# --
# Kernel/Modules/Znuny4OTRSCISearch.pm - PreApplication
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
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

    # check needed objects
    NEEDED:
    for my $Needed (qw(ParamObject DBObject LogObject ConfigObject SessionObject)) {

        next NEEDED if $Self->{$Needed};

        $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
    }

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $JSONObject           = $Kernel::OM->Get('Kernel::System::JSON');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ConfigItemObject     = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

    # get config, just for the search
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMConfigItem::Frontend::AgentITSMConfigItemSearch");
    my $CISearchConfig = $Self->{ConfigObject}->Get("Znuny4OTRSCISearch::SearchParams") || '';

    my $CISearchLabel        = $Kernel::OM->Get('Kernel::Language')->Translate('CI Search') || 'CI Search';
    my $CISearchPrefix       = $CISearchConfig->{Pre}                                       || '';
    my $CISearchSuffix       = $CISearchConfig->{Suffix}                                    || '';
    my $CISearchDefaultClass = $CISearchConfig->{DefaultClassName}                          || '';

    # get all classes (code from AgentITSMConfigItemSearch.pm L.64-79)
    my $ClassList = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::ConfigItem::Class',
    );

    return if !$ClassList;

    # check for access rights on the classes
    for my $ClassID ( sort keys %{$ClassList} ) {
        my $HasAccess = $ConfigItemObject->Permission(
            Type    => $Self->{Config}->{Permission},
            Scope   => 'Class',
            ClassID => $ClassID,
            UserID  => $Self->{UserID},
        );

        delete $ClassList->{$ClassID} if !$HasAccess;
    }

    # Check Class Count

    my $ClassCount = keys %{$ClassList};
    return if $ClassList <= 0;

    my $JSONString = $JSONObject->Encode(
        Data => $ClassList,
    );

    $LayoutObject->AddJSOnDocumentComplete(
        Code => <<ZNUNY,
        //set defaults

        Core.Config.Set('CISearch.Label', '$CISearchLabel'  );
        Core.Config.Set('CISearch.Prefix', '$CISearchPrefix'  );
        Core.Config.Set('CISearch.Suffix', '$CISearchSuffix' );
        Core.Config.Set('CISearch.DefaultClassName', '$CISearchDefaultClass' );
        var CIClasses = $JSONString;
        Core.Agent.Znuny4OTRSCISearch.Init(CIClasses);

ZNUNY
    );
    return;
}

1;
