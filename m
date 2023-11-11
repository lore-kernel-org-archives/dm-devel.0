Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2673B6FC3
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aCwsUkXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9GmA6nh+byOfUJL6jsZoOW+3Cp+wwsxWFKcq/WYI/g8=;
	b=aCwsUkXr2GduEX7rZF7xRPNQ9HPqF9ON/lM8dI9Bafkm1BSxlYtJqC4iYctZcZ82ViUHr0
	xs7/ocoC9A5PC/IoCOWhcMMMmH0tbY76EDCpRXwzz9nqfV1CX6RTuPoMKkXxRAepN3Cwgq
	9CiMrGO9CPm4Wmf3uXkzQBTg+bK54hA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-rpCQgFTcMVGGrr5YsTRLQg-1; Fri, 10 Nov 2023 23:30:46 -0500
X-MC-Unique: rpCQgFTcMVGGrr5YsTRLQg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3674A101A550;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C381492BE7;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id D6A543003C; Fri, 10 Nov 2023 23:30:45 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 6/8] dm vdo memory-alloc: rename uds_free_memory to uds_free
Date: Fri, 10 Nov 2023 23:30:42 -0500
Message-Id: <3d6e9fdff41d56b50ce0b20a9b9ad9bbf5a2b634.1699675570.git.msakai@redhat.com>
In-Reply-To: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
References: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.c | 2 +-
 drivers/md/dm-vdo/memory-alloc.h | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 81069698dd5a..136a19db33be 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -319,7 +319,7 @@ void *uds_allocate_memory_nowait(size_t size, const char *what __maybe_unused)
 	return p;
 }
 
-void uds_free_memory(void *ptr)
+void uds_free(void *ptr)
 {
 	if (ptr != NULL) {
 		if (is_vmalloc_addr(ptr)) {
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 1429d5173dbd..76789f357e00 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -16,10 +16,8 @@
 
 int __must_check uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr);
 
-void uds_free_memory(void *ptr);
-
 /* Free memory allocated with uds_allocate(). */
-#define uds_free(PTR) uds_free_memory(PTR)
+void uds_free(void *ptr);
 
 static inline void *__uds_forget(void **ptr_ptr)
 {
-- 
2.40.0

