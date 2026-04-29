Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8BA3845A8
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 20:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777494079; cv=none; b=JTet6VTSKNispaK771ZkKPbNQ0/zPqE+PLKgP0v/3kt+5EBG3Ct+/HC/Hmp4VgcE4tIVcaSWr6u9t+5biIpw1XryrJdi0B0oeAS81/XtmxTMC5Br7qtCDVmfC+ctkNwDGLoK0JhYb930jMScs8sVAfFhzPflo9XR8RfVPJaap7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777494079; c=relaxed/simple;
	bh=P5alIJUUmY1lpBkvNpSnFRVT50MtLpogSuCpQY0Hobc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QUHskGxKykFM1PmCIx7QQTqIaLgSDl1SbxVEE4e/CGqDSohAo1Giiuleq5zNWmVbvURGHyHSCGNuKiV9y8jCZjz2gkU964w+icCtt8x/aZ/idlT6T00jXR6ZWNFDY4Y4HBnCwlOPgN1Aex1M0ynB5RnYecRM7yf799OMfkq3pMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3Q3H+VW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3Q3H+VW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777494076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1g4lvY6xuWafXxo+AvK3Goh3dz6EPlc0z01DDgJonM=;
	b=f3Q3H+VWYjNdC0GJBigyht54aQbgPpgCk61uHkiCQmRvHXQxn9+7BTEGvNcLC+JK82VDhb
	HWSAW5swksPw4PxUL+Q7Zjsjoyt7mgbF0aW9zhLjEgVXEGmLq9hxMrSH2+p0304vbdd5gI
	mnWiBQ+waaXOZ4NTYXeK1KndBMlMgA8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-2ZGst7ieMG23kmTrIOnTTQ-1; Wed,
 29 Apr 2026 16:21:13 -0400
X-MC-Unique: 2ZGst7ieMG23kmTrIOnTTQ-1
X-Mimecast-MFC-AGG-ID: 2ZGst7ieMG23kmTrIOnTTQ_1777494072
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C19718002C6;
	Wed, 29 Apr 2026 20:21:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9E1419560B7;
	Wed, 29 Apr 2026 20:21:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63TKLAhk2823308
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 16:21:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63TKLAfD2823307;
	Wed, 29 Apr 2026 16:21:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        steven chen <chenste@linux.microsoft.com>
Subject: [PATCH v2 07/10] dm-ima: Fix issues with dm_ima_measure_on_device_rename
Date: Wed, 29 Apr 2026 16:21:05 -0400
Message-ID: <20260429202108.2823261-8-bmarzins@redhat.com>
In-Reply-To: <20260429202108.2823261-1-bmarzins@redhat.com>
References: <20260429202108.2823261-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 02z5LLoTK6Y34SSPA_32zRL0XKWdDRHgtFqtm-eRuOM_1777494072
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm_ima_measure_on_device_rename() can be called on a device before it
ever loads a table, so it needs to handle the case where there is no
table metadata. Also, it was only updating the table_metadata on the
active table. If there was an inactive table when the device was renamed
and that table was later swapped in as the active table, it would
still have the old name. dm_ima_measure_on_device_rename() was also
needlessly allocating new memory for the updated table metadata, instead
of just reusing the existing memory.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c | 69 ++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 75c46b5af3f7..f563c4381489 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -133,22 +133,18 @@ void dm_ima_context_table_op(struct mapped_device *md,
 }
 
 /*
- * Internal function to allocate and copy device data for IMA measurements.
+ * Internal function to copy device data for IMA measurements.
  */
