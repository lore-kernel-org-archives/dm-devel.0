From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] dm mpath: delay the requeue of blk-mq requests while
 all paths down
Date: Wed, 14 Sep 2016 08:25:51 +0200
Message-ID: <a20ea38d-4dce-3302-3e9a-bc46e250f556@suse.de>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-4-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473782495-44128-4-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/13/2016 06:01 PM, Mike Snitzer wrote:
> Return DM_MAPIO_DELAY_REQUEUE from .clone_and_map_rq.  Also, return
> false from .busy, if all paths are down, so that blk-mq requests get
> mapped via .clone_and_map_rq -- which results in DM_MAPIO_DELAY_REQUEUE
> being returned to dm-rq.
> 
> This change allows for a noticeable reduction in cpu utilization
> (reduced kworker load) while all paths are down, e.g.:
> 
> system CPU idleness (as measured by fio's --idle-prof=system):
> before: system: 87.53%
> after:  system: 97.07%
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
