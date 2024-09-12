Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87231C233E
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177797; cv=none; b=lJQG8Itchrz0nmueiHQVrt/ebexfJkxLGpyCntlT1FeIWr5wDAbZ/TDC4r2j/36UiP94PERtukbKpJhsy8ToxLX3t8QEOzraLN6VCgSSNKsy1WPlm/JODwA0vZgr0Sxkax4KK3SA7d3+r4M0hdTfzfxI2jMQ2z0LaCFvfU6c6bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177797; c=relaxed/simple;
	bh=LigvlYlkSVSBcyEuvhiP082jSwuwz6D06YhkSkrLlBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JH3wzN4l68imkNgDXpICyjBRGuww50HWby+7uhJ84qh6QwpajNoF4sCU5sQTTBD6SOMB/d0XNrXJvKMhKNxqerZuSTOkk6lOLD5qPuLSf14RP+99QNLNjO+CWCdGEBvEUWjyFTwCnQzAsDIIL5uuvPI42KuFPAB+6ntSaWEDRpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LEfy2mER; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEfy2mER"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mDcvK52Xq8n7eJMs62ES4ylrn4J1JrMbQyAQBEQ7HQ=;
	b=LEfy2mERv4pIihPsvCFmRPHq9MsTQbjnAqdMfndrR+DXxns6q2e4Ny0O0Z0bDsjp0DZlTj
	02GdyiwpYL2kIt6Ixxd9MgpnoS9gRe3qGfCmkzIihhpIEQhkxcK9OTN+8ltqd5T7xaZIUX
	f0qCDnsUVU9gCl4cJJmkI6lfRXVOgi0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-uNZ4z4AtOK6KpG8HAXqCMA-1; Thu,
 12 Sep 2024 17:49:51 -0400
X-MC-Unique: uNZ4z4AtOK6KpG8HAXqCMA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C852319560AE;
	Thu, 12 Sep 2024 21:49:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A171195609F;
	Thu, 12 Sep 2024 21:49:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnm8Q783862
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnm4u783861;
	Thu, 12 Sep 2024 17:49:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 03/22] libmultipath: split out the code to wait for pending checkers
Date: Thu, 12 Sep 2024 17:49:28 -0400
Message-ID: <20240912214947.783819-4-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patch adds a new optional symbol for the dynamic path checker
libraries, libcheck_pending. This is currently unused, but can be called
on pending checkers to check if they've completed and return their value.
The "tur" and "directio" checkers are the only ones which can return
PATH_PENDING. They now implement libcheck_pending() as a wrapper around
the code that libcheck_check uses to wait for pending paths, which has
been broken out into its own function.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c          |  4 +-
 libmultipath/checkers.h          |  1 +
 libmultipath/checkers/directio.c | 86 ++++++++++++++++++++++----------
 libmultipath/checkers/tur.c      | 65 ++++++++++++++++--------
 4 files changed, 109 insertions(+), 47 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index c4918d28..298aec78 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -26,6 +26,7 @@ struct checker_class {
 	void (*free)(struct checker *);      /* to free the context */
 	void (*reset)(void);		     /* to reset the global variables */
 	void *(*thread)(void *);	     /* async thread entry point */
+	int (*pending)(struct checker *);    /* to recheck pending paths */
 	const char **msgtable;
 	short msgtable_size;
 };
@@ -180,7 +181,8 @@ static struct checker_class *add_checker_class(const char *name)
 	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
 	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
 	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
-	/* These 3 functions can be NULL. call dlerror() to clear out any
+	c->pending = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_pending");
+	/* These 4 functions can be NULL. call dlerror() to clear out any
 	 * error string */
 	dlerror();
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index fb1160af..b2342a1b 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -190,6 +190,7 @@ void libcheck_free(struct checker *);
 void *libcheck_thread(struct checker_context *ctx);
 void libcheck_reset(void);
 int libcheck_mp_init(struct checker *);
