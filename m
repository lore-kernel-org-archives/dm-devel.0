From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v4-mike 2/2] blk-mq: issue request directly for
 blk_insert_cloned_request
Date: Tue, 16 Jan 2018 11:41:04 -0500
Message-ID: <20180116164103.GA21650@redhat.com>
References: <20180116150148.21145-1-snitzer@redhat.com>
 <20180116150148.21145-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180116150148.21145-2-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On Tue, Jan 16 2018 at 10:01P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Ming Lei <ming.lei@redhat.com>
> 
> blk_insert_cloned_request() is called in fast path of dm-rq driver, and
> in this function we append request to hctx->dispatch_list of the underlying
> queue directly.
> 
> 1) This way isn't efficient enough because hctx lock is always required
> 
> 2) With blk_insert_cloned_request(), we bypass underlying queue's IO
> scheduler totally, and depend on DM rq driver to do IO schedule
> completely.  But DM rq driver can't get underlying queue's dispatch
> feedback at all, and this information is extreamly useful for IO merge.
> Without that IO merge can't be done basically by blk-mq, which causes
> very bad sequential IO performance.
> 
> Fix this by having blk_insert_cloned_request() make use of
> blk_mq_try_issue_directly() via blk_mq_request_direct_issue().
> blk_mq_request_direct_issue() allows a request to be dispatched to be
> issue directly to the underlying queue and provides dispatch result to
> dm-rq and blk-mq.
> 
> With this, the DM's blk-mq sequential IO performance is vastly
> improved (as much as 3X in mpath/virtio-scsi testing).
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c   |  3 +--
>  block/blk-mq.c     | 42 ++++++++++++++++++++++++++++++++++++------
>  block/blk-mq.h     |  3 +++
>  drivers/md/dm-rq.c | 19 ++++++++++++++++---
>  4 files changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7ba607527487..55f338020254 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2500,8 +2500,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
>  		 * bypass a potential scheduler on the bottom device for
>  		 * insert.
>  		 */
> -		blk_mq_request_bypass_insert(rq, true);
> -		return BLK_STS_OK;
> +		return blk_mq_request_direct_issue(rq);
>  	}
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 55f3a27fb2e6..3168a13cb012 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1706,6 +1706,12 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
>  	blk_qc_t new_cookie;
>  	blk_status_t ret = BLK_STS_OK;
>  	bool run_queue = true;
> +	/*
> +	 * If @cookie is NULL do not insert the request, this mode is used
> +	 * by blk_insert_cloned_request() via blk_mq_request_direct_issue()
> +	 */
> +	bool dispatch_only = !cookie;
> +	bool need_insert = false;
>  
>  	/* RCU or SRCU read lock is needed before checking quiesced flag */
>  	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)) {
> @@ -1713,25 +1719,38 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
>  		goto insert;
>  	}
>  
> -	if (q->elevator)
> +	if (q->elevator && !dispatch_only)
>  		goto insert;
>  
>  	if (!blk_mq_get_driver_tag(rq, NULL, false))
> -		goto insert;
> +		need_insert = true;
>  
> -	if (!blk_mq_get_dispatch_budget(hctx)) {
> +	if (!need_insert && !blk_mq_get_dispatch_budget(hctx)) {
>  		blk_mq_put_driver_tag(rq);
> +		need_insert = true;
> +	}
> +
> +	if (need_insert) {
> +		if (dispatch_only)
> +			return BLK_STS_RESOURCE;
>  		goto insert;
>  	}
>  
>  	new_cookie = request_to_qc_t(hctx, rq);
>  
> +	ret = q->mq_ops->queue_rq(hctx, &bd);
> +
> +	if (dispatch_only) {
> +		if (ret == BLK_STS_RESOURCE)
> +			__blk_mq_requeue_request(rq);
> +		return ret;
> +	}
> +
>  	/*
>  	 * For OK queue, we are done. For error, kill it. Any other
>  	 * error (busy), just add it to our list as we previously
>  	 * would have done
>  	 */
> -	ret = q->mq_ops->queue_rq(hctx, &bd);
>  	switch (ret) {
>  	case BLK_STS_OK:
>  		*cookie = new_cookie;

FYI, because blk_mq_put_driver_tag() is idempotent, the above can be
simplified by eliminating 'need_insert' like so (Jens feel free to fold
this in?):

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3168a13cb012..c2f66a5c5242 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1711,7 +1711,6 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	 * by blk_insert_cloned_request() via blk_mq_request_direct_issue()
 	 */
 	bool dispatch_only = !cookie;
-	bool need_insert = false;
 
 	/* RCU or SRCU read lock is needed before checking quiesced flag */
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)) {
@@ -1722,15 +1721,9 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	if (q->elevator && !dispatch_only)
 		goto insert;
 
-	if (!blk_mq_get_driver_tag(rq, NULL, false))
-		need_insert = true;
-
-	if (!need_insert && !blk_mq_get_dispatch_budget(hctx)) {
+	if (!blk_mq_get_driver_tag(rq, NULL, false) ||
+	    !blk_mq_get_dispatch_budget(hctx)) {
 		blk_mq_put_driver_tag(rq);
-		need_insert = true;
-	}
-
-	if (need_insert) {
 		if (dispatch_only)
 			return BLK_STS_RESOURCE;
 		goto insert;
