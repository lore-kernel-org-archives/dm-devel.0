From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
Date: Wed, 23 May 2012 17:39:16 -0700
Message-ID: <20120524003915.GA27443@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-3-git-send-email-koverstreet@google.com>
 <4FBD7E80.4020005@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FBD7E80.4020005-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jun'ichi Nomura <j-nomura-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 09:19:12AM +0900, Jun'ichi Nomura wrote:
> Hi,
> 
> On 05/24/12 09:02, Kent Overstreet wrote:
> > @@ -1438,15 +1439,6 @@ void dm_dispatch_request(struct request *rq)
> >  }
> >  EXPORT_SYMBOL_GPL(dm_dispatch_request);
> >  
> > -static void dm_rq_bio_destructor(struct bio *bio)
> > -{
> > -	struct dm_rq_clone_bio_info *info = bio->bi_private;
> > -	struct mapped_device *md = info->tio->md;
> > -
> > -	free_bio_info(info);
> > -	bio_free(bio, md->bs);
> > -}
> > -
> >  static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
> >  				 void *data)
> >  {
> > @@ -1461,7 +1453,6 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
> >  	info->tio = tio;
> >  	bio->bi_end_io = end_clone_bio;
> >  	bio->bi_private = info;
> > -	bio->bi_destructor = dm_rq_bio_destructor;
> 
> The destructor may also be called from blk_rq_unprep_clone(),
> which just puts bio.
> So this patch will introduce a memory leak.

Well, keeping around bi_destructor solely for that reason would be
pretty lousy. Can you come up with a better solution?
