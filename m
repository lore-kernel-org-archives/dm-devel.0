From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] add support for IBM 3526
Date: Fri, 01 Sep 2006 08:57:48 +0200
Message-ID: <44F7D9EC.2060400@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050609010306090501010303"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050609010306090501010303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

we've found another IBM storage server in our lab; this patch adds the=20
necessary hwtable entry for it.

However, this is an RDAC machine, so it'll work only in some cases. One=20
day we really need an RDAC hw-handler.

Please apply,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050609010306090501010303
Content-Type: text/plain;
 name="multipath-tools-ibm-3526-update"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-ibm-3526-update"

Add support for IBM 3526

Adding support for IBM Netfinity FC RAID controller.
Note that this is actually a RDAC controller, so it's supported
in AVT mode only. We don't do RDAC-style failover (yet).

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/hwtable.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

807fdf4dc06ee4be11620b11ce0be3630a598d57
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b991689..50cd4c7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -236,6 +236,22 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	{
+		/* IBM Netfinity Fibre Channel RAID Controller Unit */
+		.vendor        = "IBM",
+		.product       = "3526",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
+	{
 		/* IBM DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "3542",
-- 
1.1.3

--------------050609010306090501010303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050609010306090501010303--
