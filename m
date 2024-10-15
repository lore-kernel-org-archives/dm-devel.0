Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6D51714C4
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962925; cv=none; b=GZ0Rj/BRSRWhzwNkMXrPHWSBWft452H/+dvbmvbP4zU16fDGV2Wimf2vJ9hAs9G3oDCOH99tUmylNNRmupgSECbssWOvcbeSLAktFVkna9oM1V3sFkNLiyfYI5lFwldCDdu6d7c8mQ+N15z3YVSD/ctC5aYvnx98aIrZIdFLz/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962925; c=relaxed/simple;
	bh=carlqwuHvzs4hWAk5yJVCrw1UpAvroQeY7+FaTa3NqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAD0QTC+Jr7lxk5ViN1HMQOHNkR3XoMV6oXLZH9QaaDkcgJ1toi9Iqtb5H/BILF4YhvhiWZLwUGZeHdsFbC8ERTTtBYTC0BWBMw7DRKAlIyPYmjU1Z4z+Nsj2Zmg1nEG0FF5pFI3xE7yppAHJtSo8X4WVfQwuy8CYkvBdBjOUaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B6SHz7rC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6SHz7rC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k6iSHZPtUFiEmqZCod3IM3UIOhtJux4wqtbcI3I8ouc=;
	b=B6SHz7rC+38uXDqjCxKtTJhK1T4ivDufAer+fl9GnJ4cdnNTEvFBAbCSqx68bDDJs5To7B
	QNZj+hJI3DGyVBM+oACY34pBhSJOg5VqM/cTdUbxx+QZN50yrD2UpHSZM2u6XIuTZHbbeU
	sDVatMEeIbHfuHvr5Nmf0l2XteuOKKY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-sPubHlDDMRWV6oIqGCNUng-1; Mon,
 14 Oct 2024 23:28:40 -0400
X-MC-Unique: sPubHlDDMRWV6oIqGCNUng-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA7A01955EE8;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8400D19560A2;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3Sct02693355
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3ScGU2693354;
	Mon, 14 Oct 2024 23:28:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v5 19/23] libmultipath: add libcheck_need_wait checker function
Date: Mon, 14 Oct 2024 23:28:31 -0400
Message-ID: <20241015032835.2693247-20-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Add a new optional checker class function, libcheck_need_wait() and a
new function to call it, checker_need_wait(). This can be used to see if
a path_checker is currently running. This will be used to determine if
there are pending checkers that need to be waited for.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c          | 12 +++++++++++-
 libmultipath/checkers.h          |  4 +++-
 libmultipath/checkers/directio.c | 11 +++++++++++
 libmultipath/checkers/tur.c      | 11 +++++++++++
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index f3e98352..e2eda58d 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -27,6 +27,7 @@ struct checker_class {
 	void (*reset)(void);		     /* to reset the global variables */
 	void *(*thread)(void *);	     /* async thread entry point */
 	int (*pending)(struct checker *);    /* to recheck pending paths */
+	bool (*need_wait)(struct checker *); /* checker needs waiting for */
 	const char **msgtable;
 	short msgtable_size;
 };
@@ -182,7 +183,8 @@ static struct checker_class *add_checker_class(const char *name)
 	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
 	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
 	c->pending = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_pending");
-	/* These 4 functions can be NULL. call dlerror() to clear out any
+	c->need_wait = (bool (*)(struct checker *)) dlsym(c->handle, "libcheck_need_wait");
+	/* These 5 functions can be NULL. call dlerror() to clear out any
 	 * error string */
 	dlerror();
 
@@ -313,6 +315,14 @@ int checker_get_state(struct checker *c)
 	return c->path_state;
 }
 
