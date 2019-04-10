From: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC patch 30/41] dm bufio: Simplify stack trace retrieval
Date: Wed, 10 Apr 2019 12:28:24 +0200
Message-ID: <20190410103646.311208785@linutronix.de>
References: <20190410102754.387743324@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Replace the indirection through struct stack_trace with an invocation of
the storage array based interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
---
 drivers/md/dm-bufio.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -150,7 +150,7 @@ struct dm_buffer {
 	void (*end_io)(struct dm_buffer *, blk_status_t);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 #define MAX_STACK 10
-	struct stack_trace stack_trace;
+	unsigned int stack_len;
 	unsigned long stack_entries[MAX_STACK];
 #endif
 };
@@ -232,11 +232,7 @@ static DEFINE_MUTEX(dm_bufio_clients_loc
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 static void buffer_record_stack(struct dm_buffer *b)
 {
-	b->stack_trace.nr_entries = 0;
-	b->stack_trace.max_entries = MAX_STACK;
-	b->stack_trace.entries = b->stack_entries;
-	b->stack_trace.skip = 2;
-	save_stack_trace(&b->stack_trace);
+	b->stack_len = stack_trace_save(b->stack_entries, MAX_STACK, 2);
 }
 #endif
 
@@ -438,7 +434,7 @@ static struct dm_buffer *alloc_buffer(st
 	adjust_total_allocated(b->data_mode, (long)c->block_size);
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-	memset(&b->stack_trace, 0, sizeof(b->stack_trace));
+	b->stack_len = 0;
 #endif
 	return b;
 }
@@ -1520,8 +1516,9 @@ static void drop_buffers(struct dm_bufio
 			DMERR("leaked buffer %llx, hold count %u, list %d",
 			      (unsigned long long)b->block, b->hold_count, i);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-			print_stack_trace(&b->stack_trace, 1);
-			b->hold_count = 0; /* mark unclaimed to avoid BUG_ON below */
+			stack_trace_print(b->stack_entries, b->stack_len, 1);
+			/* mark unclaimed to avoid BUG_ON below */
+			b->hold_count = 0;
 #endif
 		}
 