-static int dm_ima_alloc_and_copy_device_data(struct mapped_device *md, char **device_data,
-					     struct dm_ima_context *context,
-					     unsigned int num_targets, bool noio)
+static void dm_ima_copy_device_data(struct mapped_device *md, char *device_data,
+				    struct dm_ima_context *context,
+				    unsigned int num_targets)
 {
-	*device_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, noio);
-	if (!(*device_data))
-		return -ENOMEM;
-
-	scnprintf(*device_data, DM_IMA_DEVICE_BUF_LEN,
+	memset(device_data, 0, DM_IMA_DEVICE_BUF_LEN);
+	scnprintf(device_data, DM_IMA_DEVICE_BUF_LEN,
 		  "name=%s,uuid=%s,major=%d,minor=%d,minor_count=%d,num_targets=%u;",
 		  context->dev_name, context->dev_uuid, md->disk->major,
 		  md->disk->first_minor, md->disk->minors, num_targets);
 
-	return 0;
 }
 
 /*
@@ -223,11 +219,14 @@ void dm_ima_measure_on_table_load(struct dm_table *table,
 
 	num_targets = table->num_targets;
 
-	fix_context_strings(context);
-	if (dm_ima_alloc_and_copy_device_data(table->md, &device_data_buf,
-					      context, num_targets, noio))
+	device_data_buf = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, noio);
+	if (!device_data_buf)
 		goto error;
 
+	fix_context_strings(context);
+	dm_ima_copy_device_data(table->md, device_data_buf, context,
+				num_targets);
+
 	sha256_init(&hash_ctx);
 
 	memcpy(ima_buf + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
@@ -626,48 +625,54 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md,
 void dm_ima_measure_on_device_rename(struct mapped_device *md,
 				     struct dm_ima_context *context)
 {
-	char *old_device_data = NULL, *new_device_data = NULL;
+	char *old_device_data = NULL;
 	char *combined_device_data = NULL, *capacity_str = NULL;
 	bool noio = true;
 	int len;
+	struct dm_ima_device_table_metadata *table;
 
 	if (unlikely(!context))
 		return;
 
 	wait_to_measure(&md->ima, context->update_idx);
 
-	fix_context_strings(context);
-	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data, context,
-					      md->ima.active_table.num_targets,
-					      noio))
-		goto error;
-
 	combined_device_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN * 2, noio);
 	if (!combined_device_data)
-		goto error;
+		goto exit;
 
 	if (dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio) < 0)
-		goto error;
-
-	old_device_data = md->ima.active_table.device_metadata;
-
-	md->ima.active_table.device_metadata = new_device_data;
-	md->ima.active_table.device_metadata_len = strlen(new_device_data);
+		goto exit;
 
+	if (md->ima.active_table.device_metadata)
+		old_device_data = md->ima.active_table.device_metadata;
+	else if (md->ima.inactive_table.device_metadata)
+		old_device_data = md->ima.inactive_table.device_metadata;
+	else
+		old_device_data = "device_rename=no_data;";
+	fix_context_strings(context);
 	len = scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2,
 			"%s%snew_name=%s,new_uuid=%s;%s", DM_IMA_VERSION_STR, old_device_data,
 			context->dev_name, context->dev_uuid, capacity_str);
 
-	dm_ima_measure_data("dm_device_rename", combined_device_data, len, noio);
+	if (md->ima.active_table.device_metadata) {
+		table = &md->ima.active_table;
+		dm_ima_copy_device_data(md, table->device_metadata, context,
+					table->num_targets);
+		table->device_metadata_len = strlen(table->device_metadata);
+	}
 
-	goto exit;
+	if (md->ima.inactive_table.device_metadata) {
+		table = &md->ima.inactive_table;
+		dm_ima_copy_device_data(md, table->device_metadata, context,
+					table->num_targets);
+		table->device_metadata_len = strlen(table->device_metadata);
+	}
+
+	dm_ima_measure_data("dm_device_rename", combined_device_data, len, noio);
 
-error:
-	kfree(new_device_data);
 exit:
 	kfree(capacity_str);
 	kfree(combined_device_data);
-	kfree(old_device_data);
 
 	wake_next_measure(&md->ima);
 }
-- 
2.53.0

