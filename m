From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/57] Add HP MSA 2040 to the hardware table
Date: Fri, 29 Apr 2016 07:55:02 +0200
Message-ID: <5722F736.1050404@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-6-git-send-email-hare@suse.de>
	<20160429000605.00006561@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160429000605.00006561@localhost>
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

On 04/29/2016 12:06 AM, Sebastian Herbszt wrote:
> Hannes Reinecke wrote:
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  libmultipath/hwtable.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
> =

> You missed adding it to multipath.conf.defaults.
> =

Yes, but we're about to phase them out anyway.
Cf the recent discussion.

>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index a4ae053..28ee595 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -175,6 +175,21 @@ static struct hwentry default_hw[] =3D {
>>  		.prio_name     =3D PRIO_ALUA,
>>  		.prio_args     =3D NULL,
>>  	},
>> +	{
>> +		/* HP MSA 1040/2040 product family */
>> +		.vendor        =3D "HP",
>> +		.product       =3D "MSA (1|2)040 SA(N|S)",
>> +		.features      =3D DEFAULT_FEATURES,
>> +		.hwhandler     =3D DEFAULT_HWHANDLER,
>> +		.pgpolicy      =3D GROUP_BY_PRIO,
>> +		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>> +		.rr_weight     =3D RR_WEIGHT_NONE,
>> +		.no_path_retry =3D 18,
>> +		.minio         =3D 100,
>> +		.checker_name  =3D TUR,
>> +		.prio_name     =3D PRIO_ALUA,
>> +		.prio_args     =3D NULL,
>> +	},
>>  =

>>  	{
>>  		/* HP SVSP */
> =

> Any reason for a separate entry and not merging it with
> "HP MSA2000 product family with new firmware" ?
> =

Yes. MSA2000 are completely different beasts, so I'd like to keep
them separate.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
