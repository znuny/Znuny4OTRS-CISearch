# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::Znuny4OTRSCISearch;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject          = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $ClassList = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::ConfigItem::Class',
    );

    my %ReverseClasslist = reverse %{$ClassList};
    for my $Class ( sort keys %ReverseClasslist ) {
        $ReverseClasslist{$Class} = $Class;
    }

    my @Params;
    my $SelectedID = $ParamObject->GetParam( Param => 'CISearchDefaultClassName' );
    $SelectedID ||= $Param{UserData}->{CISearchDefaultClassName};
    $SelectedID ||= $LayoutObject->{CISearchDefaultClassName};

    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Data       => \%ReverseClasslist,
            HTMLQuote  => 0,
            SelectedID => $SelectedID,
            Block      => 'Option',
            Max        => 100,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Preferences = @{ $Param{GetParam}->{$Key} };
        PREFERENCES:
        for my $Preference (@Preferences) {

            # pref update db
            if ( !$ConfigObject->Get('DemoSystem') ) {
                $UserObject->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $Preference,
                );
            }

            # update SessionID
            next PREFERENCES if $Param{UserData}->{UserID} ne $Self->{UserID};

            $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => $Key,
                Value     => $Preference,
            );
        }
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
