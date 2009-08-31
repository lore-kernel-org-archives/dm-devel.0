From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.annotated
Date: 31 Aug 2009 18:43:19 -0000
Message-ID: <20090831184319.29500.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-08-31 18:43:18

Modified files:
	.              : multipath.conf.annotated 

Log message:
	Fix for bz #481239.  Just a comment to not set the alias config option to
	mpath<n>, since it will conflict with user_friendly_names.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.13&r2=1.18.2.14

--- multipath-tools/multipath.conf.annotated	2009/05/15 21:01:26	1.18.2.13
+++ multipath-tools/multipath.conf.annotated	2009/08/31 18:43:18	1.18.2.14
@@ -280,7 +280,11 @@
 #		#
 #		# name    : alias
 #		# scope   : multipath
-#		# desc    : symbolic name for the multipath
+#		# desc    : symbolic name for the multipath. If you are using
+#		#           user_friendly_names, do not set the alias to
+#		#           mpath<n>. This may conflict with an automatically
+#		#           assigned user friendly name, and give you
+#		#           incorrect device node names.
 #		#
 #		alias			yellow
 #
