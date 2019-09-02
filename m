From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 00:05:58 +0300
Message-ID: <20190902210558.GA23013@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

32-bit accesses are shorter than 64-bit accesses on x86_64.
Nothing uses 64-bitness of ->state.

Space savings are ~2KB on F30 kernel config.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/ia64/kernel/perfmon.c   |    4 ++--
 block/blk-mq.c               |    2 +-
 drivers/md/dm.c              |    4 ++--
 fs/userfaultfd.c             |    2 +-
 include/linux/sched.h        |    6 +++---
 include/linux/sched/debug.h  |    2 +-
 include/linux/sched/signal.h |    2 +-
 kernel/freezer.c             |    2 +-
 kernel/kthread.c             |    4 ++--
 kernel/locking/mutex.c       |    6 +++---
 kernel/locking/semaphore.c   |    2 +-
 kernel/rcu/rcutorture.c      |    4 ++--
 kernel/rcu/tree_stall.h      |    6 +++---
 kernel/sched/core.c          |    8 ++++----
 lib/syscall.c                |    2 +-
 15 files changed, 28 insertions(+), 28 deletions(-)

--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2538,7 +2538,7 @@ pfm_task_incompatible(pfm_context_t *ctx, struct task_struct *task)
 	if (task == current) return 0;
 
 	if (!task_is_stopped_or_traced(task)) {
-		DPRINT(("cannot attach to non-stopped task [%d] state=%ld\n", task_pid_nr(task), task->state));
+		DPRINT(("cannot attach to non-stopped task [%d] state=%d\n", task_pid_nr(task), task->state));
 		return -EBUSY;
 	}
 	/*
@@ -4614,7 +4614,7 @@ pfm_check_task_state(pfm_context_t *ctx, int cmd, unsigned long flags)
 		return 0;
 	}
 
-	DPRINT(("context %d state=%d [%d] task_state=%ld must_stop=%d\n",
+	DPRINT(("context %d state=%d [%d] task_state=%d must_stop=%d\n",
 		ctx->ctx_fd,
 		state,
 		task_pid_nr(task),
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3471,7 +3471,7 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
 	struct blk_mq_hw_ctx *hctx;
-	long state;
+	int state;
 
 	if (!blk_qc_t_valid(cookie) ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2424,7 +2424,7 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
-static int dm_wait_for_completion(struct mapped_device *md, long task_state)
+static int dm_wait_for_completion(struct mapped_device *md, int task_state)
 {
 	int r = 0;
 	DEFINE_WAIT(wait);
@@ -2570,7 +2570,7 @@ static void unlock_fs(struct mapped_device *md)
  * are being added to md->deferred list.
  */
 static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
