Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAE33264F2
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375619; cv=none; b=uyiQ9m2v5EHf93cPFSwoNChZ6CWGN2P+jpS+xV/PLbLDn43+e2ELmFeWZpjM4y10dHFQFUKQwjEcBid7/5b+YbI3d9HxjH2SQKI1BCHLA0NonJrNf3XWJtcJpLcnPU5Q5CsMLs2LrxQOj88NfcooJB1jKT12BWU+n2Sp0S9IBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375619; c=relaxed/simple;
	bh=Yo47g7bDq2VIw9aAQh80BcHZMRQdY3xLd60AI9MJ4BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=p/9Q0df2Ca4Xmhg/JfLtAIrlCtlnJREhbRmJNYAyJLV66oM5fzR522+KlkOKFDiGd+Xboz4wt7+hpA2/jpygW9+YcXBnUshbjvfbEH5jXJOKp4JyPhNVj6/cWkQxdim6Zs+Lzsf8nMZpzG3Oqz4l5FbogGSRnkjHPHMbgXHq/J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KqsqSeBk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqsqSeBk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7EpO8ypW9afz0s1g9FmtR1otyqfW8+7iPnP/rT8Xos=;
	b=KqsqSeBknxu+2SpLbpNratY2vZtArUpRr6/w0es9DavQIptUBdVV4W9peehGzzJNAPuaF1
	WLWWwuguvE/lTwAHuUxw0Hk+IAtDzY0M7ZRdnFD9bpVOpv34h0sAh5CTLe83vnNrUqShRa
	e+RboY2r/vpt+NUef/kNL0DjcEduZS8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-s58xqohMNfWYp86AcPm4yg-1; Tue,
 24 Mar 2026 14:06:55 -0400
X-MC-Unique: s58xqohMNfWYp86AcPm4yg-1
X-Mimecast-MFC-AGG-ID: s58xqohMNfWYp86AcPm4yg_1774375614
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92623180034E
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:54 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 749A01800361;
	Tue, 24 Mar 2026 18:06:54 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 7B1321D649; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 9/9] dm vdo: save the formatted metadata to disk
Date: Tue, 24 Mar 2026 14:06:52 -0400
Message-ID: <20260324180652.69439-10-bjohnsto@redhat.com>
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u90IRo34RTZ1j8bBm3OMUPIl7km9IjHb9GgOJDwlI_A_1774375614
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add vdo_save_super_block() and vdo_save_geometry_block() to perform
asynchronous writes of the super block and geometry block respectively.
Add vdo_clear_layout() to zero the UDS index's first block, the block
map partition, and the recovery journal partition.

These operations are driven by new phases in the pre-load state machine
(PRE_LOAD_PHASE_FORMAT_*), ensuring that disk writes happen during
pre-resume rather than during dmsetup create.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c |  36 +++++++++
 drivers/md/dm-vdo/vdo.c           | 122 +++++++++++++++++++++++++-----
 drivers/md/dm-vdo/vdo.h           |   9 +++
 3 files changed, 147 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index cee6e4edf768..0135a6f941fd 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -61,6 +61,11 @@ enum admin_phases {
 	LOAD_PHASE_DRAIN_JOURNAL,
 	LOAD_PHASE_WAIT_FOR_READ_ONLY,
 	PRE_LOAD_PHASE_START,
+	PRE_LOAD_PHASE_FORMAT_START,
+	PRE_LOAD_PHASE_FORMAT_SUPER,
+	PRE_LOAD_PHASE_FORMAT_GEOMETRY,
+	PRE_LOAD_PHASE_FORMAT_END,
+	PRE_LOAD_PHASE_LOAD_SUPER,
 	PRE_LOAD_PHASE_LOAD_COMPONENTS,
 	PRE_LOAD_PHASE_END,
 	PREPARE_GROW_PHYSICAL_PHASE_START,
@@ -110,6 +115,11 @@ static const char * const ADMIN_PHASE_NAMES[] = {
 	"LOAD_PHASE_DRAIN_JOURNAL",
 	"LOAD_PHASE_WAIT_FOR_READ_ONLY",
 	"PRE_LOAD_PHASE_START",
+	"PRE_LOAD_PHASE_FORMAT_START",
+	"PRE_LOAD_PHASE_FORMAT_SUPER",
+	"PRE_LOAD_PHASE_FORMAT_GEOMETRY",
+	"PRE_LOAD_PHASE_FORMAT_END",
+	"PRE_LOAD_PHASE_LOAD_SUPER",
 	"PRE_LOAD_PHASE_LOAD_COMPONENTS",
 	"PRE_LOAD_PHASE_END",
 	"PREPARE_GROW_PHYSICAL_PHASE_START",
@@ -1487,7 +1497,33 @@ static void pre_load_callback(struct vdo_completion *completion)
 			vdo_continue_completion(completion, result);
 			return;
 		}
+		if (vdo->needs_formatting)
+			vdo->admin.phase = PRE_LOAD_PHASE_FORMAT_START;
+		else
+			vdo->admin.phase = PRE_LOAD_PHASE_LOAD_SUPER;
 
+		vdo_continue_completion(completion, VDO_SUCCESS);
+		return;
+
+	case PRE_LOAD_PHASE_FORMAT_START:
+		vdo_continue_completion(completion, vdo_clear_layout(vdo));
+		return;
+
+	case PRE_LOAD_PHASE_FORMAT_SUPER:
+		vdo_save_super_block(vdo, completion);
+		return;
+
+	case PRE_LOAD_PHASE_FORMAT_GEOMETRY:
+		vdo_save_geometry_block(vdo, completion);
+		return;
+
+	case PRE_LOAD_PHASE_FORMAT_END:
+		/* cleanup layout before load adds to it */
+		vdo_uninitialize_layout(&vdo->states.layout);
+		vdo_continue_completion(completion, VDO_SUCCESS);
+		return;
+
+	case PRE_LOAD_PHASE_LOAD_SUPER:
 		vdo_load_super_block(vdo, completion);
 		return;
 
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index b5e64af13437..7bec2418c121 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -491,6 +491,8 @@ static int __must_check vdo_format(struct vdo *vdo, char **error_ptr)
 		return result;
 	}
 
