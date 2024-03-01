Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9146425
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265190; cv=none; b=upb03ft+BaxjDPJce789MdvwJA9A/aXzDNdJEqr+fsEkm1C2LSnTJOvAA5clsXKxWNzaLBvYm10T7BxzDQ1C0o3SyYRCfxb6h5NOrHl4YfZy5iL+qj3nAV0XpHxfIJKJ45wFFP8jRoclAjkJXCCmkvC6Frh/EHl+KFVLxKHmao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265190; c=relaxed/simple;
	bh=AcLMFB0Z1eWFpm8e9wExq1eCCi4nCaQXznv/oDJyPVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UIxDsAHRrerfLcIj87kCY6YNhAH9XDoIDAciFoyx/U12+yu/6nxnqVGGuVvmdR74oowXao2pPeLCldmV6nNNcn2/Ep6HeiEyqsFi6PDh6dhSzEtZa1QL6kL4vVbjPYXVrtZh/j1OCSkFvPuYp2ZBl8FS4XohWp9V2tQ31qVtyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxDnOpag; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxDnOpag"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAsfInQma1qWPYzxGLgTPsjTShmpRHymZMzIrG9+nI4=;
	b=dxDnOpagi8SvlDZclxuWbxq5xu8K4wExNyTKyi1TXMnso/wjeaTPyZeFhiPfmTrYJGwWTK
	nhxJdcTsL7IsG+E/XWDvtvY9X2qi6o3om7JfYXIwntYTRhsac1+duGwG9WgXZ1602uaQ7s
	TtjkEW14iczSOh0Uks6jVSofoVEbBBw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-8Wk9ZgqXPL6sR8oHipQ5Fw-1; Thu,
 29 Feb 2024 22:53:05 -0500
X-MC-Unique: 8Wk9ZgqXPL6sR8oHipQ5Fw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EC7F1C05151;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79AE14D905;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 775409EB35; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 10/13] dm vdo thread-utils: further cleanup of thread functions
Date: Thu, 29 Feb 2024 22:53:02 -0500
Message-ID: <158a5f177b5d2d7f378910fc115f14b2a1064520.1709264539.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Change thread function prefix from "uds_" to "vdo_" and fix
vdo_join_threads() to return void.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/funnel-requestqueue.c | 8 ++------
 drivers/md/dm-vdo/index.c               | 4 ++--
 drivers/md/dm-vdo/status-codes.c        | 2 +-
 drivers/md/dm-vdo/thread-utils.c        | 9 ++++-----
 drivers/md/dm-vdo/thread-utils.h        | 9 ++++-----
 drivers/md/dm-vdo/volume.c              | 4 ++--
 6 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-vdo/funnel-requestqueue.c b/drivers/md/dm-vdo/funnel-requestqueue.c
index e7a3a4962295..d2b49e39550c 100644
--- a/drivers/md/dm-vdo/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/funnel-requestqueue.c
@@ -219,7 +219,7 @@ int uds_make_request_queue(const char *queue_name,
 		return result;
 	}
 
