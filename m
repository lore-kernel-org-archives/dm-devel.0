From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 04/12] dm-zoned: secondary superblock must
 reside on the same devices than primary superblock
Date: Mon, 25 May 2020 02:10:31 +0000
Message-ID: <CY4PR04MB3751DACF536FC287B467D3FCE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-5-hare@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/05/23 0:39, Hannes Reinecke wrote:
> The secondary superblock must reside on the same device than the
> primary superblock, so there's no need to re-calculate the device.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index b70a988fa771..fdae4e0228e7 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1141,7 +1141,7 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
>  	/* Bad first super block: search for the second one */
>  	zmd->sb[1].block = zmd->sb[0].block + zone_nr_blocks;
>  	zmd->sb[1].zone = xa_load(&zmd->zones, zone_id + 1);
> -	zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
> +	zmd->sb[1].dev = zmd->sb[0].dev;
>  	for (i = 1; i < zmd->nr_rnd_zones; i++) {
>  		if (dmz_read_sb(zmd, &zmd->sb[1], 1) != 0)
>  			break;
> @@ -1149,7 +1149,6 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
>  			return 0;
>  		zmd->sb[1].block += zone_nr_blocks;
>  		zmd->sb[1].zone = dmz_get(zmd, zone_id + i);
> -		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
>  	}
>  
>  	dmz_free_mblock(zmd, mblk);
> @@ -1272,7 +1271,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>  			zmd->sb[1].zone = dmz_get(zmd, zone_id);
>  		}
>  		zmd->sb[1].block = dmz_start_block(zmd, zmd->sb[1].zone);
> -		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
> +		zmd->sb[1].dev = zmd->sb[0].dev;
>  		ret = dmz_get_sb(zmd, &zmd->sb[1], 1);
>  	} else
>  		ret = dmz_lookup_secondary_sb(zmd);
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
