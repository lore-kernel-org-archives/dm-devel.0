Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEEB5258
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708997940; cv=none; b=ozsm6qx0AS8BhcD9Z9wI3Qb+4mag/YeZZPtN5+7f8HmCDFRawZsxPGwoEqaJJIzblHNfXSUS0Wf6kZc5bqqO/8FHwhK33Jv1ECa5bWlT7IAZY/8/115YyKrlHdRpf6TrlFLQGmlxBFAcD2hj1cBtZhetKavAJLZLLuGSHrBq/kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708997940; c=relaxed/simple;
	bh=7cHEtn5/usUauu4n2MbbitQYkJHQNxNkqreUwKPvWKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8/KBmn6UKeHLirs+IQJvFAJJEy5Auh+y3/K7YJnVUrCumsMlWMGCbbS12a9rQigYe/ozP/oo4J918BXcBJNEagsF1YdZfN2Lz2PQ3kKvKpcdZqpvA33fq1C06PUcvDcLTykY+R4+ZayqHuhqHiT/+HBjJTDy3ut9OPmRp5xTFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HBNSYKk1; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HBNSYKk1"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a0b1936400so11031eaf.2
        for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 17:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708997937; x=1709602737; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uh/X4IvEG/YVTF6TF7CoVpwzdK/+m4nMnD3+Q9DdMTo=;
        b=HBNSYKk1ZmGcHVYzD6rLIp7aVMJ1H5+JhHXmtoe7qOfyOP2HLKGycfqA5UrvvqUWMY
         6CS7SEcFVqCJaY4fuVRYh5mTJ0+1DJqaARqWJL3iYZ0r7UkrWOTvHXMak4F7Gs73Utb9
         itnYgw884mrwqykamhB/++Oqxy/B5R/t4GCZkJCUPow+G3By/nOa+3++igB7kszQk4M5
         /HIijNLjyuBUC7R1eu0ZJJKDzH8VCqVDFagvKMmjlzIx4oswrJ0RsQ20gX8usuDrP3FS
         RKEC2JoeG/fkyqNgf2bM+/ClHHeN6EgyVbY+0aDxahe8deu77fnhrW8IYQOJWl52i5JZ
         LZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708997937; x=1709602737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uh/X4IvEG/YVTF6TF7CoVpwzdK/+m4nMnD3+Q9DdMTo=;
        b=HRsUuWJJvH1fOwUAXZyZ3LaLqfCq484CcIcOuKPWg30z6IApbrSpwAh8evBeIISrt5
         qxCjNzDSDPC0xcMD2SD2rzENcblTLdQPSE6JWBXlruE7MaiGePyLgFCafUw0YSRPOksv
         p2KFxR4wAFJgjdQKGPsVziY78rZBXc6FrcuBHjzZY4qbQIFmGEQFpv04vC/Rawv0HbyM
         1grZok6ku4vTDOJHMHcvbF4kkB0TxC1mZ/suwkc+wxptvmt74wIxUpwpE7CkysOxrqCK
         Jnvkk35DOuIJtRczurBShVevJyayA1P0CCH1kM7tv4AHj5VKp3YVXTPxmo1WEV5dtgmn
         Uwug==
X-Forwarded-Encrypted: i=1; AJvYcCVyWwJLuqsiJqbs+wrXlX3VD9E3P+Xc+7QqxQ51abbmJd+XBdLSnhPtvPB/OVEmkTxMeFq7vEAJtLP7IkeEgJiLjeFL0EHCWlw=
X-Gm-Message-State: AOJu0Yy4IKZjhL1U1id9VsAwm7gsxjLGS9tRjwLnGwR6raBpbhQAvXGF
	zLz9yIRAL2NibOVHsGMb0GpW5CPuVDaJKnGFkVAcclbu6JDnnGVO
X-Google-Smtp-Source: AGHT+IHkz2OvZAGja3wN+/HA2CkQlGKBxv7z1G2/NMt1RjLPbPZoLXylBDQnUmQuahGYOUaKXMthrQ==
X-Received: by 2002:a05:6358:4901:b0:17b:5211:6976 with SMTP id w1-20020a056358490100b0017b52116976mr11619599rwn.6.1708997937489;
        Mon, 26 Feb 2024 17:38:57 -0800 (PST)
