Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3283159B49
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605988; cv=none; b=TTW/CTKlNfAeSIdNEPG92C4pr4Ekp1seYSkLeD9AI77a3oSdy4lQitcadenICrD94un2tEmn4NNv59tXWnaGqzuJCcJGTHy1V74mriQlo/keBxZ9HRZDTrzJjrB5K3iSoOHgiFUgwSNsHNNz91StmN3/nBmWyDr61RAX8eLyvLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605988; c=relaxed/simple;
	bh=cpO6m2Pr5p3n/qePucxFD1UXJhPW8vRxbzSH1keUjbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j36elpotL/yFxuikaD74kn3u5Hk/pu3PoNRoJO/2V7h4Ow6GBeGiEbah6vb+zQusofnY9WTvRYYQBjLPo+CLCnEK9g6OuwH0A1dyvQ8w7jTzHOtc4hWOrxzriPM16cGJK7bOJL9QfptYKHdgC3ODpt8yw21dV4ineTJXIgHpBXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TllUN9sF; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TllUN9sF"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d8dc0172d7so10325135ad.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605986; x=1707210786; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0f+E+7Yr7tZg5UZ5N5kXMlDMZoo9OCBh+FLJ8A0xtV0=;
        b=TllUN9sFsT4hZc5vuXPN4nyrXOC1PM7oo+s4Tkcs1ULTaV1YfJcQbnZINtPnB9rCiQ
         ANQXJs25MVth50bkPe9NIcHRcA6GtJ7ALIxr1axTXSbjM1NdWFwrAMXL5BeIC/9gQBKj
         X56VSsPFC7K6qEneSWSqZWbPAgIvY+si15W7dSjLERbiokDh8m18eEDfIOXw6cIgpG8V
         vpXTvIk+vtVQ1uDpC02r4a7Z+AFyF0DWHffMCNGI2TDmm6NamX3NMmoATVtN5PuRCtvz
         kXUIzggntbD3JC55fFRBxOtATYrofVa7vx4VQa+U64YFpPk3lRS/ApBDD5M9SLUv4OXs
         b9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605986; x=1707210786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0f+E+7Yr7tZg5UZ5N5kXMlDMZoo9OCBh+FLJ8A0xtV0=;
        b=UEItX0iKNow13miqAC9nCx2AqcAxP8nZ8bcJXrOq6du+8TNgwgPhDrNiOUp2VACo7m
         GlcZOQBJuXYbRDycOo6dNa+PNdrXEmEJnBEkPEkBSWgvfQDtfeUqXNrgvC81Hn8afnU4
         5Gfehc0W9NAPReegazF0VujR+TitR2Foq9fWOym+HCxg45rUK8U97F2nki/GrjPPt9ax
         mqnpvQq/egna70s0SEqMD/9Tza93euc1UYPaIVGcguBjN80/1jTTd31vHnztXVHguDsN
         bY3T6RxYRSdzXjjMkE66xkGeG07M7oADVqCa3tTkHUiNJOq/SnbuiOwy+p6KTyTvETBE
         5eWg==
X-Gm-Message-State: AOJu0YwhshbQHqMK8oA9isdBWtIORFaUEmE/ClLrkdUtYvHnl98tSwiF
	OalMWyumAWPMH8WfWo2btcJ3O0Uon4HeBs4LaZiuiIGeboFE4IcYVi7SLtfW
X-Google-Smtp-Source: AGHT+IHW8nd6s3CduJC+/WZAHKizzZVidAfFEzNUZ1XDA7JjpE2326FNHUnbnisZAxd67Me78MzjWA==
X-Received: by 2002:a17:903:491:b0:1d8:eb22:5f25 with SMTP id jj17-20020a170903049100b001d8eb225f25mr2684625plb.102.1706605986265;
        Tue, 30 Jan 2024 01:13:06 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902d90300b001d901e176afsm1171941plz.232.2024.01.30.01.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:05 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org,
	mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	ignat@cloudflare.com,
	damien.lemoal@wdc.com,
	bob.liu@oracle.com,
	houtao1@huawei.com,
	peterz@infradead.org,
	mingo@kernel.org,
	netdev@vger.kernel.org,
	allen.lkml@gmail.com,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] workqueue: Update lock debugging code
Date: Mon, 29 Jan 2024 23:11:48 -1000
Message-ID: <20240130091300.2968534-2-tj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>
References: <20240130091300.2968534-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These changes are in preparation of BH workqueue which will execute work
items from BH context.

- Update lock and RCU depth checks in process_one_work() so that it
  remembers and checks against the starting depths and prints out the depth
  changes.

