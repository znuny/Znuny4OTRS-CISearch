# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBar::Search::CI;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::Group',
    'Kernel::System::ITSMConfigItem',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject       = $Kernel::OM->Get('Kernel::Language');
    my $JSONObject           = $Kernel::OM->Get('Kernel::System::JSON');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ConfigItemObject     = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');
    my $GroupObject          = $Kernel::OM->Get('Kernel::System::Group');
    my $UserObject           = $Kernel::OM->Get('Kernel::System::User');

    # get config, just for the search
    $Self->{Config} = $ConfigObject->Get("ITSMConfigItem::Frontend::AgentITSMConfigItemSearch");
    my $CISearchConfig = $ConfigObject->Get("ZnunyCISearch::SearchParams") || '';

    my $CISearchLabel  = $LanguageObject->Translate('CI Search') || 'CI Search';
    my $CISearchPrefix = $CISearchConfig->{Prefix}               || '';
    my $CISearchSuffix = $CISearchConfig->{Suffix}               || '';
    my $CISearchDefaultClass = $LanguageObject->Translate( $CISearchConfig->{DefaultClassName} || '' );

    # get all classes
    my $ClassList = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::ConfigItem::Class',
    );

    return if !IsHashRefWithData($ClassList);

    # check for access rights on the classes
    CLASSID:
    for my $ClassID ( sort keys %{$ClassList} ) {
        my $HasAccess = $ConfigItemObject->Permission(
            Type    => $Self->{Config}->{Permission},
            Scope   => 'Class',
            ClassID => $ClassID,
            LogNo   => 1,
            UserID  => $Self->{UserID},
        );

        delete $ClassList->{$ClassID} if !$HasAccess;
        next CLASSID                  if !$HasAccess;

        $ClassList->{$ClassID} = $LanguageObject->Translate( $ClassList->{$ClassID} );
    }

    return if !IsHashRefWithData($ClassList);

    my $CIClassesJSON = $JSONObject->Encode(
        Data => $ClassList,
    );

    # set FallbackDefaultClassName if no other DefaultClass can't get determined by roles
    my $DefaultClass = $CISearchConfig->{FallbackDefaultClassName};

    if ( IsHashRefWithData( $CISearchConfig->{DefaultClassName} ) ) {

        # get role member list
        my %Roles = $GroupObject->GroupUserRoleMemberList(
            UserID => $Self->{UserID},
            Result => 'HASH',
        );

        if (%Roles) {
            %Roles = reverse %Roles;

            GROUP:
            for my $Role ( sort keys %{ $CISearchConfig->{DefaultClassName} } ) {
                next GROUP if !IsNumber( $Roles{$Role} );

                $DefaultClass = $CISearchConfig->{DefaultClassName}->{$Role};
                last GROUP;
            }
        }
    }

    # get user preference
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    # set CISearchDefaultClassName
    if ( IsStringWithData( $Preferences{CISearchDefaultClassName} ) ) {
        $DefaultClass = $Preferences{CISearchDefaultClassName};
    }

    $DefaultClass = $LanguageObject->Translate($DefaultClass);

    my $JSBlock = <<"JS_BLOCK";
        Core.Agent.ZnunyCISearch.Init({
        Label:        '$CISearchLabel',
        Prefix:       '$CISearchPrefix',
        Suffix:       '$CISearchSuffix',
        CIClasses:    $CIClassesJSON,
        DefaultClass: '$DefaultClass'
    });
JS_BLOCK

    $LayoutObject->AddJSOnDocumentCompleteIfNotExists(
        Key  => 'ZnunyCISearch',
        Code => $JSBlock,
    );

    return;
}

1;
