use 5.010;
use Discord;

my $discord = Discord->new(
    client_id => '259521088327909380',
    client_secret => 'Z9FFr8u4gBwxnFw-RDjeqSAngAq2CglT',
    token => 'MjU5NTIxMDg4MzI3OTA5Mzgw.C1j_4w.u63P40UIx90TguO3935mVSya13Y',
    bot => 1,
);

say $discord->gateway_url();
say $discord->shards;
