From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 05/10] dm-integrity: allow large ranges
Date: Mon, 29 Apr 2019 14:57:21 +0200
Message-ID: <20190429125742.218227600@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-large-range.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This patch changes the type of the variable n_sectors from unsigned to
n_sectors. The following patches will need to lock large ranges.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-16 21:21:14.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-16 21:21:14.000000000 +0200
@@ -246,7 +246,7 @@ struct dm_integrity_c {
 
 struct dm_integrity_range {
 	sector_t logical_sector;
-	unsigned n_sectors;
+	sector_t n_sectors;
 	bool waiting;
 	union {
 		struct rb_node node;
@@ -1695,7 +1695,7 @@ retry:
 			unsigned ws, we, range_sectors;
 
 			dio->range.n_sectors = min(dio->range.n_sectors,
-						   ic->free_sectors << ic->sb->log2_sectors_per_block);
+						   (sector_t)ic->free_sectors << ic->sb->log2_sectors_per_block);
 			if (unlikely(!dio->range.n_sectors)) {
 				if (from_map)
 					goto offload_to_thread;
@@ -2153,7 +2153,7 @@ next_chunk:
 	get_area_and_offset(ic, range.logical_sector, &area, &offset);
 	range.n_sectors = min((sector_t)RECALC_SECTORS, ic->provided_data_sectors - range.logical_sector);
 	if (!ic->meta_dev)
-		range.n_sectors = min(range.n_sectors, (1U << ic->sb->log2_interleave_sectors) - (unsigned)offset);
+		range.n_sectors = min(range.n_sectors, ((sector_t)1U << ic->sb->log2_interleave_sectors) - (unsigned)offset);
 
 	if (unlikely(!add_new_range(ic, &range, true)))
 		wait_and_add_new_range(ic, &range);