-			unsigned suspend_flags, long task_state,
+			unsigned suspend_flags, int task_state,
 			int dmf_suspended_flag)
 {
 	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -356,7 +356,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	struct userfaultfd_wait_queue uwq;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool must_wait, return_to_userland;
-	long blocking_state;
+	int blocking_state;
 
 	/*
 	 * We don't do userfault handling for the final child pid update.
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -643,7 +643,7 @@ struct task_struct {
 	struct thread_info		thread_info;
 #endif
 	/* -1 unrunnable, 0 runnable, >0 stopped: */
-	volatile long			state;
+	volatile int			state;
 
 	/*
 	 * This begins the randomizable portion of task_struct. Only
@@ -1702,10 +1702,10 @@ extern char *__get_task_comm(char *to, size_t len, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 void scheduler_ipi(void);
-extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
+unsigned long wait_task_inactive(struct task_struct *, int match_state);
 #else
 static inline void scheduler_ipi(void) { }
-static inline unsigned long wait_task_inactive(struct task_struct *p, long match_state)
+static inline unsigned long wait_task_inactive(struct task_struct *p, int match_state)
 {
 	return 1;
 }
--- a/include/linux/sched/debug.h
+++ b/include/linux/sched/debug.h
@@ -14,7 +14,7 @@ extern void dump_cpu_task(int cpu);
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
-extern void show_state_filter(unsigned long state_filter);
+void show_state_filter(unsigned int state_filter);
 
 static inline void show_state(void)
 {
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -367,7 +367,7 @@ static inline int fatal_signal_pending(struct task_struct *p)
 	return signal_pending(p) && __fatal_signal_pending(p);
 }
 
-static inline int signal_pending_state(long state, struct task_struct *p)
+static inline int signal_pending_state(int state, struct task_struct *p)
 {
 	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
 		return 0;
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -64,7 +64,7 @@ bool __refrigerator(bool check_kthr_stop)
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	bool was_frozen = false;
-	long save = current->state;
+	int save = current->state;
 
 	pr_debug("%s entered refrigerator\n", current->comm);
 
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -392,7 +392,7 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
-static void __kthread_bind_mask(struct task_struct *p, const struct cpumask *mask, long state)
+static void __kthread_bind_mask(struct task_struct *p, const struct cpumask *mask, int state)
 {
 	unsigned long flags;
 
@@ -408,7 +408,7 @@ static void __kthread_bind_mask(struct task_struct *p, const struct cpumask *mas
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
-static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
+static void __kthread_bind(struct task_struct *p, unsigned int cpu, int state)
 {
 	__kthread_bind_mask(p, cpumask_of(cpu), state);
 }
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -897,7 +897,7 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
  * Lock a mutex (possibly interruptible), slowpath:
  */
 static __always_inline int __sched
-__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
+__mutex_lock_common(struct mutex *lock, int state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
@@ -1071,14 +1071,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 }
 
 static int __sched
-__mutex_lock(struct mutex *lock, long state, unsigned int subclass,
+__mutex_lock(struct mutex *lock, int state, unsigned int subclass,
 	     struct lockdep_map *nest_lock, unsigned long ip)
 {
 	return __mutex_lock_common(lock, state, subclass, nest_lock, ip, NULL, false);
 }
 
 static int __sched
-__ww_mutex_lock(struct mutex *lock, long state, unsigned int subclass,
+__ww_mutex_lock(struct mutex *lock, int state, unsigned int subclass,
 		struct lockdep_map *nest_lock, unsigned long ip,
 		struct ww_acquire_ctx *ww_ctx)
 {
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -201,7 +201,7 @@ struct semaphore_waiter {
  * constant, and thus optimised away by the compiler.  Likewise the
  * 'timeout' parameter for the cases without timeouts.
  */
-static inline int __sched __down_common(struct semaphore *sem, long state,
+static inline int __sched __down_common(struct semaphore *sem, int state,
 								long timeout)
 {
 	struct semaphore_waiter waiter;
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1472,10 +1472,10 @@ rcu_torture_stats_print(void)
 		srcutorture_get_gp_data(cur_ops->ttype, srcu_ctlp,
 					&flags, &gp_seq);
 		wtp = READ_ONCE(writer_task);
-		pr_alert("??? Writer stall state %s(%d) g%lu f%#x ->state %#lx cpu %d\n",
+		pr_alert("??? Writer stall state %s(%d) g%lu f%#x ->state %#x cpu %d\n",
 			 rcu_torture_writer_state_getname(),
 			 rcu_torture_writer_state, gp_seq, flags,
-			 wtp == NULL ? ~0UL : wtp->state,
+			 wtp == NULL ? ~0U : wtp->state,
 			 wtp == NULL ? -1 : (int)task_cpu(wtp));
 		if (!splatted && wtp) {
 			sched_show_task(wtp);
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -337,7 +337,7 @@ static void rcu_check_gp_kthread_starvation(void)
 
 	j = jiffies - READ_ONCE(rcu_state.gp_activity);
 	if (j > 2 * HZ) {
-		pr_err("%s kthread starved for %ld jiffies! g%ld f%#x %s(%d) ->state=%#lx ->cpu=%d\n",
+		pr_err("%s kthread starved for %ld jiffies! g%ld f%#x %s(%d) ->state=%#x ->cpu=%d\n",
 		       rcu_state.name, j,
 		       (long)rcu_seq_current(&rcu_state.gp_seq),
 		       READ_ONCE(rcu_state.gp_flags),
@@ -559,10 +559,10 @@ void show_rcu_gp_kthreads(void)
 	ja = j - READ_ONCE(rcu_state.gp_activity);
 	jr = j - READ_ONCE(rcu_state.gp_req_activity);
 	jw = j - READ_ONCE(rcu_state.gp_wake_time);
-	pr_info("%s: wait state: %s(%d) ->state: %#lx delta ->gp_activity %lu ->gp_req_activity %lu ->gp_wake_time %lu ->gp_wake_seq %ld ->gp_seq %ld ->gp_seq_needed %ld ->gp_flags %#x\n",
+	pr_info("%s: wait state: %s(%d) ->state: %#x delta ->gp_activity %lu ->gp_req_activity %lu ->gp_wake_time %lu ->gp_wake_seq %ld ->gp_seq %ld ->gp_seq_needed %ld ->gp_flags %#x\n",
 		rcu_state.name, gp_state_getname(rcu_state.gp_state),
 		rcu_state.gp_state,
-		rcu_state.gp_kthread ? rcu_state.gp_kthread->state : 0x1ffffL,
+		rcu_state.gp_kthread ? rcu_state.gp_kthread->state : 0x1ffff,
 		ja, jr, jw, (long)READ_ONCE(rcu_state.gp_wake_seq),
 		(long)READ_ONCE(rcu_state.gp_seq),
 		(long)READ_ONCE(rcu_get_root()->gp_seq_needed),
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1769,7 +1769,7 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p,
  * smp_call_function() if an IPI is sent by the same process we are
  * waiting to become inactive.
  */
-unsigned long wait_task_inactive(struct task_struct *p, long match_state)
+unsigned long wait_task_inactive(struct task_struct *p, int match_state)
 {
 	int running, queued;
 	struct rq_flags rf;
@@ -5761,7 +5761,7 @@ void sched_show_task(struct task_struct *p)
 EXPORT_SYMBOL_GPL(sched_show_task);
 
 static inline bool
-state_filter_match(unsigned long state_filter, struct task_struct *p)
+state_filter_match(unsigned int state_filter, struct task_struct *p)
 {
 	/* no filter, everything matches */
 	if (!state_filter)
@@ -5782,7 +5782,7 @@ state_filter_match(unsigned long state_filter, struct task_struct *p)
 }
 
 
-void show_state_filter(unsigned long state_filter)
+void show_state_filter(unsigned int state_filter)
 {
 	struct task_struct *g, *p;
 
@@ -6553,7 +6553,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	 */
 	WARN_ONCE(current->state != TASK_RUNNING && current->task_state_change,
 			"do not call blocking ops when !TASK_RUNNING; "
-			"state=%lx set at [<%p>] %pS\n",
+			"state=%x set at [<%p>] %pS\n",
 			current->state,
 			(void *)current->task_state_change,
 			(void *)current->task_state_change);
--- a/lib/syscall.c
+++ b/lib/syscall.c
@@ -61,7 +61,7 @@ static int collect_syscall(struct task_struct *target, struct syscall_info *info
  */
 int task_current_syscall(struct task_struct *target, struct syscall_info *info)
 {
-	long state;
+	int state;
 	unsigned long ncsw;
 
 	if (target == current)
