From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH] io-controller: Add io group reference handling for request
Date: Fri, 08 May 2009 17:45:32 +0800
Message-ID: <4A03FF3C.4020506@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763056AbZEHJqf@vger.kernel.org>
In-Reply-To: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek,

This patch adds io group reference handling when allocating
and removing a request.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 elevator-fq.c |   15 ++++++++++++++-
 elevator-fq.h |    5 +++++
 elevator.c    |    2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 9500619..e6d6712 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1968,11 +1968,24 @@ void elv_fq_set_request_io_group(struct request_queue *q, struct request *rq,
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	BUG_ON(!iog);
 
-	/* Store iog in rq. TODO: take care of referencing */
+	elv_get_iog(iog);
 	rq->iog = iog;
 }
 
 /*
+ * This request has been serviced. Clean up iog info and drop the reference.
+ */
+void elv_fq_unset_request_io_group(struct request *rq)
+{
+	struct io_group *iog = rq->iog;
+
+	if (iog) {
+		rq->iog = NULL;
+		elv_put_iog(iog);
+	}
+}
+
+/*
  * Find/Create the io queue the rq should go in. This is an optimization
  * for the io schedulers (noop, deadline and AS) which maintain only single
  * io queue per cgroup. In this case common layer can just maintain a
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index db3a347..96a28e9 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -512,6 +512,7 @@ static inline struct io_group *ioq_to_io_group(struct io_queue *ioq)
 extern int io_group_allow_merge(struct request *rq, struct bio *bio);
 extern void elv_fq_set_request_io_group(struct request_queue *q,
 					struct request *rq, struct bio *bio);
+extern void elv_fq_unset_request_io_group(struct request *rq);
 static inline bfq_weight_t iog_weight(struct io_group *iog)
 {
 	return iog->entity.weight;
@@ -571,6 +572,10 @@ static inline void elv_fq_set_request_io_group(struct request_queue *q,
 {
 }
 
+static inline void elv_fq_unset_request_io_group(struct request *rq)
+{
+}
+
 static inline bfq_weight_t iog_weight(struct io_group *iog)
 {
 	/* Just root group is present and weight is immaterial. */
diff --git a/block/elevator.c b/block/elevator.c
index 44c9fad..d75eec7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -992,6 +992,8 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	elv_fq_unset_request_io_group(rq);
+
 	/*
 	 * Optimization for noop, deadline and AS which maintain only single
 	 * ioq per io group
