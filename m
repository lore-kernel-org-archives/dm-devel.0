From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: HP array multipath defaults.
Date: Thu, 21 Dec 2006 16:34:19 -0600
Message-ID: <20061221223419.GB14860@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stephen Reilly <steve.reilly@hp.com>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In Redhat bz #215509, you asked for changes to the default configurations for
some of the HP Arrays for RHEL4. Currently in the upstream Multipath code, the
defaults for the HP Arrays are:

{
                .vendor        = "(COMPAQ|HP)",
                .product       = "(MSA|HSV)1.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = "1 hp_sw",
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = HP_SW,
        },
        {
                .vendor        = "HP",
                .product       = "A6189A",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = READSECTOR0,
        },
        {
                .vendor        = "HP",
                .product       = "HSV20.*",
                .revision      = "[123].*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = HP_SW,
        },
        {
                .vendor        = "HP",
                .product       = "HSV20.*",
                .revision      = "[^123].*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = "mpath_prio_alua /dev/%n",
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = TUR,
        },
        {
                .vendor        = "HP",
                .product       = "HSV21.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = "mpath_prio_alua /dev/%n",
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = TUR,
        },
        {
                .vendor        = "(HITACHI|HP)",
                .product       = "OPEN-.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = READSECTOR0,
        },

These values are different than those you specified in the bugzilla. I assume
that you want the configuration values from that bugzilla to also be used in
future releases, where appropriate. However, I still have some quesions. Here is
a possible set of configuration values, that includes the changes listed in the bugzilla.

        {
                .vendor        = "(COMPAQ|HP)",
                .product       = "MSA1.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = "1 hp_sw",
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = HP_SW,
        },
        {
                .vendor        = "(COMPAQ|HP)",
                .product       = "HSV1.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = 60,
                .minio         = 100,
                .checker_name  = TUR,
        },
        {
                .vendor        = "HP",
                .product       = "A6189A",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = READSECTOR0,
        },
        {
                .vendor        = "HP",
                .product       = "HSV20.*",
                .revision      = "[123].*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = 60,
                .minio         = 100,
                .checker_name  = HP_SW,
        },
        {
                .vendor        = "HP",
                .product       = "HSV20.*",
                .revision      = "[^123].*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = 60,
                .minio         = 100,
                .checker_name  = TUR,
        },
        {
                .vendor        = "HP",
                .product       = "HSV21.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = 60,
                .minio         = 100,
                .checker_name  = TUR,
        },
        {
                .vendor        = "(HITACHI|HP)",
                .product       = "OPEN-.*",
                .getuid        = DEFAULT_GETUID,
                .getprio       = NULL,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = MULTIBUS,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = 100,
                .checker_name  = TUR,
        },


Is the MSA configuration correct?
Should the MSA and A6189A devices also have a no_path_retry of 60, and a minio
of 100?
Are their certain revisions for the HSV devices that should still use the old
configuration, like certain revisions of the HSV20.* devices do?

Attached is a patch to replace the existing set of HP device configurations
with the ones I proposed above.

-Ben

Benjamin E. Marzinski
bmarzins@redhat.com
(612) 638-0517

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mpath_hp.patch"

--- hwtable.c	2006-11-27 17:16:41.000000000 -0600
+++ hwtable-patched.c	2006-12-21 14:28:21.000000000 -0600
@@ -76,7 +76,7 @@
 	},
 	{
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.*",
+		.product       = "MSA1.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -90,6 +90,21 @@
 		.checker_name  = HP_SW,
 	},
 	{
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "HSV1.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 60,
+		.minio         = 100,
+		.checker_name  = TUR,
+	},
+	{
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
@@ -116,8 +131,8 @@
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
+		.no_path_retry = 60,
+		.minio         = 100,
 		.checker_name  = HP_SW,
 	},
 	{
@@ -129,11 +144,11 @@
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
+		.no_path_retry = 60,
+		.minio         = 100,
 		.checker_name  = TUR,
 	},
 	{
@@ -145,10 +160,10 @@
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
+		.no_path_retry = 60,
+		.minio         = 100,
 		.checker_name  = TUR,
 	},
 	/*
@@ -245,11 +260,11 @@
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.minio         = 100,
+		.checker_name  = TUR,
 	},
 	{
 		.vendor        = "HITACHI",

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--0F1p//8PRICkK4MW--
