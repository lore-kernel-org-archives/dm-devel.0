Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFBD392C40
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 20:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777494082; cv=none; b=WrsjAZyO2VCPt9vgBDHXF75P1d84J6dr2UhDSNaMvdIhRBHQfLua0kmg7CxfFUx17MQsasr0sw4bnCkJsc0FkgjZNeIDHsVMvRHuB6fdddtA9Rf5WzRZKclW3wmtlLdrpw4yUznCrBEDo8fW9dusPdy27F/N5/cVWOSEdFGgNJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777494082; c=relaxed/simple;
	bh=SMTcW6mQxI8y93oCc+V/UUhsQZBKX/Zd1L8aqgFDV5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=WE+Obqp73O8QWjtn+9fJ0oU4X53Cw5OZhII6mNvB93gWN5ylho1cKJsCUENKh0oFPxb9oiEeQiKy7MwqS3J9zvslAdXQKgYyFMV6lg6PAdbEfiCSISlyiS46r0h0UOWix/+DjqBIxyEdVZmQ5TF9tOqT6GW578HRlI2y5YZzeI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9GTRNk0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9GTRNk0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777494080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QofwoMwxSCGblSWZLoeJ9G1stYebwuDx/UerX9q6nec=;
	b=U9GTRNk0mWHY1lh4hApJQQiT6rsuXUPHierSJ0q/GPTw+biIegiiTRcBdGho8wDUg7mGvG
	eM5tvKMA9/f3QQ5MSGJTlOtrqBheabfKAs9ZfpPEHPJhc3bVUfN/Tcgg/k5MTZ7FX8qa8a
	NeG8u+n1Q5rty5ytBwWYGJ72N3oSsrw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-JNke8-QsMkSa15wDqhYvQA-1; Wed,
 29 Apr 2026 16:21:14 -0400
X-MC-Unique: JNke8-QsMkSa15wDqhYvQA-1
X-Mimecast-MFC-AGG-ID: JNke8-QsMkSa15wDqhYvQA_1777494072
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3305D195605E;
	Wed, 29 Apr 2026 20:21:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A0D180045E;
	Wed, 29 Apr 2026 20:21:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63TKLAMp2823316
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 16:21:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63TKLA8s2823315;
	Wed, 29 Apr 2026 16:21:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        steven chen <chenste@linux.microsoft.com>
Subject: [PATCH v2 09/10] dm-ima: Fail more gracefully in dm_ima_measure_on_*
Date: Wed, 29 Apr 2026 16:21:07 -0400
Message-ID: <20260429202108.2823261-10-bmarzins@redhat.com>
In-Reply-To: <20260429202108.2823261-1-bmarzins@redhat.com>
References: <20260429202108.2823261-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: kYQv9SAMQCob9QiXv40mmHH4IHHD-6uJNOLXEt3n-u4_1777494072
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In all the dm_ima_measure_on_* functions besides
dm_ima_measure_on_table_load(), even if measuring the event fails, it's
still possible to update dm->ima, so that it continues to correctly
track the device state. This means that one measurement failure won't
cause future measurements to record the wrong data.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 47af99c9b79c..5e2efcd1de33 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -357,17 +357,6 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap,
 
 	wait_to_measure(&md->ima, context->update_idx);
 
-	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, noio);
-	if (!device_table_data)
-		goto error;
-
-	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
-	if (capacity_len < 0)
-		goto error;
-
-	memcpy(device_table_data + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
-	l += strlen(DM_IMA_VERSION_STR);
-
 	if (swap) {
 		kfree(md->ima.active_table.hash);
 		kfree(md->ima.active_table.device_metadata);
@@ -388,6 +377,17 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap,
 		}
 	}
 
+	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, noio);
+	if (!device_table_data)
+		goto error;
+
+	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (capacity_len < 0)
+		goto error;
+
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
+	l += strlen(DM_IMA_VERSION_STR);
+
 	if (md->ima.active_table.device_metadata) {
 		memcpy(device_table_data + l, md->ima.active_table.device_metadata,
 		       md->ima.active_table.device_metadata_len);
@@ -621,11 +621,11 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md,
 
 	dm_ima_measure_data("dm_table_clear", device_table_data, l, noio);
 
+error:
 	kfree(md->ima.inactive_table.hash);
 	kfree(md->ima.inactive_table.device_metadata);
 	memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
 
-error:
 	kfree(capacity_str);
 	kfree(device_table_data);
 
@@ -649,6 +649,8 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md,
 
 	wait_to_measure(&md->ima, context->update_idx);
 
+	fix_context_strings(context);
+
 	combined_device_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN * 2, noio);
 	if (!combined_device_data)
 		goto exit;
@@ -662,11 +664,15 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md,
 		old_device_data = md->ima.inactive_table.device_metadata;
 	else
 		old_device_data = "device_rename=no_data;";
-	fix_context_strings(context);
 	len = scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2,
 			"%s%snew_name=%s,new_uuid=%s;%s", DM_IMA_VERSION_STR, old_device_data,
 			context->dev_name, context->dev_uuid, capacity_str);
 
+	dm_ima_measure_data("dm_device_rename", combined_device_data, len, noio);
+exit:
+	kfree(capacity_str);
+	kfree(combined_device_data);
+
 	if (md->ima.active_table.device_metadata) {
 		table = &md->ima.active_table;
 		dm_ima_copy_device_data(md, table->device_metadata, context,
@@ -681,11 +687,5 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md,
 		table->device_metadata_len = strlen(table->device_metadata);
 	}
 
-	dm_ima_measure_data("dm_device_rename", combined_device_data, len, noio);
-
-exit:
-	kfree(capacity_str);
-	kfree(combined_device_data);
-
 	wake_next_measure(&md->ima);
 }
-- 
2.53.0

