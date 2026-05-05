Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADB548AE35
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995837; cv=none; b=j1iTEDk3ziepww00A0uT38I0PZAC5WbdIHCc7nu4CSy9LRwAa+9X24Wc7xfB2JGPPJnOLtMQgfZoCIVegO1EXcYb6WQABnb6hOv9HBwXhmd0GWwu43fnaqf1VBkWo876+LiDwAou+X9ahkDgXbipBTnhcsqzfMFxh5a8qLL301o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995837; c=relaxed/simple;
	bh=0wDIUeigVsQQfTCw9yneaitlGA1o+z6lrQOkjnqoVyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7GA613NMPeypmISOoNjCPUlr0GR1OUGrEfVYzeC8Yy80syLPGTc16D0LPrNf4Lv7/q/JH6zqFG9UHneu6QgzbUsXFST70rHT0+hBAn+CqIW7hj8UhBYQMP6e5XscyolCyWJLtpfvZWi2Fv7ltD6EI3x5oSQpwieQJQGoKSvE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K5Glq48y; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K5Glq48y"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so52429235e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995835; x=1778600635; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULVtNuCvnaMcVcc/uZB4q1DoqYETq4+/9nZ6jXEbnXg=;
        b=K5Glq48y4Y18S/fmcxowP2LjLCSow83oBzQKCLMDvIEZ34fHR//DHc73dXHijFJlOO
         ioAmR93kYggA799TCmhvpuUgvfWF7KIX80rLkIqKmV553BYprTey0/DPSyNo5fBrtUS6
         2iXmmBjav5K7rqcuY1WVQBLqNKfkirpeVnpv/5nLKiESt0b1Iz9TxNXHrrbgLwPLHrsn
         O25rAVeknFunZF1YSNx65Ph6mz+odc8NOKD+sO9U1MGbEz4KjoGpM5X9pcfkUswBuSfr
         4sFOxur60r1JDjRj/tdITKjxGPHmlj4RBUl9z94KZCDAg+4Pn8+qRLBQgT2Y3U2deY1s
         buvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995835; x=1778600635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ULVtNuCvnaMcVcc/uZB4q1DoqYETq4+/9nZ6jXEbnXg=;
        b=dwEl1xLvptqAjyhCxnjkWFsLAJ+NX/IMYM66Awn5iwiYc6QVv7vyVFBr8PzJtj3O8d
         wIZ8jamSQFJE16ndLdXAdFVWrgWeU03AjPNafOT7drFDXP2HsIZuIVCfOa5TkH7ozy0e
         jHwnQrMnJUlEe7+apGTo7SygHy95MFcRWzP5/cV2qBTNQLNcKVyc/IXfarm4n0gSWDBv
         iC+DKacwMziCsCfFhsDuyTqYHOYP20n5W3DQIELc7J115MyCaq9XQBN0ReCpsvRL4WXi
         fH4NgWU8zCw9bSJxVyBlntu9mhxZydsWrdmh102wcSGC+r5WvN8lz9ECdAoBJ5e3ibZB
         +gPQ==
X-Forwarded-Encrypted: i=1; AFNElJ/aoa+g14UaR4ya53oY+8Zfun6SCvs+519uRqy+u9FKh+5AkGxg1ScsKLP3wRkIghF3LEIu6P7FDw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwosgmUab4K65UOcpsq04BelnpAf6Z8g9NDxp3sL+KhhiigWcn9
	dVT8GRPuDRKP2l0o/G/0sYKpBeZ8tnIIi6nXFol9wpahaOKMvemIgmLCSSKTIdcQjvI=
