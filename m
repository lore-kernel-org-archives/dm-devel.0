Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A85C348C7C
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403342; cv=none; b=NKaS9p0xowAj0AgQf/gp8WZA6TRnxxSSfQgKVIZMLiW45NiVOAC2qXLWp0m7VamsvIG4l+26nXGo81DjQy5dYhEHaS/xP6f2N8cyk1GbhUbsDLj3jf3QqJCU9/fYSmM1axJFTgElKzdjc429L40dSxAYwJ/mNyhQU3wvKnnAnH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403342; c=relaxed/simple;
	bh=4q4QtSh7Fh8PnM7nTmsFAwKjfnL8mmiA/lx20oaUDGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+3Xfw4FJFOZS9kokDSvjKnArQZoMYjUKpaguHOu+ka2cb1FhpWW0BWzxaqp9NarAs5rHElZijv+tqDvvhMCOhrpsdV85cE0ZnYQrTlkD7ZvTy+1jtTcFZ/+eCOWNPyi5giOApE6kkf9GeNM/wXrtwD46KUwzz5eecRbdQmVDak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BDJZFPJ5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BDJZFPJ5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49258ac7294so277305e9.0
        for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782403340; x=1783008140; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMmsrow+XUenuLEtlSkT64hj6xXBh7pjgoqVS8JRFaE=;
        b=BDJZFPJ5sh5OwS/rk6RrOhPMbp8VueLxK50aKO2WwRD0Dfv/SXWxzzNwfooB/fgqn+
         2zHG2b7f5kf2Klor0m4M5hDQjV8zGbWTarCqiwVJG+jAFyLl2vaCDM+qJAiOsJ3pXprW
         6DhVrBhtB0xKiIZYc6li5bvE18mLMV8EDMTUucRmkq1S+pL+L6rYPMNqrPo7Yb5jJxrc
         9zuR8iwjm6mrJ6bbuPE0/q9myA4cbCiz+xiqF3ktITaan8RmBE+ahELvLd8bIFIOos0Q
         nHmMiPztjhmJYQPOsdn06wQtDTly1Han/b4uDEV5q9RvvOC6Rv6+BTKHA+tZN1U5ZLKp
         IdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403340; x=1783008140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aMmsrow+XUenuLEtlSkT64hj6xXBh7pjgoqVS8JRFaE=;
        b=GjMphVpZV2pzfTEQyfLTPe0Anx7s6HDYDQqVplg9UXh2jGM4S9JnWvrva1sS1aBz3C
         WWIexhRrst9FJJExoJCorxo47Q9fEyA+lTIg+Pc2wAbT5Bcg9+hOvMB8PFvmjAyFy+SP
         tmMn29jtLhOEV3gLnYans/ABhaEuEaxd0Zwe5OXtdzXaw9/Oq6eI/GV010TH3OYIdNSE
         /BAQGpZXI1hgKAfNjy6nARz7kMzpyV7xyeK9I+NHUY2uEfw6UbMysdZLYsdMqGF54s59
         7Q9Uj4VBVR5DGR5oT2Js0Bj9nJjgWXXumDOlnpk3Iw+ABd/JesY9Mi98v5lrKVgHnYTN
         s1Kg==
X-Gm-Message-State: AOJu0Yx7851qSwE5r/s6WJnYKyl9KPruLbu1H6a2i5oQoJHn9ucCOmyS
	PH09S6KL37QdO/o2+rxPCRkX6r/PCWDb5E7xRH4qdc9tawMkkW9swPtvIq/dv1ISl2Q=
X-Gm-Gg: AfdE7cmvrrgsHujHkboR2q5Y8s/AHP239bWzJWiK14kD2AkhfosEIwZM/j91RfltLIg
	K8dzU/ekDzZEggMK0iVP3V09CF6Jv9bmKYrkN2hqa+xvYCmmjHQ3o7Tq5mX59xBUvOeX4A4JTW1
	6y+fQAgc+5H4xyG6md9rtge9H/tWjjD6F9flslO02Ja1Gh6o67UUKERiCeURVVxyqzO0L2g/Zdx
	bm2QQZkXcvep53cI88XDuJlEog0tURYebLrFUHdF6C3URHt+HcnTpse/vxZEF5Yt+fln+RG7lTs
	XVkQKdxD/y99A3cSdDIcnrQWmJ2uiEqCi1kMpIIoEX9XTrVGNbdneJ1RStR2RGklWfh5nFLVvd/
	WnnbC+FozGH1Xe4aAT0E6KTfot70ATLnt5OuGTKQ4P4G/jB5bdyxVUV6RezA0lb+5OltfqTb2aU
	FoTgZdohUBt6dChrsvj+vL2TxweHj8hOaIH70+C+dINGDtS2AovjTPTsuDKYEVC1um3BvWOtOdO
	Ug=
X-Received: by 2002:a05:600d:844e:10b0:488:b187:3c with SMTP id 5b1f17b1804b1-49266869597mr35507225e9.14.1782403339932;
        Thu, 25 Jun 2026 09:02:19 -0700 (PDT)
Received: from localhost (p200300de374611012220024a9e5877d9.dip0.t-ipconnect.de. [2003:de:3746:1101:2220:24a:9e58:77d9])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49268fc0d36sm11960105e9.2.2026.06.25.09.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 09:02:19 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/4] libmpathutil: runner: use pthread_cleanup_push()
Date: Thu, 25 Jun 2026 18:02:00 +0200
Message-ID: <20260625160200.3318088-5-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625160200.3318088-1-mwilck@suse.com>
References: <20260625160200.3318088-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... instead of relying on -fexceptions and __attribute__((cleanup)).
The latter causes sporadic occurences of SIGSEGV on MUSL libc.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/runner.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
index c7adc20..694481e 100644
--- a/libmpathutil/runner.c
+++ b/libmpathutil/runner.c
@@ -40,10 +40,10 @@ struct runner_context {
 	char __attribute__((aligned(sizeof(void *)))) data[];
 };
 
-static void cleanup_context(struct runner_context **prctx)
+static void cleanup_context(void *arg)
 {
-	struct runner_context *rctx = *prctx;
 	int st;
+	struct runner_context *rctx = arg;
 
 	if (!rctx) {
 		condlog(0, "ERROR: %s: rctx is NULL", __func__);
@@ -82,7 +82,9 @@ static void *runner_thread(void *arg)
 	 * The cleanup function makes sure memory is freed if the thread is
 	 * cancelled (-fexceptions).
 	 */
-	struct runner_context *rctx __attribute__((cleanup(cleanup_context))) = arg;
+	struct runner_context *rctx = arg;
+
+	pthread_cleanup_push(cleanup_context, arg);
 
 #ifdef RUNNER_START_DELAY_US
 	/*
@@ -98,10 +100,12 @@ static void *runner_thread(void *arg)
 #endif
 
 	st = uatomic_cmpxchg(&rctx->status, RUNNER_IDLE, RUNNER_RUNNING);
-	if (st != RUNNER_IDLE)
-		return NULL;
 
-	(*rctx->func)(rctx->data);
+	/* Only run the function if we haven't been cancelled */
+	if (st == RUNNER_IDLE)
+		(*rctx->func)(rctx->data);
+
+	pthread_cleanup_pop(1);
 	return NULL;
 }
 
-- 
2.54.0

