From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] dm writecache: optimize superblock write
Date: Mon, 24 Feb 2020 10:20:34 +0100
Message-ID: <20200224092054.372276200@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-writecache-use-fua.patch
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

If we write a superblock in writecache_flush, we don't need to set bit and
scan the bitmap for it - we can just write the superblock directly. Also,
we can set the flag REQ_FUA on the write bio, so that we don't need to
submit a flush bio afterwards.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-02-24 10:19:14.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-02-24 10:19:14.000000000 +0100
@@ -508,6 +508,34 @@ static void ssd_commit_flushed(struct dm
 	memset(wc->dirty_bitmap, 0, wc->dirty_bitmap_size);
 }
 
+static void ssd_commit_superblock(struct dm_writecache *wc)
+{
+	int r;
+	struct dm_io_region region;
+	struct dm_io_request req;
+
+	region.bdev = wc->ssd_dev->bdev;
+	region.sector = 0;
+	region.count = PAGE_SIZE;
+
+	if (unlikely(region.sector + region.count > wc->metadata_sectors))
+		region.count = wc->metadata_sectors - region.sector;
+
+	region.sector += wc->start_sector;
+
+	req.bi_op = REQ_OP_WRITE;
+	req.bi_op_flags = REQ_SYNC | REQ_FUA;
+	req.mem.type = DM_IO_VMA;
+	req.mem.ptr.vma = (char *)wc->memory_map;
+	req.client = wc->dm_io;
+	req.notify.fn = NULL;
+	req.notify.context = NULL;
+
+	r = dm_io(&req, 1, &region, NULL);
+	if (unlikely(r))
+		writecache_error(wc, r, "error writing superblock");
+}
+
 static void writecache_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 {
 	if (WC_MODE_PMEM(wc))
@@ -757,8 +785,10 @@ static void writecache_flush(struct dm_w
 
 	wc->seq_count++;
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
-	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
-	writecache_commit_flushed(wc, false);
+	if (WC_MODE_PMEM(wc))
+		writecache_commit_flushed(wc, false);
+	else
+		ssd_commit_superblock(wc);
 
 	wc->overwrote_committed = false;
 
