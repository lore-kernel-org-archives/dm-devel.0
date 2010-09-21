From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 21 Sep 2010 18:06:05 -0000
Message-ID: <20100921180605.19410.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-09-21 18:06:05

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #573495. New default config for EUROLOGC/FC2502 storage.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.26&r2=1.5.4.27
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.32&r2=1.20.2.33

--- multipath-tools/multipath.conf.defaults	2010/09/14 19:42:37	1.5.4.26
+++ multipath-tools/multipath.conf.defaults	2010/09/21 18:06:04	1.5.4.27
@@ -670,4 +670,15 @@
 #		rr_min_io		1000
 #		path_checker		directio
 #	}
+#	device {
+#		vendor			"EUROLOGC"
+#		product			"FC2502"
+#		getuid_callout		"/sbin/scsi_id -p 0x80 -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
+#	}
 #}
--- multipath-tools/libmultipath/hwtable.c	2010/09/14 19:42:37	1.20.2.32
+++ multipath-tools/libmultipath/hwtable.c	2010/09/21 18:06:05	1.20.2.33
@@ -983,6 +983,27 @@
 		.checker_name  = DIRECTIO,
 	},
 	/*
+	 * EUROLOGC devices
+	 *
+	 * Maintainer : Benjamin Marzinski
+	 * Mail : bmarzins@redhat.com
+	 */
+	{
+		.vendor        = "EUROLOGC",
+		.product       = "FC2502",
+		.getuid        = "/sbin/scsi_id -p 0x80 -g -u -s /block/%n",
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = DEFAULT_CHECKER,
+	},
+	/*
 	 * EOL
 	 */
 	{
