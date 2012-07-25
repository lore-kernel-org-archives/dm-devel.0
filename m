From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 09/12] block: Rework bio_pair_split()
Date: Wed, 25 Jul 2012 15:03:30 +0300
Message-ID: <500FE092.6010108@panasas.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com> <1343160689-12378-10-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343160689-12378-10-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On 07/24/2012 11:11 PM, Kent Overstreet wrote:

> This changes bio_pair_split() to use the new bio_split() underneath,
> which gets rid of the single page bio limitation. The various callers
> are fixed up for the slightly different struct bio_pair, and to remove
> the unnecessary checks.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

<snip>

> +
> +extern struct bio *bio_split(struct bio *bio, int sectors,
> +			     gfp_t gfp, struct bio_set *bs);


nit:

Just for taking pride in my work, I'd move this extern declaration
to the previous patch that actually introduces it.

Cheers
Boaz

>  extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
>  extern void bio_pair_release(struct bio_pair *dbio);
>  
> @@ -512,7 +514,6 @@ extern int bio_integrity_prep(struct bio *);
>  extern void bio_integrity_endio(struct bio *, int);
>  extern void bio_integrity_advance(struct bio *, unsigned int);
>  extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
> -extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
>  extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
>  extern int bioset_integrity_create(struct bio_set *, int);
>  extern void bioset_integrity_free(struct bio_set *);
> @@ -556,12 +557,6 @@ static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
>  	return 0;
>  }
>  
> -static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
> -				       int sectors)
> -{
> -	return;
> -}
> -
>  static inline void bio_integrity_advance(struct bio *bio,
>  					 unsigned int bytes_done)
>  {
