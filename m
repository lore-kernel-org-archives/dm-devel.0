Return-Path: <SRS0=y4zT=GP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7F1C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 23:53:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5BA6B23135
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 23:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BA6B23135
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610495605;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SDNcN8uS/I/n+qqTdw8OUTrj5hwWOl/o/6qESPX4ON0=;
	b=LJrBlKlrvYkWdwnpXY7BecE1x83IZppFun0qqu7A/SNUMOu1pkrqePsdubXMFC5qaaapsN
	lmmKD07NbIkJuFYtHMF33wOPj7v8tX6OSgVy1U33hG8neuGSnvoATLGvP2Dzuco+5iEXA8
	knWg2phjMasrMOdzZ1SP1fpWR/QOw2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-gmxv-JBuM6W4r9M3nyRjbw-1; Tue, 12 Jan 2021 18:53:23 -0500
X-MC-Unique: gmxv-JBuM6W4r9M3nyRjbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF8BB15720;
	Tue, 12 Jan 2021 23:53:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C30A56F971;
	Tue, 12 Jan 2021 23:53:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 953E81809CA0;
	Tue, 12 Jan 2021 23:53:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10CNr5Vx026916 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 12 Jan 2021 18:53:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22FDD60C04; Tue, 12 Jan 2021 23:53:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACCA560BFA;
	Tue, 12 Jan 2021 23:53:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10CNqxAS008223; 
	Tue, 12 Jan 2021 17:52:59 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10CNqwie008222;
	Tue, 12 Jan 2021 17:52:58 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 12 Jan 2021 17:52:54 -0600
Message-Id: <1610495575-8177-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
References: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] multipathd: avoid io_err_stat crash during
	shutdown
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The checker thread is reponsible for enqueueing paths for the
io_err_stat thread to check. During shutdown, the io_err_stat thread is
shut down and cleaned up before the checker thread.  There is no code
to make sure that the checker thread isn't accessing the io_err_stat
pathvec or its mutex while they are being freed, which can lead to
memory corruption crashes.

To solve this, get rid of the io_err_stat_pathvec structure, and
statically define the mutex.  This means that the mutex is always valid
to access, and the io_err_stat pathvec can only be accessed while
holding it.  If the io_err_stat thread has already been cleaned up
when the checker tries to access the pathvec, it will be NULL, and the
checker will simply fail to enqueue the path.

