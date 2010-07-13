From: zkabelac@sourceware.org
Subject: dmraid/tools toollib.c
Date: 13 Jul 2010 20:16:47 -0000
Message-ID: <20100713201647.23088.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-07-13 20:16:47

Modified files:
	tools          : toollib.c 

Log message:
	dbg_strdup accepts const char*

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/toollib.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/tools/toollib.c	2008/06/20 21:52:19	1.2
+++ dmraid/tools/toollib.c	2010/07/13 20:16:47	1.3
@@ -108,7 +108,7 @@
 	char *p, *p_sav, *sep;
 	const char delim = *OPT_STR_SEPARATOR(lc);
 
-	if (!(p_sav = dbg_strdup((char *) fmt)))
+	if (!(p_sav = dbg_strdup(fmt)))
 		return log_alloc_err(lc, __func__);
 
 	sep = p_sav;
