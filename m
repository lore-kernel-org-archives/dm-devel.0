Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779F056B63
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185069; cv=none; b=I225LNH2D9C7wo6Lsn1hSPY7lEPwPPvfhPPFJ4bG6MczE4iNr4a8rksFVcSL4robLUgpSdW1y4+GobFFAcmUzVKz4Em1NOBvILhNC/pAvnAuVR/EwXQzJVg+1EVm0OybfTrCe0iQSuRkiCCfeySoYDoQxYk6DPJrJpK4gIc2aMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185069; c=relaxed/simple;
	bh=QjCEwke2q8md+7XYXgP0M4hWqJ6rqzuJXuo/F2COq6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cpn8jEGxbq5DZrHATUixzQg4Dpwkz+5oL8/8TWRRJpeHB+R0VmtybqNKxDlftMl7xmRrmw5PInPo2wRESl9pXeypElvMlMyGsla8otit7GzS6Mqc39EbiReLZK60rCyA05F0mRlkG8bjxAHt5lpyRPWglzDd1WYZNIhzS9VNb4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Na7epnFr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Na7epnFr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NsTg64+GPsxKmgqRI9XjEW4h5kvap/d+2pnLf1r3Y6A=;
	b=Na7epnFrMFZLylLNvA5KHwOamsmsgsxqIa2hzxkdvJeTpesCtDfULdi7nFuP2fckhjCGvM
	SoKvomq7GW9M+7S0J8TgS5CpnQcdIMUWOFtwMDIdlnOnlgCZpiyoH76geqH4CzVxdDnrNI
	yfAr6xm9TbXiUw/hAUrVzJqeFeZdO5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-anSpZxPlOcOmy9gCheYTHw-1; Mon, 05 Feb 2024 21:04:23 -0500
X-MC-Unique: anSpZxPlOcOmy9gCheYTHw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4F0884ACA2;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FE37492BC7;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 9E759569FE; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/7] dm vdo data-vio: silence sparse warnings about locking context imbalances
Date: Mon,  5 Feb 2024 21:04:19 -0500
Message-ID: <b9361ea21d6a946e532e344b6d6c18f31c3d5aef.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
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

Factor wait_permit() out from acquire_permit() so that the latter
always holds the spinlock and the former always releases it.

Otherwise sparse complains about locking context imbalances due to
conditional spin_unlock in acquire_permit:
 warning: context imbalance in 'acquire_permit' - different lock contexts for basic block
 warning: context imbalance in 'vdo_launch_bio' - unexpected unlock

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/data-vio.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index e0f1574ae112..d77adeb5006e 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -929,27 +929,30 @@ void free_data_vio_pool(struct data_vio_pool *pool)
 	uds_free(pool);
 }
 
-static bool acquire_permit(struct limiter *limiter, struct bio *bio)
+static bool acquire_permit(struct limiter *limiter)
 {
-	if (limiter->busy >= limiter->limit) {
-		DEFINE_WAIT(wait);
-
-		bio_list_add(&limiter->new_waiters, bio);
-		prepare_to_wait_exclusive(&limiter->blocked_threads, &wait,
-					  TASK_UNINTERRUPTIBLE);
-		spin_unlock(&limiter->pool->lock);
-		io_schedule();
-		finish_wait(&limiter->blocked_threads, &wait);
+	if (limiter->busy >= limiter->limit)
 		return false;
-	}
 
 	WRITE_ONCE(limiter->busy, limiter->busy + 1);
 	if (limiter->max_busy < limiter->busy)
 		WRITE_ONCE(limiter->max_busy, limiter->busy);
-
 	return true;
 }
 
+static void wait_permit(struct limiter *limiter, struct bio *bio)
+	__releases(&limiter->pool->lock)
+{
+	DEFINE_WAIT(wait);
+
+	bio_list_add(&limiter->new_waiters, bio);
+	prepare_to_wait_exclusive(&limiter->blocked_threads, &wait,
+				  TASK_UNINTERRUPTIBLE);
+	spin_unlock(&limiter->pool->lock);
+	io_schedule();
+	finish_wait(&limiter->blocked_threads, &wait);
+}
+
 /**
  * vdo_launch_bio() - Acquire a data_vio from the pool, assign the bio to it, and launch it.
  *
@@ -965,11 +968,15 @@ void vdo_launch_bio(struct data_vio_pool *pool, struct bio *bio)
 	bio->bi_private = (void *) jiffies;
 	spin_lock(&pool->lock);
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
-	    !acquire_permit(&pool->discard_limiter, bio))
+	    !acquire_permit(&pool->discard_limiter)) {
+		wait_permit(&pool->discard_limiter, bio);
 		return;
+	}
 
-	if (!acquire_permit(&pool->limiter, bio))
+	if (!acquire_permit(&pool->limiter)) {
+		wait_permit(&pool->limiter, bio);
 		return;
+	}
 
 	data_vio = get_available_data_vio(pool);
 	spin_unlock(&pool->lock);
-- 
2.42.0

