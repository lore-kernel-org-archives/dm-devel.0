From: Christoph Hellwig <hch@lst.de>
Subject: Re: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Wed, 29 Apr 2015 15:20:29 +0200
Message-ID: <20150429132029.GA3876@lst.de>
References: <553F7474.70905@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <553F7474.70905@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 28, 2015 at 01:52:20PM +0200, Bart Van Assche wrote:
> Hello,
>
> Earlier today I started testing an SRP initiator patch series on top of 
> Linux kernel v4.1-rc1. Although that patch series works reliably on top of 
> kernel v4.0, a test during which I triggered scsi_remove_host() + relogin 
> (for p in /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done; wait; 
> srp_daemon -oaec) triggered the following kernel oops:

Can you try the patch below?  From my cursory reading of the dm code
it can have tio->clone allocated for a while before it sets up the ->q
pointer for it:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f8c7ca3..ee74764 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1089,7 +1089,7 @@ static void free_rq_clone(struct request *clone)
 
 	blk_rq_unprep_clone(clone);
 
-	if (clone->q->mq_ops)
+	if (clone->q && clone->q->mq_ops)
 		tio->ti->type->release_clone_rq(clone);
 	else if (!md->queue->mq_ops)
 		/* request_fn queue stacked on request_fn queue(s) */
