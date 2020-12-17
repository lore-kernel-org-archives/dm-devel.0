Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7720C2BB40
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 201B22389B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 201B22389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-fw1I-6a-NG2LJTSmJvImKw-1; Thu, 17 Dec 2020 06:01:09 -0500
X-MC-Unique: fw1I-6a-NG2LJTSmJvImKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D507107ACFB;
	Thu, 17 Dec 2020 11:01:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E77C563632;
	Thu, 17 Dec 2020 11:01:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B872D4A7C6;
	Thu, 17 Dec 2020 11:01:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0gPa030276 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A326A2026D48; Thu, 17 Dec 2020 11:00:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C5042026D15
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4001858284
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-35-kcIYeTApO2OweNowfTJG7g-1;
	Thu, 17 Dec 2020 06:00:35 -0500
X-MC-Unique: kcIYeTApO2OweNowfTJG7g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 633D3AD12;
	Thu, 17 Dec 2020 11:00:33 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:14 +0100
Message-Id: <20201217110018.3347-4-mwilck@suse.com>
In-Reply-To: <20201217110018.3347-1-mwilck@suse.com>
References: <20201217110018.3347-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0gPa030276
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/7] libmultipath: prevent DSO unloading with
	astray checker threads
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

From: Martin Wilck <mwilck@suse.com>

The multipathd tur checker thread is designed to be able to finish at
any time, even after the tur checker itself has been freed. The
multipathd shutdown code makes sure all the checkers have been freed
before freeing the checker_class and calling dlclose() to unload the
DSO, but this doesn't guarantee that the checker threads have finished.
If one hasn't, the DSO will get unloaded while the thread still running
code from it, causing a segfault.

This patch fixes the issue by further incrementing the DSO's refcount
for every running thread. To avoid race conditions leading to segfaults,
the thread's entrypoint must be in libmultipath, not in the DSO itself.
Therefore we add a new optional checker method, libcheck_thread().
Checkers defining this method may create a detached thread with
entrypoint checker_thread_entry(), which will call the DSO's
libcheck_thread and take care of the refcount handling.

Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c           | 68 +++++++++++++++++++++++++++----
 libmultipath/checkers.h           | 25 ++++++++++++
 libmultipath/checkers/tur.c       | 12 +++---
 libmultipath/libmultipath.version |  5 +++
 4 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 18b1f5e..2dd9915 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -3,6 +3,8 @@
 #include <stddef.h>
 #include <dlfcn.h>
 #include <sys/stat.h>
+#include <urcu.h>
+#include <urcu/uatomic.h>
 
 #include "debug.h"
 #include "checkers.h"
@@ -20,6 +22,7 @@ struct checker_class {
 	int (*mp_init)(struct checker *);    /* to allocate the mpcontext */
 	void (*free)(struct checker *);      /* to free the context */
 	void (*reset)(void);		     /* to reset the global variables */
+	void *(*thread)(void *);	     /* async thread entry point */
 	const char **msgtable;
 	short msgtable_size;
 };
@@ -55,19 +58,32 @@ static struct checker_class *alloc_checker_class(void)
 	c = MALLOC(sizeof(struct checker_class));
 	if (c) {
 		INIT_LIST_HEAD(&c->node);
-		c->refcount = 1;
+		uatomic_set(&c->refcount, 1);
 	}
 	return c;
 }
 
