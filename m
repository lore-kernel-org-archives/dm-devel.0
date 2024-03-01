Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137B647F6A
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265191; cv=none; b=aY+s9HOLcxlb2itD8VOALJISAbKpwx7D1rMBpd9zyG3Rzk/y2tCLwXcl3v9HchGGTBafzBqy/Cnf5AzgJdyKiHSTnaqqF8XLNxqza4Gfmp1/zO5ZZeeVN4qCABPIi71V280rFu+3JuhjwJYSpBM6oMPiCalp3ivlvwueEh63biI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265191; c=relaxed/simple;
	bh=D7U9hSbDasVLHjpnK4dppPfl8pL9qfBVigNj3njzXSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMSmWhucIAydncdz4PB8mKJIrQMjGE27Sk0pQDuWJCr9UqMesU+4njQ8r18Z9yYZcUKtgl6b0Tywmc4pfBdwwNOP3RJcl2CqWULPiuqiczB59l0O5MDBFYgBS6XwsD8sFxe0szyCEV6zHgGozbYWs8RiBZYvsDSukeJNNFQu6Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ww4BRzD/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ww4BRzD/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HflpPtgl903xa7xaxDkYrdU2AaDhWyx3LcvgLKjcPHA=;
	b=Ww4BRzD/r3iIlE4fLS0yBp+ENfgiExqSyc1iQu/xsE4BZDqDLx0kuY0JMOTNNFnwPMIkHK
	OAVxwmL2vQBlW94ESBGzIh4Z5gEFnJ2iOS0iU1Back6Je1dJ7x7aX/FtOT2Sso+yorE8+c
	VX6pJb8vIg832pASC2xSkNN6qb+MCZc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365--bTWCsUSMpqgAGLFCTzIGg-1; Thu,
 29 Feb 2024 22:53:05 -0500
X-MC-Unique: -bTWCsUSMpqgAGLFCTzIGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55F203C0C48E;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EA3C1BDB1;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 46CD39EB23; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 01/13] dm vdo: make uds_*_semaphore interface private to uds-threads.c
Date: Thu, 29 Feb 2024 22:52:53 -0500
Message-ID: <dbdb8036783597e27b85a33852c3b7acea40fb6e.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
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

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/uds-threads.c | 39 +++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/uds-threads.h | 37 -------------------------------
 2 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
index 769c783e342a..33117f68cf36 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -136,10 +136,49 @@ int uds_join_threads(struct thread *thread)
 	return UDS_SUCCESS;
 }
 
+static inline int __must_check uds_initialize_semaphore(struct semaphore *semaphore,
+							unsigned int value)
+{
+	sema_init(semaphore, value);
+	return UDS_SUCCESS;
+}
+
+static inline int uds_destroy_semaphore(struct semaphore *semaphore)
+{
+	return UDS_SUCCESS;
+}
+
+static inline void uds_acquire_semaphore(struct semaphore *semaphore)
+{
+	/*
+	 * Do not use down(semaphore). Instead use down_interruptible so that
+	 * we do not get 120 second stall messages in kern.log.
+	 */
+	while (down_interruptible(semaphore) != 0) {
+		/*
+		 * If we're called from a user-mode process (e.g., "dmsetup
+		 * remove") while waiting for an operation that may take a
+		 * while (e.g., UDS index save), and a signal is sent (SIGINT,
+		 * SIGUSR2), then down_interruptible will not block. If that
+		 * happens, sleep briefly to avoid keeping the CPU locked up in
+		 * this loop. We could just call cond_resched, but then we'd
+		 * still keep consuming CPU time slices and swamp other threads
+		 * trying to do computational work. [VDO-4980]
+		 */
+		fsleep(1000);
+	}
+}
+
+static inline void uds_release_semaphore(struct semaphore *semaphore)
+{
+	up(semaphore);
+}
+
 int uds_initialize_barrier(struct barrier *barrier, unsigned int thread_count)
 {
 	int result;
 
+	/* FIXME: must cleanup, uds_initialize_semaphore never fails! */
 	result = uds_initialize_semaphore(&barrier->mutex, 1);
 	if (result != UDS_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/uds-threads.h b/drivers/md/dm-vdo/uds-threads.h
index 9f3bf7991383..b77a2d46da80 100644
--- a/drivers/md/dm-vdo/uds-threads.h
+++ b/drivers/md/dm-vdo/uds-threads.h
@@ -74,42 +74,5 @@ static inline void uds_unlock_mutex(struct mutex *mutex)
 	mutex_unlock(mutex);
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
-{
-	/*
-	 * Do not use down(semaphore). Instead use down_interruptible so that
-	 * we do not get 120 second stall messages in kern.log.
-	 */
-	while (down_interruptible(semaphore) != 0) {
-		/*
-		 * If we're called from a user-mode process (e.g., "dmsetup
-		 * remove") while waiting for an operation that may take a
-		 * while (e.g., UDS index save), and a signal is sent (SIGINT,
-		 * SIGUSR2), then down_interruptible will not block. If that
-		 * happens, sleep briefly to avoid keeping the CPU locked up in
-		 * this loop. We could just call cond_resched, but then we'd
-		 * still keep consuming CPU time slices and swamp other threads
-		 * trying to do computational work. [VDO-4980]
-		 */
-		fsleep(1000);
-	}
-}
-
-static inline void uds_release_semaphore(struct semaphore *semaphore)
-{
-	up(semaphore);
-}
 
 #endif /* UDS_THREADS_H */
-- 
2.42.0

