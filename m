From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: check max_sectors in dm_merge_bvec  (was: Re: dm:
 max_segments=1 if merge_bvec_fn is not supported)
Date: Sat, 4 Dec 2010 14:21:29 -0500
Message-ID: <20101204192128.GA13871@redhat.com>
References: <20100306211012.GA9689@racke>
 <20100308163345.42841480@notabene.brown>
 <Pine.LNX.4.64.1003080321190.25635@hs20-bc2-1.build.redhat.com>
 <20100308131449.GA15156@racke>
 <20101204064308.GA7639@redhat.com>
 <20101204160334.GD6034@barkeeper1-xen.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101204160334.GD6034@barkeeper1-xen.linbit>
Sender: linux-kernel-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, jaxboe@fusionio.com
List-Id: dm-devel.ids

On Sat, Dec 04 2010 at 11:03am -0500,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Sat, Dec 04, 2010 at 01:43:08AM -0500, Mike Snitzer wrote:
>
> > Given dm_set_device_limits() sets q->limits->max_sectors,
> > shouldn't dm_merge_bvec() be using queue_max_sectors rather than
> > queue_max_hw_sectors?
> > 
> > blk_queue_max_hw_sectors() establishes that max_hw_sectors is the hard
> > limit and max_sectors the soft.  But AFAICT no relation is maintained
> > between the two over time (even though max_sectors <= max_hw_sectors
> > _should_ be enforced; in practice there is no blk_queue_max_sectors
> > setter that uniformly enforces as much).
> 
> Just for the record, in case someone finds this in the archives,
> and wants to backport or base his own work on this:
> 
>  A long time ago, there was no .max_hw_sectors.  Then max_hw_sectors got
>  introduced, but without accessor function.
> 
>  Before 2.6.31, there was no blk_queue_max_hw_sectors(),
>  only blk_queue_max_sectors(), which set both.
> 
>  2.6.31 introduced some blk_queue_max_hw_sectors(), which _only_ set
>  max_hw_sectors, and enforced a lower limit of BLK_DEF_MAX_SECTORS, so
>  using that only, you have not been able to actually set lower limits
>  than 512 kB. With 2.6.31 to 2.6.33, inclusive, you still need to use
>  blk_queue_max_sectors() to set your limits.
> 
>  2.6.34 finally dropped the newly introduced function again,
>  but renamed the other, so starting with 2.6.34 you need to use
>  blk_queue_max_hw_sectors(), which now basically has the function body
>  blk_queue_max_sectors() had up until 2.6.33.
> 
> > dm_set_device_limits() will set q->limits->max_sectors to <= PAGE_SIZE
> > if an underlying device has a merge_bvec_fn.  Therefore, dm_merge_bvec()
> > must use queue_max_sectors() rather than queue_max_hw_sectors() to check
> > the appropriate limit.
> 
> IMO, you should not do this.
> max_sectors is a user tunable, capped by max_hw_sectors.
> max_hw_sectors is the driver limit.
>
> Please set max_hw_sectors in dm_set_device_limits instead.

Right, good point.. will do (unless I happen upon a reason not to or
someone else shouts).

Thanks,
Mike
