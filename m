Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F175DDBB
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 20:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709585115; cv=none; b=tQoTMz2NszcrxaywxFgzMR5lHqWAz7wPRf0TapeYJ5QV7mH7ZelUhqogo2yONlr3PI4Y8AyQ1VD71QyScjcv649ZfuDhbV3J2EgV8cie3MCbhzL4WyKAKFask4y4QBia7Sp3Eaf3e1ol3K/0Mw/LVxStbVS+rMcO+YyDvzURxOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709585115; c=relaxed/simple;
	bh=ApK1RRCBzU4t+7mNHyVSplMjRMupDnHSuSGicy5cUao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hPvvueLqwrvOblGq3+kGhCh3aidBELKkvyWTtsTRRkO0r8uIcu2a3jzhWdRGk6E7v86wZL0W/I76VTRaTqrbuL/ntD5s0jW5Dl2O1DN1uYlzKj3zZOudcXrmcqZupSkdblyxe7BjUl0AG0SrwNnb/lXkXw3sWDeP47TEz7fnfwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iWwUat7B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iWwUat7B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709585112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N2xJ5fterL6a179lPeKDEVJfz6vch7uUj+ctPPGDdi0=;
	b=iWwUat7BAKF9wMDAYwt91prl5yTVN9F2+QFrnO2n1xxby3j5F/lKbDjZ/NjeyL0tb906UQ
	iR1rEcKOg8W2yEfLiEicY7YylS1HX3nVPPuUwT++nUfnSiJ2ZhpbtU3RXwQ6prPOExOwf2
	diRCwF+jk3dAR4NhdN4HsrINq+7Rf88=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-Q8RLQREEMemnxzPYdEn7kQ-1; Mon,
 04 Mar 2024 15:45:10 -0500
X-MC-Unique: Q8RLQREEMemnxzPYdEn7kQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9455E280C299
	for <dm-devel@lists.linux.dev>; Mon,  4 Mar 2024 20:45:10 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FD07111E3F3;
	Mon,  4 Mar 2024 20:45:10 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 87E16A29EF; Mon,  4 Mar 2024 15:45:10 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: remove vdo_perform_once
Date: Mon,  4 Mar 2024 15:45:10 -0500
Message-ID: <c1c0c8e577dc6f757edc41db15352faa30d21595.1709584939.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Remove obsolete function vdo_perform_once. Instead, initialize
necessary module state when loading the module.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c |  2 ++
 drivers/md/dm-vdo/status-codes.c  | 30 ++++++------------------------
 drivers/md/dm-vdo/thread-utils.c  | 28 +---------------------------
 drivers/md/dm-vdo/thread-utils.h  |  4 +---
 4 files changed, 10 insertions(+), 54 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index b7b3eec39522..9128e6cd0844 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -34,6 +34,7 @@
 #include "string-utils.h"
 #include "thread-device.h"
 #include "thread-registry.h"
+#include "thread-utils.h"
 #include "types.h"
 #include "vdo.h"
 #include "vio.h"
@@ -2872,6 +2873,7 @@ static int __init vdo_init(void)
 
 	/* Memory tracking must be initialized first for accurate accounting. */
 	vdo_memory_init();
+	vdo_initialize_threads_mutex();
 	vdo_initialize_thread_device_registry();
 	vdo_initialize_device_registry_once();
 	vdo_log_info("loaded version %s", CURRENT_VERSION);
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index 918e46e7121f..d3493450b169 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -40,10 +40,11 @@ const struct error_info vdo_status_list[] = {
 	{ "VDO_INVALID_ADMIN_STATE", "Invalid operation for current state" },
 };
 
-static atomic_t vdo_status_codes_registered = ATOMIC_INIT(0);
-static int status_code_registration_result;
-
-static void do_status_code_registration(void)
+/**
+ * vdo_register_status_codes() - Register the VDO status codes.
+ * Return: A success or error code.
+ */
+int vdo_register_status_codes(void)
 {
 	int result;
 
@@ -53,26 +54,7 @@ static void do_status_code_registration(void)
 	result = uds_register_error_block("VDO Status", VDO_STATUS_CODE_BASE,
 					  VDO_STATUS_CODE_BLOCK_END, vdo_status_list,
 					  sizeof(vdo_status_list));
-	/*
-	 * The following test handles cases where libvdo is statically linked against both the test
-	 * modules and the test driver (because multiple instances of this module call their own
-	 * copy of this function once each, resulting in multiple calls to register_error_block
-	 * which is shared in libuds).
-	 */
-	if (result == UDS_DUPLICATE_NAME)
-		result = UDS_SUCCESS;
-
-	status_code_registration_result = (result == UDS_SUCCESS) ? VDO_SUCCESS : result;
-}
-
-/**
- * vdo_register_status_codes() - Register the VDO status codes if needed.
- * Return: A success or error code.
- */
-int vdo_register_status_codes(void)
-{
-	vdo_perform_once(&vdo_status_codes_registered, do_status_code_registration);
-	return status_code_registration_result;
+	return (result == UDS_SUCCESS) ? VDO_SUCCESS : result;
 }
 
 /**
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index bd620be61c1d..ec08478dd013 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -17,7 +17,6 @@
 
 static struct hlist_head thread_list;
 static struct mutex thread_mutex;
-static atomic_t thread_once = ATOMIC_INIT(0);
 
 struct thread {
 	void (*thread_function)(void *thread_data);
@@ -27,31 +26,7 @@ struct thread {
 	struct completion thread_done;
 };
 
-#define ONCE_NOT_DONE 0
-#define ONCE_IN_PROGRESS 1
-#define ONCE_COMPLETE 2
-
-/* Run a function once only, and record that fact in the atomic value. */
-void vdo_perform_once(atomic_t *once, void (*function)(void))
-{
-	for (;;) {
-		switch (atomic_cmpxchg(once, ONCE_NOT_DONE, ONCE_IN_PROGRESS)) {
-		case ONCE_NOT_DONE:
-			function();
-			atomic_set_release(once, ONCE_COMPLETE);
-			return;
-		case ONCE_IN_PROGRESS:
-			cond_resched();
-			break;
-		case ONCE_COMPLETE:
-			return;
-		default:
-			return;
-		}
-	}
-}
-
-static void thread_init(void)
+void vdo_initialize_threads_mutex(void)
 {
 	mutex_init(&thread_mutex);
 }
@@ -62,7 +37,6 @@ static int thread_starter(void *arg)
 	struct thread *thread = arg;
 
 	thread->thread_task = current;
-	vdo_perform_once(&thread_once, thread_init);
 	mutex_lock(&thread_mutex);
 	hlist_add_head(&thread->thread_links, &thread_list);
 	mutex_unlock(&thread_mutex);
diff --git a/drivers/md/dm-vdo/thread-utils.h b/drivers/md/dm-vdo/thread-utils.h
index f3619a581c5e..687ab43e2cee 100644
--- a/drivers/md/dm-vdo/thread-utils.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -12,11 +12,9 @@
 
 struct thread;
 
-
+void vdo_initialize_threads_mutex(void);
 int __must_check vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 				   const char *name, struct thread **new_thread);
 void vdo_join_threads(struct thread *thread);
 
-void vdo_perform_once(atomic_t *once_state, void (*function) (void));
-
 #endif /* UDS_THREADS_H */
-- 
2.42.0

