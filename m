From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/2] dm-zoned: remove spurious newlines from
 debugging messages
Date: Thu, 14 May 2020 07:53:47 +0000
Message-ID: <BY5PR04MB690056D5F089DF39BDC686A3E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200514060929.85469-1-hare@suse.de>
	<20200514060929.85469-3-hare@suse.de>
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

On 2020/05/14 15:09, Hannes Reinecke wrote:
> DMDEBUG will already add a newline to the logging messages, so we
> shouldn't be adding it to the message itself.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-reclaim.c | 4 ++--
>  drivers/md/dm-zoned-target.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 39ea0d5d4706..4bfa61540b9c 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -405,7 +405,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  
>  	ret = dmz_flush_metadata(zrc->metadata);
>  	if (ret) {
> -		DMDEBUG("(%s): Metadata flush for zone %u failed, err %d\n",
> +		DMDEBUG("(%s): Metadata flush for zone %u failed, err %d",
>  			dmz_metadata_label(zmd), rzone->id, ret);
>  		return ret;
>  	}
> @@ -493,7 +493,7 @@ static void dmz_reclaim_work(struct work_struct *work)
>  
>  	ret = dmz_do_reclaim(zrc);
>  	if (ret) {
> -		DMDEBUG("(%s): Reclaim error %d\n",
> +		DMDEBUG("(%s): Reclaim error %d",
>  			dmz_metadata_label(zmd), ret);
>  		if (!dmz_check_dev(zmd))
>  			return;
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index ea43f6892ced..a3d572da70ad 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -515,7 +515,7 @@ static void dmz_flush_work(struct work_struct *work)
>  	/* Flush dirty metadata blocks */
>  	ret = dmz_flush_metadata(dmz->metadata);
>  	if (ret)
> -		DMDEBUG("(%s): Metadata flush failed, rc=%d\n",
> +		DMDEBUG("(%s): Metadata flush failed, rc=%d",
>  			dmz_metadata_label(dmz->metadata), ret);
>  
>  	/* Process queued flush requests */
> @@ -679,7 +679,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  	/* Now ready to handle this BIO */
>  	ret = dmz_queue_chunk_work(dmz, bio);
>  	if (ret) {
> -		DMDEBUG("(%s): BIO op %d, can't process chunk %llu, err %i\n",
> +		DMDEBUG("(%s): BIO op %d, can't process chunk %llu, err %i",
>  			dmz_metadata_label(zmd),
>  			bio_op(bio), (u64)dmz_bio_chunk(zmd, bio),
>  			ret);
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
