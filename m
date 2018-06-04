From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 21:58:58 +0200
Message-ID: <20180604195858.GD12217@hirez.programming.kicks-ass.net>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 04, 2018 at 12:39:11PM -0700, Linus Torvalds wrote:
> On Mon, Jun 4, 2018 at 12:37 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Would it help if we did s/swake_up/swake_up_one/g ?
> >
> > Then there would not be an swake_up() to cause confusion.
> 
> Yes, i think that would already be a big improvement, forcing people
> to be aware of the exclusive nature.

The below will of course conflict with the merge request under
discussion. Also completely untested.

---
Subject: sched/swait: Unconfuse swake_up() vs wake_up()

Linus hates on swait because swake_up() behaves distinctly different
from wake_up(). Where the latter will wake all !exclusive waiters and a
single exclusive waiter, the former will wake but one waiter (everything
is exclusive).

To avoid easy confusion, rename swake_up() to swake_up_one():

  git grep -l "\<swake_up\>" | while read file;
  do
    sed -ie 's/\<swake_up\>/&_one/g' $file;
  done

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/mips/kvm/mips.c         | 4 ++--
 arch/powerpc/kvm/book3s_hv.c | 4 ++--
 arch/s390/kvm/interrupt.c    | 2 +-
 arch/x86/kernel/kvm.c        | 2 +-
 arch/x86/kvm/lapic.c         | 2 +-
 include/linux/swait.h        | 2 +-
 kernel/rcu/srcutiny.c        | 2 +-
 kernel/rcu/tree.c            | 2 +-
 kernel/rcu/tree_exp.h        | 2 +-
 kernel/rcu/tree_plugin.h     | 6 +++---
 kernel/sched/swait.c         | 4 ++--
 virt/kvm/arm/arm.c           | 2 +-
 virt/kvm/arm/psci.c          | 2 +-
 virt/kvm/async_pf.c          | 2 +-
 virt/kvm/kvm_main.c          | 2 +-
 15 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 0f725e9cee8f..612bc713c4a1 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -515,7 +515,7 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	dvcpu->arch.wait = 0;
 
 	if (swq_has_sleeper(&dvcpu->wq))
-		swake_up(&dvcpu->wq);
+		swake_up_one(&dvcpu->wq);
 
 	return 0;
 }
@@ -1204,7 +1204,7 @@ static void kvm_mips_comparecount_func(unsigned long data)
 
 	vcpu->arch.wait = 0;
 	if (swq_has_sleeper(&vcpu->wq))
-		swake_up(&vcpu->wq);
+		swake_up_one(&vcpu->wq);
 }
 
 /* low level hrtimer wake routine */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4d07fca5121c..f1bcf1875171 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -190,7 +190,7 @@ static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 
 	wqp = kvm_arch_vcpu_wq(vcpu);
 	if (swq_has_sleeper(wqp)) {
-		swake_up(wqp);
+		swake_up_one(wqp);
 		++vcpu->stat.halt_wakeup;
 	}
 
@@ -3224,7 +3224,7 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 			kvmppc_start_thread(vcpu, vc);
 			trace_kvm_guest_enter(vcpu);
 		} else if (vc->vcore_state == VCORE_SLEEPING) {
-			swake_up(&vc->wq);
+			swake_up_one(&vc->wq);
 		}
 
 	}
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 37d06e022238..f58113cbee4d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1145,7 +1145,7 @@ void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu)
 		 * yield-candidate.
 		 */
 		vcpu->preempted = true;
-		swake_up(&vcpu->wq);
+		swake_up_one(&vcpu->wq);
 		vcpu->stat.halt_wakeup++;
 	}
 	/*
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5b2300b818af..db6ebe48d991 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -188,7 +188,7 @@ static void apf_task_wake_one(struct kvm_task_sleep_node *n)
 	if (n->halted)
 		smp_send_reschedule(n->cpu);
 	else if (swq_has_sleeper(&n->wq))
-		swake_up(&n->wq);
+		swake_up_one(&n->wq);
 }
 
 static void apf_task_wake_all(void)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b74c9c1405b9..a2f8c4c76d33 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1379,7 +1379,7 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	 * using swait_active() is safe.
 	 */
 	if (swait_active(q))
-		swake_up(q);
+		swake_up_one(q);
 
 	if (apic_lvtt_tscdeadline(apic))
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
diff --git a/include/linux/swait.h b/include/linux/swait.h
index 84f9745365ff..6224bbb08cf5 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -145,7 +145,7 @@ static inline bool swq_has_sleeper(struct swait_queue_head *wq)
 	return swait_active(wq);
 }
 
