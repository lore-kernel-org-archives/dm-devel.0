Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE25366B2A
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605996; cv=none; b=E8kiXpYOFKbgo4rqEAyNCIoJvJzUPmAEsHy+FSYIjcbNJtnXlwr5wmrSKT9VPB8j3j3GgZD9N+ofPwXy/mYVHLw5BNWtwbviKpdZx0v53DtqvIYScuuU10uKirVXYA+YfK/CQ9OpW9xJSEEkbVT+ieuPvR049G5MNj1MjkfwO4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605996; c=relaxed/simple;
	bh=R1ACoB28rY6p8+XZEPrUMweeKHn7QHqywci7Ubfb9rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxvVXGZcngXt9KPjIm2Di0OlAEu6CvNdRvYbmZS02eJkxQMf5mlm23kmAqVn5AQpSxZ5sRIbo0qjNNDQdd6FOXtlsB/3vxn0Td5V/AU/hsOTRoudZNgtzGQbiQ0I+p3Ro0di5OHlC1lFn8+ESJkNRkb6vM24aqwBRTq541NemPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SudwiFGI; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SudwiFGI"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-29026523507so2962697a91.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605994; x=1707210794; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLAiJpm0LtH5vcnMce7MYOvEWmNX9nkZqVGOHKY+ODc=;
        b=SudwiFGI+OJlfPvawqQDjkTjWJI9QhZnBG78mkJrlyLRG53MMinnDhhVrgzX4Dnf67
         Y7YFDNtvjP9Z0/4E8eQGr9LsTrppvk0tKpRW/lRnAMOSQXF80Nn6115kkyiefJI/YsT3
         JUi5o2Q2kW9M7qfGVysj/Pa0XYIR6df1jmAVVnT5a0bn3Gekce4RUzKm0NRAIaOjlI29
         MgUe1bKl+9FNCCNn7zxaeeamKGlRGSI1XI3gDzUohnOKguV1UZRVd+44+qt1XkfB4u88
         +wyGDFlDUfoIP1MQjrGlU0A9UbO0BvzFZCExxuUZj456kt9aEZDgbt33cJOs59rT7d9O
         IzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605994; x=1707210794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kLAiJpm0LtH5vcnMce7MYOvEWmNX9nkZqVGOHKY+ODc=;
        b=ebxWLa0vzRJt/3R22QwG4vIUB4EcdjeQpeKWTVk+TrpLssRAJyL3kYmEfiA9m5Z7cM
         JUaX99ymBadqn3rHGkN8EktHvKL2y53R2pYTXArw9msz0dW/B6Kk5PtHJbjadHUsIyIA
         +B6T9fXTVbPItwC82ZfUZftMb70Zpf3+plMxUngpD7E2+MkGYk/n5z6RocEOGKYNiUHC
         OW9KOQcS9UY1ZbkigS/ZSBFjwW5wkvadqRs5H1GfiNOtZMYAsc2xgxq105zX47OSi03F
         thx/sVBYzyZAEwVV/ay04SIflBe8UX97eZsJyM/mW2tJjbMtJFtMBR8CxhuTTBYqFwfI
         fWSg==
X-Gm-Message-State: AOJu0Yw1nOfqOY9fVx5He53VPvo1afe31Eh+V9XISiRyNRm7dkragz6/
	Ejp3ypNqJSMmrnhfzC3EktWJZUDmzZFMsazKWUANh6u59kMTdFzJ
X-Google-Smtp-Source: AGHT+IF3b/+kojapfeRuhsR/j4T111w0CzhWh5Et0GGp61tD12NEkGqgoWCAncjIhdgx+EW/PRYQVQ==
X-Received: by 2002:a17:90b:610:b0:292:6b60:ef6e with SMTP id gb16-20020a17090b061000b002926b60ef6emr5168649pjb.46.1706605994100;
        Tue, 30 Jan 2024 01:13:14 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id bg3-20020a17090b0d8300b002949d9767acsm7146273pjb.4.2024.01.30.01.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:13 -0800 (PST)
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
	Tejun Heo <tj@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
Date: Mon, 29 Jan 2024 23:11:53 -1000
Message-ID: <20240130091300.2968534-7-tj@kernel.org>
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

The only generic interface to execute asynchronously in the BH context is
tasklet; however, it's marked deprecated and has some design flaws. To
replace tasklets, BH workqueue support was recently added. A BH workqueue
behaves similarly to regular workqueues except that the queued work items
are executed in the BH context.

This patch converts TCP Small Queues implementation from tasklet to BH
workqueue.

Semantically, this is an equivalent conversion and there shouldn't be any
user-visible behavior changes. While workqueue's queueing and execution
paths are a bit heavier than tasklet's, unless the work item is being queued
every packet, the difference hopefully shouldn't matter.

My experience with the networking stack is very limited and this patch
definitely needs attention from someone who actually understands networking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [IPv4/IPv6])
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org (open list:NETWORKING [TCP])
---
 include/net/tcp.h     |  2 +-
 net/ipv4/tcp.c        |  2 +-
 net/ipv4/tcp_output.c | 36 ++++++++++++++++++------------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index dd78a1181031..89f3702be47a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -324,7 +324,7 @@ extern struct proto tcp_prot;
 #define TCP_DEC_STATS(net, field)	SNMP_DEC_STATS((net)->mib.tcp_statistics, field)
 #define TCP_ADD_STATS(net, field, val)	SNMP_ADD_STATS((net)->mib.tcp_statistics, field, val)
 
