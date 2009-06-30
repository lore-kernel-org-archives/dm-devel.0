From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH] io-controller: Don't expire an idle ioq if it's the only
 ioq in hierarchy
Date: Tue, 30 Jun 2009 15:49:21 +0800
Message-ID: <4A49C381.3040302@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-9-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758427AbZF3Ht4@vger.kernel.org>
In-Reply-To: <1245443858-8487-9-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Hi Vivek,

We don't expect expiring an idle ioq if it's the only ioq 
in the hierarchy.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 4270cfd..0b65e16 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -4058,12 +4058,6 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 			elv_clear_ioq_slice_new(ioq);
 		}
 
-		if (elv_ioq_class_idle(ioq)) {
-			if (elv_iosched_expire_ioq(q, 1, 0))
-				elv_ioq_slice_expired(q);
-			goto done;
-		}
-
 		/*
 		 * If there is only root group present, don't expire the queue
 		 * for single queue ioschedulers (noop, deadline, AS). It is
@@ -4077,6 +4071,12 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 			goto done;
 		}
 
+		if (elv_ioq_class_idle(ioq)) {
+			if (elv_iosched_expire_ioq(q, 1, 0))
+				elv_ioq_slice_expired(q);
+			goto done;
+		}
+
 		/* For async queue try to do wait busy */
 		if (efqd->fairness && !elv_ioq_sync(ioq) && !ioq->nr_queued
 		    && (elv_iog_nr_active(iog) <= 1)) {
-- 
1.5.4.rc3
