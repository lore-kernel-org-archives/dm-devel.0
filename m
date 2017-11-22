From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: new patchset to eliminate DM's use of BIOSET_NEED_RESCUER
Date: Tue, 21 Nov 2017 21:32:03 -0500
Message-ID: <20171122023203.GA20417@redhat.com>
References: <87poe13rmm.fsf@notabene.neil.brown.name>
 <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com>
 <87a7zg31vx.fsf@notabene.neil.brown.name>
 <20171121013533.GA14520@redhat.com>
 <20171121121049.GA17014@redhat.com>
 <20171121124311.GA17243@redhat.com>
 <20171121194709.GA18903@redhat.com>
 <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
 <20171121225119.GA19630@redhat.com>
 <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 21 2017 at  8:21pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 21 Nov 2017, Mike Snitzer wrote:
> 
> > On Tue, Nov 21 2017 at  4:23pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > This is not correct:
> > > 
> > >    2206 static void dm_wq_work(struct work_struct *work)
> > >    2207 {
> > >    2208         struct mapped_device *md = container_of(work, struct mapped_device, work);
> > >    2209         struct bio *bio;
> > >    2210         int srcu_idx;
> > >    2211         struct dm_table *map;
> > >    2212
> > >    2213         if (!bio_list_empty(&md->rescued)) {
> > >    2214                 struct bio_list list;
> > >    2215                 spin_lock_irq(&md->deferred_lock);
> > >    2216                 list = md->rescued;
> > >    2217                 bio_list_init(&md->rescued);
> > >    2218                 spin_unlock_irq(&md->deferred_lock);
> > >    2219                 while ((bio = bio_list_pop(&list)))
> > >    2220                         generic_make_request(bio);
> > >    2221         }
> > >    2222
> > >    2223         map = dm_get_live_table(md, &srcu_idx);
> > >    2224
> > >    2225         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
> > >    2226                 spin_lock_irq(&md->deferred_lock);
> > >    2227                 bio = bio_list_pop(&md->deferred);
> > >    2228                 spin_unlock_irq(&md->deferred_lock);
> > >    2229
> > >    2230                 if (!bio)
> > >    2231                         break;
> > >    2232
> > >    2233                 if (dm_request_based(md))
> > >    2234                         generic_make_request(bio);
> > >    2235                 else
> > >    2236                         __split_and_process_bio(md, map, bio);
> > >    2237         }
> > >    2238
> > >    2239         dm_put_live_table(md, srcu_idx);
> > >    2240 }
> > > 
> > > You can see that if we are in dm_wq_work in __split_and_process_bio, we 
> > > will not process md->rescued list.
> > 
> > Can you elaborate further?  We cannot be "in dm_wq_work in
> > __split_and_process_bio" simultaneously.  Do you mean as a side-effect
> > of scheduling away from __split_and_process_bio?
> > 
> > The more detail you can share the better.
> 
> Suppose this scenario:
> 
> * dm_wq_work calls __split_and_process_bio

Right, I later realized this was the call chain you were referring to.
Not sure how I missed it the first time around.

> * __split_and_process_bio eventually reaches the function snapshot_map
> * snapshot_map attempts to take the snapshot lock
> 
> * the snapshot lock could be released only if some bios submitted by the 
> snapshot driver to the underlying device complete
> * the bios submitted to the underlying device were already offloaded by 
> some other task and they are waiting on the list md->rescued
> * the bios waiting on md->rescued are not processed, because dm_wq_work is 
> blocked in snapshot_map (called from __split_and_process_bio)

SO you're saying the case that Neil doesn't think should happen:
https://lkml.org/lkml/2017/11/21/658
...can happen.

> > > The processing of md->rescued is also wrong - bios for different devices 
> > > must be offloaded to different helper threads, so that processing a bio 
> > > for a lower device doesn't depend on processing a bio for a higher device. 
> > > If you offload all the bios on current->bio_list to the same thread, the 
> > > bios still depend on each other and the deadlock will still happen.
> > 
> > Commit 325738403 ("dm: revise 'rescue' strategy for bio-based bioset
> > allocations") speaks to this with:
> > 
> > "Note that only current->bio_list[0] is offloaded.  current->bio_list[1]
> > contains bios that were scheduled *before* the current one started, so
> > they must have been submitted from higher up the stack, and we cannot be
> > waiting for them here (thanks to the "dm: ensure bio submission follows
> > a depth-first tree walk" commit).  Also, we now rescue *all* bios on the
> > list as there is nothing to be gained by being more selective."
> 
> I think you are right - if we only offload current->bio_list[0], then 
> mixing of dependent bios on the offloaded list won't happen.
> 
> > And again: this patchset passes your dm-snapshot deadlock test.  Is
> > that test somehow lacking?
> 
> With your patchset, the deadlock would happen only if bios are queued on 
> &md->deferred - and that happens only in case of resume or if we are 
> processing REQ_PREFLUSH with non-zero data size.
> 
> So, the simple test that I wrote doesn't trigger it, but a more complex 
> test involving REQ_PREFLUSH could.

Makes sense.  But I need to think further about _why_ bios submitted to
the snapshot driver's underlying device would end up on md->rescued
(like you suggested above).  Again, Neil thinks it not possible.  Neil
said:
"they will not be recursive calls, so nothing will be added to
current->bio_list[0] and nothing will be moved to md->rescued.  Each
generic_make_request() will completely submit the request in the lower
level devel."

Mike
