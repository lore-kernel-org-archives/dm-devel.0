Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7B1198E91
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126172; cv=none; b=a9Qz28q6xRAdaD/46g5ueOazsEHtIlVmridaDkyZn3S9YLuJkh9CpWIoC8OmkhkiLqlEZoryYcBHUpIJI2wHFvXeWzpMFjL/7McYp1F7vC1afwqh1mt9LwtocPxBCd2FpxPpwPB82APhIN2ZpvtFTomcSu0THFgDc+LtFMMIZGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126172; c=relaxed/simple;
	bh=ZPf6+GyTYTtLJpb2olr89OG+58T8BFpkfO45JkufXOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Ig8Cj2OJjcdNlaLiXhatzkW68ijnH2nHlmvxgfM94wIhI75ldktZnBYwqhbsmWoqR6AlVQi057N90EuDKEV9XFD5HnPElHuepc084ahJyZ+i5Ddg5Oby/7dRC1+q0YLfK/edoSmkdTY8qmllw9lkWuI+x6aaXRDr48hJiX7vbv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bD7ZOs+i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bD7ZOs+i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wuX7YZ9gmtzkSJwSnc3wdTpZ7pYRQ0Q/XfXE0uaqq+0=;
	b=bD7ZOs+iwQU7CZUDTILwAKV9fFQGdW71oFO3t9aYeSa2x/kf2ZgN79hx/9TIf8HijUuqC8
	IPEKZnMBK64hEABtfezKn+AjrC+ey88749SQagM9imRAFPXRgmACuvWe5142LxK1l4zXZU
	/IoGmJxqf6aOJdkeflcGiQ/CKj7WhbQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-3XoPpnAjPD-81Ld1JJN6gQ-1; Mon,
 13 Apr 2026 20:22:48 -0400
X-MC-Unique: 3XoPpnAjPD-81Ld1JJN6gQ-1
X-Mimecast-MFC-AGG-ID: 3XoPpnAjPD-81Ld1JJN6gQ_1776126166
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B24ED195608E;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62EE23000C1F;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0Mj4x1917478
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0Mja51917477;
	Mon, 13 Apr 2026 20:22:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 03/10] dm-ima: Remove status_flags from dm_ima_measure_on_table_load()
Date: Mon, 13 Apr 2026 20:22:37 -0400
Message-ID: <20260414002244.1917447-4-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 5BR1uGbAfXpkK4O4OH74ouPCDD8sbUuQ8fI8zcVe46k_1776126166
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There is no status flag that is is used for STATUSTYPE_IMA type
status() calls, and STATUSTYPE_IMA itself is not a valid
status flag.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c   | 4 ++--
 drivers/md/dm-ima.h   | 4 ++--
 drivers/md/dm-ioctl.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 209221fa8bc5..8b84b676cad4 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -162,7 +162,7 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
 /*
  * Build up the IMA data for each target, and finally measure.
  */
-void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags)
+void dm_ima_measure_on_table_load(struct dm_table *table)
 {
 	size_t device_data_buf_len, target_metadata_buf_len, target_data_buf_len, l = 0;
 	char *target_metadata_buf = NULL, *target_data_buf = NULL, *digest_buf = NULL;
@@ -217,7 +217,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 		 * Then retrieve the actual target data.
 		 */
 		if (ti->type->status)
-			ti->type->status(ti, type, status_flags, target_data_buf,
+			ti->type->status(ti, type, 0, target_data_buf,
 					 DM_IMA_TARGET_DATA_BUF_LEN);
 		else
 			target_data_buf[0] = '\0';
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index b0b166aa2283..c0548492bef0 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -54,7 +54,7 @@ struct dm_ima_measurements {
 	struct dm_ima_device_table_metadata inactive_table;
 };
 
-void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
+void dm_ima_measure_on_table_load(struct dm_table *table);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
@@ -62,7 +62,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md);
 
 #else
 
-static inline void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
+static inline void dm_ima_measure_on_table_load(struct dm_table *table) {}
 static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
 static inline void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 405acc14d718..1a0dd4981d03 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1548,7 +1548,7 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (r)
 		goto err_unlock_md_type;
 
-	dm_ima_measure_on_table_load(t, STATUSTYPE_IMA);
+	dm_ima_measure_on_table_load(t);
 
 	immutable_target_type = dm_get_immutable_target_type(md);
 	if (immutable_target_type &&
-- 
2.53.0

