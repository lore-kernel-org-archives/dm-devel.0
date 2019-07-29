From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: [PATCH] md/raid0: Fail BIOs if their underlying block
	device is gone
Date: Mon, 29 Jul 2019 16:33:59 -0300
Message-ID: <20190729193359.11040-1-gpiccoli@canonical.com>
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

Currently md/raid0 is not provided with any mechanism to validate if
an array member got removed or failed. The driver keeps sending BIOs
regardless of the state of array members. This leads to the following
situation: if a raid0 array member is removed and the array is mounted,
some user writing to this array won't realize that errors are happening
unless they check kernel log or perform one fsync per written file.

In other words, no -EIO is returned and writes (except direct ones) appear
normal. Meaning the user might think the wrote data is correctly stored in
the array, but instead garbage was written given that raid0 does stripping
(and so, it requires all its members to be working in order to not corrupt
data).

This patch proposes a small change in this behavior: we check if the block
device's gendisk is UP when submitting the BIO to the array member, and if
it isn't, we flag the md device as broken and fail subsequent I/Os. In case
the array is restored (i.e., the missing array member is back), the flag is
cleared and we can submit BIOs normally.

With this patch, the filesystem reacts much faster to the event of missing
array member: after some I/O errors, ext4 for instance aborts the journal
and prevents corruption. Without this change, we're able to keep writing
in the disk and after a machine reboot, e2fsck shows some severe fs errors
that demand fixing. This patch was tested in both ext4 and xfs
filesystems.

Cc: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---

After an attempt to change the way md/raid0 fails in case one of its
members gets removed (see [0]), we got not so great feedback from the
community and also, the change was complex and had corner cases.
One of the points which seemed to be a consensus in that attempt was
that raid0 could benefit from a way of failing faster in case a member
gets removed. This patch aims for that, in a simpler way than earlier
proposed. Any feedbacks are welcome, thanks in advance!


Guilherme


[0] lore.kernel.org/linux-block/20190418220448.7219-1-gpiccoli@canonical.com


 drivers/md/md.c    | 5 +++++
 drivers/md/md.h    | 3 +++
 drivers/md/raid0.c | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 24638ccedce4..fba49918d591 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -376,6 +376,11 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = q->queuedata;
 	unsigned int sectors;
 
+	if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
+		bio_io_error(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	blk_queue_split(q, &bio);
 
 	if (mddev == NULL || mddev->pers == NULL) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 10f98200e2f8..41552e615c4c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -248,6 +248,9 @@ enum mddev_flags {
 	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
 				 * without explicitly holding reconfig_mutex.
 				 */
+	MD_BROKEN,              /* This is used in RAID-0 only, to stop I/O
+				 * in case an array member is gone/failed.
+				 */
 };
 
 enum mddev_sb_flags {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index bf5cf184a260..58a9cc5193bf 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -586,6 +586,14 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 
 	zone = find_zone(mddev->private, &sector);
 	tmp_dev = map_sector(mddev, zone, sector, &sector);
+
+	if (unlikely(!(tmp_dev->bdev->bd_disk->flags & GENHD_FL_UP))) {
+		set_bit(MD_BROKEN, &mddev->flags);
+		bio_io_error(bio);
+		return true;
+	}
+
+	clear_bit(MD_BROKEN, &mddev->flags);
 	bio_set_dev(bio, tmp_dev->bdev);
 	bio->bi_iter.bi_sector = sector + zone->dev_start +
 		tmp_dev->data_offset;
-- 
2.22.0
