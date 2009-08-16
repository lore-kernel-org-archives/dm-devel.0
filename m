From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 15/24] io-controller: noop changes for
	hierarchical fair queuing
Date: Sun, 16 Aug 2009 15:30:37 -0400
Message-ID: <1250451046-9966-16-git-send-email-vgoyal@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
Cc: paolo.valente@unimore.it, jmarchan@redhat.com, dhaval@linux.vnet.ibm.com, peterz@infradead.org, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, lizf@cn.fujitsu.com, jmoyer@redhat.com, mikew@google.com, fchecconi@gmail.com, dpshah@google.com, vgoyal@redhat.com, nauman@google.com, s-uchida@ap.jp.nec.com, akpm@linux-foundation.org, agk@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

This patch changes noop to use queue scheduling code from elevator layer.
One can go back to old noop by deselecting CONFIG_IOSCHED_NOOP_HIER.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |   11 +++++++++++
 block/noop-iosched.c  |   14 ++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index a7d0bf8..28cd500 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -25,6 +25,17 @@ config IOSCHED_NOOP
 	  that do their own scheduling and require only minimal assistance from
 	  the kernel.
 
+config IOSCHED_NOOP_HIER
+	bool "Noop Hierarchical Scheduling support"
+	depends on IOSCHED_NOOP && CGROUPS
+	select ELV_FAIR_QUEUING
+	select GROUP_IOSCHED
+	default n
+	---help---
+	  Enable hierarhical scheduling in noop. In this mode noop keeps
+	  one IO queue per cgroup instead of a global queue. Elevator
+	  fair queuing logic ensures fairness among various queues.
+
 config IOSCHED_AS
 	tristate "Anticipatory I/O scheduler"
 	default y
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 731dbf2..4ba496f 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -6,6 +6,7 @@
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include "elevator-fq.h"
 
 struct noop_queue {
 	struct list_head queue;
@@ -82,6 +83,15 @@ static void noop_free_noop_queue(struct elevator_queue *e, void *sched_queue)
 	kfree(nq);
 }
 
+#ifdef CONFIG_IOSCHED_NOOP_HIER
+static struct elv_fs_entry noop_attrs[] = {
+	ELV_ATTR(fairness),
+	ELV_ATTR(slice_sync),
+	ELV_ATTR(group_idle),
+	__ATTR_NULL
+};
+#endif
+
 static struct elevator_type elevator_noop = {
 	.ops = {
 		.elevator_merge_req_fn		= noop_merged_requests,
@@ -92,6 +102,10 @@ static struct elevator_type elevator_noop = {
 		.elevator_alloc_sched_queue_fn	= noop_alloc_noop_queue,
 		.elevator_free_sched_queue_fn	= noop_free_noop_queue,
 	},
+#ifdef CONFIG_IOSCHED_NOOP_HIER
+	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ,
+	.elevator_attrs = noop_attrs,
+#endif
 	.elevator_name = "noop",
 	.elevator_owner = THIS_MODULE,
 };
-- 
1.6.0.6
