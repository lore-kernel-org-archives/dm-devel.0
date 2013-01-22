From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 5/8] [dm-thin] Fix a race condition
	between	discard bios and ordinary bios.
Date: Tue, 22 Jan 2013 00:03:21 +0000
Message-ID: <20130122000321.GG27093@agk-dp.fab.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 13, 2012 at 08:19:13PM +0000, Joe Thornber wrote:
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 504f3d6..8e47f44 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c

> @@ -1470,19 +1492,24 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
>  			return DM_MAPIO_SUBMITTED;
>  		}
>  
> +		spin_lock(&tc->lock);
>  		build_virtual_key(tc->td, block, &key);
> -		if (bio_detain(tc->pool, &key, bio, &cell1))
> +		if (dm_bio_detain(tc->pool->prison, &key, bio, &tc->cell1, &cell_result)) {

Use same variable name cell_result down in the depths of the function
itself and all its callers?

Alasdair
