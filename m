From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Fri, 7 Aug 2015 17:30:57 -0700
Message-ID: <20150808003057.GA1811@kmo-pixel>
References: <20150731192337.GA8907@redhat.com>
 <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
 <20150731213831.GA16464@redhat.com>
 <1438412290.26596.14.camel@hasee>
 <20150801163356.GA21478@redhat.com>
 <1438581502.26596.24.camel@hasee>
 <20150804113626.GA12682@lst.de>
 <1438754604.29731.31.camel@hasee>
 <20150807073001.GA17485@lst.de>
 <1438990806.24452.8.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438990806.24452.8.camel@ssi>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Ming Lin <ming.l@ssi.samsung.com>
List-Id: dm-devel.ids

On Fri, Aug 07, 2015 at 04:40:06PM -0700, Ming Lin wrote:
> 
> On Fri, 2015-08-07 at 09:30 +0200, Christoph Hellwig wrote:
> > I'm for solution 3:
> > 
> >  - keep blk_bio_{discard,write_same}_split, but ensure we never built
> >    a > 4GB bio in blkdev_issue_{discard,write_same}.
> 
> This has problem as I mentioned in solution 1.
> We need to also make sure max discard size is of proper granularity.
> See below example.
> 
>       4G: 8388608 sectors
> UINT_MAX: 8388607 sectors
> 
> dm-thinp block size = default discard granularity = 128 sectors
> 
> blkdev_issue_discard(sector=0, nr_sectors=8388608)
> 
> 1. Only ensure bi_size not overflow
> 
> It doesn't work.
> 
> [start_sector, end_sector]
> [0, 8388607]
>     [0, 8388606], then dm-thinp splits it to 2 bios
>         [0, 8388479]
>         [8388480, 8388606] ---> this has problem in process_discard_bio(),
>                                 because the discard size(7 sectors) covers less than a block(128 sectors)
>     [8388607, 8388607] ---> same problem 
> 
> 2. Ensure bi_size not overflow and max discard size is of proper granularity

Ideally we'd get upper layers out of the business of knowing about the queue
limits at all - that was the point of the patch series, after all.

Instead of using UINT_MAX, would it work to just make the max 1 << 31 sectors?
