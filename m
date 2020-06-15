From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm zoned: assign max_io_len correctly
Date: Mon, 15 Jun 2020 23:32:22 +0000
Message-ID: <CY4PR04MB37518EFBA09A7E08C48E97EFE79C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200615033323.146312-1-houtao1@huawei.com>
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
To: Hou Tao <houtao1@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 2020/06/15 12:26, Hou Tao wrote:
> The unit of max_io_len is sector instead of byte (spotted through
> code review), so fix it.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/md/dm-zoned-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index a907a9446c0b..cf915009c306 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -890,7 +890,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  
>  	/* Set target (no write same support) */
> -	ti->max_io_len = dmz_zone_nr_sectors(dmz->metadata) << 9;
> +	ti->max_io_len = dmz_zone_nr_sectors(dmz->metadata);
>  	ti->num_flush_bios = 1;
>  	ti->num_discard_bios = 1;
>  	ti->num_write_zeroes_bios = 1;
> 

Good catch !

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
