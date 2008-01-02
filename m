From: bmarzins@sourceware.org
Subject: multipath-tools/multipath multipath.conf.redhat
Date: 2 Jan 2008 19:06:12 -0000
Message-ID: <20080102190612.27694.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-01-02 19:06:12

Modified files:
	multipath      : multipath.conf.redhat 

Log message:
	Config file typeo, fixes bug #426799

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.5&r2=1.6.2.6

--- multipath-tools/multipath/multipath.conf.redhat	2007/10/09 21:48:20	1.6.2.5
+++ multipath-tools/multipath/multipath.conf.redhat	2008/01/02 19:06:12	1.6.2.6
@@ -42,7 +42,7 @@
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
-#	user_friendly_name	yes
+#	user_friendly_names	yes
 #}
 ##
 ## The wwid line in the following blacklist section is shown as an example