+int libcheck_pending(struct checker *c);
 
 
 /*
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 8e87878b..3f88b40d 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -288,14 +288,36 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 	return got_events;
 }
 
+static void
+check_pending(struct directio_context *ct, struct timespec endtime)
+{
+	int r;
+	struct timespec currtime, timeout;
+
+	while(1) {
+		get_monotonic_time(&currtime);
+		timespecsub(&endtime, &currtime, &timeout);
+		if (timeout.tv_sec < 0)
+			timeout.tv_sec = timeout.tv_nsec = 0;
+
+		r = get_events(ct->aio_grp, &timeout);
+
+		if (ct->req->state != PATH_PENDING) {
+			ct->running = 0;
+			return;
+		} else if (r == 0 ||
+			   (timeout.tv_sec == 0 && timeout.tv_nsec == 0))
+			return;
+	}
+}
+
 static int
 check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 {
 	struct timespec	timeout = { .tv_nsec = 1000 };
 	struct stat	sb;
 	int		rc;
-	long		r;
-	struct timespec currtime, endtime;
+	struct timespec endtime;
 
 	if (fstat(fd, &sb) == 0) {
 		LOG(4, "called for %x", (unsigned) sb.st_rdev);
@@ -330,21 +352,11 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	endtime.tv_sec += timeout.tv_sec;
 	endtime.tv_nsec += timeout.tv_nsec;
 	normalize_timespec(&endtime);
-	while(1) {
-		r = get_events(ct->aio_grp, &timeout);
 
-		if (ct->req->state != PATH_PENDING) {
-			ct->running = 0;
-			return ct->req->state;
-		} else if (r == 0 ||
-			   (timeout.tv_sec == 0 && timeout.tv_nsec == 0))
-			break;
+	check_pending(ct, endtime);
+	if (ct->req->state != PATH_PENDING)
+		return ct->req->state;
 
-		get_monotonic_time(&currtime);
-		timespecsub(&endtime, &currtime, &timeout);
-		if (timeout.tv_sec < 0)
-			timeout.tv_sec = timeout.tv_nsec = 0;
-	}
 	if (ct->running > timeout_secs || sync) {
 		struct io_event event;
 
@@ -360,17 +372,9 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	return rc;
 }
 
-int libcheck_check (struct checker * c)
+static void set_msgid(struct checker *c, int state)
 {
-	int ret;
-	struct directio_context * ct = (struct directio_context *)c->context;
-
-	if (!ct)
-		return PATH_UNCHECKED;
-
-	ret = check_state(c->fd, ct, checker_is_sync(c), c->timeout);
-
-	switch (ret)
+	switch (state)
 	{
 	case PATH_UNCHECKED:
 		c->msgid = MSG_DIRECTIO_UNKNOWN;
@@ -387,5 +391,37 @@ int libcheck_check (struct checker * c)
 	default:
 		break;
 	}
+}
+
+int libcheck_pending(struct checker *c)
+{
+	struct timespec endtime;
+	struct directio_context *ct = (struct directio_context *)c->context;
+
+	/* The if path checker isn't running, just return the exiting value. */
+	if (!ct || !ct->running)
+		return c->path_state;
+
+	if (ct->req->state == PATH_PENDING) {
+		get_monotonic_time(&endtime);
+		check_pending(ct, endtime);
+	} else
+		ct->running = 0;
+	set_msgid(c, ct->req->state);
+
+	return ct->req->state;
+}
+
+int libcheck_check (struct checker * c)
+{
+	int ret;
+	struct directio_context * ct = (struct directio_context *)c->context;
+
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	ret = check_state(c->fd, ct, checker_is_sync(c), c->timeout);
+	set_msgid(c, ret);
+
 	return ret;
 }
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index a2905af5..95af5214 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -323,6 +323,49 @@ static int tur_check_async_timeout(struct checker *c)
 	return (now.tv_sec > ct->time);
 }
 
+int check_pending(struct checker *c, struct timespec endtime)
+{
+	struct tur_checker_context *ct = c->context;
+	int r, tur_status = PATH_PENDING;
+
+	pthread_mutex_lock(&ct->lock);
+
+	for (r = 0;
+	     r == 0 && ct->state == PATH_PENDING &&
+	     ct->msgid == MSG_TUR_RUNNING;
+	     r = pthread_cond_timedwait(&ct->active, &ct->lock, &endtime));
+
+	if (!r) {
+		tur_status = ct->state;
+		c->msgid = ct->msgid;
+	}
+	pthread_mutex_unlock(&ct->lock);
+	if (tur_status == PATH_PENDING && c->msgid == MSG_TUR_RUNNING) {
+		condlog(4, "%d:%d : tur checker still running",
+			major(ct->devt), minor(ct->devt));
+	} else {
+		int running = uatomic_xchg(&ct->running, 0);
+		if (running)
+			pthread_cancel(ct->thread);
+		ct->thread = 0;
+	}
+
+	return tur_status;
+}
+
+int libcheck_pending(struct checker *c)
+{
+	struct timespec endtime;
+	struct tur_checker_context *ct = c->context;
+
+	/* The if path checker isn't running, just return the exiting value. */
+	if (!ct || !ct->thread)
+		return c->path_state;
+
+	get_monotonic_time(&endtime);
+	return check_pending(c, endtime);
+}
+
 int libcheck_check(struct checker * c)
 {
 	struct tur_checker_context *ct = c->context;
@@ -437,27 +480,7 @@ int libcheck_check(struct checker * c)
 			return tur_check(c->fd, c->timeout, &c->msgid);
 		}
 		tur_timeout(&tsp);
-		pthread_mutex_lock(&ct->lock);
-
-		for (r = 0;
-		     r == 0 && ct->state == PATH_PENDING &&
-			     ct->msgid == MSG_TUR_RUNNING;
-		     r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp));
-
-		if (!r) {
-			tur_status = ct->state;
-			c->msgid = ct->msgid;
-		}
-		pthread_mutex_unlock(&ct->lock);
-		if (tur_status == PATH_PENDING && c->msgid == MSG_TUR_RUNNING) {
-			condlog(4, "%d:%d : tur checker still running",
-				major(ct->devt), minor(ct->devt));
-		} else {
-			int running = uatomic_xchg(&ct->running, 0);
-			if (running)
-				pthread_cancel(ct->thread);
-			ct->thread = 0;
-		}
+		tur_status = check_pending(c, tsp);
 	}
 
 	return tur_status;
-- 
2.45.0

