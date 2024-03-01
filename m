Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E384C47F53
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265191; cv=none; b=H9HBuQZqxVQiaRDTM7DMrvsve5/U9R17n8gE0rGXGGsHYeb27cTNHv5u8H72tUylmcHNRlYR4gNv/oDvK7iBiBqMbtMKolt23CvGEzwPNw1Umq4lTkshabdLr2xt6b79aYdt/D6Yb2IrtNw7dFQBdd6wEU3TaR1h1cLb0ZEJBjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265191; c=relaxed/simple;
	bh=JLv+6ZkLfpLn6RQ3rPjlh/DtdoRTtYNW8NZw6O+hWKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHB3MtCZdfTsKm7+W6MmlbS8nYg9BxcMkbpD29wjnDzh1qFoA+mFHgVshTpgkiedmTqUA5uVLhY7GsvE8m8Wgy7zAnmTSJWytMZp13GkntQrwewQQ9J3V293TySJys3shNTrgIFFb0RX9m8EoaOdEKMdHnws13wG6MzURV4hukY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RpT6l3PO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RpT6l3PO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cuiz4eaXM5sspP0BpOCemW1CEeYeai74VVQ6YS4vg4o=;
	b=RpT6l3PORNeTGieQTPL+AtEI93LUcWMzSdTjO5eheWoCIAT86LusmbBjLkdbx8hCnUUC8A
	NQp1KyKcufnbHa/IuSTvziZiWtDIXRFzoCnrMCovyllfMjVnb9yQMnuUfOTtCwf0M7FbE0
	1urzFcx7uqVNdqJ46JmClIdyARpnvUk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536--I8mlxRwPQeL_I9oe794Xg-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: -I8mlxRwPQeL_I9oe794Xg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A1F7185A782;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84756112132A;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 821999EB39; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 12/13] dm vdo thread-registry: rename all methods to reflect vdo-only use
Date: Thu, 29 Feb 2024 22:53:04 -0500
Message-ID: <91ff20e1b7e45f30b87b1483d7806fdd42e8e6c7.1709264539.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Otherwise, uds_ prefix is misleading (vdo_ is the new catch-all for
code that is used by vdo-only or _both_ vdo and the indexer code).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.c    | 12 ++++++------
 drivers/md/dm-vdo/thread-device.c   |  8 ++++----
 drivers/md/dm-vdo/thread-registry.c |  8 ++++----
 drivers/md/dm-vdo/thread-registry.h | 14 +++++++-------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 46dd5bda6825..3b2bda9248cb 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -15,14 +15,14 @@
 
 /*
  * UDS and VDO keep track of which threads are allowed to allocate memory freely, and which threads
- * must be careful to not do a memory allocation that does an I/O request. The allocating_threads
- * threads_registry and its associated methods implement this tracking.
+ * must be careful to not do a memory allocation that does an I/O request. The 'allocating_threads'
+ * thread_registry and its associated methods implement this tracking.
  */
 static struct thread_registry allocating_threads;
 
 static bool allocations_allowed(void)
 {
-	const bool *pointer = uds_lookup_thread(&allocating_threads);
+	const bool *pointer = vdo_lookup_thread(&allocating_threads);
 
 	return (pointer != NULL) ? *pointer : false;
 }
@@ -48,13 +48,13 @@ void uds_register_allocating_thread(struct registered_thread *new_thread,
 		flag_ptr = &allocation_always_allowed;
 	}
 
