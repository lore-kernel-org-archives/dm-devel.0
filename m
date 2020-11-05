Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC57FC388F7
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 11:50:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E9452083B
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 11:50:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E9452083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-dei1C455Mo-xARw-sgfuiw-1; Thu, 05 Nov 2020 06:50:41 -0500
X-MC-Unique: dei1C455Mo-xARw-sgfuiw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4865935A1B;
	Thu,  5 Nov 2020 11:50:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B11736198D;
	Thu,  5 Nov 2020 11:50:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 70D0E44A43;
	Thu,  5 Nov 2020 11:50:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A5BoBlg005441 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 06:50:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9A9A8217B43E; Thu,  5 Nov 2020 11:50:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9192F217B432
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 11:50:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEB8D90E424
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 11:50:07 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-393-bjaVSgbxMm6DJFXv3tYTdw-1;
	Thu, 05 Nov 2020 06:50:04 -0500
X-MC-Unique: bjaVSgbxMm6DJFXv3tYTdw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5AAB4ABE3;
	Thu,  5 Nov 2020 11:50:03 +0000 (UTC)
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  5 Nov 2020 12:49:52 +0100
Message-Id: <20201105114952.1059-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A5BoBlg005441
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [RFC PATCH] libmultipath: prevent DSO unloading with
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 libmultipath/checkers.c     | 55 ++++++++++++++++++++++++++++++++-----
 libmultipath/checkers.h     | 17 ++++++++++++
 libmultipath/checkers/tur.c |  7 ++---
 3 files changed, 67 insertions(+), 12 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index f7ddd53..7d10f2a 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -3,6 +3,9 @@
 #include <stddef.h>
 #include <dlfcn.h>
 #include <sys/stat.h>
+#include <pthread.h>
+#include <urcu.h>
+#include <urcu/uatomic.h>
 
 #include "debug.h"
 #include "checkers.h"
@@ -19,6 +22,7 @@ struct checker_class {
 	int (*mp_init)(struct checker *);    /* to allocate the mpcontext */
 	void (*free)(struct checker *);      /* to free the context */
 	void (*reset)(void);		     /* to reset the global variables */
+	void *(*thread)(void *);	     /* async thread entry point */
 	const char **msgtable;
 	short msgtable_size;
 };
@@ -54,19 +58,32 @@ static struct checker_class *alloc_checker_class(void)
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
@@ -160,7 +177,8 @@ static struct checker_class *add_checker_class(const char *multipath_dir,
 
 	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
 	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
-	/* These 2 functions can be NULL. call dlerror() to clear out any
+	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
+	/* These 3 functions can be NULL. call dlerror() to clear out any
 	 * error string */
 	dlerror();
 
@@ -346,6 +364,29 @@ bad_id:
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
+void *checker_thread_entry(void *arg)
+{
+	struct checker *chk = arg;
+	void *rv;
+
+	assert(chk && chk->cls && chk->cls->thread);
+
+	rcu_register_thread();
+	(void)checker_class_ref(chk->cls);
+	pthread_cleanup_push(checker_cleanup_thread, chk->cls);
+	rv = chk->cls->thread(chk->context);
+	pthread_cleanup_pop(1);
+	return rv;
+}
+
 void checker_clear_message (struct checker *c)
 {
 	if (!c)
@@ -370,7 +411,7 @@ void checker_get(const char *multipath_dir, struct checker *dst,
 	if (!src)
 		return;
 
-	src->refcount++;
+	(void)checker_class_ref(dst->cls);
 }
 
 int init_checkers(const char *multipath_dir)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 9d5f90b..01af02d 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -148,6 +148,23 @@ void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
+/*
+ * checker_thread_entry(): entry point for async path checker thread
+ *
+ * Path checkers that do I/O may hang forever. To avoid blocking, some
+ * checkers therefore use asyncronous, detached threads for checking
+ * the paths. These threads may continue hanging if multipathd is stopped.
+ * In this case, we can't unload the checker DSO at exit. In order to
+ * avoid race conditions and crashes, the entry point of the thread
+ * needs to be in libmultipath, not in the DSO itself.
+ * Checker threads must use this function as entry point. It will call
+ * the DSO's "libcheck_thread" function with the checker context as
+ * argument. When libcheck_thread() returns, it will clean up and
+ * decrement the DSO's refcount. See the tur checker for a usage example.
+ *
+ * @param arg: pointer to struct checker, must have non-NULL cls->thread
+ */
+void *checker_thread_entry (void *);
 int checker_check (struct checker *, int);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index e886fcf..063c419 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -15,7 +15,6 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <pthread.h>
-#include <urcu.h>
 #include <urcu/uatomic.h>
 
 #include "checkers.h"
@@ -204,7 +203,6 @@ static void cleanup_func(void *data)
 	holders = uatomic_sub_return(&ct->holders, 1);
 	if (!holders)
 		cleanup_context(ct);
-	rcu_unregister_thread();
 }
 
 /*
@@ -251,7 +249,7 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
 #define tur_deep_sleep(x) do {} while (0)
 #endif /* TUR_TEST_MAJOR */
 
-static void *tur_thread(void *ctx)
+void *libcheck_thread(void *ctx)
 {
 	struct tur_checker_context *ct = ctx;
 	int state, running;
@@ -259,7 +257,6 @@ static void *tur_thread(void *ctx)
 
 	/* This thread can be canceled, so setup clean up */
 	tur_thread_cleanup_push(ct);
-	rcu_register_thread();
 
 	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
 		minor(ct->devt));
@@ -394,7 +391,7 @@ int libcheck_check(struct checker * c)
 		uatomic_set(&ct->running, 1);
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
-		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
+		r = pthread_create(&ct->thread, &attr, checker_thread_entry, c);
 		pthread_attr_destroy(&attr);
 		if (r) {
 			uatomic_sub(&ct->holders, 1);
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

