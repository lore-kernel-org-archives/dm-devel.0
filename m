From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 6/6] dm-snap-persistent: make metadata_wq
 multithreaded
Date: Fri, 7 Jan 2011 22:31:06 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1101072228360.28699@hs20-bc2-1.build.redhat.com>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<1292181055-25696-7-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292181055-25696-7-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids


On Sun, 12 Dec 2010, Tejun Heo wrote:

> metadata_wq serves on-stack work items from chunk_io().  Even if
> multiple chunk_io() are simultaneously in progress, each is
> independent and queued only once, so multithreaded workqueue can be
> safely used.
> 
> Switch metadata_wq to multithread and flush the work item instead of
> the workqueue in chunk_io().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-snap-persistent.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
> index d3021a6..95891df 100644
> --- a/drivers/md/dm-snap-persistent.c
> +++ b/drivers/md/dm-snap-persistent.c
> @@ -256,7 +256,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
>  	 */
>  	INIT_WORK_ONSTACK(&req.work, do_metadata);
>  	queue_work(ps->metadata_wq, &req.work);
> -	flush_workqueue(ps->metadata_wq);
> +	flush_work(&req.work);
>  
>  	return req.result;
>  }
> @@ -818,7 +818,7 @@ static int persistent_ctr(struct dm_exception_store *store,
>  	atomic_set(&ps->pending_count, 0);
>  	ps->callbacks = NULL;
>  
> -	ps->metadata_wq = alloc_ordered_workqueue("ksnaphd", WQ_MEM_RECLAIM);
> +	ps->metadata_wq = alloc_workqueue("ksnaphd", WQ_MEM_RECLAIM, 0);
>  	if (!ps->metadata_wq) {
>  		kfree(ps);
>  		DMERR("couldn't start header metadata update thread");
> -- 
> 1.7.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
