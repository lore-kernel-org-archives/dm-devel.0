From: bmarzins@sourceware.org
Subject: multipath-tools/multipathd main.c
Date: 11 Apr 2011 17:01:09 -0000
Message-ID: <20110411170109.1622.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-04-11 17:01:08

Modified files:
	multipathd     : main.c 

Log message:
	Oops. stray semi-colon.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.34&r2=1.69.2.35

--- multipath-tools/multipathd/main.c	2011/04/04 19:48:46	1.69.2.34
+++ multipath-tools/multipathd/main.c	2011/04/11 17:01:08	1.69.2.35
@@ -1505,7 +1505,7 @@
 	condlog(2, "reconfigure (SIGHUP)");
 
 	lock(gvecs->lock);
-	if (!exitting);
+	if (!exitting)
 		reconfigure(gvecs);
 	unlock(gvecs->lock);
 
