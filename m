From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V8 02/11] block: add helper for copying request
Date: Fri, 24 Apr 2020 14:43:43 +0200
Message-ID: <2b2df3bc-edc2-7179-a57b-daad7d67cfac@suse.de>
References: <20200424102351.475641-1-ming.lei@redhat.com>
 <20200424102351.475641-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200424102351.475641-3-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/24/20 12:23 PM, Ming Lei wrote:
> Add one new helper of blk_rq_copy_request() to copy request, and the helper
> will be used in this patch for re-submitting request, so make it as a block
> layer internal helper.
> 
> Cc: John Garry <john.garry@huawei.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-core.c | 33 +++++++++++++++++++--------------
>   block/blk.h      |  2 ++
>   2 files changed, 21 insertions(+), 14 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
