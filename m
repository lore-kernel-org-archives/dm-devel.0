From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: implement no-clone optimization
Date: Fri, 15 Feb 2019 09:09:16 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1902150901230.14993@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190214150106.703894360@debian-a64.vm>
	<20190214155552.GA10827@redhat.com>
	<alpine.LRH.2.02.1902141125520.16727@file01.intranet.prod.int.rdu2.redhat.com>
	<20190214170119.GA15261@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190214170119.GA15261@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 14 Feb 2019, Mike Snitzer wrote:

> On Thu, Feb 14 2019 at 11:54am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > > x86-64, 2x six-core
> > > > /dev/ram0					2449MiB/s
> > > > /dev/mapper/lin 5.0-rc without optimization	1970MiB/s
> > > > /dev/mapper/lin 5.0-rc with optimization	2238MiB/s
> > > > 
> > > > arm64, quad core:
> > > > /dev/ram0					457MiB/s
> > > > /dev/mapper/lin 5.0-rc without optimization	325MiB/s
> > > > /dev/mapper/lin 5.0-rc with optimization	364MiB/s
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > > Nice performance improvement.  But each device should have its own
> > > mempool for dm_noclone + front padding.  So it should be wired into
> > > dm_alloc_md_mempools().
> > 
> > We don't need to use mempools - if the slab allocation fails, we fall back 
> > to the cloning path that has mempools.
> 
> But the implementation benefits from each DM device having control over
> any extra memory it'd like to use for front padding.  Same as is done
> now for the full-blown DM core with cloning.

If the machine is out of memory, you alredy have much more serious 
problems to deal with - attempting to optimize I/O by 13% doesn't make 
sense.

> > > It is fine if you don't actually deal with supporting per-bio-data in 
> > > this patch, but a follow-on patch to add support for noclone-based 
> > > per-bio-data shouldn't be expected to refactor the location of the 
> > > mempool allocation (module vs per-device granularity).
> > > 
> > > Mike
> > 
> > I tried to use per-bio-data and other features - and it makes the 
> > structure dm_noclone and function noclone_endio grow:
> > 
> > #define DM_NOCLONE_MAGIC 9693664
> > struct dm_noclone {
> > 	struct mapped_device *md;
> > 	struct dm_target *ti;
> > 	struct bio *bio;
> > 	struct bvec_iter orig_bi_iter;
> > 	bio_end_io_t *orig_bi_end_io;
> > 	void *orig_bi_private;
> > 	unsigned long start_time;
> > 	/* ... per-bio data ... */
> > 	/* DM_NOCLONE_MAGIC */
> > };
> > 
> > And this growth degrades performance on linear target - from 2238MiB/s to 
> > 2145MiB/s.
> 
> It shouldn't if done properly.. for linear there wouldn't be any growth.

That means variable structure length depending on target?

Other targets are so slow that they don't need this optimization at all - 
for example dm-thin has 80 - 110MiB/s for the same use case - an 
optimization that improves performance of linear by 13% has no effect 
here.

If we had a target that performs as well as linear or striped, this 
optimization could be enabled for it.

Mikulas
