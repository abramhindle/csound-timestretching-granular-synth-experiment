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

client()->send(['/grain/gkPhase','f',rand()]);
client()->send(['/grain/gkAmp','f',0.125]);
client()->send(['/grain/gkPhaseMix','f',rand()]);
client()->send(['/grain/gkDur','f',0.1*rand()]);
client()->send(['/grain/gkDens','f',200*rand()]);
client()->send(['/grain/gkFreq','f',2*rand()*rand()*rand()]);
client()->send(['/grain/gkFreqRand','f',rand()*0.1*rand()]);


#push @elms,['/'.$command, @args];
