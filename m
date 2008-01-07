From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.annotated multi ...
Date: 7 Jan 2008 22:22:53 -0000
Message-ID: <20080107222253.29647.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-01-07 22:22:53

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 

Log message:
	Added bindings_file info to annoted and default config files.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.2&r2=1.18.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.8&r2=1.5.4.9

--- multipath-tools/multipath.conf.annotated	2007/06/19 18:12:15	1.18.2.2
+++ multipath-tools/multipath.conf.annotated	2008/01/07 22:22:53	1.18.2.3
@@ -124,6 +124,15 @@
 #	# default : no
 #	user_friendly_names no
 #
+#	#
+#	# name    : bindings_file
+#	# scope   : multipath
+#	# desc    : The location of the bindings file that is used with
+#	#           the user_friendly_names option.
+#	# values  : <full_pathname>
+#	# default : "/var/lib/multipath/bindings"
+#	bindings_file "/etc/multipath_bindings"
+#
 #}
 #	
 ##
--- multipath-tools/multipath.conf.defaults	2008/01/03 20:16:05	1.5.4.8
+++ multipath-tools/multipath.conf.defaults	2008/01/07 22:22:53	1.5.4.9
@@ -14,6 +14,7 @@
 #	failback		manual
 #	no_path_retry		fail
 #	user_friendly_names	no
+#	bindings_file           "/var/lib/multipath/bindings"
 #}
 #
 #blacklist {
