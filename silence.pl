use Net::OpenSoundControl::Client;
use strict;
my $oschost = "127.0.0.1";
my $oscport = 3666;
{
  my $client = undef;
  sub client {
    if (!$client) {
      $client = Net::OpenSoundControl::Client->new(Host => $oschost, Port => $oscport ) or die "Could not start client: $@\n";

    }
    return $client;
  }
}

client()->send(['/grain/gkPhase','f',0]);
client()->send(['/grain/gkPhaseMix','f',0]);
client()->send(['/grain/gkDur','f',0]);
client()->send(['/grain/gkFreq','f',0]);
client()->send(['/grain/gkFreqRand','f',0]);


#push @elms,['/'.$command, @args];
