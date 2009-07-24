From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 16/24] io-controller: noop changes for hierarchical fair queuing
Date: Fri, 24 Jul 2009 16:27:46 -0400
Message-ID: <1248467274-32073-17-git-send-email-vgoyal@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754217AbZGXU2w@vger.kernel.org>
In-Reply-To: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, ryov@valinux.co.jp, guijianfeng@
Cc: lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

This patch changes noop to use queue scheduling code from elevator layer.
One can go back to old noop by deselecting CONFIG_IOSCHED_NOOP_HIER.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |   11 +++++++++++
 block/noop-iosched.c  |   13 +++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

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
index 731dbf2..5811ea2 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -82,6 +82,15 @@ static void noop_free_noop_queue(struct elevator_queue *e, void *sched_queue)
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
@@ -92,6 +101,10 @@ static struct elevator_type elevator_noop = {
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
