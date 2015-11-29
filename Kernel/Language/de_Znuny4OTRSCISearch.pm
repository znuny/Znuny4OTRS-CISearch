# --
# Kernel/Language/de_Znuny4OTRSCISearch.pm - the german translation of the texts of Znuny4OTRSCISearch
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Znuny4OTRSCISearch;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Do you want to set a default class for you search?'} = 'Welche Standard CI-Klasse soll ausgewählt sein?';
    $Self->{Translation}->{'Do you want to use a suffix for you search?'} = 'Welcher Suffix soll für die Suche verwendet werden?';
    $Self->{Translation}->{'Do you want to use a prefix for you search?'} = 'Welcher prefix soll für die Suche verwendet werden?';
    $Self->{Translation}->{'Defines a module to enable Znuny4OTRS-CISearch in all views.'} = 'Definert das Modul um die CI Suche in allen Ansichten zu aktivieren.';
    $Self->{Translation}->{'List of JS files to always be loaded for the agent interface to enable the CI search functionality.'} = 'Liste aller JS Dateien die geladen werden um die CI Suche zu ermöglichen.';
    $Self->{Translation}->{'CI Search'} = 'CI Suche';
    return 1;
}

1;
