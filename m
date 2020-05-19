From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 6/6] dm-zoned: remove unused variable in
	dmz_do_reclaim()
Date: Tue, 19 May 2020 22:29:39 +0000
Message-ID: <BY5PR04MB6900C0B1548D239690BE5A93E7B90@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200519081424.103318-1-hare@suse.de>
	<20200519081424.103318-7-hare@suse.de>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/19 17:14, Hannes Reinecke wrote:
> 'dev' is unused, and can be removed.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-reclaim.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 3ed88581dc48..571bc1d41bab 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -366,7 +366,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  	struct dmz_metadata *zmd = zrc->metadata;
>  	struct dm_zone *dzone;
>  	struct dm_zone *rzone;
> -	struct dmz_dev *dev;
>  	unsigned long start;
>  	int ret;
>  
> @@ -376,7 +375,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  		return -EBUSY;
>  
>  	start = jiffies;
> -	dev = dmz_zone_to_dev(zmd, dzone);
>  	if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
>  		if (!dmz_weight(dzone)) {
>  			/* Empty zone */
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research
