From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] new patchset to eliminate DM's use of
 BIOSET_NEED_RESCUER
Date: Wed, 22 Nov 2017 13:24:33 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com>
References: <149776047907.23258.8058071140236879834.stgit@noble> <20170618184143.GA10920@kernel.dk> <87poe13rmm.fsf@notabene.neil.brown.name> <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com> <87a7zg31vx.fsf@notabene.neil.brown.name>
 <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com> <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com> <20171121225119.GA19630@redhat.com>
 <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com> <87bmjv0xos.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87bmjv0xos.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Wed, 22 Nov 2017, NeilBrown wrote:

> On Tue, Nov 21 2017, Mikulas Patocka wrote:
> 
> > On Tue, 21 Nov 2017, Mike Snitzer wrote:
> >
> >> On Tue, Nov 21 2017 at  4:23pm -0500,
> >> Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> 
> >> > This is not correct:
> >> > 
> >> >    2206 static void dm_wq_work(struct work_struct *work)
> >> >    2207 {
> >> >    2208         struct mapped_device *md = container_of(work, struct mapped_device, work);
> >> >    2209         struct bio *bio;
> >> >    2210         int srcu_idx;
> >> >    2211         struct dm_table *map;
> >> >    2212
> >> >    2213         if (!bio_list_empty(&md->rescued)) {
> >> >    2214                 struct bio_list list;
> >> >    2215                 spin_lock_irq(&md->deferred_lock);
> >> >    2216                 list = md->rescued;
> >> >    2217                 bio_list_init(&md->rescued);
> >> >    2218                 spin_unlock_irq(&md->deferred_lock);
> >> >    2219                 while ((bio = bio_list_pop(&list)))
> >> >    2220                         generic_make_request(bio);
> >> >    2221         }
> >> >    2222
> >> >    2223         map = dm_get_live_table(md, &srcu_idx);
> >> >    2224
> >> >    2225         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
> >> >    2226                 spin_lock_irq(&md->deferred_lock);
> >> >    2227                 bio = bio_list_pop(&md->deferred);
> >> >    2228                 spin_unlock_irq(&md->deferred_lock);
> >> >    2229
> >> >    2230                 if (!bio)
> >> >    2231                         break;
> >> >    2232
> >> >    2233                 if (dm_request_based(md))
> >> >    2234                         generic_make_request(bio);
> >> >    2235                 else
> >> >    2236                         __split_and_process_bio(md, map, bio);
> >> >    2237         }
> >> >    2238
> >> >    2239         dm_put_live_table(md, srcu_idx);
> >> >    2240 }
> >> > 
> >> > You can see that if we are in dm_wq_work in __split_and_process_bio, we 
> >> > will not process md->rescued list.
> >> 
> >> Can you elaborate further?  We cannot be "in dm_wq_work in
> >> __split_and_process_bio" simultaneously.  Do you mean as a side-effect
> >> of scheduling away from __split_and_process_bio?
> >> 
> >> The more detail you can share the better.
> >
> > Suppose this scenario:
> >
> > * dm_wq_work calls __split_and_process_bio
> > * __split_and_process_bio eventually reaches the function snapshot_map
> > * snapshot_map attempts to take the snapshot lock
> >
> > * the snapshot lock could be released only if some bios submitted by the 
> > snapshot driver to the underlying device complete
> > * the bios submitted to the underlying device were already offloaded by 
> > some other task and they are waiting on the list md->rescued
> > * the bios waiting on md->rescued are not processed, because dm_wq_work is 
> > blocked in snapshot_map (called from __split_and_process_bio)
> 
> Yes, I think you are right. 
> 
> I think the solution is to get rid of the dm_offload() infrastructure
> and make it not necessary.
> i.e. discard my patches
>     dm: prepare to discontinue use of BIOSET_NEED_RESCUER
> and
>     dm: revise 'rescue' strategy for bio-based bioset allocations
> 
> And build on "dm: ensure bio submission follows a depth-first tree walk"
> which was written after those and already makes dm_offload() less
> important.
> 
> Since that "depth-first" patch, every request to the dm device, after
> the initial splitting, allocates just one dm_target_io structure, and
> makes just one __map_bio() call, and so will behave exactly the way
> generic_make_request() expects and copes with - thus avoiding awkward
> dependencies and deadlocks.  Except....
> 
> a/ If any target defines ->num_write_bios() to return >1,
>    __clone_and_map_data_bio() will make multiple calls to alloc_tio()
>    and __map_bio(), which might need rescuing.
>    But no target defines num_write_bios, and none have since it was
>    removed from dm-cache 4.5 years ago.
>    Can we discard num_write_bios??
> 
> b/ If any target sets any of num_{flush,discard,write_same,write_zeroes}_bios
>    to a value > 1, then __send_duplicate_bios() will also make multiple
>    calls to alloc_tio() and __map_bio().
>    Some do.
>      dm-cache-target:  flush=2
>      dm-snap: flush=2
>      dm-stripe: discard, write_same, write_zeroes all set to 'stripes'.
> 
> These will only be a problem if the second (or subsequent) alloc_tio()
> blocks waiting for an earlier allocation to complete.  This will only
> be a problem if multiple threads are each trying to allocate multiple
> dm_target_io from the same bioset at the same time.
> This is rare and should be easier to address than the current
> dm_offload() approach. 
> One possibility would be to copy the approach taken by
> crypt_alloc_buffer() which needs to allocate multiple entries from a
> mempool.
> It first tries the with GFP_NOWAIT.  If that fails it take a mutex and
> tries with GFP_NOIO.  This mean only one thread will try to allocate
> multiple bios at once, so there can be no deadlock.
> 
> Below are two RFC patches.  The first removes num_write_bios.
> The second is incomplete and makes a stab are allocating multiple bios
> at once safely.
> A third would be needed to remove dm_offload() etc... but I cannot quite
> fit that in today - must be off.
> 
> Thanks,
> NeilBrown

Another problem is this:

struct bio *b = bio_clone_bioset(bio, GFP_NOIO, md->queue->bio_split);
bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
bio_chain(b, bio);

What if it blocks because the bioset is exhausted?

The code basically builds a chain of bios of unlimited length (suppose for 
example a case when we are splitting on every sector boundary, so there 
will be one bio for every sector in the original bio), it could exhaust 
the bioset easily.

It would be better to use mechanism from md-raid that chains all the 
sub-bios to the same master bio and doesn't create long chains of bios:

        if (max_sectors < bio_sectors(bio)) {
                struct bio *split = bio_split(bio, max_sectors,
                                              gfp, conf->bio_split);
                bio_chain(split, bio);
                generic_make_request(bio);
                bio = split;
                r1_bio->master_bio = bio;
                r1_bio->sectors = max_sectors;
        }

Mikulas
