Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340359475
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322955; cv=none; b=KqMTG8YA6Pkpr3bUJnCyJe4xakC3h66LpOo4oYUEAutXtU3UQKGDKQLHeF74bwRwqbgF+BF/APXxLC0yoBIgxPCUZljryun1LVwg/+nzaoaFF6Q0lrUjVToxR8v1RzNsBhu4AIDXIF0iGJHCjJ+aGzT8MO8NbM5YGaH5Z4QhXh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322955; c=relaxed/simple;
	bh=OH3ve7NjkQj9p6qNtHcEMba1LUh3XjamBSno+bR35xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPUwoY3bNCXtgID2+mJgzYOSttk/SKwC2Gd21cS72AmRzJqL/DEGR6QNTCZYOyzGBWENtW/j8Ww91kpEHRPRULlKpTMqkRdnYG/5tdMFpXrLCBW+u1le4363kDxJOpdUmMc96bl/5GrJz2hN7ykW024yUzyZertEkUcShMBjBhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIzjB34l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIzjB34l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706322953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzzGLrD8hQckS8ozwHpH7C97fefB70tFTutgnlboENg=;
	b=RIzjB34ltm6ZIRx0467XvH9m6pSkLjLgrDLjqLaIa4UOgH4J1sBU2v2HIeoLbelWT/Q7rR
	OBOqe94px9zaaBLgATmztAb1DACyrz/oSZZGcmDhzRaZIJTPzAOQ+qXPqo9e15oY/29Vhk
	ka3Kht/871gEzko4YNybiDqsb/1yly4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-2JqvhwU3MhyCRw57nUEZmg-1; Fri, 26 Jan 2024 21:35:49 -0500
X-MC-Unique: 2JqvhwU3MhyCRw57nUEZmg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68508827D8C;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62BB0492BE3;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5F6C3560C7; Fri, 26 Jan 2024 21:35:49 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/5] dm vdo block-map: avoid extra dereferences to access vdo object
Date: Fri, 26 Jan 2024 21:35:48 -0500
Message-ID: <5ccfb6d5622877f57b5f8329a42e7aaad7d9a997.1706322049.git.msakai@redhat.com>
In-Reply-To: <cover.1706322049.git.msakai@redhat.com>
References: <cover.1706322049.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

The vdo_page_cache's 'vdo' is the same as the block_map's vdo
instance, so use that to save 2 extra dereferences.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index eda42383a2c1..0ce136612869 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -562,7 +562,7 @@ static void set_persistent_error(struct vdo_page_cache *cache, const char *conte
 {
 	struct page_info *info;
 	/* If we're already read-only, there's no need to log. */
-	struct vdo *vdo = cache->zone->block_map->vdo;
+	struct vdo *vdo = cache->vdo;
 
 	if ((result != VDO_READ_ONLY) && !vdo_is_read_only(vdo)) {
 		uds_log_error_strerror(result, "VDO Page Cache persistent error: %s",
@@ -1111,7 +1111,7 @@ static void write_pages(struct vdo_completion *flush_completion)
 					 state_entry);
 
 		list_del_init(&info->state_entry);
-		if (vdo_is_read_only(info->cache->zone->block_map->vdo)) {
+		if (vdo_is_read_only(info->cache->vdo)) {
 			struct vdo_completion *completion = &info->vio->completion;
 
 			vdo_reset_completion(completion);
@@ -1233,7 +1233,7 @@ void vdo_get_page(struct vdo_page_completion *page_completion,
 			       cache->zone->thread_id, parent);
 	completion->requeue = requeue;
 
-	if (page_completion->writable && vdo_is_read_only(cache->zone->block_map->vdo)) {
+	if (page_completion->writable && vdo_is_read_only(cache->vdo)) {
 		vdo_fail_completion(completion, VDO_READ_ONLY);
 		return;
 	}
-- 
2.42.0

