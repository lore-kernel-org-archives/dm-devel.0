From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 01/12] dm-zoned: add debugging message for
 reading superblocks
Date: Mon, 25 May 2020 01:54:19 +0000
Message-ID: <CY4PR04MB3751A8221E6D35A3ECD0C216E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-2-hare@suse.de>
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
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 4a2e351365c5..b0d3ed4ac56a 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1105,6 +1105,9 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
>   */
>  static int dmz_read_sb(struct dmz_metadata *zmd, unsigned int set)
>  {
> +	DMDEBUG("(%s): read superblock set %d dev %s block %llu",
> +		zmd->devname, set, zmd->sb[set].dev->name,
> +		zmd->sb[set].block);

A blank line here would be nice. Cosmetic only, no big deal.

>  	return dmz_rdwr_block(zmd->sb[set].dev, REQ_OP_READ,
>  			      zmd->sb[set].block, zmd->sb[set].mblk->page);
>  }
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
