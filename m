From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] swait: export the symbols __prepare_to_swait
 and __finish_swait
Date: Wed, 22 Nov 2017 21:35:36 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711222134370.2330@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

In order to reduce locking overhead, I use the spinlock in
swait_queue_head to protect not only the wait queue, but also the list of
events. Consequently, I need to use unlocked functions __prepare_to_swait
and __finish_swait. These functions are declared in the file
include/linux/swait.h, but they are not exported, and so they are not
useable from kernel modules.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 kernel/sched/swait.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/sched/swait.c
===================================================================
--- linux-2.6.orig/kernel/sched/swait.c
+++ linux-2.6/kernel/sched/swait.c
@@ -73,6 +73,7 @@ void __prepare_to_swait(struct swait_que
 	if (list_empty(&wait->task_list))
 		list_add(&wait->task_list, &q->task_list);
 }
+EXPORT_SYMBOL(__prepare_to_swait);
 
 void prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait, int state)
 {
@@ -102,6 +103,7 @@ void __finish_swait(struct swait_queue_h
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
 }
+EXPORT_SYMBOL(__finish_swait);
 
 void finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
 {
