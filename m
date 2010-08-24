From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 24 Aug 2010 21:51:11 -0000
Message-ID: <20100824215111.17381.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-24 21:51:10

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	path_priority/pp_hds_modular: pp_hds_modular.c 

Log message:
	Fix for bz #559852.  mpath_prio_hds_modular can now accept a pathname as well
	as the major:minor.  The default config has been switched to use this.  This
	allows the callout to work even if they can't create any files on /tmp. Not
	Applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.22&r2=1.5.4.23
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.29&r2=1.20.2.30
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hds_modular/pp_hds_modular.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2&r2=1.2.2.1

--- multipath-tools/multipath.conf.defaults	2010/08/09 21:35:58	1.5.4.22
+++ multipath-tools/multipath.conf.defaults	2010/08/24 21:51:10	1.5.4.23
@@ -267,7 +267,7 @@
 #               vendor                  "HITACHI"
 #               product                 "DF.*"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
-#		prio_callout		"/sbin/mpath_prio_hds_modular %d"
+#		prio_callout		"/sbin/mpath_prio_hds_modular /dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #		path_grouping_policy	group_by_prio
@@ -395,7 +395,7 @@
 #		vendor			"IBM"
 #		product			"1750500"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_alua %d"	
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #               path_grouping_policy    group_by_prio
@@ -482,7 +482,7 @@
 #		vendor			"Pillar"
 #		product			"Axiom [35]00"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_alua %d"	
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
 #               path_grouping_policy    group_by_prio
--- multipath-tools/libmultipath/hwtable.c	2010/08/09 21:35:58	1.20.2.29
+++ multipath-tools/libmultipath/hwtable.c	2010/08/24 21:51:10	1.20.2.30
@@ -289,7 +289,7 @@
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_hds_modular %d",
+		.getprio       = "/sbin/mpath_prio_hds_modular /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -646,7 +646,7 @@
 		.vendor        = "Pillar",
 		.product       = "Axiom [35]00",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua %d",
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
--- multipath-tools/path_priority/pp_hds_modular/pp_hds_modular.c	2006/06/06 18:32:44	1.2
+++ multipath-tools/path_priority/pp_hds_modular/pp_hds_modular.c	2010/08/24 21:51:10	1.2.2.1
@@ -99,7 +99,7 @@
 
 int verbose;
 
-int hds_modular_prio(char * major_minor)
+int hds_modular_prio(char * device)
 {
 	int sg_fd, k, i;
 	char vendor[32];
@@ -117,16 +117,24 @@
 	unsigned char sense_buffer[32];
 	sg_io_hdr_t io_hdr;
 
-	sscanf(major_minor, "%u:%u", &major, &minor);
 	memset(devpath, 0, FILE_NAME_SIZE);
+	if (sscanf(device, "%u:%u", &major, &minor) == 2) {
 
-	if (safe_sprintf(devpath, "/tmp/.pp_balance.%u.%u.devnode",
-			 major, minor))
-		exit(1);
-
-	unlink (devpath);
-	mknod(devpath, S_IFBLK|S_IRUSR|S_IWUSR, makedev(major, minor));
+		if (safe_sprintf(devpath, "/tmp/.pp_balance.%u.%u.devnode",
+				 major, minor))
+			exit(1);
 
+		unlink (devpath);
+		mknod(devpath, S_IFBLK|S_IRUSR|S_IWUSR, makedev(major, minor));
+	}
+	else if (device[0] == '/') {
+		if (safe_sprintf(devpath, "%s", device))
+			exit(1);
+	}
+	else {
+		if (safe_sprintf(devpath, "/dev/%s", device))
+			exit(1);
+	}
 	if ((sg_fd = open(devpath, O_RDONLY)) < 0) exit(1);
 	if ((ioctl(sg_fd, SG_GET_VERSION_NUM, &k) < 0) || (k < 30000))
 		exit(1);
