From: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC patch 31/41] dm persistent data: Simplify stack trace handling
Date: Wed, 10 Apr 2019 12:28:25 +0200
Message-ID: <20190410103646.401662030@linutronix.de>
References: <20190410102754.387743324@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Replace the indirection through struct stack_trace with an invocation of
the storage array based interface. This results in less storage space and
indirection.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
---
 drivers/md/persistent-data/dm-block-manager.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -35,7 +35,10 @@
 #define MAX_HOLDERS 4
 #define MAX_STACK 10
 
-typedef unsigned long stack_entries[MAX_STACK];
+struct stack_store {
+	unsigned int	nr_entries;
+	unsigned long	entries[MAX_STACK];
+};
 
 struct block_lock {
 	spinlock_t lock;
@@ -44,8 +47,7 @@ struct block_lock {
 	struct task_struct *holders[MAX_HOLDERS];
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-	struct stack_trace traces[MAX_HOLDERS];
-	stack_entries entries[MAX_HOLDERS];
+	struct stack_store traces[MAX_HOLDERS];
 #endif
 };
 
@@ -73,7 +75,7 @@ static void __add_holder(struct block_lo
 {
 	unsigned h = __find_holder(lock, NULL);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-	struct stack_trace *t;
+	struct stack_store *t;
 #endif
 
 	get_task_struct(task);
@@ -81,11 +83,7 @@ static void __add_holder(struct block_lo
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 	t = lock->traces + h;
-	t->nr_entries = 0;
-	t->max_entries = MAX_STACK;
-	t->entries = lock->entries[h];
-	t->skip = 2;
-	save_stack_trace(t);
+	t->nr_entries = stack_trace_save(t->entries, MAX_STACK, 2);
 #endif
 }
 
@@ -106,7 +104,8 @@ static int __check_holder(struct block_l
 			DMERR("recursive lock detected in metadata");
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 			DMERR("previously held here:");
-			print_stack_trace(lock->traces + i, 4);
+			stack_trace_print(lock->traces[i].entries,
+					  lock->traces[i].nr_entries, 4);
 
 			DMERR("subsequent acquisition attempted here:");
 			dump_stack();
