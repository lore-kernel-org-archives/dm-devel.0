From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: consider non-idle request as "inflight" in
 blk_mq_rq_inflight()
Date: Tue, 7 Jul 2020 09:06:41 -0600
Message-ID: <dc5f15f0-db7f-eb1b-f504-d29ec5ef8a7e@kernel.dk>
References: <20200707150433.39480-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200707150433.39480-1-snitzer@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On 7/7/20 9:04 AM, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> dm-multipath is the only user of blk_mq_queue_inflight().  When
> dm-multipath calls blk_mq_queue_inflight() to check if it has
> outstanding IO it can get a false negative.  The reason for this is
> blk_mq_rq_inflight() doesn't consider requests that are no longer
> MQ_RQ_IN_FLIGHT but that are now MQ_RQ_COMPLETE (->complete isn't
> called or finished yet) as "inflight".
> 
> This causes request-based dm-multipath's dm_wait_for_completion() to
> return before all outstanding dm-multipath requests have actually
> completed.  This breaks DM multipath's suspend functionality because
> blk-mq requests complete after DM's suspend has finished -- which
> shouldn't happen.
> 
> Fix this by considering any request not in the MQ_RQ_IDLE state
> (so either MQ_RQ_COMPLETE or MQ_RQ_IN_FLIGHT) as "inflight" in
> blk_mq_rq_inflight().

Applied, thanks.

-- 
Jens Axboe
