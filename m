From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-zoned: Avoid metadata flush writeback
 throttling
Date: Mon, 24 Jul 2017 01:03:20 -0700
Message-ID: <20170724080320.GA16608@infradead.org>
References: <20170724074422.23948-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170724074422.23948-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 24, 2017 at 04:44:22PM +0900, Damien Le Moal wrote:
> Avoid metadata flush to be blocked by the writeback throttling code in
> wbt_wait(). Otherwise, we can end up with a deadlock under heavy write
> load with all chunk works active. In such situation, a deadlock can
> happen if the flush work is blocked by the throttling code while holding
> the metadata lock: as the chunk works will wait for the metadata lock
> too, no progress can be made.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 884ff7c170a0..f694fb98b002 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -567,7 +567,8 @@ static void dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
>  	bio->bi_bdev = zmd->dev->bdev;
>  	bio->bi_private = mblk;
>  	bio->bi_end_io = dmz_mblock_bio_end_io;
> -	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
> +	bio_set_op_attrs(bio, REQ_OP_WRITE,
> +			 REQ_META | REQ_PRIO | REQ_SYNC | REQ_IDLE);

Please just assign bi_opf directly instea dof using bio_set_op_attrs
in new code.

Also what do you need REQ_IDLE for?
