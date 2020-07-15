From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm zoned: update atime for new buffer zones
Date: Wed, 15 Jul 2020 08:49:50 +0000
Message-ID: <CY4PR04MB37511C00F22BDC73456FC252E77E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715081752.28130-1-hare@suse.de>
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

On 2020/07/15 17:18, Hannes Reinecke wrote:
> When a new buffer zone is allocated in dmz_handle_buffered_write()
> we should update the 'atime' to inform reclaim that this zone has
> been accessed.
> Otherwise we end up with the pathological case where the first write
> allocates a new buffer zone, but the next write will start reclaim
> before processing the bio. As the atime is not set reclaim declares
> the system idle and reclaims the zone. Then the write will be processed
> and re-allocate the very same zone again; this repeats for every
> consecutive write, making for a _very_ slow mkfs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-target.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index cf915009c306..b32d37bef14f 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -297,6 +297,9 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
>  	if (dmz_is_readonly(bzone))
>  		return -EROFS;
>  
> +	/* Tell reclaim we're doing some work here */
> +	dmz_reclaim_bio_acc(bzone->dev->reclaim);
> +
>  	/* Submit write */
>  	ret = dmz_submit_bio(dmz, bzone, bio, chunk_block, nr_blocks);
>  	if (ret)

This is without a cache device, right ? Otherwise, since the cache device has no
reclaim, it would not make much sense.

In fact, I think that the atime timestamp being attached to each device reclaim
structure is a problem. We do not need that since we always trigger reclaim for
all drives. We only want to see if the target is busy or not, so atime should be
attached to struct dmz_metadata.

That will simplify things since we will not need to care about which zone/which
device is being accessed to track activity. We can just have:

	dmz_reclaim_bio_acc(dmz->metadata);

Thoughts ?

-- 
Damien Le Moal
Western Digital Research
