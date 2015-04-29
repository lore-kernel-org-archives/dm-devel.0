From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix free_rq_clone() NULL pointer when requeueing
 unmapped request
Date: Wed, 29 Apr 2015 15:53:42 -0400
Message-ID: <20150429195342.GA6110@redhat.com>
References: <553F7474.70905@sandisk.com> <20150429132029.GA3876@lst.de>
	<20150429133433.GA23127@redhat.com>
	<20150429185345.GA5975@redhat.com> <55412CE0.4060909@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <55412CE0.4060909@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Aaro Koskinen <aaro.koskinen@nokia.com>
List-Id: dm-devel.ids

On Wed, Apr 29 2015 at  3:11P -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 04/29/15 20:53, Mike Snitzer wrote:
> >Actually, here is the proper 4.1-only fix (Bart please verify this works
> >for you):
> 
> Hello Mike,
> 
> Thanks for the patch. But against which tree has this patch been generated ?
> It doesn't seem to apply on v4.1-rc1:
> 
> $ git reset --hard v4.1-rc1
> HEAD is now at b787f68 Linux 4.1-rc1
> $ patch -p1 < ~/\[PATCH\]\ dm\:\ fix\ free_rq_clone\(\)\ NULL\ pointer\
> when\ requeueing\ unmapped\ request.eml
> (Stripping trailing CRs from patch; use --binary to disable.)
> patching file drivers/md/dm.c
> Hunk #1 FAILED at 1031.
> Hunk #2 succeeded at 1124 (offset 53 lines).
> Hunk #3 succeeded at 1143 (offset 53 lines).
> 1 out of 3 hunks FAILED -- saving rejects to file drivers/md/dm.c.rej

It was implemented against my "private" wip2 branch (since rebased):
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip2

Anyway, here it is rebased to 4.1-rc1 (BTW, I'm open to dropping the
WARN_ON_ONCE but I need to research further.. if you guys think that
there are perfectly resonable ways to explain why clone->q is NULL in
the IO completion path then I'm all ears):

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
index 6754bbd..dfb7bde 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1082,18 +1082,26 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	dm_put(md);
 }
 
-static void free_rq_clone(struct request *clone)
+static void free_rq_clone(struct request *clone, bool must_be_mapped)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 
+	WARN_ON_ONCE(must_be_mapped && !clone->q);
+
 	blk_rq_unprep_clone(clone);
 
-	if (clone->q->mq_ops)
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
@@ -1124,7 +1132,7 @@ static void dm_end_request(struct request *clone, int error)
 			rq->sense_len = clone->sense_len;
 	}
 
-	free_rq_clone(clone);
+	free_rq_clone(clone, true);
 	if (!rq->q->mq_ops)
 		blk_end_request_all(rq, error);
 	else
@@ -1143,7 +1151,7 @@ static void dm_unprep_request(struct request *rq)
 	}
 
 	if (clone)
-		free_rq_clone(clone);
+		free_rq_clone(clone, false);
 }
 
 /*
-- 
2.3.2 (Apple Git-55)
