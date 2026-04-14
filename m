Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3EF1F8723
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126173; cv=none; b=VhKbg5+7CIX0mk/IRjZ66NFGYltAMXA4woMv8J3RUBmzTo0TE9deHmfHkwQq7d0T+H8LyTQy9S33VpzSnNA8HdN3VDmUq1+BqUyGOrzVylKEkpM7W/QK8avyPAqtlyOxHtVhKa2oyVukAsOjsTPB9BjkuxWMsnEx1dns5gnOJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126173; c=relaxed/simple;
	bh=ORIvckZt2jSkddDsux0hSRr+GV/AnGOc9Qvj7yYAm/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ZRximfsmO0Gi80DuEivX5m3RXxUU9faHC2EFCNufFeP764ygHenFKXiXhXMmYfKH1aeUzkr9b4xM9e+Ey+sa3fdK+hpnBEjs+nffdS7cX8Q5aYWCNDNp7mVJBor2ODthBpT8NfnSapQ9ttMTHo7zO5qA5SJZR4sLfYWhj/liZ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I2GeFD7C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2GeFD7C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oF+i8JGuoRRVgN4Ucsmr8gvo+be6kQhWhDQaarZPrg0=;
	b=I2GeFD7CD40Y+iz1k3LCtGPPhMVBxfgptWoUJOxMwFN321akFs/HdHHsEj0WWPu5FmJ4kv
	LoEy33Jgcr9GQfqhUD1HbSzEZR1CVPbIoip89MDII360WbjKmsh3HUO66NP8fTzx0ggZ15
	K4ax8QIkAVzoxXIKHzhyAKwW/8UevTo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-57xWp9rdOfGvz9HWnWHJwg-1; Mon,
 13 Apr 2026 20:22:48 -0400
X-MC-Unique: 57xWp9rdOfGvz9HWnWHJwg-1
X-Mimecast-MFC-AGG-ID: 57xWp9rdOfGvz9HWnWHJwg_1776126166
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5B91180034E;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5363E195608E;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0Mi9u1917470
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0Miid1917469;
	Mon, 13 Apr 2026 20:22:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 01/10] dm-ima: remove dm_ima_reset_data()
Date: Mon, 13 Apr 2026 20:22:35 -0400
Message-ID: <20260414002244.1917447-2-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 0YYG8aHXfxqcJudWlvWvbTJgO2D31AGY5gxdMi9SvjM_1776126166
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There's no point in saving the string length of DM_IMA_VERSION_STR. It's
a constant, so the compiler will precompute it. dm_create() will already
zero out the rest of dm->ima.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c | 32 ++++++++++++--------------------
 drivers/md/dm-ima.h |  3 ---
 drivers/md/dm.c     |  2 --
 3 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 9495ca035056..a639bb0fe6c3 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -159,15 +159,6 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
 			 capacity);
 }
 
-/*
- * Initialize/reset the dm ima related data structure variables.
- */
-void dm_ima_reset_data(struct mapped_device *md)
-{
-	memset(&(md->ima), 0, sizeof(md->ima));
-	md->ima.dm_version_str_len = strlen(DM_IMA_VERSION_STR);
-}
-
 /*
  * Build up the IMA data for each target, and finally measure.
  */
@@ -204,8 +195,8 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 
 	sha256_init(&hash_ctx);
 
-	memcpy(ima_buf + l, DM_IMA_VERSION_STR, table->md->ima.dm_version_str_len);
-	l += table->md->ima.dm_version_str_len;
+	memcpy(ima_buf + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
+	l += strlen(DM_IMA_VERSION_STR);
 
 	device_data_buf_len = strlen(device_data_buf);
 	memcpy(ima_buf + l, device_data_buf, device_data_buf_len);
@@ -260,8 +251,8 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 			 * prefix, so that multiple records from the same "dm_table_load" for
 			 * a given device can be linked together.
 			 */
-			memcpy(ima_buf + l, DM_IMA_VERSION_STR, table->md->ima.dm_version_str_len);
-			l += table->md->ima.dm_version_str_len;
+			memcpy(ima_buf + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
+			l += strlen(DM_IMA_VERSION_STR);
 
 			memcpy(ima_buf + l, device_data_buf, device_data_buf_len);
 			l += device_data_buf_len;
@@ -349,8 +340,8 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	if (capacity_len < 0)
 		goto error;
 
-	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
-	l += md->ima.dm_version_str_len;
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
+	l += strlen(DM_IMA_VERSION_STR);
 
 	if (swap) {
 		if (md->ima.active_table.hash != md->ima.inactive_table.hash)
@@ -460,8 +451,8 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 		goto exit;
 	}
 
-	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
-	l += md->ima.dm_version_str_len;
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
+	l += strlen(DM_IMA_VERSION_STR);
 
 	if (md->ima.active_table.device_metadata) {
 		memcpy(device_table_data + l, device_active_str, device_active_len);
@@ -551,7 +542,8 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	if (md->ima.active_table.hash != md->ima.inactive_table.hash)
 		kfree(md->ima.inactive_table.hash);
 
-	dm_ima_reset_data(md);
+	memset(&md->ima.active_table, 0, sizeof(md->ima.active_table));
+	memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
 
 	kfree(dev_name);
 	kfree(dev_uuid);
@@ -578,8 +570,8 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	if (capacity_len < 0)
 		goto error1;
 
-	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
-	l += md->ima.dm_version_str_len;
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, strlen(DM_IMA_VERSION_STR));
+	l += strlen(DM_IMA_VERSION_STR);
 
 	if (md->ima.inactive_table.device_metadata_len &&
 	    md->ima.inactive_table.hash_len) {
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index a403deca6093..b0b166aa2283 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -52,10 +52,8 @@ struct dm_ima_device_table_metadata {
 struct dm_ima_measurements {
 	struct dm_ima_device_table_metadata active_table;
 	struct dm_ima_device_table_metadata inactive_table;
-	unsigned int dm_version_str_len;
 };
 
-void dm_ima_reset_data(struct mapped_device *md);
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
@@ -64,7 +62,6 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md);
 
 #else
 
-static inline void dm_ima_reset_data(struct mapped_device *md) {}
 static inline void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e178fe19973e..8b60c9804f5b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2546,8 +2546,6 @@ int dm_create(int minor, struct mapped_device **result)
 	if (!md)
 		return -ENXIO;
 
-	dm_ima_reset_data(md);
-
 	*result = md;
 	return 0;
 }
-- 
2.53.0

