From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: bdev_stack_limits wrapper and DM topology
	fixes
Date: Fri, 8 Jan 2010 19:01:45 -0500
Message-ID: <20100109000145.GB21439@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
	<yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
	<20100106132508.GA3589@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100106132508.GA3589@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Martin,

On Wed, Jan 06 2010 at  8:25am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Jan 06 2010 at  3:39am -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
>
> > You'll notice that bdev_stack_limits takes a sector offset as argument.
> > I have a patch that I intend to push at a later date that will convert
> > the remaining stacking functions to take soft sector offsets instead of
> > bytes.  I deal with the appropriate conversion in the alignment
> > calculation.  That way we avoid the blk_off_t goo entirely and it makes
> > the difference between absolute offsets and alignment offsets crystal
> > clear.
> 
> Looks good.  But you're missing the EXPORT_SYMBOL(bdev_stack_limits)

In that you're carrying the dm_set_device_limits() change as part of
this patch:
http://oss.oracle.com/git/?p=mkp/linux-2.6.git;a=commit;h=f3bc9c611895

Any chance you'd shepherd this revised patch to Jens?  It includes
various DM topology cleanups that we've discussed as well as the
EXPORT_SYMBOL(bdev_stack_limits).

The dm_set_device_limits DMWARN() cleanup is the line after your 
sector change so it'd require coordination.  I'm purposely displaying
the 'start' in bytes because all other topology limit values in that
DMWARN are in bytes.  [and yes it's > 80-char, linus is OK with that now
if it "makes sense"]

The 2nd and 3rd hunks of the dm-table.c changes respectively offer
another topology DMWARN cleanup and the removal of the alignment_offset
and misaligned resets that we discussed extensively.

If you'd rather not take those 2 hunks I can queue them with Alasdair
but I figured we could just add them to this patch.

Let me know, thanks.


From: Martin K. Petersen <martin.petersen@oracle.com>

block: bdev_stack_limits wrapper and DM topology fixes

DM does not want to know about partition offsets.  Add a partition-aware
wrapper that DM can use when stacking block devices.

Also remove the clearing of alignment_offset and misaligned in
dm_table_set_restrictions().  Adjust some misleading topology DMWARN
messages too.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G. Kergon <agk@redhat.com>
---
 block/blk-settings.c   |   22 ++++++++++++++++++++++
 drivers/md/dm-table.c  |   20 +++++---------------
 include/linux/blkdev.h |    2 ++
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d52d4ad..0d8de4e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -631,6 +631,28 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 EXPORT_SYMBOL(blk_stack_limits);
 
 /**
+ * bdev_stack_limits - adjust queue limits for stacked drivers
+ * @t:	the stacking driver limits (top device)
+ * @bdev:  the component block_device (bottom)
+ * @start:  first data sector within component device
+ *
+ * Description:
+ *    Merges queue limits for a top device and a block_device.  Returns
+ *    0 if alignment didn't change.  Returns -1 if adding the bottom
+ *    device caused misalignment.
+ */
+int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
+		      sector_t start)
+{
+	struct request_queue *bq = bdev_get_queue(bdev);
+
+	start += get_start_sect(bdev);
+
+	return blk_stack_limits(t, &bq->limits, start << 9);
+}
+EXPORT_SYMBOL(bdev_stack_limits);
+
+/**
  * disk_stack_limits - adjust queue limits for stacked drivers
  * @disk:  MD/DM gendisk (top)
  * @bdev:  the underlying block device (bottom)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index be62547..4b22feb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -503,16 +503,15 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-		DMWARN("%s: target device %s is misaligned: "
+	if (bdev_stack_limits(limits, bdev, start) < 0)
+		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
 		       dm_device_name(ti->table->md), bdevname(bdev, b),
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
 		       q->limits.alignment_offset,
-		       (unsigned long long) start << 9);
-
+		       (unsigned long long) start << SECTOR_SHIFT);
 
 	/*
 	 * Check if merge fn is supported.
@@ -1026,9 +1025,9 @@ combine_limits:
 		 * for the table.
 		 */
 		if (blk_stack_limits(limits, &ti_limits, 0) < 0)
-			DMWARN("%s: target device "
+			DMWARN("%s: adding target device "
 			       "(start sect %llu len %llu) "
-			       "is misaligned",
+			       "caused an alignment inconsistency",
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
@@ -1080,15 +1079,6 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
 	/*
-	 * Each target device in the table has a data area that should normally
-	 * be aligned such that the DM device's alignment_offset is 0.
-	 * FIXME: Propagate alignment_offsets up the stack and warn of
-	 *	  sub-optimal or inconsistent settings.
-	 */
-	limits->alignment_offset = 0;
-	limits->misaligned = 0;
-
-	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
 	q->limits = *limits;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9b98173..70b7ede 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -938,6 +938,8 @@ extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_default_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
+extern int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
+			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 			      sector_t offset);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
