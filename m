From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] dm:  dm_table_unplug_all optimization
Date: Wed, 9 Apr 2008 10:15:23 +0200
Message-ID: <20080409081522.GI12774@kernel.dk>
References: <20080408182055.1779.69633.stgit@desktop-andmike.beaverton.ibm.com>
	<20080408182100.1779.92514.stgit@desktop-andmike.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080408182100.1779.92514.stgit@desktop-andmike.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 08 2008, Mike Anderson wrote:
> Performance optimization for high contention of the q->queue_lock under
> certain workloads.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

> ---
> 
>  drivers/md/dm-table.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e75b143..f4c8c1b 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1012,7 +1012,8 @@ void dm_table_unplug_all(struct dm_table *t)
>  	list_for_each_entry(dd, devices, list) {
>  		struct request_queue *q = bdev_get_queue(dd->bdev);
>  
> -		blk_unplug(q);
> +		if (blk_queue_plugged(q))
> +			blk_unplug(q);
>  	}
>  }
>  
> 

-- 
Jens Axboe
