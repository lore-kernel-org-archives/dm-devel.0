From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.annotated multi ...
Date: 3 Sep 2010 22:23:22 -0000
Message-ID: <20100903222322.1889.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-09-03 22:23:22

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 

Log message:
	doc file changes for bz #570513

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.16&r2=1.18.2.17
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.24&r2=1.5.4.25

--- multipath-tools/multipath.conf.annotated	2010/04/08 19:31:49	1.18.2.16
+++ multipath-tools/multipath.conf.annotated	2010/09/03 22:23:22	1.18.2.17
@@ -186,6 +186,17 @@
 #	user_friendly_names no
 #
 #	#
+#	# name    : pg_prio_calc
+#	# scope   : multipath & multipathd
+#	# desc    : If set to "avg", multipath sets the priority of path groups
+#	#           to the average of the priorities of the included paths.
+#	#           If set to "sum", multipath sets the priority of path groups
+#	#           to the sum of the priorities of the included paths.
+#	# values  : "sum"|"avg"
+#	# default : "sum"
+#	pg_prio_calc "avg"
+#
+#	#
 #	# name    : bindings_file
 #	# scope   : multipath
 #	# desc    : The location of the bindings file that is used with
--- multipath-tools/multipath.conf.defaults	2010/09/03 03:46:11	1.5.4.24
+++ multipath-tools/multipath.conf.defaults	2010/09/03 22:23:22	1.5.4.25
@@ -14,6 +14,7 @@
 #	failback		manual
 #	no_path_retry		fail
 #	user_friendly_names	no
+#	pg_prio_calc		sum
 #	bindings_file           "/var/lib/multipath/bindings"
 #}
 #
