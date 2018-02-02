From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM TOPIC] block: extend generic biosets to allow per-device
 frontpad
Date: Fri, 2 Feb 2018 11:08:34 -0500
Message-ID: <20180202160834.GA8192@redhat.com>
References: <20180129213300.GC5744@redhat.com>
 <87zi4r29sa.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zi4r29sa.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Feb 02 2018 at  1:19am -0500,
NeilBrown <neilb@suse.com> wrote:

> On Mon, Jan 29 2018, Mike Snitzer wrote:
> 
> > I'd like to enable bio-based DM to _not_ need to clone bios.  But to do
> > so each bio-based DM target's required per-bio-data would need to be
> > provided by upper layer biosets (as opposed to the bioset DM currently
> > creates).
> >
> > So my thinking is that all system-level biosets (e.g. fs_bio_set,
> > blkdev_dio_pool) would redirect to a device specific variant bioset IFF
> > the underlying device advertises the need for a specific per-bio-data
> > payload to be provided.
> >
> > I know this _could_ become a rathole but I'd like to avoid reverting DM
> > back to the days of having to worry about managing mempools for the
> > purpose of per-io allocations.  I've grown spoiled by the performance
> > and elegance that comes with having the bio and per-bio-data allocated
> > from the same bioset.
> >
> > Thoughts?
> 
> md/raid0 remaps each bio and passes it directly down to one of several
> devices.
> I think your scheme would mean that it would need to clone each bio to
> make sure it is from the correctly sized pool.

Not sure why the md/raid0 device would need to do anything (not unless
it wanted to take advantage of this).

The model, in my head, would be that this is _not_ intended for an
arbitrary stacked MD or DM device.  So the underlying device(s) for
a DM or MD device, that wants to leverage upper layer bio_set provided
front_pad, would be a real device (e.g. NVMe, SCSI, whatever).

But if a mix of underlying drivers were used (each with unique
per-bio-data, aka front_pad, requirements) then the blk_stack_limits()
interface _could_ build that information up.  And while that pretty much
gets us all we'd need to support md/raid0 on arbitrary stacked DM or MD
volumes that isn't what I'm interested in.  But supporting an arbitrary
stacked device could be done as follow-on work.

I'm specifically looking to optimize DM's new DM_TYPE_NVME_BIO_BASED
device (see commits 22c11858e, 978e51ba3, cd02538445, etc) so that bios
are just remapped to the underlying NVMe device without cloning.  DM
core now takes care to validate that a DM_TYPE_NVME_BIO_BASED DM device
(e.g. a DM multipath device -- via "queue_mode nvme") is _only_ stacked
directly ontop of native NVMe devices.

> I suspect it could be made to work though.
> 
> 1/ have a way for the driver receiving a bio to discover how much
>    frontpad was allocated.

Yes

> 2/ require drivers to accept bios with any size of frontpad, but a
>    fast-path is taken if it is already big enough.

Yes and no, the driver really should be able to trust that the block
layer is sending it bios with adeuqate front_pad (if the device
registered its front_pad requirements).

That said, making it optional (via "hint") is likely safer from the
standpoint that it is less cut-throat given we'd be depending on the
various biosets to respect our wishes.  I just worry that having the
code for falling back to cloning, if the front_pad isn't adequate, will
defeat much of the benefit of optimizing what is intended to be a faster
fast path.

But if the bioset enhancements are implemented properly then the kernels
N biosets shouldn't need to be in doubt.  They'll all just adapt to have
N backing mempools (N being for N conflicting front_pad requirements).

> 3/ allow a block device to advertise it's preferred frontpad.

s/preferred/required/ in my mental model.

> 4/ make sure your config-change-notification mechanism can communicate
>    changes to this number.

You're referring to he notifier chain idea about restacking
queue_limits?  Yes, that'd be needed once that exists.

> 5/ gather statistics on what percentage of bios have a too-small
>    frontpad.
>
> Then start modifying places that allocate bios to use the hint,
> and when benchmarks show the percentage is high - use it to encourage
> other people to allocate better bios.

This shouldn't be needed if we were to go the route where bio_sets
dynamically select the appropriate mempool based on the front_pad
requirements advertised by the underlying device ("3/" above).

Thanks,
Mike
