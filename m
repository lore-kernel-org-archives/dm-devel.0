Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4533A3A291
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhbJkzau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GazJbm+Edelo8Okl0Y7yj3zYgSsHXqmSc+x6WkJpXD4=;
	b=dhbJkzaubQCh+l/TnjDFmmN1x2QRoTMzAlkycRUr0/Rq7G/YT3oSkmSLgy+7vC36n7PO4f
	GZW8wK2meN9KoFlmZQVOyEpLUJ7W15EF16IjmzeQCSqfveTIsJBapUeiVONfYQDy37m53R
	hFuk3SFzLBiUnZc9huTvK3CtU+HOHHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-iWDiKkDjMoOadToXVPEvsA-1; Mon, 20 Nov 2023 17:29:21 -0500
X-MC-Unique: iWDiKkDjMoOadToXVPEvsA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 217D08533D4;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C2B4492BE0;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 1A25D51CCE; Mon, 20 Nov 2023 17:29:21 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/5] dm vdo wait-queue: optimize vdo_waitq_dequeue_matching_waiters
Date: Mon, 20 Nov 2023 17:29:18 -0500
Message-ID: <0253e36543d5030cab7b5ead05850f085692a329.1700516271.git.msakai@redhat.com>
In-Reply-To: <cover.1700516271.git.msakai@redhat.com>
References: <cover.1700516271.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Remove temporary 'matched_waiters' waitq and just enqueue matched
waiters directly to the caller provided 'matched_waitq'.

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/wait-queue.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-vdo/wait-queue.c b/drivers/md/dm-vdo/wait-queue.c
index 4231d3243fa1..7e4cf9f03249 100644
--- a/drivers/md/dm-vdo/wait-queue.c
+++ b/drivers/md/dm-vdo/wait-queue.c
@@ -129,10 +129,8 @@ void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
 					void *match_context,
 					struct vdo_wait_queue *matched_waitq)
 {
-	// FIXME: copying a waitq just to iterate it, with matching, is unfortunate
-	struct vdo_wait_queue matched_waiters, iteration_waitq;
+	struct vdo_wait_queue iteration_waitq;
 
-	vdo_waitq_init(&matched_waiters);
 	vdo_waitq_init(&iteration_waitq);
 	vdo_waitq_transfer_all_waiters(waitq, &iteration_waitq);
 
@@ -140,10 +138,8 @@ void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
 		struct vdo_waiter *waiter = vdo_waitq_dequeue_next_waiter(&iteration_waitq);
 
 		vdo_waitq_enqueue_waiter((waiter_match(waiter, match_context) ?
-					  &matched_waiters : waitq), waiter);
+					  matched_waitq : waitq), waiter);
 	}
-
-	vdo_waitq_transfer_all_waiters(&matched_waiters, matched_waitq);
 }
 
 /**
-- 
2.42.0

