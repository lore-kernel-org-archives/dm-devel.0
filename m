From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-4.2 06/14] dm: rename methods that
 requeue requests
Date: Mon, 18 May 2015 01:29:44 -0700
Message-ID: <20150518082944.GC5439@infradead.org>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
	<1431637512-64245-7-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1431637512-64245-7-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 14, 2015 at 05:05:04PM -0400, Mike Snitzer wrote:
> More often than not a request that is requeued _is_ mapped (meaning the
> clone request is allocated and clone->q is initialized).  Rename
> dm_requeue_unmapped_original_request() and dm_requeue_unmapped_request()
> to avoid potential confusion due to function names containing "unmapped".

Can you also just kill off dm_requeue_unmapped_request / dm_requeue_request
while you're at it?  Both callers have the dm_rq_target_io at hand,
so it's rather poinless.

Also for the blk-mq case please just return BLK_MQ_RQ_QUEUE_BUSY from
->queue_rq insted of requeing the request.
