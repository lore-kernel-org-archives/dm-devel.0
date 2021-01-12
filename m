Return-Path: <SRS0=y4zT=GP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA47BC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 23:53:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5767B214D8
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 23:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5767B214D8
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
	bh=x6RxsmqzYCXdMMRoeNxHRDajQ2Xtq16Be9hmLxkCiTQ=;
	b=h4D9UYCsqnuGgjoRzbxJHvB1uwBcI5kxkOs6q/ACaSNqBfbHNfOg/mKHBBxCPWjvoNfX8o
	B/UwBX4AKpUFBgfg2FgWQiYJrznzcmuSJZjP2EaOp1/lHocqBwjTbrVGgmQIbQ7OZLqUZq
	Yv3rwnzF1V1oYs1rHErnHr/5dOGjYvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-YAqHRFPRPwS2m4M01qNmUw-1; Tue, 12 Jan 2021 18:53:23 -0500
X-MC-Unique: YAqHRFPRPwS2m4M01qNmUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AE231800D42;
	Tue, 12 Jan 2021 23:53:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ADFC60BFA;
	Tue, 12 Jan 2021 23:53:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1AC84180954D;
	Tue, 12 Jan 2021 23:53:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10CNr5VV026915 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 12 Jan 2021 18:53:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22DDB13470; Tue, 12 Jan 2021 23:53:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 002285B4A1;
	Tue, 12 Jan 2021 23:53:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10CNr02c008227; 
	Tue, 12 Jan 2021 17:53:00 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10CNr0uR008226;
	Tue, 12 Jan 2021 17:53:00 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 12 Jan 2021 17:52:55 -0600
Message-Id: <1610495575-8177-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
References: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] multipathd: avoid io_err_stat ABBA deadlock
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When the checker thread enqueues paths for the io_err_stat thread to
check, it calls enqueue_io_err_stat_by_path() with the vecs lock held.
start_io_err_stat_thread() is also called with the vecs lock held.
These two functions both lock io_err_pathvec_lock. When the io_err_stat
thread updates the paths in vecs->pathvec in poll_io_err_stat(), it has
the io_err_pathvec_lock held, and then locks the vecs lock. This can
cause an ABBA deadlock.

To solve this, service_paths() no longer updates the paths in
vecs->pathvec with the io_err_pathvec_lock held.  It does this by moving
the io_err_stat_path from io_err_pathvec to a local vector when it needs
to update the path. After releasing the io_err_pathvec_lock, it goes
through this temporary vector, updates the paths with the vecs lock
held, and then frees everything.

This change fixes a bug in service_paths() where elements were being
deleted from io_err_pathvec, without the index being decremented,
causing the loop to skip elements. Also, service_paths() could be
cancelled while holding the io_err_pathvec_lock, so it should have a
cleanup handler.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/io_err_stat.c | 55 +++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 4c6f7f08..a222594e 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -385,20 +385,6 @@ recover:
 	return 0;
 }
 
-static int delete_io_err_stat_by_addr(struct io_err_stat_path *p)
-{
-	int i;
-
-	i = find_slot(io_err_pathvec, p);
-	if (i != -1)
-		vector_del_slot(io_err_pathvec, i);
-
-	destroy_directio_ctx(p);
-	free_io_err_stat_path(p);
-
-	return 0;
-}
-
 static void account_async_io_state(struct io_err_stat_path *pp, int rc)
 {
 	switch (rc) {
@@ -415,17 +401,26 @@ static void account_async_io_state(struct io_err_stat_path *pp, int rc)
 	}
 }
 
-static int poll_io_err_stat(struct vectors *vecs, struct io_err_stat_path *pp)
+static int io_err_stat_time_up(struct io_err_stat_path *pp)
 {
 	struct timespec currtime, difftime;
-	struct path *path;
-	double err_rate;
 
 	if (clock_gettime(CLOCK_MONOTONIC, &currtime) != 0)
-		return 1;
+		return 0;
 	timespecsub(&currtime, &pp->start_time, &difftime);
 	if (difftime.tv_sec < pp->total_time)
 		return 0;
+	return 1;
+}
+
+static void end_io_err_stat(struct io_err_stat_path *pp)
+{
+	struct timespec currtime;
+	struct path *path;
+	double err_rate;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &currtime) != 0)
+		currtime = pp->start_time;
 
 	io_err_stat_log(4, "%s: check end", pp->devname);
 
@@ -464,10 +459,6 @@ static int poll_io_err_stat(struct vectors *vecs, struct io_err_stat_path *pp)
 				pp->devname);
 	}
 	lock_cleanup_pop(vecs->lock);
-
-	delete_io_err_stat_by_addr(pp);
-
-	return 0;
 }
 
 static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
@@ -639,17 +630,33 @@ static void process_async_ios_event(int timeout_nsecs, char *dev)
 
 static void service_paths(void)
 {
+	struct _vector _pathvec = {0};
+	/* avoid gcc warnings that &_pathvec will never be NULL in vector ops */
+	vector tmp_pathvec = &_pathvec;
 	struct io_err_stat_path *pp;
 	int i;
 
 	pthread_mutex_lock(&io_err_pathvec_lock);
+	pthread_cleanup_push(cleanup_unlock, &io_err_pathvec_lock);
 	vector_foreach_slot(io_err_pathvec, pp, i) {
 		send_batch_async_ios(pp);
 		process_async_ios_event(TIMEOUT_NO_IO_NSEC, pp->devname);
 		poll_async_io_timeout();
-		poll_io_err_stat(vecs, pp);
+		if (io_err_stat_time_up(pp)) {
+			if (!vector_alloc_slot(tmp_pathvec))
+				continue;
+			vector_del_slot(io_err_pathvec, i--);
+			vector_set_slot(tmp_pathvec, pp);
+		}
 	}
-	pthread_mutex_unlock(&io_err_pathvec_lock);
+	pthread_cleanup_pop(1);
+	vector_foreach_slot_backwards(tmp_pathvec, pp, i) {
+		end_io_err_stat(pp);
+		vector_del_slot(tmp_pathvec, i);
+		destroy_directio_ctx(pp);
+		free_io_err_stat_path(pp);
+	}
+	vector_reset(tmp_pathvec);
 }
 
 static void cleanup_exited(__attribute__((unused)) void *arg)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

