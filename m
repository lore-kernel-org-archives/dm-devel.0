From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 17/24] io-controller: deadline changes for
	hierarchical fair queuing
Date: Fri, 24 Jul 2009 16:27:47 -0400
Message-ID: <1248467274-32073-18-git-send-email-vgoyal@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, ryov@valinux.co.jp, guijianfeng@c
Cc: paolo.valente@unimore.it, dhaval@linux.vnet.ibm.com, peterz@infradead.org, fernando@oss.ntt.co.jp, lizf@cn.fujitsu.com, jmoyer@redhat.com, mikew@google.com, fchecconi@gmail.com, vgoyal@redhat.com, s-uchida@ap.jp.nec.com, akpm@linux-foundation.org, agk@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

This patch changes deadline to use queue scheduling code from elevator layer.
One can go back to old deadline by selecting CONFIG_IOSCHED_DEADLINE_HIER.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched    |   11 +++++++++++
 block/deadline-iosched.c |    8 ++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

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
index 6e69ea3..73cd98f 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -461,6 +461,11 @@ static struct elv_fs_entry deadline_attrs[] = {
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
 
@@ -478,6 +483,9 @@ static struct elevator_type iosched_deadline = {
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
