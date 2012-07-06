From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mirror: fix crash with mirror recovery and discard
Date: Fri, 6 Jul 2012 15:49:00 -0400
Message-ID: <20120706194859.GA10276@redhat.com>
References: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 06 2012 at  2:56pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-mirror: fix crash with mirror recovery and discard
...
> These bypasses were improperly implemented for REQ_DISCARD. In
> do_writes, REQ_DISCARD requests is always added on sync queue and
> immediatelly dispatched (even if the region is in DM_RH_RECOVERING).
> However, dm_rh_inc and dm_rh_dec is called for REQ_DISCARD resusts.
> So it violates the rule that no I/Os are started on DM_RH_RECOVERING
> regions, and causes the list corruption described above.

Yeap, my fault.  Thanks for sorting this out.  So this bug has existed
since: 5fc2ffe v2.6.38-rc1 dm raid1: support discard

Best to reference that in the patch header so stable knows how far back
this issue goes.
 
> This patch changes it so that REQ_DISCARD requests follow the same path
> as REQ_FLUSH. This avoids the crash.
> 
> Note that we can't guarantee that REQ_DISCARD zeroes the data even if
> the underlying disks support zero on discard, so this patch also sets
> ti->discard_zeroes_data_unsupported.

...

> Index: linux-3.4.4-fast/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-3.4.4-fast.orig/drivers/md/dm-raid1.c	2012-07-06 19:01:27.000000000 +0200
> +++ linux-3.4.4-fast/drivers/md/dm-raid1.c	2012-07-06 19:03:53.000000000 +0200
> @@ -1091,6 +1091,7 @@ static int mirror_ctr(struct dm_target *
>  
>  	ti->num_flush_requests = 1;
>  	ti->num_discard_requests = 1;
> +	ti->discard_zeroes_data_unsupported = 1;
>  
>  	ms->kmirrord_wq = alloc_workqueue("kmirrord",
>  					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);

This should be split out to a separate patch and properly justified in
the patch header.  Is there something unique to dm-mirror that renders
the underlying device's zeroing unreliable?

> Index: linux-3.4.4-fast/drivers/md/dm-region-hash.c
> ===================================================================
> --- linux-3.4.4-fast.orig/drivers/md/dm-region-hash.c	2012-07-06 19:02:28.000000000 +0200
> +++ linux-3.4.4-fast/drivers/md/dm-region-hash.c	2012-07-06 19:02:57.000000000 +0200
> @@ -524,7 +527,7 @@ void dm_rh_inc_pending(struct dm_region_
>  	struct bio *bio;
>  
>  	for (bio = bios->head; bio; bio = bio->bi_next) {
> -		if (bio->bi_rw & REQ_FLUSH)
> +		if (bio->bi_rw & (REQ_FLUSH | REQ_FLUSH))
>  			continue;
>  		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
>  	}

Typo, you meant: if (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD))
