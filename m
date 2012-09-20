From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 10/26] block: Add submit_bio_wait(), remove from md
Date: Thu, 20 Sep 2012 16:56:43 -0700
Message-ID: <20120920235643.GQ7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-11-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-11-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:21PM -0700, Kent Overstreet wrote:
> Random cleanup - this code was duplicated and it's not really specific
> to md.
> 
> Also added the ability to return the actual error code.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -249,6 +249,7 @@ extern void bio_endio(struct bio *, int);
>  struct request_queue;
>  extern int bio_phys_segments(struct request_queue *, struct bio *);
>  
> +extern int submit_bio_wait(int rw, struct bio *bio);
>  void bio_advance(struct bio *, unsigned);

Heh, this is one of the reasons why I don't like extern on function
prototypes.  It's not necessary and people end up jumping between the
two forms.  :(

Thanks.

-- 
tejun
