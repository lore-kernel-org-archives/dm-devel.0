Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E152F9E
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 02:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775467; cv=none; b=dicgvS92uQBXDPzW73XFNyleeL8q6Lsh2wOmrHXG67u7c9f7/Pd9JG17A0UflzFDw/0US2B8o9UBrsw3YCX0yfk1Lkl7mYNKSBCW2uhmt2f6uqDZyVH1Mt1YZvXbtYuUBmTRwGQ2XTFglToIOz8n8TiQZyrrUvozQQmY+nHxFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775467; c=relaxed/simple;
	bh=fxC23B3anVytNAqVzEWwW84/Q46Gbk2PC7r5zmSNwlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PwQsIMNtxhqhO47kSiAAnt2DLI4hD+YbnHELNnkw8BEDEsTJkNSvghyyVEAd91ixPJzzHkwu39/mPwhFsPogrLCu7J7Rlk3p2YttdGFWJeFfCT+m+iIOP0YOqClZ4fwJgusfViS0Tqn5sEfYwUyopVoA0mJIQArf0Yd7lRjI5xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U+oRV6/T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U+oRV6/T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730775463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bx8OMZ70xvRJY8G5lDJp+FEMakM5ECaKLNPopZc4xXo=;
	b=U+oRV6/TdERdKcFx1I8bqgvapwYmOUpVntpNPBNnPe4CjWJNGL0kMSQVMrTnn+98YKlQGw
	uD2Lw5/Haj5mEYlbO9Oc+7hYkhiv4CopSYerQIkFEUaIeInF0LGU/JJJrObQvJIbYlJ6QY
	92i9cZIMV1HIjLKV63Y/JpvH9uM5FUM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-vGXTUfewNW-FXLJqDfE4-w-1; Mon,
 04 Nov 2024 21:57:42 -0500
X-MC-Unique: vGXTUfewNW-FXLJqDfE4-w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9C2A1955F41;
	Tue,  5 Nov 2024 02:57:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24E2819560AD;
	Tue,  5 Nov 2024 02:57:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A52vdpQ450458
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 4 Nov 2024 21:57:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A52vdL1450457;
	Mon, 4 Nov 2024 21:57:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2] multipathd: use timestamps to tell when the directio checker timed out
Date: Mon,  4 Nov 2024 21:57:39 -0500
Message-ID: <20241105025739.450449-1-bmarzins@redhat.com>
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

Instead of counting the number of times the path checker has been
called and treating that as the number of seconds that have passed,
calculate the actual timestamp when the checker will time out, and
check that instead.

Suggested-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes in V2 (as suggested by Martin Wilck):
Switch from tracking the timeout with time_t to struct timespec, to
to keep timeouts from being late by up to a second.

 libmultipath/checkers/directio.c | 42 ++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 27227894..a7422a87 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -60,13 +60,26 @@ const char *libcheck_msgtable[] = {
 #define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt, ##args)
 
 struct directio_context {
-	unsigned int	running;
-	int		reset_flags;
+	struct timespec timeout;
+	int reset_flags;
 	struct aio_group *aio_grp;
 	struct async_req *req;
 	bool checked_state;
 };
 
+static bool is_running(struct directio_context *ct) {
+	return (ct->timeout.tv_sec != 0 || ct->timeout.tv_nsec != 0);
+}
+
+static void start_running(struct directio_context *ct, int timeout_secs) {
+	get_monotonic_time(&ct->timeout);
+	ct->timeout.tv_sec += timeout_secs;
+}
+
+static void stop_running(struct directio_context *ct) {
+	ct->timeout.tv_sec = ct->timeout.tv_nsec = 0;
+}
+
 static struct aio_group *
 add_aio_group(void)
 {
@@ -234,9 +247,9 @@ void libcheck_free (struct checker * c)
 		}
 	}
 
-	if (ct->running && ct->req->state != PATH_PENDING)
-		ct->running = 0;
-	if (!ct->running) {
+	if (is_running(ct) && ct->req->state != PATH_PENDING)
+		stop_running(ct);
+	if (!is_running(ct)) {
 		free(ct->req->buf);
 		free(ct->req);
 		ct->aio_grp->holders--;
@@ -304,7 +317,7 @@ check_pending(struct directio_context *ct, struct timespec timeout)
 		r = get_events(ct->aio_grp, &timeout);
 
 		if (ct->req->state != PATH_PENDING) {
-			ct->running = 0;
+			stop_running(ct);
 			return;
 		} else if (r == 0 ||
 			   (timeout.tv_sec == 0 && timeout.tv_nsec == 0))
@@ -330,10 +343,10 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	if (sync > 0)
 		LOG(4, "called in synchronous mode");
 
-	if (ct->running) {
+	if (is_running(ct)) {
 		ct->checked_state = true;
 		if (ct->req->state != PATH_PENDING) {
-			ct->running = 0;
+			stop_running(ct);
 			return ct->req->state;
 		}
 	} else {
@@ -348,9 +361,9 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 			LOG(3, "io_submit error %i", -rc);
 			return PATH_UNCHECKED;
 		}
+		start_running(ct, timeout_secs);
 		ct->checked_state = false;
 	}
-	ct->running++;
 	if (!sync)
 		return PATH_PENDING;
 
@@ -388,7 +401,7 @@ static void set_msgid(struct checker *c, int state)
 bool libcheck_need_wait(struct checker *c)
 {
 	struct directio_context *ct = (struct directio_context *)c->context;
-	return (ct && ct->running && ct->req->state == PATH_PENDING &&
+	return (ct && is_running(ct) && ct->req->state == PATH_PENDING &&
 		!ct->checked_state);
 }
 
@@ -400,7 +413,7 @@ int libcheck_pending(struct checker *c)
 	struct timespec no_wait = { .tv_sec = 0 };
 
 	/* The if path checker isn't running, just return the exiting value. */
-	if (!ct || !ct->running) {
+	if (!ct || !is_running(ct)) {
 		rc = c->path_state;
 		goto out;
 	}
@@ -408,10 +421,13 @@ int libcheck_pending(struct checker *c)
 	if (ct->req->state == PATH_PENDING)
 		check_pending(ct, no_wait);
 	else
-		ct->running = 0;
+		stop_running(ct);
 	rc = ct->req->state;
 	if (rc == PATH_PENDING) {
-		if (ct->running > c->timeout) {
+		struct timespec now;
+
+		get_monotonic_time(&now);
+		if (timespeccmp(&now, &ct->timeout) > 0) {
 			LOG(3, "abort check on timeout");
 			io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
 			rc = PATH_DOWN;
-- 
2.46.2