+/* Use uatomic_{sub,add}_return() to ensure proper memory barriers */
+static int checker_class_ref(struct checker_class *cls)
+{
+	return uatomic_add_return(&cls->refcount, 1);
+}
+
+static int checker_class_unref(struct checker_class *cls)
+{
+	return uatomic_sub_return(&cls->refcount, 1);
+}
+
 void free_checker_class(struct checker_class *c)
 {
+	int cnt;
+
 	if (!c)
 		return;
-	c->refcount--;
-	if (c->refcount) {
-		condlog(4, "%s checker refcount %d",
-			c->name, c->refcount);
+	cnt = checker_class_unref(c);
+	if (cnt != 0) {
+		condlog(cnt < 0 ? 1 : 4, "%s checker refcount %d",
+			c->name, cnt);
 		return;
 	}
 	condlog(3, "unloading %s checker", c->name);
@@ -161,7 +177,8 @@ static struct checker_class *add_checker_class(const char *multipath_dir,
 
 	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
 	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
-	/* These 2 functions can be NULL. call dlerror() to clear out any
+	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
+	/* These 3 functions can be NULL. call dlerror() to clear out any
 	 * error string */
 	dlerror();
 
@@ -347,6 +364,43 @@ bad_id:
 	return generic_msg[CHECKER_MSGID_NONE];
 }
 
+static void checker_cleanup_thread(void *arg)
+{
+	struct checker_class *cls = arg;
+
+	(void)checker_class_unref(cls);
+	rcu_unregister_thread();
+}
+
+static void *checker_thread_entry(void *arg)
+{
+	struct checker_context *ctx = arg;
+	void *rv;
+
+	rcu_register_thread();
+	pthread_cleanup_push(checker_cleanup_thread, ctx->cls);
+	rv = ctx->cls->thread(ctx);
+	pthread_cleanup_pop(1);
+	return rv;
+}
+
+int start_checker_thread(pthread_t *thread, const pthread_attr_t *attr,
+			 struct checker_context *ctx)
+{
+	int rv;
+
+	assert(ctx && ctx->cls && ctx->cls->thread);
+	/* Take a ref here, lest the class be freed before the thread starts */
+	(void)checker_class_ref(ctx->cls);
+	rv = pthread_create(thread, attr, checker_thread_entry, ctx);
+	if (rv != 0) {
+		condlog(1, "failed to start checker thread for %s: %m",
+			ctx->cls->name);
+		checker_class_unref(ctx->cls);
+	}
+	return rv;
+}
+
 void checker_clear_message (struct checker *c)
 {
 	if (!c)
@@ -371,7 +425,7 @@ void checker_get(const char *multipath_dir, struct checker *dst,
 	if (!src)
 		return;
 
-	src->refcount++;
+	(void)checker_class_ref(dst->cls);
 }
 
 int init_checkers(const char *multipath_dir)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 9d5f90b..2fd1d1c 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -1,6 +1,7 @@
 #ifndef _CHECKERS_H
 #define _CHECKERS_H
 
+#include <pthread.h>
 #include "list.h"
 #include "memory.h"
 #include "defaults.h"
@@ -148,6 +149,28 @@ void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
+/*
+ * start_checker_thread(): start async path checker thread
+ *
+ * This function provides a wrapper around pthread_create().
+ * The created thread will call the DSO's "libcheck_thread" function with the
+ * checker context as argument.
+ *
+ * Rationale:
+ * Path checkers that do I/O may hang forever. To avoid blocking, some
+ * checkers therefore use asyncronous, detached threads for checking
+ * the paths. These threads may continue hanging if multipathd is stopped.
+ * In this case, we can't unload the checker DSO at exit. In order to
+ * avoid race conditions and crashes, the entry point of the thread
+ * needs to be in libmultipath, not in the DSO itself.
+ *
+ * @param arg: pointer to struct checker_context.
+ */
+struct checker_context {
+	struct checker_class *cls;
+};
+int start_checker_thread (pthread_t *thread, const pthread_attr_t *attr,
+			  struct checker_context *ctx);
 int checker_check (struct checker *, int);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
@@ -164,6 +187,8 @@ void checker_get(const char *, struct checker *, const char *);
 int libcheck_check(struct checker *);
 int libcheck_init(struct checker *);
 void libcheck_free(struct checker *);
+void *libcheck_thread(struct checker_context *ctx);
+
 /*
  * msgid => message map.
  *
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index e886fcf..a4b4a21 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -15,7 +15,6 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <pthread.h>
-#include <urcu.h>
 #include <urcu/uatomic.h>
 
 #include "checkers.h"
@@ -55,6 +54,7 @@ struct tur_checker_context {
 	pthread_cond_t active;
 	int holders; /* uatomic access only */
 	int msgid;
+	struct checker_context ctx;
 };
 
 int libcheck_init (struct checker * c)
@@ -74,6 +74,7 @@ int libcheck_init (struct checker * c)
 	pthread_mutex_init(&ct->lock, NULL);
 	if (fstat(c->fd, &sb) == 0)
 		ct->devt = sb.st_rdev;
+	ct->ctx.cls = c->cls;
 	c->context = ct;
 
 	return 0;
@@ -204,7 +205,6 @@ static void cleanup_func(void *data)
 	holders = uatomic_sub_return(&ct->holders, 1);
 	if (!holders)
 		cleanup_context(ct);
-	rcu_unregister_thread();
 }
 
 /*
@@ -251,15 +251,15 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
 #define tur_deep_sleep(x) do {} while (0)
 #endif /* TUR_TEST_MAJOR */
 
-static void *tur_thread(void *ctx)
+void *libcheck_thread(struct checker_context *ctx)
 {
-	struct tur_checker_context *ct = ctx;
+	struct tur_checker_context *ct =
+		container_of(ctx, struct tur_checker_context, ctx);
 	int state, running;
 	short msgid;
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
-	rcu_register_thread();
 
 	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
 		minor(ct->devt));
@@ -394,7 +394,7 @@ int libcheck_check(struct checker * c)
 		uatomic_set(&ct->running, 1);
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
-		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
+		r = start_checker_thread(&ct->thread, &attr, &ct->ctx);
 		pthread_attr_destroy(&attr);
 		if (r) {
 			uatomic_sub(&ct->holders, 1);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 2e3583f..751099d 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -270,3 +270,8 @@ global:
 	dm_prereq;
 	skip_libmp_dm_init;
 } LIBMULTIPATH_4.1.0;
+
+LIBMULTIPATH_4.3.0 {
+global:
+	start_checker_thread;
+} LIBMULTIPATH_4.2.0;
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