-extern void swake_up(struct swait_queue_head *q);
+extern void swake_up_one(struct swait_queue_head *q);
 extern void swake_up_all(struct swait_queue_head *q);
 extern void swake_up_locked(struct swait_queue_head *q);
 
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index 622792abe41a..790876228824 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -110,7 +110,7 @@ void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 
 	WRITE_ONCE(sp->srcu_lock_nesting[idx], newval);
 	if (!newval && READ_ONCE(sp->srcu_gp_waiting))
-		swake_up(&sp->srcu_wq);
+		swake_up_one(&sp->srcu_wq);
 }
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4fccdfa25716..c5fbd74c8af0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1727,7 +1727,7 @@ static void rcu_gp_kthread_wake(struct rcu_state *rsp)
 	    !READ_ONCE(rsp->gp_flags) ||
 	    !rsp->gp_kthread)
 		return;
-	swake_up(&rsp->gp_wq);
+	swake_up_one(&rsp->gp_wq);
 }
 
 /*
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index d40708e8c5d6..027a432a167d 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -212,7 +212,7 @@ static void __rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 			raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 			if (wake) {
 				smp_mb(); /* EGP done before wake_up(). */
-				swake_up(&rsp->expedited_wq);
+				swake_up_one(&rsp->expedited_wq);
 			}
 			break;
 		}
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7fd12039e512..1245610f689d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1854,8 +1854,8 @@ static void __wake_nocb_leader(struct rcu_data *rdp, bool force,
 		WRITE_ONCE(rdp_leader->nocb_leader_sleep, false);
 		del_timer(&rdp->nocb_timer);
 		raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
-		smp_mb(); /* ->nocb_leader_sleep before swake_up(). */
-		swake_up(&rdp_leader->nocb_wq);
+		smp_mb(); /* ->nocb_leader_sleep before swake_up_one(). */
+		swake_up_one(&rdp_leader->nocb_wq);
 	} else {
 		raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
 	}
@@ -2176,7 +2176,7 @@ static void nocb_leader_wait(struct rcu_data *my_rdp)
 		raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
 		if (rdp != my_rdp && tail == &rdp->nocb_follower_head) {
 			/* List was empty, so wake up the follower.  */
-			swake_up(&rdp->nocb_wq);
+			swake_up_one(&rdp->nocb_wq);
 		}
 	}
 
diff --git a/kernel/sched/swait.c b/kernel/sched/swait.c
index b6fb2c3b3ff7..e471a58f565c 100644
--- a/kernel/sched/swait.c
+++ b/kernel/sched/swait.c
@@ -32,7 +32,7 @@ void swake_up_locked(struct swait_queue_head *q)
 }
 EXPORT_SYMBOL(swake_up_locked);
 
-void swake_up(struct swait_queue_head *q)
+void swake_up_one(struct swait_queue_head *q)
 {
 	unsigned long flags;
 
@@ -40,7 +40,7 @@ void swake_up(struct swait_queue_head *q)
 	swake_up_locked(q);
 	raw_spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(swake_up);
+EXPORT_SYMBOL(swake_up_one);
 
 /*
  * Does not allow usage from IRQ disabled, since we must be able to
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a4c1b76240df..172e82b75e3f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -586,7 +586,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu->arch.pause = false;
-		swake_up(kvm_arch_vcpu_wq(vcpu));
+		swake_up_one(kvm_arch_vcpu_wq(vcpu));
 	}
 }
 
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index c4762bef13c6..18effcb166ad 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -155,7 +155,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	smp_mb();		/* Make sure the above is visible */
 
 	wq = kvm_arch_vcpu_wq(vcpu);
-	swake_up(wq);
+	swake_up_one(wq);
 
 	return PSCI_RET_SUCCESS;
 }
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 57bcb27dcf30..23c2519c5b32 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -107,7 +107,7 @@ static void async_pf_execute(struct work_struct *work)
 	trace_kvm_async_pf_completed(addr, gva);
 
 	if (swq_has_sleeper(&vcpu->wq))
-		swake_up(&vcpu->wq);
+		swake_up_one(&vcpu->wq);
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c7b2e927f699..8cbf1276ed2e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2197,7 +2197,7 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 
 	wqp = kvm_arch_vcpu_wq(vcpu);
 	if (swq_has_sleeper(wqp)) {
-		swake_up(wqp);
+		swake_up_one(wqp);
 		++vcpu->stat.halt_wakeup;
 		return true;
 	}
