From: heinzm@sourceware.org
Subject: dmraid/lib/misc file.c
Date: 11 Jan 2010 16:19:30 -0000
Message-ID: <20100111161930.24052.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-01-11 16:19:29

Modified files:
	lib/misc       : file.c 

Log message:
	Correct indentation and remove some empty lines

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/file.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/lib/misc/file.c	2008/06/20 21:52:18	1.3
+++ dmraid/lib/misc/file.c	2010/01/11 16:19:29	1.4
@@ -32,7 +32,6 @@
 	} while (s);
 
 	dbg_free(orig);
-
 	return ret;
 }
 
@@ -62,9 +61,9 @@
 		ssize_t(*func) ();
 		const char *what;
 	} rw_spec[] = {
-		{
-		read, "read"}, {
-	write, "writ"},}, *rw = rw_spec + ((flags & O_WRONLY) ? 1 : 0);
+		{ read, "read"},
+		{ write, "writ"},
+	}, *rw = rw_spec + ((flags & O_WRONLY) ? 1 : 0);
 
 	if ((fd = open(path, flags, lc->mode)) == -1)
 		LOG_ERR(lc, 0, "opening \"%s\"", path);
@@ -84,7 +83,6 @@
 		ret = 1;
 
 	close(fd);
-
 	return ret;
 }
 
