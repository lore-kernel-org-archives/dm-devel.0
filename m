Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A5845C12
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265190; cv=none; b=DSm9+d54iOFfpwitvNTU/9USdwWfc3Q/P20TDwy+G1OGm0PSKcWMPsIm7jUtt0Ctax2BTn0+ErOrDBUgAd1NuRzVl7YHirQjBnwlJeRmvdtG3N77EXr/7+e4pYGL1ugk7DNrlItwiY9ssc4QQcL8DzkrV0V06JApLaDI3pNGD/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265190; c=relaxed/simple;
	bh=EtH2AfpT38i/2OFi28+NmwQBdM8lEomQdxGXFtGzh+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJqI3Cd4/lWtMzeHyCjohrHtjRhDdaz43rSTfDzJHLguWqr6cE/37+/YvbHHJ/5aIVveTvOTdPoVDJosPfGTQBZl/hIjdn5SgcT3xHbHxoExlSx2kMTwZx4DBaTuaFwFOQFjn+sd67kgM94ham8Kt//2zswh7IXzPFqB18mRT7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/Zf9grw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/Zf9grw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+YjRLgFYc8FFFBKDSPy1QFfYTN4GuTKY441ak+islVU=;
	b=a/Zf9grwKlcbMRd7egOxyA+Px+OVCbnAU9AgNwM+dCkN64zJrxc+GJZkRtxbg3+E0ndfi6
	FFBast8VjFXZW9q3U5CBEmRzd70Smdgifs0eTOvgwnedzBsyKSVAayRUSHc4ckn5/GR1DM
	iuysB91KS7w7vwBS04Cd+ISdm6QUPRU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-38UnSv3DPHqpDgL0n6tnuw-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: 38UnSv3DPHqpDgL0n6tnuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75CB183B827;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6ECD3C0348C;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6C1629EB31; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 08/13] dm vdo thread-utils: push uds_*_cond interface down to indexer
Date: Thu, 29 Feb 2024 22:53:00 -0500
Message-ID: <2ea30ce3613b6c8aa541882a927c9a5019ec5956.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Only used by indexer components. Also return void from
uds_init_cond(), remove uds_destroy_cond(), and fix up
all callers.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/index-session.c | 32 +++++++++++++------------------
 drivers/md/dm-vdo/index.c         |  8 +-------
 drivers/md/dm-vdo/indexer.h       | 24 +++++++++++++++++++++++
 drivers/md/dm-vdo/thread-utils.c  | 12 ------------
 drivers/md/dm-vdo/thread-utils.h  | 28 ---------------------------
 drivers/md/dm-vdo/volume.c        | 15 ++-------------
 6 files changed, 40 insertions(+), 79 deletions(-)

diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 7afc19748712..4837621c16db 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -230,36 +230,21 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 		return result;
 	}
 
-	result = uds_init_cond(&session->request_cond);
-	if (result != UDS_SUCCESS) {
-		uds_destroy_mutex(&session->request_mutex);
-		uds_free(session);
-		return result;
-	}
+	uds_init_cond(&session->request_cond);
 
 	result = uds_init_mutex(&session->load_context.mutex);
 	if (result != UDS_SUCCESS) {
-		uds_destroy_cond(&session->request_cond);
 		uds_destroy_mutex(&session->request_mutex);
 		uds_free(session);
 		return result;
 	}
 
-	result = uds_init_cond(&session->load_context.cond);
-	if (result != UDS_SUCCESS) {
-		uds_destroy_mutex(&session->load_context.mutex);
-		uds_destroy_cond(&session->request_cond);
-		uds_destroy_mutex(&session->request_mutex);
-		uds_free(session);
-		return result;
-	}
+	uds_init_cond(&session->load_context.cond);
 
 	result = uds_make_request_queue("callbackW", &handle_callbacks,
 					&session->callback_queue);
 	if (result != UDS_SUCCESS) {
-		uds_destroy_cond(&session->load_context.cond);
 		uds_destroy_mutex(&session->load_context.mutex);
-		uds_destroy_cond(&session->request_cond);
 		uds_destroy_mutex(&session->request_mutex);
 		uds_free(session);
 		return result;
@@ -700,9 +685,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	result = save_and_free_index(index_session);
 	uds_request_queue_finish(index_session->callback_queue);
 	index_session->callback_queue = NULL;
-	uds_destroy_cond(&index_session->load_context.cond);
 	uds_destroy_mutex(&index_session->load_context.mutex);
-	uds_destroy_cond(&index_session->request_cond);
 	uds_destroy_mutex(&index_session->request_mutex);
 	uds_log_debug("Destroyed index session");
 	uds_free(index_session);
@@ -758,3 +741,14 @@ int uds_get_index_session_stats(struct uds_index_session *index_session,
 
 	return UDS_SUCCESS;
 }
+
+void uds_wait_cond(struct cond_var *cv, struct mutex *mutex)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(&cv->wait_queue, &__wait, TASK_IDLE);
+	uds_unlock_mutex(mutex);
+	schedule();
+	finish_wait(&cv->wait_queue, &__wait);
+	uds_lock_mutex(mutex);
+}
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index 1596f6ba43a5..edd81f03c2b5 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -754,7 +754,6 @@ static void free_chapter_writer(struct chapter_writer *writer)
 
 	stop_chapter_writer(writer);
 	uds_destroy_mutex(&writer->mutex);
-	uds_destroy_cond(&writer->cond);
 	uds_free_open_chapter_index(writer->open_chapter_index);
 	uds_free(writer->collated_records);
 	uds_free(writer);
