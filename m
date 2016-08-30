From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: Fix error with too large bios
Date: Tue, 30 Aug 2016 08:19:46 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1608300813280.9336@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.11.1608102050200.10662@mail.ewheeler.net> <alpine.LRH.2.02.1608131342250.3291@file01.intranet.prod.int.rdu2.redhat.com> <20160814000740.GA5317@redhat.com> <alpine.LRH.2.02.1608151245120.13026@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.11.1608181742260.10662@mail.ewheeler.net> <alpine.LRH.2.02.1608251426590.26645@file01.intranet.prod.int.rdu2.redhat.com> <24746705-a3af-e634-e675-f2214b6cf356@kernel.dk> <20160826140501.GA1061@redhat.com>
 <alpine.LRH.2.02.1608271102560.14465@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVP36-XU4J0D2xgvPBqvEMC6oGfXbbF8aGB0Rj-J10SizA@mail.gmail.com> <alpine.LRH.2.02.1608291752340.29067@file01.intranet.prod.int.rdu2.redhat.com>
 <CACVXFVOP6BkgTbWOmMrc6tJ_ekEanKWwRaGmBFXyz+mVwCukFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CACVXFVOP6BkgTbWOmMrc6tJ_ekEanKWwRaGmBFXyz+mVwCukFQ@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Eric Wheeler <dm-devel@lists.ewheeler.net>, Christoph Hellwig <hch@lst.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, johnstonj.public@codenest.com, linux-block <linux-block@vger.kernel.org>
List-Id: dm-devel.ids



On Tue, 30 Aug 2016, Ming Lei wrote:

> On Tue, Aug 30, 2016 at 5:57 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> > On Mon, 29 Aug 2016, Ming Lei wrote:
> >
> >> On Sat, Aug 27, 2016 at 11:09 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> >
> >> > But this patch won't work for device mapper, blk_bio_segment_split is
> >> > called from blk_queue_split and device mapper doesn't use blk_queue_split
> >> > (it can't because it frees queue->bio_split).
> >> >
> >> > We still need these two patches:
> >> > https://www.redhat.com/archives/dm-devel/2016-May/msg00211.html
> >> > https://www.redhat.com/archives/dm-devel/2016-May/msg00210.html
> >>
> >> About the 2nd patch, it might not be good enough because in theory
> >> a small size bio still may include big bvecs, such as, each bvec points
> >> to 512byte buffer, so strictly speaking the bvec number should
> >> be checked instead of bio size.
> >>
> >> Ming Lei
> >
> > This is not a problem.
> 
> I meant the following code in your 2nd patch:
> 
> + if (unlikely(bio->bi_iter.bi_size > BIO_MAX_SIZE) &&
> +    (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD | REQ_WRITE)) == REQ_WRITE)
> + dm_accept_partial_bio(bio, BIO_MAX_SIZE >> SECTOR_SHIFT);
> 
> And the check on .bi_size may not work.

kcryptd_crypt_write_convert calls:
crypt_alloc_buffer(io, io->base_bio->bi_iter.bi_size)

crypt_alloc_buffer does:
unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);

So, if io->base_bio->bi_iter.bi_size <= BIO_MAX_SIZE, then nr_iovecs will 
be less or equal than BIO_MAX_PAGES and the function bio_alloc_bioset will 
succeed.

(BTW. BIO_MAX_SIZE was removed in the current kernel, we should use 
(BIO_MAX_PAGES << PAGE_SHIFT) instead).

Mikulas
