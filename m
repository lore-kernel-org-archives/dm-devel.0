From: NeilBrown <neilb@suse.de>
Subject: [PATCH] dmraid: allow "dmraid --erase_metadata" to work
	with ddf
Date: Tue, 23 Aug 2011 18:02:35 +1000
Message-ID: <20110823180235.2920da02@notabene.brown>
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
To: dm-devel@redhat.com, Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids


Hi,
 current dmraid cannot erase ddf metadata.
 It tries to seek to an offset too big by a factor of 512, and then writes
 zero bytes to the anchor.

 "ddf1->anchor_offset" is set to a number of bytes and sometimes treated as
 bytes - sometimes as sectors.
 This patch makes it always sectors and also sets the size of the anchor
 metadata area to DDF1_BLKSIZE

Signed-off-by: NeilBrown <neilb@suse.de>


Index: lib/format/ddf/ddf1.c
===================================================================
RCS file: /cvs/dm/dmraid/lib/format/ddf/ddf1.c,v
retrieving revision 1.8
diff -u -r1.8 ddf1.c
--- lib/format/ddf/ddf1.c	18 Mar 2010 16:53:17 -0000	1.8
+++ lib/format/ddf/ddf1.c	23 Aug 2011 08:01:13 -0000
@@ -526,7 +526,7 @@
 		       ddf1_sboffset) || !is_ddf1(lc, di, ddf1))
 		goto bad;
 
-	ddf1->anchor_offset = ddf1_sboffset;
+	ddf1->anchor_offset = ddf1_sboffset / 512;
 
 	/* Convert endianness */
 	ddf1->in_cpu_format = 0;
@@ -962,6 +962,7 @@
 		ma[i].offset = ddf1->primary->primary_table_lba;
 
 	ma->offset = ddf1->anchor_offset;
+	ma->size = DDF1_BLKSIZE;
 	(ma++)->area = &ddf1->anchor;
 
 	(ma++)->area = ddf1->primary;
Index: lib/format/ddf/ddf1_dump.c
===================================================================
RCS file: /cvs/dm/dmraid/lib/format/ddf/ddf1_dump.c,v
retrieving revision 1.3
diff -u -r1.3 ddf1_dump.c
--- lib/format/ddf/ddf1_dump.c	13 Jul 2010 20:22:38 -0000	1.3
+++ lib/format/ddf/ddf1_dump.c	23 Aug 2011 08:01:13 -0000
@@ -60,7 +60,7 @@
 {
 	log_print(lc, "%s (%s):", di->path, handler);
 	log_print(lc, "DDF1 anchor at %llu with tables in %s-endian format.",
-		  ddf1->anchor_offset / DDF1_BLKSIZE,
+		  ddf1->anchor_offset,
 		  (ddf1->disk_format == LITTLE_ENDIAN ? "little" : "big"));
 }
 
