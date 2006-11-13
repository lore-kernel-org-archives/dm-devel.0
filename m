From: "Reilly, Stephen (MRO)" <Steve.Reilly@hp.com>
Subject: RE: [PATCH 4/4] [libmultipath] Update hardware table for
	HPHSV200
Date: Mon, 13 Nov 2006 14:44:58 -0500
Message-ID: <0E766B4D32E1BC4A877197B95A04A25A9B31A6@tayexc14.americas.cpqcorp.net>
References: <20061109221555.ED66173C93@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20061109221555.ED66173C93@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The product name does change if the firmware uses 'START_STOP_UNIT' or
ALUA... so why are we adding the revision?

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Hannes Reinecke
Sent: Thursday, November 09, 2006 5:10 AM
Subject: [dm-devel] [PATCH 4/4] [libmultipath] Update hardware table for
HPHSV200

According to HP the behaviour of the HSV200 depends on the software
release; all revisions smaller or equal to '3000' have active/passive
support; all revisions above that have active/active support.
Translated it means that the older firmware uses the HP-style
'START_STOP_UNIT' command to switch paths, while the newer firmware
supports ALUA.
So we should update the hardware tables accordingly.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/hwtable.c |   49
+++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

19c1285b869bfe42b3605c2fee73bb4b416c4c40
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b56c231..8c8699d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -91,7 +91,7 @@ static struct hwentry default_hw[] =3D {
 	},
 	{
 		.vendor        =3D "HP",
-		.product       =3D "(HSV2.*|A6189A)",
+		.product       =3D "A6189A",
 		.getuid        =3D DEFAULT_GETUID,
 		.getprio       =3D NULL,
 		.features      =3D DEFAULT_FEATURES,
@@ -104,6 +104,53 @@ static struct hwentry default_hw[] =3D {
 		.minio         =3D DEFAULT_MINIO,
 		.checker_name  =3D READSECTOR0,
 	},
+	{
+		.vendor        =3D "HP",
+		.product       =3D "HSV20.*",
+		.revision      =3D "[123].*",
+		.getuid        =3D DEFAULT_GETUID,
+		.getprio       =3D NULL,
+		.features      =3D DEFAULT_FEATURES,
+		.hwhandler     =3D DEFAULT_HWHANDLER,
+		.selector      =3D DEFAULT_SELECTOR,
+		.pgpolicy      =3D MULTIBUS,
+		.pgfailback    =3D FAILBACK_UNDEF,
+		.rr_weight     =3D RR_WEIGHT_NONE,
+		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
+		.minio         =3D DEFAULT_MINIO,
+		.checker_name  =3D HP_SW,
+	},
+	{
+		.vendor        =3D "HP",
+		.product       =3D "HSV20.*",
+		.revision      =3D "[^123].*",
+		.getuid        =3D DEFAULT_GETUID,
+		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
+		.features      =3D DEFAULT_FEATURES,
+		.hwhandler     =3D DEFAULT_HWHANDLER,
+		.selector      =3D DEFAULT_SELECTOR,
+		.pgpolicy      =3D MULTIBUS,
+		.pgfailback    =3D -FAILBACK_IMMEDIATE,
+		.rr_weight     =3D RR_WEIGHT_PRIORITIES,
+		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
+		.minio         =3D DEFAULT_MINIO,
+		.checker_name  =3D TUR,
+	},
+	{
+		.vendor        =3D "HP",
+		.product       =3D "HSV21.*",
+		.getuid        =3D DEFAULT_GETUID,
+		.getprio       =3D "/sbin/mpath_prio_alua /dev/%n",
+		.features      =3D DEFAULT_FEATURES,
+		.hwhandler     =3D DEFAULT_HWHANDLER,
+		.selector      =3D DEFAULT_SELECTOR,
+		.pgpolicy      =3D GROUP_BY_PRIO,
+		.pgfailback    =3D FAILBACK_UNDEF,
+		.rr_weight     =3D RR_WEIGHT_NONE,
+		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
+		.minio         =3D DEFAULT_MINIO,
+		.checker_name  =3D TUR,
+	},
 	/*
 	 * DDN controller family
 	 *
--=20
1.3.1


--------------040805080108070409060801--

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
