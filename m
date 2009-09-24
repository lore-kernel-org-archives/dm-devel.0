From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 21/28] io-controller: deadline changes for hierarchical fair queuing
Date: Thu, 24 Sep 2009 15:25:25 -0400
Message-ID: <1253820332-10246-22-git-send-email-vgoyal@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753994AbZIXT0f@vger.kernel.org>
In-Reply-To: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

This patch changes deadline to use queue scheduling code from elevator layer.
One can go back to old deadline by selecting CONFIG_IOSCHED_DEADLINE_HIER.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 block/Kconfig.iosched    |   11 +++++++++++
 block/deadline-iosched.c |    9 +++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 28cd500..cc87c87 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -55,6 +55,17 @@ config IOSCHED_DEADLINE
 	  a disk at any one time, its behaviour is almost identical to the
 	  anticipatory I/O scheduler and so is a good choice.
 
+config IOSCHED_DEADLINE_HIER
+	bool "Deadline Hierarchical Scheduling support"
+	depends on IOSCHED_DEADLINE && CGROUPS
+	select ELV_FAIR_QUEUING
+	select GROUP_IOSCHED
+	default n
+	---help---
+	  Enable hierarhical scheduling in deadline. In this mode deadline keeps
+	  one IO queue per cgroup instead of a global queue. Elevator
+	  fair queuing logic ensures fairness among various queues.
+
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
 	select ELV_FAIR_QUEUING
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 6e69ea3..e5bc823 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/compiler.h>
 #include <linux/rbtree.h>
+#include "elevator-fq.h"
 
 /*
  * See Documentation/block/deadline-iosched.txt
@@ -461,6 +462,11 @@ static struct elv_fs_entry deadline_attrs[] = {
 	DD_ATTR(writes_starved),
 	DD_ATTR(front_merges),
 	DD_ATTR(fifo_batch),
+#ifdef CONFIG_IOSCHED_DEADLINE_HIER
+	ELV_ATTR(fairness),
+	ELV_ATTR(slice_sync),
+	ELV_ATTR(group_idle),
+#endif
 	__ATTR_NULL
 };
 
@@ -478,6 +484,9 @@ static struct elevator_type iosched_deadline = {
 		.elevator_alloc_sched_queue_fn = deadline_alloc_deadline_queue,
 		.elevator_free_sched_queue_fn = deadline_free_deadline_queue,
 	},
+#ifdef CONFIG_IOSCHED_DEADLINE_HIER
+	.elevator_features = ELV_IOSCHED_NEED_FQ | ELV_IOSCHED_SINGLE_IOQ,
+#endif
 	.elevator_attrs = deadline_attrs,
 	.elevator_name = "deadline",
 	.elevator_owner = THIS_MODULE,
-- 
1.6.0.6