Received: from localhost ([2620:10d:c090:400::4:31e4])
        by smtp.gmail.com with ESMTPSA id i6-20020a62c106000000b006e50cb38395sm3301196pfg.53.2024.02.26.17.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 17:38:56 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 26 Feb 2024 15:38:55 -1000
From: Tejun Heo <tj@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH for-6.9] workqueue: Drain BH work items on hot-unplugged CPUs
Message-ID: <Zd09L9DgerYjezGT@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-4-tj@kernel.org>
 <ZcABypwUML6Osiec@slm.duckdns.org>
 <Zdvw0HdSXcU3JZ4g@boqun-archlinux>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zdvw0HdSXcU3JZ4g@boqun-archlinux>

Boqun pointed out that workqueues aren't handling BH work items on offlined
CPUs. Unlike tasklet which transfers out the pending tasks from
CPUHP_SOFTIRQ_DEAD, BH workqueue would just leave them pending which is
problematic. Note that this behavior is specific to BH workqueues as the
non-BH per-CPU workers just become unbound when the CPU goes offline.

This patch fixes the issue by draining the pending BH work items from an
offlined CPU from CPUHP_SOFTIRQ_DEAD. Because work items carry more context,
it's not as easy to transfer the pending work items from one pool to
another. Instead, run BH work items which execute the offlined pools on an
online CPU.

Note that this assumes that no further BH work items will be queued on the
offlined CPUs. This assumption is shared with tasklet and should be fine for
conversions. However, this issue also exists for per-CPU workqueues which
will just keep executing work items queued after CPU offline on unbound
workers and workqueue should reject per-CPU and BH work items queued on
offline CPUs. This will be addressed separately later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Boqun Feng <boqun.feng@gmail.com>
Link: http://lkml.kernel.org/r/Zdvw0HdSXcU3JZ4g@boqun-archlinux
---
 include/linux/workqueue.h |    1 
 kernel/softirq.c          |    2 +
 kernel/workqueue.c        |   91 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 91 insertions(+), 3 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -458,6 +458,7 @@ extern struct workqueue_struct *system_b
 extern struct workqueue_struct *system_bh_highpri_wq;
 
 void workqueue_softirq_action(bool highpri);
