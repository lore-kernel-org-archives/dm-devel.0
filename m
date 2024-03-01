Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB0E47F48
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265192; cv=none; b=ekAeTfOQUWrozvnJOK4CtXwBCUzIM8J+JNa7HpYuiyVe59gPD6ln73wbmMLKduFJKLmtFkeaiu3YYPDBNWlMqIT3QLPRWNU61Cb6enuN2KcLF5iug1FAGCK+FcwIi0d/RkA/RxACbMAjuo/GBM9nHCmUX6JdR7KMlPYhY8d+z5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265192; c=relaxed/simple;
	bh=piyl5X83nzXG4LYYEKjgHcb4oIDyi+4cEkylwW+Tf7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bl7S0x1lVKNoHmyBaKZCrSmJ6T0ABkX2gbF81c5e56T2GOENm94cF9x0AZL5E/cF/OxsbVPqvWpF9UzcpemipyRYIPjY1z1mE35JpqTK0LeSi2QmECrynCfzQP1B1mHxoxRdubA73lSMWBaX8UGsnhFaqjbrxK8g4DBr0eeqt8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BoEbOtkF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BoEbOtkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jeLEZfNTc3kUZVf3/H9cozjpp8Yd+0clzzRlyWTjd0I=;
	b=BoEbOtkFx2+cy14pNmEfTceF8u5T+KvfILGRszrFZ+nuM/M8w0/8i6rnbZ5r9AJR6YeW9O
	p8+GZzNEps51L0qDUOiSoyeZ4ZRiTXH+oCiXQfDXR0e53Sdcc4pSNE3mKDWEOooqw5n3SS
	AQqRi1mx/Dzl73+hVCQ8JH5nSI9fm10=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-AJJ4XONlMAeUuwpj9lzdwA-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: AJJ4XONlMAeUuwpj9lzdwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5979A83B826;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 540658CED;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5178E9EB27; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 03/13] dm vdo uds-threads: push 'barrier' down to sparse-cache
Date: Thu, 29 Feb 2024 22:52:55 -0500
Message-ID: <6ffa0fa6379e6c701551cf444de4869cf074488b.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

The sparse-cache is the only user of the 'barrier' data structure,
so just move it private to it.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/sparse-cache.c | 69 +++++++++++++++++++++++++++++++-
 drivers/md/dm-vdo/uds-threads.c  | 56 --------------------------
 drivers/md/dm-vdo/uds-threads.h  | 15 -------
 3 files changed, 68 insertions(+), 72 deletions(-)

diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index 5b41c94f53fa..dcd5ef25b360 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -6,6 +6,7 @@
 #include "sparse-cache.h"
 
 #include <linux/cache.h>
+#include <linux/delay.h>
 #include <linux/dm-bufio.h>
 
 #include "chapter-index.h"
@@ -14,7 +15,6 @@
 #include "logger.h"
 #include "memory-alloc.h"
 #include "permassert.h"
-#include "uds-threads.h"
 
 /*
  * Since the cache is small, it is implemented as a simple array of cache entries. Searching for a
@@ -141,6 +141,17 @@ struct search_list {
 	struct cached_chapter_index *entries[];
 };
 
+struct barrier {
+	/* Lock for this barrier object */
+	struct semaphore lock;
+	/* Semaphore for threads waiting at this barrier */
+	struct semaphore wait;
+	/* Number of threads which have arrived */
+	int arrived;
+	/* Total number of threads using this barrier */
+	int thread_count;
+};
+
 struct sparse_cache {
 	const struct index_geometry *geometry;
 	unsigned int capacity;
@@ -156,6 +167,62 @@ struct sparse_cache {
 	struct cached_chapter_index chapters[];
 };
 
+static int uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count)
+{
+	sema_init(&barrier->lock, 1);
+	barrier->arrived = 0;
+	barrier->thread_count = thread_count;
+	sema_init(&barrier->wait, 0);
+
+	return UDS_SUCCESS;
+}
+
+static int uds_destroy_barrier(struct barrier *barrier)
+{
+	return UDS_SUCCESS;
+}
+
+static inline void __down(struct semaphore *semaphore)
+{
+	/*
+	 * Do not use down(semaphore). Instead use down_interruptible so that
+	 * we do not get 120 second stall messages in kern.log.
+	 */
+	while (down_interruptible(semaphore) != 0) {
+		/*
+		 * If we're called from a user-mode process (e.g., "dmsetup
+		 * remove") while waiting for an operation that may take a
+		 * while (e.g., UDS index save), and a signal is sent (SIGINT,
+		 * SIGUSR2), then down_interruptible will not block. If that
+		 * happens, sleep briefly to avoid keeping the CPU locked up in
+		 * this loop. We could just call cond_resched, but then we'd
+		 * still keep consuming CPU time slices and swamp other threads
+		 * trying to do computational work. [VDO-4980]
+		 */
+		fsleep(1000);
+	}
+}
+
+static int uds_enter_barrier(struct barrier *barrier)
+{
+	__down(&barrier->lock);
+	if (++barrier->arrived == barrier->thread_count) {
+		/* last thread */
+		int i;
+
+		for (i = 1; i < barrier->thread_count; i++)
+			up(&barrier->wait);
+
+		barrier->arrived = 0;
+		up(&barrier->lock);
+	} else {
+		up(&barrier->lock);
+		__down(&barrier->wait);
+	}
+
+	return UDS_SUCCESS;
+}
+
 static int __must_check initialize_cached_chapter_index(struct cached_chapter_index *chapter,
 							const struct index_geometry *geometry)
 {
diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
index af6c58eaf449..3bfd22bae8b1 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -135,59 +135,3 @@ int uds_join_threads(struct thread *thread)
 	uds_free(thread);
 	return UDS_SUCCESS;
 }
