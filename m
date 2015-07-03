From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/7] dm-stats: rename functions
Date: Fri, 3 Jul 2015 16:58:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507031657260.28837@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Rename function dm_kvzalloc to dm_stats_kvzalloc and dm_kvfree to
dm_stats_kvfree so that they don't clash with newly introduced and
exported functions.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stats.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

Index: linux-4.1/drivers/md/dm-stats.c
===================================================================
--- linux-4.1.orig/drivers/md/dm-stats.c	2015-07-02 18:54:50.000000000 +0200
+++ linux-4.1/drivers/md/dm-stats.c	2015-07-02 19:03:26.000000000 +0200
@@ -139,7 +139,7 @@ static void free_shared_memory(size_t al
 	spin_unlock_irqrestore(&shared_memory_lock, flags);
 }
 
-static void *dm_kvzalloc(size_t alloc_size, int node)
+static void *dm_stats_kvzalloc(size_t alloc_size, int node)
 {
 	void *p;
 
@@ -160,17 +160,14 @@ static void *dm_kvzalloc(size_t alloc_si
 	return NULL;
 }
 
-static void dm_kvfree(void *ptr, size_t alloc_size)
+static void dm_stats_kvfree(void *ptr, size_t alloc_size)
 {
 	if (!ptr)
 		return;
 
 	free_shared_memory(alloc_size);
 
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
+	kvfree(ptr);
 }
 
 static void dm_stat_free(struct rcu_head *head)
@@ -181,11 +178,11 @@ static void dm_stat_free(struct rcu_head
 	kfree(s->program_id);
 	kfree(s->aux_data);
 	for_each_possible_cpu(cpu) {
-		dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
-		dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		dm_stats_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
+		dm_stats_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
 	}
-	dm_kvfree(s->stat_shared[0].tmp.histogram, s->histogram_alloc_size);
-	dm_kvfree(s, s->shared_alloc_size);
+	dm_stats_kvfree(s->stat_shared[0].tmp.histogram, s->histogram_alloc_size);
+	dm_stats_kvfree(s, s->shared_alloc_size);
 }
 
 static int dm_stat_in_flight(struct dm_stat_shared *shared)
@@ -282,7 +279,7 @@ static int dm_stats_create(struct dm_sta
 	if (!check_shared_memory(shared_alloc_size + histogram_alloc_size + num_possible_cpus() * (percpu_alloc_size + histogram_alloc_size)))
 		return -ENOMEM;
 
-	s = dm_kvzalloc(shared_alloc_size, NUMA_NO_NODE);
+	s = dm_stats_kvzalloc(shared_alloc_size, NUMA_NO_NODE);
 	if (!s)
 		return -ENOMEM;
 
@@ -320,7 +317,7 @@ static int dm_stats_create(struct dm_sta
 
 	if (s->n_histogram_entries) {
 		unsigned long long *hi;
-		hi = dm_kvzalloc(s->histogram_alloc_size, NUMA_NO_NODE);
+		hi = dm_stats_kvzalloc(s->histogram_alloc_size, NUMA_NO_NODE);
 		if (!hi) {
 			r = -ENOMEM;
 			goto out;
@@ -332,7 +329,7 @@ static int dm_stats_create(struct dm_sta
 	}
 
 	for_each_possible_cpu(cpu) {
-		p = dm_kvzalloc(percpu_alloc_size, cpu_to_node(cpu));
+		p = dm_stats_kvzalloc(percpu_alloc_size, cpu_to_node(cpu));
 		if (!p) {
 			r = -ENOMEM;
 			goto out;
@@ -340,7 +337,7 @@ static int dm_stats_create(struct dm_sta
 		s->stat_percpu[cpu] = p;
 		if (s->n_histogram_entries) {
 			unsigned long long *hi;
-			hi = dm_kvzalloc(s->histogram_alloc_size, cpu_to_node(cpu));
+			hi = dm_stats_kvzalloc(s->histogram_alloc_size, cpu_to_node(cpu));
 			if (!hi) {
 				r = -ENOMEM;
 				goto out;
