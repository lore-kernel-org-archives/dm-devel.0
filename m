Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947CF211A20
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 06:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142495; cv=none; b=OTo7Q+FR1QcOnFa66TOzb/jYIi6bqn2x5NKr6Tp/irJVJlNM6R8ID2KVcbQ03rF+rJMku9iPvIaI2ZI0/EKc3SAKExx/gINZlnyQRxT48prsb7Jwm+Ek1FBcQh2i2/3x8XET6Da/pIPvIRE6n2kAOXfSTJqYcJJQ2aTlSwagmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142495; c=relaxed/simple;
	bh=KIeqCI1rQ9xEoTnMFgzrPuDOkPsFLF9qmyeXIjCapD8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o81VlcW4eq6EJKMsUUk0D1GidY1JWRJ0hSec3lCVOaExbP+doX8gY8t94Hgr/i9cz15W/pd7IZZF39gK4eglBY1FnDTyztUPhE1IW3vLmnRXGzOHE+yv7p2ZKb/gwVWPFrNMeS92v3IKYKVHi3Wh1DZMM41R8JS9nK0QUEnB07w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZP9Gc6R7yz4f3jt8
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 81E3C1A13CE
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 14:14:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S11;
	Fri, 28 Mar 2025 14:14:50 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2 07/14] md/md-llbitmap: implement hidden disk to manage bitmap IO
Date: Fri, 28 Mar 2025 14:08:46 +0800
Message-Id: <20250328060853.4124527-8-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S11
X-Coremail-Antispam: 1UD129KBjvJXoWxuw15ury3Kr4kAF43GryxAFb_yoW3AFWxpF
	W3X3W5Kr4rJrn3Ww17JrW7AFyFqr4DJr92qFZ7ua4S9r1jyrZIgF48GFy8Aws8WrnrCFnr
	JFs8K34rGw48XFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Bitmap is stored in each member disk, the old bitmap implementation is
allocating memory and managing data by itself, read and write will
attach the allocated page to bio for member disks, and a bitmap level
spinlock is used for synchronization

For llbitmap, a hidden disk, named mdxxx_bitmap, is created for bitmap, see
details in llbitmap_add_disk(). And a file is created as well to manage
bitmap IO for this disk. Read/write bitmap will be converted to buffer
IO to this file.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 238 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1f97b6868279..bbd8a7c99577 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -56,8 +56,16 @@
  *   unwritten blocks.
  * - After resync is done, change state from Syncing to Dirty first, in case
  *   Startwrite happen before the state is Clean.
+ *
+ * ##### Bitmap IO
+ *
+ * A hidden disk, named mdxxx_bitmap, is created for bitmap, see details in
+ * llbitmap_add_disk(). And a file is created as well to manage bitmap IO for
+ * this disk, see details in llbitmap_open_disk(). Read/write bitmap is
+ * converted to buffer IO to this file.
  */
 
+#define BITMAP_MAX_SECTOR (128 * 2)
 #define BITMAP_MAX_PAGES 32
 #define BITMAP_SB_SIZE 1024
 
@@ -135,6 +143,13 @@ struct llbitmap {
 	__u64	events_cleared;
 };
 
+struct llbitmap_bio {
+	struct md_rdev *rdev;
+	struct bio bio;
+};
+
+static struct workqueue_struct *md_llbitmap_io_wq;
+
 static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
 	[BitUnwritten] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone},
 	[BitClean] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitUnwritten, BitNeedSync},
@@ -254,3 +269,226 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 
 	return state;
 }
