From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 04/26] block: Refactor blk_update_request()
Date: Tue, 2 Oct 2012 13:25:18 -0700
Message-ID: <20121002202518.GP26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-5-git-send-email-koverstreet@google.com>
 <20121002184359.GC3283@redhat.com>
 <20121002201014.GK26488@google.com>
 <20121002201451.GH758@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121002201451.GH758-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 04:14:51PM -0400, Vivek Goyal wrote:
> On Tue, Oct 02, 2012 at 01:10:14PM -0700, Kent Overstreet wrote:
> > On Tue, Oct 02, 2012 at 02:43:59PM -0400, Vivek Goyal wrote:
> > > On Mon, Sep 24, 2012 at 03:34:44PM -0700, Kent Overstreet wrote:
> > > > Converts it to use bio_advance(), simplifying it quite a bit in the
> > > > process.
> > > > 
> > > > Note that req_bio_endio() now always calls bio_advance() - which means
> > > > it always loops over the biovec, not just on partial completions. Don't
> > > > expect it to affect performance, but worth noting.
> > > > 
> > > > Tested it by forcing partial updates, and dumping before and after on
> > > > various bio/bvec fields when doing a partial update.
> > > > 
> > > > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > > > ---
> > > >  block/blk-core.c | 80 +++++++++-----------------------------------------------
> > > >  1 file changed, 12 insertions(+), 68 deletions(-)
> > > > 
> > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > index a17869f..a8a1a9e 100644
> > > > --- a/block/blk-core.c
> > > > +++ b/block/blk-core.c
> > > > @@ -158,20 +158,10 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
> > > >  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> > > >  		error = -EIO;
> > > >  
> > > > -	if (unlikely(nbytes > bio->bi_size)) {
> > > > -		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
> > > > -		       __func__, nbytes, bio->bi_size);
> > > > -		nbytes = bio->bi_size;
> > > > -	}
> > > > -
> > > 
> > > You are dropping this warning because nobody is calling req_bio_endio()
> > > with bytes greater than bio size in current code?
> > 
> > Not dropping it, just moved it to bio_advance()
> 
> bio_advance() is checking bio vec count and idx and not nr_bytes.

Whoops, -ENOCOFFEE... I didn't fully read that code fragment.

Yes, req_bio_endio() is only called from one place, and
blk_update_request() never calls it with nbytes > bio->bi_size (and
after the refactor it's more obviously impossible).
