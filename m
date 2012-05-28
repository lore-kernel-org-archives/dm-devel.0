From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 07/16] block: Rename bio_split() -> bio_pair_split()
Date: Mon, 28 May 2012 13:15:39 +0300
Message-ID: <4FC3504B.7000903@panasas.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-8-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337977539-16977-8-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On 05/25/2012 11:25 PM, Kent Overstreet wrote:

> This is prep work for introducing a more general bio_split()
> 
> Change-Id: Ib9c4ff691af889d26bc9ec9fb42a2f3068f34ad9
> 


Since these patches will go through Jens tree this kind of
comment can *never* be true/correct. And it is plenty unwanted
for sure.

Here:
bio_do means an operation on bio. But here we are actually operating
on a bio_pair. So rename it it to bio_pair_do.

We will later introduce a real bio_split() function that receives
a bio and splits it.

Or something like that.
Thanks
Boaz

> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

<snip>

> @@ -201,7 +201,7 @@ struct bio_pair {
>  	atomic_t			cnt;
>  	int				error;
>  };
> -extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
> +extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
>  extern void bio_pair_release(struct bio_pair *dbio);
>  
>  extern struct bio_set *bioset_create(unsigned int, unsigned int);