@@ -781,12 +780,7 @@ static int make_chapter_writer(struct uds_index *index,
 		return result;
 	}
 
-	result = uds_init_cond(&writer->cond);
-	if (result != UDS_SUCCESS) {
-		uds_destroy_mutex(&writer->mutex);
-		uds_free(writer);
-		return result;
-	}
+	uds_init_cond(&writer->cond);
 
 	result = uds_allocate_cache_aligned(collated_records_size, "collated records",
 					    &writer->collated_records);
diff --git a/drivers/md/dm-vdo/indexer.h b/drivers/md/dm-vdo/indexer.h
index 59e6a5ca2acb..3744aaf625b0 100644
--- a/drivers/md/dm-vdo/indexer.h
+++ b/drivers/md/dm-vdo/indexer.h
@@ -6,7 +6,10 @@
 #ifndef INDEXER_H
 #define INDEXER_H
 
+#include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/wait.h>
 
 #include "funnel-queue.h"
 
@@ -326,4 +329,25 @@ int __must_check uds_get_index_session_stats(struct uds_index_session *session,
 /* This function will fail if any required field of the request is not set. */
 int __must_check uds_launch_request(struct uds_request *request);
 
+struct cond_var {
+	wait_queue_head_t wait_queue;
+};
+
+static inline void uds_init_cond(struct cond_var *cv)
+{
+	init_waitqueue_head(&cv->wait_queue);
+}
+
+static inline void uds_signal_cond(struct cond_var *cv)
+{
+	wake_up(&cv->wait_queue);
+}
+
+static inline void uds_broadcast_cond(struct cond_var *cv)
+{
+	wake_up_all(&cv->wait_queue);
+}
+
+void uds_wait_cond(struct cond_var *cv, struct mutex *mutex);
+
 #endif /* INDEXER_H */
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index 5d371bfba8ff..30760b1c4d30 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -9,7 +9,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/kthread.h>
-#include <linux/sched.h>
 
 #include "errors.h"
 #include "logger.h"
@@ -135,14 +134,3 @@ int uds_join_threads(struct thread *thread)
 	uds_free(thread);
 	return UDS_SUCCESS;
 }
-
-void uds_wait_cond(struct cond_var *cv, struct mutex *mutex)
-{
-	DEFINE_WAIT(__wait);
-
-	prepare_to_wait(&cv->wait_queue, &__wait, TASK_IDLE);
-	uds_unlock_mutex(mutex);
-	schedule();
-	finish_wait(&cv->wait_queue, &__wait);
-	uds_lock_mutex(mutex);
-}
diff --git a/drivers/md/dm-vdo/thread-utils.h b/drivers/md/dm-vdo/thread-utils.h
index c7a5d2d948a4..fb71f8f1b46e 100644
--- a/drivers/md/dm-vdo/thread-utils.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -11,16 +11,11 @@
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
 #include <linux/semaphore.h>
-#include <linux/wait.h>
 
 #include "errors.h"
 
 /* Thread and synchronization utilities for UDS */
 
-struct cond_var {
-	wait_queue_head_t wait_queue;
-};
-
 struct thread;
 
 
@@ -31,30 +26,8 @@ void uds_perform_once(atomic_t *once_state, void (*function) (void));
 
 int uds_join_threads(struct thread *thread);
 
-static inline int __must_check uds_init_cond(struct cond_var *cv)
-{
-	init_waitqueue_head(&cv->wait_queue);
-	return UDS_SUCCESS;
-}
-
-static inline void uds_signal_cond(struct cond_var *cv)
-{
-	wake_up(&cv->wait_queue);
-}
-
-static inline void uds_broadcast_cond(struct cond_var *cv)
-{
-	wake_up_all(&cv->wait_queue);
-}
-
-void uds_wait_cond(struct cond_var *cv, struct mutex *mutex);
-
 /* FIXME: all below wrappers should be removed! */
 
-static inline void uds_destroy_cond(struct cond_var *cv)
-{
-}
-
 static inline int __must_check uds_init_mutex(struct mutex *mutex)
 {
 	mutex_init(mutex);
@@ -76,5 +49,4 @@ static inline void uds_unlock_mutex(struct mutex *mutex)
 	mutex_unlock(mutex);
 }
 
-
 #endif /* UDS_THREADS_H */
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 5b3cb5d89e47..3b256a78fb02 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -1627,17 +1627,8 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 		return result;
 	}
 
-	result = uds_init_cond(&volume->read_threads_read_done_cond);
-	if (result != UDS_SUCCESS) {
-		uds_free_volume(volume);
-		return result;
-	}
-
-	result = uds_init_cond(&volume->read_threads_cond);
-	if (result != UDS_SUCCESS) {
-		uds_free_volume(volume);
-		return result;
-	}
+	uds_init_cond(&volume->read_threads_read_done_cond);
+	uds_init_cond(&volume->read_threads_cond);
 
 	result = uds_allocate(config->read_threads, struct thread *, "reader threads",
 			      &volume->reader_threads);
@@ -1700,8 +1691,6 @@ void uds_free_volume(struct volume *volume)
 	if (volume->client != NULL)
 		dm_bufio_client_destroy(uds_forget(volume->client));
 
-	uds_destroy_cond(&volume->read_threads_cond);
-	uds_destroy_cond(&volume->read_threads_read_done_cond);
 	uds_destroy_mutex(&volume->read_threads_mutex);
 	uds_free_index_page_map(volume->index_page_map);
 	uds_free_radix_sorter(volume->radix_sorter);
-- 
2.42.0

