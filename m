From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Tue, 20 Sep 2011 11:13:54 +0400
Message-ID: <1316502834.2971.7.camel@dabdike>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
	<4E76E5E8.9040701@ce.jp.nec.com> <20110919143411.GA7965@redhat.com>
	<4E7824CB.9030405@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E7824CB.9030405@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: roland@purestorage.com, jaxboe@fusionio.com, "Alasdair G. Kergon" <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, 2011-09-20 at 14:29 +0900, Jun'ichi Nomura wrote:
> Hi Mike,
> 
> On 09/19/11 23:34, Mike Snitzer wrote:
> > On Mon, Sep 19 2011 at  2:49am -0400,
> > Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
> >> DM opens underlying devices and it should be sufficient to keep
> >> request_queue from being freed.
> > 
> > I welcome your review but please be more specific in the future.
> > 
> > Sure DM opens the underlying devices:
> > 
> > dm_get_device()
> >   -> open_dev()
> >      -> blkdev_get_by_dev()
> >      	-> bdget()
> > 	-> blkdev_get()
> > 
> > But DM only gets a reference on the associated block_device.
> 
> Point is the above should be sufficient to keep the queue from freeing.
> Otherwise, 'q->_something_' everywhere could cause invalid pointer access
> as the queue is freed.
> 
> 
> Below are additional details replying to your comments:
> 
> > 
> > DM multipath makes use of the request_queue of each paths'
> > block_device.  Having a reference on the block_device isn't the same as
> > having a reference on the request_queue.
> 
> Yes. But it does not necessarily mean we have to raise
> a reference count of the request_queue.
> 
> > 
> > Point is, blk_cleanup_queue() could easily be called by the SCSI
> > subsystem for a device that is removed -- a request_queue reference is
> > taken by the underlying driver at blk_alloc_queue_node() time.  So SCSI
> > is free to drop the only reference in blk_cleanup_queue() which frees
> > the request_queue (unless upper layer driver like mpath also takes a
> > request_queue reference).
> 
> As for SCSI, it takes another reference count and drops it
> in scsi_device_dev_release.
> So blk_cleanup_queue is not dropping the last reference.
> 
> > 
> > FYI, I got looking at mpath's request_queue references, or lack thereof,
> > because of this report/patch on LKML from Roland Drier:
> > https://lkml.org/lkml/2011/7/8/457
> > 
> > here was my follow-up to Roland:
> > https://lkml.org/lkml/2011/7/11/410
> 
> For that problem, taking a reference count is not a remedy.
> The problem occurs because elevator is freed regardless of the
> reference count.
> 
> The cause of the problem was:
>   a) SCSI has moved blk_cleanup_queue() to earlier stage
>      where there still is a opener
>   b) blk_cleanup_queue() frees elevator after marking
>      the queue DEAD
>   c) blk_insert_cloned_request() uses elevator without
>      checking QUEUE_FLAG_DEAD
> 
> Roland's patch was to fix c) by adding QUEUE_FLAG_DEAD check.
> However, it's not possible to do it safely because
> QUEUE_FLAG_DEAD means we can't even access q->queue_lock.
> (See Vivek's comment in the same thread)
> And without queue_lock, there's a window for a race.
> 
> James's suggestion was to fix b) by not freeing elevator
> until blk_release_queue() is called:
>   https://lkml.org/lkml/2011/8/10/421
> But it would hit the same issue that there's no guarantee
> of q->queue_lock validity after blk_cleanup_queue().
> James's other suggestion was to add a callback mechanism
> for driver to free q->queue_lock.

Actually, there isn't a problem with this patch:  Any driver that
expects blk_cleanup_queue to guarantee last use of the lock has to call
it as the last releaser.  If it doesn't, it would oops (or would have
oopsed before we started putting the block guards in).

> I was trying to fix a) in the following thread:
>   https://lkml.org/lkml/2011/8/18/103
> but haven't gotten response from James so it seems rejected.

I think I said quite a few times that this would reintroduce the oops I
was trying to fix.  Alan seems to think that there are sufficient guards
just to move the blk_cleanup_queue(), but I'd prefer to get
blk_cleanup_queue() working properly like the del method it's supposed
to be.

I still think this (with beefed up doc) is the correct fix.

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..f30f9bf 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -350,7 +350,11 @@ EXPORT_SYMBOL(blk_put_queue);
 /*
  * Note: If a driver supplied the queue lock, it should not zap that lock
  * unexpectedly as some queue cleanup components like elevator_exit() and
- * blk_throtl_exit() need queue lock.
+ * blk_throtl_exit() need queue lock.  If you're using blk_cleanup_queue() as
+ * the point after which you can zap the supplied lock, you *must* ensure that
+ * the blk_put_queue() in this code is the final put.  If it isn't, the
+ * elevator cleanup functions (which take the lock) won't be called and you'll
+ * get an oops when they are
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -367,11 +371,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
-
-	blk_throtl_exit(q);
-
 	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..a5a756b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -477,6 +477,11 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
+	blk_throtl_exit(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 