+
+static void llbitmap_end_write(struct bio *bio)
+{
+	struct bio *parent = bio->bi_private;
+	struct llbitmap_bio *llbitmap_bio;
+	struct md_rdev *rdev;
+
+	if (bio->bi_status == BLK_STS_OK) {
+		WRITE_ONCE(parent->bi_status, BLK_STS_OK);
+	} else {
+		llbitmap_bio = container_of(bio, struct llbitmap_bio, bio);
+		rdev = llbitmap_bio->rdev;
+
+		pr_err("%s: %s: bitmap write failed for %pg\n", __func__,
+		       mdname(rdev->mddev), rdev->bdev);
+		md_error(rdev->mddev, rdev);
+	}
+
+	bio_put(bio);
+	bio_endio(parent);
+}
+
+static void md_llbitmap_retry_read(struct llbitmap *llbitmap, struct bio *bio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&llbitmap->retry_lock, flags);
+	bio_list_add(&llbitmap->retry_list, bio);
+	queue_work(md_llbitmap_io_wq, &llbitmap->retry_work);
+	spin_unlock_irqrestore(&llbitmap->retry_lock, flags);
+}
+
+static void llbitmap_end_read(struct bio *bio)
+{
+	struct bio *parent = bio->bi_private;
+	struct llbitmap_bio *llbitmap_bio;
+	struct llbitmap *llbitmap;
+	struct md_rdev *rdev;
+
+	if (bio->bi_status == BLK_STS_OK) {
+		WRITE_ONCE(parent->bi_status, BLK_STS_OK);
+		bio_put(bio);
+		bio_endio(parent);
+		return;
+	}
+
+	llbitmap_bio = container_of(bio, struct llbitmap_bio, bio);
+	rdev = llbitmap_bio->rdev;
+	pr_err("%s: %s: bitmap read failed for %pg\n", __func__,
+	       mdname(rdev->mddev), rdev->bdev);
+	md_error(rdev->mddev, rdev);
+	bio_put(bio);
+	md_llbitmap_retry_read(llbitmap, parent);
+}
+
+static void md_llbitmap_retry_fn(struct work_struct *work)
+{
+	struct llbitmap *llbitmap =
+		container_of(work, struct llbitmap, retry_work);
+	struct mddev *mddev = llbitmap->mddev;
+	struct md_rdev *rdev;
+	struct bio *bio;
+
+again:
+	spin_lock_irq(&llbitmap->retry_lock);
+	bio = bio_list_pop(&llbitmap->retry_list);
+	spin_unlock_irq(&llbitmap->retry_lock);
+
+	if (!bio)
+		return;
+
+	rdev_for_each(rdev, mddev) {
+		struct llbitmap_bio *llbitmap_bio;
+		struct bio *new;
+
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+			continue;
+
+		new = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
+				      &llbitmap->bio_set);
+		new->bi_iter.bi_sector = bio->bi_iter.bi_sector +
+					 rdev->sb_start +
+					 mddev->bitmap_info.offset;
+		new->bi_opf |= REQ_SYNC | REQ_IDLE | REQ_META;
+		new->bi_private = bio;
+		new->bi_end_io = llbitmap_end_read;
+
+		llbitmap_bio = container_of(new, struct llbitmap_bio, bio);
+		llbitmap_bio->rdev = rdev;
+
+		submit_bio_noacct(new);
+		goto again;
+	}
+}
+
+static void llbitmap_submit_bio(struct bio *bio)
+{
+	struct mddev *mddev = bio->bi_bdev->bd_disk->private_data;
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct llbitmap_bio *llbitmap_bio;
+	struct md_rdev *rdev;
+	struct bio *new;
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH))
+		bio->bi_opf &= ~REQ_PREFLUSH;
+
+	if (!bio_sectors(bio)) {
+		bio_endio(bio);
+		return;
+	}
+
+	/* status will be cleared if any member disk IO succeed */
+	bio->bi_status = BLK_STS_IOERR;
+
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+			continue;
+
+		new = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
+				      &llbitmap->bio_set);
+		new->bi_iter.bi_sector = bio->bi_iter.bi_sector +
+					 rdev->sb_start +
+					 mddev->bitmap_info.offset;
+		new->bi_opf |= REQ_SYNC | REQ_IDLE | REQ_META;
+
+		llbitmap_bio = container_of(new, struct llbitmap_bio, bio);
+		llbitmap_bio->rdev = rdev;
+		bio_inc_remaining(bio);
+		new->bi_private = bio;
+
+		if (bio_data_dir(bio) == WRITE) {
+			new->bi_end_io = llbitmap_end_write;
+			new->bi_opf |= REQ_FUA;
+			submit_bio_noacct(new);
+			continue;
+		}
+
+		new->bi_end_io = llbitmap_end_read;
+		submit_bio_noacct(new);
+		break;
+	}
+
+	bio_endio(bio);
+}
+
+const struct block_device_operations llbitmap_fops = {
+	.owner = THIS_MODULE,
+	.submit_bio = llbitmap_submit_bio,
+};
+
+static int llbitmap_add_disk(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	struct gendisk *disk = blk_alloc_disk(&mddev->gendisk->queue->limits,
+					      NUMA_NO_NODE);
+	int ret;
+
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
+
+	sprintf(disk->disk_name, "%s_bitmap", mdname(mddev));
+	disk->flags |= GENHD_FL_HIDDEN;
+	disk->fops = &llbitmap_fops;
+
+	ret = add_disk(disk);
+	if (ret) {
+		put_disk(disk);
+		return ret;
+	}
+
+	set_capacity(disk, BITMAP_MAX_SECTOR);
+	disk->private_data = mddev;
+	llbitmap->bitmap_disk = disk;
+	return 0;
+}
+
+static void llbitmap_del_disk(struct llbitmap *llbitmap)
+{
+	struct gendisk *disk = llbitmap->bitmap_disk;
+
+	if (!disk)
+		return;
+
+	llbitmap->bitmap_disk = NULL;
+	del_gendisk(disk);
+	put_disk(disk);
+}
+
+static int llbitmap_open_disk(struct llbitmap *llbitmap)
+{
+	struct gendisk *disk = llbitmap->bitmap_disk;
+	struct file *bitmap_file;
+
+	bitmap_file = bdev_file_alloc(disk->part0,
+				      BLK_OPEN_READ | BLK_OPEN_WRITE);
+	if (IS_ERR(bitmap_file))
+		return PTR_ERR(bitmap_file);
+
+	/* corresponding to the blkdev_put_no_open() from blkdev_release() */
+	get_device(disk_to_dev(disk));
+
+	bitmap_file->f_flags |= O_LARGEFILE;
+	bitmap_file->f_mode |= FMODE_CAN_ODIRECT;
+	bitmap_file->f_mapping = disk->part0->bd_mapping;
+	bitmap_file->f_wb_err = filemap_sample_wb_err(bitmap_file->f_mapping);
+
+	/* not actually opened, let blkdev_release() know */
+	bitmap_file->private_data = ERR_PTR(-ENODEV);
+	llbitmap->bitmap_file = bitmap_file;
+	return 0;
+}
+
+static void llbitmap_close_disk(struct llbitmap *llbitmap)
+{
+	struct file *bitmap_file = llbitmap->bitmap_file;
+
+	if (!bitmap_file)
+		return;
+
+	llbitmap->bitmap_file = NULL;
+	fput(bitmap_file);
+}
+
-- 
2.39.2

