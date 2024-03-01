Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9987247796
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265191; cv=none; b=cXn6FlWresMv+WDJ93/WORb4LOzhRoovX/H3AssjUpWjY1N/hpw2bmPpSpiPqWQuAuro4JDvGC9fCmDsc9i+J6n56TGSfPvKGzTMPq9Ru/8IHKFAbijApNtya/xGdMGkqH/FZ292/cwYdvNl6VYXuw2Xf4bakbhV0+/26knb1Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265191; c=relaxed/simple;
	bh=nsSxxZN6LxnSuezxOmspTqsdUw/aZFfrWUemE4TH0/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFrsxkONV1wi7/Y8545n0asDPZLCmooT5pYCKORyay9i84VKjbIBmLbbfGE4gzd0HyGsk2XPMrmHi509n68fqLNHC4qMPQWft2nEdetzgKYUO7Sexc1AquqBKo8D1PM1gwOfW/UrQyU79EL6cS35VkMG0Cwo2/nTZ82GnN1DxPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3pWd+GM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3pWd+GM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WtWPyMbTk58AYr1kvZbcq3mIljo45Od+ZWKXEqBGeo=;
	b=A3pWd+GMyr2GYKG5eUE1cmcSsqknUUPH6UYYbvtmPib48tFpV4qW/ohLI83N2ZybTGBM6o
	eAAdcIM1OeyXxVG+8PF6pktjkVeeoxpTwdU7MKNwVfw5zwtfZbngGelNcQyobC+dSHgVr1
	QZUdJCCNe+giPQyIpxOIBGSF/0T1t8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-m9undeGSP-ahdM8NDIz2Fw-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: m9undeGSP-ahdM8NDIz2Fw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 793BC89F9E2;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7373510793;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 71FB09EB33; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 09/13] dm vdo thread-utils: remove all uds_*_mutex wrappers
Date: Thu, 29 Feb 2024 22:53:01 -0500
Message-ID: <d7d1fa760bffcbba959fe095391d52717e754b6d.1709264538.git.msakai@redhat.com>
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

Just use mutex_init, mutex_lock and mutex_unlock.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/index-session.c | 110 +++++++++++++-----------------
 drivers/md/dm-vdo/index.c         |  42 +++++-------
 drivers/md/dm-vdo/thread-utils.h  |  23 -------
 drivers/md/dm-vdo/volume-index.c  |  40 ++++-------
 drivers/md/dm-vdo/volume.c        |  38 +++++------
 5 files changed, 96 insertions(+), 157 deletions(-)

diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 4837621c16db..a482ccd3981e 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -61,10 +61,10 @@ enum index_session_flag {
 /* Release a reference to an index session. */
 static void release_index_session(struct uds_index_session *index_session)
 {
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	if (--index_session->request_count == 0)
 		uds_broadcast_cond(&index_session->request_cond);
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 }
 
 /*
@@ -76,10 +76,10 @@ static int get_index_session(struct uds_index_session *index_session)
 	unsigned int state;
 	int result = UDS_SUCCESS;
 
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	index_session->request_count++;
 	state = index_session->state;
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 
 	if (state == IS_FLAG_LOADED) {
 		return UDS_SUCCESS;
@@ -141,9 +141,9 @@ static void enter_callback_stage(struct uds_request *request)
 {
 	if (request->status != UDS_SUCCESS) {
 		/* All request errors are considered unrecoverable */
-		uds_lock_mutex(&request->session->request_mutex);
+		mutex_lock(&request->session->request_mutex);
 		request->session->state |= IS_FLAG_DISABLED;
-		uds_unlock_mutex(&request->session->request_mutex);
+		mutex_unlock(&request->session->request_mutex);
 	}
 
 	uds_request_queue_enqueue(request->session->callback_queue, request);
@@ -224,28 +224,14 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_init_mutex(&session->request_mutex);
-	if (result != UDS_SUCCESS) {
-		uds_free(session);
-		return result;
-	}
-
+	mutex_init(&session->request_mutex);
 	uds_init_cond(&session->request_cond);
