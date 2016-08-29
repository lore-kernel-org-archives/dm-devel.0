From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: Fix error with too large bios
Date: Mon, 29 Aug 2016 18:01:55 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1608291757120.29067@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.11.1608102050200.10662@mail.ewheeler.net> <alpine.LRH.2.02.1608131342250.3291@file01.intranet.prod.int.rdu2.redhat.com> <20160814000740.GA5317@redhat.com> <alpine.LRH.2.02.1608151245120.13026@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.11.1608181742260.10662@mail.ewheeler.net> <alpine.LRH.2.02.1608251426590.26645@file01.intranet.prod.int.rdu2.redhat.com> <24746705-a3af-e634-e675-f2214b6cf356@kernel.dk> <20160826140501.GA1061@redhat.com>
 <alpine.LRH.2.02.1608271102560.14465@file01.intranet.prod.int.rdu2.redhat.com> <20160829181940.GA21794@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160829181940.GA21794@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Wheeler <dm-devel@lists.ewheeler.net>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, johnstonj.public@codenest.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 29 Aug 2016, Mike Snitzer wrote:

> On Sat, Aug 27 2016 at 11:09am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Fri, 26 Aug 2016, Mike Snitzer wrote:
> > 
> > > On Thu, Aug 25 2016 at  4:13pm -0400,
> > > Jens Axboe <axboe@kernel.dk> wrote:
> > > 
> > > > On 08/25/2016 12:34 PM, Mikulas Patocka wrote:
> > > > >
> > > > >Device mapper can't split the bio in generic_make_request - it frees the
> > > > >md->queue->bio_split bioset, to save one kernel thread per device. Device
> > > > >mapper uses its own splitting mechanism.
> > > > >
> > > > >So what is the final decision? - should device mapper split the big bio or
> > > > >should bcache not submit big bios?
> > > > >
> > > > >I think splitting big bios in the device mapper is better - simply because
> > > > >it is much less code than reworking bcache to split bios internally.
> > > > >
> > > > >BTW. In the device mapper, we have a layer dm-io, that was created to work
> > > > >around bio size limitations - it accepts unlimited I/O request and splits
> > > > >it to several bios. When bio size limitations are gone, we could simplify
> > > > >dm-io too.
> > > > 
> > > > The patch from Ming Lei was applied for 4.8 the other day.
> > > 
> > > See linux-block commit:
> > > 4d70dca4eadf2f block: make sure a big bio is split into at most 256 bvecs
> > > http://git.kernel.dk/cgit/linux-block/commit/?h=for-linus&id=4d70dca4eadf2f95abe389116ac02b8439c2d16c
> > 
> > But this patch won't work for device mapper, blk_bio_segment_split is 
> > called from blk_queue_split and device mapper doesn't use blk_queue_split 
> > (it can't because it frees queue->bio_split).
> > 
> > We still need these two patches:
> > https://www.redhat.com/archives/dm-devel/2016-May/msg00211.html
> > https://www.redhat.com/archives/dm-devel/2016-May/msg00210.html
> 
> I'm left wondering whether it'd be better to revert commit dbba42d8a9e
> ("dm: eliminate unused "bioset" process for each bio-based DM device")

That would create one more process per dm device.

There is no need to create another process if the bio can be split in the 
device mapper.

> And also look for other areas of DM that could leverage the block core's
> relatively new splitting capabilities.
> 
> Otherwise, we'll just be sprinking more BIO_MAX_PAGES-based splitting
> code in DM targets because DM is so "special" that it doesn't need the
> block core's splitting (even though it clearly would now benefit).

It would be possible to split bios on BIO_MAX_PAGES boundary in the dm 
core. But I checked all the dm targets and I found problem only in 
dm-crypt and dm-log-writes. So there is no need to split bio bios for the 
other targets.

> Mike

Mikulas
