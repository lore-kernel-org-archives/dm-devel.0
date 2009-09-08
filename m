From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 24/23] io-controller: Don't leave a queue active when a
	disk is idle
Date: Tue, 8 Sep 2009 18:28:21 -0400
Message-ID: <20090908222821.GB3558@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752496AbZIHW3H@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids


o It is possible that when there is only a single queue in the system, it
  remains unexpired for a long time (because there is no IO activity on the
  disk). So when next request comes in after a long time, it might make
  scheduler think that all this while queue used the disk and it will assign
  a high vdisktime to the queue. Hence make sure queue is expired once all
  the requests have completed from the queue.

o Also avoid unnecessarily expiring a queue when it has got one request
  dispatched to the queue and waiting for it to finish and it does not have
  more requests queued to dispatch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux16/block/elevator-fq.c
===================================================================
--- linux16.orig/block/elevator-fq.c	2009-09-08 15:43:36.000000000 -0400
+++ linux16/block/elevator-fq.c	2009-09-08 15:44:21.000000000 -0400
@@ -2947,6 +2947,10 @@ void *elv_select_ioq(struct request_queu
 	if (ioq == NULL)
 		goto new_queue;
 
+	/* There is only one active queue which is empty. Nothing to dispatch */
+	if (elv_nr_busy_ioq(q->elevator) == 1 && !ioq->nr_queued)
+		return NULL;
+
 	iog = ioq_to_io_group(ioq);
 
 	/*
@@ -3236,6 +3240,17 @@ void elv_ioq_completed_request(struct re
 			else
 				elv_iog_arm_slice_timer(q, iog, 0);
 		}
+
+		/*
+		 * if this is only queue and it has completed all its requests
+		 * and has nothing to dispatch, expire it. We don't want to
+		 * keep it around idle otherwise later when it is expired, all
+		 * this idle time will be added to queue's disk time used.
+		 */
+		if (efqd->busy_queues == 1 && !ioq->dispatched &&
+		   !ioq->nr_queued && !timer_pending(&efqd->idle_slice_timer)) {
+			elv_slice_expired(q);
+		}
 	}
 done:
 	if (!efqd->rq_in_driver)