-
-	result = uds_init_mutex(&session->load_context.mutex);
-	if (result != UDS_SUCCESS) {
-		uds_destroy_mutex(&session->request_mutex);
-		uds_free(session);
-		return result;
-	}
-
+	mutex_init(&session->load_context.mutex);
 	uds_init_cond(&session->load_context.cond);
 
 	result = uds_make_request_queue("callbackW", &handle_callbacks,
 					&session->callback_queue);
 	if (result != UDS_SUCCESS) {
-		uds_destroy_mutex(&session->load_context.mutex);
-		uds_destroy_mutex(&session->request_mutex);
 		uds_free(session);
 		return result;
 	}
@@ -268,7 +254,7 @@ static int __must_check start_loading_index_session(struct uds_index_session *in
 {
 	int result;
 
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	if (index_session->state & IS_FLAG_SUSPENDED) {
 		uds_log_info("Index session is suspended");
 		result = -EBUSY;
@@ -279,20 +265,20 @@ static int __must_check start_loading_index_session(struct uds_index_session *in
 		index_session->state |= IS_FLAG_LOADING;
 		result = UDS_SUCCESS;
 	}
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 	return result;
 }
 
 static void finish_loading_index_session(struct uds_index_session *index_session,
 					 int result)
 {
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	index_session->state &= ~IS_FLAG_LOADING;
 	if (result == UDS_SUCCESS)
 		index_session->state |= IS_FLAG_LOADED;
 
 	uds_broadcast_cond(&index_session->request_cond);
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 }
 
 static int initialize_index_session(struct uds_index_session *index_session,
@@ -376,12 +362,12 @@ int uds_open_index(enum uds_open_index_type open_type,
 
 static void wait_for_no_requests_in_progress(struct uds_index_session *index_session)
 {
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	while (index_session->request_count > 0) {
 		uds_wait_cond(&index_session->request_cond,
 			      &index_session->request_mutex);
 	}
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 }
 
 static int __must_check save_index(struct uds_index_session *index_session)
@@ -392,7 +378,7 @@ static int __must_check save_index(struct uds_index_session *index_session)
 
 static void suspend_rebuild(struct uds_index_session *session)
 {
-	uds_lock_mutex(&session->load_context.mutex);
+	mutex_lock(&session->load_context.mutex);
 	switch (session->load_context.status) {
 	case INDEX_OPENING:
 		session->load_context.status = INDEX_SUSPENDING;
@@ -419,7 +405,7 @@ static void suspend_rebuild(struct uds_index_session *session)
 				session->load_context.status);
 		break;
 	}
-	uds_unlock_mutex(&session->load_context.mutex);
+	mutex_unlock(&session->load_context.mutex);
 }
 
 /*
@@ -433,7 +419,7 @@ int uds_suspend_index_session(struct uds_index_session *session, bool save)
 	bool rebuilding = false;
 
 	/* Wait for any current index state change to complete. */
-	uds_lock_mutex(&session->request_mutex);
+	mutex_lock(&session->request_mutex);
 	while (session->state & IS_FLAG_CLOSING)
 		uds_wait_cond(&session->request_cond, &session->request_mutex);
 
@@ -453,7 +439,7 @@ int uds_suspend_index_session(struct uds_index_session *session, bool save)
 		session->state |= IS_FLAG_SUSPENDED;
 		uds_broadcast_cond(&session->request_cond);
 	}
-	uds_unlock_mutex(&session->request_mutex);
+	mutex_unlock(&session->request_mutex);
 
 	if (no_work)
 		return uds_status_to_errno(result);
@@ -465,11 +451,11 @@ int uds_suspend_index_session(struct uds_index_session *session, bool save)
 	else
 		result = uds_flush_index_session(session);
 
-	uds_lock_mutex(&session->request_mutex);
+	mutex_lock(&session->request_mutex);
 	session->state &= ~IS_FLAG_WAITING;
 	session->state |= IS_FLAG_SUSPENDED;
 	uds_broadcast_cond(&session->request_cond);
-	uds_unlock_mutex(&session->request_mutex);
+	mutex_unlock(&session->request_mutex);
 	return uds_status_to_errno(result);
 }
 
@@ -496,7 +482,7 @@ int uds_resume_index_session(struct uds_index_session *session,
 	bool no_work = false;
 	bool resume_replay = false;
 
-	uds_lock_mutex(&session->request_mutex);
+	mutex_lock(&session->request_mutex);
 	if (session->state & IS_FLAG_WAITING) {
 		uds_log_info("Index session is already changing state");
 		no_work = true;
@@ -510,7 +496,7 @@ int uds_resume_index_session(struct uds_index_session *session,
 		if (session->state & IS_FLAG_LOADING)
 			resume_replay = true;
 	}
-	uds_unlock_mutex(&session->request_mutex);
+	mutex_unlock(&session->request_mutex);
 
 	if (no_work)
 		return result;
@@ -518,16 +504,16 @@ int uds_resume_index_session(struct uds_index_session *session,
 	if ((session->index != NULL) && (bdev != session->parameters.bdev)) {
 		result = replace_device(session, bdev);
 		if (result != UDS_SUCCESS) {
-			uds_lock_mutex(&session->request_mutex);
+			mutex_lock(&session->request_mutex);
 			session->state &= ~IS_FLAG_WAITING;
 			uds_broadcast_cond(&session->request_cond);
-			uds_unlock_mutex(&session->request_mutex);
+			mutex_unlock(&session->request_mutex);
 			return uds_status_to_errno(result);
 		}
 	}
 
 	if (resume_replay) {
-		uds_lock_mutex(&session->load_context.mutex);
+		mutex_lock(&session->load_context.mutex);
 		switch (session->load_context.status) {
 		case INDEX_SUSPENDED:
 			session->load_context.status = INDEX_OPENING;
@@ -548,14 +534,14 @@ int uds_resume_index_session(struct uds_index_session *session,
 					session->load_context.status);
 			break;
 		}
-		uds_unlock_mutex(&session->load_context.mutex);
+		mutex_unlock(&session->load_context.mutex);
 	}
 
-	uds_lock_mutex(&session->request_mutex);
+	mutex_lock(&session->request_mutex);
 	session->state &= ~IS_FLAG_WAITING;
 	session->state &= ~IS_FLAG_SUSPENDED;
 	uds_broadcast_cond(&session->request_cond);
-	uds_unlock_mutex(&session->request_mutex);
+	mutex_unlock(&session->request_mutex);
 	return UDS_SUCCESS;
 }
 
@@ -568,9 +554,9 @@ static int save_and_free_index(struct uds_index_session *index_session)
 	if (index == NULL)
 		return UDS_SUCCESS;
 
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	suspended = (index_session->state & IS_FLAG_SUSPENDED);
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 
 	if (!suspended) {
 		result = uds_save_index(index);
@@ -585,14 +571,14 @@ static int save_and_free_index(struct uds_index_session *index_session)
 	 * Reset all index state that happens to be in the index
 	 * session, so it doesn't affect any future index.
 	 */
-	uds_lock_mutex(&index_session->load_context.mutex);
+	mutex_lock(&index_session->load_context.mutex);
 	index_session->load_context.status = INDEX_OPENING;
-	uds_unlock_mutex(&index_session->load_context.mutex);
+	mutex_unlock(&index_session->load_context.mutex);
 
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	/* Only the suspend bit will remain relevant. */
 	index_session->state &= IS_FLAG_SUSPENDED;
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 
 	return result;
 }
@@ -603,7 +589,7 @@ int uds_close_index(struct uds_index_session *index_session)
 	int result = UDS_SUCCESS;
 
 	/* Wait for any current index state change to complete. */
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	while ((index_session->state & IS_FLAG_WAITING) ||
 	       (index_session->state & IS_FLAG_CLOSING)) {
 		uds_wait_cond(&index_session->request_cond,
@@ -620,7 +606,7 @@ int uds_close_index(struct uds_index_session *index_session)
 	} else {
 		index_session->state |= IS_FLAG_CLOSING;
 	}
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 	if (result != UDS_SUCCESS)
 		return uds_status_to_errno(result);
 
@@ -629,10 +615,10 @@ int uds_close_index(struct uds_index_session *index_session)
 	result = save_and_free_index(index_session);
 	uds_log_debug("Closed index");
 
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	index_session->state &= ~IS_FLAG_CLOSING;
 	uds_broadcast_cond(&index_session->request_cond);
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 	return uds_status_to_errno(result);
 }
 
@@ -645,7 +631,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	uds_log_debug("Destroying index session");
 
 	/* Wait for any current index state change to complete. */
-	uds_lock_mutex(&index_session->request_mutex);
+	mutex_lock(&index_session->request_mutex);
 	while ((index_session->state & IS_FLAG_WAITING) ||
 	       (index_session->state & IS_FLAG_CLOSING)) {
 		uds_wait_cond(&index_session->request_cond,
@@ -653,7 +639,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	}
 
 	if (index_session->state & IS_FLAG_DESTROYING) {
-		uds_unlock_mutex(&index_session->request_mutex);
+		mutex_unlock(&index_session->request_mutex);
 		uds_log_info("Index session is already closing");
 		return -EBUSY;
 	}
@@ -661,32 +647,30 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	index_session->state |= IS_FLAG_DESTROYING;
 	load_pending = ((index_session->state & IS_FLAG_LOADING) &&
 			(index_session->state & IS_FLAG_SUSPENDED));
-	uds_unlock_mutex(&index_session->request_mutex);
+	mutex_unlock(&index_session->request_mutex);
 
 	if (load_pending) {
 		/* Tell the index to terminate the rebuild. */
-		uds_lock_mutex(&index_session->load_context.mutex);
+		mutex_lock(&index_session->load_context.mutex);
 		if (index_session->load_context.status == INDEX_SUSPENDED) {
 			index_session->load_context.status = INDEX_FREEING;
 			uds_broadcast_cond(&index_session->load_context.cond);
 		}
-		uds_unlock_mutex(&index_session->load_context.mutex);
+		mutex_unlock(&index_session->load_context.mutex);
 
 		/* Wait until the load exits before proceeding. */
-		uds_lock_mutex(&index_session->request_mutex);
+		mutex_lock(&index_session->request_mutex);
 		while (index_session->state & IS_FLAG_LOADING) {
 			uds_wait_cond(&index_session->request_cond,
 				      &index_session->request_mutex);
 		}
-		uds_unlock_mutex(&index_session->request_mutex);
+		mutex_unlock(&index_session->request_mutex);
 	}
 
 	wait_for_no_requests_in_progress(index_session);
 	result = save_and_free_index(index_session);
 	uds_request_queue_finish(index_session->callback_queue);
 	index_session->callback_queue = NULL;
-	uds_destroy_mutex(&index_session->load_context.mutex);
-	uds_destroy_mutex(&index_session->request_mutex);
 	uds_log_debug("Destroyed index session");
 	uds_free(index_session);
 	return uds_status_to_errno(result);
@@ -747,8 +731,8 @@ void uds_wait_cond(struct cond_var *cv, struct mutex *mutex)
 	DEFINE_WAIT(__wait);
 
 	prepare_to_wait(&cv->wait_queue, &__wait, TASK_IDLE);
-	uds_unlock_mutex(mutex);
+	mutex_unlock(mutex);
 	schedule();
 	finish_wait(&cv->wait_queue, &__wait);
-	uds_lock_mutex(mutex);
+	mutex_lock(mutex);
 }
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index edd81f03c2b5..5c9906e73c84 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -180,11 +180,11 @@ static int finish_previous_chapter(struct uds_index *index, u64 current_chapter_
 	int result;
 	struct chapter_writer *writer = index->chapter_writer;
 
-	uds_lock_mutex(&writer->mutex);
+	mutex_lock(&writer->mutex);
 	while (index->newest_virtual_chapter < current_chapter_number)
 		uds_wait_cond(&writer->cond, &writer->mutex);
 	result = writer->result;
-	uds_unlock_mutex(&writer->mutex);
+	mutex_unlock(&writer->mutex);
 
 	if (result != UDS_SUCCESS)
 		return uds_log_error_strerror(result,
@@ -219,11 +219,11 @@ static unsigned int start_closing_chapter(struct uds_index *index,
 	unsigned int finished_zones;
 	struct chapter_writer *writer = index->chapter_writer;
 
-	uds_lock_mutex(&writer->mutex);
+	mutex_lock(&writer->mutex);
 	finished_zones = ++writer->zones_to_write;
 	writer->chapters[zone_number] = chapter;
 	uds_broadcast_cond(&writer->cond);
-	uds_unlock_mutex(&writer->mutex);
+	mutex_unlock(&writer->mutex);
 
 	return finished_zones;
 }
@@ -678,7 +678,7 @@ static void close_chapters(void *arg)
 	struct uds_index *index = writer->index;
 
 	uds_log_debug("chapter writer starting");
-	uds_lock_mutex(&writer->mutex);
+	mutex_lock(&writer->mutex);
 	for (;;) {
 		while (writer->zones_to_write < index->zone_count) {
 			if (writer->stop && (writer->zones_to_write == 0)) {
@@ -686,7 +686,7 @@ static void close_chapters(void *arg)
 				 * We've been told to stop, and all of the zones are in the same
 				 * open chapter, so we can exit now.
 				 */
-				uds_unlock_mutex(&writer->mutex);
+				mutex_unlock(&writer->mutex);
 				uds_log_debug("chapter writer stopping");
 				return;
 			}
@@ -698,7 +698,7 @@ static void close_chapters(void *arg)
 		 * it seems safer in principle. It's OK to access the chapter and chapter_number
 		 * fields without the lock since those aren't allowed to change until we're done.
 		 */
-		uds_unlock_mutex(&writer->mutex);
+		mutex_unlock(&writer->mutex);
 
 		if (index->has_saved_open_chapter) {
 			/*
@@ -719,7 +719,7 @@ static void close_chapters(void *arg)
 						writer->collated_records,
 						index->newest_virtual_chapter);
 
-		uds_lock_mutex(&writer->mutex);
+		mutex_lock(&writer->mutex);
 		index->newest_virtual_chapter++;
 		index->oldest_virtual_chapter +=
 			uds_chapters_to_expire(index->volume->geometry,
@@ -734,14 +734,14 @@ static void stop_chapter_writer(struct chapter_writer *writer)
 {
 	struct thread *writer_thread = NULL;
 
-	uds_lock_mutex(&writer->mutex);
+	mutex_lock(&writer->mutex);
 	if (writer->thread != NULL) {
 		writer_thread = writer->thread;
 		writer->thread = NULL;
 		writer->stop = true;
 		uds_broadcast_cond(&writer->cond);
 	}
-	uds_unlock_mutex(&writer->mutex);
+	mutex_unlock(&writer->mutex);
 
 	if (writer_thread != NULL)
 		uds_join_threads(writer_thread);
@@ -753,7 +753,6 @@ static void free_chapter_writer(struct chapter_writer *writer)
 		return;
 
 	stop_chapter_writer(writer);
-	uds_destroy_mutex(&writer->mutex);
 	uds_free_open_chapter_index(writer->open_chapter_index);
 	uds_free(writer->collated_records);
 	uds_free(writer);
@@ -774,12 +773,7 @@ static int make_chapter_writer(struct uds_index *index,
 		return result;
 
 	writer->index = index;
-	result = uds_init_mutex(&writer->mutex);
-	if (result != UDS_SUCCESS) {
-		uds_free(writer);
-		return result;
-	}
-
+	mutex_init(&writer->mutex);
 	uds_init_cond(&writer->cond);
 
 	result = uds_allocate_cache_aligned(collated_records_size, "collated records",
@@ -957,9 +951,9 @@ static bool check_for_suspend(struct uds_index *index)
 	if (index->load_context == NULL)
 		return false;
 
-	uds_lock_mutex(&index->load_context->mutex);
+	mutex_lock(&index->load_context->mutex);
 	if (index->load_context->status != INDEX_SUSPENDING) {
-		uds_unlock_mutex(&index->load_context->mutex);
+		mutex_unlock(&index->load_context->mutex);
 		return false;
 	}
 
@@ -972,7 +966,7 @@ static bool check_for_suspend(struct uds_index *index)
 		uds_wait_cond(&index->load_context->cond, &index->load_context->mutex);
 
 	closing = (index->load_context->status == INDEX_FREEING);
-	uds_unlock_mutex(&index->load_context->mutex);
+	mutex_unlock(&index->load_context->mutex);
 	return closing;
 }
 
@@ -1261,14 +1255,14 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 	}
 
 	if (index->load_context != NULL) {
-		uds_lock_mutex(&index->load_context->mutex);
+		mutex_lock(&index->load_context->mutex);
 		index->load_context->status = INDEX_READY;
 		/*
 		 * If we get here, suspend is meaningless, but notify any thread trying to suspend
 		 * us so it doesn't hang.
 		 */
 		uds_broadcast_cond(&index->load_context->cond);
-		uds_unlock_mutex(&index->load_context->mutex);
+		mutex_unlock(&index->load_context->mutex);
 	}
 
 	index->has_saved_open_chapter = loaded;
@@ -1307,10 +1301,10 @@ void uds_wait_for_idle_index(struct uds_index *index)
 {
 	struct chapter_writer *writer = index->chapter_writer;
 
-	uds_lock_mutex(&writer->mutex);
+	mutex_lock(&writer->mutex);
 	while (writer->zones_to_write > 0)
 		uds_wait_cond(&writer->cond, &writer->mutex);
-	uds_unlock_mutex(&writer->mutex);
+	mutex_unlock(&writer->mutex);
 }
 
 /* This function assumes that all requests have been drained. */
diff --git a/drivers/md/dm-vdo/thread-utils.h b/drivers/md/dm-vdo/thread-utils.h
index fb71f8f1b46e..8b55f0d1ab80 100644
--- a/drivers/md/dm-vdo/thread-utils.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -26,27 +26,4 @@ void uds_perform_once(atomic_t *once_state, void (*function) (void));
 
 int uds_join_threads(struct thread *thread);
 
-/* FIXME: all below wrappers should be removed! */
-
-static inline int __must_check uds_init_mutex(struct mutex *mutex)
-{
-	mutex_init(mutex);
-	return UDS_SUCCESS;
-}
-
-static inline int uds_destroy_mutex(struct mutex *mutex)
-{
-	return UDS_SUCCESS;
-}
-
-static inline void uds_lock_mutex(struct mutex *mutex)
-{
-	mutex_lock(mutex);
-}
-
-static inline void uds_unlock_mutex(struct mutex *mutex)
-{
-	mutex_unlock(mutex);
-}
-
 #endif /* UDS_THREADS_H */
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index 39c4be06780f..36e3c2e3d799 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -286,13 +286,8 @@ void uds_free_volume_index(struct volume_index *volume_index)
 	if (volume_index == NULL)
 		return;
 
-	if (volume_index->zones != NULL) {
-		unsigned int zone;
-
-		for (zone = 0; zone < volume_index->zone_count; zone++)
-			uds_destroy_mutex(&volume_index->zones[zone].hook_mutex);
+	if (volume_index->zones != NULL)
 		uds_free(uds_forget(volume_index->zones));
-	}
 
 	uninitialize_volume_sub_index(&volume_index->vi_non_hook);
 	uninitialize_volume_sub_index(&volume_index->vi_hook);
@@ -546,10 +541,10 @@ int uds_get_volume_index_record(struct volume_index *volume_index,
 			get_volume_sub_index_zone(&volume_index->vi_hook, name);
 		struct mutex *mutex = &volume_index->zones[zone].hook_mutex;
 
-		uds_lock_mutex(mutex);
+		mutex_lock(mutex);
 		result = get_volume_sub_index_record(&volume_index->vi_hook, name,
 						     record);
-		uds_unlock_mutex(mutex);
+		mutex_unlock(mutex);
 		/* Remember the mutex so that other operations on the index record can use it. */
 		record->mutex = mutex;
 	} else {
@@ -578,13 +573,13 @@ int uds_put_volume_index_record(struct volume_index_record *record, u64 virtual_
 	}
 	address = extract_address(sub_index, record->name);
 	if (unlikely(record->mutex != NULL))
-		uds_lock_mutex(record->mutex);
+		mutex_lock(record->mutex);
 	result = uds_put_delta_index_entry(&record->delta_entry, address,
 					   convert_virtual_to_index(sub_index,
 								    virtual_chapter),
 					   record->is_found ? record->name->name : NULL);
 	if (unlikely(record->mutex != NULL))
-		uds_unlock_mutex(record->mutex);
+		mutex_unlock(record->mutex);
 	switch (result) {
 	case UDS_SUCCESS:
 		record->virtual_chapter = virtual_chapter;
@@ -614,10 +609,10 @@ int uds_remove_volume_index_record(struct volume_index_record *record)
 	/* Mark the record so that it cannot be used again */
 	record->is_found = false;
 	if (unlikely(record->mutex != NULL))
-		uds_lock_mutex(record->mutex);
+		mutex_lock(record->mutex);
 	result = uds_remove_delta_index_entry(&record->delta_entry);
 	if (unlikely(record->mutex != NULL))
-		uds_unlock_mutex(record->mutex);
+		mutex_unlock(record->mutex);
 	return result;
 }
 
@@ -688,10 +683,10 @@ void uds_set_volume_index_zone_open_chapter(struct volume_index *volume_index,
 	 * chapter number is changing.
 	 */
 	if (has_sparse(volume_index)) {
-		uds_lock_mutex(mutex);
+		mutex_lock(mutex);
 		set_volume_sub_index_zone_open_chapter(&volume_index->vi_hook,
 						       zone_number, virtual_chapter);
-		uds_unlock_mutex(mutex);
+		mutex_unlock(mutex);
 	}
 }
 
@@ -730,12 +725,12 @@ int uds_set_volume_index_record_chapter(struct volume_index_record *record,
 	}
 
 	if (unlikely(record->mutex != NULL))
-		uds_lock_mutex(record->mutex);
+		mutex_lock(record->mutex);
 	result = uds_set_delta_entry_value(&record->delta_entry,
 					   convert_virtual_to_index(sub_index,
 								    virtual_chapter));
 	if (unlikely(record->mutex != NULL))
-		uds_unlock_mutex(record->mutex);
+		mutex_unlock(record->mutex);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -785,9 +780,9 @@ u64 uds_lookup_volume_index_name(const struct volume_index *volume_index,
 	if (!uds_is_volume_index_sample(volume_index, name))
 		return NO_CHAPTER;
 
-	uds_lock_mutex(mutex);
+	mutex_lock(mutex);
 	virtual_chapter = lookup_volume_sub_index_name(&volume_index->vi_hook, name);
-	uds_unlock_mutex(mutex);
+	mutex_unlock(mutex);
 
 	return virtual_chapter;
 }
@@ -1258,13 +1253,8 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 		return result;
 	}
 
-	for (zone = 0; zone < config->zone_count; zone++) {
-		result = uds_init_mutex(&volume_index->zones[zone].hook_mutex);
-		if (result != UDS_SUCCESS) {
-			uds_free_volume_index(volume_index);
-			return result;
-		}
-	}
+	for (zone = 0; zone < config->zone_count; zone++)
+		mutex_init(&volume_index->zones[zone].hook_mutex);
 
 	split_configuration(config, &split);
 	result = initialize_volume_sub_index(&split.non_hook_config, volume_nonce, 'd',
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 3b256a78fb02..0fb06fd315ef 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -554,7 +554,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 
 	page = select_victim_in_cache(&volume->page_cache);
 
-	uds_unlock_mutex(&volume->read_threads_mutex);
+	mutex_unlock(&volume->read_threads_mutex);
 	page_data = dm_bufio_read(volume->client, page_number, &page->buffer);
 	if (IS_ERR(page_data)) {
 		result = -PTR_ERR(page_data);
@@ -564,7 +564,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 		cancel_page_in_cache(&volume->page_cache, page_number, page);
 		return result;
 	}
-	uds_lock_mutex(&volume->read_threads_mutex);
+	mutex_lock(&volume->read_threads_mutex);
 
 	if (entry->invalid) {
 		uds_log_warning("Page %u invalidated after read", page_number);
@@ -626,7 +626,7 @@ static void read_thread_function(void *arg)
 	struct volume *volume = arg;
 
 	uds_log_debug("reader starting");
-	uds_lock_mutex(&volume->read_threads_mutex);
+	mutex_lock(&volume->read_threads_mutex);
 	while (true) {
 		struct queued_read *queue_entry;
 		int result;
@@ -638,7 +638,7 @@ static void read_thread_function(void *arg)
 		result = process_entry(volume, queue_entry);
 		release_queued_requests(volume, queue_entry, result);
 	}
-	uds_unlock_mutex(&volume->read_threads_mutex);
+	mutex_unlock(&volume->read_threads_mutex);
 	uds_log_debug("reader done");
 }
 
@@ -769,7 +769,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 
 	/* Prepare to enqueue a read for the page. */
 	end_pending_search(&volume->page_cache, request->zone_number);
-	uds_lock_mutex(&volume->read_threads_mutex);
+	mutex_lock(&volume->read_threads_mutex);
 
 	/*
 	 * Do the lookup again while holding the read mutex (no longer the fast case so this should
@@ -787,7 +787,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 		 * turns out to be significant in some cases. The page is not available yet so
 		 * the order does not matter for correctness as it does below.
 		 */
-		uds_unlock_mutex(&volume->read_threads_mutex);
+		mutex_unlock(&volume->read_threads_mutex);
 		begin_pending_search(&volume->page_cache, physical_page,
 				     request->zone_number);
 		return UDS_QUEUED;
@@ -799,7 +799,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 	 * the caller gets to look at it.
 	 */
 	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
-	uds_unlock_mutex(&volume->read_threads_mutex);
+	mutex_unlock(&volume->read_threads_mutex);
 	*page_ptr = page;
 	return UDS_SUCCESS;
 }
@@ -810,9 +810,9 @@ static int get_volume_page(struct volume *volume, u32 chapter, u32 page_number,
 	int result;
 	u32 physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
 
-	uds_lock_mutex(&volume->read_threads_mutex);
+	mutex_lock(&volume->read_threads_mutex);
 	result = get_volume_page_locked(volume, physical_page, page_ptr);
-	uds_unlock_mutex(&volume->read_threads_mutex);
+	mutex_unlock(&volume->read_threads_mutex);
 	return result;
 }
 
@@ -1053,10 +1053,10 @@ void uds_forget_chapter(struct volume *volume, u64 virtual_chapter)
 	u32 i;
 
 	uds_log_debug("forgetting chapter %llu", (unsigned long long) virtual_chapter);
-	uds_lock_mutex(&volume->read_threads_mutex);
+	mutex_lock(&volume->read_threads_mutex);
 	for (i = 0; i < volume->geometry->pages_per_chapter; i++)
 		invalidate_page(&volume->page_cache, first_page + i);
-	uds_unlock_mutex(&volume->read_threads_mutex);
+	mutex_unlock(&volume->read_threads_mutex);
 }
 
 /*
@@ -1141,10 +1141,10 @@ static int write_index_pages(struct volume *volume, u32 physical_chapter_number,
 					  physical_chapter_number, index_page_number,
 					  delta_list_number - 1);
 
-		uds_lock_mutex(&volume->read_threads_mutex);
+		mutex_lock(&volume->read_threads_mutex);
 		result = donate_index_page_locked(volume, physical_chapter_number,
 						  index_page_number, page_buffer);
-		uds_unlock_mutex(&volume->read_threads_mutex);
+		mutex_unlock(&volume->read_threads_mutex);
 		if (result != UDS_SUCCESS) {
 			dm_bufio_release(page_buffer);
 			return result;
@@ -1621,12 +1621,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 		return result;
 	}
 
-	result = uds_init_mutex(&volume->read_threads_mutex);
-	if (result != UDS_SUCCESS) {
-		uds_free_volume(volume);
-		return result;
-	}
-
+	mutex_init(&volume->read_threads_mutex);
 	uds_init_cond(&volume->read_threads_read_done_cond);
 	uds_init_cond(&volume->read_threads_cond);
 
@@ -1675,10 +1670,10 @@ void uds_free_volume(struct volume *volume)
 		unsigned int i;
 
 		/* This works even if some threads weren't started. */
-		uds_lock_mutex(&volume->read_threads_mutex);
+		mutex_lock(&volume->read_threads_mutex);
 		volume->read_threads_exiting = true;
 		uds_broadcast_cond(&volume->read_threads_cond);
-		uds_unlock_mutex(&volume->read_threads_mutex);
+		mutex_unlock(&volume->read_threads_mutex);
 		for (i = 0; i < volume->read_thread_count; i++)
 			uds_join_threads(volume->reader_threads[i]);
 		uds_free(volume->reader_threads);
@@ -1691,7 +1686,6 @@ void uds_free_volume(struct volume *volume)
 	if (volume->client != NULL)
 		dm_bufio_client_destroy(uds_forget(volume->client));
 
-	uds_destroy_mutex(&volume->read_threads_mutex);
 	uds_free_index_page_map(volume->index_page_map);
 	uds_free_radix_sorter(volume->radix_sorter);
 	uds_free(volume->geometry);
-- 
2.42.0

