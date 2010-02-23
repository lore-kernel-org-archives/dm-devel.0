From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when
	requeueing io
Date: Tue, 23 Feb 2010 14:52:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1002231429210.29863@hs20-bc2-1.build.redhat.com>
References: <20100219163257.186977438@kvm.kroah.org>
	<4B815A3D.9040402@canonical.com> <4B825982.3060606@ct.jp.nec.com>
	<20100223175331.GE560@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100223175331.GE560@agk-dp.fab.redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 23 Feb 2010, Alasdair G Kergon wrote:

> > >>  		spin_unlock(q->queue_lock);
> > >> -		map_request(ti, rq, md);
> > >> +		if (map_request(ti, rq, md))
> > >> +			goto requeued;
> > >>  		spin_lock_irq(q->queue_lock);
> 
> > In the current device-mapper code, I would like to go with
> > spin_unlock/lock here.
> > However, there was a case to enable irq in map_requst() for request
> > allocation, and this spin_lock_irq was a work-around for the case.
> > Now, there is no such case in the device-mapper code, so spin_lock should
> > be enough here.  But I'm still using spin_lock_irq for safeness, since
> > there might be some more cases to enable irq during request submission
> > to underlying devices.

Either map_requst() may enable irqs --- then you should enable them with 
spin_unlock_irq (then, you'd have to review all the callers of 
dm_request_fn that they are fine with enabling irqs).

Or map_request() must not enable irqs --- and then there is already a bug 
and there is no point in using "spin_lock_irq" for safeness, because it 
doesn't fix the bug (the interrupt may come anyway, before spin_lock_irq).

> I don't understand this.
> 
> Are you saying that sometimes this fn is called with local interrupts disabled
> and other times with them still enabled?
> 
> If they are sometimes left enabled, and the unlock() leaves them alone,
> then the lock_irq disables them,  what piece of code then reenables them?
> 
> Surely this code can only be working if local interrupts are always 
> disabled prior to entry?
> 
> Alasdair

Another problem:
dm_request_fn can be called in an interrupt context, I scanned it for 
calling process-context functions and found:

It may call rq_completed (either directly, via
dm_request_fn->map_request->dm_kill_unmapped_request->dm_complete_request
->dm_done->dm_end_request->dm_put) or indirectly, when the request is
completed from host controller interrupt. And dm_put is a process_context 
function.

I believe it doesn't cause a real crash, because dm_put is called in 
dm_blk_close, thus there is always at least one reference. When the device 
is closed with dm_blk_close, there should be no requests on it.

But it is simply a logic error to call a process-context function from 
an interrupt context. I'd remove those dm_get/dm_put from 
request-based-dm --- they are not needed anyway, as long as there are 
requests, the "mapped_device" structure can't disappear.

You can apply this (in 2.6.34-rc1) to catch all the errorneous users of 
dm_put.

Mikulas

---

Catch errorneous calls of dm_put from an interrupt context.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.33-rc8-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.33-rc8-fast.orig/drivers/md/dm.c	2010-02-23 20:45:31.000000000 +0100
+++ linux-2.6.33-rc8-fast/drivers/md/dm.c	2010-02-23 20:46:10.000000000 +0100
@@ -2188,6 +2188,7 @@ void dm_put(struct mapped_device *md)
 	struct dm_table *map;
 
 	BUG_ON(test_bit(DMF_FREEING, &md->flags));
+	might_sleep();
 
 	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
 		map = dm_get_live_table(md);
