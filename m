From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 1/6] blk-mq: introduce blk_mq_delay_kick_requeue_list()
Date: Wed, 14 Sep 2016 10:34:48 -0600
Message-ID: <7b569638-e572-d386-d170-b49c30f5e506@kernel.dk>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
 <1473870576-54331-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-2-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/14/2016 10:29 AM, Mike Snitzer wrote:
> +void blk_mq_delay_kick_requeue_list(struct request_queue *q,
> +				    unsigned long delay)
> +{
> +	kblockd_schedule_delayed_work(&q->requeue_work, delay);
> +}
> +EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);

Leave the interface as taking msecs, but do msecs_to_jiffies() before
calling into kblockd_schedule_delayed_work().

-- 
Jens Axboe

