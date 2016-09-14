From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue of
 blk-mq requests
Date: Wed, 14 Sep 2016 08:24:58 +0200
Message-ID: <1bffba61-1643-54ea-2e8d-a24326bd2381@suse.de>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-3-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473782495-44128-3-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/13/2016 06:01 PM, Mike Snitzer wrote:
> Otherwise blk-mq will immediately dispatch requests that are requeued
> via a BLK_MQ_RQ_QUEUE_BUSY return from blk_mq_ops .queue_rq.
> 
> Delayed requeue is implemented using blk_mq_delay_kick_requeue_list()
> with a delay of 5 secs.  In the context of DM multipath (all paths down)
> it doesn't make any sense to requeue more quickly.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-rq.c            | 35 ++++++++++++++++++++---------------
>  include/linux/device-mapper.h |  1 +
>  2 files changed, 21 insertions(+), 15 deletions(-)
> 
Hmm. Not sure if I agree with the reasoning for a 5 seconds delay; this
seems to be a rather broad estimate.
Won't it delay I/O resumption when we have intermittent path failure (eg
on iSCSI)?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
