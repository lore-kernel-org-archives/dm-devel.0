Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2D4611CC
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468295; cv=none; b=GUlCZA5aBjyHic+/vMuRd6fD7lNPp5zMIROdAIrQz2979Wy2IfABS666eX8cCOr6DMv69nmzy2UmpHKM13Vuyzk1rt8aO1brG5PbTjhu7pW7laVL56EFQ6FwMyWrb3tEsIujOLJBjUmr0Ge/dnV3GzwnB7TtJNPP0niV1ipgv+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468295; c=relaxed/simple;
	bh=X5vtvUcdIDrIIrqG/frqvencuaPmxTpgaEjUzqapn1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AubHODVJYmtN8F7rgfMgxXZzr07EjgQGo2rCcar/AkQJST96nTv9WSD/coF4KTOwT7qqpmr5T2UdvwUjf+6teVyue8nNJEeZm5hAOXAu8CPWUbZj8UEHecPrJXW2ukAyn3KBvpcmXnNurgRTOCQWpU0p+8I+SYnfZiMVCXCXKMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J2r3h/Br; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J2r3h/Br"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d7e23defbso4292900f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468292; x=1780073092; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hawesuSJ13GH6L7sxB+NNgVOzr5pdVX/ilIiLpmosiI=;
        b=J2r3h/Br/LeODWYLyZu08HA4dQ0QYlntNuNQFFdTmR6KDxglh52GuefEG1ZbL2n1rP
         KBMJiNhatOb7JgHHh/JJkSvpQf4de5IVXtqvkUXPWM/LtY+t2qKb6YHwfgCvi3UdIC5v
         Vcj2f8yX9cfqBGVLeHrZDISXs3nmBuMSLJ0gCMBIPz2lrJaSExvA6FL0426dM5ji7gOg
         h1KfFJq7DZjWo53fWXnUHwHwqYfHRio9Y1+NcLxE9hF3ndI58iag6cz0fC8wFxOqCpuD
         uahyyic2T/AEux5x96NYI7Ggx/Jv7ajq5LJZcQYe9SQuxGAgYXHaRghx0BEaBocecJGN
         W3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468292; x=1780073092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hawesuSJ13GH6L7sxB+NNgVOzr5pdVX/ilIiLpmosiI=;
        b=gYFHTbGTXVTst+b69PdCBg+vfPB3pwCS52HgkZkuHtm0HWFUqae66xWOjH4pcBnd3m
         wdRTB8CXk9gy1zHS+fU6N56aeuNzlAgD6TM53fhQw7tRE91ywOd3EMBmDByGdXYNl7tu
         nNAMk+iVY3wI3vFd7hNpC8Gtsmd0kE9oW6/T2hG8H03UA7VMD9If8iY1HnEGa5BvHBHF
         PGWjkKkGtMcxIWjMAr61gWs5SBR3BNsm97TSgaWydwl2modyGw11ZtyXlrsOJ3LMP4hW
         Y1UGA7Wqv2ViZQuxYfsuoyffXE/dD5KvZSW+c/iKtJ6p3mAioH5nLjAlVfPulq+coPCE
         Xutw==
X-Forwarded-Encrypted: i=1; AFNElJ93eaYkgN8oBjT1clMceO5IaaJpyePREhzDbg0wcxGVzZuzB6gO7ElSUm9RDYcG4dDLr2M7DuCWMw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzSmVzvu45DhVYLrfrozrwgkiJUJsXLb8ThgISzFxT+ISbNcWSv
	i/wmohDwKrWyn0eFychSkxuUxs/4N78U0vzPddOVCCqf69B9E2f4NDJEi7F//t76BGM=
X-Gm-Gg: Acq92OFcv63txbmurW7jBPj6NCn1ESryU3TJF2altwhInkPkL+TBPQNKIeXFssTchs3
	Ck/MT9G9NE1Cj4hs+Oy7gHjCUuanT+vi5f2/fsbFOevCTjCTkzDqy0wNiwDcTq4B4Zn1seHdIo1
	j+2PS90AMQcupv3CbVMxloBz50JzqcTpSi6cmLe8WM1GbJaH/mQEs4RepZPidtZBSoACRqWdi7G
	LNAeX+fRoS09ind0Hbl0l1/yGJsFD4m3cu2tVCvZqdYKESfR9GNmIuXKpmBtn7Bciwv2xh4XDTH
	OGtxrA4S8VERE15nSvY5nEOIzj4v1s2MJTBO5LwMkDh8GF/yKQ0UcxPKdugoCGcm+gbbwH1rG1T
	RESTMeGhL71wGLQiL2DuYP8eMgv6vx1s4fP1RGWXRU6dPiE+ChE4E0N3WvvFZVfnLUPqC+KqnLt
	wyfQ6bej+YGnQqGCIGW46ybVptBxK57q2FaQH6wCT1Az+JUDxEHp9sU+1YT0Lw/16wGAMUQ1Rto
	RZRvwAHcnzH3wXiaIcIoBA88kmwzvO5Ikk=
X-Received: by 2002:a05:6000:4b06:b0:45e:73eb:1ff7 with SMTP id ffacd0b85a97d-45eb3688819mr6599964f8f.3.1779468291863;
        Fri, 22 May 2026 09:44:51 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6cce01asm5803301f8f.11.2026.05.22.09.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:51 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/19] libmpathutil: runner: use shared_ptr
Date: Fri, 22 May 2026 18:44:05 +0200
Message-ID: <20260522164415.846589-10-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use shared_ptr to track the runner_context refcount.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

