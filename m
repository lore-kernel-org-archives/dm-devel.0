From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-bufio: introduce block_to_sector
Date: Fri, 7 Feb 2020 15:59:25 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002071558040.24277@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Introduce a function block_to_sector to avoid repetitive code in
the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2020-02-07 17:09:44.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2020-02-07 17:13:09.000000000 +0100
@@ -632,6 +632,21 @@ dmio:
 	submit_bio(bio);
 }
 
+static inline sector_t block_to_sector(struct dm_bufio_client *c, sector_t block)
+{
+	sector_t sector;
+
+	if (unlikely(c->raw_sectors))
+		sector = block;
+	else if (likely(c->sectors_per_block_bits >= 0))
+		sector = block << c->sectors_per_block_bits;
+	else
+		sector = block * (c->block_size >> SECTOR_SHIFT);
+	sector += c->start;
+
+	return sector;
+}
+
 static void submit_io(struct dm_buffer *b, int rw, void (*end_io)(struct dm_buffer *, blk_status_t))
 {
 	unsigned n_sectors;
@@ -640,13 +655,7 @@ static void submit_io(struct dm_buffer *
 
 	b->end_io = end_io;
 
-	if (unlikely(b->c->raw_sectors))
-		sector = b->block;
-	else if (likely(b->c->sectors_per_block_bits >= 0))
-		sector = b->block << b->c->sectors_per_block_bits;
-	else
-		sector = b->block * (b->c->block_size >> SECTOR_SHIFT);
-	sector += b->c->start;
+	sector = block_to_sector(b->c, b->block);
 
 	if (rw != REQ_OP_WRITE) {
 		n_sectors = b->c->block_size >> SECTOR_SHIFT;
