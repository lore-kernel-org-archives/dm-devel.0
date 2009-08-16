From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 08/24] io-controller: cfq changes to use
	hierarchical fair queuing code in elevaotor layer
Date: Sun, 16 Aug 2009 15:30:30 -0400
Message-ID: <1250451046-9966-9-git-send-email-vgoyal@redhat.com>
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

Make cfq hierarhical.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |    8 ++++++
 block/cfq-iosched.c   |   63 ++++++++++++++++++++++++++++++++++++++++++++++--
 init/Kconfig          |    2 +-
 3 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index dd5224d..a91a807 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -54,6 +54,14 @@ config IOSCHED_CFQ
 	  working environment, suitable for desktop systems.
 	  This is the default I/O scheduler.
 
+config IOSCHED_CFQ_HIER
+	bool "CFQ Hierarchical Scheduling support"
+	depends on IOSCHED_CFQ && CGROUPS
+	select GROUP_IOSCHED
+	default n
+	---help---
+	  Enable hierarhical scheduling in cfq.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index decb654..6c1f87a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1285,6 +1285,60 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->pid = pid;
 }
 
+#ifdef CONFIG_IOSCHED_CFQ_HIER
+static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
+{
+	struct cfq_queue *async_cfqq = cic_to_cfqq(cic, 0);
+	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
+	struct cfq_data *cfqd = cic->key;
+	struct io_group *iog, *__iog;
+	unsigned long flags;
+	struct request_queue *q;
+
+	if (unlikely(!cfqd))
+		return;
+
+	q = cfqd->queue;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	iog = elv_io_get_io_group(q, 0);
+
+	if (async_cfqq != NULL) {
+		__iog = cfqq_to_io_group(async_cfqq);
+		if (iog != __iog) {
+			/* cgroup changed, drop the reference to async queue */
+			cic_set_cfqq(cic, NULL, 0);
+			cfq_put_queue(async_cfqq);
+		}
+	}
+
+	if (sync_cfqq != NULL) {
+		__iog = cfqq_to_io_group(sync_cfqq);
+
+		/*
+		 * Drop reference to sync queue. A new sync queue will
+		 * be assigned in new group upon arrival of a fresh request.
+		 * If old queue has got requests, those reuests will be
+		 * dispatched over a period of time and queue will be freed
+		 * automatically.
+		 */
+		if (iog != __iog) {
+			cic_set_cfqq(cic, NULL, 1);
+			cfq_put_queue(sync_cfqq);
+		}
+	}
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void cfq_ioc_set_cgroup(struct io_context *ioc)
+{
+	call_for_each_cic(ioc, changed_cgroup);
+	ioc->cgroup_changed = 0;
+}
+#endif  /* CONFIG_IOSCHED_CFQ_HIER */
+
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
@@ -1296,7 +1350,7 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
 	struct io_group *iog = NULL;
 
 retry:
-	iog = elv_io_get_io_group(q, 0);
+	iog = elv_io_get_io_group(q, 1);
 
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
@@ -1385,7 +1439,7 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
 	const int ioprio_class = task_ioprio_class(ioc);
 	struct cfq_queue *async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
-	struct io_group *iog = elv_io_get_io_group(cfqd->queue, 0);
+	struct io_group *iog = elv_io_get_io_group(cfqd->queue, 1);
 
 	if (!is_sync) {
 		async_cfqq = elv_io_group_async_queue_prio(iog, ioprio_class,
@@ -1540,7 +1594,10 @@ out:
 	smp_read_barrier_depends();
 	if (unlikely(ioc->ioprio_changed))
 		cfq_ioc_set_ioprio(ioc);
-
+#ifdef CONFIG_IOSCHED_CFQ_HIER
+	if (unlikely(ioc->cgroup_changed))
+		cfq_ioc_set_cgroup(ioc);
+#endif
 	return cic;
 err_free:
 	cfq_cic_free(cic);
diff --git a/init/Kconfig b/init/Kconfig
index 29f701d..afcaa86 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -613,7 +613,7 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  size is 4096bytes, 512k per 1Gbytes of swap.
 
 config GROUP_IOSCHED
-	bool "Group IO Scheduler"
+	bool
 	depends on CGROUPS && ELV_FAIR_QUEUING
 	default n
 	---help---
-- 
1.6.0.6
