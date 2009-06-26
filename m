From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH 2/2] io-controller: make rt preemption happen in the whole
 hierarchy
Date: Fri, 26 Jun 2009 16:13:51 +0800
Message-ID: <4A44833F.8040308@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-21-git-send-email-vgoyal@redhat.com> <4A3F3648.7080007@cn.fujitsu.com> <20090622172123.GE15600@redhat.com> <4A4079B8.4020402@cn.fujitsu.com> <20090623140250.GA4262@redhat.com> <4A41EFE1.5050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756396AbZFZIOZ@vger.kernel.org>
In-Reply-To: <4A41EFE1.5050101@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

let rt queue preempt non-rt queue if needed.
Make sure comparision happens at the same level.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 1d4ec1f..21d38f5 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3742,6 +3742,31 @@ int elv_iosched_expire_ioq(struct request_queue *q, int slice_expired,
 	return ret;
 }
 
+static int check_rt_preemption(struct io_queue *ioq)
+{
+	struct hlist_node *node;
+	struct hlist_head *hhead = &ioq->efqd->rt_ioq_list;
+	struct io_queue *rt_ioq;
+	struct io_entity *entity = &ioq->entity;
+	struct io_entity *new_entity;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(rt_ioq, node, hhead, rt_node) {
+		new_entity = &rt_ioq->entity;
+
+		bfq_find_matching_entity(&entity, &new_entity);
+
+		if (new_entity->ioprio_class == IOPRIO_CLASS_RT &&
+		    entity->ioprio_class != IOPRIO_CLASS_RT) {
+			rcu_read_unlock();
+			return 1;
+		}
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
 /* Common layer function to select the next queue to dispatch from */
 void *elv_fq_select_ioq(struct request_queue *q, int force)
 {
@@ -3823,7 +3848,8 @@ void *elv_fq_select_ioq(struct request_queue *q, int force)
 	 */
 	iog = ioq_to_io_group(ioq);
 
-	if (!elv_ioq_class_rt(ioq) && iog->busy_rt_queues) {
+	if (!elv_ioq_class_rt(ioq) &&
+	    (iog->busy_rt_queues || check_rt_preemption(ioq))) {
 		/*
 		 * We simulate this as cfqq timed out so that it gets to bank
 		 * the remaining of its time slice.
-- 
1.5.4.rc3
