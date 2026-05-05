Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86DA48AE35
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995835; cv=none; b=hR4CfZlOy/qgDq2Gry4D4Knhp6UCPumD3pHR6ko/q66m4tIdHRQAP0RSysfKRRsw/L4VbfTg7QaZ+2cHfcpInEu9GgEitd0qm9T6GyhplxEf4L97FPBf6echRrsZATyQYOZZR/SimYZl0YeytUAP/hfyXR4lWyqBK9yg1wOZWE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995835; c=relaxed/simple;
	bh=b1qkcOrz5SXlbdtr09gJ0ZpBG1z3McdXbrdLc1+Xx+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=natkA2pkqGOfFt6fnxVjYhEqymIeRDvNK/QO4NDqY1tF/1vax5AKZlkciahyfueRQFYbzQyRugc9sE6ysoJVhKcE8G75Rpml0PFAflhXQKRcWMxGc0TwBNeMExqt8xq5Drx4M7En+4SLD1hA/kR/tpU9L3D7PzITA8EJP8mOTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G3ZAxRu1; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G3ZAxRu1"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891f625344so58613495e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995832; x=1778600632; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDy4p+uuL7FX+ZYObh7QlI8/s/lQiEg/Wpft5quXxrI=;
        b=G3ZAxRu1aGs8nD7njeg2PA7oCV9QS5+IZK93zvsoKK6XGFcztmifDY7Kd4ittZmVyQ
         Is9jKvmAGsysefHt6w2Ep0x7+WHPRmROfXZphguPhXE/yAPfp1L4U6Be2fXLZHWDgQ+U
         fEio1vV0qCrZ15W3bkBCbX9biQzRPIjJbmcYG3hDSDoVoJCBXU/OSjily7xzTvmLHVDK
         oTYREtAZ0zuwfu/YnOGmhrFUm9nm3n5StGejbWrKK4Z0V2CpGkDBEqOFzgpdcawwhv7X
         vKBNxLoDsUfX6N4ONCTfTlT56Xde44lQv8EFQlvCu7D9E/QROkZGkp7JFMoijLsmx8on
         hDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995832; x=1778600632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uDy4p+uuL7FX+ZYObh7QlI8/s/lQiEg/Wpft5quXxrI=;
        b=e6cBrYB904x3TTt2M8+i2ocYbWchyRxEffMS5+bvtYiOsuEdhno6Htuk7sgjCeaYPo
         WifflufudCCbPOY98nm/Q4wwE+XY0vRkCTkiMS5eYC6OZXl2wrfvQii6M2jfbLhqFAdj
         PPvLsfRUUT27o4zSguUQodtH6eGCk3zeUObpzYMQhA0eW13+jzC78TzeIFTO17/L6jWC
         XR1EQH9KNIBFoI1nw4MGUdb76gAc3ggWwIQUejTgxxwn0pYkfJ1Yt0JNr5KqdE58CP/9
         ZbujQybHOlyte9s+OwdesUYW5sf/6u505Nj2zIvcK+GstrcHxtJ5zIfL+49ZUkJ5LR9v
         6LBw==
X-Forwarded-Encrypted: i=1; AFNElJ+TdvYY7ejdQmXZYz9rkCsN2qjKb81ARstbejEtKJ4L9wnzjaGQtv9apg0TslIVHZXuTWZF2bwFTA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzjOpa6ANKak3oOgGPn1qFZeT3XMan/uLUsm0gh1i2pK9hDL2tX
	UjJV2wbA8lzax59FvHkUWpl48fvvGjhPQTaYLhwddK5s72Wd5exeC6/r3+ch9z/BXbE=
X-Gm-Gg: AeBDieuOjUkcbZXhAUjRkqFUMZzIkLTAslkfGEV+2VsTpbGOSLFG8nogWNILAOvyvpj
	r3FiWG2OnqfK4RLG+IOsfG+R8SxM77Pe/jzf/r83GPd4Ss+pTXiCrdS7dPXZTMdKH72rP5N80gU
	7EfTQhD0Jheoa+6xC+VHcTWo4zDg3IQwAZT9jr8IxzWR01G/+TGbD6SHGCK8SrrPvBOwQ1s7L1F
	jBbYMrQXs1qSk7DBNNbcxtiT4TRptRzF9ruuiq4ruNgVPu8bOqZicbUWv2nxzI0o015v3FcTfhj
	yAr9rXHKfmpaX4oDXe7BowBuxR3o3IgiK2vjKnqGSJivm+KNAWDi2EMsyh0Rq1xS0qouMiR0uJI
	qMs91389CJ9uME8kUQEUV/5h12bSkYUKzpke0q9htMw9TLdkeLpQ7PC1WruTNdSC+at4dLxK5y1
	VV1JmPYmgZL85YKgTMFQsKVdZKOcQ+jwXEr8yKwBeq3bivPVdeaH7tjsoTuoCtZuY3f8Ab9GKmc
	8Z0HRhQ+2plCsgCGbt262Oe
