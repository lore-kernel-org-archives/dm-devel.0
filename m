From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Date: Fri, 31 Aug 2012 19:23:05 -0700
Message-ID: <20120901022305.GE19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
 <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828221715.GD1048@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120828221715.GD1048-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Tue, Aug 28, 2012 at 03:17:15PM -0700, Kent Overstreet wrote:
> > Better to explain why some bio fields are re-ordered and why that
> > shouldn't make things worse cacheline-wise?
> 
> Well it may (struct bio is what, 3 or 4 cachelines now?) but even on
> ridiculous million iop devices struct bio just isn't hot enough for this
> kind of stuff to show up in the profiles... and I've done enough
> profiling to be pretty confident of that.
> 
> So um, if there was anything to say performance wise I would, but to me
> it seems more that there isn't.
> 
> (pruning struct bio would have more of an effect performance wise, which
> you know is something I'd like to do.)

Yeah, please put something like the above in the patch description.

> > > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> > > +
> > > +	if (bio_integrity(bio))
> > > +		bio_integrity_free(bio, bio->bi_pool);
> > > +
> > > +	bio_disassociate_task(bio);
> > 
> > Is this desirable?  Why?
> 
> *twitch* I should've thought more when I made that change.
> 
> It occurs to me now that we specifically talked about that and decided
> to do it the other way - when I changed that I was just looking at
> bio_free() and decided they needed to be symmetrical.
> 
> I still think they should be symmetrical, but if that's true bi_ioc and
> bi_css need to be moved, and also bio_disassociate_task() should be
> getting called from bio_free(), not bio_put().
> 
> Were you the one that added that call? I know you've been working on
> that area of the code recently. Sticking it in bio_put() instead of
> bio_free() seems odd to be, and they're completely equivalent now that
> bio_free() is only called from bio_put() (save one instance I should
> probably fix).

Maybe I botched symmetry but anyways I *suspect* it probably would be
better to keep css association across bio_reset() give the current
usages of both mechanisms.  css association indicates the ownership of
the bio which isn't likely to change while recycling the bio.

Thanks.

-- 
tejun
