Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1779B42069
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723258069; cv=none; b=NPPYwZj+PU/B9M2gEAluPYtpF9EE506O/CAMu7dYkbpIVzCrRda5oVBSn9YJh2gNE2sWxs9sii3QAT1EYW32Vn8lHQeNGMXUXmCEVyAvVmlCY6a/zMa8CIe15cX0xQChvjET8hOwgjV0JJ5vfdxx1/dZmabCfoBVHUdP4zUWh9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723258069; c=relaxed/simple;
	bh=KvB6YpjxRbYfcUw9J6n+MzO8Wc+8MWlh5RoGsuHADdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Diz0oKPFyBMDH84Tp+Z4Yv4Zep2aZn93pOxnVZztYUqQq0B8m+H2yVB265KdefZB9ZEr+ZvLrP1050SJmJ303YqmEMwJMl7s6aMQ3+v069WRMnz/ZUUmCtXZeFyijzLFpinaskQxYxduWI8SVrANCk9kwh1BkfLXDSKpttwDjxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UbZrpMtc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UbZrpMtc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723258066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WUVwLzbKe4Wut7UUbcDLEOIL0ZNnV86B3smNfSp2ER0=;
	b=UbZrpMtcv/fj6t8HzNbC4E/N/EH4zvmgD92AsIemkO78WJbJH4ZPc37h0w6M/FgVXrUehx
	oPHP/bogecixuzMrTxW7z/lMVDZVZDfyUyx7sbeKo8lyLXtZ4gM1r4hxDXZv7G7wzZpuMZ
	cAMjsWED14YlnhTlzyb1bov+NBdP13E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-aqxQ9uAoMfm5DeJNoAnlTg-1; Fri,
 09 Aug 2024 22:47:45 -0400
X-MC-Unique: aqxQ9uAoMfm5DeJNoAnlTg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C9A019560AF
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:47:44 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A1961955D58;
	Sat, 10 Aug 2024 02:47:43 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 464A854760; Fri,  9 Aug 2024 22:47:43 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo: abort loading dirty VDO with the old recovery journal format
Date: Fri,  9 Aug 2024 22:47:42 -0400
Message-ID: <b62f6edc22c48cb00a9d2f8811b8ec79a01bcf04.1723249375.git.msakai@redhat.com>
In-Reply-To: <cover.1723249375.git.msakai@redhat.com>
References: <cover.1723249375.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Abort the load process with status code VDO_UNSUPPORTED_VERSION
without forcing read-only mode when a journal block with the
old format version is detected.

Forcing the VDO volume into read-only mode and thus requiring
a read-only rebuild should only be done when absolutely necessary.

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 24 +++++++++++++++++++++++-
 drivers/md/dm-vdo/repair.c        |  4 +---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index ed1d775de0d3..5b5660404669 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -2296,6 +2296,14 @@ static void handle_load_error(struct vdo_completion *completion)
 		return;
 	}
 
+	if ((completion->result == VDO_UNSUPPORTED_VERSION) &&
+	    (vdo->admin.phase == LOAD_PHASE_MAKE_DIRTY)) {
+		vdo_log_error("Aborting load due to unsupported version");
+		vdo->admin.phase = LOAD_PHASE_FINISHED;
+		load_callback(completion);
+		return;
+	}
+
 	vdo_log_error_strerror(completion->result,
 			       "Entering read-only mode due to load error");
 	vdo->admin.phase = LOAD_PHASE_WAIT_FOR_READ_ONLY;
@@ -2740,6 +2748,19 @@ static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
 		vdo_log_info("starting device '%s'", device_name);
 		result = perform_admin_operation(vdo, LOAD_PHASE_START, load_callback,
 						 handle_load_error, "load");
+		if (result == VDO_UNSUPPORTED_VERSION) {
+			 /*
+			  * A component version is not supported. This can happen when the
+			  * recovery journal metadata is in an old version format. Abort the
+			  * load without saving the state.
+			  */
+			vdo->suspend_type = VDO_ADMIN_STATE_SUSPENDING;
+			perform_admin_operation(vdo, SUSPEND_PHASE_START,
+						suspend_callback, suspend_callback,
+						"suspend");
+			return result;
+		}
+
 		if ((result != VDO_SUCCESS) && (result != VDO_READ_ONLY)) {
 			/*
 			 * Something has gone very wrong. Make sure everything has drained and
@@ -2811,7 +2832,8 @@ static int vdo_preresume(struct dm_target *ti)
 
 	vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 	result = vdo_preresume_registered(ti, vdo);
-	if ((result == VDO_PARAMETER_MISMATCH) || (result == VDO_INVALID_ADMIN_STATE))
+	if ((result == VDO_PARAMETER_MISMATCH) || (result == VDO_INVALID_ADMIN_STATE) ||
+	    (result == VDO_UNSUPPORTED_VERSION))
 		result = -EINVAL;
 	vdo_unregister_thread_device_id();
 	return vdo_status_to_errno(result);
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index b6f3d0710a21..28475eee0058 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1574,9 +1574,7 @@ static int parse_journal_for_recovery(struct repair_completion *repair)
 		if (header.metadata_type == VDO_METADATA_RECOVERY_JOURNAL) {
 			/* This is an old format block, so we need to upgrade */
 			vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
-					       "Recovery journal is in the old format, a read-only rebuild is required.");
-			vdo_enter_read_only_mode(repair->completion.vdo,
-						 VDO_UNSUPPORTED_VERSION);
+					       "Recovery journal is in the old format. Downgrade and complete recovery, then upgrade with a clean volume");
 			return VDO_UNSUPPORTED_VERSION;
 		}
 
-- 
2.45.2

