From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Bug#604457: [dm-devel] [PATCH] dm: Deal with merge_bvec_fn in component devices better
Date: Mon, 2 Sep 2013 10:32:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309021029020.16272@file01.intranet.prod.int.rdu2.redhat.com>
References: <1378051306.25743.18.camel@deadeye.wl.decadent.org.uk>
Reply-To: Mikulas Patocka <mpatocka@redhat.com>, 604457@bugs.debian.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.604457.B604457.137813234520503@bugs.debian.org>
In-Reply-To: <1378051306.25743.18.camel@deadeye.wl.decadent.org.uk>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 604457@bugs.debian.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This was already fixed in 2.6.31 with commit 
8cbeb67ad50f7d68e5e83be2cb2284de8f9c03b5.

See this piece of code in dm.c:

/*
 * If the target doesn't support merge method and some of the devices
 * provided their merge_bvec method (we know this by looking at
 * queue_max_hw_sectors), then we can't allow bios with multiple vector
 * entries.  So always set max_size to 0, and the code below allows
 * just one page.
 */
else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
        max_size = 0;

Mikulas


On Sun, 1 Sep 2013, Ben Hutchings wrote:

> This is analogous to commit 627a2d3c29427637f4c5d31ccc7fcbd8d312cd71
> ('md: deal with merge_bvec_fn in component devices better.'),
> which does the same for md-devices at the top of the stack.  The
> following explanation is taken from that commit.  Thanks to Neil Brown
> <neilb@suse.de> for the advice.
> 
> If a component device has a merge_bvec_fn then as we never call it
> we must ensure we never need to.  Currently this is done by setting
> max_sector to 1 PAGE, however this does not stop a bio being created
> with several sub-page iovecs that would violate the merge_bvec_fn.
> 
> So instead set max_segments to 1 and set the segment boundary to the
> same as a page boundary to ensure there is only ever one single-page
> segment of IO requested at a time.
> 
> This can particularly be an issue when 'xen' is used as it is
> known to submit multiple small buffers in a single bio.
> 
> References: http://bugs.debian.org/604457
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> We've been carrying this in Debian for about 3 years and it's about time
> it got reviewed...  It's basically Neil's work so should probably have
> his sign-off as well.
> 
> Ben.
> 
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -536,13 +536,15 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  		       (unsigned long long) start << SECTOR_SHIFT);
>  
>  	/*
> -	 * Check if merge fn is supported.
> -	 * If not we'll force DM to use PAGE_SIZE or
> -	 * smaller I/O, just to be safe.
> +	 * If we don't call merge_bvec_fn, we must never risk
> +	 * violating it, so limit max_phys_segments to 1 lying within
> +	 * a single page.
>  	 */
> -	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
> -		blk_limits_max_hw_sectors(limits,
> -					  (unsigned int) (PAGE_SIZE >> 9));
> +	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge) {
> +		limits->max_segments = 1;
> +		limits->seg_boundary_mask = PAGE_CACHE_SIZE - 1;
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(dm_set_device_limits);
> 
> -- 
> Ben Hutchings
> The most exhausting thing in life is being insincere. - Anne Morrow Lindberg
> 
