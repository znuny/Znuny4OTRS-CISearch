# --
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
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

    $Self->{Translation}->{'This configuration defines a mapping of role to class name that is used for the CI search'} = 'Diese Konfiguration definiert eine Rollen-Klassen Zuordnung, die für die CI Suche verwendent werden soll.';
    $Self->{Translation}->{'This configuration defines a prefix that will be used for the CI search.'} = 'Diese Konfiguration definiert ein Prefix, das für die CI Suche verwendent werden soll.';
    $Self->{Translation}->{'This configuration defines a suffix that will be used for the CI search.'} = 'Diese Konfiguration definiert ein Suffix, das für die CI Suche verwendent werden soll.';
    $Self->{Translation}->{'This configuration defines a PreApplication module to enable Znuny4OTRS-CISearch in all views.'} = 'Diese Konfiguration definiert ein PreApplication Modul, das die CI Suche in allen Ansichten aktiviert.';
    $Self->{Translation}->{'List of all JS files which are loaded to provide the CI search for the agent interface.'} = 'Liste aller JS Dateien die geladen werden um die CI Suche zu ermöglichen.';
    $Self->{Translation}->{'CI Search'} = 'CI Suche';
    $Self->{Translation}->{'This configuration defines a global default class that will be used for the CI search if no other class can not get determined.'} = 'Diese Konfiguration definiert eine globale Standard-Klasse, welche für die CI-Suche genutzt wird, wenn kein andere Klasse bestimmt werden konnte.';
    $Self->{Translation}->{'This configuration defines a mapping of role to class name that is used as default class for the CI search.'} = 'Diese Konfiguration definiert ein Mapping zwischen Rollen zu Klassen-Namen welche für die CI-Suche als Standard-Klasse genutzt wird.';
    $Self->{Translation}->{'CISearch Default ClassName'} = 'CI Suche Standard-Klasse';
    $Self->{Translation}->{'Default ClassName'} = 'Standard-Klasse';

    return 1;
}

1;
