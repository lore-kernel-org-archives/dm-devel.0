From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: data corruption with 'splt' workload to XFS on DM
 cache with its 3 underlying devices being on same NVMe device
Date: Tue, 24 Jul 2018 09:07:03 -0400
Message-ID: <20180724130703.GA30804@redhat.com>
References: <20180723163357.GA29658@redhat.com>
	<e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Tue, Jul 24 2018 at  2:00am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 07/23/2018 06:33 PM, Mike Snitzer wrote:
> >Hi,
> >
> >I've opened the following public BZ:
> >https://bugzilla.redhat.com/show_bug.cgi?id=1607527
> >
> >Feel free to add comments to that BZ if you have a redhat bugzilla
> >account.
> >
> >But otherwise, happy to get as much feedback and discussion going purely
> >on the relevant lists.  I've taken ~1.5 weeks to categorize and isolate
> >this issue.  But I've reached a point where I'm getting diminishing
> >returns and could _really_ use the collective eyeballs and expertise of
> >the community.  This is by far one of the most nasty cases of corruption
> >I've seen in a while.  Not sure where the ultimate cause of corruption
> >lies (that the money question) but it _feels_ rooted in NVMe and is
> >unique to this particular workload I've stumbled onto via customer
> >escalation and then trying to replicate an rbd device using a more
> >approachable one (request-based DM multipath in this case).
> >
> I might be stating the obvious, but so far we only have considered
> request-based multipath as being active for the _entire_ device.
> To my knowledge we've never tested that when running on a partition.

True.  We only ever support mapping the partitions ontop of
request-based multipath (via dm-linear volumes created by kpartx).

> So, have you tested that request-based multipathing works on a
> partition _at all_? I'm not sure if partition mapping is done
> correctly here; we never remap the start of the request (nor bio,
> come to speak of it), so it looks as if we would be doing the wrong
> things here.
> 
> Have you checked that partition remapping is done correctly?

It clearly doesn't work.  Not quite following why but...

After running the test the partition table at the start of the whole
NVMe device is overwritten by XFS.  So likely the IO destined to the
dm-cache's "slow" (dm-mpath device on NVMe partition) was issued to the
whole NVMe device:

# pvcreate /dev/nvme1n1
WARNING: xfs signature detected on /dev/nvme1n1 at offset 0. Wipe it? [y/n]

# vgcreate test /dev/nvme1n1
# lvcreate -n slow -L 512G test
WARNING: xfs signature detected on /dev/test/slow at offset 0. Wipe it?
[y/n]: y
  Wiping xfs signature on /dev/test/slow.
  Logical volume "slow" created.

Isn't this a failing of block core's partitioning?  Why should a target
that is given the entire partition of a device need to be concerned with
remapping IO?  Shouldn't block core handle that mapping?

Anyway, yesterday I went so far as to hack together request-based
support for DM linear (because request-based DM cannot stack on
bio-based DM) .  With this, request-based linear devices instead of
conventional partitioning, I no longer see the XFS corruption when
running the test:

 drivers/md/dm-linear.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d10964d41fd7..d4a65dd20c6e 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -12,6 +12,7 @@
 #include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
+#include <linux/blk-mq.h>
 
 #define DM_MSG_PREFIX "linear"
 
@@ -24,7 +25,7 @@ struct linear_c {
 };
 
 /*
- * Construct a linear mapping: <dev_path> <offset>
+ * Construct a linear mapping: <dev_path> <offset> [<# optional params> <optional params>]
  */
 static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -57,6 +58,11 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	// FIXME: need to parse optional args
+	// FIXME: model  alloc_multipath_stage2()?
+	// Call: dm_table_set_type()
+	dm_table_set_type(ti->table, DM_TYPE_MQ_REQUEST_BASED);
+
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
@@ -113,6 +119,37 @@ static int linear_end_io(struct dm_target *ti, struct bio *bio,
 	return DM_ENDIO_DONE;
 }
 
+static int linear_clone_and_map(struct dm_target *ti, struct request *rq,
+				union map_info *map_context,
+				struct request **__clone)
+{
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	struct request *clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE,
+						BLK_MQ_REQ_NOWAIT);
+	if (IS_ERR(clone)) {
+		if (blk_queue_dying(q) || !q->mq_ops)
+			return DM_MAPIO_DELAY_REQUEUE;
+
+		return DM_MAPIO_REQUEUE;
+	}
+
+	clone->__sector = linear_map_sector(ti, rq->__sector);
+	clone->bio = clone->biotail = NULL;
+	clone->rq_disk = bdev->bd_disk;
+	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	*__clone = clone;
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static void linear_release_clone(struct request *clone)
+{
+	blk_put_request(clone);
+}
+
 static void linear_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -207,13 +244,15 @@ static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
 
 static struct target_type linear_target = {
 	.name   = "linear",
-	.version = {1, 4, 0},
-	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
+	.version = {1, 5, 0},
+	.features = DM_TARGET_IMMUTABLE | DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
 	.dtr    = linear_dtr,
 	.map    = linear_map,
 	.end_io = linear_end_io,
+	.clone_and_map_rq = linear_clone_and_map,
+	.release_clone_rq = linear_release_clone,
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
