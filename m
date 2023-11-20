Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE783A27F
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMCI20+X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YtqvjJx4w69N0cI3MmIZXs4DO/L+e+eWvqKYYPtrz4=;
	b=SMCI20+Xa/G3iOnH9i8luo8K0wQLsDcaNejNmGFiUIRYwUYssO7+Uh/KirFjSfa0ypw1Ut
	+NxcWIF8LD+fNkEomec2f4MQ2mfpaJiBoKw4hItD516+Z0aS3J01rO31HxZUs7HrMlhpNB
	Vt69e4WFDtY63v+Lid6wqYCU3DRVZKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-rUpfQyGWP1SGKUbJM-xs-Q-1; Mon, 20 Nov 2023 17:29:21 -0500
X-MC-Unique: rUpfQyGWP1SGKUbJM-xs-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E071101A550;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18A615028;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 13C1451CCC; Mon, 20 Nov 2023 17:29:21 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/5] dm vdo wait-queue: remove unused debug function vdo_waitq_get_next_waiter
Date: Mon, 20 Nov 2023 17:29:17 -0500
Message-ID: <68b5cc8b27c9446be1d2da7824b40dd80a265d94.1700516271.git.msakai@redhat.com>
In-Reply-To: <cover.1700516271.git.msakai@redhat.com>
References: <cover.1700516271.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/wait-queue.c | 18 ------------------
 drivers/md/dm-vdo/wait-queue.h |  3 ---
 2 files changed, 21 deletions(-)

diff --git a/drivers/md/dm-vdo/wait-queue.c b/drivers/md/dm-vdo/wait-queue.c
index 9c12a9893823..4231d3243fa1 100644
--- a/drivers/md/dm-vdo/wait-queue.c
+++ b/drivers/md/dm-vdo/wait-queue.c
@@ -207,21 +207,3 @@ bool vdo_waitq_notify_next_waiter(struct vdo_wait_queue *waitq,
 
 	return true;
 }
-
-/**
- * vdo_waitq_get_next_waiter() - Get the waiter after this one, for debug iteration.
- * @waitq: The vdo_wait_queue.
- * @waiter: A waiter.
- *
- * Return: The next waiter, or NULL.
- */
-const struct vdo_waiter *vdo_waitq_get_next_waiter(const struct vdo_wait_queue *waitq,
-						   const struct vdo_waiter *waiter)
-{
-	struct vdo_waiter *first_waiter = vdo_waitq_get_first_waiter(waitq);
-
-	if (waiter == NULL)
-		return first_waiter;
-
-	return ((waiter->next_waiter != first_waiter) ? waiter->next_waiter : NULL);
-}
diff --git a/drivers/md/dm-vdo/wait-queue.h b/drivers/md/dm-vdo/wait-queue.h
index b92f12dd5b4b..e514bdcf7d32 100644
--- a/drivers/md/dm-vdo/wait-queue.h
+++ b/drivers/md/dm-vdo/wait-queue.h
@@ -135,7 +135,4 @@ static inline size_t __must_check vdo_waitq_num_waiters(const struct vdo_wait_qu
 	return waitq->length;
 }
 
-const struct vdo_waiter * __must_check
-vdo_waitq_get_next_waiter(const struct vdo_wait_queue *waitq, const struct vdo_waiter *waiter);
-
 #endif /* VDO_WAIT_QUEUE_H */
-- 
2.42.0

