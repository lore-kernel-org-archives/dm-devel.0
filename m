From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/6] dm rq: add DM_MAPIO_DELAY_REQUEUE to
 delay requeue of blk-mq requests
Date: Thu, 15 Sep 2016 08:54:42 -0400
Message-ID: <20160915125442.GA6373@redhat.com>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
	<1473870576-54331-3-git-send-email-snitzer@redhat.com>
	<f8ec9117-2191-590c-582d-e41d69072fd6@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f8ec9117-2191-590c-582d-e41d69072fd6@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 15 2016 at  2:14am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 09/14/2016 06:29 PM, Mike Snitzer wrote:
> > Otherwise blk-mq will immediately dispatch requests that are requeued
> > via a BLK_MQ_RQ_QUEUE_BUSY return from blk_mq_ops .queue_rq.
> > 
> > Delayed requeue is implemented using blk_mq_delay_kick_requeue_list()
> > with a delay of 5 secs.  In the context of DM multipath (all paths down)
> > it doesn't make any sense to requeue more quickly.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm-rq.c            | 32 ++++++++++++++++++--------------
> >  include/linux/device-mapper.h |  1 +
> >  2 files changed, 19 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > index 0d301d5..9eebc8d 100644
> > --- a/drivers/md/dm-rq.c
> > +++ b/drivers/md/dm-rq.c
> [..]
> > @@ -671,7 +673,10 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
> >  		break;
> >  	case DM_MAPIO_REQUEUE:
> >  		/* The target wants to requeue the I/O */
> > -		dm_requeue_original_request(md, tio->orig);
> > +		break;
> > +	case DM_MAPIO_DELAY_REQUEUE:
> > +		/* The target wants to requeue the I/O after a delay */
> > +		dm_requeue_original_request(md, tio->orig, true);
> >  		break;
> >  	default:
> >  		if (r > 0) {
> Hmm? What happened here?
> Don't we need to requeue the request for DM_MAPIO_REQUEUE?

Yes, as always, the caller will perform the immediate requeue -- this is
a requirement for blk-mq but I made .request_fn do the same just for
consistency in the request-based DM code.

In the case of blk-mq it is done in terms of a BLK_MQ_RQ_QUEUE_BUSY
return from .queue_rq (which is the most immediate requeue there is
since blk-mq just puts the request back on its dispatch list for the
very next queue run).

(it is so quick that it causes excessive load when all paths are down,
hence this patchset to only use immediate requeue when it makes sense)

Mike
