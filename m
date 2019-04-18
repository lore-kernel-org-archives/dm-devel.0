From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 23/29] tracing: Simplify stack trace retrieval
Date: Thu, 18 Apr 2019 10:41:42 +0200
Message-ID: <20190418084255.186774860@linutronix.de>
References: <20190418084119.056416939@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Alexander Potapenko <glider@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Catalin Marinas <catalin.marinas@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, kasan-dev@googlegroups.com, Mike Rapoport <rppt@linux.vnet.ibm.com>, Akinobu Mita <akinobu.mita@gmail.com>, iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: dm-devel.ids

Replace the indirection through struct stack_trace by using the storage
array based interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2774,22 +2774,18 @@ static void __ftrace_trace_stack(struct
 {
 	struct trace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
+	unsigned int size, nr_entries;
 	struct ftrace_stack *fstack;
 	struct stack_entry *entry;
-	struct stack_trace trace;
-	int size = FTRACE_KSTACK_ENTRIES;
 	int stackidx;
 
-	trace.nr_entries	= 0;
-	trace.skip		= skip;
-
 	/*
 	 * Add one, for this function and the call to save_stack_trace()
 	 * If regs is set, then these functions will not be in the way.
 	 */
 #ifndef CONFIG_UNWINDER_ORC
 	if (!regs)
-		trace.skip++;
+		skip++;
 #endif
 
 	/*
@@ -2816,28 +2812,24 @@ static void __ftrace_trace_stack(struct
 	barrier();
 
 	fstack = this_cpu_ptr(ftrace_stacks.stacks) + (stackidx - 1);
-	trace.entries		= fstack->calls;
-	trace.max_entries	= FTRACE_KSTACK_ENTRIES;
-
-	if (regs)
-		save_stack_trace_regs(regs, &trace);
-	else
-		save_stack_trace(&trace);
-
-	if (trace.nr_entries > size)
-		size = trace.nr_entries;
+	size = ARRAY_SIZE(fstack->calls);
 
-	size *= sizeof(unsigned long);
+	if (regs) {
+		nr_entries = stack_trace_save_regs(regs, fstack->calls,
+						   size, skip);
+	} else {
+		nr_entries = stack_trace_save(fstack->calls, size, skip);
+	}
 
+	size = nr_entries * sizeof(unsigned long);
 	event = __trace_buffer_lock_reserve(buffer, TRACE_STACK,
 					    sizeof(*entry) + size, flags, pc);
 	if (!event)
 		goto out;
 	entry = ring_buffer_event_data(event);
 
-	memcpy(&entry->caller, trace.entries, size);
-
-	entry->size = trace.nr_entries;
+	memcpy(&entry->caller, fstack->calls, size);
+	entry->size = nr_entries;
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
@@ -2916,7 +2908,6 @@ ftrace_trace_userstack(struct ring_buffe
 	struct trace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
-	struct stack_trace trace;
 
 	if (!(global_trace.trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
@@ -2947,12 +2938,7 @@ ftrace_trace_userstack(struct ring_buffe
 	entry->tgid		= current->tgid;
 	memset(&entry->caller, 0, sizeof(entry->caller));
 
-	trace.nr_entries	= 0;
-	trace.max_entries	= FTRACE_STACK_ENTRIES;
-	trace.skip		= 0;
-	trace.entries		= entry->caller;
-
-	save_stack_trace_user(&trace);
+	stack_trace_save_user(entry->caller, FTRACE_STACK_ENTRIES);
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 
