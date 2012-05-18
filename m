From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/13] block: Kill bi_destructor
Date: Fri, 18 May 2012 15:21:30 -0700
Message-ID: <20120518222130.GC32300@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <de05855cf0fa4800cfab7e8340f106dccc7a75a1.1337308722.git.koverstreet@google.com>
 <20120518162142.GH19388@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120518162142.GH19388-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 09:21:42AM -0700, Tejun Heo wrote:
> Hello,
> 
> > @@ -417,8 +409,11 @@ void bio_put(struct bio *bio)
> >  
> >  		if (bio->bi_pool)
> >  			bio_free(bio, bio->bi_pool);
> > -		else
> > -			bio->bi_destructor(bio);
> > +		else {
> > +			if (bio_integrity(bio))
> > +				bio_integrity_free(bio, fs_bio_set);
> > +			kfree(bio);
> 
> if {
> } else {
> }
> 
> And wouldn't it be better to make bio_free() handle kfreeing too?

That'd kind of change the semantics of bio_free() - but I suppose it'd
make sense.

I'm not terribly happy with how the bio integrity data belongs to
fs_bio_set for kmalloced bios. Maybe I'll change that at some point.
