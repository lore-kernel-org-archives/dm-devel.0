From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/26] md: Convert md_trim_bio() to use bio_advance()
Date: Wed, 26 Sep 2012 21:41:37 -0700
Message-ID: <20120927044137.GC29160@moria.home.lan>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-6-git-send-email-koverstreet@google.com>
 <20120926103827.4d880cf4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120926103827.4d880cf4-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Sep 26, 2012 at 10:38:27AM +1000, NeilBrown wrote:
> On Mon, 24 Sep 2012 15:34:45 -0700 Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> wrote:
> 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> > ---
> >  drivers/md/md.c | 19 +++++--------------
> >  1 file changed, 5 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 7a2b079..51ce48c 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -190,25 +190,16 @@ void md_trim_bio(struct bio *bio, int offset, int size)
> >  	struct bio_vec *bvec;
> >  	int sofar = 0;
> >  
> > -	size <<= 9;
> >  	if (offset == 0 && size == bio->bi_size)
> >  		return;
> 
> Safer to leave the "size <<= 9" where it is, otherwise that condition will
> always fail.

Whoops, moving that certainly didn't make sense. Thanks!
