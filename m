From: heinzm@sourceware.org
Subject: dmraid/lib/format/ddf ddf1.c ddf1_dump.c
Date: 24 Aug 2011 14:28:47 -0000
Message-ID: <20110824142847.15574.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2011-08-24 14:28:47

Modified files:
	lib/format/ddf : ddf1.c ddf1_dump.c 

Log message:
	dmraid cannot erase ddf metadata.
	It tries to seek to an offset too big by a factor of 512, and then writes
	zero bytes to the anchor.
	
	ddf1-

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_dump.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/lib/format/ddf/ddf1.c	2010/03/18 16:53:17	1.8
+++ dmraid/lib/format/ddf/ddf1.c	2011/08/24 14:28:46	1.9
@@ -526,7 +526,8 @@
 		       ddf1_sboffset) || !is_ddf1(lc, di, ddf1))
 		goto bad;
 
-	ddf1->anchor_offset = ddf1_sboffset;
+	/* ddf1_sboffset is in bytes. */
+	ddf1->anchor_offset = ddf1_sboffset >> 9;
 
 	/* Convert endianness */
 	ddf1->in_cpu_format = 0;
@@ -962,6 +963,7 @@
 		ma[i].offset = ddf1->primary->primary_table_lba;
 
 	ma->offset = ddf1->anchor_offset;
+	ma->size = DDF1_BLKSIZE;
 	(ma++)->area = &ddf1->anchor;
 
 	(ma++)->area = ddf1->primary;
--- dmraid/lib/format/ddf/ddf1_dump.c	2010/07/13 20:22:38	1.3
+++ dmraid/lib/format/ddf/ddf1_dump.c	2011/08/24 14:28:46	1.4
@@ -60,7 +60,7 @@
 {
 	log_print(lc, "%s (%s):", di->path, handler);
 	log_print(lc, "DDF1 anchor at %llu with tables in %s-endian format.",
-		  ddf1->anchor_offset / DDF1_BLKSIZE,
+		  ddf1->anchor_offset,
 		  (ddf1->disk_format == LITTLE_ENDIAN ? "little" : "big"));
 }
 