-	result = uds_create_thread(request_queue_worker, queue, queue_name,
+	result = vdo_create_thread(request_queue_worker, queue, queue_name,
 				   &queue->thread);
 	if (result != UDS_SUCCESS) {
 		uds_request_queue_finish(queue);
@@ -256,8 +256,6 @@ void uds_request_queue_enqueue(struct uds_request_queue *queue,
 
 void uds_request_queue_finish(struct uds_request_queue *queue)
 {
-	int result;
-
 	if (queue == NULL)
 		return;
 
@@ -272,9 +270,7 @@ void uds_request_queue_finish(struct uds_request_queue *queue)
 
 	if (queue->started) {
 		wake_up_worker(queue);
-		result = uds_join_threads(queue->thread);
-		if (result != UDS_SUCCESS)
-			uds_log_warning_strerror(result, "Failed to join worker thread");
+		vdo_join_threads(queue->thread);
 	}
 
 	uds_free_funnel_queue(queue->main_queue);
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index 5c9906e73c84..9d4a8e5cbaad 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -744,7 +744,7 @@ static void stop_chapter_writer(struct chapter_writer *writer)
 	mutex_unlock(&writer->mutex);
 
 	if (writer_thread != NULL)
-		uds_join_threads(writer_thread);
+		vdo_join_threads(writer_thread);
 }
 
 static void free_chapter_writer(struct chapter_writer *writer)
@@ -796,7 +796,7 @@ static int make_chapter_writer(struct uds_index *index,
 			       collated_records_size +
 			       writer->open_chapter_index->memory_size);
 
-	result = uds_create_thread(close_chapters, writer, "writer", &writer->thread);
+	result = vdo_create_thread(close_chapters, writer, "writer", &writer->thread);
 	if (result != UDS_SUCCESS) {
 		free_chapter_writer(writer);
 		return result;
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index d77bc5e4a99a..efba1ead0aca 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -82,7 +82,7 @@ static void do_status_code_registration(void)
  */
 int vdo_register_status_codes(void)
 {
-	uds_perform_once(&vdo_status_codes_registered, do_status_code_registration);
+	vdo_perform_once(&vdo_status_codes_registered, do_status_code_registration);
 	return status_code_registration_result;
 }
 
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index 30760b1c4d30..0b80247c7f1b 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -33,7 +33,7 @@ enum {
 };
 
 /* Run a function once only, and record that fact in the atomic value. */
-void uds_perform_once(atomic_t *once, void (*function)(void))
+void vdo_perform_once(atomic_t *once, void (*function)(void))
 {
 	for (;;) {
 		switch (atomic_cmpxchg(once, ONCE_NOT_DONE, ONCE_IN_PROGRESS)) {
@@ -63,7 +63,7 @@ static int thread_starter(void *arg)
 	struct thread *thread = arg;
 
 	thread->thread_task = current;
-	uds_perform_once(&thread_once, thread_init);
+	vdo_perform_once(&thread_once, thread_init);
 	mutex_lock(&thread_mutex);
 	hlist_add_head(&thread->thread_links, &thread_list);
 	mutex_unlock(&thread_mutex);
@@ -74,7 +74,7 @@ static int thread_starter(void *arg)
 	return 0;
 }
 
-int uds_create_thread(void (*thread_function)(void *), void *thread_data,
+int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 		      const char *name, struct thread **new_thread)
 {
 	char *name_colon = strchr(name, ':');
@@ -123,7 +123,7 @@ int uds_create_thread(void (*thread_function)(void *), void *thread_data,
 	return UDS_SUCCESS;
 }
 
-int uds_join_threads(struct thread *thread)
+void vdo_join_threads(struct thread *thread)
 {
 	while (wait_for_completion_interruptible(&thread->thread_done))
 		fsleep(1000);
@@ -132,5 +132,4 @@ int uds_join_threads(struct thread *thread)
 	hlist_del(&thread->thread_links);
 	mutex_unlock(&thread_mutex);
 	uds_free(thread);
-	return UDS_SUCCESS;
 }
diff --git a/drivers/md/dm-vdo/thread-utils.h b/drivers/md/dm-vdo/thread-utils.h
index 8b55f0d1ab80..ebe032e066ff 100644
--- a/drivers/md/dm-vdo/thread-utils.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -14,16 +14,15 @@
 
 #include "errors.h"
 
-/* Thread and synchronization utilities for UDS */
+/* Thread and synchronization utilities */
 
 struct thread;
 
 
-int __must_check uds_create_thread(void (*thread_function)(void *), void *thread_data,
+int __must_check vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 				   const char *name, struct thread **new_thread);
+void vdo_join_threads(struct thread *thread);
 
-void uds_perform_once(atomic_t *once_state, void (*function) (void));
-
-int uds_join_threads(struct thread *thread);
+void vdo_perform_once(atomic_t *once_state, void (*function) (void));
 
 #endif /* UDS_THREADS_H */
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 0fb06fd315ef..37c2ef0777e5 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -1633,7 +1633,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	}
 
 	for (i = 0; i < config->read_threads; i++) {
-		result = uds_create_thread(read_thread_function, (void *) volume,
+		result = vdo_create_thread(read_thread_function, (void *) volume,
 					   "reader", &volume->reader_threads[i]);
 		if (result != UDS_SUCCESS) {
 			uds_free_volume(volume);
@@ -1675,7 +1675,7 @@ void uds_free_volume(struct volume *volume)
 		uds_broadcast_cond(&volume->read_threads_cond);
 		mutex_unlock(&volume->read_threads_mutex);
 		for (i = 0; i < volume->read_thread_count; i++)
-			uds_join_threads(volume->reader_threads[i]);
+			vdo_join_threads(volume->reader_threads[i]);
 		uds_free(volume->reader_threads);
 		volume->reader_threads = NULL;
 	}
-- 
2.42.0

