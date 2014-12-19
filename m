From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Fri, 19 Dec 2014 12:14:38 -0500
Message-ID: <20141219171438.GA6347@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
	<5491F906.1090004@kernel.dk> <20141217230622.GC15390@redhat.com>
	<54943714.2040704@acm.org> <20141219153801.GA8697@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141219153801.GA8697@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, hch@infradead.org, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Fri, Dec 19 2014 at 10:38am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Dec 19 2014 at  9:32am -0500,
> Bart Van Assche <bvanassche@acm.org> wrote:
> 
> > On 12/18/14 00:06, Mike Snitzer wrote:
> > > So if you know someone with relevant blk-mq hardware who might benefit
> > > from blk-mq multipathing please point them at this code and have them
> > > report back!
> > 
> > Hello Mike,
> > 
> > Great to see that you are working on blk-mq multipathing. Unfortunately
> > a test with the SRP initiator and your dm-for-3.20-blk-mq tree merged
> > with Linus' latest tree was not successful. This is what was reported
> > when I tried to start multipathd (without call trace, followed by a
> > hard lockup):
> > 
> > =========================================================
> > [ INFO: possible irq lock inversion dependency detected ]
> > 3.18.0-debug+ #1 Tainted: G        W     
> > ---------------------------------------------------------
> > kdmwork-253:0/5347 just changed the state of lock:
> >  (&(&m->lock)->rlock){+.....}, at: [<ffffffffa080eb80>] __multipath_map.isra.15+0x40/0x1f0 [dm_multipath]
> > but this lock was taken by another, HARDIRQ-safe lock in the past:
> >  (&(&q->__queue_lock)->rlock){-.-...}
> >  
> > and interrupts could create inverse lock ordering between them.
> >  
> > other info that might help us debug this:
> >  Possible interrupt unsafe locking scenario:
> 
> This "dm: submit stacked requests in irq enabled context" commit
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20-blk-mq&id=1844ba7e2e013fa38c45d646248c517eb363e26c
> 
> changed the locking needed in the multipath target.  I altered
> __multipath_map but didn't audit elsewhere.  I'll work through it.

Hi Bart,

This patch silences the lockdep inversion splat on my testbed, but I'd
really appreciate it if you could see if it works for you since you hit
an actual hang:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1fa6f14..4bfa3d9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -390,7 +390,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	struct block_device *bdev;
 	struct dm_mpath_io *mpio;
 
-	spin_lock(&m->lock);
+	spin_lock_irq(&m->lock);
 
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
@@ -412,8 +412,14 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		/* ENOMEM, requeue */
 		goto out_unlock;
 
+	mpio = map_context->ptr;
+	mpio->pgpath = pgpath;
+	mpio->nr_bytes = nr_bytes;
+
 	bdev = pgpath->path.dev->bdev;
 
+	spin_unlock_irq(&m->lock);
+
 	if (clone) {
 		/* Old request-based interface: allocated clone is passed in */
 		clone->q = bdev_get_queue(bdev);
@@ -425,21 +431,18 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 					   rq_data_dir(rq), GFP_KERNEL);
 		if (IS_ERR(*__clone))
 			/* ENOMEM, requeue */
-			goto out_unlock;
+			return r;
 		(*__clone)->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	}
 
-	mpio = map_context->ptr;
-	mpio->pgpath = pgpath;
-	mpio->nr_bytes = nr_bytes;
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
 					      nr_bytes);
-	r = DM_MAPIO_REMAPPED;
+	return DM_MAPIO_REMAPPED;
 
 out_unlock:
-	spin_unlock(&m->lock);
+	spin_unlock_irq(&m->lock);
 
 	return r;
 }
