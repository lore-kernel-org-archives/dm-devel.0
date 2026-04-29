Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8273B3939B1
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 20:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777494082; cv=none; b=KEDEUfDKJKZrlbSnP8z4VmJMLHRa4PGRdl7OnSEa0+P509UXFu1GGKzWn8O/p21nUV5NsEqYkM/Al54X54h6m5ZrHiZxfT2KgWelPvQ7geMlkFxcoTSbXVEd/undult2BvuU9BM0mSw53rmE0WbM0q2uEPOxwBndPBPVFfwbIH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777494082; c=relaxed/simple;
	bh=jWFjd5Wdi3AOccT9GTdXOGJaQvG2/ZYt2cK4IJQxg9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=MB4StYO2UGZ8VEwwjuZRq16hgthtOgMgUOIam9k/SN35MmOQC7aVVuj5s42JJsPbtwG14A86y4QFIIy7W23ryU5RmYiHX5NJlkj9n3v+tX/QjtlmZebjNHhn0NAqzBt1UpZCKR8fkThae71T0syAzncGfsukwUh4lQEZJI53m/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MoBFLKrc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MoBFLKrc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777494079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYkLh9bC9ifBjvBZ7J6NOmEIfBfQMxuwlkqale5umV0=;
	b=MoBFLKrcWI8As0tbhj8GSvLldz0rKvKPv4p644LtlJlgH67rrKfQoUxonKXBOO6Vey9Y6/
	3SVmYWTpszOYqroBBF5aqjR74Pk/3pJ0NU+sbqTHaxfkq+KZji7QXtG2F7I8w3kKuWPbUi
	yHVLJbVrG0ayw0MZx/mgtJ1hUAj0uRo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-0wy6pmwmPk-oMqnOd8Z4ag-1; Wed,
 29 Apr 2026 16:21:13 -0400
X-MC-Unique: 0wy6pmwmPk-oMqnOd8Z4ag-1
X-Mimecast-MFC-AGG-ID: 0wy6pmwmPk-oMqnOd8Z4ag_1777494071
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B80F1800367;
	Wed, 29 Apr 2026 20:21:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 045F61955D87;
	Wed, 29 Apr 2026 20:21:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63TKL99C2823292
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 16:21:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63TKL9wC2823291;
	Wed, 29 Apr 2026 16:21:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        steven chen <chenste@linux.microsoft.com>
Subject: [PATCH v2 03/10] dm-ima: Remove status_flags from dm_ima_measure_on_table_load()
Date: Wed, 29 Apr 2026 16:21:01 -0400
Message-ID: <20260429202108.2823261-4-bmarzins@redhat.com>
In-Reply-To: <20260429202108.2823261-1-bmarzins@redhat.com>
References: <20260429202108.2823261-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: FDTUj7P1UmvDsZNAz3bHl7O62d91qSAuEZgo9IOXn3E_1777494071
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
index a529174c94cf..074a3c71297e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1552,7 +1552,7 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (r)
 		goto err_unlock_md_type;
 
-	dm_ima_measure_on_table_load(t, STATUSTYPE_IMA);
+	dm_ima_measure_on_table_load(t);
 
 	immutable_target_type = dm_get_immutable_target_type(md);
 	if (immutable_target_type &&
-- 
2.53.0