-
-static inline void __down(struct semaphore *semaphore)
-{
-	/*
-	 * Do not use down(semaphore). Instead use down_interruptible so that
-	 * we do not get 120 second stall messages in kern.log.
-	 */
-	while (down_interruptible(semaphore) != 0) {
-		/*
-		 * If we're called from a user-mode process (e.g., "dmsetup
-		 * remove") while waiting for an operation that may take a
-		 * while (e.g., UDS index save), and a signal is sent (SIGINT,
-		 * SIGUSR2), then down_interruptible will not block. If that
-		 * happens, sleep briefly to avoid keeping the CPU locked up in
-		 * this loop. We could just call cond_resched, but then we'd
-		 * still keep consuming CPU time slices and swamp other threads
-		 * trying to do computational work. [VDO-4980]
-		 */
-		fsleep(1000);
-	}
-}
-
-int uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count)
-{
-	sema_init(&barrier->lock, 1);
-	barrier->arrived = 0;
-	barrier->thread_count = thread_count;
-	sema_init(&barrier->wait, 0);
-
-	return UDS_SUCCESS;
-}
-
-int uds_destroy_barrier(struct barrier *barrier)
-{
-	return UDS_SUCCESS;
-}
-
-int uds_enter_barrier(struct barrier *barrier)
-{
-	__down(&barrier->lock);
-	if (++barrier->arrived == barrier->thread_count) {
-		/* last thread */
-		int i;
-
-		for (i = 1; i < barrier->thread_count; i++)
-			up(&barrier->wait);
-
-		barrier->arrived = 0;
-		up(&barrier->lock);
-	} else {
-		up(&barrier->lock);
-		__down(&barrier->wait);
-	}
-
-	return UDS_SUCCESS;
-}
diff --git a/drivers/md/dm-vdo/uds-threads.h b/drivers/md/dm-vdo/uds-threads.h
index e6fa32af1feb..2a0580e4482b 100644
--- a/drivers/md/dm-vdo/uds-threads.h
+++ b/drivers/md/dm-vdo/uds-threads.h
@@ -24,16 +24,6 @@ struct cond_var {
 
 struct thread;
 
-struct barrier {
-	/* Lock for this barrier object */
-	struct semaphore lock;
-	/* Semaphore for threads waiting at the barrier */
-	struct semaphore wait;
-	/* Number of threads which have arrived */
-	int arrived;
-	/* Total number of threads using this barrier */
-	int thread_count;
-};
 
 int __must_check uds_create_thread(void (*thread_function)(void *), void *thread_data,
 				   const char *name, struct thread **new_thread);
@@ -42,11 +32,6 @@ void uds_perform_once(atomic_t *once_state, void (*function) (void));
 
 int uds_join_threads(struct thread *thread);
 
-int __must_check uds_initialize_barrier(struct barrier *barrier,
-					unsigned int thread_count);
-int uds_destroy_barrier(struct barrier *barrier);
-int uds_enter_barrier(struct barrier *barrier);
-
 int __must_check uds_init_cond(struct cond_var *cond);
 int uds_signal_cond(struct cond_var *cond);
 int uds_broadcast_cond(struct cond_var *cond);
-- 
2.42.0

