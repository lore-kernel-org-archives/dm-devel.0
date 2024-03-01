Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D861E2F53
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265535; cv=none; b=eK3sW0eVU7zKy/dg4i4NjQ+JDavkaQbEnVDy8IlHV+sdLVhJy9fhnIi4mSPJccYc9+QgsVHXrbNATy2w74FyKw1I7nKy7+Rz1Fqbw1OnO2KtXsNZM7n6PxsVCaJwjKV63yN4EP4m95SHs2J4kYR9fWtx7ot42b0lxy45EVKApQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265535; c=relaxed/simple;
	bh=RM/yVkQHH2XbCZsdK+FT6Xdpha1k66S+i5SxxQ2kRY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fuvfo2OLxMuKdhieWf9pvZoxUx0prgA64nsrBl3LNjUkXGxElIFu4uRO7Yy2Fc/1cp/d2I/l/J7kIhiOvZpSJLQwI6qyymA7zJb6mvNdMRO5bug6pClmqtWafTEup1h20UGQIT0ncDG3VyMecJeNQ+ID5KDxz1+Chf2KsqHmOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RqEhbbpd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RqEhbbpd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ag+zhssmg3biBOtlubtT8YTcwcy/d7aVeEYjjUJ4wc8=;
	b=RqEhbbpdiPk8iGw6y0jc1Jz+jLknexCNV+eLXJSSsubdl+VRoNVDx32Ci4UyZ1VKEP3xj2
	1rH5Q9SAngi3JhKfTnM4huithJefU5wDpCHc+Bha8ZSEyw8LIT5V8iWe52qYoCDe7uA1KG
	cDP3V6N93VpIwR9nwZFBzn+4/JO2/4o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-eRCCR-vgPfWFfuLMGzEewg-1; Thu, 29 Feb 2024 22:58:51 -0500
X-MC-Unique: eRCCR-vgPfWFfuLMGzEewg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B271185A784
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:58:51 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 525C4C0348C;
	Fri,  1 Mar 2024 03:58:51 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4C9FF9F80C; Thu, 29 Feb 2024 22:58:51 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo: remove internal ticket references from indexer
Date: Thu, 29 Feb 2024 22:58:50 -0500
Message-ID: <a068349e8bc97f7928c21d9f3b623c913add5709.1709265262.git.msakai@redhat.com>
In-Reply-To: <cover.1709265262.git.msakai@redhat.com>
References: <cover.1709265262.git.msakai@redhat.com>
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

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.c | 8 ++++----
 drivers/md/dm-vdo/sparse-cache.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 3b2bda9248cb..5cd387f9294e 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -235,8 +235,8 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 		if (p == NULL) {
 			/*
 			 * It is possible for kmalloc to fail to allocate memory because there is
-			 * no page available (see VDO-3688). A short sleep may allow the page
-			 * reclaimer to free a page.
+			 * no page available. A short sleep may allow the page reclaimer to
+			 * free a page.
 			 */
 			fsleep(1000);
 			p = kmalloc(size, gfp_flags);
@@ -251,8 +251,8 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 		    UDS_SUCCESS) {
 			/*
 			 * It is possible for __vmalloc to fail to allocate memory because there
-			 * are no pages available (see VDO-3661). A short sleep may allow the page
-			 * reclaimer to free enough pages for a small allocation.
+			 * are no pages available. A short sleep may allow the page reclaimer
+			 * to free enough pages for a small allocation.
 			 *
 			 * For larger allocations, the page_alloc code is racing against the page
 			 * reclaimer. If the page reclaimer can stay ahead of page_alloc, the
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index 216c8d6256a9..b43a626a42de 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -191,7 +191,7 @@ static inline void __down(struct semaphore *semaphore)
 		 * happens, sleep briefly to avoid keeping the CPU locked up in
 		 * this loop. We could just call cond_resched, but then we'd
 		 * still keep consuming CPU time slices and swamp other threads
-		 * trying to do computational work. [VDO-4980]
+		 * trying to do computational work.
 		 */
 		fsleep(1000);
 	}
-- 
2.42.0

