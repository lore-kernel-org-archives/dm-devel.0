Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3406EB65C
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322955; cv=none; b=pk3LbB45rbGLMk3OGlIcYNV7dSYThu64GIWz6Met5J+VYzZ+aNsCn6Im2ipyFkGB4fGpn7cW4Qml7GUDtjsKrsOa61Yp7uKKjfF97UmM0n/LR8VqDluiwX4/DNytkUnSKt+yiCK58VNxu3aurfJjet8Fncb7Lq5qZzravyi4N4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322955; c=relaxed/simple;
	bh=7+16x9S2keM3gIhEh6E7x2bFKGS6K7PhrevswNenfgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WaCRGl3lBN3Rz1D56FCl1V5wmvwbBO/yp3PxaqAVVney9fuLpdz0n3W3tPASrVXuRfKp1CuUxuFcf/kkzuG0EnEgXOOy9iAyvpFeNup2kB5MWg8QCBtKMcLCW7zynBz89vd94tACpO7akaPtdEUFEO2ulsPqjB/b/AZoNC/1Eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cwCbkJxP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwCbkJxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706322953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6r2qehB/ngNMLkkPh0sJKGMbg6Db5fJinTPw9GaJaEY=;
	b=cwCbkJxPeDZqIBb723ZvVo5MZLqwrEDEH5WOFZb5tnVFbTFqlU4pGzOKPcjhdd+vLbvXeu
	lTTE/E1VNcAJYuhQFLRbCt3b5XRyCFkh18lbEJyJonOWcFhzuU/G7XQuI0ZCG27qoB2imy
	NbJJgu9D/0zNhnwGsTqmsSDPRZK2LRU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-aWBocmNdNum2wZ0bmAYYsg-1; Fri, 26 Jan 2024 21:35:49 -0500
X-MC-Unique: aWBocmNdNum2wZ0bmAYYsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FA6C837226;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 599AC1C060B1;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4D1BE560C1; Fri, 26 Jan 2024 21:35:49 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/5] dm vdo block-map: fix a few small nits
Date: Fri, 26 Jan 2024 21:35:45 -0500
Message-ID: <f2b1a7b041dba5d37fb205516397b72f09d6e9cb.1706322049.git.msakai@redhat.com>
In-Reply-To: <cover.1706322049.git.msakai@redhat.com>
References: <cover.1706322049.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename 'pages' to 'num_pages' in distribute_page_over_waitq().
Update assert message in validate_completed_page() to model others.
Tweak line-wrapping on a comment that was needlessly long.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index f9f68e8d4b0c..64f893b0721a 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -535,19 +535,19 @@ static void complete_waiter_with_page(struct vdo_waiter *waiter, void *page_info
 static unsigned int distribute_page_over_waitq(struct page_info *info,
 					       struct vdo_wait_queue *waitq)
 {
-	size_t pages;
+	size_t num_pages;
 
 	update_lru(info);
-	pages = vdo_waitq_num_waiters(waitq);
+	num_pages = vdo_waitq_num_waiters(waitq);
 
 	/*
 	 * Increment the busy count once for each pending completion so that this page does not
 	 * stop being busy until all completions have been processed (VDO-83).
 	 */
-	info->busy += pages;
+	info->busy += num_pages;
 
 	vdo_waitq_notify_all_waiters(waitq, complete_waiter_with_page, info);
-	return pages;
+	return num_pages;
 }
 
 /**
@@ -614,7 +614,8 @@ static int __must_check validate_completed_page(struct vdo_page_completion *comp
 		return result;
 
 	if (writable) {
-		result = ASSERT(completion->writable, "VDO Page Completion is writable");
+		result = ASSERT(completion->writable,
+				"VDO Page Completion must be writable");
 		if (result != UDS_SUCCESS)
 			return result;
 	}
@@ -741,8 +742,8 @@ static void handle_rebuild_read_error(struct vdo_completion *completion)
 	assert_on_cache_thread(cache, __func__);
 
 	/*
-	 * We are doing a read-only rebuild, so treat this as a successful read of an uninitialized
-	 * page.
+	 * We are doing a read-only rebuild, so treat this as a successful read
+	 * of an uninitialized page.
 	 */
 	vio_record_metadata_io_error(as_vio(completion));
 	ADD_ONCE(cache->stats.failed_reads, 1);
-- 
2.42.0

