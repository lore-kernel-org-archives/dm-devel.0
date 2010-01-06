From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Wed, 06 Jan 2010 03:39:12 -0500
Message-ID: <yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100106051605.GB21438@redhat.com> (Mike Snitzer's message of
	"Wed, 6 Jan 2010 00:16:06 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> BTW, the other related concern Alasdair had was that DM shouldn't
Mike> need to know to add the start of the partition to the 'offset' it
Mike> passes to blk_stack_limits() -- sees it as a layering violation.

Mike> I went over the fact that the 'struct queue_limits' was added to
Mike> abstract out the limit stacking in a way that DM could use too.
Mike> Without passing asymmetric types for the 'top' and 'bottom' device
Mike> to blk_stack_limits(), e.g.:

I don't particularly care about the symmetry.  The current set of
arguments were first and foremost there to meet DM's needs.  I don't
think you had access to the bdev at the right time when we originally
came up with this.

However, there are other subsystems that need to stack without an
associated block_device.  So instead of changing blk_stack_limits I
propose we use the wrapper below.

You'll notice that bdev_stack_limits takes a sector offset as argument.
I have a patch that I intend to push at a later date that will convert
the remaining stacking functions to take soft sector offsets instead of
bytes.  I deal with the appropriate conversion in the alignment
calculation.  That way we avoid the blk_off_t goo entirely and it makes
the difference between absolute offsets and alignment offsets crystal
clear.

Alasdair, if you are OK with the approach below I propose you give an
Acked-by: and then we can feed the patch through Jens instead of dealing
with a clunky two-stage merge this late in the .33 game.



block: bdev_stack_limits wrapper

DM does not want to know about partition offsets.  Add a partition-aware
wrapper that DM can use when stacking block devices.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d52d4ad..4b43e14 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -631,6 +631,27 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
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
+
+/**
  * disk_stack_limits - adjust queue limits for stacked drivers
  * @disk:  MD/DM gendisk (top)
  * @bdev:  the underlying block device (bottom)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index be62547..e0866a0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -503,7 +503,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
+	if (bdev_stack_limits(limits, bdev, start) < 0)
 		DMWARN("%s: target device %s is misaligned: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
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
