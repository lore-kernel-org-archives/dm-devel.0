From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 5/7] block: Delay default elevator
	initialization
Date: Thu, 5 Sep 2019 15:19:24 +0800
Message-ID: <20190905071923.GA8898@ming.t460p>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
	<20190905042901.5830-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190905042901.5830-6-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 05, 2019 at 01:28:59PM +0900, Damien Le Moal wrote:
> When elevator_init_mq() is called from blk_mq_init_allocated_queue(),
> the only information known about the device is the number of hardware
> queues as the block device scan by the device driver is not completed
> yet. The device type and the device required features are not set yet,
> preventing to correctly choose the default elevator most suitable for
> the device.
> 
> This currently affects all multi-queue zoned block devices which default
> to the "none" elevator instead of the required "mq-deadline" elevator.
> These drives currently include host-managed SMR disks connected to a
> smartpqi HBA and null_blk block devices with zoned mode enabled.
> Upcoming NVMe Zoned Namespace devices will also be affected.
> 
> Fix this by moving the execution of elevator_init_mq() from
> blk_mq_init_allocated_queue() into __device_add_disk() to allow for the
> device driver to probe the device characteristics and set attributes
> of the device request queue prior to the elevator initialization. This
> initialization is skipped for DM devices using
> device_add_disk_no_queue_reg() as this also skips the queue
> registration.
> 
> Additionally, to make sure that the elevator initialization is never
> done while requests are in-flight (there should be none when the device
> driver calls device_add_disk()), freeze and quiesce the device request
> queue before calling blk_mq_init_sched() in elevator_init_mq().
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  block/blk-mq.c   | 2 --
>  block/elevator.c | 7 +++++++
>  block/genhd.c    | 9 +++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ee4caf0c0807..a37503984206 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2902,8 +2902,6 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>  	blk_mq_add_queue_tag_set(set, q);
>  	blk_mq_map_swqueue(q);
>  
> -	elevator_init_mq(q);
> -
>  	return q;
>  
>  err_hctxs:
> diff --git a/block/elevator.c b/block/elevator.c
> index 520d6b224b74..096a670d22d7 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -712,7 +712,14 @@ void elevator_init_mq(struct request_queue *q)
>  	if (!e)
>  		return;
>  
> +	blk_mq_freeze_queue(q);
> +	blk_mq_quiesce_queue(q);
> +
>  	err = blk_mq_init_sched(q, e);
> +
> +	blk_mq_unquiesce_queue(q);
> +	blk_mq_unfreeze_queue(q);
> +
>  	if (err) {
>  		pr_warn("\"%s\" elevator initialization failed, "
>  			"falling back to \"none\"\n", e->elevator_name);
> diff --git a/block/genhd.c b/block/genhd.c
> index 54f1f0d381f4..26b31fcae217 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -695,6 +695,15 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
>  	dev_t devt;
>  	int retval;
>  
> +	/*
> +	 * The disk queue should now be all set with enough information about
> +	 * the device for the elevator code to pick an adequate default
> +	 * elevator if one is needed, that is, for devices requesting queue
> +	 * registration.
> +	 */
> +	if (register_queue)
> +		elevator_init_mq(disk->queue);
> +

This way is better, but still changes the default elevator to 'none'
for dm-rq always.


thanks,
Ming
