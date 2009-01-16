From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 16 Jan 2009 21:30:43 -0000
Message-ID: <20090116213043.32325.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-01-16 21:30:43

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : dict.c 

Log message:
	Fix fox bz #453547.  Fix rr_min_io for devices/maps in multipath.conf

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.6&r2=1.16.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.5&r2=1.16.2.6

--- multipath-tools/multipath.conf.annotated	2008/04/14 22:40:08	1.16.2.6
+++ multipath-tools/multipath.conf.annotated	2009/01/16 21:30:42	1.16.2.7
@@ -265,6 +265,14 @@
 #		path_selector		"round-robin 0"
 #
 #		#
+#		# name    : rr_min_io
+#		# scope   : multipath
+#		# desc    : the number of IO to route to a path before switching
+#		#           to the next in the same path group
+#		#
+#		rr_min_io	100
+#
+#		#
 #		# name    : failback
 #		# scope   : multipathd
 #		# desc    : tell the daemon to manage path group failback, or
@@ -403,6 +411,14 @@
 #		path_selector		"round-robin 0"
 #
 #		#
+#		# name    : rr_min_io
+#		# scope   : multipath
+#		# desc    : the number of IO to route to a path before switching
+#		#           to the next in the same path group
+#		#
+#		rr_min_io	100
+#
+#		#
 #		# name    : path_checker
 #		# scope   : multipathd
 #		# desc    : path checking alorithm to use to check path state
--- multipath-tools/libmultipath/dict.c	2008/04/14 22:40:08	1.16.2.5
+++ multipath-tools/libmultipath/dict.c	2009/01/16 21:30:43	1.16.2.6
@@ -556,6 +556,26 @@
 }
 
 static int
+hw_rr_min_io_handler(vector strvec)
+{
+	char * buff;
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	if (!hwe)
+		return 1;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+	
+	hwe->rr_min_io = atoi(buff);
+	FREE(buff);
+
+	return 0;
+}
+
+static int
 hw_features_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
@@ -830,6 +850,26 @@
 	return 0;
 }
 
+
+static int
+mp_rr_min_io_handler(vector strvec)
+{
+	char * buff;
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+	
+	mpe->rr_min_io = atoi(buff);
+	FREE(buff);
+
+	return 0;
+}
 static int
 mp_failback_handler(vector strvec)
 {
@@ -1087,6 +1127,7 @@
 	install_keyword("getuid_callout", &hw_getuid_callout_handler);
 	install_keyword("path_selector", &hw_selector_handler);
 	install_keyword("path_checker", &hw_path_checker_handler);
+	install_keyword("rr_min_io", &hw_rr_min_io_handler);
 	install_keyword("features", &hw_features_handler);
 	install_keyword("hardware_handler", &hw_handler_handler);
 	install_keyword("prio_callout", &prio_callout_handler);
@@ -1104,6 +1145,7 @@
 	install_keyword("alias", &alias_handler);
 	install_keyword("path_grouping_policy", &mp_pgpolicy_handler);
 	install_keyword("path_selector", &mp_selector_handler);
+	install_keyword("rr_min_io", &mp_rr_min_io_handler);
 	install_keyword("failback", &mp_failback_handler);
 	install_keyword("rr_weight", &mp_weight_handler);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler);
