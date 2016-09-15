From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/6] dm mpath: delay the requeue of blk-mq requests
 while all paths down
Date: Thu, 15 Sep 2016 08:18:13 +0200
Message-ID: <91b009ed-c3a6-de08-aa91-43054196b037@suse.de>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
 <1473870576-54331-7-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-7-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/14/2016 06:29 PM, Mike Snitzer wrote:
> Return DM_MAPIO_DELAY_REQUEUE from .clone_and_map_rq.  Also, return
> false from .busy, if all paths are down, so that blk-mq requests get
> mapped via .clone_and_map_rq -- which results in DM_MAPIO_DELAY_REQUEUE
> being returned to dm-rq.
> 
> This change allows for a noticeable reduction in cpu utilization
> (reduced kworker load) while all paths are down, e.g.:
> 
> system CPU idleness (as measured by fio's --idle-prof=system):
> before: system: 86.58%
> after:  system: 98.60%
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