- Factor out lockdep annotations in the flush paths into
  touch_{wq|work}_lockdep_map(). The work->lockdep_map touching is moved
  from __flush_work() to its callee - start_flush_work(). This brings it
  closer to the wq counterpart and will allow testing the associated wq's
  flags which will be needed to support BH workqueues. This is not expected
  to cause any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9221a4c57ae1..3f2081bd05a4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2954,6 +2954,7 @@ __acquires(&pool->lock)
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct worker_pool *pool = worker->pool;
 	unsigned long work_data;
+	int lockdep_start_depth, rcu_start_depth;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -3016,6 +3017,8 @@ __acquires(&pool->lock)
 	pwq->stats[PWQ_STAT_STARTED]++;
 	raw_spin_unlock_irq(&pool->lock);
 
+	rcu_start_depth = rcu_preempt_depth();
+	lockdep_start_depth = lockdep_depth(current);
 	lock_map_acquire(&pwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	/*
@@ -3051,12 +3054,15 @@ __acquires(&pool->lock)
 	lock_map_release(&lockdep_map);
 	lock_map_release(&pwq->wq->lockdep_map);
 
-	if (unlikely(in_atomic() || lockdep_depth(current) > 0 ||
-		     rcu_preempt_depth() > 0)) {
-		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d/%d\n"
-		       "     last function: %ps\n",
-		       current->comm, preempt_count(), rcu_preempt_depth(),
-		       task_pid_nr(current), worker->current_func);
+	if (unlikely((worker->task && in_atomic()) ||
+		     lockdep_depth(current) != lockdep_start_depth ||
+		     rcu_preempt_depth() != rcu_start_depth)) {
+		pr_err("BUG: workqueue leaked atomic, lock or RCU: %s[%d]\n"
+		       "     preempt=0x%08x lock=%d->%d RCU=%d->%d workfn=%ps\n",
+		       current->comm, task_pid_nr(current), preempt_count(),
+		       lockdep_start_depth, lockdep_depth(current),
+		       rcu_start_depth, rcu_preempt_depth(),
+		       worker->current_func);
 		debug_show_held_locks(current);
 		dump_stack();
 	}
@@ -3538,6 +3544,19 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 	return wait;
 }
 
+static void touch_wq_lockdep_map(struct workqueue_struct *wq)
+{
+	lock_map_acquire(&wq->lockdep_map);
+	lock_map_release(&wq->lockdep_map);
+}
+
+static void touch_work_lockdep_map(struct work_struct *work,
+				   struct workqueue_struct *wq)
+{
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
+}
+
 /**
  * __flush_workqueue - ensure that any scheduled work has run to completion.
  * @wq: workqueue to flush
@@ -3557,8 +3576,7 @@ void __flush_workqueue(struct workqueue_struct *wq)
 	if (WARN_ON(!wq_online))
 		return;
 
-	lock_map_acquire(&wq->lockdep_map);
-	lock_map_release(&wq->lockdep_map);
+	touch_wq_lockdep_map(wq);
 
 	mutex_lock(&wq->mutex);
 
@@ -3757,6 +3775,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 	struct worker *worker = NULL;
 	struct worker_pool *pool;
 	struct pool_workqueue *pwq;
+	struct workqueue_struct *wq;
 
 	might_sleep();
 
@@ -3780,11 +3799,14 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		pwq = worker->current_pwq;
 	}
 
-	check_flush_dependency(pwq->wq, work);
+	wq = pwq->wq;
+	check_flush_dependency(wq, work);
 
 	insert_wq_barrier(pwq, barr, work, worker);
 	raw_spin_unlock_irq(&pool->lock);
 
+	touch_work_lockdep_map(work, wq);
+
 	/*
 	 * Force a lock recursion deadlock when using flush_work() inside a
 	 * single-threaded or rescuer equipped workqueue.
@@ -3794,11 +3816,9 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 	 * workqueues the deadlock happens when the rescuer stalls, blocking
 	 * forward progress.
 	 */
-	if (!from_cancel &&
-	    (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer)) {
-		lock_map_acquire(&pwq->wq->lockdep_map);
-		lock_map_release(&pwq->wq->lockdep_map);
-	}
+	if (!from_cancel && (wq->saved_max_active == 1 || wq->rescuer))
+		touch_wq_lockdep_map(wq);
+
 	rcu_read_unlock();
 	return true;
 already_gone:
@@ -3817,9 +3837,6 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	if (WARN_ON(!work->func))
 		return false;
 
-	lock_map_acquire(&work->lockdep_map);
-	lock_map_release(&work->lockdep_map);
-
 	if (start_flush_work(work, &barr, from_cancel)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
-- 
2.43.0

