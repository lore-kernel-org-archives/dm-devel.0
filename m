From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 1/6] blk-mq: introduce blk_mq_delay_kick_requeue_list()
Date: Wed, 14 Sep 2016 11:49:16 -0600
Message-ID: <57cef1a1-3025-c16a-075e-46706b34a766@kernel.dk>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
 <1473870576-54331-2-git-send-email-snitzer@redhat.com>
 <7b569638-e572-d386-d170-b49c30f5e506@kernel.dk>
 <20160914172829.GA55842@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160914172829.GA55842@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/14/2016 11:28 AM, Mike Snitzer wrote:
> blk_mq_delay_kick_requeue_list() provides the ability to kick the
> q->requeue_list after a specified time.  To do this the request_queue's
> 'requeue_work' member was changed to a delayed_work.
>
> blk_mq_delay_kick_requeue_list() allows DM to defer processing requeued
> requests while it doesn't make sense to immediately requeue them
> (e.g. when all paths in a DM multipath have failed).

Applied for 4.9.

-- 
Jens Axboe

