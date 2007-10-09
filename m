From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 9 Oct 2007 21:48:20 -0000
Message-ID: <20071009214820.18363.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-10-09 21:48:20

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 
	multipath      : multipath.conf.redhat 
	path_priority/pp_netapp: Makefile 

Log message:
	add symlink for mpath_prio_ontap and clean up default config file.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.6&r2=1.5.4.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.7&r2=1.20.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.4&r2=1.6.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.2&r2=1.2.2.3

--- multipath-tools/multipath.conf.defaults	2007/09/06 16:22:25	1.5.4.6
+++ multipath-tools/multipath.conf.defaults	2007/10/09 21:48:19	1.5.4.7
@@ -287,7 +287,7 @@
 #		vendor			"NETAPP"
 #		product			"LUN"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
-#		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
+#		prio_callout		"/sbin/mpath_prio_ontap /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_grouping_policy	group_by_prio
@@ -300,7 +300,7 @@
 #		vendor			"IBM"
 #		product			"Nseries.*"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
-#		prio_callout		"/sbin/mpath_prio_netapp /dev/%n"
+#		prio_callout		"/sbin/mpath_prio_ontap /dev/%n"
 #		features		"1 queue_if_no_path"
 #		hardware_handler	"0"
 #		path_grouping_policy	group_by_prio
--- multipath-tools/libmultipath/hwtable.c	2007/09/06 16:21:38	1.20.2.7
+++ multipath-tools/libmultipath/hwtable.c	2007/10/09 21:48:19	1.20.2.8
@@ -394,7 +394,7 @@
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_netapp /dev/%n",
+		.getprio       = "/sbin/mpath_prio_ontap /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -415,7 +415,7 @@
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_netapp /dev/%n",
+		.getprio       = "/sbin/mpath_prio_ontap /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
--- multipath-tools/multipath/multipath.conf.redhat	2007/06/19 18:12:15	1.6.2.4
+++ multipath-tools/multipath/multipath.conf.redhat	2007/10/09 21:48:20	1.6.2.5
@@ -1,8 +1,9 @@
-# This is an example configuration file for device mapper multipath.
+# This is a basic configuration file with some examples, for device mapper
+# multipath.
 # For a complete list of the default configuration values, see
-# /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults
+# /usr/share/doc/device-mapper-multipath-0.4.7/multipath.conf.defaults
 # For a list of configuration options with descriptions, see
-# /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated
+# /usr/share/doc/device-mapper-multipath-0.4.7/multipath.conf.annotated
 
 
 # Blacklist all devices by default. Remove this to enable multipathing
@@ -26,9 +27,9 @@
 	user_friendly_names yes
 }
 ##
-## This is a template multipath-tools configuration file
-## Uncomment the lines relevent to your environment
+## Here is an example of how to configure some standard options.
 ##
+#
 #defaults {
 #	udev_dir		/dev
 #	polling_interval 	10
@@ -45,7 +46,7 @@
 #}
 ##
 ## The wwid line in the following blacklist section is shown as an example
-## of how to blacklist devices by wwid.  The 3 devnode lines are the
+## of how to blacklist devices by wwid.  The 2 devnode lines are the
 ## compiled in default blacklist. If you want to blacklist entire types
 ## of devices, such as all scsi devices, you should use a devnode line.
 ## However, if you want to blacklist specific devices, you should use
--- multipath-tools/path_priority/pp_netapp/Makefile	2007/06/15 21:03:14	1.2.2.2
+++ multipath-tools/path_priority/pp_netapp/Makefile	2007/10/09 21:48:20	1.2.2.3
@@ -17,6 +17,7 @@
 install: $(EXEC)
 	[ -f $(EXEC).static ] && install -m 755 $(EXEC).static $(DESTDIR)$(bindir)/$(EXEC).static
 	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	ln -s $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/mpath_prio_ontap
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
