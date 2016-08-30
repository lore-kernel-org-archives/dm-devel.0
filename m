From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: Fix error with too large bios
Date: Tue, 30 Aug 2016 18:27:45 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1608301825540.10943@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1608151245120.13026@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.11.1608181742260.10662@mail.ewheeler.net> <alpine.LRH.2.02.1608251426590.26645@file01.intranet.prod.int.rdu2.redhat.com> <24746705-a3af-e634-e675-f2214b6cf356@kernel.dk>
 <20160826140501.GA1061@redhat.com> <alpine.LRH.2.02.1608271102560.14465@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVP36-XU4J0D2xgvPBqvEMC6oGfXbbF8aGB0Rj-J10SizA@mail.gmail.com> <alpine.LRH.2.02.1608291752340.29067@file01.intranet.prod.int.rdu2.redhat.com>
 <CACVXFVOP6BkgTbWOmMrc6tJ_ekEanKWwRaGmBFXyz+mVwCukFQ@mail.gmail.com> <alpine.LRH.2.02.1608300813280.9336@file01.intranet.prod.int.rdu2.redhat.com> <20160830205732.GA53993@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160830205732.GA53993@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>, Eric Wheeler <dm-devel@lists.ewheeler.net>, Christoph Hellwig <hch@lst.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, johnstonj.public@codenest.com, linux-block <linux-block@vger.kernel.org>
List-Id: dm-devel.ids



On Tue, 30 Aug 2016, Mike Snitzer wrote:

> On Tue, Aug 30 2016 at  8:19P -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Tue, 30 Aug 2016, Ming Lei wrote:
> > 
> > > On Tue, Aug 30, 2016 at 5:57 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > >
> > > >
> > > > On Mon, 29 Aug 2016, Ming Lei wrote:
> > > >
> > > >> On Sat, Aug 27, 2016 at 11:09 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > >> >
> > > >> > But this patch won't work for device mapper, blk_bio_segment_split is
> > > >> > called from blk_queue_split and device mapper doesn't use blk_queue_split
> > > >> > (it can't because it frees queue->bio_split).
> > > >> >
> > > >> > We still need these two patches:
> > > >> > https://www.redhat.com/archives/dm-devel/2016-May/msg00211.html
> > > >> > https://www.redhat.com/archives/dm-devel/2016-May/msg00210.html
> > > >>
> > > >> About the 2nd patch, it might not be good enough because in theory
> > > >> a small size bio still may include big bvecs, such as, each bvec points
> > > >> to 512byte buffer, so strictly speaking the bvec number should
> > > >> be checked instead of bio size.
> > > >>
> > > >> Ming Lei
> > > >
> > > > This is not a problem.
> > > 
> > > I meant the following code in your 2nd patch:
> > > 
> > > + if (unlikely(bio->bi_iter.bi_size > BIO_MAX_SIZE) &&
> > > +    (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD | REQ_WRITE)) == REQ_WRITE)
> > > + dm_accept_partial_bio(bio, BIO_MAX_SIZE >> SECTOR_SHIFT);
> > > 
> > > And the check on .bi_size may not work.
> > 
> > kcryptd_crypt_write_convert calls:
> > crypt_alloc_buffer(io, io->base_bio->bi_iter.bi_size)
> > 
> > crypt_alloc_buffer does:
> > unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
> > 
> > So, if io->base_bio->bi_iter.bi_size <= BIO_MAX_SIZE, then nr_iovecs will 
> > be less or equal than BIO_MAX_PAGES and the function bio_alloc_bioset will 
> > succeed.
> > 
> > (BTW. BIO_MAX_SIZE was removed in the current kernel, we should use 
> > (BIO_MAX_PAGES << PAGE_SHIFT) instead).
> 
> Is this revised patch OK with you?

Drop that "#ifdef CONFIG_BCACHE". Anyone should be allowed to create a big 
bio, not just bcache.

That one test has no performance impact, there is no need to hide it 
behind #ifdef.

Mikulas

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Tue, 30 Aug 2016 16:38:42 -0400
> Subject: [PATCH] dm crypt: fix error with too large bcache bios
> 
> When dm-crypt processes writes, it allocates a new bio in
> crypt_alloc_buffer().  The bio is allocated from a bio set and it can
> have at most BIO_MAX_PAGES vector entries, however the incoming bio can be
> larger if it was allocated by bcache.  If the incoming bio is larger,
> bio_alloc_bioset() fails and an error is returned.
> 
> To avoid the error, we test for a too large bio in the function
> crypt_map() and use dm_accept_partial_bio() to split the bio.
> dm_accept_partial_bio() trims the current bio to the desired size and
> asks DM core to send another bio with the rest of the data.
> 
> This fix is wrapped with a check for CONFIG_BCACHE because there
> currently isn't any other code that generates too large bios.  So unless
> bcache is configured there is no point wasting time making this check.
> 
> Signed-off-by: Mikulas Patocka <mpatocka redhat com>
> Cc: stable@vger.kernel.org # v3.16+
> ---
>  drivers/md/dm-crypt.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index eedba67..743f548 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1924,6 +1924,12 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_REMAPPED;
>  	}
>  
> +#ifdef CONFIG_BCACHE
> +	if (unlikely(bio->bi_iter.bi_size > (BIO_MAX_PAGES << PAGE_SHIFT)) &&
> +	    bio_data_dir(bio) == WRITE)
> +		dm_accept_partial_bio(bio, ((BIO_MAX_PAGES << PAGE_SHIFT) >> SECTOR_SHIFT));
> +#endif
> +
>  	io = dm_per_bio_data(bio, cc->per_bio_data_size);
>  	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
>  	io->ctx.req = (struct skcipher_request *)(io + 1);
> -- 
> 2.7.4 (Apple Git-66)
> 
