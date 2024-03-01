Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2954776F
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265190; cv=none; b=dn7PYjRGLA4dufa4zTOteG6Fm68vryCXrvZRujOE0ZNnti1C8gNlc+uTLyIluvoAB2t+fqo+AXPZ4h79Lpy4erqhbMQtOLQtadl6L8DRk1ozH5qlj+/0k9M4qAqAqCy1b0HX0LCZzh7I15cyDq0usvbKpngv/3sRVwvPwanexDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265190; c=relaxed/simple;
	bh=BuusVIOQhqXevUKQsajY+IYQyczcPAKl1u3sgh6/hNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMS6HAxArJXKqjPoF6FPuFu6hoMnDcy0dT28J/XIiejJmkZyWqV2n0RjQPEVfrn753L9GJSvYNYLsfMqpmKaRXjMtfyjCyp6xpmrTSDwnyZKW3z0yr+zvUm+EzEvv+FRrodz+c2nmHYuMKd0SsVly6HX4m+QE62Au+psV5yWsUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hivk0ReJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hivk0ReJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKautf/gT3LLV6qTZmonhDS/2IRA2liUxESgcUd4vJ8=;
	b=hivk0ReJYPmKvv/71volBFiIAfDE2vkDfiL2P3fG/AbXZx5W1t4GrXgq94ywapS96LW2Ka
	nkO50foaVAn/hLNPuaWb7pJuhy6evESpIvAjZDJIOWs4aui7zw4OlnCCh7/IZHsZyqwoYI
	+foztat0Qlvv8W6IGAS9EjunpljP4Tk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-IX-MPu2hO3y1088eKH89sA-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: IX-MPu2hO3y1088eKH89sA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F783859701;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6940E2166B33;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 66C289EB2F; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 07/13] dm vdo: fold thread-cond-var.c into thread-utils
Date: Thu, 29 Feb 2024 22:52:59 -0500
Message-ID: <c7ee6402475696f93f21613bfd7d7ecca4744b40.1709264538.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Further cleanup is needed for thread-utils interfaces given many
functions should return void or be removed entirely because they
amount to obfuscation via wrappers.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/Makefile          |  1 -
 drivers/md/dm-vdo/thread-cond-var.c | 46 -----------------------------
 drivers/md/dm-vdo/thread-utils.c    | 11 +++++++
 drivers/md/dm-vdo/thread-utils.h    | 28 ++++++++++++++----
 4 files changed, 34 insertions(+), 52 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/thread-cond-var.c

diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
index be5020b81c47..32266ab04cc1 100644
--- a/drivers/md/dm-vdo/Makefile
+++ b/drivers/md/dm-vdo/Makefile
@@ -48,7 +48,6 @@ dm-vdo-objs := \
 	status-codes.o \
 	string-utils.o \
 	sysfs.o \
-	thread-cond-var.o \
 	thread-device.o \
 	thread-registry.o \
 	thread-utils.o \
diff --git a/drivers/md/dm-vdo/thread-cond-var.c b/drivers/md/dm-vdo/thread-cond-var.c
deleted file mode 100644
index 82b80338b448..000000000000
--- a/drivers/md/dm-vdo/thread-cond-var.c
+++ /dev/null
@@ -1,46 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-#include <linux/jiffies.h>
-#include <linux/minmax.h>
-
-#include "errors.h"
-#include "thread-utils.h"
-#include "time-utils.h"
-
-int uds_init_cond(struct cond_var *cv)
-{
-	init_waitqueue_head(&cv->wait_queue);
-	return UDS_SUCCESS;
-}
-
-int uds_signal_cond(struct cond_var *cv)
-{
-	wake_up(&cv->wait_queue);
-	return UDS_SUCCESS;
-}
-
-int uds_broadcast_cond(struct cond_var *cv)
-{
-	wake_up_all(&cv->wait_queue);
-	return UDS_SUCCESS;
-}
-
-int uds_wait_cond(struct cond_var *cv, struct mutex *mutex)
-{
-	DEFINE_WAIT(__wait);
-
-	prepare_to_wait(&cv->wait_queue, &__wait, TASK_IDLE);
-	uds_unlock_mutex(mutex);
-	schedule();
-	finish_wait(&cv->wait_queue, &__wait);
-	uds_lock_mutex(mutex);
-	return UDS_SUCCESS;
-}
-
-int uds_destroy_cond(struct cond_var *cv)
-{
-	return UDS_SUCCESS;
-}
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index 1a1eb9ae9e33..5d371bfba8ff 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -135,3 +135,14 @@ int uds_join_threads(struct thread *thread)
 	uds_free(thread);
 	return UDS_SUCCESS;
 }
+
+void uds_wait_cond(struct cond_var *cv, struct mutex *mutex)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(&cv->wait_queue, &__wait, TASK_IDLE);
+	uds_unlock_mutex(mutex);
+	schedule();
+	finish_wait(&cv->wait_queue, &__wait);
+	uds_lock_mutex(mutex);
+}
diff --git a/drivers/md/dm-vdo/thread-utils.h b/drivers/md/dm-vdo/thread-utils.h
index 30637dd264cc..c7a5d2d948a4 100644
--- a/drivers/md/dm-vdo/thread-utils.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -31,11 +31,29 @@ void uds_perform_once(atomic_t *once_state, void (*function) (void));
 
 int uds_join_threads(struct thread *thread);
 
-int __must_check uds_init_cond(struct cond_var *cond);
-int uds_signal_cond(struct cond_var *cond);
-int uds_broadcast_cond(struct cond_var *cond);
-int uds_wait_cond(struct cond_var *cond, struct mutex *mutex);
-int uds_destroy_cond(struct cond_var *cond);
+static inline int __must_check uds_init_cond(struct cond_var *cv)
+{
+	init_waitqueue_head(&cv->wait_queue);
+	return UDS_SUCCESS;
+}
+
+static inline void uds_signal_cond(struct cond_var *cv)
+{
+	wake_up(&cv->wait_queue);
+}
+
+static inline void uds_broadcast_cond(struct cond_var *cv)
+{
+	wake_up_all(&cv->wait_queue);
+}
+
+void uds_wait_cond(struct cond_var *cv, struct mutex *mutex);
+
+/* FIXME: all below wrappers should be removed! */
+
+static inline void uds_destroy_cond(struct cond_var *cv)
+{
+}
 
 static inline int __must_check uds_init_mutex(struct mutex *mutex)
 {
-- 
2.42.0

