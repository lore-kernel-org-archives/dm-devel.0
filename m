From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/4] multipath-tools: update scsi_id arguments
Date: Fri, 17 Apr 2009 18:07:57 -0400
Message-ID: <1240006080-27892-2-git-send-email-snitzer@redhat.com>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Switch over to using --whitelisted and --device

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 libmultipath/defaults.h    |    2 +-
 libmultipath/hwtable.c     |    6 ++--
 multipath.conf.annotated   |    6 ++--
 multipath.conf.defaults    |   78 ++++++++++++++++++++++----------------------
 multipath.conf.synthetic   |    4 +-
 multipath/multipath.conf.5 |    2 +-
 6 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 87b155e..d7f93cb 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,4 +1,4 @@
-#define DEFAULT_GETUID		"/lib/udev/scsi_id -g -u -d /dev/%n"
+#define DEFAULT_GETUID		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/lib/multipath"
 #define DEFAULT_SELECTOR	"round-robin 0"
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1a51b19..52bced9 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -193,7 +193,7 @@ static struct hwentry default_hw[] = {
 		/* HP Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
-		.getuid        = "/lib/udev/scsi_id -n -g -u -d /dev/%n",
+		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -235,7 +235,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.getuid        = "/lib/udev/scsi_id -g -u -ppre-spc3-83 -d /dev/%n",
+		.getuid        = "/lib/udev/scsi_id --page=pre-spc3-83 --whitelisted --device=/dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -794,7 +794,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
-		.getuid        = "/lib/udev/scsi_id -p 0x80 -g -u -d /dev/%n",
+		.getuid        = "/lib/udev/scsi_id --page=0x80 --whitelisted --device=/dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 10aa5eb..7f5fe0d 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -55,9 +55,9 @@
 #	# scope   : multipath
 #	# desc    : the default program and args to callout to obtain a unique 
 #	#           path identifier. Absolute path required
-#	# default : /lib/udev/scsi_id -g -u -s
+#	# default : /lib/udev/scsi_id --whitelisted --device=/dev/%n
 #	#
-#	getuid_callout	"/lib/udev/scsi_id -g -u -d /dev/%n"
+#	getuid_callout	"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #
 #	#
 #	# name    : prio
@@ -351,7 +351,7 @@
 #		# desc    : the program and args to callout to obtain a unique 
 #		#           path identifier. Absolute path required
 #		#
-#		getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
+#		getuid_callout          "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #
 #		#
 #		# name    : prio
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index d2dfe2b..3651e40 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -6,7 +6,7 @@
 #	polling_interval	5
 #	selector		"round-robin 0"
 #	path_grouping_policy	failover
-#	getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#	getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #	prio			const
 #	path_checker		directio
 #	rr_min_io		1000
@@ -26,7 +26,7 @@
 #	device {
 #		vendor			"APPLE*"
 #		product			"Xserve RAID"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -39,7 +39,7 @@
 #	device {
 #		vendor			"3PARdata"
 #		product			"VV"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -52,7 +52,7 @@
 #	device {
 #		vendor			"DEC"
 #		product			"HSG80"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"1 hp-sw"
 #		path_selector		"round-robin 0"
@@ -65,7 +65,7 @@
 #	device {
 #		vendor			"HP"
 #		product			"A6189A"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -79,7 +79,7 @@
 #	device {
 #		vendor			"(COMPAQ|HP)"
 #		product			"(MSA|HSV)1.0.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"1 hp-sw"
 #		path_selector		"round-robin 0"
@@ -93,7 +93,7 @@
 #	device {
 #		vendor			"HP"
 #		product			"MSA VOLUME"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -123,7 +123,7 @@
 #	device {
 #		vendor			"(COMPAQ|HP)"
 #		product			"HSV1[01]1|HSV2[01]0|HSV300"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -138,7 +138,7 @@
 #	device {
 #		vendor			"HP"
 #		product			"MSA2[02]12*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -153,7 +153,7 @@
 #	device {
 #		vendor			"HP"
 #		product			"LOGICAL VOLUME.*"
-#		getuid_callout		"/lib/udev/scsi_id -n -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -168,7 +168,7 @@
 #	device {
 #		vendor			"DDN"
 #		product			"SAN DataDirector"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -181,7 +181,7 @@
 #	device {
 #		vendor			"EMC"
 #		product			"SYMMETRIX"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -ppre-spc3-83 -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --page=pre-spc3-83 --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -195,7 +195,7 @@
 #		vendor			"DGC"
 #		product			".*"
 #		product_blacklist	"LUNZ"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"1 emc"
@@ -211,7 +211,7 @@
 #	device {
 #		vendor			"FSC"
 #		product			"CentricStor"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -224,7 +224,7 @@
 #	device {
 #		vendor			"(HITACHI|HP)"
 #		product			"OPEN-.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -237,7 +237,7 @@
 #	device {
 #		vendor			"HITACHI"
 #		product			"DF.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -251,7 +251,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"ProFibre 4000R"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -264,7 +264,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"1722-600"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -279,7 +279,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"1742"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -294,7 +294,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"1814"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -309,7 +309,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"1815"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -324,7 +324,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"3526"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -339,7 +339,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"3542"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -352,7 +352,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"2105(800|F20)"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -365,7 +365,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"1750500"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -379,7 +379,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"2107900"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -392,7 +392,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"2145"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -407,7 +407,7 @@
 #		vendor			"IBM"
 #		product			"S/390 DASD ECKD"
 #		product_blacklist	"S/390.*"
-#		getuid_callout		"/sbin/dasdinfo -u -b %n"
+#		getuid_callout		"/sbin/dasd_id /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -420,7 +420,7 @@
 #	device {
 #		vendor			"NETAPP"
 #		product			"LUN.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -434,7 +434,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"Nseries.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -448,7 +448,7 @@
 #	device {
 #		vendor			"Pillar"
 #		product			"Axiom.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -461,7 +461,7 @@
 #	device {
 #		vendor			"SGI"
 #		product			"TP9[13]00"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -474,7 +474,7 @@
 #	device {
 #		vendor			"SGI"
 #		product			"TP9[45]00"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -489,7 +489,7 @@
 #	device {
 #		vendor			"SGI"
 #		product			"IS.*"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -504,7 +504,7 @@
 #	device {
 #		vendor			"STK"
 #		product			"OPENstorage D280"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -518,7 +518,7 @@
 #	device {
 #		vendor			"SUN"
 #		product			"(StorEdge 3510|T4)"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -531,7 +531,7 @@
 #	device {
 #		vendor			"PIVOT3"
 #		product			"RAIGE VOLUME"
-#		getuid_callout		"/sbin/scsi_id -p 0x80 -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --page=0x80 --device=/dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_selector		"round-robin 0"
@@ -544,7 +544,7 @@
 #	device {
 #		vendor			"SUN"
 #		product			"CSM200_R"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
@@ -559,7 +559,7 @@
 #	device {
 #		vendor			"SUN"
 #		product			"LCSM100_F"
-#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		features		"0"
 #		hardware_handler	"1 rdac"
 #		path_selector		"round-robin 0"
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index bf94c04..efa84f0 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -7,7 +7,7 @@
 #	polling_interval 	10
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
-#	getuid_callout		"/lib/udev/scsi_id -g -u -d /dev/%n"
+#	getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #	prio			const
 #	path_checker		directio
 #	rr_min_io		100
@@ -52,7 +52,7 @@
 #		vendor			"COMPAQ  "
 #		product			"HSV110 (C)COMPAQ"
 #		path_grouping_policy	multibus
-#		getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
+#		getuid_callout          "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #		path_checker		directio
 #		path_selector		"round-robin 0"
 #		hardware_handler	"0"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c02245c..057dd83 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -109,7 +109,7 @@ Default value is \fImultibus\fR.
 The default program and args to callout to obtain a unique path
 identifier. Should be specified with an absolute path. Default value
 is
-.I /lib/udev/scsi_id -g -u -d /dev/%n
+.I /lib/udev/scsi_id --whitelisted --device=/dev/%n
 .TP
 .B prio_callout
 The default program and args to callout to obtain a path priority
-- 
1.6.0.6
