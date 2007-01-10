From: bmarzins@sourceware.org
Subject: multipath-tools ./Multipath-usage.txt ./multip ...
Date: 10 Jan 2007 21:56:18 -0000
Message-ID: <20070110215618.29313.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-01-10 21:56:17

Modified files:
	.              : Multipath-usage.txt multipath.conf.defaults 
	libmultipath   : hwtable.c 
	multipath      : multipath.conf.redhat 

Log message:
	Resolves: bz 220643
	Doc changes, to explain about using /dev/mapper devices to avoid the udev race
	at boot and to help people figure out how to use dasd devices. Also, the
	IBM:S/390 devices are again blacklisted by default.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Multipath-usage.txt.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4.2.1&r2=1.4.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.5&r2=1.16.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.1&r2=1.5.2.2

--- multipath-tools/Multipath-usage.txt	2006/06/06 18:04:08	1.4.2.1
+++ multipath-tools/Multipath-usage.txt	2007/01/10 21:56:17	1.4.2.2
@@ -219,6 +219,12 @@
 After initial setup, all access to the multipathed storage should go through the
 multipath device.
 
+When a multipath device is mounted at boot time , udev may not create the
+device node for it soon enough.  To avoid this problem, instead of using
+the /dev/mpath/<device> name in /etc/fstab, use /dev/mapper/<device>. This
+device node is automatically created by device-mapper, as soon as the device is
+created.
+
 GNBD devices will not be automatically multipathed after they are imported.
 The command
 
--- multipath-tools/multipath.conf.defaults	2006/12/07 15:53:44	1.5.2.1
+++ multipath-tools/multipath.conf.defaults	2007/01/10 21:56:17	1.5.2.2
@@ -204,6 +204,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"S/390 DASD ECKD"
+#		bl_product		"S/390"
 #		path_grouping_policy	multibus
 #		getuid_callout		"/sbin/dasdview -j /dev/%n"
 #		path_checker		directio
--- multipath-tools/libmultipath/hwtable.c	2006/12/01 23:45:18	1.16.2.5
+++ multipath-tools/libmultipath/hwtable.c	2007/01/10 21:56:17	1.16.2.6
@@ -70,7 +70,7 @@
 		   "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "S/390 DASD ECKD", MULTIBUS,
 		   "/sbin/dasdview -j /dev/%n", NULL, "0", "0",
-		   "directio", FAILBACK_UNDEF, NULL, 0, 0, 0);
+		   "directio", FAILBACK_UNDEF, "S/390", 0, 0, 0);
 	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
 		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
 		  "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF, NULL, 0, 0, 0);
--- multipath-tools/multipath/multipath.conf.redhat	2007/01/04 19:02:30	1.5.2.1
+++ multipath-tools/multipath/multipath.conf.redhat	2007/01/10 21:56:17	1.5.2.2
@@ -15,6 +15,22 @@
 defaults {
 	user_friendly_names yes
 }
+
+
+## By default, devices with vendor = "IBM" and product = "S/390.*" are
+## blacklisted. To enable mulitpathing on these devies, uncomment the
+## following lines.
+#devices {
+#	device {
+#		vendor                  "IBM"
+#		product                 "S/390 DASD ECKD"
+#		path_grouping_policy    multibus
+#		getuid_callout          "/sbin/dasdview -j /dev/%n"
+#		path_checker            directio
+#	}
+#}
+
+
 ##
 ## This is a template multipath-tools configuration file
 ## Uncomment the lines relevent to your environment
