From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/57] Use ALUA for HP 3PAR
Date: Fri, 29 Apr 2016 07:58:04 +0200
Message-ID: <5722F7EC.2030601@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-7-git-send-email-hare@suse.de>
	<20160429002524.00006f73@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160429002524.00006f73@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 04/29/2016 12:25 AM, Sebastian Herbszt wrote:
> Hannes Reinecke wrote:
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  libmultipath/hwtable.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
> =

> You missed to also change multipath.conf.defaults.
>  =

>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index 28ee595..4549268 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -65,13 +65,13 @@ static struct hwentry default_hw[] =3D {
>>  		.vendor        =3D "3PARdata",
>>  		.product       =3D "VV",
>>  		.features      =3D DEFAULT_FEATURES,
>> -		.hwhandler     =3D DEFAULT_HWHANDLER,
>> -		.pgpolicy      =3D MULTIBUS,
>> -		.pgfailback    =3D FAILBACK_UNDEF,
>> +		.hwhandler     =3D "1 alua",
>> +		.pgpolicy      =3D GROUP_BY_PRIO,
>> +		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>>  		.rr_weight     =3D RR_WEIGHT_NONE,
>> -		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
>> -		.checker_name  =3D DEFAULT_CHECKER,
>> -		.prio_name     =3D DEFAULT_PRIO,
>> +		.no_path_retry =3D 18,
>> +		.checker_name  =3D TUR,
>> +		.prio_name     =3D PRIO_ALUA,
>>  		.prio_args     =3D NULL,
>>  	},
>>  	{
> =

> Can you please elaborate on this?
> I think the correct setting depends on the configured
> "host persona". Currently the expected value would be
> "Generic / 1". The patch changes it to "Generic-ALUA / 2".
> Does the above change still work if the "host persona" is
> not modified and still set to "Generic / 1"?
> =

I have never ever _seen_ an 3Par array, so I wasn't aware that you
could switch host 'persona'. So I have to rely on our partners (ie
HPE) for correct configuration here.
But given that fact we should better switch back to use the default
hw_handler and use the 'retain_attached_hw_handler' option.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
