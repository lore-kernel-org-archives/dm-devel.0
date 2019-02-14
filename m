From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: implement no-clone optimization
Date: Thu, 14 Feb 2019 11:54:56 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1902141125520.16727@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190214150106.703894360@debian-a64.vm>
	<20190214155552.GA10827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190214155552.GA10827@redhat.com>
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

> On Thu, Feb 14 2019 at 10:00am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > This patch improves performance of dm-linear and dm-striped targets.
> > Device mapper copies the whole bio and passes it to the lower layer. This
> > copying may be avoided in special cases.
> > 
> > This patch changes the logic so that instead of copying the bio we
> > allocate a structure dm_noclone (it has only 4 entries), save the values
> > bi_end_io and bi_private in it, overwrite these values in the bio and pass
> > the bio to the lower block device.
> > 
> > When the bio is finished, the function noclone_endio restores te values
> > bi_end_io and bi_private and passes the bio to the original bi_end_io
> > function.
> > 
> > This optimization can only be done by dm-linear and dm-striped targets,
> > the target can op-in by setting ti->no_clone = true.
> > 
> > Performance improvement:
> > 
> > # modprobe brd rd_size=1048576
> > # dd if=/dev/zero of=/dev/ram0 bs=1M oflag=direct
> > # dmsetup create lin --table "0 2097152 linear /dev/ram0 0"
> > # fio --ioengine=psync --iodepth=1 --rw=read --bs=512 --direct=1 --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/mapper/lin
> > 
> > x86-64, 2x six-core
> > /dev/ram0					2449MiB/s
> > /dev/mapper/lin 5.0-rc without optimization	1970MiB/s
> > /dev/mapper/lin 5.0-rc with optimization	2238MiB/s
> > 
> > arm64, quad core:
> > /dev/ram0					457MiB/s
> > /dev/mapper/lin 5.0-rc without optimization	325MiB/s
> > /dev/mapper/lin 5.0-rc with optimization	364MiB/s
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Nice performance improvement.  But each device should have its own
> mempool for dm_noclone + front padding.  So it should be wired into
> dm_alloc_md_mempools().

We don't need to use mempools - if the slab allocation fails, we fall back 
to the cloning path that has mempools.

> It is fine if you don't actually deal with supporting per-bio-data in 
> this patch, but a follow-on patch to add support for noclone-based 
> per-bio-data shouldn't be expected to refactor the location of the 
> mempool allocation (module vs per-device granularity).
> 
> Mike

I tried to use per-bio-data and other features - and it makes the 
structure dm_noclone and function noclone_endio grow:

#define DM_NOCLONE_MAGIC 9693664
struct dm_noclone {
	struct mapped_device *md;
	struct dm_target *ti;
	struct bio *bio;
	struct bvec_iter orig_bi_iter;
	bio_end_io_t *orig_bi_end_io;
	void *orig_bi_private;
	unsigned long start_time;
	/* ... per-bio data ... */
	/* DM_NOCLONE_MAGIC */
};

And this growth degrades performance on linear target - from 2238MiB/s to 
2145MiB/s.

Mikulas
