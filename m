Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7031CD2C
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436535; cv=none; b=AgJXP/EQfO9L6Itr2eS61ATJhg5Oy3Yg8GIaLpDHaL9oWrs1DDwYmeZCVBdR6fLgsUeCDLAt7mR20xHlS3HROp59vnHvVqDZvq3N/t+q7/DMfVnW6LIxDWeZ+rNaApO+KQuUgsO3ah4JescWgbZr1/LzjeQBMxz14JoL+B1AFeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436535; c=relaxed/simple;
	bh=9gf0xS5uvMboH734GTPPdJpFwAl6aDwk3bX/llWFMFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eobB1dejeGZI3l80SROoZBZjaAJEphOQ0mQ7H/52eltUWvySlIrNJzDtPNgKd1BfBZHrhm+H9ZOivZj0s/f8tE4LAwXg7Kjw9RmDdMGXyrHqUKCpREbfJFxQtM5hB3cB7kNHaJ6NP1q2v6Ml9rEOxveHtvzGWrkgwxnTT3QU+HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MaCjxWP3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MaCjxWP3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pAoNay9S+X0hEUCnIb37okRQ6By4AndDEubmxEliNU=;
	b=MaCjxWP3AmLJ8MFOAoz4JGxRX5/3UAN8nMD+/JS9abQHvvH/cuyOAk0aCoFEANcYjOvCaF
	oDg1wkdBcvWLV1bR0KAqAQsb088Fkvn03H3EAKQEsvEY+FzhZkQ1jy0hA1kCdzohtJT22K
	zX7KBWgx0By4PKLGowoXmjfU0bcyErA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-XbmLBmQbPvyXPA3AKDetHQ-1; Tue,
 08 Oct 2024 21:15:27 -0400
X-MC-Unique: XbmLBmQbPvyXPA3AKDetHQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46B361955EA8;
	Wed,  9 Oct 2024 01:15:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03B5E1956086;
	Wed,  9 Oct 2024 01:15:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FOga2381624
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FOJ52381623;
	Tue, 8 Oct 2024 21:15:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 04/22] libmultipath: remove pending wait code from libcheck_check calls
Date: Tue,  8 Oct 2024 21:15:05 -0400
Message-ID: <20241009011523.2381575-5-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
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

When the tur and directio checkers start an asynchronous checker, they
now immediately return with the path in PATH_PENDING, instead of
waiting in checker_check(). Instead the wait now happens in
checker_get_state().

