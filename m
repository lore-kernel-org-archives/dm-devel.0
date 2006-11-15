From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] [libmultipath] Update hardware
	table	forHPHSV200
Date: Wed, 15 Nov 2006 13:49:45 +0100
Message-ID: <455B0CE9.8040103@suse.de>
References: <0E766B4D32E1BC4A877197B95A04A25A9F4FBF@tayexc14.americas.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050805040802030105010200"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0E766B4D32E1BC4A877197B95A04A25A9F4FBF@tayexc14.americas.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steve Reilly <steve.reilly@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050805040802030105010200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Reilly, Stephen (MRO) wrote:
[ Quoting appears to be a lost art ... ]
>=20
> Hannes Reinecke wrote:
 >> Reilly, Stephen (MRO) wrote:
>>> The product name does change if the firmware uses 'START_STOP_UNIT' o=
r
>>> ALUA... so why are we adding the revision?
>>
>> Ah, that's news to me.
>> How does the product name change?
 >
> The firmware will change the name
 >
Oh, that's nice.

>> My contacts at HP Boeblingen said that the revision number indicated t=
he=20
>> behaviour.
>> What are the names of the fw using START_STOP_UNIT?
> HSV100 and HSV110 EVA3000/5000
EVA is the name of the machine; HSV is the SCSI model name, right?

>> And what are those for using ALUA?
> HSV101, HSV111, HSV200 and HSV210 EVA 3000/5000  EVA4000/6000/8000
>=20
What about the old MSA ones? Is there a firmware upgrade available?
If so, will the name change there, too?

>> And irrespective of this I think matching by revision is still a valid=
=20
>> addition to the hardware table mechanism.
> However I would not use it determine the START_STOP_UNIT or ALUA implem=
entation
>=20
I was under the impression that the name would stay the same. If that's=20
not the case then of course we should match onto the name.

Please check the attached patch if it updates the hwtables correctly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050805040802030105010200
Content-Type: text/plain;
 name="hp-hwtable-update"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hp-hwtable-update"

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ac126c0..2fd6fac 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -75,21 +75,6 @@ static struct hwentry default_hw[] = {
 		.checker_name  = HP_SW,
 	},
 	{
-		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.*",
-		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 hp_sw",
-		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
-		.checker_name  = HP_SW,
-	},
-	{
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
@@ -105,13 +90,13 @@ static struct hwentry default_hw[] = {
 		.checker_name  = READSECTOR0,
 	},
 	{
-		.vendor        = "HP",
-		.product       = "HSV20.*",
-		.revision      = "[123].*",
+		/* EVA 3000/5000 with old firmware */
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "(MSA|HSV)1.0.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -121,15 +106,15 @@ static struct hwentry default_hw[] = {
 		.checker_name  = HP_SW,
 	},
 	{
-		.vendor        = "HP",
-		.product       = "HSV20.*",
-		.revision      = "[^123].*",
+		/* EVA 3000/5000 with new firmware */
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "(MSA|HSV)1.1.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
@@ -137,15 +122,16 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	{
+		/* EVA 4000/6000/8000 */
 		.vendor        = "HP",
-		.product       = "HSV21.*",
+		.product       = "HSV2.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
@@ -249,7 +235,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = TUR,
 	},
 	{
 		.vendor        = "HITACHI",

--------------050805040802030105010200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050805040802030105010200--
