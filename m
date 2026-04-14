Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4C11D5CC6
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126172; cv=none; b=m502z/QnQkJlSFshURo1t56EuJPnwrrge9dKF7Cb+3SzGiJ4GFS1T3RXgdthyPAW6YZ4TPxPaBsFWq4JmoRh6CeaYZ0UKMis1+x55XksWgYpNNn78G/NNAMGwfzBlzi1j4hMbbKVilUPgMUpIpF5e2T6VOUC8I//DrPEQwN2zZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126172; c=relaxed/simple;
	bh=FhEQ6kO3b6LAjKUyVD2j7dR+0ivy3buI8Po9yZsBeZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LfI7ci4+ahHf3w6uioA2NTH5oT2BIIlejx/bq2gikZdJAUaKVq3yKItlUSPPVTSJNT01ggQDrED13EfYahmEdJXgrOjHSA+1xOHhCeoFAaRt6N86MMqKRiQ88sT9lMcQ7JXplMk2KSt7qEaDFIxVyTVnbEoFukJYhwcykW6l/Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/fedyy/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/fedyy/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ow9dlW10/tlQES5/kiZlse5U/0qRpFUE3A6ttc28T3g=;
	b=f/fedyy/Xs8RRIRODbgvhCpLHF5Ictg9QR+X6TUQGKt9jDaK5iz4189QkgMr/Jeb1BkPsi
	9/7/jVSmHFduATH7IwF7M+zjTJ0s6ebwbT4qT3mfDnEU8Lwu+Ftpxenx2YEC3ebNiikD1F
	Tf/NsHRLx4/6woQFArVKGaeMcQgXOX4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-c7WZAyk2MdOC5q7G8KpXEw-1; Mon,
 13 Apr 2026 20:22:49 -0400
X-MC-Unique: c7WZAyk2MdOC5q7G8KpXEw-1
X-Mimecast-MFC-AGG-ID: c7WZAyk2MdOC5q7G8KpXEw_1776126167
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3A8E1956095;
	Tue, 14 Apr 2026 00:22:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D1243000C1F;
	Tue, 14 Apr 2026 00:22:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0MkNr1917502
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0Mkkm1917501;
	Mon, 13 Apr 2026 20:22:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 09/10] dm-ima: Fail more gracefully in dm_ima_measure_on_*
Date: Mon, 13 Apr 2026 20:22:43 -0400
Message-ID: <20260414002244.1917447-10-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: PceLRnAU91Ys4Wah7IU0WjSWJ0FmmnKMqgdQeKhAEu4_1776126167
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
index 4631dc2a6d4d..45038bd65f7b 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -351,17 +351,6 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap,
 		    context->update_idx));
 	smp_mb();
 
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
@@ -382,6 +371,17 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap,
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
@@ -624,11 +624,11 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md,
 
 	dm_ima_measure_data("dm_table_clear", device_table_data, l, noio);
 
+error:
 	kfree(md->ima.inactive_table.hash);
 	kfree(md->ima.inactive_table.device_metadata);
 	memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
 
-error:
 	kfree(capacity_str);
 	kfree(device_table_data);
 
@@ -657,6 +657,8 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md,
 		    context->update_idx));
 	smp_mb();
 
+	fix_context_strings(context);
+
 	combined_device_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN * 2, noio);
 	if (!combined_device_data)
 		goto exit;
@@ -670,11 +672,15 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md,
 		old_device_data = md->ima.inactive_table.device_metadata;
 	else
 		old_device_data = "table_rename=no_data;";
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
@@ -689,12 +695,6 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md,
 		table->device_metadata_len = strlen(table->device_metadata);
 	}
 
-	dm_ima_measure_data("dm_device_rename", combined_device_data, len, noio);
-
-exit:
-	kfree(capacity_str);
-	kfree(combined_device_data);
-
 	smp_mb__before_atomic();
 	atomic_inc(&md->ima.measure_idx);
 	wake_up_all(&md->ima.ima_wq);
-- 
2.53.0

