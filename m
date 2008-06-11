From: Stefan Haberland <sth@linux.vnet.ibm.com>
Subject: [PATCH] multipath-tools: add FBA DASD
Date: Wed, 11 Jun 2008 14:08:24 +0200
Message-ID: <484FC038.2040705@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030902050701030107010903"
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
To: dm-devel@redhat.com
Cc: cristophe.varoqui@free.fr
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030902050701030107010903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


S/390 FBA DASDs are not blacklisted because they are not detected 
correctly.
Added S/390 FBA DASDs to hwtable.c to solve this problem

Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>

---
libmultipath/hwtable.c |   17 +++++++++++++++++
1 file changed, 17 insertions(+)

Index: multipath-tools/libmultipath/hwtable.c
===================================================================
--- multipath-tools.orig/libmultipath/hwtable.c
+++ multipath-tools/libmultipath/hwtable.c
@@ -497,6 +497,23 @@ static struct hwentry default_hw[] = {
               .checker_name  = DIRECTIO,
               .prio_name     = DEFAULT_PRIO,
       },
+       {
+               /* IBM S/390 FBA DASD */
+               .vendor        = "IBM",
+               .product       = "S/390 DASD FBA",
+               .bl_product       = "S/390.*",
+               .getuid        = "/sbin/dasdinfo -u -b %n",
+               .features      = "1 queue_if_no_path",
+               .hwhandler     = DEFAULT_HWHANDLER,
+               .selector      = DEFAULT_SELECTOR,
+               .pgpolicy      = MULTIBUS,
+               .pgfailback    = FAILBACK_UNDEF,
+               .rr_weight     = RR_WEIGHT_NONE,
+               .no_path_retry = NO_PATH_RETRY_UNDEF,
+               .minio         = DEFAULT_MINIO,
+               .checker_name  = DIRECTIO,
+               .prio_name     = DEFAULT_PRIO,
+       },
       /*
        * NETAPP controller family
        *

--------------030902050701030107010903
Content-Type: text/x-patch;
 name="hwtable_add_fbadasd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hwtable_add_fbadasd.patch"

S/390 FBA DASDs are not blacklisted because they are not detected correctly.
Added S/390 FBA DASDs to hwtable.c to solve this problem

Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>

---
 libmultipath/hwtable.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: multipath-tools/libmultipath/hwtable.c
===================================================================
--- multipath-tools.orig/libmultipath/hwtable.c
+++ multipath-tools/libmultipath/hwtable.c
@@ -497,6 +497,23 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.prio_name     = DEFAULT_PRIO,
 	},
+	{
+		/* IBM S/390 FBA DASD */
+		.vendor        = "IBM",
+		.product       = "S/390 DASD FBA",
+		.bl_product       = "S/390.*",
+		.getuid        = "/sbin/dasdinfo -u -b %n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
+	},
 	/*
 	 * NETAPP controller family
 	 *

--------------030902050701030107010903
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030902050701030107010903--
