From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 5/5] blk-mq: issue request directly for
 blk_insert_cloned_request
Date: Thu, 11 Jan 2018 17:42:49 -0500
Message-ID: <20180111224249.GD31944@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111060159.12991-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111060159.12991-6-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  1:01am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> blk_insert_cloned_request() is called in fast path of dm-rq driver, and
> in this function we append request to hctx->dispatch_list of the underlying
> queue directly.
> 
> 1) This way isn't efficient enough because hctx lock is always required
> 
> 2) With blk_insert_cloned_request(), we bypass underlying queue's IO scheduler
> totally, and depend on DM rq driver to do IO schedule completely. But DM
> rq driver can't get underlying queue's dispatch feedback at all, and this
> information is extreamly useful for IO merge. Without that IO merge can't
> be done basically by blk-mq, and causes very bad sequential IO performance.
> 
> This patch makes use of blk_mq_try_issue_directly() to dispatch rq to
> underlying queue and provides disptch result to dm-rq and blk-mq, and
> improves the above situations very much.
> 
> With this patch, seqential IO is improved by 3X in my test over
> mpath/virtio-scsi.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Tested-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
