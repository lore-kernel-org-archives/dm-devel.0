Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319A1C2DB2
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177799; cv=none; b=svbZvfEEe/ZltBpBY2DNw9jeUixt4SmvPQxhBXKL+PxzWJm17b0933uwv+iF38dgokq6dnNrUXsAkkGBrcBqi8tMv9IbzK9HCnUuyJkQmAmci3Z414odZYvPK8MItDh4OsGGcNg2HQu5GQWTl0U4188GdVtoyUluMT8jesIuMQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177799; c=relaxed/simple;
	bh=5u4/KUW+laLDyJO8EzbRtEhOGuG324koA5N5mRCRZN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qf6oNXSouju3DTurNaWYSQSnqhPeQPqN254fb+lpTeM4Cu48kBKNuOoKRlJ4ja2lV4G0y7HKICX86xFyt7SwX9juP0gad6SzWp6+0Pea0/BBDlyEyfxv+7V1Y+qzmeKl6E2W1Zwj+l6OtllZbFajC+aAVgYmIRWiSR5pn7lApLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4+tmy4c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4+tmy4c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USiiU9JpSKW+zG6EGxO1TfKUrW0299kTdQakFJmuFw0=;
	b=F4+tmy4cZjEb4vJFifh6M5FhSZajQExMhC1jbSJ2ZTCIvLwHnUgvsgCkQfVdqk0sbefeqp
	nU73fssyNkuQGuA4ftiBCMd17mGOkWHShe8jPCYUnQ93854/YE55VmP4RPTsVSjwnSMIJi
	9jS8lTxTnQmtPxJaQ5Cex1AyQweKSUw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317--g7JCOhlO7mP4lmxZZFMyQ-1; Thu,
 12 Sep 2024 17:49:54 -0400
X-MC-Unique: -g7JCOhlO7mP4lmxZZFMyQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8279819560AE;
	Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 401303001D17;
	Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnpnI783944
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnpZK783943;
	Thu, 12 Sep 2024 17:49:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 20/22] libmultipath: don't wait in libcheck_pending
Date: Thu, 12 Sep 2024 17:49:45 -0400
Message-ID: <20240912214947.783819-21-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Disable waiting in the libcheck_pending() checker class functions.
Instead, they now just check if the checker has already completed.
A future patch will re-add waiting outside of libcheck_pending().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/directio.c | 41 ++++++++++++++++----------------
 libmultipath/checkers/tur.c      | 20 +++-------------
 2 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 4beed02e..f37b0d39 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -64,7 +64,6 @@ struct directio_context {
 	int		reset_flags;
 	struct aio_group *aio_grp;
 	struct async_req *req;
-	struct timespec endtime;
 	bool waited_for;
 };
 
@@ -291,18 +290,17 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 }
 
 static void
-check_pending(struct directio_context *ct, struct timespec endtime)
+check_pending(struct directio_context *ct, struct timespec timeout)
 {
 	int r;
-	struct timespec currtime, timeout;
+	struct timespec endtime, currtime;
 
 	ct->waited_for = true;
+	get_monotonic_time(&endtime);
+	endtime.tv_sec += timeout.tv_sec;
+	endtime.tv_nsec += timeout.tv_nsec;
+	normalize_timespec(&endtime);
 	while(1) {
-		get_monotonic_time(&currtime);
-		timespecsub(&endtime, &currtime, &timeout);
-		if (timeout.tv_sec < 0)
-			timeout.tv_sec = timeout.tv_nsec = 0;
-
 		r = get_events(ct->aio_grp, &timeout);
 
 		if (ct->req->state != PATH_PENDING) {
@@ -311,6 +309,10 @@ check_pending(struct directio_context *ct, struct timespec endtime)
 		} else if (r == 0 ||
 			   (timeout.tv_sec == 0 && timeout.tv_nsec == 0))
 			return;
+		get_monotonic_time(&currtime);
+		timespecsub(&endtime, &currtime, &timeout);
+		if (timeout.tv_sec < 0)
+			timeout.tv_sec = timeout.tv_nsec = 0;
 	}
 }
 
