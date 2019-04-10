From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3] dm zoned: Silence a static checker warning
Date: Wed, 10 Apr 2019 08:14:32 +0000
Message-ID: <BYAPR04MB581696AA3EF70BE5328A9C95E72E0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190410081231.GA31089@kadam>
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
To: Dan Carpenter <dan.carpenter@oracle.com>, Alasdair Kergon <agk@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Edwards <gedwards@ddn.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Greg, Omar, Sandoval <osandov@fb.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 2019/04/10 17:13, Dan Carpenter wrote:
> My static checker complains about this line from dmz_get_zoned_device()
> 
> 	aligned_capacity = dev->capacity & ~(blk_queue_zone_sectors(q) - 1);
> 
> The problem is that "aligned_capacity" and "dev->capacity" are sector_t
> type (which is a u64 under most configs) but blk_queue_zone_sectors(q)
> returns a u32 so the higher 32 bits in aligned_capacity are cleared to
> zero.  This patch adds a cast to address the issue.
> 
> Fixes: 114e025968b5 ("dm zoned: ignore last smaller runt zone")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: The v1 patch declared blk_queue_zone_sectors() as sector_t but the
>     v2 cast added a cast to u64.
> v3: Cast it to sector_t instead
> 
>  drivers/md/dm-zoned-target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 8865c1709e16..51d029bbb740 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -643,7 +643,8 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
>  
>  	q = bdev_get_queue(dev->bdev);
>  	dev->capacity = i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
> -	aligned_capacity = dev->capacity & ~(blk_queue_zone_sectors(q) - 1);
> +	aligned_capacity = dev->capacity &
> +				~((sector_t)blk_queue_zone_sectors(q) - 1);
>  	if (ti->begin ||
>  	    ((ti->len != dev->capacity) && (ti->len != aligned_capacity))) {
>  		ti->error = "Partial mapping not supported";
> 

Thanks for fixing this !

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
