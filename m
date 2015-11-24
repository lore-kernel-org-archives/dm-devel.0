From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-block-manager: stacktrace cleanup
Date: Mon, 23 Nov 2015 19:12:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511231911350.16811@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

A small code cleanup. There is no need to record stack trace and
immediatelly print it. We have a function dump_stack() that prints the
current stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-4.4-rc2/drivers/md/persistent-data/dm-block-manager.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/persistent-data/dm-block-manager.c
+++ linux-4.4-rc2/drivers/md/persistent-data/dm-block-manager.c
@@ -97,10 +97,6 @@ static void __del_holder(struct block_lo
 static int __check_holder(struct block_lock *lock)
 {
 	unsigned i;
-#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-	static struct stack_trace t;
-	static stack_entries entries;
-#endif
 
 	for (i = 0; i < MAX_HOLDERS; i++) {
 		if (lock->holders[i] == current) {
@@ -110,12 +106,7 @@ static int __check_holder(struct block_l
 			print_stack_trace(lock->traces + i, 4);
 
 			DMERR("subsequent acquisition attempted here:");
-			t.nr_entries = 0;
-			t.max_entries = MAX_STACK;
-			t.entries = entries;
-			t.skip = 3;
-			save_stack_trace(&t);
-			print_stack_trace(&t, 4);
+			dump_stack();
 #endif
 			return -EINVAL;
 		}
