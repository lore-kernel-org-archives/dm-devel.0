From: Guido Guenther <agx@sigxcpu.org>
Subject: [multipath 1/3] Call /lib/udev/scsi_id instead of
	/sbin/scsi_id
Date: Sat, 16 Jun 2007 20:07:14 +0200
Message-ID: <11820172361537-git-send-email-agx@sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 8deeb0f..df7d971 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,4 +1,4 @@
-#define DEFAULT_GETUID		"/sbin/scsi_id -g -u -s /block/%n"
+#define DEFAULT_GETUID		"/lib/udev/scsi_id -g -u -s /block/%n"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_SELECTOR	"round-robin 0"
 #define DEFAULT_FEATURES	"0"
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2a5f2d5..c7bcf3d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -183,7 +183,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.getuid        = "/sbin/scsi_id -g -u -ppre-spc3-83 -s /block/%n",
+		.getuid        = "/lib/udev/scsi_id -g -u -ppre-spc3-83 -s /block/%n",
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 649ff8c..edb6628 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -11,7 +11,7 @@
 #	#
 #	# name    : udev_dir
 #	# desc    : directory where udev creates its device nodes
-#	# default : /udev
+#	# default : /dev
 #	#
 #	udev_dir	/dev
 #
@@ -47,9 +47,9 @@
 #	# scope   : multipath
 #	# desc    : the default program and args to callout to obtain a unique 
 #	#           path identifier. Absolute path required
-#	# default : /sbin/scsi_id -g -u -s
+#	# default : /lib/udev/scsi_id -g -u -s
 #	#
-#	getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
+#	getuid_callout	"/lib/udev/scsi_id -g -u -s /block/%n"
 #
 #	#
 #	# name    : prio_callout
@@ -291,9 +291,9 @@
 #		# scope   : multipath
 #		# desc    : the program and args to callout to obtain a unique 
 #		#           path identifier. Absolute path required
-#		# default : /sbin/scsi_id -g -u -s
+#		# default : /lib/udev/scsi_id -g -u -s
 #		#
-#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
 #
 #		#
 #		# name    : prio_callout
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index e5e6cd0..1250c63 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -7,7 +7,7 @@
 #	polling_interval 	10
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
-#	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#	getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
 #	prio_callout		/bin/true
 #	path_checker		readsector0
 #	rr_min_io		100
@@ -52,7 +52,7 @@
 #		vendor			"COMPAQ  "
 #		product			"HSV110 (C)COMPAQ"
 #		path_grouping_policy	multibus
-#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
 #		path_checker		readsector0
 #		path_selector		"round-robin 0"
 #		hardware_handler	"0"
diff --git a/multipath/02_multipath b/multipath/02_multipath
index 1a5d5a1..067c582 100755
--- a/multipath/02_multipath
+++ b/multipath/02_multipath
@@ -12,10 +12,10 @@ cp /sbin/kpartx $INITRDDIR/sbin
 # feed the dependencies too
 # scsi_id is dynamicaly linked, so store the libs too
 #
-cp /sbin/scsi_id $INITRDDIR/sbin
+cp /lib/udev/scsi_id $INITRDDIR/lib/udev/
 cp /bin/mountpoint $INITRDDIR/bin
 
-PROGS="/sbin/scsi_id /bin/mountpoint"
+PROGS="/lib/udev/scsi_id /bin/mountpoint"
 LIBS=`ldd $PROGS | grep -v linux-gate.so | sort -u | \
 awk '{print $3}'` 
 for i in $LIBS
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 1c1c0db..905cb65 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -109,7 +109,7 @@ Default value is \fImultibus\fR.
 The default program and args to callout to obtain a unique path
 identifier. Should be specified with an absolute path. Default value
 is
-.I /sbin/scsi_id -g -u -s
+.I /lib/udev/scsi_id -g -u -s
 .TP
 .B prio_callout
 The default program and args to callout to obtain a path priority
diff --git a/path_priority/pp_hds_modular/pp_hds_modular.c b/path_priority/pp_hds_modular/pp_hds_modular.c
index f38ebcf..e93ea8d 100644
--- a/path_priority/pp_hds_modular/pp_hds_modular.c
+++ b/path_priority/pp_hds_modular/pp_hds_modular.c
@@ -56,7 +56,7 @@
  *                path_grouping_policy    group_by_prio
  *                prio_callout            "/sbin/pp_hds_modular %d"
  *                path_checker            readsector0
- *                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+ *                getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
  *                failback                immediate
  *        }
  *        device {
-- 
1.5.2.1
