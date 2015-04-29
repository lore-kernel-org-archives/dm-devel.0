From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: fix free_rq_clone() NULL pointer when
 requeueing unmapped request
Date: Wed, 29 Apr 2015 14:53:45 -0400
Message-ID: <20150429185345.GA5975@redhat.com>
References: <553F7474.70905@sandisk.com> <20150429132029.GA3876@lst.de>
	<20150429133433.GA23127@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150429133433.GA23127@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Aaro Koskinen <aaro.koskinen@nokia.com>
List-Id: dm-devel.ids

On Wed, Apr 29 2015 at  9:34am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Apr 29 2015 at  9:20am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Tue, Apr 28, 2015 at 01:52:20PM +0200, Bart Van Assche wrote:
> > > Hello,
> > >
> > > Earlier today I started testing an SRP initiator patch series on top of 
> > > Linux kernel v4.1-rc1. Although that patch series works reliably on top of 
> > > kernel v4.0, a test during which I triggered scsi_remove_host() + relogin 
> > > (for p in /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done; wait; 
> > > srp_daemon -oaec) triggered the following kernel oops:
> > 
> > Can you try the patch below?  From my cursory reading of the dm code
> > it can have tio->clone allocated for a while before it sets up the ->q
> > pointer for it:
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index f8c7ca3..ee74764 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1089,7 +1089,7 @@ static void free_rq_clone(struct request *clone)
> >  
> >  	blk_rq_unprep_clone(clone);
> >  
> > -	if (clone->q->mq_ops)
> > +	if (clone->q && clone->q->mq_ops)
> >  		tio->ti->type->release_clone_rq(clone);
> >  	else if (!md->queue->mq_ops)
> >  		/* request_fn queue stacked on request_fn queue(s) */
> 
> I'm seeing this same crash on the completion path (when using your
> tcm_loop script).  But for Bart's case his stacktrace included
> dm_requeue_unmapped_original_request() -- which if called from
> map_request() implies clone->q won't have been initialized given
> __multipath_map()'s code for setting up the old request_fn case.
> 
> Long story short: your fix is right for Bart's crash (but not the ones
> I'm seeing with tcm_loop) -- I'll get it queued up with a proper header
> attributed to you and cc'ing stable as needed.

Actually, here is the proper 4.1-only fix (Bart please verify this works
for you):

From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 29 Apr 2015 10:48:09 -0400
Subject: dm: fix free_rq_clone() NULL pointer when requeueing unmapped request

Commit 022333427a ("dm: optimize dm_mq_queue_rq to _not_ use kthread if
using pure blk-mq") mistakenly removed free_rq_clone()'s clone->q check
before testing clone->q->mq_ops.  It was an oversight to discontinue
that check for 1 of the 2 use-cases for free_rq_clone():
1) free_rq_clone() called when an unmapped original request is requeued
2) free_rq_clone() called in the request-based IO completion path

The clone->q check made sense for case #1 but not for #2.  However, we
cannot just reinstate the check as it'd mask a serious bug in the IO
completion case #2 -- no in-flight request should have an uninitialized
request_queue (basic block layer refcounting _should_ ensure this).

The NULL pointer seen for case #1 is detailed here:
https://www.redhat.com/archives/dm-devel/2015-April/msg00160.html

Fix this free_rq_clone() NULL pointer by simply checking if the
mapped_device's type is DM_TYPE_MQ_REQUEST_BASED (clone's queue is
blk-mq) rather than checking clone->q->mq_ops.  This avoids the need to
dereference clone->q, but a WARN_ON_ONCE is added to let us know if an
uninitialized clone request is being completed.

Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3d34b5d..5998c26 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1031,16 +1031,24 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	dm_put(md);
 }
 
-static void free_rq_clone(struct request *clone)
+static void free_rq_clone(struct request *clone, bool must_be_mapped)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 
-	if (clone->q->mq_ops)
+	WARN_ON_ONCE(must_be_mapped && !clone->q);
+
+	if (md->type == DM_TYPE_MQ_REQUEST_BASED)
+		/* stacked on blk-mq queue(s) */
 		tio->ti->type->release_clone_rq(clone);
 	else if (!md->queue->mq_ops)
 		/* request_fn queue stacked on request_fn queue(s) */
 		free_clone_request(md, clone);
+	/*
+	 * NOTE: for the blk-mq queue stacked on request_fn queue(s) case:
+	 * no need to call free_clone_request() because we leverage blk-mq by
+	 * allocating the clone at the end of the blk-mq pdu (see: clone_rq)
+	 */
 
 	if (!md->queue->mq_ops)
 		free_rq_tio(tio);
@@ -1071,7 +1079,7 @@ static void dm_end_request(struct request *clone, int error)
 			rq->sense_len = clone->sense_len;
 	}
 
-	free_rq_clone(clone);
+	free_rq_clone(clone, true);
 	if (!rq->q->mq_ops)
 		blk_end_request_all(rq, error);
 	else
@@ -1090,7 +1098,7 @@ static void dm_unprep_request(struct request *rq)
 	}
 
 	if (clone)
-		free_rq_clone(clone);
+		free_rq_clone(clone, false);
 }
 
 /*
-- 
2.3.2 (Apple Git-55)