+	vdo->needs_formatting = true;
+
 	return VDO_SUCCESS;
 }
 
@@ -951,24 +953,101 @@ static void record_vdo(struct vdo *vdo)
 	vdo->states.layout = vdo->layout;
 }
 
+static int __must_check clear_partition(struct vdo *vdo, enum partition_id id)
+{
+	struct partition *partition;
+	int result;
+
+	result = vdo_get_partition(&vdo->states.layout, id, &partition);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	return blkdev_issue_zeroout(vdo_get_backing_device(vdo),
+				    partition->offset * VDO_SECTORS_PER_BLOCK,
+				    partition->count * VDO_SECTORS_PER_BLOCK,
+				    GFP_NOWAIT, 0);
+}
+
+int vdo_clear_layout(struct vdo *vdo)
+{
+	int result;
+
+	/* Zero out the uds index's first block. */
+	result = blkdev_issue_zeroout(vdo_get_backing_device(vdo),
+				      VDO_SECTORS_PER_BLOCK,
+				      VDO_SECTORS_PER_BLOCK,
+				      GFP_NOWAIT, 0);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	result = clear_partition(vdo, VDO_BLOCK_MAP_PARTITION);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	return clear_partition(vdo, VDO_RECOVERY_JOURNAL_PARTITION);
+}
+
 /**
- * continue_super_block_parent() - Continue the parent of a super block save operation.
- * @completion: The super block vio.
+ * continue_parent() - Continue the parent of a save operation.
+ * @completion: The completion to continue.
  *
- * This callback is registered in vdo_save_components().
  */
-static void continue_super_block_parent(struct vdo_completion *completion)
+static void continue_parent(struct vdo_completion *completion)
 {
 	vdo_continue_completion(vdo_forget(completion->parent), completion->result);
 }
 
+static void handle_write_endio(struct bio *bio)
+{
+	struct vio *vio = bio->bi_private;
+	struct vdo_completion *parent = vio->completion.parent;
+
+	continue_vio_after_io(vio, continue_parent,
+			      parent->callback_thread_id);
+}
+
 /**
- * handle_save_error() - Log a super block save error.
+ * handle_geometry_block_save_error() - Log a geometry block save error.
+ * @completion: The super block vio.
+ *
+ * This error handler is registered in vdo_save_geometry_block().
+ */
+static void handle_geometry_block_save_error(struct vdo_completion *completion)
+{
+	struct vdo_geometry_block *geometry_block =
+		container_of(as_vio(completion), struct vdo_geometry_block, vio);
+
+	vio_record_metadata_io_error(&geometry_block->vio);
+	vdo_log_error_strerror(completion->result, "geometry block save failed");
+	completion->callback(completion);
+}
+
+/**
+ * vdo_save_geometry_block() - Encode the vdo and save the geometry block asynchronously.
+ * @vdo: The vdo whose state is being saved.
+ * @parent: The completion to notify when the save is complete.
+ */
+void vdo_save_geometry_block(struct vdo *vdo, struct vdo_completion *parent)
+{
+	struct vdo_geometry_block *geometry_block = &vdo->geometry_block;
+
+	vdo_encode_volume_geometry(geometry_block->buffer, &vdo->geometry,
+				   VDO_DEFAULT_GEOMETRY_BLOCK_VERSION);
+	geometry_block->vio.completion.parent = parent;
+	geometry_block->vio.completion.callback_thread_id = parent->callback_thread_id;
+	vdo_submit_metadata_vio(&geometry_block->vio,
+				VDO_GEOMETRY_BLOCK_LOCATION,
+				handle_write_endio, handle_geometry_block_save_error,
+				REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA);
+}
+
+/**
+ * handle_super_block_save_error() - Log a super block save error.
  * @completion: The super block vio.
  *
  * This error handler is registered in vdo_save_components().
  */
