From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [patch V2 01/29] tracing: Cleanup stack trace code
Date: Thu, 18 Apr 2019 10:41:20 +0200
Message-ID: <20190418084253.142712304@linutronix.de>
References: <20190418084119.056416939@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmKsTnJN9+BGXg@public.gmane.org>
List-Id: dm-devel.ids

- Remove the extra array member of stack_dump_trace[]. It's not required as
  the stack tracer stores at max array size - 1 entries so there is still
  an empty slot.

- Make variables which are only used in trace_stack.c static.

- Simplify the enable/disable logic.

- Rename stack_trace_print() as it's using the stack_trace_ namespace. Free
  the name up for stack trace related functions.

Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
---
V2: Add more cleanups and use print_max_stack() as requested by Steven.
---
 include/linux/ftrace.h     |   18 ++++--------------
 kernel/trace/trace_stack.c |   36 ++++++++++++------------------------
 2 files changed, 16 insertions(+), 38 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -241,21 +241,11 @@ static inline void ftrace_free_mem(struc
 
 #ifdef CONFIG_STACK_TRACER
 
-#define STACK_TRACE_ENTRIES 500
-
-struct stack_trace;
-
-extern unsigned stack_trace_index[];
-extern struct stack_trace stack_trace_max;
-extern unsigned long stack_trace_max_size;
-extern arch_spinlock_t stack_trace_max_lock;
-
 extern int stack_tracer_enabled;
-void stack_trace_print(void);
-int
-stack_trace_sysctl(struct ctl_table *table, int write,
-		   void __user *buffer, size_t *lenp,
-		   loff_t *ppos);
+
+int stack_trace_sysctl(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp,
+		       loff_t *ppos);
 
 /* DO NOT MODIFY THIS VARIABLE DIRECTLY! */
 DECLARE_PER_CPU(int, disable_stack_tracer);
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -18,8 +18,10 @@
 
 #include "trace.h"
 
-static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES + 1];
-unsigned stack_trace_index[STACK_TRACE_ENTRIES];
+#define STACK_TRACE_ENTRIES 500
+
+static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES];
+static unsigned stack_trace_index[STACK_TRACE_ENTRIES];
 
 /*
  * Reserve one entry for the passed in ip. This will allow
@@ -31,17 +33,16 @@ struct stack_trace stack_trace_max = {
 	.entries		= &stack_dump_trace[0],
 };
 
-unsigned long stack_trace_max_size;
-arch_spinlock_t stack_trace_max_lock =
+static unsigned long stack_trace_max_size;
+static arch_spinlock_t stack_trace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 DEFINE_PER_CPU(int, disable_stack_tracer);
 static DEFINE_MUTEX(stack_sysctl_mutex);
 
 int stack_tracer_enabled;
-static int last_stack_tracer_enabled;
 
-void stack_trace_print(void)
+static void print_max_stack(void)
 {
 	long i;
 	int size;
@@ -61,16 +62,7 @@ void stack_trace_print(void)
 	}
 }
 
-/*
- * When arch-specific code overrides this function, the following
- * data should be filled up, assuming stack_trace_max_lock is held to
- * prevent concurrent updates.
- *     stack_trace_index[]
- *     stack_trace_max
- *     stack_trace_max_size
- */
-void __weak
-check_stack(unsigned long ip, unsigned long *stack)
+static void check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags; unsigned long *p, *top, *start;
 	static int tracer_frame;
@@ -179,7 +171,7 @@ check_stack(unsigned long ip, unsigned l
 	stack_trace_max.nr_entries = x;
 
 	if (task_stack_end_corrupted(current)) {
-		stack_trace_print();
+		print_max_stack();
 		BUG();
 	}
 
@@ -412,23 +404,20 @@ stack_trace_sysctl(struct ctl_table *tab
 		   void __user *buffer, size_t *lenp,
 		   loff_t *ppos)
 {
-	int ret;
+	int ret, was_enabled;
 
 	mutex_lock(&stack_sysctl_mutex);
+	was_enabled = !!stack_tracer_enabled;
 
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 
-	if (ret || !write ||
-	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
+	if (ret || !write || (was_enabled == !!stack_tracer_enabled))
 		goto out;
 
-	last_stack_tracer_enabled = !!stack_tracer_enabled;
-
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
 	else
 		unregister_ftrace_function(&trace_ops);
-
  out:
 	mutex_unlock(&stack_sysctl_mutex);
 	return ret;
@@ -444,7 +433,6 @@ static __init int enable_stacktrace(char
 		strncpy(stack_trace_filter_buf, str + len, COMMAND_LINE_SIZE);
 
 	stack_tracer_enabled = 1;
-	last_stack_tracer_enabled = 1;
 	return 1;
 }
 __setup("stacktrace", enable_stacktrace);
