From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.annotated
Date: 23 Jan 2009 00:27:44 -0000
Message-ID: <20090123002744.25439.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-01-23 00:27:43

Modified files:
	.              : multipath.conf.annotated 

Log message:
	Fix for bz #461122. Just a small documentation cleanup.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.8&r2=1.16.2.9

--- multipath-tools/multipath.conf.annotated	2009/01/17 00:46:51	1.16.2.8
+++ multipath-tools/multipath.conf.annotated	2009/01/23 00:27:43	1.16.2.9
@@ -236,7 +236,12 @@
 #		#
 #		# name    : alias
 #		# scope   : multipath
-#		# desc    : symbolic name for the multipath
+#		# desc    : symbolic name for the multipath. If you
+#		#           are using user_friendly_name, do not set
+#		#           the alias to mpath<n>.  This may conflict
+#		#           with a automatically assigned
+#		#           user_friendly_name, and give you incorrect
+#		#           device nodes.
 #		#
 #		alias			yellow
 #
