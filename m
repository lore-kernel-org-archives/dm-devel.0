From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: switch IO scheduler of underlying paths to "none"
 [was: Re: BFQ + dm-mpath]
Date: Fri, 8 Sep 2017 12:41:29 -0400
Message-ID: <20170908164129.GA48286@redhat.com>
References: <1503611578.2899.69.camel@wdc.com>
 <AE77899A-0365-4C7C-91E4-5ACCC396B26B@linaro.org>
 <ED23C7AC-F202-40E3-8421-E714BF446399@linaro.org>
 <1504620914.4135.11.camel@wdc.com>
 <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
Sender: linux-block-owner@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>, axboe@kernel.dk, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 08 2017 at  5:13P -0400,
Paolo Valente <paolo.valente@linaro.org> wrote:

> 
> > Il giorno 07 set 2017, alle ore 17:52, Mike Snitzer <snitzer@redhat.com> ha scritto:
> > 
> > On Tue, Sep 05 2017 at 10:15am -0400,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > 
> >> On Tue, 2017-09-05 at 09:56 +0200, Paolo Valente wrote:
> >>> Ok, my suspects seem confirmed: the path dm_mq_queue_rq -> map_request
> >>> -> setup_clone -> blk_rq_prep_clone creates a cloned request without
> >>> invoking e->type->ops.mq.prepare_request for the target elevator e.
> >>> The cloned request is therefore not initialized for the scheduler, but
> >>> it is however inserted into the scheduler by
> >>> blk_mq_sched_insert_request.  This seems an error for any scheduler
> >>> that needs to initialize fields in the incoming request, or in general
> >>> to take some preliminary action.
> >>> 
> >>> Am I missing something here?
> >> 
> >> (+Mike Snitzer)
> >> 
> >> Mike, do you perhaps have the time to look into this memory leak?
> > 
> > It isn't a memory leak, it is missing initialization in the case of
> > cloned requests (if I'm understanding Paolo correctly).
> > 
> 
> Exactly!
> 
> > But cloned requests shouldn't be going through the scheduler.  Only the
> > original requests should.
> > 
> > Commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
> > schedulers") switched from blk_mq_insert_request() to
> > blk_mq_sched_insert_request() and in doing so it opened dm-mpath up to
> > this bug.
> > 
> > Could be we need to take steps to ensure the block layer still
> > supports bypassing the elevator by using direct insertion?
> > 
> > Or blk_mq_sched_insert_request() needs updating to check if
> > e->type->ops.mq.prepare_request were actually performed and to fallback
> > to the !elevator case if not..
> > 
> > Not sure on the fix, but I can look closer if others (like Jens or
> > Paolo) don't have quicker suggestions.
> > 
> 
> No quick suggestion from me :(
> 
> Thanks for analyzing this bug,

Please see the following untested patch.  All
testing/review/comments/acks appreciated.

I elected to use elevator_change() rather than fiddle with adding a new
blk-mq elevator hook (e.g. ->request_prepared) to verify that each
blk-mq elevator enabled request did in fact get prepared.

Bart, please test this patch and reply with your review/feedback.

Jens, if you're OK with this solution please reply with your Ack and
I'll send it to Linus along with the rest of the handful of DM changes I
have for 4.14.

Thanks,
Mike

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 8 Sep 2017 11:45:13 -0400
Subject: [PATCH] dm mpath: switch IO scheduler of underlying paths to "none"

A NULL pointer crash was reported for the case of having the BFQ IO
scheduler attached to the underlying paths of a DM multipath device.
The crash occurs in blk_mq_sched_insert_request()'s call to
e->type->ops.mq.insert_requests().

Paolo Valente correctly summarized why the crash occured with:
"the call chain (dm_mq_queue_rq -> map_request -> setup_clone ->
blk_rq_prep_clone) creates a cloned request without invoking
e->type->ops.mq.prepare_request for the target elevator e.  The cloned
request is therefore not initialized for the scheduler, but it is
however inserted into the scheduler by blk_mq_sched_insert_request."

All said, there is no reason for IO scheduling in the underlying paths
because the top-level DM multipath request_queue handles all IO
scheduling of the original requests issued to the multipath device.  The
multipath device's clones of the original requests are then just inserted
directly into the underlying path's dispatch queue(s).

Commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
schedulers") switched blk_insert_cloned_request() from using
blk_mq_insert_request() to blk_mq_sched_insert_request().  Which
incorrectly added elevator machinery into a call chain that isn't
supposed to have any.

To fix this DM multipath now explicitly removes the IO scheduler from
all underlying paths during multipath device initialization.  To do so
elevator_change() is needed, so elevator_change() is reinstated by
reverting commit c033269490 ("block: Remove elevator_change()").

Fixes: bd166ef18 ("blk-mq-sched: add framework for MQ capable IO schedulers")
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/elevator.c         | 13 +++++++++++++
 drivers/md/dm-mpath.c    | 14 ++++++++++++--
 include/linux/elevator.h |  1 +
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 4bb2f0c..a5d9639 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1084,6 +1084,19 @@ static int __elevator_change(struct request_queue *q, const char *name)
 	return elevator_switch(q, e);
 }
 
+int elevator_change(struct request_queue *q, const char *name)
+{
+	int ret;
+
+	/* Protect q->elevator from elevator_init() */
+	mutex_lock(&q->sysfs_lock);
+	ret = __elevator_change(q, name);
+	mutex_unlock(&q->sysfs_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(elevator_change);
+
 static inline bool elv_support_iosched(struct request_queue *q)
 {
 	if (q->mq_ops && q->tag_set && (q->tag_set->flags &
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bf280a9..de046b0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -25,6 +25,7 @@
 #include <scsi/scsi_dh.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
+#include <linux/elevator.h>
 
 #define DM_MSG_PREFIX "multipath"
 #define DM_PG_INIT_DELAY_MSECS 2000
@@ -757,8 +758,17 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) || m->hw_handler_name)
-		q = bdev_get_queue(p->path.dev->bdev);
+	q = bdev_get_queue(p->path.dev->bdev);
+
+	/*
+	 * The underlying path's IO scheduler is _not_ used because all
+	 * scheduling is done by the top-level multipath request_queue.
+	 */
+	if (elevator_change(q, "none")) {
+		ti->error = "error switching underlying path's IO scheduler to 'none'";
+		dm_put_device(ti, p->path.dev);
+		goto bad;
+	}
 
 	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
 retain:
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 5bc8f86..fe24004 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -220,6 +220,7 @@ extern ssize_t elv_iosched_store(struct request_queue *, const char *, size_t);
 
 extern int elevator_init(struct request_queue *, char *);
 extern void elevator_exit(struct request_queue *, struct elevator_queue *);
+extern int elevator_change(struct request_queue *, const char *);
 extern bool elv_bio_merge_ok(struct request *, struct bio *);
 extern struct elevator_queue *elevator_alloc(struct request_queue *,
 					struct elevator_type *);
-- 
2.10.1
