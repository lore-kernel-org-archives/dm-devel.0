From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/6] dm rq: introduce dm_mq_kick_requeue_list()
Date: Thu, 15 Sep 2016 08:16:02 +0200
Message-ID: <891299a6-69d0-5436-ebb5-4808fcf32843@suse.de>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
 <1473870576-54331-5-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-5-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/14/2016 06:29 PM, Mike Snitzer wrote:
> Make it possible for a request-based target to kick the DM device's
> blk-mq request_queue's requeue_list.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-rq.c | 17 +++++++++++++----
>  drivers/md/dm-rq.h |  2 ++
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
