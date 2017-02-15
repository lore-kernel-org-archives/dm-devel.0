From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm stats: fix a memory leak
Date: Wed, 15 Feb 2017 12:06:19 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1702151204500.5572@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike

This fixes a memory leak in dm-stats. Put it into your queue of patches 
for Linus.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

Fix a leaked array s->histogram_boundaries.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: dfcfac3e4cd9 ("dm stats: collect and report histogram of IO latencies")
Cc: stable@vger.kernel.org	# v4.2+

---
 drivers/md/dm-stats.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/dm-stats.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stats.c
+++ linux-2.6/drivers/md/dm-stats.c
@@ -175,6 +175,7 @@ static void dm_stat_free(struct rcu_head
 	int cpu;
 	struct dm_stat *s = container_of(head, struct dm_stat, rcu_head);
 
+	kfree(s->histogram_boundaries);
 	kfree(s->program_id);
 	kfree(s->aux_data);
 	for_each_possible_cpu(cpu) {