+bool checker_need_wait(struct checker *c)
+{
+	if (!c || !c->cls || c->path_state != PATH_PENDING ||
+	    !c->cls->need_wait)
+		return false;
+	return c->cls->need_wait(c);
+}
+
 void checker_check (struct checker * c, int path_state)
 {
 	if (!c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index b2342a1b..da91f499 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -2,6 +2,7 @@
 #define CHECKERS_H_INCLUDED
 
 #include <pthread.h>
+#include <stdbool.h>
 #include "list.h"
 #include "defaults.h"
 
@@ -171,6 +172,7 @@ struct checker_context {
 int start_checker_thread (pthread_t *thread, const pthread_attr_t *attr,
 			  struct checker_context *ctx);
 int checker_get_state(struct checker *c);
+bool checker_need_wait(struct checker *c);
 void checker_check (struct checker *, int);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
@@ -191,7 +193,7 @@ void *libcheck_thread(struct checker_context *ctx);
 void libcheck_reset(void);
 int libcheck_mp_init(struct checker *);
 int libcheck_pending(struct checker *c);
-
+bool libcheck_need_wait(struct checker *c);
 
 /*
  * msgid => message map.
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 904e3071..54c12f7b 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -65,6 +65,7 @@ struct directio_context {
 	struct aio_group *aio_grp;
 	struct async_req *req;
 	struct timespec endtime;
+	bool checked_state;
 };
 
 static struct aio_group *
@@ -295,6 +296,7 @@ check_pending(struct directio_context *ct, struct timespec endtime)
 	int r;
 	struct timespec currtime, timeout;
 
+	ct->checked_state = true;
 	while(1) {
 		get_monotonic_time(&currtime);
 		timespecsub(&endtime, &currtime, &timeout);
@@ -327,6 +329,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 		LOG(4, "called in synchronous mode");
 
 	if (ct->running) {
+		ct->checked_state = true;
 		if (ct->req->state != PATH_PENDING) {
 			ct->running = 0;
 			return ct->req->state;
@@ -346,6 +349,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 		get_monotonic_time(&ct->endtime);
 		ct->endtime.tv_nsec += 1000 * 1000;
 		normalize_timespec(&ct->endtime);
+		ct->checked_state = false;
 	}
 	ct->running++;
 	if (!sync)
@@ -386,6 +390,13 @@ static void set_msgid(struct checker *c, int state)
 	}
 }
 
+bool libcheck_need_wait(struct checker *c)
+{
+	struct directio_context *ct = (struct directio_context *)c->context;
+	return (ct && ct->running && ct->req->state == PATH_PENDING &&
+		!ct->checked_state);
+}
+
 int libcheck_pending(struct checker *c)
 {
 	int rc;
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 81db565b..f7e6a483 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -59,6 +59,7 @@ struct tur_checker_context {
 	struct checker_context ctx;
 	unsigned int nr_timeouts;
 	struct timespec endtime;
+	bool checked_state;
 };
 
 int libcheck_init (struct checker * c)
@@ -351,9 +352,17 @@ int check_pending(struct checker *c)
 		ct->thread = 0;
 	}
 
+	ct->checked_state = true;
 	return tur_status;
 }
 
+bool libcheck_need_wait(struct checker *c)
+{
+	struct tur_checker_context *ct = c->context;
+	return (ct && ct->thread && uatomic_read(&ct->running) != 0 &&
+		!ct->checked_state);
+}
+
 int libcheck_pending(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
@@ -381,6 +390,7 @@ int libcheck_check(struct checker * c)
 	 * Async mode
 	 */
 	if (ct->thread) {
+		ct->checked_state = true;
 		if (tur_check_async_timeout(c)) {
 			int running = uatomic_xchg(&ct->running, 0);
 			if (running) {
@@ -463,6 +473,7 @@ int libcheck_check(struct checker * c)
 		pthread_mutex_unlock(&ct->lock);
 		ct->fd = c->fd;
 		ct->timeout = c->timeout;
+		ct->checked_state = false;
 		uatomic_add(&ct->holders, 1);
 		uatomic_set(&ct->running, 1);
 		tur_set_async_timeout(c);
-- 
2.45.0

