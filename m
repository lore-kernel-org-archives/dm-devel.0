Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865311A08C0
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883485; cv=none; b=DQIGO39/tapG6rZZ3JauOOujjhn/eGvTHDMFQshWoJIrqcrAVEO+Ii8M/C9Gm9t19M70n5LideHVYlyXZEFA/TW9Mg4H647qsPACIRJ+bgNtVLx7XSvgN7pS0XNaAF3pIAg75Tn5zi23Vf2/M63hxP9XKNyz60ODKZZ5oA6A9N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883485; c=relaxed/simple;
	bh=ng99bfcce39amTOxcaJwlFh76bO+zSgzU41gYyYDXwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSJS02ft115Frgr1vkTwFZPYM8Vlc7D3jyqY3lPyC4rVFWJu5DNtQIth33dY7HX3SVYlKk6SgLQzPRO4qMuZr/bcmVJnlDPRvvhbb0TUHdAnwQ36IwPBkG5va+r9grh0DsxZvsfKFvQ+LI9f4ascuBRV2P+rM4twfwXJbU3UeLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDQokyiQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDQokyiQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxNaIn5VkIePhHNDe8xgYfw78m7m13x7pNhaIlUSMtY=;
	b=HDQokyiQ6NIH0Kt5KDOReQSZOPTRJ4HjZT2b+cA9425bCHcucCFto274BnCYw8oljbkT7t
	GNXs/arXx1DkuFZnJCGmS9c5IFsyUKtjU6ri3BMmS+G8+zofuuZrmrgRhbxxZrEom9rB7U
	FIjUawgvJez2WMsq6keRPI10EXzyj2U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-4wiJtemqPFeHSLcEOoLIMQ-1; Wed,
 28 Aug 2024 18:18:01 -0400
X-MC-Unique: 4wiJtemqPFeHSLcEOoLIMQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 217BD19560A6;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5CA319560AA;
	Wed, 28 Aug 2024 22:17:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHwD54060588
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHwbB4060587;
	Wed, 28 Aug 2024 18:17:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 04/15] libmultipath: remove pending wait code from libcheck_check calls
Date: Wed, 28 Aug 2024 18:17:46 -0400
Message-ID: <20240828221757.4060548-5-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
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

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c          |  7 +++-
 libmultipath/checkers/directio.c | 57 +++++++++++++++++---------------
 libmultipath/checkers/tur.c      | 13 +++-----
 3 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 298aec78..b44b856a 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -303,7 +303,12 @@ void checker_put (struct checker * dst)
 
 int checker_get_state(struct checker *c)
 {
-	return c ? c->path_state : PATH_UNCHECKED;
+	if (!c)
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

