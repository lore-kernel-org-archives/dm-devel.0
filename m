From: egoggin@emc.com
Subject: making rq_init functionality available to modules
Date: Tue, 8 Aug 2006 11:38:19 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1353@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Alasdair,

This patch exports rq_init in block/ll_rw_blk.c to be usable by GPL modules.

The initialization of a block request structure as done by rq_init is a
useful feature for use whenever one wishes to utilize a pre-allocated block
request structure in order to avoid deadlock potential of allocating one via
get_request.

Another patch will make use of rq_init to initialize messages sent by the
EMC CLARiiON dm-multipath hardware handler.  Without this patch, I can
easily reproduce a deadlock caused by the EMC CLARiiON hardware handler
trying to allocate a write request structure from a target queue which is
over its write queue threshold.  With this patch, I have yet to reproduce
this problem.

This capability could instead be implemented by making rq_init an inline
function available in blkdev.h.  Not sure which is best.

Ed


*** block/ll_rw_blk.c.orig	Thu Aug  3 04:03:45 2006
--- block/ll_rw_blk.c	Thu Aug  3 04:53:07 2006
***************
*** 277,283 ****
  
  EXPORT_SYMBOL(blk_queue_make_request);
  
! static inline void rq_init(request_queue_t *q, struct request *rq)
  {
  	INIT_LIST_HEAD(&rq->queuelist);
  	INIT_LIST_HEAD(&rq->donelist);
--- 277,283 ----
  
  EXPORT_SYMBOL(blk_queue_make_request);
  
! void rq_init(request_queue_t *q, struct request *rq)
  {
  	INIT_LIST_HEAD(&rq->queuelist);
  	INIT_LIST_HEAD(&rq->donelist);
***************
*** 300,305 ****
--- 300,307 ----
  	rq->completion_data = NULL;
  }
  
+ EXPORT_SYMBOL_GPL(rq_init);
+ 
  /**
   * blk_queue_ordered - does this queue support ordered writes
   * @q:        the request queue


*** include/linux/blkdev.h.orig	Thu Aug  3 04:27:26 2006
--- include/linux/blkdev.h	Thu Aug  3 04:29:24 2006
***************
*** 112,117 ****
--- 112,119 ----
  struct request;
  typedef void (rq_end_io_fn)(struct request *, int);
  
+ void rq_init(request_queue_t *q, struct request *rq);
+ 
  struct request_list {
  	int count[2];
  	int starved[2];
