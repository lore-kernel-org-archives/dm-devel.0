Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C15C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 20:35:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-DnCIbQeLP4qb7z30mMr5_A-1; Thu, 06 Jan 2022 15:35:09 -0500
X-MC-Unique: DnCIbQeLP4qb7z30mMr5_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A62D81CCB5;
	Thu,  6 Jan 2022 20:35:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3C32E2C8;
	Thu,  6 Jan 2022 20:35:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 19AAC1809CB9;
	Thu,  6 Jan 2022 20:35:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206KZ16T023491 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 15:35:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CD42492D4B; Thu,  6 Jan 2022 20:35:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 187AE492D40
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 20:35:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2DA92A59560
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 20:35:00 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de
	[81.169.146.165]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-471-sfsrRkhHMwqUZiZnMuzE2w-1; Thu, 06 Jan 2022 15:34:57 -0500
X-MC-Unique: sfsrRkhHMwqUZiZnMuzE2w-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
	with ESMTPSA id k3f463y06KYp05f
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Thu, 6 Jan 2022 21:34:51 +0100 (CET)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Thu,  6 Jan 2022 21:34:34 +0100
Message-Id: <20220106203436.281629-2-public@thson.de>
In-Reply-To: <20220106203436.281629-1-public@thson.de>
References: <20220106203436.281629-1-public@thson.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, linux-integrity@vger.kernel.org,
	Thore Sommer <public@thson.de>
Subject: [dm-devel] [RFC PATCH 1/3] dm ima: allow targets to remeasure their
	table entry
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A new DM event dm_target_update is introduced for targets to remeasure
their table entry. This is intended for targets that indicate security
relevant events by updating one of their table entries (e.g. verity for
corruption).

In the event the dm version, device metadata and target data gets
measured.

This does not update the hash of the active table because it would require
to rehash the whole table with all the other targets entries.

Signed-off-by: Thore Sommer <public@thson.de>
---
 drivers/md/dm-ima.c | 76 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h |  2 ++
 2 files changed, 78 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 957999998d70..3b1bb97263d9 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -750,3 +750,79 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	kfree(new_dev_name);
 	kfree(new_dev_uuid);
 }
+
+/*
+ * Give the option for targets to remeasure on state change.
+ */
+void dm_ima_measure_on_target_update(struct dm_target *ti)
+{
+	char *ima_buf = NULL, *target_metadata_buf = NULL, *target_data_buf = NULL;
+	struct dm_target *ti2;
+	size_t target_metadata_buf_len, target_data_buf_len;
+	unsigned int num_targets, target_index;
+	struct dm_table *table = ti->table;
+	struct mapped_device *md = table->md;
+	bool found = false;
+	bool noio = true;
+	int l = 0;
+
+	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
+	if (!ima_buf)
+		return;
+
+	target_metadata_buf = dm_ima_alloc(DM_IMA_TARGET_METADATA_BUF_LEN, GFP_KERNEL, noio);
+	if (!target_metadata_buf)
+		goto exit;
+
+	target_data_buf = dm_ima_alloc(DM_IMA_TARGET_DATA_BUF_LEN, GFP_KERNEL, noio);
+	if (!target_data_buf)
+		goto exit;
+
+	/*
+	 * Get the index of the target in the table.
+	 */
+	num_targets = dm_table_get_num_targets(table);
+	for (target_index = 0; target_index < num_targets; target_index++) {
+		ti2 = dm_table_get_target(table, target_index);
+		if (!ti)
+			goto exit;
+		if (ti == ti2) {
+			found = true;
+			break;
+		}
+	}
+	if (!found)
+		goto exit;
+
+	scnprintf(target_metadata_buf, DM_IMA_TARGET_METADATA_BUF_LEN,
+			  "target_index=%d,target_begin=%llu,target_len=%llu,",
+			  target_index, ti->begin, ti->len);
+	target_metadata_buf_len = strlen(target_metadata_buf);
+
+	if (ti->type->status)
+		ti->type->status(ti, STATUSTYPE_IMA, STATUSTYPE_IMA, target_data_buf,
+					DM_IMA_TARGET_DATA_BUF_LEN);
+	else
+		target_data_buf[0] = '\0';
+	target_data_buf_len = strlen(target_data_buf);
+
+	memcpy(ima_buf + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
+	l += md->ima.dm_version_str_len;
+
+	memcpy(ima_buf + l, md->ima.active_table.device_metadata,
+	       md->ima.active_table.device_metadata_len);
+	l += md->ima.active_table.device_metadata_len;
+
+	memcpy(ima_buf + l, target_metadata_buf, target_metadata_buf_len);
+	l += target_metadata_buf_len;
+
+	memcpy(ima_buf + l, target_data_buf, target_data_buf_len);
+
+	dm_ima_measure_data("dm_target_update", ima_buf, strlen(ima_buf), noio);
+
+exit:
+	kfree(ima_buf);
+	kfree(target_data_buf);
+	kfree(target_metadata_buf);
+}
+EXPORT_SYMBOL_GPL(dm_ima_measure_on_target_update);
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index b8c3b614670b..281a8b65f8a9 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -63,6 +63,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
 void dm_ima_measure_on_device_rename(struct mapped_device *md);
+void dm_ima_measure_on_target_update(struct dm_target *ti);
 
 #else
 
@@ -72,6 +73,7 @@ static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, boo
 static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
 static inline void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
 static inline void dm_ima_measure_on_device_rename(struct mapped_device *md) {}
+static inline void dm_ima_measure_on_target_update(struct dm_target *ti) {}
 
 #endif /* CONFIG_IMA */
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

