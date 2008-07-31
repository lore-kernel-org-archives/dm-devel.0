From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH] udev as of 0.124 doesn't support -s anymore
Date: Thu, 31 Jul 2008 06:17:50 -0400
Message-ID: <20080731101750.GA744@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,
sysfs as of 0.124 doesn't support -s anymore and the whole sysfs code
got removed, we'll have to use the devnodes in /dev/ from now on.  I
also changed the last remaining call from /sbin/scsi_id to
/lib/udev/scsi_id.
Cheers,
 -- Guido

---
 libmultipath/defaults.h    |    2 +-
 libmultipath/hwtable.c     |    6 +++---
 multipath.conf.annotated   |    4 ++--
 multipath.conf.synthetic   |    4 ++--
 multipath/multipath.conf.5 |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 826f360..87b155e 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,4 +1,4 @@
-#define DEFAULT_GETUID		"/lib/udev/scsi_id -g -u -s /block/%n"
+#define DEFAULT_GETUID		"/lib/udev/scsi_id -g -u -d /dev/%n"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/lib/multipath"
 #define DEFAULT_SELECTOR	"round-robin 0"
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0a94f10..2708fb4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -172,7 +172,7 @@ static struct hwentry default_hw[] = {
 		/* HP Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
-		.getuid        = "/lib/udev/scsi_id -n -g -u -s /block/%n",
+		.getuid        = "/lib/udev/scsi_id -n -g -u -d /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -214,7 +214,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.getuid        = "/lib/udev/scsi_id -g -u -ppre-spc3-83 -s /block/%n",
+		.getuid        = "/lib/udev/scsi_id -g -u -ppre-spc3-83 -d /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -679,7 +679,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
-		.getuid        = "/sbin/scsi_id -p 0x80 -g -u -s /block/%n",
+		.getuid        = "/lib/udev/scsi_id -p 0x80 -g -u -d /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 49c9c5c..3653477 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -49,7 +49,7 @@
 #	#           path identifier. Absolute path required
 #	# default : /lib/udev/scsi_id -g -u -s
 #	#
-#	getuid_callout	"/lib/udev/scsi_id -g -u -s /block/%n"
+#	getuid_callout	"/lib/udev/scsi_id -g -u -d /dev/%n"
 #
 #	#
 #	# name    : prio
@@ -303,7 +303,7 @@
 #		#           path identifier. Absolute path required
 #		# default : /lib/udev/scsi_id -g -u -s
 #		#
-#		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
 #
 #		#
 #		# name    : prio
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index 33f820b..6459f56 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -7,7 +7,7 @@
 #	polling_interval 	10
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
-#	getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#	getuid_callout		"/lib/udev/scsi_id -g -u -d /dev/%n"
 #	prio			const
 #	path_checker		directio
 #	rr_min_io		100
@@ -53,7 +53,7 @@
 #		vendor			"COMPAQ  "
 #		product			"HSV110 (C)COMPAQ"
 #		path_grouping_policy	multibus
-#		getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
 #		path_checker		directio
 #		path_selector		"round-robin 0"
 #		hardware_handler	"0"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c66d7fc..39639dd 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -109,7 +109,7 @@ Default value is \fImultibus\fR.
 The default program and args to callout to obtain a unique path
 identifier. Should be specified with an absolute path. Default value
 is
-.I /lib/udev/scsi_id -g -u -s
+.I /lib/udev/scsi_id -g -u -d /dev/%n
 .TP
 .B prio_callout
 The default program and args to callout to obtain a path priority
-- 
1.5.6.3
