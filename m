From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: [PATCH v2] md raid0/linear: Fail BIOs if their
	underlying block device is gone
Date: Fri, 16 Aug 2019 10:34:41 -0300
Message-ID: <20190816133441.29350-1-gpiccoli@canonical.com>
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
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, gpiccoli@canonical.com, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

Currently md raid0/linear are not provided with any mechanism to validate
if an array member got removed or failed. The driver keeps sending BIOs
regardless of the state of array members. This leads to the following
situation: if a raid0/linear array member is removed and the array is
mounted, some user writing to this array won't realize that errors are
happening unless they check dmesg or perform one fsync per written file.

In other words, no -EIO is returned and writes (except direct ones) appear
normal. Meaning the user might think the wrote data is correctly stored in
the array, but instead garbage was written given that raid0 does stripping
(and so, it requires all its members to be working in order to not corrupt
data). For md/linear, writes to the available members will work fine, but
if the writes go to the missing member(s), it'll cause a file corruption
situation, whereas the portion of the writes to the missing device aren't
written effectively.

This patch proposes a small change in this behavior: we check if the block
device's gendisk is UP when submitting the BIO to the array member, and if
it isn't, we flag the md device as broken and fail subsequent write I/Os.
If the array is restored (i.e., the missing array members are back) and
the array is restarted, the flag is cleared and we can submit BIOs normally.

With this patch, the filesystem reacts much faster to the event of missing
array member: after some I/O errors, ext4 for instance aborts the journal
and prevents corruption. Without this change, we're able to keep writing
in the disk and after a machine reboot, e2fsck shows some severe fs errors
that demand fixing. This patch was tested in ext4 and xfs filesystems.

Cc: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---

v1 -> v2:
* Fail only WRITE requests (thanks Neil for the suggestion);
* Added handling for md-linear failures too (thanks Song for
the suggestion).


 drivers/md/md-linear.c | 6 ++++++
 drivers/md/md.c        | 5 +++++
 drivers/md/md.h        | 3 +++
 drivers/md/raid0.c     | 7 +++++++
 4 files changed, 21 insertions(+)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 7354466ddc90..ed2297541414 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -258,6 +258,12 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		     bio_sector < start_sector))
 		goto out_of_bounds;
 
+	if (unlikely(!(tmp_dev->rdev->bdev->bd_disk->flags & GENHD_FL_UP))) {
+		set_bit(MD_BROKEN, &mddev->flags);
+		bio_io_error(bio);
+		return true;
+	}
+
 	if (unlikely(bio_end_sector(bio) > end_sector)) {
 		/* This bio crosses a device boundary, so we have to split it */
 		struct bio *split = bio_split(bio, end_sector - bio_sector,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 24638ccedce4..ba4de55eea13 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -376,6 +376,11 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = q->queuedata;
 	unsigned int sectors;
 
+	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
+		bio_io_error(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	blk_queue_split(q, &bio);
 
 	if (mddev == NULL || mddev->pers == NULL) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 10f98200e2f8..5d7c1cad4946 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -248,6 +248,9 @@ enum mddev_flags {
 	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
 				 * without explicitly holding reconfig_mutex.
 				 */
+	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
+				 * I/O in case an array member is gone/failed.
+				 */
 };
 
 enum mddev_sb_flags {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index bf5cf184a260..ef896ee7198b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -586,6 +586,13 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 
 	zone = find_zone(mddev->private, &sector);
 	tmp_dev = map_sector(mddev, zone, sector, &sector);
+
+	if (unlikely(!(tmp_dev->bdev->bd_disk->flags & GENHD_FL_UP))) {
+		set_bit(MD_BROKEN, &mddev->flags);
+		bio_io_error(bio);
+		return true;
+	}
+
 	bio_set_dev(bio, tmp_dev->bdev);
 	bio->bi_iter.bi_sector = sector + zone->dev_start +
 		tmp_dev->data_offset;
-- 
2.22.0
