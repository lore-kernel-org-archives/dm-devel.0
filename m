From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: new patchset to eliminate DM's use of      BIOSET_NEED_RESCUER
Date: Tue, 21 Nov 2017 23:28:38 -0500
Message-ID: <20171122042838.GB20417@redhat.com>
References: <CAMM=eLf9Vu-z1ZEsGtRoSkhpaaQXAdr8TsUYUCSmAjqrqo=W-w@mail.gmail.com>
 <87a7zg31vx.fsf@notabene.neil.brown.name>
 <20171121013533.GA14520@redhat.com>
 <20171121121049.GA17014@redhat.com>
 <20171121124311.GA17243@redhat.com>
 <20171121194709.GA18903@redhat.com>
 <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com>
 <20171121225119.GA19630@redhat.com>
 <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com>
 <87bmjv0xos.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bmjv0xos.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 21 2017 at 11:00pm -0500,
NeilBrown <neilb@suse.com> wrote:

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

Yes, FYI I've also verified that even with just the "depth-first" patch
(and dm_offload disabled) the snapshot deadlock is fixed.
 
> a/ If any target defines ->num_write_bios() to return >1,
>    __clone_and_map_data_bio() will make multiple calls to alloc_tio()
>    and __map_bio(), which might need rescuing.
>    But no target defines num_write_bios, and none have since it was
>    removed from dm-cache 4.5 years ago.
>    Can we discard num_write_bios??

Yes.

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

Great.

> From: NeilBrown <neilb@suse.com>
> Date: Wed, 22 Nov 2017 14:25:18 +1100
> Subject: [PATCH] DM: remove num_write_bios target interface.
> 
> No target provides num_write_bios and none has done
> since 2013.
> Having the possibility of num_write_bios > 1 complicates
> bio allocation.
> So remove the interface and assume there is only one bio
> needed.
> If a target ever needs more, it must provide a suitable
> bioset and allocate itself based on its particular needs.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/dm.c               | 22 ++++------------------
>  include/linux/device-mapper.h | 15 ---------------
>  2 files changed, 4 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b20febd6cbc7..8c1a05609eea 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1323,27 +1323,13 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
>  {
>  	struct bio *bio = ci->bio;
>  	struct dm_target_io *tio;
> -	unsigned target_bio_nr;
> -	unsigned num_target_bios = 1;
>  	int r = 0;
>  
> -	/*
> -	 * Does the target want to receive duplicate copies of the bio?
> -	 */
> -	if (bio_data_dir(bio) == WRITE && ti->num_write_bios)
> -		num_target_bios = ti->num_write_bios(ti, bio);
> -
> -	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
> -		tio = alloc_tio(ci, ti, target_bio_nr);
> -		tio->len_ptr = len;
> -		r = clone_bio(tio, bio, sector, *len);
> -		if (r < 0) {
> -			free_tio(tio);
> -			break;
> -		}
> +	tio = alloc_tio(ci, ti, 0);
> +	tio->len_ptr = len;
> +	r = clone_bio(tio, bio, sector, *len);
> +	if (r >= 0)
>  		__map_bio(tio);
> -	}
> -

This bit is wrong, free_tio() is needed if clone_bio() fails.  I can fix
it up though.

I'll work through your patches tomorrow.

Thanks,
Mike
