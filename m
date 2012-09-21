From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 21/26] block: Convert some code to
 bio_for_each_segment_all()
Date: Thu, 20 Sep 2012 17:50:35 -0700
Message-ID: <20120921005035.GO5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-22-git-send-email-koverstreet@google.com>
 <20120921003832.GY7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120921003832.GY7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 05:38:32PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:32PM -0700, Kent Overstreet wrote:
> > A few places in the code were either open coding or using the wrong
> > version - fix.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> > ---
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -921,7 +921,7 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
> >  	if (unlikely(!bvecs))
> >  		return;
> >  
> > -	bio_for_each_segment(bvec, bio, i) {
> > +	bio_for_each_segment_all(bvec, bio, i) {
> 
> I don't get this conversion.  Why is this necessary?

Not necessary, just a consistency thing - this bio is a clone that md
owns (and the clone was trimmed, so we know bi_idx is 0).

Also, it wasn't an issue here but after the patch that introduces the
bvec iter it's no longer possible to modify the biovec through
bio_for_each_segment_all() - it doesn't increment a pointer to the
current bvec, you pass in a struct bio_vec (not a pointer) which is
updated with what the current biovec would be (taking into account
bi_bvec_done and bi_size).

So because of that it is IMO more worthwhile to be consistent about
bio_for_each_segment()/bio_for_each_segment_all() usage.

Suppose I should stick all that in the patch description.
