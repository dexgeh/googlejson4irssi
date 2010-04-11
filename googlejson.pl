
#credits: http://code.google.com/apis/ajaxsearch/documentation/#fonje_snippets
 
use strict;

use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';

use LWP::UserAgent;
use JSON;

%IRSSI = (
    authors     => 'dexgeh',
    contact     => 'dexgeh@gmail.com',
    name        => 'gData Google search',
    description => 'This script allow you to search through google using its Json API',
    license     => 'Public Domain',
);

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
    foreach my $result (@{$json->{responseData}->{results}}){
        $i++;
        Irssi::active_win()->print($i.". " . $result->{titleNoFormatting} . "(" . $result->{url} . ")");
    }
    if(!$i){
        Irssi::active_win()->print("Sorry, but there were no results.");
    }
}

Irssi::command_bind('gsearch', 'cmd_google');