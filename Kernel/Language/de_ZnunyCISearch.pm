# --
# Copyright (C) 2012-2022 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ZnunyCISearch;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'This configuration defines a mapping of role to class name that is used for the CI search'} = 'Diese Konfiguration definiert eine Rollen-Klassen-Zuordnung, die für die CI-Suche verwendet werden soll.';
    $Self->{Translation}->{'This configuration defines a prefix that will be used for the CI search.'} = 'Diese Konfiguration definiert ein Präfix, das für die CI-Suche verwendet werden soll.';
    $Self->{Translation}->{'This configuration defines a suffix that will be used for the CI search.'} = 'Diese Konfiguration definiert ein Suffix, das für die CI-Suche verwendet werden soll.';
    $Self->{Translation}->{'This configuration defines a PreApplication module to enable Znuny-CISearch in all views.'} = 'Diese Konfiguration definiert ein Pre-Application-Modul, das die CI-Suche in allen Ansichten aktiviert.';
    $Self->{Translation}->{'List of all JS files which are loaded to provide the CI search for the agent interface.'} = 'Liste aller JS-Dateien, die geladen werden, um die CI-Suche zu ermöglichen.';
    $Self->{Translation}->{'CI Search'} = 'CI-Suche';
    $Self->{Translation}->{'This configuration defines a global default class that will be used for the CI search if no other class can not get determined.'} = 'Diese Konfiguration definiert eine globale Standard-Klasse, welche für die CI-Suche genutzt wird, wenn kein andere Klasse bestimmt werden konnte.';
    $Self->{Translation}->{'This configuration defines a mapping of role to class name that is used as default class for the CI search.'} = 'Diese Konfiguration definiert ein Mapping zwischen Rollen- und Klassennamen, welche für die CI-Suche als Standard-Klasse genutzt wird.';
    $Self->{Translation}->{'Defines the config parameters of this item, to be shown in the preferences view.'} = 'Definiert die Konfigurationsparameter dieses Elements, die in der Einstellungsansicht angezeigt werden sollen.';

    $Self->{Translation}->{'CI search default class name'} = 'CI-Suche-Standard-Klasse';
    $Self->{Translation}->{'Default class name'}           = 'Standard-Klasse';

    return 1;
}

1;
