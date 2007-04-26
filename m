From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 26 Apr 2007 17:47:01 -0000
Message-ID: <20070426174701.15275.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-04-26 18:47:01

Modified files:
	multipathd     : main.c 

Log message:
	pulled upstream patch to fix multipath daemon segfaults.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.1&r2=1.66.2.2

--- multipath-tools/multipathd/main.c	2006/07/11 22:49:22	1.66.2.1
+++ multipath-tools/multipathd/main.c	2007/04/26 17:47:01	1.66.2.2
@@ -1542,6 +1542,7 @@
 	signal_set(SIGINT, sigend);
 	signal_set(SIGTERM, sigend);
 	signal_set(SIGKILL, sigend);
+	signal(SIGPIPE, SIG_IGN);
 }
 
 static void
