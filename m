Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3422B4642B
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265191; cv=none; b=ijzpeU0aq7WDYt7YSqdhAUbqy4yBziT1/UOkFVW347cdXGzTUSuwrAPHiHgZSi3qMfidhPQ6yySURl66AHIJ4AjL1JsGpTXUawx0YQgpEZ29K3l25GsXO79Et6bZB73oZb8y6uDRZWnllI/zFtlsiGbyisnuFfA8vN531JVpf/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265191; c=relaxed/simple;
	bh=jefC1JxriJ5jUJvkZd6Vg1T6E5a0VQnAxlNxl1FHR9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2RpcUdc00wLc72DceS+6CQWLIOBdPiVCSX1SESphMOOmD7JeUJcR/9CGXfeoZ9JvFjklRVPHeVwAOglVNCbadSfhENHeMMOd2ECjdj8S9SuaeWjtFnGcDksZtx3OL1stpHDnXlqqnVOwG1c/dMnuvi6WHjEZubt6dxp71JXVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iECtCZTh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iECtCZTh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RFT8EmHvbijxNAAai7LY5XQ36XQoDHuzIcaTSreBBvA=;
	b=iECtCZThB5wlMpSSNKDGd0ywt1qFPO4EWNthEp5vbZrhlzG+s5D0KweoxldUUR/fJdpEot
	v4Uxb+5XIpbrPeJHbYG2hvKQfJQreC9X+8q9QJMZ3d800L1eTCwu8q7G2A4O+jhsKmvkGv
	h0M+q9EaMAzfq3zQ7V23aGtd/+L/ESE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-eMy85RMiP9SXGMevkJqc2g-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: eMy85RMiP9SXGMevkJqc2g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 578B783B821;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 52518492BC6;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4C1E79EB25; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 02/13] dm vdo uds-threads: eliminate uds_*_semaphore interfaces
Date: Thu, 29 Feb 2024 22:52:54 -0500
Message-ID: <750100ca8c0916440c9f8079eccd3ea7140672b5.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
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

The implementation of thread 'barrier' data structure does not require
overdone private semaphore wrappers.  Also rename the barrier
structure's 'mutex' member (a semaphore) to 'lock'.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/uds-threads.c | 55 ++++++++-------------------------
 drivers/md/dm-vdo/uds-threads.h |  4 +--
 2 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
index 33117f68cf36..af6c58eaf449 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -136,19 +136,7 @@ int uds_join_threads(struct thread *thread)
 	return UDS_SUCCESS;
 }
 
-static inline int __must_check uds_initialize_semaphore(struct semaphore *semaphore,
-							unsigned int value)
-{
-	sema_init(semaphore, value);
-	return UDS_SUCCESS;
-}
-
-static inline int uds_destroy_semaphore(struct semaphore *semaphore)
-{
-	return UDS_SUCCESS;
-}
-
-static inline void uds_acquire_semaphore(struct semaphore *semaphore)
+static inline void __down(struct semaphore *semaphore)
 {
 	/*
 	 * Do not use down(semaphore). Instead use down_interruptible so that
@@ -169,53 +157,36 @@ static inline void uds_acquire_semaphore(struct semaphore *semaphore)
 	}
 }
 
-static inline void uds_release_semaphore(struct semaphore *semaphore)
-{
-	up(semaphore);
-}
-
 int uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count)
 {
-	int result;
-
-	/* FIXME: must cleanup, uds_initialize_semaphore never fails! */
-	result = uds_initialize_semaphore(&barrier->mutex, 1);
-	if (result != UDS_SUCCESS)
-		return result;
-
+	sema_init(&barrier->lock, 1);
 	barrier->arrived = 0;
 	barrier->thread_count = thread_count;
-	return uds_initialize_semaphore(&barrier->wait, 0);
+	sema_init(&barrier->wait, 0);
+
+	return UDS_SUCCESS;
 }
 
 int uds_destroy_barrier(struct barrier *barrier)
 {
-	int result;
-
-	result = uds_destroy_semaphore(&barrier->mutex);
-	if (result != UDS_SUCCESS)
-		return result;
-
-	return uds_destroy_semaphore(&barrier->wait);
+	return UDS_SUCCESS;
 }
 
 int uds_enter_barrier(struct barrier *barrier)
 {
-	bool last_thread;
-
-	uds_acquire_semaphore(&barrier->mutex);
-	last_thread = (++barrier->arrived == barrier->thread_count);
-	if (last_thread) {
+	__down(&barrier->lock);
+	if (++barrier->arrived == barrier->thread_count) {
+		/* last thread */
 		int i;
 
 		for (i = 1; i < barrier->thread_count; i++)
-			uds_release_semaphore(&barrier->wait);
+			up(&barrier->wait);
 
 		barrier->arrived = 0;
-		uds_release_semaphore(&barrier->mutex);
+		up(&barrier->lock);
 	} else {
-		uds_release_semaphore(&barrier->mutex);
-		uds_acquire_semaphore(&barrier->wait);
+		up(&barrier->lock);
+		__down(&barrier->wait);
 	}
 
 	return UDS_SUCCESS;
diff --git a/drivers/md/dm-vdo/uds-threads.h b/drivers/md/dm-vdo/uds-threads.h
index b77a2d46da80..e6fa32af1feb 100644
--- a/drivers/md/dm-vdo/uds-threads.h
+++ b/drivers/md/dm-vdo/uds-threads.h
@@ -25,8 +25,8 @@ struct cond_var {
 struct thread;
 
 struct barrier {
-	/* Mutex for this barrier object */
-	struct semaphore mutex;
+	/* Lock for this barrier object */
+	struct semaphore lock;
 	/* Semaphore for threads waiting at the barrier */
 	struct semaphore wait;
 	/* Number of threads which have arrived */
-- 
2.42.0

