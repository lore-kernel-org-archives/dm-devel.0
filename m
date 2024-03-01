Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BFF482DF
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267563; cv=none; b=YHzPUpdFz19WvoziKqIUnN4WxAe8DCJhI5lsSiFMykN2mMUKY97mnWRiDIP/qh/d9eKxzhw1cr7Aw8H6zJZ+XWEwi6nAqAAZdDgNHol2bg9w6AjChx3FkUJZfcNlczkB2QzkWsTQcml+RaM4dZdsHzc/57lU/2dRcUe2vVqOW1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267563; c=relaxed/simple;
	bh=GCPJYkiLbaEqlSNXAwBqJInpifNkhSjccil5alJhlFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMfojlyHjTElwIUSpHP+1xquZFaE+hDqRi/0nzlNe/13k9+/rResIFCMIrPWF3aAD7KHyYABLSy6o1XB5usDMmpLZZfGstRRhH+9C16k6FFujKIUXJSYPzx8Df/Zm1LiJLOj+nXDSpdIIYJsT6h+47EDfFxUv/rLBlwkFp5G2mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YGCyAyUH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YGCyAyUH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45wx3PuiApKsUGRs/LByo+w5ERtMCWDzxs8u3ujz1YE=;
	b=YGCyAyUHT9nOcQB2FxoligXVUMb65mQKaEqj2yRKxnJAQ0JGA/FGH9r/6CcCAfszU0vNcB
	LPzIy3ahyabXBgefu27EmrIcEOOXfqPXVQhw1oN9Q94ZZsB0HK4uITaskNdn9Jnaf2QYng
	RnDKDfN3zhJBYavYJ/Pe39MlKY5TiBg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-YuhHiwHlMEqDXFGbzldlhg-1; Thu,
 29 Feb 2024 23:32:38 -0500
X-MC-Unique: YuhHiwHlMEqDXFGbzldlhg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BDC41C05AC9;
	Fri,  1 Mar 2024 04:32:38 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74507C185C0;
	Fri,  1 Mar 2024 04:32:38 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6FF06A15F1; Thu, 29 Feb 2024 23:32:38 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo memory-alloc: rename vdo_do_allocation to __vdo_do_allocation
Date: Thu, 29 Feb 2024 23:32:38 -0500
Message-ID: <2e2e4b079c241492d8b22cc9e75038c3dcf3305c.1709267399.git.msakai@redhat.com>
In-Reply-To: <cover.1709267399.git.msakai@redhat.com>
References: <cover.1709267399.git.msakai@redhat.com>
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

__vdo_do_allocation shouldn't be used outside of memory-alloc.h, so
add hidden prefix.

Also, tabify the vdo_allocate_extended macro.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 3f27dd722a2d..1401843db5e0 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -37,8 +37,8 @@ int __must_check vdo_allocate_memory(size_t size, size_t align, const char *what
  *
  * Return: UDS_SUCCESS or an error code
  */
-static inline int vdo_do_allocation(size_t count, size_t size, size_t extra,
-				    size_t align, const char *what, void *ptr)
+static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
+				      size_t align, const char *what, void *ptr)
 {
 	size_t total_size = count * size + extra;
 
@@ -68,7 +68,7 @@ static inline int vdo_do_allocation(size_t count, size_t size, size_t extra,
  * Return: UDS_SUCCESS or an error code
  */
 #define vdo_allocate(COUNT, TYPE, WHAT, PTR) \
-	vdo_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
+	__vdo_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
 
 /*
  * Allocate one object of an indicated type, followed by one or more elements of a second type,
@@ -83,18 +83,18 @@ static inline int vdo_do_allocation(size_t count, size_t size, size_t extra,
  *
  * Return: UDS_SUCCESS or an error code
  */
-#define vdo_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)            \
-	__extension__({                                                  \
-		int _result;						 \
-		TYPE1 **_ptr = (PTR);                                    \
-		BUILD_BUG_ON(__alignof__(TYPE1) < __alignof__(TYPE2));   \
-		_result = vdo_do_allocation(COUNT,                       \
-					    sizeof(TYPE2),               \
-					    sizeof(TYPE1),               \
-					    __alignof__(TYPE1),          \
-					    WHAT,                        \
-					    _ptr);                       \
-		_result;                                                 \
+#define vdo_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)		\
+	__extension__({							\
+		int _result;						\
+		TYPE1 **_ptr = (PTR);					\
+		BUILD_BUG_ON(__alignof__(TYPE1) < __alignof__(TYPE2));	\
+		_result = __vdo_do_allocation(COUNT,			\
+					      sizeof(TYPE2),		\
+					      sizeof(TYPE1),		\
+					      __alignof__(TYPE1),	\
+					      WHAT,			\
+					      _ptr);			\
+		_result;						\
 	})
 
 /*
-- 
2.42.0

