From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: add topology support
Date: Fri, 12 Jun 2009 00:17:57 -0400
Message-ID: <20090612041757.GA19697@redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
	<20090610211235.GF25088@redhat.com>
	<yq1k53j68wj.fsf@sermon.lab.mkp.net>
	<20090610230804.GR647@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090610230804.GR647@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Jun 10 2009 at  7:08pm -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Wed, Jun 10, 2009 at 06:06:36PM -0400, Martin K. Petersen wrote:
> > The default limits should all be set by the block layer when setting up
> > the request queue.  So my reason for inquiring was to figure out whether
> > check_for_valid_limits() actually makes any difference?
>  
> I renamed that badly-named function earlier to:
>   init_valid_queue_limits()
> 
> It should also really be shared with block/.
> 
> What's going on is that LVM prepares the new tables it wants to
> build up a device stack in advance, then if everything has worked,
> makes them all go live.
> 
> The validation has to happen during the first phase - backing out
> the change to the device stack upon a failure is easier then as
> we have not yet reached the commit point of the transaction.
> The operation making the new stack live if at all possible must not
> fail, because that comes within the commit logic and would make recovery
> much trickier.
> 
> In dm terms, this means we have two tables - called 'live' and
> 'inactive'.  The first phase sets up inactive tables on all the stacked
> devices involved in the transaction and that is when all the memory
> needed is allocated and the validation occurs.  The second phase then
> makes the inactive table live and discards the previously-live table.
> The two tables are independent: the old queue limits on the dm device
> are discarded and replaced by the newly-calculated ones.
> 
> Currently those limits are calculated in phase one, but we should see
> about delaying this limit combination code (which should alway succeed)
> until phase two (which gives userspace code more freedom in its use of
> the interface).

Alasdair,

I've attempted to implement your suggested change of moving the
combining of limits from stage1 (dmsetup load) to stage2 (dmsetup 
resume).

- moved combining the limits for the DM table into stage2
  (dm_table_set_restrictions). 
- init_valid_queue_limits() was removed in favor of Martin's
  blk_set_default_limits()

But the following still establishes each target device's limits during
stage1 (dm_set_device_limits).  I don't see a way to avoid this given
that we only know the table's target devices (and associated bdev and
request_queue) through each target's ctr():

stage1 (dmsetup load)
---------------------
all necessary validation is at table load time
=> dm-ioctl.c:table_load 
   => dm-table.c:dm_table_create
   => dm-ioctl.c:populate_table
      -> dm-table.c:dm_table_add_target
      	 -> tgt->type->ctr()
	    -> dm-table.c:dm_get_device
	       -> dm-table.c:dm_set_device_limits
	       	  -> blk_stack_limits(ti, bdev->q->limits)
		     [NOTE: changed to: ti->limits = q->limits below]
		     [NOTE: this copy can't be delayed, need
		      access to target's bdev; only available through
		      ctr's params]
	 -> BEFORE: blk_stack_limits(table, ti->limits)
	    [NOTE: now delayed, moved to dm_table_set_restrictions]
      -> dm-table.c:dm_table_complete
      	 -> BEFORE: init_valid_queue_limits(table->limits)
	    [NOTE: now delayed, moved to dm_table_set_restrictions]
	    [NOTE: changed call to blk_set_default_limits]

stage2 (dmsetup resume)
-----------------------
swap_table: (use dm_table_set_restrictions hook)
1) inits table limits
2) iterates all target devices, stack limits
3) copies table limits to queue limits

=> dm.c:dm_swap_table
   -> dm.c:__bind
   -> dm-table.c:dm_table_set_restrictions

---
 drivers/md/dm-table.c |   60 ++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 40 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -492,9 +492,8 @@ void dm_set_device_limits(struct dm_targ
 		return;
 	}
 
-	if (blk_stack_limits(&ti->limits, &q->limits, 0) < 0)
-		DMWARN("%s: target device %s is misaligned",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+	/* Copy queue_limits from underlying device */
+	ti->limits = q->limits;
 
 	/*
 	 * Check if merge fn is supported.
@@ -643,34 +642,6 @@ int dm_split_args(int *argc, char ***arg
 	return 0;
 }
 
-static void init_valid_queue_limits(struct queue_limits *limits)
-{
-	if (!limits->max_sectors)
-		limits->max_sectors = SAFE_MAX_SECTORS;
-	if (!limits->max_hw_sectors)
-		limits->max_hw_sectors = SAFE_MAX_SECTORS;
-	if (!limits->max_phys_segments)
-		limits->max_phys_segments = MAX_PHYS_SEGMENTS;
-	if (!limits->max_hw_segments)
-		limits->max_hw_segments = MAX_HW_SEGMENTS;
-	if (!limits->logical_block_size)
-		limits->logical_block_size = 1 << SECTOR_SHIFT;
-	if (!limits->physical_block_size)
-		limits->physical_block_size = 1 << SECTOR_SHIFT;
-	if (!limits->io_min)
-		limits->io_min = 1 << SECTOR_SHIFT;
-	if (!limits->max_segment_size)
-		limits->max_segment_size = MAX_SEGMENT_SIZE;
-	if (!limits->seg_boundary_mask)
-		limits->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
-	if (!limits->bounce_pfn)
-		limits->bounce_pfn = -1;
-	/*
-	 * The other fields (alignment_offset, io_opt, misaligned)
-	 * hold 0 from the kzalloc().
-	 */
-}
-
 /*
  * Impose necessary and sufficient conditions on a devices's table such
  * that any incoming bio which respects its logical_block_size can be
@@ -788,12 +759,6 @@ int dm_table_add_target(struct dm_table 
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
-	if (blk_stack_limits(&t->limits, &tgt->limits, 0) < 0)
-		DMWARN("%s: target device (start sect %llu len %llu) "
-		       "is misaligned",
-		       dm_device_name(t->md),
-		       (unsigned long long) tgt->begin,
-		       (unsigned long long) tgt->len);
 	return 0;
 
  bad:
@@ -836,8 +801,6 @@ int dm_table_complete(struct dm_table *t
 	int r = 0;
 	unsigned int leaf_nodes;
 
-	init_valid_queue_limits(&t->limits);
-
 	r = validate_hardware_logical_block_alignment(t);
 	if (r)
 		return r;
@@ -958,8 +921,25 @@ no_integrity:
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
-	 * Copy table's limits to the DM device's request_queue
+	 * Initialize table's queue_limits and merge each underlying
+	 * device's queue_limits with it
+	 */
+	struct dm_target *uninitialized_var(ti);
+	unsigned i = 0;
+
+	blk_set_default_limits(&t->limits);
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+		(void)blk_stack_limits(&t->limits, &ti->limits, 0);
+	}
+
+	/*
+	 * Each target device in the table has a data area that is aligned
+	 * (via LVM2) so the DM device's alignment_offset should be 0.
 	 */
+	t->limits.alignment_offset = 0;
+
+	/* Copy table's queue_limits to the DM device's request_queue */
 	q->limits = t->limits;
 
 	if (t->limits.no_cluster)
