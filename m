From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 5/8] [dm-thin] Fix a race condition
	between	discard bios and ordinary bios.
Date: Thu, 24 Jan 2013 02:35:03 +0000
Message-ID: <20130124023503.GG30267@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-6-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-6-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 13, 2012 at 08:19:13PM +0000, Joe Thornber wrote:
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 504f3d6..8e47f44 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -222,10 +222,28 @@ struct thin_c {
>  
>  	struct pool *pool;
>  	struct dm_thin_device *td;
> +
> +	/*
> +	 * The cell structures are too big to put on the stack, so we have
> +	 * a couple here for use by the main mapping function.
> +	 */
> +	spinlock_t lock;
> +	struct dm_bio_prison_cell cell1, cell2;

We're also trying to cut down on locking on these code paths.
(High i/o load, many many cores?)

Have you hit any problems while testing due to the stack size?
The cells don't seem ridiculously big - could we perhaps just put them on 
the stack for now?  If we do hit stack size problems in real world
configurations, then we can try to compare the locking approach with an
approach that uses a separate (local) mempool for each cell (or a
mempool with double-sized elements).

> -		if (bio_detain(tc->pool, &key, bio, &cell1))
> +		if (dm_bio_detain(tc->pool->prison, &key, bio, &tc->cell1, &cell_result)) {

This deals with the existing upstream mempool deadlock, but there are
still some other calls to bio_detain() remaining in the file in other
functions that take one cell from a mempool and, before returning it,
may require a second cell from the same mempool, which could lead
to a deadlock.

Can they be fixed too?  (Multiple mempools/larger mempool elements where
there isn't such an easy on-stack fix?  In the worst case we might
later end up unable to avoid having to use the bio front_pad.)

Alasdair
