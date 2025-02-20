Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D7E1EE006
	for <dm-devel@lists.linux.dev>; Thu, 20 Feb 2025 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094396; cv=none; b=aCLKWCevk1QM5IyCW0CNshk9Sj1BVajWMed63xqi+6fpm+T7//7loSAh2nsPuzwN/rpJDpwk1H07KvZRAwF6RUxyxwwzCNBHJuIykIqW5nYWw+RnZn/0vFBcQvDyaxVOYTOFUwWnYvpIoqfeEMS9lanR/5R2HAl+WD57nxcxS4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094396; c=relaxed/simple;
	bh=C8t27BV2VXMlLD6CcK4EpcPbKWo+JxK8StRyJsHFHqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=rsVkiz8pxxJbt2PWdtyKIXout3ItBa4p/uWXfC/DOHOxKKJeNPF1UJ9/UZ4LYxRh87Ijq7U0glVbKLSxWhf0Ix98k4UDhBF6S2MARdL2Mya+BJeKlQQqjTjjIRABe2TejK1dQGmNxcngWjvC4ZHVQoJLrdpSeq9Xc9uXlV1cx4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8LWClr7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8LWClr7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740094393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wBGHAqG3qZnjDi/A9mDCk4bg1ubE65WNciioHRx7HTU=;
	b=F8LWClr7SU9YSe8Q35a6JOcs06tQtwBTot8TNwkPUd2WErKs8KBG/a6y/dM0mmHjy7pMkW
	LEXA5cDqS3BVmhB2DuTo0LORyPMF+gbYIvMOFB6FCqDUd9ES1fiAGZjgidJBXWj2bH5C0F
	L9oD6hxkMMpRWnhE52BjBEijCAkZplY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-FNFyeSvEN_Kp3cUw3cg_2w-1; Thu,
 20 Feb 2025 18:33:12 -0500
X-MC-Unique: FNFyeSvEN_Kp3cUw3cg_2w-1
X-Mimecast-MFC-AGG-ID: FNFyeSvEN_Kp3cUw3cg_2w_1740094391
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9409219560B5
	for <dm-devel@lists.linux.dev>; Thu, 20 Feb 2025 23:33:11 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32FE119412A3;
	Thu, 20 Feb 2025 23:33:10 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 39E7E60487; Thu, 20 Feb 2025 18:33:10 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: reorder uds_request to reduce padding
Date: Thu, 20 Feb 2025 18:33:10 -0500
Message-ID: <20250220233310.1342059-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yMw0YHxGAyyIBlYZIZ6DEYMwGdrrLShfhlqcJqqvIq0_1740094391
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
 
 /* Compute the number of bytes needed to store an index. */
-- 
2.45.2

