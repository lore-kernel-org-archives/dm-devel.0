Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FCC6FBE
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Khs5CEBP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6JfZQ21ewyn7EdBfOsAZxsF6p4sy9p78qxGCEvYBK0=;
	b=Khs5CEBPyPUkxSG1OO1spUJa4BAKgQBPAGl6OcWCLvQjjk+9kEDhCT3lqNgTnIZkkFxL+D
	qcTlb7C2AmpiBaG/D8GKqSR3CzqMVJcTPSY9Fs+P851kVLbT0m5903tncCDNxj+5EeMmE0
	VMO+hdNzH+Zyec3Ij6wXYzK40hTOzI4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-GL6qRJGlPICOVjEuz8w3Fw-1; Fri, 10 Nov 2023 23:30:46 -0500
X-MC-Unique: GL6qRJGlPICOVjEuz8w3Fw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55005832D66;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A97440C6EB9;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 0C5173003E; Fri, 10 Nov 2023 23:30:45 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 7/8] dm vdo memory-alloc: cleanup flow of memory-alloc.h
Date: Fri, 10 Nov 2023 23:30:43 -0500
Message-Id: <a515c8832388f33774cef30f7c691914812210a2.1699675570.git.msakai@redhat.com>
In-Reply-To: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
References: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.h | 51 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 76789f357e00..a3f69e729e0a 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -12,27 +12,9 @@
 #include "permassert.h"
 #include "thread-registry.h"
 
-/* Custom memory allocation functions for UDS that track memory usage */
-
+/* Custom memory allocation function for UDS that tracks memory usage */
 int __must_check uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr);
 
-/* Free memory allocated with uds_allocate(). */
-void uds_free(void *ptr);
-
-static inline void *__uds_forget(void **ptr_ptr)
-{
-	void *ptr = *ptr_ptr;
-
-	*ptr_ptr = NULL;
-	return ptr;
-}
-
-/*
- * Null out a pointer and return a copy to it. This macro should be used when passing a pointer to
- * a function for which it is not safe to access the pointer once the function returns.
- */
-#define uds_forget(ptr) __uds_forget((void **) &(ptr))
-
 /*
  * Allocate storage based on element counts, sizes, and alignment.
  *
@@ -77,12 +59,6 @@ static inline int uds_do_allocation(size_t count,
 	return uds_allocate_memory(total_size, align, what, ptr);
 }
 
-int __must_check uds_reallocate_memory(void *ptr,
-				       size_t old_size,
-				       size_t size,
-				       const char *what,
-				       void *new_ptr);
-
 /*
  * Allocate one or more elements of the indicated type, logging an error if the allocation fails.
  * The memory will be zeroed.
@@ -150,12 +126,35 @@ static inline int __must_check uds_allocate_cache_aligned(size_t size, const cha
  */
 void *__must_check uds_allocate_memory_nowait(size_t size, const char *what);
 
+int __must_check uds_reallocate_memory(void *ptr,
+				       size_t old_size,
+				       size_t size,
+				       const char *what,
+				       void *new_ptr);
+
 int __must_check uds_duplicate_string(const char *string, const char *what, char **new_string);
 
-void uds_memory_exit(void);
+/* Free memory allocated with uds_allocate(). */
+void uds_free(void *ptr);
+
+static inline void *__uds_forget(void **ptr_ptr)
+{
+	void *ptr = *ptr_ptr;
+
+	*ptr_ptr = NULL;
+	return ptr;
+}
+
+/*
+ * Null out a pointer and return a copy to it. This macro should be used when passing a pointer to
+ * a function for which it is not safe to access the pointer once the function returns.
+ */
+#define uds_forget(ptr) __uds_forget((void **) &(ptr))
 
 void uds_memory_init(void);
 
+void uds_memory_exit(void);
+
 void uds_register_allocating_thread(struct registered_thread *new_thread, const bool *flag_ptr);
 
 void uds_unregister_allocating_thread(void);
-- 
2.40.0

