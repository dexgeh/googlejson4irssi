 
use strict;

use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';

use LWP::UserAgent;
use JSON;
use Data::Dumper;

%IRSSI = (
    authors     => 'dexgeh',
    contact     => 'dexgeh@gmail.com',
    name        => 'gData Google search',
    description => 'This script allow ow you to search through google using its API',
    license     => 'Public Domain',
);

my $lastSearch;

sub cmd_google {
    my ($data, $server, $witem) = @_;
    $data =~ s/\s/+/g;
    my $query = "http://ajax.googleapis.com/ajax/services/search/web?q=" . $data . "&v=1.0";
    #Irssi::active_win()->print($query);
    my $ua = LWP::UserAgent->new();
    $ua->default_header("HTTP_REFERER" => "Irssi");
    my $body = $ua->get($query);
    my $json = from_json($body->decoded_content);
    my $i = 0;
    $lastSearch = $json->{responseData}->{results};

    foreach my $result (@{$json->{responseData}->{results}}){
        $i++;
        Irssi::active_win()->print($i.". " . $result->{titleNoFormatting} . "(" . $result->{url} . ")");
    }
    if(!$i){
        Irssi::active_win()->print("Sorry, but there were no results.");
    }
}

sub say_google_result {
    my ($data, $server, $witem) = @_;
    my $idx = int($data);
    #Irssi::active_win()->print($idx);
    my $i = 0;
    foreach my $result (@{$lastSearch}) {
        $i++;
        if ($i == $idx) {
            $witem->command("/SAY " . $result->{titleNoFormatting} . "(" . $result->{url} . ")");
        }
    }
}

Irssi::command_bind('gsearch', 'cmd_google');
Irssi::command_bind('gsay','say_google_result');