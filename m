From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 10/10] md: use PAGE_SECTORS to clean up code
Date: Thu, 7 May 2020 15:51:00 +0800
Message-ID: <20200507075100.1779-11-thunder.leizhen@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
List-Id: dm-devel.ids

Execute the following shell script:

C_FILES=`find drivers/md/ -name "*.c"`

for file in $C_FILES
do
        #with brace
        sed -i 's/(PAGE_SIZE \/ 512)/PAGE_SECTORS/g' $file
        sed -i 's/(PAGE_SIZE\/512)/PAGE_SECTORS/g' $file
        sed -i 's/(PAGE_SIZE >> 9)/PAGE_SECTORS/g' $file
        sed -i 's/(PAGE_SIZE>>9)/PAGE_SECTORS/g' $file

        #without brace
        sed -i 's/PAGE_SIZE \/ 512/PAGE_SECTORS/g' $file
        sed -i 's/PAGE_SIZE\/512/PAGE_SECTORS/g' $file
        sed -i 's/PAGE_SIZE >> 9/PAGE_SECTORS/g' $file
        sed -i 's/PAGE_SIZE>>9/PAGE_SECTORS/g' $file
done

In addition, eliminate below scripts/checkpatch.pl warning:
#44: FILE: drivers/md/dm-kcopyd.c:587:
+       unsigned nr_pages = dm_div_up(job->dests[0].count, PAGE_SECTORS);

Change to "unsigned int nr_pages".

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/md/dm-kcopyd.c |  2 +-
 drivers/md/md-bitmap.c | 16 ++++++++--------
 drivers/md/md.c        |  6 +++---
 drivers/md/raid1.c     | 10 +++++-----
 drivers/md/raid10.c    | 20 ++++++++++----------
 drivers/md/raid5.c     |  4 ++--
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 1bbe4a34ef4c..ad861a3d648e 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -584,7 +584,7 @@ static int run_io_job(struct kcopyd_job *job)
 static int run_pages_job(struct kcopyd_job *job)
 {
 	int r;
-	unsigned nr_pages = dm_div_up(job->dests[0].count, PAGE_SIZE >> 9);
+	unsigned int nr_pages = dm_div_up(job->dests[0].count, PAGE_SECTORS);
 
 	r = kcopyd_get_pages(job->kc, nr_pages, &job->pages);
 	if (!r) {
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b952bd45bd6a..12ccf1c81661 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -161,7 +161,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 		    || test_bit(Bitmap_sync, &rdev->flags))
 			continue;
 
-		target = offset + index * (PAGE_SIZE/512);
+		target = offset + index * PAGE_SECTORS;
 
 		if (sync_page_io(rdev, target,
 				 roundup(size, bdev_logical_block_size(rdev->bdev)),
@@ -237,17 +237,17 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		if (mddev->external) {
 			/* Bitmap could be anywhere. */
 			if (rdev->sb_start + offset + (page->index
-						       * (PAGE_SIZE/512))
+						       * PAGE_SECTORS)
 			    > rdev->data_offset
 			    &&
 			    rdev->sb_start + offset
 			    < (rdev->data_offset + mddev->dev_sectors
-			     + (PAGE_SIZE/512)))
+			     + PAGE_SECTORS))
 				goto bad_alignment;
 		} else if (offset < 0) {
 			/* DATA  BITMAP METADATA  */
 			if (offset
-			    + (long)(page->index * (PAGE_SIZE/512))
+			    + (long)(page->index * PAGE_SECTORS)
 			    + size/512 > 0)
 				/* bitmap runs in to metadata */
 				goto bad_alignment;
@@ -259,7 +259,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 			/* METADATA BITMAP DATA */
 			if (rdev->sb_start
 			    + offset
-			    + page->index*(PAGE_SIZE/512) + size/512
+			    + page->index*PAGE_SECTORS + size/512
 			    > rdev->data_offset)
 				/* bitmap runs in to data */
 				goto bad_alignment;
@@ -268,7 +268,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		}
 		md_super_write(mddev, rdev,
 			       rdev->sb_start + offset
-			       + page->index * (PAGE_SIZE/512),
+			       + page->index * PAGE_SECTORS,
 			       size,
 			       page);
 	}
@@ -1548,14 +1548,14 @@ int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *block
 	 * pages, otherwise resync (which is very PAGE_SIZE based) will
 	 * get confused.
 	 * So call __bitmap_start_sync repeatedly (if needed) until
-	 * At least PAGE_SIZE>>9 blocks are covered.
+	 * At least PAGE_SECTORS blocks are covered.
 	 * Return the 'or' of the result.
 	 */
 	int rv = 0;
 	sector_t blocks1;
 
 	*blocks = 0;
