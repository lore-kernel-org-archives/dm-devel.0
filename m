Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052689;
	b=ooaqyeiT6YfDCkK5l1N52iR2Br8Q91BdsouRKNmHtw952dQV51IaEts0kyr/81aVovP6
	 KEKM/c0RAgJMEUH9d7NB1uWkOQ4gRJ6igVpHgXiIMO30QFiCc2HzzEr2aTzgT8SkNcWfG
	 ClYEcTbrJ/vyx7uaknPBD5eZg/YRH+j6cQzigBeZV3npKbSQPjTTHsd2XinP1mB3lJbtB
	 /u7+uUnfSk630qZTMcdCs8L3D/7YbhneE6WOmvNQDFeGdbPfg+nXDWSi0n0QeolwknngP
	 s3MHSIQ+OzJMOwaIJ3Htf25eBICEZXc63L2DAVyEFjTi+4SgifYqAXf0uol0Ko359iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052689;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=pBploOhn4g6yNVDbs6FG1RfhgMGJUyZbXI+qPBgpBqE=;
	b=dYgLmX5pAJFxSAAkwssFTix8D/dvH8eZ746VAbfh6djeHDrZbAfsb9onJyxG2I03k23b
	 lqqTfWx5DTr2H4i/Di7uuVWmjWdIyqoj7aK3ib7oo6qhZ2BYZO3N/98WzlKS+QbpA1RRx
	 TbzyXcz+/UgBGzAXQiuuoHyPNvEVfcnuPQdr39AY0Rh2ab9uVrVg3vFFNk4LBGRZkxUJR
	 PR6GI5d140GGVJ02sv8+jOkTkb7sRdgzNkjC6Tx2BjAfHJk+cShBetO64SZF+su3IoSCo
	 hyF0bZDrIq5JqhcW47tdmAf+Fz7MSEeLF04KohIfyjuLksC1IeMkIW8z6sXgPaJurug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XjyzRgvu;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214AC606A32F
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 01:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 214AC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XjyzRgvu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795052688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pBploOhn4g6yNVDbs6FG1RfhgMGJUyZbXI+qPBgpBqE=;
	b=XjyzRgvukTvD6xjKXaImf6lzV8hc2ItvbMKp3/Y37l8vU5A/Of/rn6md0MKn1E0gFJE39v
	zD2aQl7+y+28fZpSDmLYI+cLt2wJXtfvzVtFW1FvEZEwtRAEhwIUMt2JigB5pcy5ZOStB8
	ovYjRxX8G3zE9CKPp0Jvml/WCEm9Cok=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-eH8q5MGcPQOV7pj0DbWGAw-1; Wed,
 18 Nov 2026 20:44:46 -0500
X-MC-Unique: eH8q5MGcPQOV7pj0DbWGAw-1
X-Mimecast-MFC-AGG-ID: eH8q5MGcPQOV7pj0DbWGAw_1795052686
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC2B01800260;
	Thu, 19 Nov 2026 01:44:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.74.64.3])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F31B4195608B;
	Thu, 19 Nov 2026 01:44:43 +0000 (UTC)
From: Ganesh Andhale <gandhale@redhat.com>
To: christophe.varoqui@opensvc.com
Cc: dm-devel@lists.linux.dev,
	bmarzins@redhat.com,
	mwilck@suse.com
Subject: [PATCH] multipathd: cleanup global queues after threads exit
Date: Thu, 12 Nov 2026 21:03:10 +0530
Message-ID: <20261112153310.19652-1-gandhale@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q9OhK-GWWknKyEu9k5Rojc605a186N9Y_PcQnXwKjQ8_1795052686
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

cleanup_global_uevq() and cleanup_global_purge_queue() were registered
as pthread cleanup handlers in worker threads. During shutdown, these
handlers could run as soon as their owning thread was cancelled, while
another thread that also accessed the same global queue had not been
joined yet.

This allowed the global uevent or purge queue to be cleaned while a
producer or consumer thread could still touch it.

Move the global queue cleanup to cleanup_queues(), which is called
after cleanup_threads(), once all related threads have been joined.
Keep the pthread cleanup handlers only for thread-local temporary lists
and other resources owned by the cancelling thread.

Export cleanup_global_uevq() from libmultipath so multipathd can call
it during daemon shutdown.

