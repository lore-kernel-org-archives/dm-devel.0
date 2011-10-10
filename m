From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 10 Oct 2011 04:15:42 -0000
Message-ID: <20111010041542.4123.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-10-10 04:15:42

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	libmultipath   : dict.c 
	multipathd     : main.c 

Log message:
	Fix for BZs #702410, #711970, and #715524
	
	Various small cleanups.  Keep mutipath from complaining when it fails to add
	non-multipath devices. Allow "path_selector" or "selector" in the defaults
	section of multipath.conf. Document file_timeout option. Not applicable
	upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.18&r2=1.18.2.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.29&r2=1.5.4.30
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.19&r2=1.17.2.20
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.36&r2=1.69.2.37

--- multipath-tools/multipath.conf.annotated	2011/02/18 18:27:00	1.18.2.18
+++ multipath-tools/multipath.conf.annotated	2011/10/10 04:15:41	1.18.2.19
@@ -260,6 +260,16 @@
 #      # default : determined by the OS
 #      dev_loss_tmo 600
 #
+#      #
+#      # name    : file_timeout
+#      # scope   : multipath & multipathd
+#      # desc    : The number of seconds that multipath will wait for
+#      #           necessary files to appear while setting up a multipath
+#      #           devices.
+#      # values  : n > 0
+#      # default : 90
+#      file_timeout 30
+#
 #}
 #	
 ##
--- multipath-tools/multipath.conf.defaults	2011/03/07 05:19:36	1.5.4.29
+++ multipath-tools/multipath.conf.defaults	2011/10/10 04:15:41	1.5.4.30
@@ -16,6 +16,7 @@
 #	user_friendly_names	no
 #	pg_prio_calc		sum
 #	bindings_file           "/var/lib/multipath/bindings"
+#	file_timeout		90
 #}
 #
 #blacklist {
--- multipath-tools/libmultipath/dict.c	2011/04/05 18:41:45	1.17.2.19
+++ multipath-tools/libmultipath/dict.c	2011/10/10 04:15:41	1.17.2.20
@@ -2150,7 +2150,8 @@
 ;
 	install_keyword("polling_interval", &polling_interval_handler, &snprint_def_polling_interval);
 	install_keyword("udev_dir", &udev_dir_handler, &snprint_def_udev_dir);
-	install_keyword("selector", &def_selector_handler, &snprint_def_selector);
+	install_keyword("selector", &def_selector_handler, NULL);
+	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
 	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
 	install_keyword("prio_callout", &def_prio_callout_handler, &snprint_def_getprio_callout);
--- multipath-tools/multipathd/main.c	2011/10/10 03:47:07	1.69.2.36
+++ multipath-tools/multipathd/main.c	2011/10/10 04:15:41	1.69.2.37
@@ -227,7 +227,8 @@
 uev_add_map (char * devname, struct vectors * vecs)
 {
 	condlog(2, "%s: add map (uevent)", devname);
-	return ev_add_map(devname, vecs);
+	ev_add_map(devname, vecs);
+	return 0;
 }
 
 int
