From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c  ...
Date: 24 Jul 2007 14:16:48 -0000
Message-ID: <20070724141648.18945.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-07-24 14:16:48

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 
	lib/fs         : libdevmapper.c 

Log message:
	libdevmapper, dmeventd: be paranoid about detecting write failure
	* dmeventd/dmeventd.c (_set_oom_adj): When writing to /proc/self/oom_adj,
	detect failure even if it's hidden behind ferror.  [Using dm_fclose's
	extra ferror test here is probably not needed, since the amount written
	is nowhere near BUFSIZ, but use it regardless, for consistency. ]
	* lib/fs/libdevmapper.c (do_suspend): Detect fclose failure when
	writing to suspend.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.192&r2=1.193
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.49&r2=1.50
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/fs/libdevmapper.c.diff?cvsroot=dm&r1=1.13&r2=1.14

--- device-mapper/WHATS_NEW	2007/07/24 14:15:45	1.192
+++ device-mapper/WHATS_NEW	2007/07/24 14:16:48	1.193
@@ -1,6 +1,7 @@
 Version 1.02.22 - 
 ================================
   dm_fclose: new function
+  libdevmapper, dmeventd: be paranoid about detecting write failure
 
 Version 1.02.21 - 13th July 2007
 ================================
--- device-mapper/dmeventd/dmeventd.c	2007/04/24 13:29:02	1.49
+++ device-mapper/dmeventd/dmeventd.c	2007/07/24 14:16:48	1.50
@@ -1579,7 +1579,7 @@
 	}
 
 	fprintf(fp, "%i", val);
-	if (fclose(fp))
+	if (dm_fclose(fp))
 		perror(OOM_ADJ_FILE ": fclose failed");
 
 	return 1;
--- device-mapper/lib/fs/libdevmapper.c	2004/03/30 19:08:57	1.13
+++ device-mapper/lib/fs/libdevmapper.c	2007/07/24 14:16:48	1.14
@@ -150,7 +150,8 @@
 			ret = 1;
 		else
 			log_error("%s: fputc failed: %s", path, strerror(errno));
-		fclose(fp);
+		if (fclose(fp))
+			log_error("%s: write failed: %s", path, strerror(errno));
 	} else
 		log_error("%s: fopen failed: %s", path, strerror(errno));
 
