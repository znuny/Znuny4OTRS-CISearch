# --
# Copyright (C) 2012-2022 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ZnunyCISearch;    ## no critic

use strict;
use warnings;

use utf8;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::ZnunyHelper',
);

use Kernel::System::VariableCheck qw(:all);

=head1 NAME

var::packagesetup::ZnunyCISearch - code to execute during package installation

=head1 SYNOPSIS

All code to execute during package installation

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $CodeObject    = $Kernel::OM->Get('var::packagesetup::ZnunyCISearch');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    $ZnunyHelperObject->_RebuildConfig();

    return $Self;
}

=head2 CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    return if !$Self->_MigrateSysConfigSettings(%Param);

    return 1;
}

=head2 CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return if !$Self->CodeInstall();

    return 1;
}

=head2 CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return if !$Self->CodeInstall();

    return 1;
}

=head2 CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 _MigrateSysConfigSettings()

Migrates SysConfig settings to 6.3.

    $CodeObject->_MigrateSysConfigSettings();

=cut

sub _MigrateSysConfigSettings {
    my ( $Self, %Param ) = @_;

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');

    my $UserID = 1;

    my %RenamedSysConfigOptions = (
        'Znuny4OTRSCISearch::SearchParams###Prefix' => [
            'ZnunyCISearch::SearchParams###Prefix',
        ],
        'Znuny4OTRSCISearch::SearchParams###Suffix' => [
            'ZnunyCISearch::SearchParams###Suffix',
        ],
        'Znuny4OTRSCISearch::SearchParams###FallbackDefaultClassName' => [
            'ZnunyCISearch::SearchParams###FallbackDefaultClassName',
        ],
        'Znuny4OTRSCISearch::SearchParams###DefaultClassName' => [
            'ZnunyCISearch::SearchParams###DefaultClassName',
        ],
    );

    ORIGINALSYSCONFIGOPTIONNAME:
    for my $OriginalSysConfigOptionName ( sort keys %RenamedSysConfigOptions ) {

        # Fetch original SysConfig option value.
        my ( $OriginalSysConfigOptionBaseName, @OriginalSysConfigOptionHashKeys ) = split '###',
            $OriginalSysConfigOptionName;

        my $OriginalSysConfigOptionValue = $ConfigObject->Get($OriginalSysConfigOptionBaseName);
        next ORIGINALSYSCONFIGOPTIONNAME if !defined $OriginalSysConfigOptionValue;

        if (@OriginalSysConfigOptionHashKeys) {
            for my $OriginalSysConfigOptionHashKey (@OriginalSysConfigOptionHashKeys) {
                next ORIGINALSYSCONFIGOPTIONNAME if ref $OriginalSysConfigOptionValue ne 'HASH';
                next ORIGINALSYSCONFIGOPTIONNAME
                    if !exists $OriginalSysConfigOptionValue->{$OriginalSysConfigOptionHashKey};

                $OriginalSysConfigOptionValue = $OriginalSysConfigOptionValue->{$OriginalSysConfigOptionHashKey};
            }
        }
        next ORIGINALSYSCONFIGOPTIONNAME if !defined $OriginalSysConfigOptionValue;

        my $NewSysConfigOptionNames = $RenamedSysConfigOptions{$OriginalSysConfigOptionName};
        for my $NewSysConfigOptionName ( @{$NewSysConfigOptionNames} ) {
            my $SettingUpdated = $SysConfigObject->SettingsSet(
                Settings => [
                    {
                        Name           => $NewSysConfigOptionName,
                        IsValid        => 1,
                        EffectiveValue => $OriginalSysConfigOptionValue,
                    },
                ],
                UserID => $UserID,
            );

            next ORIGINALSYSCONFIGOPTIONNAME if $SettingUpdated;

            $LogObject->Log(
                Priority => 'error',
                Message =>
                    "Error: Unable to migrate value of SysConfig option $OriginalSysConfigOptionName to option $NewSysConfigOptionName",
            );
        }
    }

    $ZnunyHelperObject->_RebuildConfig();

    return 1;
}

1;
