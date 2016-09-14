From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 1/3] blk-mq: introduce blk_mq_delay_kick_requeue_list()
Date: Wed, 14 Sep 2016 13:28:21 +0200
Message-ID: <7745fd2a-b8e3-f2c8-5154-4f0bcd263338@acm.org>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473782495-44128-2-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/13/2016 06:01 PM, Mike Snitzer wrote:
> +void blk_mq_delay_kick_requeue_list(struct request_queue *q,
> +				    unsigned long msecs)
> +{
> +	kblockd_schedule_delayed_work(&q->requeue_work, msecs);
> +}
> +EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);

Hello Mike,

I think kblockd_schedule_delayed_work() expects that the second argument 
is a number of jiffies instead of a number of milliseconds.

Bart.
