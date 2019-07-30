From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 0/2] block/scsi/dm-rq: fix leak of request private
 data in dm-mpath
Date: Tue, 30 Jul 2019 08:44:00 +0800
Message-ID: <20190730004359.GA28708@ming.t460p>
References: <20190725020500.4317-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725020500.4317-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jul 25, 2019 at 10:04:58AM +0800, Ming Lei wrote:
> Hi,
> 
> When one request is dispatched to LLD via dm-rq, if the result is
> BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
> private data for this request, so this way will cause memory leak.
> 
> Add .cleanup_rq() callback and implement it in SCSI for fixing the issue,
> since SCSI is the only driver which allocates private requst data in
> .queue_rq() path.
> 
> Another use case of this callback is to free the request and re-submit
> bios during cpu hotplug when the hctx is dead, see the following link:
> 
> https://lore.kernel.org/linux-block/f122e8f2-5ede-2d83-9ca0-bc713ce66d01@huawei.com/T/#t
> 
> V4:
> 	- add more commit log on the new .cleanup_rq callback, as suggested
> 	  by Mike
> 
> V3:
> 	- run .cleanup_rq() from dm-rq because this issue is dm-rq specific,
> 	and even in future it should be still very unusual to free request
> 	in this way. If we call .cleanup_rq() in generic rq free code(fast
> 	path), cost will be introduced unnecessarily, also we have to
> 	consider related race.
> 
> V2:
> 	- run .cleanup_rq() in blk_mq_free_request(), as suggested by Mike 
> 
> 
> 
> Ming Lei (2):
>   blk-mq: add callback of .cleanup_rq
>   scsi: implement .cleanup_rq callback
> 
>  drivers/md/dm-rq.c      |  1 +
>  drivers/scsi/scsi_lib.c | 13 +++++++++++++
>  include/linux/blk-mq.h  | 13 +++++++++++++
>  3 files changed, 27 insertions(+)
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: <stable@vger.kernel.org>
> Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")

Hello Jens & guys,

Ping on this fix.


Thanks,
Ming