This change also fixes a bug in free_io_err_pathvec(), which previously
only attempted to free the pathvec if it was not set, instead of when it
was set.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 108 +++++++++++++++----------------------
 1 file changed, 44 insertions(+), 64 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 2e48ee81..4c6f7f08 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -46,12 +46,6 @@
 #define io_err_stat_log(prio, fmt, args...) \
 	condlog(prio, "io error statistic: " fmt, ##args)
 
-
-struct io_err_stat_pathvec {
-	pthread_mutex_t mutex;
-	vector		pathvec;
-};
-
 struct dio_ctx {
 	struct timespec	io_starttime;
 	unsigned int	blksize;
@@ -75,9 +69,10 @@ static pthread_t	io_err_stat_thr;
 
 static pthread_mutex_t io_err_thread_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t io_err_thread_cond = PTHREAD_COND_INITIALIZER;
+static pthread_mutex_t io_err_pathvec_lock = PTHREAD_MUTEX_INITIALIZER;
 static int io_err_thread_running = 0;
 
-static struct io_err_stat_pathvec *paths;
+static vector io_err_pathvec;
 struct vectors *vecs;
 io_context_t	ioctx;
 
@@ -207,46 +202,28 @@ static void free_io_err_stat_path(struct io_err_stat_path *p)
 	FREE(p);
 }
 
-static struct io_err_stat_pathvec *alloc_pathvec(void)
+static void cleanup_unlock(void *arg)
 {
-	struct io_err_stat_pathvec *p;
-	int r;
-
-	p = (struct io_err_stat_pathvec *)MALLOC(sizeof(*p));
-	if (!p)
-		return NULL;
-	p->pathvec = vector_alloc();
-	if (!p->pathvec)
-		goto out_free_struct_pathvec;
-	r = pthread_mutex_init(&p->mutex, NULL);
-	if (r)
-		goto out_free_member_pathvec;
-
-	return p;
-
-out_free_member_pathvec:
-	vector_free(p->pathvec);
-out_free_struct_pathvec:
-	FREE(p);
-	return NULL;
+	pthread_mutex_unlock((pthread_mutex_t*) arg);
 }
 
-static void free_io_err_pathvec(struct io_err_stat_pathvec *p)
+static void free_io_err_pathvec(void)
 {
 	struct io_err_stat_path *path;
 	int i;
 
-	if (!p)
-		return;
-	pthread_mutex_destroy(&p->mutex);
-	if (!p->pathvec) {
-		vector_foreach_slot(p->pathvec, path, i) {
-			destroy_directio_ctx(path);
-			free_io_err_stat_path(path);
-		}
-		vector_free(p->pathvec);
+	pthread_mutex_lock(&io_err_pathvec_lock);
+	pthread_cleanup_push(cleanup_unlock, &io_err_pathvec_lock);
+	if (!io_err_pathvec)
+		goto out;
+	vector_foreach_slot(io_err_pathvec, path, i) {
+		destroy_directio_ctx(path);
+		free_io_err_stat_path(path);
 	}
-	FREE(p);
+	vector_free(io_err_pathvec);
+	io_err_pathvec = NULL;
+out:
+	pthread_cleanup_pop(1);
 }
 
 /*
@@ -258,13 +235,13 @@ static int enqueue_io_err_stat_by_path(struct path *path)
 {
 	struct io_err_stat_path *p;
 
-	pthread_mutex_lock(&paths->mutex);
-	p = find_err_path_by_dev(paths->pathvec, path->dev);
+	pthread_mutex_lock(&io_err_pathvec_lock);
+	p = find_err_path_by_dev(io_err_pathvec, path->dev);
 	if (p) {
-		pthread_mutex_unlock(&paths->mutex);
+		pthread_mutex_unlock(&io_err_pathvec_lock);
 		return 0;
 	}
-	pthread_mutex_unlock(&paths->mutex);
+	pthread_mutex_unlock(&io_err_pathvec_lock);
 
 	p = alloc_io_err_stat_path();
 	if (!p)
@@ -276,18 +253,18 @@ static int enqueue_io_err_stat_by_path(struct path *path)
 
 	if (setup_directio_ctx(p))
 		goto free_ioerr_path;
-	pthread_mutex_lock(&paths->mutex);
-	if (!vector_alloc_slot(paths->pathvec))
+	pthread_mutex_lock(&io_err_pathvec_lock);
+	if (!vector_alloc_slot(io_err_pathvec))
 		goto unlock_destroy;
-	vector_set_slot(paths->pathvec, p);
-	pthread_mutex_unlock(&paths->mutex);
+	vector_set_slot(io_err_pathvec, p);
+	pthread_mutex_unlock(&io_err_pathvec_lock);
 
 	io_err_stat_log(2, "%s: enqueue path %s to check",
 			path->mpp->alias, path->dev);
 	return 0;
 
 unlock_destroy:
-	pthread_mutex_unlock(&paths->mutex);
+	pthread_mutex_unlock(&io_err_pathvec_lock);
 	destroy_directio_ctx(p);
 free_ioerr_path:
 	free_io_err_stat_path(p);
@@ -412,9 +389,9 @@ static int delete_io_err_stat_by_addr(struct io_err_stat_path *p)
 {
 	int i;
 
-	i = find_slot(paths->pathvec, p);
+	i = find_slot(io_err_pathvec, p);
 	if (i != -1)
-		vector_del_slot(paths->pathvec, i);
+		vector_del_slot(io_err_pathvec, i);
 
 	destroy_directio_ctx(p);
 	free_io_err_stat_path(p);
@@ -585,7 +562,7 @@ static void poll_async_io_timeout(void)
 
 	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
 		return;
-	vector_foreach_slot(paths->pathvec, pp, i) {
+	vector_foreach_slot(io_err_pathvec, pp, i) {
 		for (j = 0; j < CONCUR_NR_EVENT; j++) {
 			rc = try_to_cancel_timeout_io(pp->dio_ctx_array + j,
 					&curr_time, pp->devname);
@@ -631,7 +608,7 @@ static void handle_async_io_done_event(struct io_event *io_evt)
 	int rc = PATH_UNCHECKED;
 	int i, j;
 
-	vector_foreach_slot(paths->pathvec, pp, i) {
+	vector_foreach_slot(io_err_pathvec, pp, i) {
 		for (j = 0; j < CONCUR_NR_EVENT; j++) {
 			ct = pp->dio_ctx_array + j;
 			if (&ct->io == io_evt->obj) {
@@ -665,19 +642,14 @@ static void service_paths(void)
 	struct io_err_stat_path *pp;
 	int i;
 
-	pthread_mutex_lock(&paths->mutex);
-	vector_foreach_slot(paths->pathvec, pp, i) {
+	pthread_mutex_lock(&io_err_pathvec_lock);
+	vector_foreach_slot(io_err_pathvec, pp, i) {
 		send_batch_async_ios(pp);
 		process_async_ios_event(TIMEOUT_NO_IO_NSEC, pp->devname);
 		poll_async_io_timeout();
 		poll_io_err_stat(vecs, pp);
 	}
-	pthread_mutex_unlock(&paths->mutex);
-}
-
-static void cleanup_unlock(void *arg)
-{
-	pthread_mutex_unlock((pthread_mutex_t*) arg);
+	pthread_mutex_unlock(&io_err_pathvec_lock);
 }
 
 static void cleanup_exited(__attribute__((unused)) void *arg)
@@ -736,9 +708,14 @@ int start_io_err_stat_thread(void *data)
 		io_err_stat_log(4, "io_setup failed");
 		return 1;
 	}
-	paths = alloc_pathvec();
-	if (!paths)
+
+	pthread_mutex_lock(&io_err_pathvec_lock);
+	io_err_pathvec = vector_alloc();
+	if (!io_err_pathvec) {
+		pthread_mutex_unlock(&io_err_pathvec_lock);
 		goto destroy_ctx;
+	}
+	pthread_mutex_unlock(&io_err_pathvec_lock);
 
 	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0);
 	pthread_mutex_lock(&io_err_thread_lock);
@@ -763,7 +740,10 @@ int start_io_err_stat_thread(void *data)
 	return 0;
 
 out_free:
-	free_io_err_pathvec(paths);
+	pthread_mutex_lock(&io_err_pathvec_lock);
+	vector_free(io_err_pathvec);
+	io_err_pathvec = NULL;
+	pthread_mutex_unlock(&io_err_pathvec_lock);
 destroy_ctx:
 	io_destroy(ioctx);
 	io_err_stat_log(0, "failed to start io_error statistic thread");
@@ -779,6 +759,6 @@ void stop_io_err_stat_thread(void)
 		pthread_cancel(io_err_stat_thr);
 
 	pthread_join(io_err_stat_thr, NULL);
-	free_io_err_pathvec(paths);
+	free_io_err_pathvec();
 	io_destroy(ioctx);
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

