From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [patch V2 02/29] stacktrace: Provide helpers for common stack trace
	operations
Date: Thu, 18 Apr 2019 10:41:21 +0200
Message-ID: <20190418084253.234868907@linutronix.de>
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

All operations with stack traces are based on struct stack_trace. That's a
horrible construct as the struct is a kitchen sink for input and
output. Quite some usage sites embed it into their own data structures
which creates weird indirections.

There is absolutely no point in doing so. For all use cases a storage array
and the number of valid stack trace entries in the array is sufficient.

Provide helper functions which avoid the struct stack_trace indirection so
the usage sites can be cleaned up.

Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 include/linux/stacktrace.h |   27 +++++++
 kernel/stacktrace.c        |  160 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 172 insertions(+), 15 deletions(-)

--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -3,11 +3,26 @@
 #define __LINUX_STACKTRACE_H
 
 #include <linux/types.h>
+#include <asm/errno.h>
 
 struct task_struct;
 struct pt_regs;
 
 #ifdef CONFIG_STACKTRACE
+void stack_trace_print(unsigned long *trace, unsigned int nr_entries,
+		       int spaces);
+int stack_trace_snprint(char *buf, size_t size, unsigned long *entries,
+			unsigned int nr_entries, int spaces);
+unsigned int stack_trace_save(unsigned long *store, unsigned int size,
+			      unsigned int skipnr);
+unsigned int stack_trace_save_tsk(struct task_struct *task,
+				  unsigned long *store, unsigned int size,
+				  unsigned int skipnr);
+unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
+				   unsigned int size, unsigned int skipnr);
+unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
+
+/* Internal interfaces. Do not use in generic code */
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
@@ -41,4 +56,16 @@ extern void save_stack_trace_user(struct
 # define save_stack_trace_tsk_reliable(tsk, trace)	({ -ENOSYS; })
 #endif /* CONFIG_STACKTRACE */
 
+#if defined(CONFIG_STACKTRACE) && defined(CONFIG_HAVE_RELIABLE_STACKTRACE)
+int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
+				  unsigned int size);
+#else
+static inline int stack_trace_save_tsk_reliable(struct task_struct *tsk,
+						unsigned long *store,
+						unsigned int size)
+{
+	return -ENOSYS;
+}
+#endif
+
 #endif /* __LINUX_STACKTRACE_H */
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -11,35 +11,52 @@
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 
-void print_stack_trace(struct stack_trace *trace, int spaces)
+/**
+ * stack_trace_print - Print the entries in the stack trace
+ * @entries:	Pointer to storage array
+ * @nr_entries:	Number of entries in the storage array
+ * @spaces:	Number of leading spaces to print
+ */
+void stack_trace_print(unsigned long *entries, unsigned int nr_entries,
+		       int spaces)
 {
-	int i;
+	unsigned int i;
 
-	if (WARN_ON(!trace->entries))
+	if (WARN_ON(!entries))
 		return;
 
-	for (i = 0; i < trace->nr_entries; i++)
-		printk("%*c%pS\n", 1 + spaces, ' ', (void *)trace->entries[i]);
+	for (i = 0; i < nr_entries; i++)
+		printk("%*c%pS\n", 1 + spaces, ' ', (void *)entries[i]);
+}
+EXPORT_SYMBOL_GPL(stack_trace_print);
+
+void print_stack_trace(struct stack_trace *trace, int spaces)
+{
+	stack_trace_print(trace->entries, trace->nr_entries, spaces);
 }
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
-int snprint_stack_trace(char *buf, size_t size,
-			struct stack_trace *trace, int spaces)
+/**
+ * stack_trace_snprint - Print the entries in the stack trace into a buffer
+ * @buf:	Pointer to the print buffer
+ * @size:	Size of the print buffer
+ * @entries:	Pointer to storage array
+ * @nr_entries:	Number of entries in the storage array
+ * @spaces:	Number of leading spaces to print
+ */
+int stack_trace_snprint(char *buf, size_t size, unsigned long *entries,
+			unsigned int nr_entries, int spaces)
 {
-	int i;
-	int generated;
-	int total = 0;
+	unsigned int generated, i, total = 0;
 
-	if (WARN_ON(!trace->entries))
+	if (WARN_ON(!entries))
 		return 0;
 
-	for (i = 0; i < trace->nr_entries; i++) {
+	for (i = 0; i < nr_entries; i++) {
 		generated = snprintf(buf, size, "%*c%pS\n", 1 + spaces, ' ',
-				     (void *)trace->entries[i]);
+				     (void *)entries[i]);
 
 		total += generated;
-
-		/* Assume that generated isn't a negative number */
 		if (generated >= size) {
 			buf += size;
 			size = 0;
@@ -51,6 +68,14 @@ int snprint_stack_trace(char *buf, size_
 
 	return total;
 }
+EXPORT_SYMBOL_GPL(stack_trace_snprint);
+
+int snprint_stack_trace(char *buf, size_t size,
+			struct stack_trace *trace, int spaces)
+{
+	return stack_trace_snprint(buf, size, trace->entries,
+				   trace->nr_entries, spaces);
+}
 EXPORT_SYMBOL_GPL(snprint_stack_trace);
 
 /*
@@ -77,3 +102,108 @@ save_stack_trace_tsk_reliable(struct tas
 	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
 	return -ENOSYS;
 }
+
+/**
+ * stack_trace_save - Save a stack trace into a storage array
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ */
+unsigned int stack_trace_save(unsigned long *store, unsigned int size,
+			      unsigned int skipnr)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+		.skip		= skipnr + 1,
+	};
+
+	save_stack_trace(&trace);
+	return trace.nr_entries;
+}
+EXPORT_SYMBOL_GPL(stack_trace_save);
+
+/**
+ * stack_trace_save_tsk - Save a task stack trace into a storage array
+ * @task:	The task to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ */
+unsigned int stack_trace_save_tsk(struct task_struct *task,
+				  unsigned long *store, unsigned int size,
+				  unsigned int skipnr)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+		.skip		= skipnr + 1,
+	};
+
+	save_stack_trace_tsk(task, &trace);
+	return trace.nr_entries;
+}
+
+/**
+ * stack_trace_save_regs - Save a stack trace based on pt_regs into a storage array
+ * @regs:	Pointer to pt_regs to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ */
+unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
+				   unsigned int size, unsigned int skipnr)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+		.skip		= skipnr,
+	};
+
+	save_stack_trace_regs(regs, &trace);
+	return trace.nr_entries;
+}
+
+#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
+/**
+ * stack_trace_save_tsk_reliable - Save task stack with verification
+ * @tsk:	Pointer to the task to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ *
+ * Returns:	An error if it detects any unreliable features of the
+ *		stack. Otherwise it guarantees that the stack trace is
+ *		reliable and returns the number of entries stored.
+ *
+ * If the task is not 'current', the caller *must* ensure the task is inactive.
+ */
+int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
+				  unsigned int size)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+	};
+	int ret = save_stack_trace_tsk_reliable(tsk, &trace);
+
+	return ret ? ret : trace.nr_entries;
+}
+#endif
+
+#ifdef CONFIG_USER_STACKTRACE_SUPPORT
+/**
+ * stack_trace_save_user - Save a user space stack trace into a storage array
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ */
+unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+	};
+
+	save_stack_trace_user(&trace);
+	return trace.nr_entries;
+}
+#endif /* CONFIG_USER_STACKTRACE_SUPPORT */
