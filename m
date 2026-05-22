Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8C834DB46
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468291; cv=none; b=VNQVRGLUynFGE6SORSNOJyV1xzz2YqWni0vbZQDkX4D5RLclfhm7FSjKMkDXgs4U7C1DvReNIvt/Wlr+liaZjk9mPw9Qr2YyKV+NE11iW0MJzJcxy+v9mWlq98EziOeVMxxSOcDWgtLOYesr4PTna22aHr43ow42O0bS2jN1v/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468291; c=relaxed/simple;
	bh=S1KX4cPbYFuAXCYMPi2sg4djmvUgg4Kdn95iZaUGK/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1s3nof5R7SSiBou5GppoN/7ZQ5BpkkcilZixOWrSyy/0O2dj4Sp/ilNTZxv9hwgh/PdgxCowj5BooKm7JiSkmm4CPCSsYjy39DbFkJssFVtBGC6meWqW308PqCrSgKCIiTZH+zczYoyk/beNRp8w48gPVluz/s2PXLLfENtlo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Pxj4m2f+; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Pxj4m2f+"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso48075475e9.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468288; x=1780073088; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOpvvTIhDNU0ToK3DjIsHlvMt0SliJvpy4FgbZgd4Cg=;
        b=Pxj4m2f+vaNYM5Lw9NywvesVHnzzbpE6hpayTnyuT3iCXU+tzaNLqzChVC+SChmozd
         Nbp2uOOY2IgGGNrNEopZ2SpSe4brA+nIjBt2M7RrI9pIWlQQ9TOrN9VIO9IqMi6GLIQF
         qSx4HH93qvbz4QKtLKAjxOM5bs1E9QD7HBU3uqkd8lzezaZp1GZPCg31BS4cG4tW2ihu
         UPq04kzbFQp1vNZACHiKDNbQLRrLIzITziwfzqP5HbwNZ9Kxu1lie5+ywjrwPMzN0nQh
         MxaLp5LgZuItecf10IZpOjZZ1GxXmfttOPdSlodElAg9tQ5qW0IQwRrOcfSAgCkhlGzh
         rYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468288; x=1780073088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BOpvvTIhDNU0ToK3DjIsHlvMt0SliJvpy4FgbZgd4Cg=;
        b=B1Zp6sIxtCRItrqX5ArcroD9k9ygJLFStpv/A1vJvJHoKSPfqywNo3wtCM27O0p5tL
         bT85guJ69aTDJ5hFzULx/wrKxOc9XR0QP4jqMfXJKquy5Dep6Spi02sObpQEVy7cQvra
         IBMTJ7A5SH54TMZPE+wNflybUHNgKo6AfLiTygcTG8sCy7hsTHOpGGdUbFnS0zSFNdJU
         Ir6QWgepsbLnwTZAnSi3zluNoEqMqPmcUslifzzmkeBmD4jbdRyzMz54pLvcQxbcTQT7
         BMMSXDFaGI5CPbThllUfjLHl5rPSpfnv4r/C2bnstZg1ZVK5X15ZzPh907+cmY8NxGXD
         h6nw==
X-Forwarded-Encrypted: i=1; AFNElJ8XhunowPHAX0FXe4KiJgRdfYVGuLheXnj+D8TV04IFqSfGy4iNbfJmoOqqlh9kMqNAR5sbTsvnaQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YydneP1QCOskvplrRG3W/bGkiFi5YyAZGsfk23baMvlK1Z1XQuM
	s/MWnvJ+MJdSwN8eoeaCE9lrKSHWG1M54T2djTjpoJM+IsR334Htraon5XmMJZEfai4=
X-Gm-Gg: Acq92OHMSLBpJDdKND5wMkPLbKlGTvFWCcs+6k8CwZRRdAqqskzr+yhGwyKNaLgaNY6
	qqZaM9Xxn/bcK4hrHM9p4qMus0cfQEz46kp6Gfp1+68Z8Rhnj56td6Ool/F60sIp19lnxPYs73a
	9jRjVU2Sq47iveuC05JhygPf2o8ePsh2gQNLgcb7kCHuYduGnIxyZgdV7+kPuCyFwqsYn+u2Pmh
	GaMPgcfZ5ZDrLcVqPdMEaUbR4yyD0f893KmUQqNM5NM0mmTW7ybwgZyOk540ytMzRubbPZ27UYj
	U4YXdPCz1Mqot4/rQTMSJUQcCrWvCa1jO/TQ0cfNYPdHpYsNyNscooXVVWqTmA1gAMLbWFu+aYg
	V2mePuTxBRBJTzIl2eIsuX58TYBAeoEi35oOf5e6ZutJOT+yiVyz1Z3YkWfysA/dNjpmg+xuOFc
	/r4dVpWeKG3SNS2/iFdW0C5GSSZc68hrNqMx3D62NKFGQIxjNKggjgMldzo2K32UCPUpK1AH2C1
	QoLsP3786Mlkw==
