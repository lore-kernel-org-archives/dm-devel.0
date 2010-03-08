From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] dm: max_segments=1 if merge_bvec_fn is not supported
Date: Mon, 8 Mar 2010 16:33:45 +1100
Message-ID: <20100308163345.42841480@notabene.brown>
References: <20100306211012.GA9689@racke>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100306211012.GA9689@racke>
Sender: linux-kernel-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, 6 Mar 2010 22:10:13 +0100
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> If the lower device exposes a merge_bvec_fn,
> dm_set_device_limits() restricts max_sectors
> to PAGE_SIZE "just to be safe".
> 
> This is not sufficient, however.
> 
> If someone uses bio_add_page() to add 8 disjunct 512 byte partial
> pages to a bio, it would succeed, but could still cross a border
> of whatever restrictions are below us (e.g. raid10 stripe boundary).
> An attempted bio_split() would not succeed, because bi_vcnt is 8.
> 
> One example that triggered this frequently is the xen io layer.
> 
> raid10_make_request bug: can't convert block across chunks or bigger than 64k 209265151 1
> 
> Signed-off-by: Lars <lars.ellenberg@linbit.com>
> 
> ---
> 
> Neil: you may want to double check linear.c and raid*.c for similar logic,
> even though it is unlikely that someone puts md raid6 on top of something
> exposing a merge_bvec_fn.
> 

Unlikely, but by no means impossible.  I have queued up an appropriate fix
for md.

Thanks!

NeilBrown


> This is not the first time this has been patched, btw.
> See https://bugzilla.redhat.com/show_bug.cgi?id=440093
> and the patch by Mikulas:
> https://bugzilla.redhat.com/attachment.cgi?id=342638&action=diff
> 
> ---
>  drivers/md/dm-table.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 4b22feb..c686ff4 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -515,14 +515,22 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  
>  	/*
>  	 * Check if merge fn is supported.
> -	 * If not we'll force DM to use PAGE_SIZE or
> +	 * If not we'll force DM to use single bio_vec of PAGE_SIZE or
>  	 * smaller I/O, just to be safe.
>  	 */
>  
> -	if (q->merge_bvec_fn && !ti->type->merge)
> +	if (q->merge_bvec_fn && !ti->type->merge) {
>  		limits->max_sectors =
>  			min_not_zero(limits->max_sectors,
>  				     (unsigned int) (PAGE_SIZE >> 9));
> +		/* Restricting max_sectors is not enough.
> +		 * If someone uses bio_add_page to add 8 disjunct 512 byte
> +		 * partial pages to a bio, it would succeed,
> +		 * but could still cross a border of whatever restrictions
> +		 * are below us (e.g. raid0 stripe boundary).  An attempted
> +		 * bio_split() would not succeed, because bi_vcnt is 8. */
> +		limits->max_segments = 1;
> +	}
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(dm_set_device_limits);
