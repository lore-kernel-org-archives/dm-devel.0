Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1509469D
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432970; cv=none; b=bqlFLWUzXzTT6b8dRU+aVbu+/ZuawZQycXhxQ6nD+FGnzCu59APS+LNQYAM1Tief4bvecUi6hIaaT3UCx6MbNcfb6ah1COoOr5IX7AxlZJwuyEFuGRklSWSu4HRCOe2kUJpQJnDbvayKmme1Y2QA2+vYQpu0XIKizYWG2g6mSuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432970; c=relaxed/simple;
	bh=h0ei7NooZCkq93TmC0/jg5ZO/cEiu3BlR7/+3pED5dw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=rwz3UZp8L+CBSudtZh/xihPnKCInXQVQotWuHouya7NI4k85LmgwxGS44z5cLJMhtHMvuI5m8mFzXvyRaITDwC05gQsvw/h4uxAUv+sUcyvDZF8A5/YPumgXfXsTX1SYLdpwQ+oWW3HkUeSX9YE1AluLbgLWQvPA0RsJw2HB+4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OERPlHaa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OERPlHaa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740432967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jN3LIlbSpI+97YTG7CRJeLi/FvNma370D+W4C7KdEOw=;
	b=OERPlHaaCerV4mdKZmyEz+Xlba9s7+7mVHP7Tv1iCi6os2tjZxN1x4gXGDaAzjt1Xm23qi
	YNNP/dKYpFi7p3ERNo6h3iKf6t14gGvTzboyGZG2qXl+Eqs/ecOu6ES44wimi846H5X5jM
	5Kc6zrvSLoiR/pbHWreYEqhmsMXCNMM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-FYjcVmHjOya6-UzXN5yVmw-1; Mon,
 24 Feb 2025 16:36:05 -0500
X-MC-Unique: FYjcVmHjOya6-UzXN5yVmw-1
X-Mimecast-MFC-AGG-ID: FYjcVmHjOya6-UzXN5yVmw_1740432964
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E3EA180098F
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 21:36:04 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5BD0E180035E;
	Mon, 24 Feb 2025 21:36:04 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 96A03607B8; Mon, 24 Feb 2025 16:36:03 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v2] dm vdo indexer: reorder uds_request to reduce padding
Date: Mon, 24 Feb 2025 16:36:03 -0500
Message-ID: <20250224213603.1353256-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jxhL_Qtt82lADPTSz1yLId5Jd3ZhvOfkc6dlnNt_Cw0_1740432964
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Reorder fields and make uds_request_type and uds_zone_message packed,
to squeeze out some space. Use struct_group so the request reset code
no longer needs to care about field order.

On x86_64 this reduces the struct size from 144 to 120, which saves 48
kB (about 12%) per VDO hash zone.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/index-session.c |  6 +--
 drivers/md/dm-vdo/indexer/indexer.h       | 53 +++++++++++------------
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
index aee0914d604a..aa575a24e0b2 100644
--- a/drivers/md/dm-vdo/indexer/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -100,7 +100,6 @@ static int get_index_session(struct uds_index_session *index_session)
 
 int uds_launch_request(struct uds_request *request)
 {
-	size_t internal_size;
 	int result;
 
 	if (request->callback == NULL) {
@@ -121,10 +120,7 @@ int uds_launch_request(struct uds_request *request)
 	}
 
 	/* Reset all internal fields before processing. */
-	internal_size =
-		sizeof(struct uds_request) - offsetof(struct uds_request, zone_number);
-	// FIXME should be using struct_group for this instead
-	memset((char *) request + sizeof(*request) - internal_size, 0, internal_size);
+	memset(&request->internal, 0, sizeof(request->internal));
 
 	result = get_index_session(request->session);
 	if (result != UDS_SUCCESS)
diff --git a/drivers/md/dm-vdo/indexer/indexer.h b/drivers/md/dm-vdo/indexer/indexer.h
index 3744aaf625b0..d765f24328eb 100644
--- a/drivers/md/dm-vdo/indexer/indexer.h
+++ b/drivers/md/dm-vdo/indexer/indexer.h
@@ -8,6 +8,7 @@
 
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 
@@ -73,7 +74,7 @@ enum uds_request_type {
 	/* Remove any mapping for a name. */
 	UDS_DELETE,
 
-};
+} __packed;
 
 enum uds_open_index_type {
 	/* Create a new index. */
@@ -226,7 +227,7 @@ struct uds_zone_message {
 	enum uds_zone_message_type type;
 	/* The virtual chapter number to which the message applies */
 	u64 virtual_chapter;
-};
+} __packed;
 
 struct uds_index_session;
 struct uds_index;
@@ -253,34 +254,32 @@ struct uds_request {
 
 	/* The existing data associated with the request name, if any */
 	struct uds_record_data old_metadata;
-	/* Either UDS_SUCCESS or an error code for the request */
-	int status;
 	/* True if the record name had an existing entry in the index */
 	bool found;
+	/* Either UDS_SUCCESS or an error code for the request */
+	int status;
 
-	/*
-	 * The remaining fields are used internally and should not be altered by clients. The index
-	 * relies on zone_number being the first field in this section.
-	 */
-
-	/* The number of the zone which will process this request*/
-	unsigned int zone_number;
-	/* A link for adding a request to a lock-free queue */
-	struct funnel_queue_entry queue_link;
-	/* A link for adding a request to a standard linked list */
-	struct uds_request *next_request;
-	/* A pointer to the index processing this request */
-	struct uds_index *index;
-	/* Control message for coordinating between zones */
-	struct uds_zone_message zone_message;
-	/* If true, process request immediately by waking the worker thread */
-	bool unbatched;
-	/* If true, continue this request before processing newer requests */
-	bool requeued;
-	/* The virtual chapter containing the record name, if known */
-	u64 virtual_chapter;
-	/* The region of the index containing the record name */
-	enum uds_index_region location;
+	/* The remaining fields are used internally and should not be altered by clients. */
+	struct_group(internal,
+		     /* The virtual chapter containing the record name, if known */
+		     u64 virtual_chapter;
+		     /* The region of the index containing the record name */
+		     enum uds_index_region location;
+		     /* If true, process request immediately by waking the worker thread */
+		     bool unbatched;
+		     /* If true, continue this request before processing newer requests */
+		     bool requeued;
+		     /* Control message for coordinating between zones */
+		     struct uds_zone_message zone_message;
+		     /* The number of the zone which will process this request*/
+		     unsigned int zone_number;
+		     /* A link for adding a request to a lock-free queue */
+		     struct funnel_queue_entry queue_link;
+		     /* A link for adding a request to a standard linked list */
+		     struct uds_request *next_request;
+		     /* A pointer to the index processing this request */
+		     struct uds_index *index;
+		     );
 };
 
 /* A session is required for most index operations. */
-- 
2.45.2