-static void handle_save_error(struct vdo_completion *completion)
+static void handle_super_block_save_error(struct vdo_completion *completion)
 {
 	struct vdo_super_block *super_block =
 		container_of(as_vio(completion), struct vdo_super_block, vio);
@@ -987,17 +1066,27 @@ static void handle_save_error(struct vdo_completion *completion)
 	completion->callback(completion);
 }
 
-static void super_block_write_endio(struct bio *bio)
+/**
+ * vdo_save_super_block() - Save the component states to the super block asynchronously.
+ * @vdo: The vdo whose state is being saved.
+ * @parent: The completion to notify when the save is complete.
+ */
+void vdo_save_super_block(struct vdo *vdo, struct vdo_completion *parent)
 {
-	struct vio *vio = bio->bi_private;
-	struct vdo_completion *parent = vio->completion.parent;
+	struct vdo_super_block *super_block = &vdo->super_block;
 
-	continue_vio_after_io(vio, continue_super_block_parent,
-			      parent->callback_thread_id);
+	vdo_encode_super_block(super_block->buffer, &vdo->states);
+	super_block->vio.completion.parent = parent;
+	super_block->vio.completion.callback_thread_id = parent->callback_thread_id;
+	vdo_submit_metadata_vio(&super_block->vio,
+				vdo_get_data_region_start(vdo->geometry),
+				handle_write_endio, handle_super_block_save_error,
+				REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA);
 }
 
 /**
- * vdo_save_components() - Encode the vdo and save the super block asynchronously.
+ * vdo_save_components() - Copy the current state of the VDO to the states struct and save
+ *                         it to the super block asynchronously.
  * @vdo: The vdo whose state is being saved.
  * @parent: The completion to notify when the save is complete.
  */
@@ -1016,14 +1105,7 @@ void vdo_save_components(struct vdo *vdo, struct vdo_completion *parent)
 	}
 
 	record_vdo(vdo);
-
-	vdo_encode_super_block(super_block->buffer, &vdo->states);
-	super_block->vio.completion.parent = parent;
-	super_block->vio.completion.callback_thread_id = parent->callback_thread_id;
-	vdo_submit_metadata_vio(&super_block->vio,
-				vdo_get_data_region_start(vdo->geometry),
-				super_block_write_endio, handle_save_error,
-				REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA);
+	vdo_save_super_block(vdo, parent);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 21f6ac999e9d..9a63f5d45ce3 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -246,6 +246,7 @@ struct vdo {
 	const struct admin_state_code *suspend_type;
 	bool allocations_allowed;
 	bool dump_on_shutdown;
+	bool needs_formatting;
 	atomic_t processing_message;
 
 	/*
@@ -314,6 +315,10 @@ int __must_check vdo_make(unsigned int instance, struct device_config *config,
 
 void vdo_destroy(struct vdo *vdo);
 
+int __must_check vdo_format_components(struct vdo *vdo);
+
+void vdo_format_super_block(struct vdo *vdo, struct vdo_completion *parent);
+
 void vdo_load_super_block(struct vdo *vdo, struct vdo_completion *parent);
 
 struct block_device * __must_check vdo_get_backing_device(const struct vdo *vdo);
@@ -336,6 +341,10 @@ enum vdo_state __must_check vdo_get_state(const struct vdo *vdo);
 
 void vdo_set_state(struct vdo *vdo, enum vdo_state state);
 
+int vdo_clear_layout(struct vdo *vdo);
+void vdo_save_geometry_block(struct vdo *vdo, struct vdo_completion *parent);
+void vdo_save_super_block(struct vdo *vdo, struct vdo_completion *parent);
+
 void vdo_save_components(struct vdo *vdo, struct vdo_completion *parent);
 
 int vdo_register_read_only_listener(struct vdo *vdo, void *listener,
-- 
2.52.0

