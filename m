Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FF250263
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267938; cv=none; b=myuqu7O3xyxIOIPbczpgwmTf9AhaRKwM0A/dtu/Slg8xoGaFkSQAsNbSg80RI/jm1cb4bBP8s0R/2CM/x5kSobbgtt+vkIjuXHOCwfhP/gF230l7lHErTg3F6ZJA3fOJANKcPVSZedRyw5ZMInFtx5Tpb9VUZPi8ijS2ZZYgapk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267938; c=relaxed/simple;
	bh=bPqXZQJmpTUbLZVaoWbfPJO2MVYQYC6ppXjF9grD9ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSythEWI8+t8YdvPkPEveIEbP369OVAkAjCoZda9AxUsD98mfKvweBe8VO3ucaJoaq5+9oMjFeMI08yhOQiP8MMTvJ/c6ypcxSEJrx4pA3X90vtkZpSbU3oP2dqjveW1qogv2TY6aSUCVBVBOM+55Ibb8hf7clyiaf291NvKn84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GmQRYkJm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmQRYkJm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0yBWOrph1RO7Wna9nVGis2+wWoyhUgPm2d7LzcK2HeQ=;
	b=GmQRYkJmu2CfNjbUNyi/v727owNJUxJjJoUQu8w25D4dk3+JLApSoKLPX+XXU/LbsGN66c
	4vlAG8T4rK0zYi59F2v7lHc3cA3O0Pm/hYLYJHBxQRIzsufmCsLwsj+fh8vvNU4PVSaArB
	ZE1O3TlCHG8jaIijP5Drm/33ypfNBUo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-ZeTjmVyQNsSa4TTUxORG0Q-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: ZeTjmVyQNsSa4TTUxORG0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAE2083B8E5;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5CD21121312;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C3402A1624; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 05/10] dm vdo thread-utils: return VDO_SUCCESS on vdo_create_thread success
Date: Thu, 29 Feb 2024 23:38:48 -0500
Message-ID: <adaa76ffe3b651376239eda8e88139c68c1d2a35.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Update all callers to check for VDO_SUCCESS.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/funnel-requestqueue.c | 2 +-
 drivers/md/dm-vdo/indexer/index.c               | 2 +-
 drivers/md/dm-vdo/indexer/volume.c              | 2 +-
 drivers/md/dm-vdo/thread-utils.c                | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
index eee7b980960f..84c7c1ae1333 100644
--- a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
@@ -221,7 +221,7 @@ int uds_make_request_queue(const char *queue_name,
 
 	result = vdo_create_thread(request_queue_worker, queue, queue_name,
 				   &queue->thread);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_request_queue_finish(queue);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index 243a9deab4de..226713221105 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -798,7 +798,7 @@ static int make_chapter_writer(struct uds_index *index,
 			       writer->open_chapter_index->memory_size);
 
 	result = vdo_create_thread(close_chapters, writer, "writer", &writer->thread);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		free_chapter_writer(writer);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 959dd82ef665..0a4beef8ac8d 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -1634,7 +1634,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	for (i = 0; i < config->read_threads; i++) {
 		result = vdo_create_thread(read_thread_function, (void *) volume,
 					   "reader", &volume->reader_threads[i]);
-		if (result != UDS_SUCCESS) {
+		if (result != VDO_SUCCESS) {
 			uds_free_volume(volume);
 			return result;
 		}
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index b4aa71fffdbf..c822df86f731 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -119,7 +119,7 @@ int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 	}
 
 	*new_thread = thread;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 void vdo_join_threads(struct thread *thread)
-- 
2.42.0

