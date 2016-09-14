From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue
 of blk-mq requests
Date: Wed, 14 Sep 2016 09:51:21 -0400
Message-ID: <20160914135121.GB29338@redhat.com>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
 <1473782495-44128-3-git-send-email-snitzer@redhat.com>
 <1bffba61-1643-54ea-2e8d-a24326bd2381@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1bffba61-1643-54ea-2e8d-a24326bd2381@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 14 2016 at  2:24am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 09/13/2016 06:01 PM, Mike Snitzer wrote:
> > Otherwise blk-mq will immediately dispatch requests that are requeued
> > via a BLK_MQ_RQ_QUEUE_BUSY return from blk_mq_ops .queue_rq.
> > 
> > Delayed requeue is implemented using blk_mq_delay_kick_requeue_list()
> > with a delay of 5 secs.  In the context of DM multipath (all paths down)
> > it doesn't make any sense to requeue more quickly.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm-rq.c            | 35 ++++++++++++++++++++---------------
> >  include/linux/device-mapper.h |  1 +
> >  2 files changed, 21 insertions(+), 15 deletions(-)
> > 
> Hmm. Not sure if I agree with the reasoning for a 5 seconds delay; this
> seems to be a rather broad estimate.
> Won't it delay I/O resumption when we have intermittent path failure (eg
> on iSCSI)?

Are you saying the path would be reinstated via the 'reinstate_path'
message or by table reload?  Table reload will kick the requeue list.
'reinstate_path' doesn't (and there isn't an easy way to have dm-mpath
inform dm-rq core to do so -- could add a new function...)

If I can wire up requeue list kick on reinstate_path then the 5 secs is
perfectly fine and won't hurt how quickly IO is resumed once a path
comes back.
