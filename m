Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7032450A62
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267940; cv=none; b=ggUxUs6Y5/aHvCiXKAF8+BWzcKJugTlnF6NZPEbyoC3nL45JndiMAQqtXcPnoyINpDZKaEgcZJ+3IAFb2RK4WAIoiOPXXtd6gIogVc7PC6LiPi0DUAVddy6QEak9g3DMlPN9gQaGGfkIESlBKvKBbaFMi4ZSAsLi7zM8FiLCLAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267940; c=relaxed/simple;
	bh=+NsMK88P8fGRTDDY2580G/KZbBNMTmj2o3ymk+gyQmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHA+weWUWEJMt63xtBWcPNtbhTOL9g84Z/FEK2U+CeHzdMsf2vhu7d25ES+ZFUqPtiK3dP8kFUDUCrF14Tc+a+txH6blWiuBkzUD+Crcmr4hNhBWpyXB6hW3i8qmr1xSA9UFfulJlXytxA5i4Pd46hmXAR1LhmD17u0ugjxiOuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XHfFqz3A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XHfFqz3A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3gUtW8s4dzVzYkQkTYpx/1lN/7KAsle5z4XzHFITPq4=;
	b=XHfFqz3AXrESMsUwLFhko4fjiPcEJwqEJmy9rbEf4dXGgmlVrZzu6PuGK34LIIzUI/Z36y
	ahtEB0qSU8u2IADL2sKAR63+WSlyb/iReUvQlwxfi3DzYdeZwHqk0YDnNsa5Kmd/pey8Da
	sQhYVGvAyS5dbDZXdRwScBzZGukZQtQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-_5DpK_yINQyEHhWgI_oO4Q-1; Thu,
 29 Feb 2024 23:38:54 -0500
X-MC-Unique: _5DpK_yINQyEHhWgI_oO4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C273338062B5;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB3402166B5E;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id B29F3A161C; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 02/10] dm vdo memory-alloc: return VDO_SUCCESS on success
Date: Thu, 29 Feb 2024 23:38:45 -0500
Message-ID: <6105d788062f5239a4d58469982a2a87967b455c.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.c | 24 ++++++++++++------------
 drivers/md/dm-vdo/memory-alloc.h |  8 ++++----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 8d5df3e45a24..dd5acc582fb3 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -194,7 +194,7 @@ static inline bool use_kmalloc(size_t size)
  * @what: What is being allocated (for error logging)
  * @ptr: A pointer to hold the allocated memory
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  */
 int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 {
@@ -216,12 +216,12 @@ int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	unsigned long start_time;
 	void *p = NULL;
 
-	if (ptr == NULL)
-		return UDS_INVALID_ARGUMENT;
+	if (unlikely(ptr == NULL))
+		return -EINVAL;
 
 	if (size == 0) {
 		*((void **) ptr) = NULL;
-		return UDS_SUCCESS;
+		return VDO_SUCCESS;
 	}
 
 	if (allocations_restricted)
@@ -245,7 +245,7 @@ int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	} else {
 		struct vmalloc_block_info *block;
 
-		if (vdo_allocate(1, struct vmalloc_block_info, __func__, &block) == UDS_SUCCESS) {
+		if (vdo_allocate(1, struct vmalloc_block_info, __func__, &block) == VDO_SUCCESS) {
 			/*
 			 * It is possible for __vmalloc to fail to allocate memory because there
 			 * are no pages available. A short sleep may allow the page reclaimer
@@ -290,7 +290,7 @@ int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	}
 
 	*((void **) ptr) = p;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /*
@@ -335,7 +335,7 @@ void vdo_free(void *ptr)
  * @what: What is being allocated (for error logging)
  * @new_ptr: A pointer to hold the reallocated pointer
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  */
 int vdo_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *what,
 			  void *new_ptr)
@@ -345,11 +345,11 @@ int vdo_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 	if (size == 0) {
 		vdo_free(ptr);
 		*(void **) new_ptr = NULL;
-		return UDS_SUCCESS;
+		return VDO_SUCCESS;
 	}
 
 	result = vdo_allocate(size, char, what, new_ptr);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	if (ptr != NULL) {
@@ -360,7 +360,7 @@ int vdo_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 		vdo_free(ptr);
 	}
 
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 int vdo_duplicate_string(const char *string, const char *what, char **new_string)
@@ -369,12 +369,12 @@ int vdo_duplicate_string(const char *string, const char *what, char **new_string
 	u8 *dup;
 
 	result = vdo_allocate(strlen(string) + 1, u8, what, &dup);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	memcpy(dup, string, strlen(string) + 1);
 	*new_string = dup;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 void vdo_memory_init(void)
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 1401843db5e0..0093d9f940d9 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -35,7 +35,7 @@ int __must_check vdo_allocate_memory(size_t size, size_t align, const char *what
  * @what: What is being allocated (for error logging)
  * @ptr: A pointer to hold the allocated memory
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  */
 static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
 				      size_t align, const char *what, void *ptr)
@@ -65,7 +65,7 @@ static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
  * @WHAT: What is being allocated (for error logging)
  * @PTR: A pointer to hold the allocated memory
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  */
 #define vdo_allocate(COUNT, TYPE, WHAT, PTR) \
 	__vdo_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
@@ -81,7 +81,7 @@ static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
  * @WHAT: What is being allocated (for error logging)
  * @PTR: A pointer to hold the allocated memory
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  */
 #define vdo_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)		\
 	__extension__({							\
@@ -105,7 +105,7 @@ static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
  * @what: What is being allocated (for error logging)
  * @ptr: A pointer to hold the allocated memory
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  */
 static inline int __must_check vdo_allocate_cache_aligned(size_t size, const char *what, void *ptr)
 {
-- 
2.42.0

