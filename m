From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 03/25] io-controller: bfq support of in-class
	preemption
Date: Thu,  2 Jul 2009 16:01:35 -0400
Message-ID: <1246564917-19603-4-git-send-email-vgoyal@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google
Cc: peterz@infradead.org, akpm@linux-foundation.org, snitzer@redhat.com, agk@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

o Generally preemption is associated with cross class where if an request
  from RT class is pending it will preempt the ongoing BE or IDLE class
  request.

o CFQ also does in-class preemtions like a sync request queue preempting the
  async request queue. In that case it looks like preempting queue gains
  share and it is not fair.

o Implement the similar functionality in bfq so that we can retain the
  existing CFQ behavior.

o This patch creates a bypass path so that a queue can be put at the
  front of the service tree (add_front, similar to CFQ), so that it will
  be selected next to run. That's a different thing that in the process
  this queue gains share.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index a58efdc..7ee4321 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -582,7 +582,7 @@ static struct io_entity *bfq_lookup_next_entity(struct io_sched_data *sd,
  * service received if @entity is active) of the queue to calculate its
  * timestamps.
  */
-static void __bfq_activate_entity(struct io_entity *entity)
+static void __bfq_activate_entity(struct io_entity *entity, int add_front)
 {
 	struct io_sched_data *sd = entity->sched_data;
 	struct io_service_tree *st = io_entity_service_tree(entity);
@@ -627,7 +627,42 @@ static void __bfq_activate_entity(struct io_entity *entity)
 	}
 
 	st = __bfq_entity_update_prio(st, entity);
-	bfq_calc_finish(entity, entity->budget);
+	/*
+	 * This is to emulate cfq like functionality where preemption can
+	 * happen with-in same class, like sync queue preempting async queue
+	 * May be this is not a very good idea from fairness point of view
+	 * as preempting queue gains share. Keeping it for now.
+	 */
+	if (add_front) {
+		struct io_entity *next_entity;
+
+		/*
+		 * Determine the entity which will be dispatched next
+		 * Use sd->next_active once hierarchical patch is applied
+		 */
+		next_entity = bfq_lookup_next_entity(sd, 0);
+
+		if (next_entity && next_entity != entity) {
+			struct io_service_tree *new_st;
+			u64 delta;
+
+			new_st = io_entity_service_tree(next_entity);
+
+			/*
+			 * At this point, both entities should belong to
+			 * same service tree as cross service tree preemption
+			 * is automatically taken care by algorithm
+			 */
+			BUG_ON(new_st != st);
+			entity->finish = next_entity->finish - 1;
+			delta = bfq_delta(entity->budget, entity->weight);
+			entity->start = entity->finish - delta;
+			if (bfq_gt(entity->start, st->vtime))
+				entity->start = st->vtime;
+		}
+	} else {
+		bfq_calc_finish(entity, entity->budget);
+	}
 	bfq_active_insert(st, entity);
 }
 
@@ -635,9 +670,9 @@ static void __bfq_activate_entity(struct io_entity *entity)
  * bfq_activate_entity - activate an entity.
  * @entity: the entity to activate.
  */
-static void bfq_activate_entity(struct io_entity *entity)
+static void bfq_activate_entity(struct io_entity *entity, int add_front)
 {
-	__bfq_activate_entity(entity);
+	__bfq_activate_entity(entity, add_front);
 }
 
 /**
-- 
1.6.0.6