X-Received: by 2002:a05:600c:3b27:b0:490:3b87:be0f with SMTP id 5b1f17b1804b1-490428d750fmr62251985e9.23.1779468287584;
        Fri, 22 May 2026 09:44:47 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49042cebaaasm19493755e9.36.2026.05.22.09.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:47 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/19] libmultipath: remove libcheck_thread related code
Date: Fri, 22 May 2026 18:44:02 +0200
Message-ID: <20260522164415.846589-7-mwilck@suse.com>
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

After d1ebd97 ("libmultipath: TUR checker: use runner threads"),
this code is not used any more. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c           | 40 +------------------------------
 libmultipath/checkers.h           | 22 +----------------
 libmultipath/libmultipath.version |  1 -
 3 files changed, 2 insertions(+), 61 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 8f18ca6..5655146 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -163,8 +163,7 @@ static struct checker_class *add_checker_class(const char *name)
 		goto out;
 
 	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
-	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
-	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
+	c->reset = (void (*)(void))dlsym(c->handle, "libcheck_reset");
 	c->pending = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_pending");
 	c->need_wait = (bool (*)(struct checker *)) dlsym(c->handle, "libcheck_need_wait");
 	/* These 5 functions can be NULL. call dlerror() to clear out any
@@ -371,43 +370,6 @@ bad_id:
 	return generic_msg[CHECKER_MSGID_NONE];
 }
 
-static void checker_cleanup_thread(void *arg)
-{
-	struct checker_class *cls = arg;
-
-	free_checker_class(cls);
-	rcu_unregister_thread();
-}
-
-static void *checker_thread_entry(void *arg)
-{
-	struct checker_context *ctx = arg;
-	void *rv;
-
-	rcu_register_thread();
-	pthread_cleanup_push(checker_cleanup_thread, ctx->cls);
-	rv = ctx->cls->thread(ctx);
-	pthread_cleanup_pop(1);
-	return rv;
-}
-
-int start_checker_thread(pthread_t *thread, const pthread_attr_t *attr,
-			 struct checker_context *ctx)
-{
-	int rv;
-
-	assert(ctx && ctx->cls && ctx->cls->thread);
-	/* Take a ref here, lest the class be freed before the thread starts */
-	(void)checker_class_ref(ctx->cls);
-	rv = pthread_create(thread, attr, checker_thread_entry, ctx);
-	if (rv != 0) {
-		condlog(1, "failed to start checker thread for %s: %m",
-			ctx->cls->name);
-		checker_class_unref(ctx->cls);
-	}
-	return rv;
-}
-
 void checker_clear_message (struct checker *c)
 {
 	if (!c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 694dfa3..e69dfd9 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -143,7 +143,6 @@ struct checker_class {
 	int (*mp_init)(struct checker *); /* to allocate the mpcontext */
 	void (*free)(struct checker *);	  /* to free the context */
 	void (*reset)(void);		  /* to reset the global variables */
-	void *(*thread)(void *);	  /* async thread entry point */
 	int (*pending)(struct checker *); /* to recheck pending paths */
 	bool (*need_wait)(struct checker *); /* checker needs waiting for */
 	const char **msgtable;
@@ -179,29 +178,10 @@ void checker_set_sync (struct checker *);
 void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
-void checker_disable (struct checker *);
-/*
- * start_checker_thread(): start async path checker thread
- *
- * This function provides a wrapper around pthread_create().
- * The created thread will call the DSO's "libcheck_thread" function with the
- * checker context as argument.
- *
- * Rationale:
- * Path checkers that do I/O may hang forever. To avoid blocking, some
- * checkers therefore use asynchronous, detached threads for checking
- * the paths. These threads may continue hanging if multipathd is stopped.
- * In this case, we can't unload the checker DSO at exit. In order to
- * avoid race conditions and crashes, the entry point of the thread
- * needs to be in libmultipath, not in the DSO itself.
- *
- * @param arg: pointer to struct checker_context.
- */
+void checker_disable(struct checker *);
 struct checker_context {
 	struct checker_class *cls;
 };
-int start_checker_thread (pthread_t *thread, const pthread_attr_t *attr,
-			  struct checker_context *ctx);
 int checker_get_state(struct checker *c);
 bool checker_need_wait(struct checker *c);
 void checker_check (struct checker *, int);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 78fa2d4..5deee32 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -221,7 +221,6 @@ global:
 	/* checkers */
 	checker_is_sync;
 	sg_read;
-	start_checker_thread;
 
 	/* prioritizers */
 	get_asymmetric_access_state;
-- 
2.54.0

