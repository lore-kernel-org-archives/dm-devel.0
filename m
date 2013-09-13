From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-statistics: fix a possible counter corruption
 on 32-bit systems
Date: Fri, 13 Sep 2013 17:42:24 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309131739480.8872@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi

I found this bug when reading through the statistics patch. That trick to 
avoid irq disabling can be done on 64-bit architectures, but not on 
32-bit.

Push this patch upstream.

Mikulas

---

dm-statistics: fix a possible counter corruption on 32-bit systems

There was a deliberate race condition in dm_stat_for_entry to avoid the
overhead disabling and enabling interrupts. The race could result in some
events not being counted.

However, on 32-bit architectures, operations on long long variables are
not atomic, so the race condition could cause the counter to jump by 2^32.
Such jumps could be disruptive, so we need to do proper locking on 32-bit
architectures.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stats.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: linux-3.11-fast/drivers/md/dm-stats.c
===================================================================
--- linux-3.11-fast.orig/drivers/md/dm-stats.c	2013-09-13 22:26:00.000000000 +0200
+++ linux-3.11-fast/drivers/md/dm-stats.c	2013-09-13 23:30:08.000000000 +0200
@@ -451,19 +451,26 @@ static void dm_stat_for_entry(struct dm_
 	struct dm_stat_percpu *p;
 
 	/*
-	 * For strict correctness we should use local_irq_disable/enable
+	 * For strict correctness we should use local_irq_save/restore
 	 * instead of preempt_disable/enable.
 	 *
-	 * This is racy if the driver finishes bios from non-interrupt
-	 * context as well as from interrupt context or from more different
-	 * interrupts.
+	 * preempt_disable/enable is racy if the driver finishes bios
+	 * from non-interrupt context as well as from interrupt context
+	 * or from more different interrupts.
 	 *
-	 * However, the race only results in not counting some events,
-	 * so it is acceptable.
+	 * On 64-bit architectures the race only results in not counting some
+	 * events, so it is acceptable. On 32-bit architectures the race could
+	 * cause the counter going off by 2^32, so we need to do proper locking
+	 * there.
 	 *
 	 * part_stat_lock()/part_stat_unlock() have this race too.
 	 */
+#if BITS_PER_LONG == 32
+	unsigned long flags;
+	local_irq_save(flags);
+#else
 	preempt_disable();
+#endif
 	p = &s->stat_percpu[smp_processor_id()][entry];
 
 	if (!end) {
@@ -478,7 +485,11 @@ static void dm_stat_for_entry(struct dm_
 		p->ticks[idx] += duration;
 	}
 
+#if BITS_PER_LONG == 32
+	local_irq_restore(flags);
+#else
 	preempt_enable();
+#endif
 }
 
 static void __dm_stat_bio(struct dm_stat *s, unsigned long bi_rw,
