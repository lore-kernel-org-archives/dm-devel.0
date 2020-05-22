From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm-zoned: remove leftover hunk for switching
 to sequential zones
Date: Fri, 22 May 2020 07:45:41 +0000
Message-ID: <BY5PR04MB6900CDDFAD24878D00D951E0E7B40@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200522073209.78681-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: "Hannes@suse.de" <Hannes@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/22 16:32, Hannes Reinecke wrote:
> Remove a leftover hunk to switch from sequential zones to random

...from random zones to sequential zones...

> zones when selecting a reclaim zone; the logic has moved into the
> caller and this patch is now pointless.

s/this patch/this hunk/ ?

> 
> Fixes: 34f5affd04c4 ("dm zoned: separate random and cache zones")
> Signed-off-by: Hannes Reinecke <hare@suse.de.
> ---
>  drivers/md/dm-zoned-metadata.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index db0dc2b5d44d..4a2e351365c5 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -2111,14 +2111,6 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
>  		 */
>  		if (!(flags & DMZ_ALLOC_RECLAIM))
>  			return NULL;
> -		/*
> -		 * Use sequential write zones if we started off with random
> -		 * zones and the list is empty
> -		 */
> -		if (list == &zmd->unmap_rnd_list) {
> -			list = &zmd->unmap_seq_list;
> -			goto again;
> -		}
>  		/*
>  		 * Fallback to the reserved sequential zones
>  		 */

Apart from the commit message nits, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
