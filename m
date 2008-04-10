From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 10 Apr 2008 18:00:45 -0000
Message-ID: <20080410180045.21335.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2008-04-10 18:00:45

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.132&r2=1.133
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.225&r2=1.226

--- device-mapper/VERSION	2007/12/20 15:16:14	1.132
+++ device-mapper/VERSION	2008/04/10 18:00:45	1.133
@@ -1 +1 @@
-1.02.25-cvs (2007-12-20)
+1.02.25-cvs (2008-04-10)
--- device-mapper/WHATS_NEW	2008/02/15 14:14:58	1.225
+++ device-mapper/WHATS_NEW	2008/04/10 18:00:45	1.226
@@ -1,5 +1,5 @@
-Version 1.02.25 - 
-====================================
+Version 1.02.25 - 10th April 2008
+=================================
   Remove redundant if-before-free tests.
   Use log_warn for reporting field help text instead of log_print.
   Change cluster mirror log type name (s/clustered_/clustered-/)
