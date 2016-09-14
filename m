From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] blk-mq: introduce blk_mq_delay_kick_requeue_list()
Date: Wed, 14 Sep 2016 09:04:23 -0600
Message-ID: <90cdf652-555a-e88a-72b2-0a81926d78e3@kernel.dk>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473782495-44128-2-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/13/2016 10:01 AM, Mike Snitzer wrote:
> blk_mq_delay_kick_requeue_list() provides the ability to kick the
> q->requeue_list after a specified time.  To do this the request_queue's
> 'requeue_work' member was changed to a delayed_work.
>
> blk_mq_delay_kick_requeue_list() allows DM to defer processing requeued
> requests while it doesn't make sense to immediately requeue them
> (e.g. when all paths in a DM multipath have failed).

Looks fine to me, sans the missing jiffies conversion that Bart pointed
out.

-- 
Jens Axboe