-	uds_register_thread(&allocating_threads, new_thread, flag_ptr);
+	vdo_register_thread(&allocating_threads, new_thread, flag_ptr);
 }
 
 /* Unregister the current thread as an allocating thread. */
 void uds_unregister_allocating_thread(void)
 {
-	uds_unregister_thread(&allocating_threads);
+	vdo_unregister_thread(&allocating_threads);
 }
 
 /*
@@ -384,7 +384,7 @@ int uds_duplicate_string(const char *string, const char *what, char **new_string
 void uds_memory_init(void)
 {
 	spin_lock_init(&memory_stats.lock);
-	uds_initialize_thread_registry(&allocating_threads);
+	vdo_initialize_thread_registry(&allocating_threads);
 }
 
 void uds_memory_exit(void)
diff --git a/drivers/md/dm-vdo/thread-device.c b/drivers/md/dm-vdo/thread-device.c
index b87de448a83b..2bf14b9f67f8 100644
--- a/drivers/md/dm-vdo/thread-device.c
+++ b/drivers/md/dm-vdo/thread-device.c
@@ -14,23 +14,23 @@ static struct thread_registry device_id_thread_registry;
 void uds_register_thread_device_id(struct registered_thread *new_thread,
 				   unsigned int *id_ptr)
 {
-	uds_register_thread(&device_id_thread_registry, new_thread, id_ptr);
+	vdo_register_thread(&device_id_thread_registry, new_thread, id_ptr);
 }
 
 void uds_unregister_thread_device_id(void)
 {
-	uds_unregister_thread(&device_id_thread_registry);
+	vdo_unregister_thread(&device_id_thread_registry);
 }
 
 int uds_get_thread_device_id(void)
 {
 	const unsigned int *pointer;
 
-	pointer = uds_lookup_thread(&device_id_thread_registry);
+	pointer = vdo_lookup_thread(&device_id_thread_registry);
 	return (pointer != NULL) ? *pointer : -1;
 }
 
 void uds_initialize_thread_device_registry(void)
 {
-	uds_initialize_thread_registry(&device_id_thread_registry);
+	vdo_initialize_thread_registry(&device_id_thread_registry);
 }
diff --git a/drivers/md/dm-vdo/thread-registry.c b/drivers/md/dm-vdo/thread-registry.c
index 8c887158c224..1314d2b6a26f 100644
--- a/drivers/md/dm-vdo/thread-registry.c
+++ b/drivers/md/dm-vdo/thread-registry.c
@@ -14,14 +14,14 @@
  * their normal operation. For example, we do not want to invoke the logger while holding a lock.
  */
 
-void uds_initialize_thread_registry(struct thread_registry *registry)
+void vdo_initialize_thread_registry(struct thread_registry *registry)
 {
 	INIT_LIST_HEAD(&registry->links);
 	spin_lock_init(&registry->lock);
 }
 
 /* Register the current thread and associate it with a data pointer. */
-void uds_register_thread(struct thread_registry *registry,
+void vdo_register_thread(struct thread_registry *registry,
 			 struct registered_thread *new_thread, const void *pointer)
 {
 	struct registered_thread *thread;
@@ -51,7 +51,7 @@ void uds_register_thread(struct thread_registry *registry,
 	}
 }
 
-void uds_unregister_thread(struct thread_registry *registry)
+void vdo_unregister_thread(struct thread_registry *registry)
 {
 	struct registered_thread *thread;
 	bool found_it = false;
@@ -74,7 +74,7 @@ void uds_unregister_thread(struct thread_registry *registry)
 	}
 }
 
-const void *uds_lookup_thread(struct thread_registry *registry)
+const void *vdo_lookup_thread(struct thread_registry *registry)
 {
 	struct registered_thread *thread;
 	const void *result = NULL;
diff --git a/drivers/md/dm-vdo/thread-registry.h b/drivers/md/dm-vdo/thread-registry.h
index f70f755568a1..cc6d78312b9e 100644
--- a/drivers/md/dm-vdo/thread-registry.h
+++ b/drivers/md/dm-vdo/thread-registry.h
@@ -3,8 +3,8 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_THREAD_REGISTRY_H
-#define UDS_THREAD_REGISTRY_H
+#ifndef VDO_THREAD_REGISTRY_H
+#define VDO_THREAD_REGISTRY_H
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -20,13 +20,13 @@ struct registered_thread {
 	struct task_struct *task;
 };
 
-void uds_initialize_thread_registry(struct thread_registry *registry);
+void vdo_initialize_thread_registry(struct thread_registry *registry);
 
-void uds_register_thread(struct thread_registry *registry,
+void vdo_register_thread(struct thread_registry *registry,
 			 struct registered_thread *new_thread, const void *pointer);
 
-void uds_unregister_thread(struct thread_registry *registry);
+void vdo_unregister_thread(struct thread_registry *registry);
 
-const void *uds_lookup_thread(struct thread_registry *registry);
+const void *vdo_lookup_thread(struct thread_registry *registry);
 
-#endif /* UDS_THREAD_REGISTRY_H */
+#endif /* VDO_THREAD_REGISTRY_H */
-- 
2.42.0

