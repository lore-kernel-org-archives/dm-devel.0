From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.annotated
Date: 14 Jan 2008 23:49:34 -0000
Message-ID: <20080114234934.15141.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-01-14 23:49:34

Modified files:
	.              : multipath.conf.annotated 

Log message:
	Fix wrong defaults in annotated config file.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.3&r2=1.18.2.4

--- multipath-tools/multipath.conf.annotated	2008/01/07 22:22:53	1.18.2.3
+++ multipath-tools/multipath.conf.annotated	2008/01/14 23:49:34	1.18.2.4
@@ -38,7 +38,7 @@
 #	# scope   : multipath
 #	# desc    : the default path grouping policy to apply to unspecified
 #	#           multipaths
-#	# default : multibus
+#	# default : failover
 #	#
 #	path_grouping_policy	multibus
 #
@@ -96,9 +96,9 @@
 #	#	    0 means immediate failback, values >0 means deffered failback
 #	#	    expressed in seconds.
 #	# values  : manual|immediate|n > 0
-#	# default : immediate
+#	# default : manual
 #	#
-#	failback	manual
+#	failback	immediate
 #
 #	#
 #	# name    : no_path_retry
@@ -231,9 +231,9 @@
 #		#	    0 means immediate failback, values >0 means deffered failback
 #		#	    expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : immediate
+#		# default : manual
 #		#
-#		failback		manual
+#		failback		immediate
 #
 #		#
 #		# name    : no_path_retry
@@ -343,7 +343,7 @@
 #		#	    0 means immediate failback, values >0 means deffered failback
 #		#	    expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : immediate
+#		# default : manual
 #		#
 #		failback		30
 #
