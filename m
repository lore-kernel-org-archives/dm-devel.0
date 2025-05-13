Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2FD2EAE5
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 01:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747098617; cv=none; b=LOR3qDJY8Z9Abm65Lez2I285tp4bqcLgWJqx9BNVVGNBCgQRS0LvJPL4YsaE4k0io9glCiAm1E1K6H+OQC5unkDx43C3JguCo7XbuKuUoAWlw65ExFneQUJzxkf9rJX4haKZXMjUSyC/1+3d4w+KmOfbyw52SeBuNGWj5qvrLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747098617; c=relaxed/simple;
	bh=6V/LYEoV1AzqjI1x8xTXpmqQW0dDP/puEe4n6vi1bBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=FUO48QjUaGeOQCZ1XHcuwC6QfsfrK/iI+SXoDyq8RnbmTTSR23m/UV3uJvgS6slKv0Y+dDKA5Vq1Co3IpUoqsmTG/wxkXNFwHFNhJ2B8KGs+FmqrtbLlW5vs+MRH9KBUWSMcgj0DB0p1PUTW8UWNYXz05cKIffTe6pix0qRmpuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ma3il/0+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma3il/0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747098613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Pakuarw/8VaPWixePjLs+3flWE2XXEwMhdC1GkdeOHU=;
	b=Ma3il/0+0kXElzSRMPsjRsoXFo/A0pzrYpgpRMFlNPG67ZzNb6RxGOiogCjD29zRm+TfRa
	hAoRjdIf7ZfVMZr7mXOkIXDUev8PICwHewXKmQeNZT4o4+CRDX/kuTGbYzqu9z7MTSGXAq
	42ZfzGVW9FoysCkXRKq6aF4PTds6mIc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-A2KCh03kPO6tQOYucZzwcg-1; Mon,
 12 May 2025 21:10:12 -0400
X-MC-Unique: A2KCh03kPO6tQOYucZzwcg-1
X-Mimecast-MFC-AGG-ID: A2KCh03kPO6tQOYucZzwcg_1747098611
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C87C180036F
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 01:10:11 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 085CE19560A3;
	Tue, 13 May 2025 01:10:10 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 44ADBE2449; Mon, 12 May 2025 21:10:10 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: don't read request structure after enqueuing
Date: Mon, 12 May 2025 21:10:10 -0400
Message-ID: <75b89986ce2b958cabc20214cc3a95d3b06669bc.1747098268.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X-r38Mj0IgQytTHi2UCuXjaedKG3XcybQPu7QeEXXXk_1747098611
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The function get_volume_page_protected may place a request on
a queue for another thread to process asynchronously. When this
happens, the volume should not read the request from the original
thread. This can not currently cause problems, due to the way
request processing is handled, but it is not safe in general.

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/volume.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 655453bb276b..425b3a74f4db 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -754,10 +754,11 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 				     u32 physical_page, struct cached_page **page_ptr)
 {
 	struct cached_page *page;
+	unsigned int zone_number = request->zone_number;
 
 	get_page_from_cache(&volume->page_cache, physical_page, &page);
 	if (page != NULL) {
-		if (request->zone_number == 0) {
+		if (zone_number == 0) {
 			/* Only one zone is allowed to update the LRU. */
 			make_page_most_recent(&volume->page_cache, page);
 		}
@@ -767,7 +768,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 	}
 
 	/* Prepare to enqueue a read for the page. */
-	end_pending_search(&volume->page_cache, request->zone_number);
+	end_pending_search(&volume->page_cache, zone_number);
 	mutex_lock(&volume->read_threads_mutex);
 
 	/*
@@ -787,8 +788,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 		 * the order does not matter for correctness as it does below.
 		 */
 		mutex_unlock(&volume->read_threads_mutex);
-		begin_pending_search(&volume->page_cache, physical_page,
-				     request->zone_number);
+		begin_pending_search(&volume->page_cache, physical_page, zone_number);
 		return UDS_QUEUED;
 	}
 
@@ -797,7 +797,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 	 * "search pending" state in careful order so no other thread can mess with the data before
 	 * the caller gets to look at it.
 	 */
-	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	begin_pending_search(&volume->page_cache, physical_page, zone_number);
 	mutex_unlock(&volume->read_threads_mutex);
 	*page_ptr = page;
 	return UDS_SUCCESS;
@@ -849,6 +849,7 @@ static int search_cached_index_page(struct volume *volume, struct uds_request *r
 {
 	int result;
 	struct cached_page *page = NULL;
+	unsigned int zone_number = request->zone_number;
 	u32 physical_page = map_to_physical_page(volume->geometry, chapter,
 						 index_page_number);
 
@@ -858,18 +859,18 @@ static int search_cached_index_page(struct volume *volume, struct uds_request *r
 	 * invalidation by the reader thread, before the reader thread has noticed that the
 	 * invalidate_counter has been incremented.
 	 */
-	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	begin_pending_search(&volume->page_cache, physical_page, zone_number);
 
 	result = get_volume_page_protected(volume, request, physical_page, &page);
 	if (result != UDS_SUCCESS) {
-		end_pending_search(&volume->page_cache, request->zone_number);
+		end_pending_search(&volume->page_cache, zone_number);
 		return result;
 	}
 
 	result = uds_search_chapter_index_page(&page->index_page, volume->geometry,
 					       &request->record_name,
 					       record_page_number);
-	end_pending_search(&volume->page_cache, request->zone_number);
+	end_pending_search(&volume->page_cache, zone_number);
 	return result;
 }
 
@@ -882,6 +883,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 {
 	struct cached_page *record_page;
 	struct index_geometry *geometry = volume->geometry;
+	unsigned int zone_number = request->zone_number;
 	int result;
 	u32 physical_page, page_number;
 
@@ -905,11 +907,11 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 	 * invalidation by the reader thread, before the reader thread has noticed that the
 	 * invalidate_counter has been incremented.
 	 */
-	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	begin_pending_search(&volume->page_cache, physical_page, zone_number);
 
 	result = get_volume_page_protected(volume, request, physical_page, &record_page);
 	if (result != UDS_SUCCESS) {
-		end_pending_search(&volume->page_cache, request->zone_number);
+		end_pending_search(&volume->page_cache, zone_number);
 		return result;
 	}
 
@@ -917,7 +919,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 			       &request->record_name, geometry, &request->old_metadata))
 		*found = true;
 
-	end_pending_search(&volume->page_cache, request->zone_number);
+	end_pending_search(&volume->page_cache, zone_number);
 	return UDS_SUCCESS;
 }
 
-- 
2.48.1

