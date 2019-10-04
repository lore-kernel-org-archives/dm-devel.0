From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-snapshot: Reimplement the cow limit.
Date: Thu, 3 Oct 2019 22:44:41 -0400
Message-ID: <20191004024438.GA3250@lobo>
References: <alpine.LRH.2.02.1910020614190.973@file01.intranet.prod.int.rdu2.redhat.com>
	<b63d2544-64fd-de75-15c1-d85be0cd887e@arrikto.com>
	<alpine.LRH.2.02.1910031601030.26094@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1910031601030.26094@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Nikos Tsironis <ntsironis@arrikto.com>, Alasdair Kergon <agk@redhat.com>, guru2018@gmail.com
List-Id: dm-devel.ids

On Thu, Oct 03 2019 at  4:06P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 2 Oct 2019, Nikos Tsironis wrote:
> 
> > Hi Mikulas,
> > 
> > I agree that it's better to avoid holding any locks while waiting for
> > some pending kcopyd jobs to finish, but please see the comments below.
> > 
> > On 10/2/19 1:15 PM, Mikulas Patocka wrote:
> > > +
> > > +static bool wait_for_in_progress(struct dm_snapshot *s, bool unlock_origins)
> > > +{
> > > +	if (unlikely(s->in_progress > cow_threshold)) {
> > > +		spin_lock(&s->in_progress_wait.lock);
> > > +		if (likely(s->in_progress > cow_threshold)) {
> > > +			DECLARE_WAITQUEUE(wait, current);
> > > +			__add_wait_queue(&s->in_progress_wait, &wait);
> > > +			__set_current_state(TASK_UNINTERRUPTIBLE);
> > > +			spin_unlock(&s->in_progress_wait.lock);
> > > +			if (unlock_origins)
> > > +				up_read(&_origins_lock);
> > > +			io_schedule();
> > > +			remove_wait_queue(&s->in_progress_wait, &wait);
> > > +			return false;
> > > +		}
> > > +		spin_unlock(&s->in_progress_wait.lock);
> > > +	}
> > > +	return true;
> > >  }
> > 
> > wait_for_in_progress() doesn't take into account which chunk is written
> > and whether it has already been reallocated or it is currently
> > reallocating.
> > 
> > This means, if I am not missing something, that both origin_map() and
> > snapshot_map() might unnecessarily throttle writes that don't need any
> > COW to take place.
> 
> I know about it, but I think it's not serious problem - if there are 2048 
> outstanding I/Os the system is already heavily congested. It doesn't 
> matter if you allow a few more writes or not.
> 
> Mikulas
> 
> > For example, if we have some writes coming in, that trigger COW and
> > cause the COW limit to be reached, and then some more writes come in for
> > chunks that have already been reallocated (and before any kcopyd job
> > finishes and decrements s->in_progress), the latter writes would be
> > delayed without a reason, as they don't require any COW to be performed.
> > 
> > It seems strange that the COW throttling mechanism might also throttle
> > writes that don't require any COW.
> > 
> > Moreover, if we have reached the COW limit and we get a write for a
> > chunk that is currently reallocating we will block the thread, when we
> > could just add the bio to the origin_bios list of the pending exception
> > and move on.
> > 
> > wait_for_in_progress() could check if the exception is already
> > reallocated or is being reallocated, but the extra locking in the
> > critical path might have an adverse effect on performance, especially in
> > multi-threaded workloads. Maybe some benchmarks would help clarify that.
> > 
> > As a final note, in case the devices are slow, there might be many
> > writers waiting in s->in_progress_wait. When a kcopyd job finishes, all
> > of them will wake up and in some cases we might end up issuing more COW
> > jobs than the cow_count limit, as the accounting for new COW jobs
> > doesn't happen atomically with the check for the cow_count limit in
> > wait_for_in_progress().
> > 
> > That said, I don't think having a few more COW jobs in flight, than the
> > defined limit, will cause any issues.

Nikos,

I looked at your concern even before Mikulas replied and found it to be
valid.  But in the end I struggled to imagine how imposing extra
throttling once above the thorttle threshold would significantly impact
performance.

So when I saw Mikulas' reply he definitely reinforced my thinking.  But
please feel free to explore whether further refinement is needed.  I
think your concern about extra locking in the hotpath (to check if a
chunk already triggered an exception) was a great observation but if
such a check is done I'm hopeful it won't be _that_ costly because we'll
have already reached the cow threshold and would already be taking the
lock (as the 2nd phase of the double checked locking).

Anyway, I folded these small tweaks into Mikulas' 2nd patch:

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 560b8cb38026..4fb1a40e68a0 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1525,7 +1525,8 @@ static void account_end_copy(struct dm_snapshot *s)
 	spin_lock(&s->in_progress_wait.lock);
 	BUG_ON(!s->in_progress);
 	s->in_progress--;
-	if (likely(s->in_progress <= cow_threshold) && unlikely(waitqueue_active(&s->in_progress_wait)))
+	if (likely(s->in_progress <= cow_threshold) &&
+	    unlikely(waitqueue_active(&s->in_progress_wait)))
 		wake_up_locked(&s->in_progress_wait);
 	spin_unlock(&s->in_progress_wait.lock);
 }
@@ -1535,6 +1536,13 @@ static bool wait_for_in_progress(struct dm_snapshot *s, bool unlock_origins)
 	if (unlikely(s->in_progress > cow_threshold)) {
 		spin_lock(&s->in_progress_wait.lock);
 		if (likely(s->in_progress > cow_threshold)) {
+			/*
+			 * NOTE: this throttle doesn't account for whether
+			 * the caller is servicing an IO that will trigger a COW
+			 * so excess throttling may result for chunks not required
+			 * to be COW'd.  But if cow_threshold was reached, extra
+			 * throttling is unlikely to negatively impact performance.
+			 */
 			DECLARE_WAITQUEUE(wait, current);
 			__add_wait_queue(&s->in_progress_wait, &wait);
 			__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1955,7 +1963,8 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_KILL;
 
 	if (bio_data_dir(bio) == WRITE) {
-		while (unlikely(!wait_for_in_progress(s, false))) ;
+		while (unlikely(!wait_for_in_progress(s, false)))
+			; /* wait_for_in_progress() has slept */
 	}
 
 	down_read(&s->lock);
@@ -2538,8 +2547,8 @@ static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit)
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
 	if (o) {
-		struct dm_snapshot *s;
 		if (limit) {
+			struct dm_snapshot *s;
 			list_for_each_entry(s, &o->snapshots, list)
 				if (unlikely(!wait_for_in_progress(s, true)))
 					goto again;

and I've pushed the changes to linux-next via linux-dm.git's for-next
(with tweaked commit headers).  But if you or Mikulas find something
that would warrant destaging these changes I'd welcome that feedback.

Thanks,
Mike
