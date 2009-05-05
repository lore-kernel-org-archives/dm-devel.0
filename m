From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 06/18] io-controller: cfq changes to use
	hierarchical fair queuing code in elevaotor layer
Date: Tue,  5 May 2009 15:58:33 -0400
Message-ID: <1241553525-28095-7-git-send-email-vgoyal__16686.2685852267$1243384448$gmane$org@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.
Cc: akpm@linux-foundation.org, vgoyal@redhat.com
List-Id: dm-devel.ids

Make cfq hierarhical.

Signed-off-by: Nauman Rafique <nauman@google.com>
Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |    8 ++++++++
 block/cfq-iosched.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig          |    2 +-
 3 files changed, 57 insertions(+), 1 deletions(-)

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
index f90c534..1e9dd5b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1229,6 +1229,50 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 	ioc->ioprio_changed = 0;
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
+	iog = io_lookup_io_group_current(q);
+
+	if (async_cfqq != NULL) {
+		__iog = cfqq_to_io_group(async_cfqq);
+
+		if (iog != __iog) {
+			cic_set_cfqq(cic, NULL, 0);
+			cfq_put_queue(async_cfqq);
+		}
+	}
+
+	if (sync_cfqq != NULL) {
+		__iog = cfqq_to_io_group(sync_cfqq);
+		if (iog != __iog)
+			io_ioq_move(q->elevator, sync_cfqq->ioq, iog);
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
@@ -1494,6 +1538,10 @@ out:
 	smp_read_barrier_depends();
 	if (unlikely(ioc->ioprio_changed))
 		cfq_ioc_set_ioprio(ioc);
+#ifdef CONFIG_IOSCHED_CFQ_HIER
+	if (unlikely(ioc->cgroup_changed))
+		cfq_ioc_set_cgroup(ioc);
+#endif
 	return cic;
 err_free:
 	cfq_cic_free(cic);
diff --git a/init/Kconfig b/init/Kconfig
index ab76477..1a4686d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -607,7 +607,7 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  size is 4096bytes, 512k per 1Gbytes of swap.
 
 config GROUP_IOSCHED
-	bool "Group IO Scheduler"
+	bool
 	depends on CGROUPS && ELV_FAIR_QUEUING
 	default n
 	---help---
-- 
1.6.0.1