-void tcp_tasklet_init(void);
+void tcp_tsq_work_init(void);
 
 int tcp_v4_err(struct sk_buff *skb, u32);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1baa484d2190..d085ee5642fe 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4772,6 +4772,6 @@ void __init tcp_init(void)
 	tcp_v4_init();
 	tcp_metrics_init();
 	BUG_ON(tcp_register_congestion_control(&tcp_reno) != 0);
-	tcp_tasklet_init();
+	tcp_tsq_work_init();
 	mptcp_init();
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e3167ad96567..d11be6eebb6e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1049,15 +1049,15 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
  * needs to be reallocated in a driver.
  * The invariant being skb->truesize subtracted from sk->sk_wmem_alloc
  *
- * Since transmit from skb destructor is forbidden, we use a tasklet
+ * Since transmit from skb destructor is forbidden, we use a BH work item
  * to process all sockets that eventually need to send more skbs.
- * We use one tasklet per cpu, with its own queue of sockets.
+ * We use one work item per cpu, with its own queue of sockets.
  */
-struct tsq_tasklet {
-	struct tasklet_struct	tasklet;
+struct tsq_work {
+	struct work_struct	work;
 	struct list_head	head; /* queue of tcp sockets */
 };
-static DEFINE_PER_CPU(struct tsq_tasklet, tsq_tasklet);
+static DEFINE_PER_CPU(struct tsq_work, tsq_work);
 
 static void tcp_tsq_write(struct sock *sk)
 {
@@ -1087,14 +1087,14 @@ static void tcp_tsq_handler(struct sock *sk)
 	bh_unlock_sock(sk);
 }
 /*
- * One tasklet per cpu tries to send more skbs.
- * We run in tasklet context but need to disable irqs when
+ * One work item per cpu tries to send more skbs.
+ * We run in BH context but need to disable irqs when
  * transferring tsq->head because tcp_wfree() might
  * interrupt us (non NAPI drivers)
  */
-static void tcp_tasklet_func(struct tasklet_struct *t)
+static void tcp_tsq_workfn(struct work_struct *work)
 {
-	struct tsq_tasklet *tsq = from_tasklet(tsq,  t, tasklet);
+	struct tsq_work *tsq = container_of(work, struct tsq_work, work);
 	LIST_HEAD(list);
 	unsigned long flags;
 	struct list_head *q, *n;
@@ -1164,15 +1164,15 @@ void tcp_release_cb(struct sock *sk)
 }
 EXPORT_SYMBOL(tcp_release_cb);
 
-void __init tcp_tasklet_init(void)
+void __init tcp_tsq_work_init(void)
 {
 	int i;
 
 	for_each_possible_cpu(i) {
-		struct tsq_tasklet *tsq = &per_cpu(tsq_tasklet, i);
+		struct tsq_work *tsq = &per_cpu(tsq_work, i);
 
 		INIT_LIST_HEAD(&tsq->head);
-		tasklet_setup(&tsq->tasklet, tcp_tasklet_func);
+		INIT_WORK(&tsq->work, tcp_tsq_workfn);
 	}
 }
 
@@ -1186,11 +1186,11 @@ void tcp_wfree(struct sk_buff *skb)
 	struct sock *sk = skb->sk;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned long flags, nval, oval;
-	struct tsq_tasklet *tsq;
+	struct tsq_work *tsq;
 	bool empty;
 
 	/* Keep one reference on sk_wmem_alloc.
-	 * Will be released by sk_free() from here or tcp_tasklet_func()
+	 * Will be released by sk_free() from here or tcp_tsq_workfn()
 	 */
 	WARN_ON(refcount_sub_and_test(skb->truesize - 1, &sk->sk_wmem_alloc));
 
@@ -1212,13 +1212,13 @@ void tcp_wfree(struct sk_buff *skb)
 		nval = (oval & ~TSQF_THROTTLED) | TSQF_QUEUED;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));
 
-	/* queue this socket to tasklet queue */
+	/* queue this socket to BH workqueue */
 	local_irq_save(flags);
-	tsq = this_cpu_ptr(&tsq_tasklet);
+	tsq = this_cpu_ptr(&tsq_work);
 	empty = list_empty(&tsq->head);
 	list_add(&tp->tsq_node, &tsq->head);
 	if (empty)
-		tasklet_schedule(&tsq->tasklet);
+		queue_work(system_bh_wq, &tsq->work);
 	local_irq_restore(flags);
 	return;
 out:
@@ -2623,7 +2623,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 	if (refcount_read(&sk->sk_wmem_alloc) > limit) {
 		/* Always send skb if rtx queue is empty or has one skb.
 		 * No need to wait for TX completion to call us back,
-		 * after softirq/tasklet schedule.
+		 * after softirq schedule.
 		 * This helps when TX completions are delayed too much.
 		 */
 		if (tcp_rtx_queue_empty_or_single_skb(sk))
-- 
2.43.0

