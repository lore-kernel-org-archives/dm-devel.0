Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA510A01
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707886637; cv=none; b=M6aInxU3uShkYPz1sOEd/kwDdNfRluqrQYZgQx69+FJJn1lN5SbseV7GMypRSrimSebnIEAV1SNGyNYinvirKSfqddPqNlL4GiLEs7/E9+9z5B6tLtgK2ds68BKxshhgSuMs6bXbn6D4uVnM/eHRC36YDqjmISxbM7a6keuVQdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707886637; c=relaxed/simple;
	bh=XA5aP57EjhtheILyabqS0KKF0vUypcW4GIhCy9isrjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F7IGpTV5X6B+QUFqRdRMnX3VEj0hjK17pNjAVqBKLQamrKX7Ou0xf0tYAtZmTUQcJ5r5kYkMGC2abJm9CkH6/Otdb94UpwfxS+lGRfm0Y0U7TLvR/8lD5W8FnWrbYIkHegdAjtGNLa+pQHBa+HxDFRhVtT1z6HmNtqBw9BVI7PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=grW0ACWL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grW0ACWL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707886634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0PDb84uWZ4cY249hGMPSJYbkC6wo9Lv7vU68rCzAsE=;
	b=grW0ACWLszZdd30AnAI1jzFgQekgup8B10Ka967vAAjdwd2NLtEBGA984Fky7laFReZQhT
	t0m0fLEJEwDnhYh3w5f8GpsoqS2EXXrmHG16m+bJwo2301qB7x3eIk2G80MdKUECSrRbPs
	FHP/boHszpLDAMoX7/GI6BivyTiiePU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-Ur6viUwvOUaJgjJl6D5-6w-1; Tue, 13 Feb 2024 23:57:12 -0500
X-MC-Unique: Ur6viUwvOUaJgjJl6D5-6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5814C101FA0B;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 515C32166B36;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4B2AC576BC; Tue, 13 Feb 2024 23:57:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/5] dm vdo dedupe: fix various small nits
Date: Tue, 13 Feb 2024 23:57:09 -0500
Message-ID: <fd39a8c5675d25c52382a851aa9fe5fd3ca1066c.1707886374.git.msakai@redhat.com>
In-Reply-To: <cover.1707886374.git.msakai@redhat.com>
References: <cover.1707886374.git.msakai@redhat.com>
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

Add a __must_hold sparse annotation to launch_dedupe_state_change that
reflects its ASSERTION code comments about locking requirements, add
some extra braces and fix a couple typos.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index d81065a0951c..2a1902c4423c 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -81,7 +81,7 @@
  *
  * A query to the UDS index is handled asynchronously by the index's threads. When the query is
  * complete, a callback supplied with the query will be called from one of the those threads. Under
- * heavy system load, the index may be slower to respond then is desirable for reasonable I/O
+ * heavy system load, the index may be slower to respond than is desirable for reasonable I/O
  * throughput. Since deduplication of writes is not necessary for correct operation of a VDO
  * device, it is acceptable to timeout out slow index queries and proceed to fulfill a write
  * request without deduplicating. However, because the uds_request struct itself is supplied by the
@@ -1311,7 +1311,7 @@ static bool acquire_provisional_reference(struct data_vio *agent, struct pbn_loc
  *              behalf of its hash lock.
  *
  * If the PBN is already locked for writing, the lock attempt is abandoned and is_duplicate will be
- * cleared before calling back. this continuation is launched from start_locking(), and calls back
+ * cleared before calling back. This continuation is launched from start_locking(), and calls back
  * to finish_locking() on the hash zone thread.
  */
 static void lock_duplicate_pbn(struct vdo_completion *completion)
@@ -2300,9 +2300,10 @@ static void finish_index_operation(struct uds_request *request)
 	 * data_vio has already moved on.
 	 */
 	if (!change_context_state(context, DEDUPE_CONTEXT_TIMED_OUT,
-				  DEDUPE_CONTEXT_TIMED_OUT_COMPLETE))
+				  DEDUPE_CONTEXT_TIMED_OUT_COMPLETE)) {
 		ASSERT_LOG_ONLY(false, "uds request was timed out (state %d)",
 				atomic_read(&context->state));
+	}
 
 	uds_funnel_queue_put(context->zone->timed_out_complete, &context->queue_entry);
 }
@@ -2616,6 +2617,7 @@ void vdo_drain_hash_zones(struct hash_zones *zones, struct vdo_completion *paren
 }
 
 static void launch_dedupe_state_change(struct hash_zones *zones)
+	__must_hold(&zones->lock)
 {
 	/* ASSERTION: We enter with the lock held. */
 	if (zones->changing || !vdo_is_state_normal(&zones->state))
@@ -3056,9 +3058,10 @@ int vdo_add_dedupe_index_sysfs(struct hash_zones *zones)
 	int result = kobject_add(&zones->dedupe_directory,
 				 &zones->completion.vdo->vdo_directory, "dedupe");
 
-	if (result == 0)
+	if (result == 0) {
 		vdo_set_admin_state_code(&zones->state,
 					 VDO_ADMIN_STATE_NORMAL_OPERATION);
+	}
 
 	return result;
 }
-- 
2.42.0

