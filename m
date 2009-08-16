From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 24/24] io-controller: debug elevator fair queuing
	support
Date: Sun, 16 Aug 2009 15:30:46 -0400
Message-ID: <1250451046-9966-25-git-send-email-vgoyal@redhat.com>
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

o More debugging help to debug elevator fair queuing support. Enabled under
  CONFIG_DEBUG_ELV_FAIR_QUEUING. Currently it prints vdisktime related
  trace messages in blktrace.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |    9 +++++++++
 block/elevator-fq.c   |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 8b507c4..edcd317 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -15,6 +15,15 @@ config ELV_FAIR_QUEUING
 	  other ioschedulers can make use of it.
 	  If unsure, say N.
 
+config DEBUG_ELV_FAIR_QUEUING
+	bool "Debug elevator fair queuing"
+	depends on ELV_FAIR_QUEUING
+	default n
+	---help---
+	  Enable some debugging hooks for elevator fair queuing support.
+	  Currently it just outputs more information about vdisktime in
+	  blktrace output .
+
 config IOSCHED_NOOP
 	bool
 	default y
diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 2f7a419..d04e925 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -34,6 +34,24 @@ static struct kmem_cache *elv_ioq_pool;
 #define ELV_SERVICE_TREE_INIT   ((struct io_service_tree)	\
 				{ RB_ROOT, NULL, 0, NULL, 0})
 
+#ifdef CONFIG_DEBUG_ELV_FAIR_QUEUING
+#define elv_log_entity(entity, fmt, args...) 			\
+{                                                               \
+{								\
+	struct io_queue *ioq = ioq_of(entity);			\
+	struct io_group *iog = iog_of(entity);			\
+								\
+	if (ioq) {						\
+		elv_log_ioq(ioq->efqd, ioq, fmt, ##args);	\
+	} else	{						\
+		elv_log_iog((struct elv_fq_data *)iog->key, iog, fmt, ##args);\
+	}							\
+}								\
+}
+#else
+#define elv_log_entity(entity, fmt, args...)
+#endif
+
 static inline struct io_queue *ioq_of(struct io_entity *entity)
 {
 	if (entity->my_sd == NULL)
@@ -350,15 +368,39 @@ static inline void debug_update_stats_enqueue(struct io_entity *entity) {}
 static inline void debug_update_stats_dequeue(struct io_entity *entity) {}
 #endif /* DEBUG_GROUP_IOSCHED */
 
+#ifdef CONFIG_DEBUG_ELV_FAIR_QUEUING
+static inline void debug_entity_vdisktime(struct io_entity *entity,
+					unsigned long served, u64 delta)
+{
+	struct elv_fq_data *efqd;
+	struct io_group *iog;
+
+	elv_log_entity(entity, "vdisktime=%llu service=%lu delta=%llu"
+				" entity->weight=%u", entity->vdisktime,
+				served, delta, entity->weight);
+
+	iog = iog_of(parent_entity(entity));
+	efqd = iog->key;
+	elv_log_iog(efqd, iog, "min_vdisktime=%llu", entity->st->min_vdisktime);
+}
+#else /* DEBUG_ELV_FAIR_QUEUING */
+static inline void debug_entity_vdisktime(struct io_entity *entity,
+					unsigned long served, u64 delta) {}
+#endif /* DEBUG_ELV_FAIR_QUEUING */
+
 static void
 entity_served(struct io_entity *entity, unsigned long served,
 				unsigned long nr_sectors)
 {
 	for_each_entity(entity) {
-		entity->vdisktime += elv_delta_fair(served, entity);
+		u64 delta;
+
+		delta = elv_delta_fair(served, entity);
+		entity->vdisktime += delta;
 		update_min_vdisktime(entity->st);
 		entity->total_time += served;
 		entity->total_sectors += nr_sectors;
+		debug_entity_vdisktime(entity, served, delta);
 	}
 }
 
@@ -391,6 +433,9 @@ static void place_entity(struct io_service_tree *st, struct io_entity *entity,
 		vdisktime = st->min_vdisktime;
 
 	entity->vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
+	elv_log_entity(entity, "place_entity: vdisktime=%llu"
+			" min_vdisktime=%llu", entity->vdisktime,
+			st->min_vdisktime);
 }
 
 static inline void io_entity_update_prio(struct io_entity *entity)
-- 
1.6.0.6