@@ -320,7 +322,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	struct stat	sb;
 	int		rc;
 	struct io_event event;
-	struct timespec endtime;
+	struct timespec timeout = { .tv_sec = timeout_secs };
 
 	if (fstat(fd, &sb) == 0) {
 		LOG(4, "called for %x", (unsigned) sb.st_rdev);
@@ -345,20 +347,13 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 			LOG(3, "io_submit error %i", -rc);
 			return PATH_UNCHECKED;
 		}
-		get_monotonic_time(&ct->endtime);
-		ct->endtime.tv_nsec += 1000 * 1000;
-		normalize_timespec(&ct->endtime);
 		ct->waited_for = false;
 	}
 	ct->running++;
 	if (!sync)
 		return PATH_PENDING;
 
-	get_monotonic_time(&endtime);
-	endtime.tv_sec += timeout_secs;
-	normalize_timespec(&endtime);
-
-	check_pending(ct, endtime);
+	check_pending(ct, timeout);
 	if (ct->req->state != PATH_PENDING)
 		return ct->req->state;
 
@@ -401,13 +396,16 @@ int libcheck_pending(struct checker *c)
 	int rc;
 	struct io_event event;
 	struct directio_context *ct = (struct directio_context *)c->context;
+	struct timespec no_wait = { .tv_sec = 0 };
 
 	/* The if path checker isn't running, just return the exiting value. */
-	if (!ct || !ct->running)
-		return c->path_state;
+	if (!ct || !ct->running) {
+		rc = c->path_state;
+		goto out;
+	}
 
 	if (ct->req->state == PATH_PENDING)
-		check_pending(ct, ct->endtime);
+		check_pending(ct, no_wait);
 	else
 		ct->running = 0;
 	rc = ct->req->state;
@@ -420,8 +418,9 @@ int libcheck_pending(struct checker *c)
 		else
 			LOG(4, "async io pending");
 	}
-	set_msgid(c, rc);
 
+out:
+	set_msgid(c, rc);
 	return rc;
 }
 
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 41d6b9c3..5d606708 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -58,7 +58,6 @@ struct tur_checker_context {
 	int msgid;
 	struct checker_context ctx;
 	unsigned int nr_timeouts;
-	struct timespec endtime;
 	bool waited_for;
 };
 
@@ -299,14 +298,6 @@ void *libcheck_thread(struct checker_context *ctx)
 	return ((void *)0);
 }
 
-
-static void tur_timeout(struct timespec *tsp)
-{
-	get_monotonic_time(tsp);
-	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
-	normalize_timespec(tsp);
-}
-
 static void tur_set_async_timeout(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
@@ -328,16 +319,12 @@ static int tur_check_async_timeout(struct checker *c)
 int check_pending(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
-	int r, tur_status = PATH_PENDING;
+	int tur_status = PATH_PENDING;
 
 	pthread_mutex_lock(&ct->lock);
 
-	for (r = 0;
-	     r == 0 && ct->state == PATH_PENDING &&
-	     ct->msgid == MSG_TUR_RUNNING;
-	     r = pthread_cond_timedwait(&ct->active, &ct->lock, &ct->endtime));
-
-	if (!r) {
+	if (ct->state != PATH_PENDING || ct->msgid != MSG_TUR_RUNNING)
+	{
 		tur_status = ct->state;
 		c->msgid = ct->msgid;
 	}
@@ -487,7 +474,6 @@ int libcheck_check(struct checker * c)
 				" sync mode", major(ct->devt), minor(ct->devt));
 			return tur_check(c->fd, c->timeout, &c->msgid);
 		}
-		tur_timeout(&ct->endtime);
 	}
 
 	return tur_status;
-- 
2.45.0