Additionally, the directio checker now waits for 1 ms, like the tur
checker does. Also like the tur checker it now only waits once. If it
is still pending after the first call to checker_get_state(). It will
not wait at all on future calls, and will just process the already
completed IOs.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c          |  7 +++-
 libmultipath/checkers/directio.c | 57 +++++++++++++++++---------------
 libmultipath/checkers/tur.c      | 13 +++-----
 3 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 298aec78..ce3e48bd 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -303,7 +303,12 @@ void checker_put (struct checker * dst)
 
 int checker_get_state(struct checker *c)
 {
-	return c ? c->path_state : PATH_UNCHECKED;
+	if (!c || !c->cls)
+		return PATH_UNCHECKED;
+	if (c->path_state != PATH_PENDING || !c->cls->pending)
+		return c->path_state;
+	c->path_state = c->cls->pending(c);
+	return c->path_state;
 }
 
 void checker_check (struct checker * c, int path_state)
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 3f88b40d..904e3071 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -60,10 +60,11 @@ const char *libcheck_msgtable[] = {
 #define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt, ##args)
 
 struct directio_context {
-	int		running;
+	unsigned int	running;
 	int		reset_flags;
 	struct aio_group *aio_grp;
 	struct async_req *req;
+	struct timespec endtime;
 };
 
 static struct aio_group *
@@ -314,19 +315,16 @@ check_pending(struct directio_context *ct, struct timespec endtime)
 static int
 check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 {
-	struct timespec	timeout = { .tv_nsec = 1000 };
 	struct stat	sb;
 	int		rc;
+	struct io_event event;
 	struct timespec endtime;
 
 	if (fstat(fd, &sb) == 0) {
 		LOG(4, "called for %x", (unsigned) sb.st_rdev);
 	}
-	if (sync > 0) {
+	if (sync > 0)
 		LOG(4, "called in synchronous mode");
-		timeout.tv_sec  = timeout_secs;
-		timeout.tv_nsec = 0;
-	}
 
 	if (ct->running) {
 		if (ct->req->state != PATH_PENDING) {
@@ -345,31 +343,26 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 			LOG(3, "io_submit error %i", -rc);
 			return PATH_UNCHECKED;
 		}
+		get_monotonic_time(&ct->endtime);
+		ct->endtime.tv_nsec += 1000 * 1000;
+		normalize_timespec(&ct->endtime);
 	}
 	ct->running++;
+	if (!sync)
+		return PATH_PENDING;
 
 	get_monotonic_time(&endtime);
-	endtime.tv_sec += timeout.tv_sec;
-	endtime.tv_nsec += timeout.tv_nsec;
+	endtime.tv_sec += timeout_secs;
 	normalize_timespec(&endtime);
 
 	check_pending(ct, endtime);
 	if (ct->req->state != PATH_PENDING)
 		return ct->req->state;
 
-	if (ct->running > timeout_secs || sync) {
-		struct io_event event;
-
-		LOG(3, "abort check on timeout");
-
-		io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
-		rc = PATH_DOWN;
-	} else {
-		LOG(4, "async io pending");
-		rc = PATH_PENDING;
-	}
+	LOG(3, "abort check on timeout");
 
-	return rc;
+	io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
+	return PATH_DOWN;
 }
 
 static void set_msgid(struct checker *c, int state)
@@ -395,21 +388,31 @@ static void set_msgid(struct checker *c, int state)
 
 int libcheck_pending(struct checker *c)
 {
-	struct timespec endtime;
+	int rc;
+	struct io_event event;
 	struct directio_context *ct = (struct directio_context *)c->context;
 
 	/* The if path checker isn't running, just return the exiting value. */
 	if (!ct || !ct->running)
 		return c->path_state;
 
-	if (ct->req->state == PATH_PENDING) {
-		get_monotonic_time(&endtime);
-		check_pending(ct, endtime);
-	} else
+	if (ct->req->state == PATH_PENDING)
+		check_pending(ct, ct->endtime);
+	else
 		ct->running = 0;
-	set_msgid(c, ct->req->state);
+	rc = ct->req->state;
+	if (rc == PATH_PENDING) {
+		if (ct->running > c->timeout) {
+			LOG(3, "abort check on timeout");
+			io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
+			rc = PATH_DOWN;
+		}
+		else
+			LOG(4, "async io pending");
+	}
+	set_msgid(c, rc);
 
-	return ct->req->state;
+	return rc;
 }
 
 int libcheck_check (struct checker * c)
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 95af5214..81db565b 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -58,6 +58,7 @@ struct tur_checker_context {
 	int msgid;
 	struct checker_context ctx;
 	unsigned int nr_timeouts;
+	struct timespec endtime;
 };
 
 int libcheck_init (struct checker * c)
@@ -323,7 +324,7 @@ static int tur_check_async_timeout(struct checker *c)
 	return (now.tv_sec > ct->time);
 }
 
-int check_pending(struct checker *c, struct timespec endtime)
+int check_pending(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
 	int r, tur_status = PATH_PENDING;
@@ -333,7 +334,7 @@ int check_pending(struct checker *c, struct timespec endtime)
 	for (r = 0;
 	     r == 0 && ct->state == PATH_PENDING &&
 	     ct->msgid == MSG_TUR_RUNNING;
-	     r = pthread_cond_timedwait(&ct->active, &ct->lock, &endtime));
+	     r = pthread_cond_timedwait(&ct->active, &ct->lock, &ct->endtime));
 
 	if (!r) {
 		tur_status = ct->state;
@@ -355,21 +356,18 @@ int check_pending(struct checker *c, struct timespec endtime)
 
 int libcheck_pending(struct checker *c)
 {
-	struct timespec endtime;
 	struct tur_checker_context *ct = c->context;
 
 	/* The if path checker isn't running, just return the exiting value. */
 	if (!ct || !ct->thread)
 		return c->path_state;
 
-	get_monotonic_time(&endtime);
-	return check_pending(c, endtime);
+	return check_pending(c);
 }
 
 int libcheck_check(struct checker * c)
 {
 	struct tur_checker_context *ct = c->context;
-	struct timespec tsp;
 	pthread_attr_t attr;
 	int tur_status, r;
 
@@ -479,8 +477,7 @@ int libcheck_check(struct checker * c)
 				" sync mode", major(ct->devt), minor(ct->devt));
 			return tur_check(c->fd, c->timeout, &c->msgid);
 		}
-		tur_timeout(&tsp);
-		tur_status = check_pending(c, tsp);
+		tur_timeout(&ct->endtime);
 	}
 
 	return tur_status;
-- 
2.45.0

