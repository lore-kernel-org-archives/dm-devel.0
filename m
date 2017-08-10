From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: Make blk_mq_delay_kick_requeue_list() rerun the
        queue at a quiet time
Date: Thu, 10 Aug 2017 09:14:08 +0200
Message-ID: <20170810071408.GA20981@lst.de>
References: <20170809182806.32741-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170809182806.32741-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 09, 2017 at 11:28:06AM -0700, Bart Van Assche wrote:
> The blk_mq_delay_kick_requeue_list() function is used by the device
> mapper and only by the device mapper to rerun the queue and requeue
> list after a delay. This function is called once per request that
> gets requeued. Modify this function such that the queue is run once
> per path change event instead of once per request that is requeued.

Is there a chance we could look into killing this function and moving
dm to run it every time we requeue a request like all the other drivers?