X-Gm-Gg: AeBDiesVaS7P3tTJkKZvuCxhnF452r1iNRDeP+B/ZINhdYbTlqUgEl2XnDlzFoS0Cun
	27OlXChJCRW7hUGO1n9Rfhg0FSa6bJV8bRrzY+gPZz0bmZ5eGurARiebnJ/ZTq04Mt8ogmJF8AS
	2YfScQcogY4m/5SUGcI2EwOUqFcyVamRY3Db3/9saMHneTV39k40QaNE/0h6kd8DbGHIuJ6yJuI
	uvFBrclgfuLC8/dBn0wIiVQh6BhwrYuc4VdqmAkqyv0lNtrKV8SuQdQmnGH/EecW4gyP7B+cE0B
	wkRtLOqG5di6toPOQ+/lVb8kiJl1SIlxhg5Ip13B30hgiyTdLqAPdy1q81sQYIsO9bobBpoYS5Y
	vsfAQ6YA9iU1CZYULQ1n2tTyGMy+jlkxsgeywFY4O6zNdGRTTmOgsV32ujfnCUnw2/2btmMFQSo
	rJC5VXQ3OWHiNhYFjp2EmmtyLAXeHzZjrZa0etaEfuylqwgSIn8NsINhovKlfHp3o4t3JfgrGK8
	l5unTBbVgeLz2k9t/5pebX1
X-Received: by 2002:a05:600c:c094:b0:48d:5c1:bc3b with SMTP id 5b1f17b1804b1-48d18cef847mr45759875e9.24.1777995834772;
        Tue, 05 May 2026 08:43:54 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a8eb75fc1sm368032545e9.7.2026.05.05.08.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/18] libmpathutil: runner: use shared_ptr
Date: Tue,  5 May 2026 17:43:22 +0200
Message-ID: <20260505154332.448054-9-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use shared_ptr to track the runner_context refcount.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/runner.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
index 8c6d6b9..56abd03 100644
--- a/libmpathutil/runner.c
+++ b/libmpathutil/runner.c
@@ -30,7 +30,6 @@ const char *runner_state_name(int state)
 }
 
 struct runner_context {
-	int refcount;
 	int status;
 	struct timespec deadline;
 	pthread_t thr;
@@ -39,17 +38,6 @@ struct runner_context {
 	char __attribute__((aligned(sizeof(void *)))) data[];
 };
 
-static void release_context(struct runner_context *rctx)
-{
-	int n;
-
-	n = uatomic_sub_return(&rctx->refcount, 1);
-	assert(n >= 0);
-
-	if (n == 0)
-		free(rctx);
-}
-
 static void cleanup_context(struct runner_context **prctx)
 {
 	struct runner_context *rctx = *prctx;
@@ -65,7 +53,7 @@ static void cleanup_context(struct runner_context **prctx)
 			"%s: runner %p finished in state '%s'", __func__, rctx,
 			runner_state_name(st));
 	}
-	release_context(rctx);
+	put_shared_ptr(rctx);
 }
 
 static void *runner_thread(void *arg)
@@ -147,7 +135,7 @@ repeat:
 void release_runner(struct runner_context *rctx)
 {
 	cancel_runner(rctx);
-	release_context(rctx);
+	put_shared_ptr(rctx);
 }
 
 int check_runner(struct runner_context *rctx, void *data, unsigned int size)
@@ -195,17 +183,17 @@ struct runner_context *get_runner(runner_func func, void *data,
 		return NULL;
 	}
 
-	rctx = malloc(sizeof(*rctx) + size);
+	rctx = alloc_shared_ptr(sizeof(*rctx) + size, NULL);
 	if (!rctx)
 		return NULL;
 
 	rctx->func = func;
 	/*
-	 * We have to set the refcount to 2 here. The runner thread may be
-	 * cancelled before it even had the chance to increase the refcount,
-	 * which could result in a use-after-free in cleanup_context().
+	 * Take an additional reference here. The runner thread may be
+	 * cancelled before it even had the chance to take a reference, which
+	 * could result in a use-after-free in cleanup_context().
 	 */
-	uatomic_set(&rctx->refcount, 2);
+	get_shared_ptr(rctx);
 	uatomic_set(&rctx->status, RUNNER_IDLE);
 	memcpy(rctx->data, data, size);
 
@@ -222,8 +210,8 @@ struct runner_context *get_runner(runner_func func, void *data,
 
 	if (rc) {
 		condlog(1, "%s: pthread_create(): %s", __func__, strerror(rc));
-		uatomic_dec(&rctx->refcount);
-		release_context(rctx);
+		put_shared_ptr(rctx);
+		put_shared_ptr(rctx);
 		return NULL;
 	}
 	return rctx;
-- 
2.54.0

