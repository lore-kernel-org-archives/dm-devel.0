From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 12/20] io-controller: deadline changes for hierarchical fair queuing
Date: Tue, 26 May 2009 18:42:01 -0400
Message-ID: <1243377729-2176-13-git-send-email-vgoyal@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758941AbZEZWoQ@vger.kernel.org>
In-Reply-To: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@googl
Cc: agk@redhat.com, snitzer@redhat.com, vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

This patch changes deadline to use queue scheduling code from elevator layer.
One can go back to old deadline by selecting CONFIG_IOSCHED_DEADLINE_HIER.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched    |   11 +++++++++++
 block/deadline-iosched.c |    3 +++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 9da6657..3a9e7d7 100644
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
index 5e65041..27b77b9 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -477,6 +477,9 @@ static struct elevator_type iosched_deadline = {
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
1.6.0.1
