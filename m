From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: fix pool target flags that control discard
Date: Mon, 26 Mar 2012 15:56:14 -0400
Message-ID: <20120326195613.GB6029@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-11-git-send-email-ejt@redhat.com>
	<20120323123747.GB16214@agk-dp.fab.redhat.com>
	<20120323215502.GB11054@redhat.com> <20120326141520.GA24249@ubuntu>
	<20120326153341.GA4022@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120326153341.GA4022@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 26 2012 at 11:33am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Mar 26 2012 at 10:15am -0400,
> Joe Thornber <thornber@redhat.com> wrote:
> 
> > On Fri, Mar 23, 2012 at 05:55:02PM -0400, Mike Snitzer wrote:
> > > On Fri, Mar 23 2012 at  8:37am -0400,
> > > Alasdair G Kergon <agk@redhat.com> wrote:
> > > 
> > > > On Fri, Mar 16, 2012 at 03:22:34PM +0000, Joe Thornber wrote:
> > > > > +      'ignore_discard': disable discard support
> > > > > +      'no_discard_passdown': don't pass discards down to the underlying data device
> > > > 
> > > > If someone reloads the pool target changing either of these options, how do connected
> > > > thin targets pick up the change?  If they don't pick it up automatically, how do you
> > > > determine whether they did or didn't pick it up - is that internal state not
> > > > exposed to userspace yet?
> > > 
> > > Here are various fixes for dm_thin-add-pool-target-flags-to-control-discard.patch
> > > 
> > > o wire up 'discard_passdown' so that it does control whether or not the
> > >   discard is passed to the pool's underlying data device
> > 
> > This already works, see test_{enable,disable}_passdown() tests here:
> > 
> >   https://github.com/jthornber/thinp-test-suite/blob/master/discard_tests.rb
> > 
> > You've got to remember that there are 2 different interacting targets:
> > 
> >  i) discard enabled in the 'thin' target will cause mappings to be removed from the btree.
> > 
> >  ii) discard enabled in the 'pool' device will cause discards to be passed down.
> > 
> > The following logic is in the pool_ctr:
> > 
> >         if (pf.discard_enabled && pf.discard_passdown) {
> >                 ti->discards_supported = 1;
> >                 ti->num_discard_requests = 1;
> >         }
> 
> We reasoned through this already, your code did work.  But for the
> benefit of others this is why it worked:
> 
> thin will process_discard() via bio being deferring in thin_bio_map() --
> provided pf.discard_enabled.  Then thin will pass the discard on to the
> pool device regardless of pf.discard_passdown.  dm-core will then drop
> the discard because ti->num_discard_requests is 0; but that results in
> -EOPNOTSUPP.
> 
> Thing is, we don't want to return -EOPNOTSUPP if passdown was disabled.
> So I think my change is an improvement (because process_prepared_discard
> will now properly bio_endio(m->bio, 0) the discard).
> 
> > > o disallow disabling discards if a pool was already configured with
> > >   discards enabled (the default)
> > >   - justification is inlined in the code
> > >   - required pool_ctr knowing whether pool was created or not; so added
> > >     'created' flag to __pool_find()
> > 
> > ack, this needs fixing.
> 
> We've discussed that it is easier to just disallow changing discard
> configuration.  And that there was a bug in my early return.  So you'll
> be sending a follow-up fixup patch.

Here is a fixup patch that builds on what Alasdair already has staged
in dm_thin-add-pool-target-flags-to-control-discard.patch

I've added comments to help explain the subtlety of the initial thinp
discard code.

---
 drivers/md/dm-thin.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

Index: linux/drivers/md/dm-thin.c
===================================================================
--- linux.orig/drivers/md/dm-thin.c
+++ linux/drivers/md/dm-thin.c
@@ -1972,19 +1972,20 @@ static int pool_ctr(struct dm_target *ti
 
 	/*
 	 * 'pool_created' reflects whether this is the first table load.
-	 * Discard support is not allowed to be disabled after initial load.
-	 * Disabling it would require a pool reload to trigger thin device
-	 * changes (e.g. ti->discards_supported and QUEUE_FLAG_DISCARD).
+	 * Top level discard support is not allowed to be changed after
+	 * initial load.  This would require a pool reload to trigger thin
+	 * device changes.
 	 */
-	if (!pool_created && !pf.discard_enabled && pool->pf.discard_enabled) {
+	if (!pool_created && pf.discard_enabled != pool->pf.discard_enabled) {
 		ti->error = "Discard support cannot be disabled once enabled";
 		r = -EINVAL;
-		goto out_free_pt;
+		goto out_flags_changed;
 	}
 
 	/*
 	 * If discard_passdown was enabled verify that the data device
-	 * supports discards.  Disable discard_passdown if not.
+	 * supports discards.  Disable discard_passdown if not; otherwise
+	 * -EOPNOTSUPP will be returned.
 	 */
 	if (pf.discard_passdown) {
 		struct request_queue *q = bdev_get_queue(data_dev->bdev);
@@ -2001,8 +2002,18 @@ static int pool_ctr(struct dm_target *ti
 	pt->low_water_blocks = low_water_blocks;
 	pt->pf = pf;
 	ti->num_flush_requests = 1;
-	if (pf.discard_enabled) {
+	/*
+	 * Only need to enable discards if the pool should pass
+	 * them down to the data device.  The thin device's discard
+	 * processing will cause mappings to be removed from the btree.
+	 */
+	if (pf.discard_enabled && pf.discard_passdown) {
 		ti->num_discard_requests = 1;
+		/*
+		 * Setting 'discards_supported' circumvents the normal
+		 * stacking of discard limits (this keeps the pool and
+		 * thin devices' discard limits consistent).
+		 */
 		ti->discards_supported = 1;
 	}
 	ti->private = pt;
@@ -2014,6 +2025,8 @@ static int pool_ctr(struct dm_target *ti
 
 	return 0;
 
+out_flags_changed:
+	__pool_dec(pool);
 out_free_pt:
 	kfree(pt);
 out:
@@ -2408,6 +2421,9 @@ static int pool_merge(struct dm_target *
 
 static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
 {
+	/*
+	 * FIXME: these limits may be incompatible with the pool's data device
+	 */
 	limits->max_discard_sectors = pool->sectors_per_block;
 
 	/*