-	while (*blocks < (PAGE_SIZE>>9)) {
+	while (*blocks < PAGE_SECTORS) {
 		rv |= __bitmap_start_sync(bitmap, offset,
 					  &blocks1, degraded);
 		offset += blocks1;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 271e8a587354..a7572b17cf2e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1736,7 +1736,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		__le64 *bbp;
 		int i;
 		int sectors = le16_to_cpu(sb->bblog_size);
-		if (sectors > (PAGE_SIZE / 512))
+		if (sectors > PAGE_SECTORS)
 			return -EINVAL;
 		offset = le32_to_cpu(sb->bblog_offset);
 		if (offset == 0)
@@ -2223,7 +2223,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	bitmap = rdev->mddev->bitmap;
 	if (bitmap && !rdev->mddev->bitmap_info.file &&
 	    rdev->sb_start + rdev->mddev->bitmap_info.offset +
-	    bitmap->storage.file_pages * (PAGE_SIZE>>9) > new_offset)
+	    bitmap->storage.file_pages * PAGE_SECTORS > new_offset)
 		return 0;
 	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
 		return 0;
@@ -8734,7 +8734,7 @@ void md_do_sync(struct md_thread *thread)
 	/*
 	 * Tune reconstruction:
 	 */
-	window = 32 * (PAGE_SIZE / 512);
+	window = 32 * PAGE_SECTORS;
 	pr_debug("md: using %dk window, over a total of %lluk.\n",
 		 window/2, (unsigned long long)max_sectors/2);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 44ffe1b6d77a..717c6e397cad 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2021,8 +2021,8 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		int success = 0;
 		int start;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
+		if (s > PAGE_SECTORS)
+			s = PAGE_SECTORS;
 		do {
 			if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
 				/* No rcu protection needed here devices
@@ -2129,7 +2129,7 @@ static void process_checks(struct r1bio *r1_bio)
 	int vcnt;
 
 	/* Fix variable parts of all bios */
-	vcnt = sectors_to_npage(r1_bio->sectors + PAGE_SIZE / 512 - 1);
+	vcnt = sectors_to_npage(r1_bio->sectors + PAGE_SECTORS - 1);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		blk_status_t status;
 		struct bio *b = r1_bio->bios[i];
@@ -2264,8 +2264,8 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		int start;
 		struct md_rdev *rdev;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
+		if (s > PAGE_SECTORS)
+			s = PAGE_SECTORS;
 
 		do {
 			sector_t first_bad;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ac4273f804e8..21bc6e33c093 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2029,7 +2029,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	fbio->bi_iter.bi_idx = 0;
 	fpages = get_resync_pages(fbio)->pages;
 
-	vcnt = sectors_to_npage(r10_bio->sectors + (PAGE_SIZE >> 9) - 1);
+	vcnt = sectors_to_npage(r10_bio->sectors + PAGE_SECTORS - 1);
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
@@ -2163,8 +2163,8 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 		sector_t addr;
 		int ok;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
+		if (s > PAGE_SECTORS)
+			s = PAGE_SECTORS;
 
 		rdev = conf->mirrors[dr].rdev;
 		addr = r10_bio->devs[0].addr + sect,
@@ -2367,8 +2367,8 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		int success = 0;
 		int start;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
+		if (s > PAGE_SECTORS)
+			s = PAGE_SECTORS;
 
 		rcu_read_lock();
 		do {
@@ -3597,7 +3597,7 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 	}
 	if (layout >> 19)
 		return -1;
-	if (chunk < (PAGE_SIZE >> 9) ||
+	if (chunk < PAGE_SECTORS ||
 	    !is_power_of_2(chunk))
 		return -2;
 	nc = layout & 255;
@@ -4632,8 +4632,8 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 
 	nr_sectors = 0;
 	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
-	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
-		struct page *page = pages[s / (PAGE_SIZE >> 9)];
+	for (s = 0 ; s < max_sectors; s += PAGE_SECTORS) {
+		struct page *page = pages[s / PAGE_SECTORS];
 		int len = (max_sectors - s) << 9;
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
@@ -4789,8 +4789,8 @@ static int handle_reshape_read_error(struct mddev *mddev,
 		int success = 0;
 		int first_slot = slot;
 
-		if (s > (PAGE_SIZE >> 9))
-			s = PAGE_SIZE >> 9;
+		if (s > PAGE_SECTORS)
+			s = PAGE_SECTORS;
 
 		rcu_read_lock();
 		while (!success) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ba00e9877f02..5b316538b9ea 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8197,7 +8197,7 @@ static int raid5_check_reshape(struct mddev *mddev)
 	if (new_chunk > 0) {
 		if (!is_power_of_2(new_chunk))
 			return -EINVAL;
-		if (new_chunk < (PAGE_SIZE>>9))
+		if (new_chunk < PAGE_SECTORS)
 			return -EINVAL;
 		if (mddev->array_sectors & (new_chunk-1))
 			/* not factor of array size */
@@ -8231,7 +8231,7 @@ static int raid6_check_reshape(struct mddev *mddev)
 	if (new_chunk > 0) {
 		if (!is_power_of_2(new_chunk))
 			return -EINVAL;
-		if (new_chunk < (PAGE_SIZE >> 9))
+		if (new_chunk < PAGE_SECTORS)
 			return -EINVAL;
 		if (mddev->array_sectors & (new_chunk-1))
 			/* not factor of array size */
-- 
2.26.0.106.g9fadedd
