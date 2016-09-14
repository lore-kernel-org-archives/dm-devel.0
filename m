From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] blk-mq: introduce blk_mq_delay_kick_requeue_list()
Date: Wed, 14 Sep 2016 08:22:17 +0200
Message-ID: <a284da09-dbb7-5582-91ed-f5654386b579@suse.de>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473782495-44128-2-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/13/2016 06:01 PM, Mike Snitzer wrote:
> blk_mq_delay_kick_requeue_list() provides the ability to kick the
> q->requeue_list after a specified time.  To do this the request_queue's
> 'requeue_work' member was changed to a delayed_work.
> 
> blk_mq_delay_kick_requeue_list() allows DM to defer processing requeued
> requests while it doesn't make sense to immediately requeue them
> (e.g. when all paths in a DM multipath have failed).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-mq.c         | 15 +++++++++++----
>  include/linux/blk-mq.h |  1 +
>  include/linux/blkdev.h |  2 +-
>  3 files changed, 13 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
