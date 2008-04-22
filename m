From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 2/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:53:01 +0900 (JST)
Message-ID: <20080422.225301.114961903.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Every I/O scheduler should get a iocontext from a given bio,
not from the current process.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/block/blk-core.c	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/block/blk-core.c	2008-04-22 16:13:31.000000000 +0900
@@ -600,7 +600,8 @@ static inline void blk_free_request(stru
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask,
+						struct io_context *ioc)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -614,7 +615,7 @@ blk_alloc_request(struct request_queue *
 	rq->cmd_flags = rw | REQ_ALLOCED;
 
 	if (priv) {
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
+		if (unlikely(elv_set_request(q, rq, gfp_mask, ioc))) {
 			mempool_free(rq, q->rq.rq_pool);
 			return NULL;
 		}
@@ -702,7 +703,7 @@ static struct request *get_request(struc
 {
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
-	struct io_context *ioc = NULL;
+	struct io_context *ioc;
 	const int rw = rw_flags & 0x01;
 	int may_queue, priv;
 
@@ -710,9 +711,12 @@ static struct request *get_request(struc
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
+	ioc = bio ? bio->bi_io_context : current->io_context;
+
 	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
 		if (rl->count[rw]+1 >= q->nr_requests) {
-			ioc = current_io_context(GFP_ATOMIC, q->node);
+			if (!ioc)
+				ioc = current_io_context(GFP_ATOMIC, q->node);
 			/*
 			 * The queue will fill after this allocation, so set
 			 * it as full, and mark this process as "batching".
@@ -754,7 +758,7 @@ static struct request *get_request(struc
 
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask, ioc);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
--- linux-2.6.25.bio0/include/linux/elevator.h	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/include/linux/elevator.h	2008-04-22 15:51:27.000000000 +0900
@@ -22,7 +22,7 @@ typedef struct request *(elevator_reques
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t, struct io_context *);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
@@ -113,7 +113,7 @@ extern int elv_register_queue(struct req
 extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
 extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
+extern int elv_set_request(struct request_queue *, struct request *, gfp_t, struct io_context *);
 extern void elv_put_request(struct request_queue *, struct request *);
 
 /*
--- linux-2.6.25.bio0/block/elevator.c	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/block/elevator.c	2008-04-22 15:51:27.000000000 +0900
@@ -864,12 +864,13 @@ struct request *elv_former_request(struc
 	return NULL;
 }
 
-int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int elv_set_request(struct request_queue *q, struct request *rq,
+				 gfp_t gfp_mask, struct io_context *ioc)
 {
 	elevator_t *e = q->elevator;
 
 	if (e->ops->elevator_set_req_fn)
-		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
+		return e->ops->elevator_set_req_fn(q, rq, gfp_mask, ioc);
 
 	rq->elevator_private = NULL;
 	return 0;
--- linux-2.6.25.bio0/block/cfq-iosched.c	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/block/cfq-iosched.c	2008-04-22 17:15:21.000000000 +0900
@@ -1571,14 +1571,16 @@ static int cfq_cic_link(struct cfq_data 
  * than one device managed by cfq.
  */
 static struct cfq_io_context *
-cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
+cfq_get_io_context(struct cfq_data *cfqd, struct io_context *ioc, gfp_t gfp_mask)
 {
-	struct io_context *ioc = NULL;
 	struct cfq_io_context *cic;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	ioc = get_io_context(gfp_mask, cfqd->queue->node);
+	ioc = ioc_object_link(ioc);
+
+	if (!ioc)
+		ioc = get_io_context(gfp_mask, cfqd->queue->node);
 	if (!ioc)
 		return NULL;
 
@@ -1938,7 +1940,8 @@ static void cfq_put_request(struct reque
  * Allocate cfq data structures associated with this request.
  */
 static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask,
+				struct io_context *ioc)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
@@ -1949,7 +1952,7 @@ cfq_set_request(struct request_queue *q,
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
-	cic = cfq_get_io_context(cfqd, gfp_mask);
+	cic = cfq_get_io_context(cfqd, ioc, gfp_mask);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