X-Received: by 2002:a05:600c:c096:b0:48a:5821:6006 with SMTP id 5b1f17b1804b1-48d142331dcmr48670945e9.4.1777995832043;
        Tue, 05 May 2026 08:43:52 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a8eba8487sm356574495e9.11.2026.05.05.08.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:51 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/18] libmultipath: use shared_ptr for checker classes
Date: Tue,  5 May 2026 17:43:20 +0200
Message-ID: <20260505154332.448054-7-mwilck@suse.com>
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

Utilize the share_ptr code for tracking the refcount of checker classes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c | 98 +++++++++--------------------------------
 libmultipath/checkers.h |  2 -
 2 files changed, 20 insertions(+), 80 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 8f18ca6..a3b9cc8 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -39,41 +39,11 @@ const char *checker_state_name(int i)
 	return checker_state_names[i];
 }
 
-static struct checker_class *alloc_checker_class(void)
+static void free_checker_class(void *ptr)
 {
-	struct checker_class *c;
-
-	c = calloc(1, sizeof(struct checker_class));
-	if (c) {
-		INIT_LIST_HEAD(&c->node);
-		uatomic_set(&c->refcount, 1);
-	}
-	return c;
-}
-
-/* Use uatomic_{sub,add}_return() to ensure proper memory barriers */
-static int checker_class_ref(struct checker_class *cls)
-{
-	return uatomic_add_return(&cls->refcount, 1);
-}
-
-static int checker_class_unref(struct checker_class *cls)
-{
-	return uatomic_sub_return(&cls->refcount, 1);
-}
-
-void free_checker_class(struct checker_class *c)
-{
-	int cnt;
-
+	struct checker_class *c = ptr;
 	if (!c)
 		return;
-	cnt = checker_class_unref(c);
-	if (cnt != 0) {
-		condlog(cnt < 0 ? 1 : 4, "%s checker refcount %d",
-			c->name, cnt);
-		return;
-	}
 	condlog(3, "unloading %s checker", c->name);
 	list_del(&c->node);
 	if (c->reset)
@@ -84,7 +54,18 @@ void free_checker_class(struct checker_class *c)
 				c->name, dlerror());
 		}
 	}
-	free(c);
+}
+
+static struct checker_class *alloc_checker_class(void)
+{
+	struct checker_class *c;
+
+	c = alloc_shared_ptr(sizeof(*c), free_checker_class);
+	if (c) {
+		memset(c, 0, sizeof(*c));
+		INIT_LIST_HEAD(&c->node);
+	}
+	return c;
 }
 
 void cleanup_checkers (void)
@@ -92,9 +73,8 @@ void cleanup_checkers (void)
 	struct checker_class *checker_loop;
 	struct checker_class *checker_temp;
 
-	list_for_each_entry_safe(checker_loop, checker_temp, &checkers, node) {
-		free_checker_class(checker_loop);
-	}
+	list_for_each_entry_safe(checker_loop, checker_temp, &checkers, node)
+		put_shared_ptr(checker_loop);
 }
 
 static struct checker_class *checker_class_lookup(const char *name)
@@ -163,8 +143,7 @@ static struct checker_class *add_checker_class(const char *name)
 		goto out;
 
 	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
-	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
-	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
+	c->reset = (void (*)(void))dlsym(c->handle, "libcheck_reset");
 	c->pending = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_pending");
 	c->need_wait = (bool (*)(struct checker *)) dlsym(c->handle, "libcheck_need_wait");
 	/* These 5 functions can be NULL. call dlerror() to clear out any
@@ -199,7 +178,7 @@ done:
 	list_add(&c->node, &checkers);
 	return c;
 out:
-	free_checker_class(c);
+	put_shared_ptr(c);
 	return NULL;
 }
 
@@ -285,7 +264,7 @@ void checker_put (struct checker * dst)
 	if (src && src->free)
 		src->free(dst);
 	checker_clear(dst);
-	free_checker_class(src);
+	put_shared_ptr(src);
 }
 
 int checker_get_state(struct checker *c)
@@ -371,43 +350,6 @@ bad_id:
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
@@ -431,7 +373,7 @@ void checker_get(struct checker *dst, const char *name)
 	if (!src)
 		return;
 
-	(void)checker_class_ref(dst->cls);
+	get_shared_ptr(dst->cls);
 }
 
 int init_checkers(void)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 694dfa3..630e987 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -135,7 +135,6 @@ struct checker;
 struct checker_class {
 	struct list_head node;
 	void *handle;
-	int refcount;
 	int sync;
 	char name[CHECKER_NAME_LEN];
 	int (*check)(struct checker *);
@@ -143,7 +142,6 @@ struct checker_class {
 	int (*mp_init)(struct checker *); /* to allocate the mpcontext */
 	void (*free)(struct checker *);	  /* to free the context */
 	void (*reset)(void);		  /* to reset the global variables */
-	void *(*thread)(void *);	  /* async thread entry point */
 	int (*pending)(struct checker *); /* to recheck pending paths */
 	bool (*need_wait)(struct checker *); /* checker needs waiting for */
 	const char **msgtable;
-- 
2.54.0

