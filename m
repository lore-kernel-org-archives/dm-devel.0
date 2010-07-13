From: zkabelac@sourceware.org
Subject: dmraid/lib misc/misc.c locking/locking.c
Date: 13 Jul 2010 20:21:20 -0000
Message-ID: <20100713202120.24585.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:21:20

Modified files:
	lib/misc       : misc.c 
	lib/locking    : locking.c 

Log message:
	dbg_strdup, get_dirname accepts const char*

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/misc.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/locking/locking.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/lib/misc/misc.c	2010/03/12 11:33:02	1.4
+++ dmraid/lib/misc/misc.c	2010/07/13 20:21:19	1.5
@@ -45,7 +45,7 @@
 
 /* Return the dirname of a path. */
 char *
-get_dirname(struct lib_context *lc, char *str)
+get_dirname(struct lib_context *lc, const char *str)
 {
 	char *ret = strrchr(str, '/');
 	size_t len = ret ? ret - str : strlen(str);
@@ -228,7 +228,7 @@
 	char *b, *f, *f_sav;
 	va_list ap;
 
-	if (!(f = f_sav = dbg_strdup((char *) fmt)))
+	if (!(f = f_sav = dbg_strdup(fmt)))
 		return 0;
 
 	va_start(ap, fmt);
--- dmraid/lib/locking/locking.c	2009/09/16 11:45:15	1.4
+++ dmraid/lib/locking/locking.c	2010/07/13 20:21:20	1.5
@@ -68,7 +68,7 @@
 	int ret = 0;
 	char *dir;
 
-	if (!(dir = get_dirname(lc, (char *) lock_file)))
+	if (!(dir = get_dirname(lc, lock_file)))
 		return 0;
 
 	if (!mk_dir(lc, dir))
