# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::Znuny4OTRSCISearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = \%Param;
    bless( $Self, $Type );

    return $Self;
}

sub PreRun {
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
    my $CISearchConfig = $ConfigObject->Get("Znuny4OTRSCISearch::SearchParams") || '';

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

        if ( !$HasAccess ) {
            delete $ClassList->{$ClassID};
            next CLASSID;
        }

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
        Core.Agent.Znuny4OTRSCISearch.Init({
        Label:        '$CISearchLabel',
        Prefix:       '$CISearchPrefix',
        Suffix:       '$CISearchSuffix',
        CIClasses:    $CIClassesJSON,
        DefaultClass: '$DefaultClass'
    });
JS_BLOCK

    $LayoutObject->AddJSOnDocumentCompleteIfNotExists(
        Key  => 'Znuny4OTRSCISearch',
        Code => $JSBlock,
    );

    return;
}

1;
