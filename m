From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/11] bottom-layer barrier support
Date: Fri, 10 Apr 2009 01:13:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904100113050.1117@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110010.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110370.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100111110.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100112060.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100112330.1117@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904100112330.1117@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Introduce __clone_and_map_empty_barrier that will pass empty barrier
to the targets. Each target receives as many requests as it set up
in num_flush_requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm.c	2009-04-10 06:33:28.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm.c	2009-04-10 06:33:31.000000000 +0200
@@ -747,6 +747,8 @@ static struct bio *clone_bio(struct bio 
 	return clone;
 }
 
+static int __clone_and_map_empty_barrier(struct clone_info *ci);
+
 static int __clone_and_map(struct clone_info *ci)
 {
 	struct bio *clone, *bio = ci->bio;
@@ -754,6 +756,9 @@ static int __clone_and_map(struct clone_
 	sector_t len = 0, max;
 	struct dm_target_io *tio;
 
+	if (unlikely(bio_empty_barrier(bio)))
+		return __clone_and_map_empty_barrier(ci);
+
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
 		return -EIO;
@@ -847,6 +852,31 @@ static int __clone_and_map(struct clone_
 	return 0;
 }
 
+static int __clone_and_map_empty_barrier(struct clone_info *ci)
+{
+	unsigned i, j, n;
+	n = dm_table_get_num_targets(ci->map);
+	for (i = 0; i < n; i++) {
+		struct bio *clone;
+		struct dm_target *ti = dm_table_get_target(ci->map, i);
+		for (j = 0; j < ti->num_flush_requests; j++) {
+			struct dm_target_io *tio = alloc_tio(ci->md);
+			tio->io = ci->io;
+			tio->ti = ti;
+			memset(&tio->info, 0, sizeof(tio->info));
+			tio->info.flush_request = j;
+
+			clone = bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
+			__bio_clone(clone, ci->bio);
+			clone->bi_destructor = dm_bio_destructor;
+
+			__map_bio(ti, clone, tio);
+		}
+	}
+	ci->sector_count = 0;
+	return 0;
+}
+
 /*
  * Split the bio into several clones and submit it to targets.
  */
@@ -874,6 +904,8 @@ static void __split_and_process_bio(stru
 	ci.io->md = md;
 	ci.sector = bio->bi_sector;
 	ci.sector_count = bio_sectors(bio);
+	if (unlikely(bio_empty_barrier(bio)))
+		ci.sector_count = 1;
 	ci.idx = bio->bi_idx;
 
 	start_io_acct(ci.io);
