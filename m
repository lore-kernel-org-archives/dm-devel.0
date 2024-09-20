Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A7183CCA
	for <dm-devel@lists.linux.dev>; Fri, 20 Sep 2024 22:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726870430; cv=none; b=koXEpGOv2bMaAm1zxXC0gJHp9BOpIGg9TTt7PNf+/x/xquoOggwKZ8NvwRDkU2lphP0MZqXInwipCS92zspvpgrQQ90p2zxUTiPvnuRazCc5JzJS29C/5DrcfKhsz1GmKDq49LDirfoflfN5kUZ+8t9yUtG4WJ7WabqCQAPud/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726870430; c=relaxed/simple;
	bh=rfTgDC3RMLjaRGxlJcXsJF5JYLxRx86obDX0d7aCVrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YpFaduDQ4XxpYgLLHO3sudg1XFZbC/79eZrtHKwtbQjw5VU2Avfz5THEX8djHcqYNzjIhoUEAcfvAE9pP0VppLdXTbJJgqgKQlmFVKyx/aCg3S5BB6ThEBYvMiuEPOGc3Me7kAzAEcQ0JgVYLGF152qPC0AmNtQVPuMTiG41fqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCDSt6+O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCDSt6+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726870427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Sst7k/jAU2BOcvV4AGmH2ZggpGvDC3qUU+7OFTXJKfM=;
	b=VCDSt6+OVe94R3qrFPRABASwwPg5Ko9oteppaXoiiIplLL4RZ3KQC98+hUvekcHJSlF9bd
	M0fP5y2dakU+YNWJQChyN0XObDgqexrvbenkvD5k6s73gZOGfUI3ZzFtCHJzorw2tnTZim
	cboFZCyS+HplJqz5UYAhHd9cC0ca5vk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-17FcWVObPBK6eUs5MdY3NQ-1; Fri,
 20 Sep 2024 18:13:46 -0400
X-MC-Unique: 17FcWVObPBK6eUs5MdY3NQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 301F91918DDD
	for <dm-devel@lists.linux.dev>; Fri, 20 Sep 2024 22:13:45 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F0301956052;
	Fri, 20 Sep 2024 22:13:45 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 9A49A5710F; Fri, 20 Sep 2024 18:13:44 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: handle unaligned discards correctly
Date: Fri, 20 Sep 2024 18:13:44 -0400
Message-ID: <d5cee9e5a1d083fc366506dbbb6ad00b0ab6be79.1726869977.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Reset the data_vio properly for each discard block, and delay
acknowledgement and cleanup until all discard blocks are complete.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/data-vio.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 94f6f1ccfb7d..79fbf34763a2 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -501,6 +501,7 @@ static void launch_data_vio(struct data_vio *data_vio, logical_block_number_t lb
 
 	memset(&data_vio->record_name, 0, sizeof(data_vio->record_name));
 	memset(&data_vio->duplicate, 0, sizeof(data_vio->duplicate));
+	vdo_reset_completion(&data_vio->decrement_completion);
 	vdo_reset_completion(completion);
 	completion->error_handler = handle_data_vio_error;
 	set_data_vio_logical_callback(data_vio, attempt_logical_block_lock);
@@ -1274,12 +1275,14 @@ static void clean_hash_lock(struct vdo_completion *completion)
 static void finish_cleanup(struct data_vio *data_vio)
 {
 	struct vdo_completion *completion = &data_vio->vio.completion;
+	u32 discard_size = min_t(u32, data_vio->remaining_discard,
+				 VDO_BLOCK_SIZE - data_vio->offset);
 
 	VDO_ASSERT_LOG_ONLY(data_vio->allocation.lock == NULL,
 			    "complete data_vio has no allocation lock");
 	VDO_ASSERT_LOG_ONLY(data_vio->hash_lock == NULL,
 			    "complete data_vio has no hash lock");
-	if ((data_vio->remaining_discard <= VDO_BLOCK_SIZE) ||
+	if ((data_vio->remaining_discard <= discard_size) ||
 	    (completion->result != VDO_SUCCESS)) {
 		struct data_vio_pool *pool = completion->vdo->data_vio_pool;
 
@@ -1288,12 +1291,12 @@ static void finish_cleanup(struct data_vio *data_vio)
 		return;
 	}
 
-	data_vio->remaining_discard -= min_t(u32, data_vio->remaining_discard,
-					     VDO_BLOCK_SIZE - data_vio->offset);
+	data_vio->remaining_discard -= discard_size;
 	data_vio->is_partial = (data_vio->remaining_discard < VDO_BLOCK_SIZE);
 	data_vio->read = data_vio->is_partial;
 	data_vio->offset = 0;
 	completion->requeue = true;
+	data_vio->first_reference_operation_complete = false;
 	launch_data_vio(data_vio, data_vio->logical.lbn + 1);
 }
 
@@ -1966,7 +1969,8 @@ static void allocate_block(struct vdo_completion *completion)
 		.state = VDO_MAPPING_STATE_UNCOMPRESSED,
 	};
 
-	if (data_vio->fua) {
+	if (data_vio->fua ||
+	    data_vio->remaining_discard > (u32) (VDO_BLOCK_SIZE - data_vio->offset)) {
 		prepare_for_dedupe(data_vio);
 		return;
 	}
@@ -2043,7 +2047,6 @@ void continue_data_vio_with_block_map_slot(struct vdo_completion *completion)
 		return;
 	}
 
-
 	/*
 	 * We don't need to write any data, so skip allocation and just update the block map and
 	 * reference counts (via the journal).
@@ -2052,7 +2055,7 @@ void continue_data_vio_with_block_map_slot(struct vdo_completion *completion)
 	if (data_vio->is_zero)
 		data_vio->new_mapped.state = VDO_MAPPING_STATE_UNCOMPRESSED;
 
-	if (data_vio->remaining_discard > VDO_BLOCK_SIZE) {
+	if (data_vio->remaining_discard > (u32) (VDO_BLOCK_SIZE - data_vio->offset)) {
 		/* This is not the final block of a discard so we can't acknowledge it yet. */
 		update_metadata_for_data_vio_write(data_vio, NULL);
 		return;
-- 
2.45.2