+void workqueue_softirq_dead(unsigned int cpu);
 
 /**
  * alloc_workqueue - allocate a workqueue
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -932,6 +932,8 @@ static void run_ksoftirqd(unsigned int c
 #ifdef CONFIG_HOTPLUG_CPU
 static int takeover_tasklets(unsigned int cpu)
 {
+	workqueue_softirq_dead(cpu);
+
 	/* CPU is dead, so no lock needed. */
 	local_irq_disable();
 
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -81,6 +81,7 @@ enum worker_pool_flags {
 	POOL_BH			= 1 << 0,	/* is a BH pool */
 	POOL_MANAGER_ACTIVE	= 1 << 1,	/* being managed */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
+	POOL_BH_DRAINING	= 1 << 3,	/* draining after CPU offline */
 };
 
 enum worker_flags {
@@ -1218,7 +1219,9 @@ static struct irq_work *bh_pool_irq_work
 static void kick_bh_pool(struct worker_pool *pool)
 {
 #ifdef CONFIG_SMP
-	if (unlikely(pool->cpu != smp_processor_id())) {
+	/* see drain_dead_softirq_workfn() for BH_DRAINING */
+	if (unlikely(pool->cpu != smp_processor_id() &&
+		     !(pool->flags & POOL_BH_DRAINING))) {
 		irq_work_queue_on(bh_pool_irq_work(pool), pool->cpu);
 		return;
 	}
@@ -3155,6 +3158,7 @@ __acquires(&pool->lock)
 	struct worker_pool *pool = worker->pool;
 	unsigned long work_data;
 	int lockdep_start_depth, rcu_start_depth;
+	bool bh_draining = pool->flags & POOL_BH_DRAINING;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -3220,7 +3224,9 @@ __acquires(&pool->lock)
 
 	rcu_start_depth = rcu_preempt_depth();
 	lockdep_start_depth = lockdep_depth(current);
-	lock_map_acquire(&pwq->wq->lockdep_map);
+	/* see drain_dead_softirq_workfn() */
+	if (!bh_draining)
+		lock_map_acquire(&pwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	/*
 	 * Strictly speaking we should mark the invariant state without holding
@@ -3253,7 +3259,8 @@ __acquires(&pool->lock)
 	trace_workqueue_execute_end(work, worker->current_func);
 	pwq->stats[PWQ_STAT_COMPLETED]++;
 	lock_map_release(&lockdep_map);
-	lock_map_release(&pwq->wq->lockdep_map);
+	if (!bh_draining)
+		lock_map_release(&pwq->wq->lockdep_map);
 
 	if (unlikely((worker->task && in_atomic()) ||
 		     lockdep_depth(current) != lockdep_start_depth ||
@@ -3615,6 +3622,84 @@ void workqueue_softirq_action(bool highp
 		bh_worker(list_first_entry(&pool->workers, struct worker, node));
 }
 
+struct wq_drain_dead_softirq_work {
+	struct work_struct	work;
+	struct worker_pool	*pool;
+	struct completion	done;
+};
+
+static void drain_dead_softirq_workfn(struct work_struct *work)
+{
+	struct wq_drain_dead_softirq_work *dead_work =
+		container_of(work, struct wq_drain_dead_softirq_work, work);
+	struct worker_pool *pool = dead_work->pool;
+	bool repeat;
+
+	/*
+	 * @pool's CPU is dead and we want to execute its still pending work
+	 * items from this BH work item which is running on a different CPU. As
+	 * its CPU is dead, @pool can't be kicked and, as work execution path
+	 * will be nested, a lockdep annotation needs to be suppressed. Mark
+	 * @pool with %POOL_BH_DRAINING for the special treatments.
+	 */
+	raw_spin_lock_irq(&pool->lock);
+	pool->flags |= POOL_BH_DRAINING;
+	raw_spin_unlock_irq(&pool->lock);
+
+	bh_worker(list_first_entry(&pool->workers, struct worker, node));
+
+	raw_spin_lock_irq(&pool->lock);
+	pool->flags &= ~POOL_BH_DRAINING;
+	repeat = need_more_worker(pool);
+	raw_spin_unlock_irq(&pool->lock);
+
+	/*
+	 * bh_worker() might hit consecutive execution limit and bail. If there
+	 * still are pending work items, reschedule self and return so that we
+	 * don't hog this CPU's BH.
+	 */
+	if (repeat) {
+		if (pool->attrs->nice == HIGHPRI_NICE_LEVEL)
+			queue_work(system_bh_highpri_wq, work);
+		else
+			queue_work(system_bh_wq, work);
+	} else {
+		complete(&dead_work->done);
+	}
+}
+
+/*
+ * @cpu is dead. Drain the remaining BH work items on the current CPU. It's
+ * possible to allocate dead_work per CPU and avoid flushing. However, then we
+ * have to worry about draining overlapping with CPU coming back online or
+ * nesting (one CPU's dead_work queued on another CPU which is also dead and so
+ * on). Let's keep it simple and drain them synchronously. These are BH work
+ * items which shouldn't be requeued on the same pool. Shouldn't take long.
+ */
+void workqueue_softirq_dead(unsigned int cpu)
+{
+	int i;
+
+	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
+		struct worker_pool *pool = &per_cpu(bh_worker_pools, cpu)[i];
+		struct wq_drain_dead_softirq_work dead_work;
+
+		if (!need_more_worker(pool))
+			continue;
+
+		INIT_WORK(&dead_work.work, drain_dead_softirq_workfn);
+		dead_work.pool = pool;
+		init_completion(&dead_work.done);
+
+		if (pool->attrs->nice == HIGHPRI_NICE_LEVEL)
+			queue_work(system_bh_highpri_wq, &dead_work.work);
+		else
+			queue_work(system_bh_wq, &dead_work.work);
+
+		wait_for_completion(&dead_work.done);
+	}
+}
+
 /**
  * check_flush_dependency - check for flush dependency sanity
  * @target_wq: workqueue being flushed
