From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 08/16] block: Rework bio splitting
Date: Mon, 28 May 2012 12:12:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205281210450.3913@file.rdu.redhat.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-9-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337977539-16977-9-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids



On Fri, 25 May 2012, Kent Overstreet wrote:

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f8b6f14..0062326 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1001,15 +1001,9 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  		      > chunk_sects &&
>  		    conf->near_copies < conf->raid_disks)) {
>  		struct bio_pair *bp;
> -		/* Sanity check -- queue functions should prevent this happening */
> -		if (bio->bi_vcnt != 1 ||
> -		    bio->bi_idx != 0)
> -			goto bad_map;
> -		/* This is a one page bio that upper layers
> -		 * refuse to split for us, so we need to split it.
> -		 */
> +

That "Sanity check" should be removed from drivers/md/raid0.c too. Your 
patch only removes it from raid10.

Mikulas
