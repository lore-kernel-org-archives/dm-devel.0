Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C659FC47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:34:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5614D61403
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5614D61403
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-aeakCSF_OrGebwgjqt9WLw-1; Thu, 03 Jun 2021 02:33:28 -0400
X-MC-Unique: aeakCSF_OrGebwgjqt9WLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 315FB80D696;
	Thu,  3 Jun 2021 06:33:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 040F15D705;
	Thu,  3 Jun 2021 06:33:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8E251813CA7;
	Thu,  3 Jun 2021 06:33:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152Ec5fH002781 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 10:38:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 351A6208BDDA; Wed,  2 Jun 2021 14:38:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30927208C197
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:38:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A752D80D0E3
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:38:01 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-536-MnXuCvXKMe67hgvPNko9cA-1; Wed, 02 Jun 2021 10:37:59 -0400
X-MC-Unique: MnXuCvXKMe67hgvPNko9cA-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loQxc-002tou-3G; Wed, 02 Jun 2021 13:31:11 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BB4B13002B1;
	Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
	id 989162C14C594; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.334970485@infradead.org>
User-Agent: quilt/0.66
Date: Wed, 02 Jun 2021 15:12:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>
References: <20210602131225.336600299@infradead.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Jun 2021 02:32:49 -0400
Cc: Mark Rutland <mark.rutland@arm.com>, Pavel Machek <pavel@ucw.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
	dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Joel Fernandes <joel@joelfernandes.org>, netdev@vger.kernel.org,
	Jiri Olsa <jolsa@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Davidlohr Bueso <dave@stgolabs.net>, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	x86@kernel.org, Jakub Kicinski <kuba@kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-pm@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Waiman Long <longman@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Felipe Balbi <balbi@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Douglas Anderson <dianders@chromium.org>,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>, Tejun Heo <tj@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>, rcu@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: [dm-devel] [PATCH 2/6] sched: Introduce task_is_running()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
task_is_running(p).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/process.c |    4 ++--
 block/blk-mq.c            |    2 +-
 include/linux/sched.h     |    2 ++
 kernel/locking/lockdep.c  |    2 +-
 kernel/rcu/tree_plugin.h  |    2 +-
 kernel/sched/core.c       |    6 +++---
 kernel/sched/stats.h      |    2 +-
 kernel/signal.c           |    2 +-
 kernel/softirq.c          |    3 +--
 mm/compaction.c           |    2 +-
 10 files changed, 14 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
 	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
 	int count = 0;
 
-	if (p == current || p->state == TASK_RUNNING)
+	if (p == current || task_is_running(p))
 		return 0;
 
 	if (!try_get_task_stack(p))
@@ -975,7 +975,7 @@ unsigned long get_wchan(struct task_stru
 			goto out;
 		}
 		fp = READ_ONCE_NOCHECK(*(unsigned long *)fp);
-	} while (count++ < 16 && p->state != TASK_RUNNING);
+	} while (count++ < 16 && !task_is_running(p));
 
 out:
 	put_task_stack(p);
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3926,7 +3926,7 @@ int blk_poll(struct request_queue *q, bl
 		if (signal_pending_state(state, current))
 			__set_current_state(TASK_RUNNING);
 
-		if (current->state == TASK_RUNNING)
+		if (task_is_running(current))
 			return 1;
 		if (ret < 0 || !spin)
 			break;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -113,6 +113,8 @@ struct task_group;
 					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
 					 TASK_PARKED)
 
+#define task_is_running(task)		(READ_ONCE((task)->state) == TASK_RUNNING)
+
 #define task_is_traced(task)		((task->state & __TASK_TRACED) != 0)
 
 #define task_is_stopped(task)		((task->state & __TASK_STOPPED) != 0)
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -760,7 +760,7 @@ static void lockdep_print_held_locks(str
 	 * It's not reliable to print a task's held locks if it's not sleeping
 	 * and it's not the current task.
 	 */
-	if (p->state == TASK_RUNNING && p != current)
+	if (p != current && task_is_running(p))
 		return;
 	for (i = 0; i < depth; i++) {
 		printk(" #%d: ", i);
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2768,7 +2768,7 @@ EXPORT_SYMBOL_GPL(rcu_bind_current_to_no
 #ifdef CONFIG_SMP
 static char *show_rcu_should_be_on_cpu(struct task_struct *tsp)
 {
-	return tsp && tsp->state == TASK_RUNNING && !tsp->on_cpu ? "!" : "";
+	return tsp && task_is_running(tsp) && !tsp->on_cpu ? "!" : "";
 }
 #else // #ifdef CONFIG_SMP
 static char *show_rcu_should_be_on_cpu(struct task_struct *tsp)
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5989,7 +5989,7 @@ static inline void sched_submit_work(str
 {
 	unsigned int task_flags;
 
-	if (!tsk->state)
+	if (task_is_running(tsk))
 		return;
 
 	task_flags = tsk->flags;
@@ -7964,7 +7964,7 @@ int __sched yield_to(struct task_struct
 	if (curr->sched_class != p->sched_class)
 		goto out_unlock;
 
-	if (task_running(p_rq, p) || p->state)
+	if (task_running(p_rq, p) || !task_is_running(p))
 		goto out_unlock;
 
 	yielded = curr->sched_class->yield_to_task(rq, p);
@@ -8167,7 +8167,7 @@ void sched_show_task(struct task_struct
 
 	pr_info("task:%-15.15s state:%c", p->comm, task_state_to_char(p));
 
-	if (p->state == TASK_RUNNING)
+	if (task_is_running(p))
 		pr_cont("  running task    ");
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -217,7 +217,7 @@ static inline void sched_info_depart(str
 
 	rq_sched_info_depart(rq, delta);
 
-	if (t->state == TASK_RUNNING)
+	if (task_is_running(t))
 		sched_info_enqueue(rq, t);
 }
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4719,7 +4719,7 @@ void kdb_send_sig(struct task_struct *t,
 	}
 	new_t = kdb_prev_t != t;
 	kdb_prev_t = t;
-	if (t->state != TASK_RUNNING && new_t) {
+	if (!task_is_running(t) && new_t) {
 		spin_unlock(&t->sighand->siglock);
 		kdb_printf("Process is not RUNNING, sending a signal from "
 			   "kdb risks deadlock\n"
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -92,8 +92,7 @@ static bool ksoftirqd_running(unsigned l
 
 	if (pending & SOFTIRQ_NOW_MASK)
 		return false;
-	return tsk && (tsk->state == TASK_RUNNING) &&
-		!__kthread_should_park(tsk);
+	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
 }
 
 #ifdef CONFIG_TRACE_IRQFLAGS
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1955,7 +1955,7 @@ static inline bool is_via_compact_memory
 
 static bool kswapd_is_running(pg_data_t *pgdat)
 {
-	return pgdat->kswapd && (pgdat->kswapd->state == TASK_RUNNING);
+	return pgdat->kswapd && task_is_running(pgdat->kswapd);
 }
 
 /*


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

