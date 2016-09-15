From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/6] dm mpath: use dm_mq_kick_requeue_list()
Date: Thu, 15 Sep 2016 08:16:54 +0200
Message-ID: <9961e795-39f5-0d1a-80ea-785586abb0ca@suse.de>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
 <1473870576-54331-6-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-6-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/14/2016 06:29 PM, Mike Snitzer wrote:
> When reinstating a path the blk-mq request_queue's requeue_list should
> get kicked.  It makes sense to kick the requeue_list as part of the
> existing hook (previously only used by bio-based support).
> 
> Rename process_queued_bios_list to process_queued_io_list.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