Signed-off-by: Ganesh Andhale <gandhale@redhat.com>
---
 libmultipath/libmultipath.version |  1 +
 libmultipath/uevent.c             |  4 +---
 libmultipath/uevent.h             |  2 ++
 multipathd/main.c                 | 12 ++++++++++++
 multipathd/purge.c                |  4 +---
 multipathd/purge.h                |  2 ++
 6 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index f631f453..93f213b6 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -203,6 +203,7 @@ global:
 	trigger_path_udev_change;
 	trigger_paths_udev_change;
 	udev;
+	cleanup_global_uevq;
 	uevent_dispatch;
 	uevent_get_dm_str;
 	uevent_get_env_positive_int;
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index b0c43340..e1c8aa72 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -503,7 +503,7 @@ static void cleanup_uevq(void *arg)
 	uevq_cleanup(arg);
 }
 
-static void cleanup_global_uevq(void *arg __attribute__((unused)))
+void cleanup_global_uevq(void)
 {
 	pthread_mutex_lock(uevq_lockp);
 	uevq_cleanup(&uevq);
@@ -726,7 +726,6 @@ int uevent_listen(struct udev *udev)
 		goto out;
 	}
 
-	pthread_cleanup_push(cleanup_global_uevq, NULL);
 	pthread_cleanup_push(cleanup_uevq, &uevlisten_tmp);
 	while (1) {
 		int fdcount, events;
@@ -755,7 +754,6 @@ int uevent_listen(struct udev *udev)
 		pthread_mutex_unlock(uevq_lockp);
 	}
 	pthread_cleanup_pop(1);
-	pthread_cleanup_pop(1);
 out:
 	pthread_cleanup_pop(1);
 out_udev:
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 69296789..f21419ea 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -28,6 +28,8 @@ struct uevent {
 struct uevent *alloc_uevent(void);
 int is_uevent_busy(void);
 
+void cleanup_global_uevq(void);
+
 int uevent_listen(struct udev *udev);
 int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data),
 		    void * trigger_data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 9bce4d6b..11bd1d01 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3812,6 +3812,17 @@ static void cleanup_vecs(void)
 	gvecs = NULL;
 }
 
+static void cleanup_queues(void)
+{
+	/*
+	 * Shared queues must be cleaned only after every producer and
+	 * consumer has been joined. Worker cleanup handlers must not
+	 * free these globals while another thread may still access them.
+	 */
+	cleanup_global_purge_queue();
+	cleanup_global_uevq();
+}
+
 static void cleanup_threads(void)
 {
 	stop_io_err_stat_thread();
@@ -3915,6 +3926,7 @@ static void cleanup_rcu(void)
 static void cleanup_child(void)
 {
 	cleanup_threads();
+	cleanup_queues();
 	cleanup_vecs();
 	cleanup_bindings();
 	if (poll_dmevents)
diff --git a/multipathd/purge.c b/multipathd/purge.c
index 68db8ced..078b4079 100644
--- a/multipathd/purge.c
+++ b/multipathd/purge.c
@@ -235,7 +235,7 @@ void cleanup_purge_list(void *arg)
  * Cleanup handler for the global purge queue.
  * Used during shutdown to free any remaining queued items.
  */
-static void cleanup_global_purge_queue(void *arg __attribute__((unused)))
+void cleanup_global_purge_queue(void)
 {
 	pthread_mutex_lock(&purge_mutex);
 	cleanup_purge_list(&purge_queue);
@@ -268,7 +268,6 @@ void *purgeloop(void *ap __attribute__((unused)))
 	 * Cleanup handler for global purge_queue.
 	 * This handles items that were queued but not yet moved to purge_list.
 	 */
-	pthread_cleanup_push(cleanup_global_purge_queue, NULL);
 
 	while (1) {
 		LIST_HEAD(purge_list);
@@ -320,7 +319,6 @@ void *purgeloop(void *ap __attribute__((unused)))
 		pthread_cleanup_pop(0);
 	}
 
-	pthread_cleanup_pop(1);
 	pthread_cleanup_pop(1);
 	return NULL;
 }
diff --git a/multipathd/purge.h b/multipathd/purge.h
index 1fe755f3..81ed952b 100644
--- a/multipathd/purge.h
+++ b/multipathd/purge.h
@@ -33,6 +33,8 @@ void build_purge_list(struct vectors *vecs, struct list_head *tmpq);
  */
 void cleanup_purge_list(void *arg);
 
+void cleanup_global_purge_queue(void);
+
 /*
  * Main purge thread loop
  */
-- 
2.56.0

