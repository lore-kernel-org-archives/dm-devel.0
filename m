From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v2] dm log writes: make sure the log super
 sectors are written in order
Date: Thu, 13 Jun 2019 10:06:29 +0800
Message-ID: <404ad73a-0630-3b1f-1b7a-4f374051cf2a@huawei.com>
References: <1559741228-96463-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1559741228-96463-1-git-send-email-yi.zhang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: josef@toxicpanda.com, dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, houtao1@huawei.com
List-Id: dm-devel.ids

Gentle ping.

On 2019/6/5 21:27, zhangyi (F) Wrote:
> Currently, although we submit super bios in log-write thread orderly
> (the super.nr_entries is incremented by each logged entry), the
> submit_bio() cannot make sure that each super sector is written to log
> device in order. So the submitting bio of each super sector may be
> out-of-order, and then the final nr_entries maybe small than the real
> entries submitted.
> 
> This problem can be reproduced by the xfstests generic/455 with ext4,
> which may complained below after running the test:
> 
>   QA output created by 455
>  -Silence is golden
>  +mark 'end' does not exist
> 
> This patch serialize submitting super secotrs to make sure each super
> sectors are written to log disk in order, so that we can prevent the
> latest nr_entries be rewritten by some old super bios.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> ---
> Changes since v1:
>  - Switch to use completion instead of wait_queue to synchronize
>    submitting super bios.
> 
>  drivers/md/dm-log-writes.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> index 9ea2b02..4854246 100644
> --- a/drivers/md/dm-log-writes.c
> +++ b/drivers/md/dm-log-writes.c
> @@ -60,6 +60,7 @@
>  
>  #define WRITE_LOG_VERSION 1ULL
>  #define WRITE_LOG_MAGIC 0x6a736677736872ULL
> +#define WRITE_LOG_SUPER_SECTOR 0
>  
>  /*
>   * The disk format for this is braindead simple.
> @@ -115,6 +116,7 @@ struct log_writes_c {
>  	struct list_head logging_blocks;
>  	wait_queue_head_t wait;
>  	struct task_struct *log_kthread;
> +	struct completion super_done;
>  };
>  
>  struct pending_block {
> @@ -180,6 +182,15 @@ static void log_end_io(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> +static void log_end_super(struct bio *bio)
> +{
> +	struct log_writes_c *lc = bio->bi_private;
> +
> +	/* Wake up log-write kthread that super has been written */
> +	complete(&lc->super_done);
> +	log_end_io(bio);
> +}
> +
>  /*
>   * Meant to be called if there is an error, it will free all the pages
>   * associated with the block.
> @@ -215,7 +226,8 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
>  	bio->bi_iter.bi_size = 0;
>  	bio->bi_iter.bi_sector = sector;
>  	bio_set_dev(bio, lc->logdev->bdev);
> -	bio->bi_end_io = log_end_io;
> +	bio->bi_end_io = (sector == WRITE_LOG_SUPER_SECTOR) ?
> +			  log_end_super : log_end_io;
>  	bio->bi_private = lc;
>  	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
>  
> @@ -418,11 +430,19 @@ static int log_super(struct log_writes_c *lc)
>  	super.nr_entries = cpu_to_le64(lc->logged_entries);
>  	super.sectorsize = cpu_to_le32(lc->sectorsize);
>  
> -	if (write_metadata(lc, &super, sizeof(super), NULL, 0, 0)) {
> +	if (write_metadata(lc, &super, sizeof(super), NULL, 0,
> +			   WRITE_LOG_SUPER_SECTOR)) {
>  		DMERR("Couldn't write super");
>  		return -1;
>  	}
>  
> +	/*
> +	 * Super sector should be writen in-order, or else the
> +	 * nr_entries could be rewritten by the old bio and small
> +	 * than the real submitted entries.
> +	 */
> +	wait_for_completion_io(&lc->super_done);
> +
>  	return 0;
>  }
>  
> @@ -531,6 +551,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	INIT_LIST_HEAD(&lc->unflushed_blocks);
>  	INIT_LIST_HEAD(&lc->logging_blocks);
>  	init_waitqueue_head(&lc->wait);
> +	init_completion(&lc->super_done);
>  	atomic_set(&lc->io_blocks, 0);
>  	atomic_set(&lc->pending_blocks, 0);
>  
> 
