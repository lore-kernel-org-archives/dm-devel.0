From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Wed, 29 Apr 2015 09:34:33 -0400
Message-ID: <20150429133433.GA23127@redhat.com>
References: <553F7474.70905@sandisk.com>
 <20150429132029.GA3876@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150429132029.GA3876@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 29 2015 at  9:20am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Apr 28, 2015 at 01:52:20PM +0200, Bart Van Assche wrote:
> > Hello,
> >
> > Earlier today I started testing an SRP initiator patch series on top of 
> > Linux kernel v4.1-rc1. Although that patch series works reliably on top of 
> > kernel v4.0, a test during which I triggered scsi_remove_host() + relogin 
> > (for p in /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done; wait; 
> > srp_daemon -oaec) triggered the following kernel oops:
> 
> Can you try the patch below?  From my cursory reading of the dm code
> it can have tio->clone allocated for a while before it sets up the ->q
> pointer for it:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f8c7ca3..ee74764 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1089,7 +1089,7 @@ static void free_rq_clone(struct request *clone)
>  
>  	blk_rq_unprep_clone(clone);
>  
> -	if (clone->q->mq_ops)
> +	if (clone->q && clone->q->mq_ops)
>  		tio->ti->type->release_clone_rq(clone);
>  	else if (!md->queue->mq_ops)
>  		/* request_fn queue stacked on request_fn queue(s) */

I'm seeing this same crash on the completion path (when using your
tcm_loop script).  But for Bart's case his stacktrace included
dm_requeue_unmapped_original_request() -- which if called from
map_request() implies clone->q won't have been initialized given
__multipath_map()'s code for setting up the old request_fn case.

Long story short: your fix is right for Bart's crash (but not the ones
I'm seeing with tcm_loop) -- I'll get it queued up with a proper header
attributed to you and cc'ing stable as needed.

Thanks,
Mike
