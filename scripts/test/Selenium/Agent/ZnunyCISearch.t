# --
# Copyright (C) 2012-2022 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

my $SeleniumObject = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my $SeleniumTest = sub {

    # initialize Znuny Helpers and other needed objects
    my $HelperObject                 = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
    my $ZnunyHelperObject            = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $UserObject                   = $Kernel::OM->Get('Kernel::System::User');
    my $UnitTestITSMConfigItemObject = $Kernel::OM->Get('Kernel::System::UnitTest::ITSMConfigItem');

    my $CIName = 'Znuny Rack 42';
    $UnitTestITSMConfigItemObject->ConfigItemCreate(
        Name          => $CIName,
        ClassName     => 'Hardware',
        DeplStateName => 'Production',
        InciStateName => 'Operational',
        XMLData       => {},
    );

    # create test user and login
    my %TestUser = $SeleniumObject->AgentLogin(
        Groups => [ 'admin', 'itsm-configitem', 'users' ],
    );

    my $PreferenceKey   = 'CISearchDefaultClassName';
    my $PreferenceValue = 'Software';
    $UserObject->SetPreferences(
        UserID => $TestUser{UserID},
        Key    => $PreferenceKey,
        Value  => $PreferenceValue,
    );

    for my $Displayed (qw(SearchName ClassID)) {
        my $IsDisplayed = $SeleniumObject->find_element( "#$Displayed", 'css' )->is_displayed();
        $Self->True( $IsDisplayed, "$Displayed is displayed" );
    }

    $SeleniumObject->AgentInterface(
        Action      => 'AgentPreferences',
        Subaction   => 'Group',
        Group       => 'Miscellaneous',
        WaitForAJAX => 0,
    );

    my $IsDisplayed = $SeleniumObject->find_element( "#${PreferenceKey}_Search", 'css' )->is_displayed();
    $Self->True( $IsDisplayed, "${PreferenceKey}_Search is displayed" );

    my $StoredPreferenceValue = $SeleniumObject->InputGet(
        Attribute => $PreferenceKey,
        Options   => {
            KeyOrValue => 'Value',
        },
    );

    $Self->Is(
        $StoredPreferenceValue,
        $PreferenceValue,
        "PreferenceValue $PreferenceValue reflected",
    );

    my $ShownPreferenceValue = $SeleniumObject->InputGet(
        Attribute => 'ClassID',
        Options   => {
            KeyOrValue => 'Value',
        },
    );

    $Self->Is(
        $ShownPreferenceValue,
        $PreferenceValue,
        "PreferenceValue $PreferenceValue selected",
    );

    $SeleniumObject->InputSet(
        Attribute   => 'SearchName',
        Content     => 'Znuny',
        WaitForAJAX => 0,
    );

    $SeleniumObject->find_element( '#CISearch', 'css' )->submit();

    $SeleniumObject->WaitFor(
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    ) || die "OTRS API verification failed after page load.";

    $SeleniumObject->PageContainsNot(
        String => $CIName,
    );

    $SeleniumObject->InputSet(
        Attribute   => 'ClassID',
        Content     => 'Hardware',
        WaitForAJAX => 0,
        Options     => {
            KeyOrValue => 'Value',
        },
    );

    $SeleniumObject->InputSet(
        Attribute   => 'SearchName',
        Content     => 'Znuny',
        WaitForAJAX => 0,
    );

    $SeleniumObject->find_element( '#CISearch', 'css' )->submit();

    $SeleniumObject->WaitFor(
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    ) || die "OTRS API verification failed after page load.";

    $SeleniumObject->PageContains(
        String => $CIName,
    );
};

$SeleniumObject->RunTest($SeleniumTest);

1;
