Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F620C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 17:38:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E68246101E
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 17:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E68246101E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=thson.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-pTEJSdhvOEOla6n7cnS_vA-1; Wed, 28 Jul 2021 13:38:07 -0400
X-MC-Unique: pTEJSdhvOEOla6n7cnS_vA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE1A7107465F;
	Wed, 28 Jul 2021 17:38:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F9776060F;
	Wed, 28 Jul 2021 17:38:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B04DB4BB7C;
	Wed, 28 Jul 2021 17:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16SHc0Ui005709 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 13:38:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 509172089A1B; Wed, 28 Jul 2021 17:38:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B55F2089A17
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 17:37:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A78B8D138A
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 17:37:57 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de
	[85.215.255.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-332-32oiCAIhMx2PGcebljFOVg-1; Wed, 28 Jul 2021 13:37:54 -0400
X-MC-Unique: 32oiCAIhMx2PGcebljFOVg-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoau5J4Tj7+uA76w8eadkyoCWU/S6TOnfqgd7To/uJm/gTTBonpqa8ec="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.28.1 AUTH)
	with ESMTPSA id t06ddcx6SHYlteJ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Wed, 28 Jul 2021 19:34:47 +0200 (CEST)
From: Thore Sommer <public@thson.de>
To: agk@redhat.com
Date: Wed, 28 Jul 2021 19:34:40 +0200
Message-Id: <20210728173440.1121652-1-public@thson.de>
In-Reply-To: <20210727203337.GA81220@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
References: <20210727203337.GA81220@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	dm-devel@redhat.com, public@thson.de,
	tusharsu@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
	IMA
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Alasdair,

thank you for answering my questions. The answers helped a lot.

> Having other triggering mechanisms - such as hooking into internal
> events when something unexpected happens - could be considered for
> follow-on patches.

I've written [1] a proof of concept implementation that provides a hook for
targets to remeasure their state. This was my first attempt at writing kernel
code, so there might be some serious bugs. With something like this implemented
remote attestation for state of dm-verity should be possible.

The output if a target calls that hook is:
device_update DEVICE_METADATA;TARGET_METADATA,TARGET_STATUS

Regards,
Thore

[1]
diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 2d796e439bee..b743a2e9add4 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -703,3 +703,84 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	kfree(new_dev_name);
 	kfree(new_dev_uuid);
 }
+
+/*
+ * Give the option for targets to remeasure on state change.
+ */
+void dm_ima_measure_on_target_update(struct dm_target *ti){
+	char *ima_buf = NULL, *target_metadata_buf = NULL, *target_data_buf= NULL;
+	status_type_t type = STATUSTYPE_IMA;
+	size_t target_metadata_buf_len, target_data_buf_len;
+	unsigned int num_targets, i;
+	struct dm_table *table = ti->table;
+	struct mapped_device *md = table->md;
+	unsigned int  target_num = -1;
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
+
+	num_targets = dm_table_get_num_targets(table);
+
+	// Get target number
+	for (i = 0; i < num_targets; i++){
+		struct dm_target *ti2 = dm_table_get_target(table, i);
+		if (!ti)
+			goto exit;
+		if (ti == ti2){
+			target_num = i;
+			break;
+		}
+	}
+	if (target_num == -1)
+		goto exit;
+
+	/*
+	 * First retrieve the target metadata.
+	 */
+	scnprintf(target_metadata_buf, DM_IMA_TARGET_METADATA_BUF_LEN,
+			  "target_index=%d,target_begin=%llu,target_len=%llu,",
+			  target_num, ti->begin, ti->len);
+	target_metadata_buf_len = strlen(target_metadata_buf);
+
+	/*
+	 * Then retrieve the actual target data.
+	 */
+	if (ti->type->status)
+		ti->type->status(ti, type, STATUSTYPE_IMA, target_data_buf,
+					DM_IMA_TARGET_DATA_BUF_LEN);
+	else
+		target_data_buf[0] = '\0';
+	target_data_buf_len = strlen(target_data_buf);
+
+	// Add the device metadata
+	memcpy(ima_buf + l, md->ima.active_table.device_metadata, md->ima.active_table.device_metadata_len);
+	l += md->ima.active_table.device_metadata_len;
+
+	// Add the target metadata
+	memcpy(ima_buf + l, target_metadata_buf, target_metadata_buf_len);
+	l += target_metadata_buf_len;
+
+	// Add the new target state
+	memcpy(ima_buf + l, target_data_buf, target_data_buf_len);
+
+	dm_ima_measure_data("device_update", ima_buf, strlen(ima_buf), noio);
+
+exit:
+	kfree(ima_buf);
+	kfree(target_data_buf);
+	kfree(target_metadata_buf);
+}
+
+EXPORT_SYMBOL_GPL(dm_ima_measure_on_target_update);
\ No newline at end of file
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 6e6f18bf05b4..f90c4147277a 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -53,6 +53,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
 void dm_ima_measure_on_device_rename(struct mapped_device *md);
+void dm_ima_measure_on_target_update(struct dm_target *ti);
 
 #else
 
@@ -62,6 +63,7 @@ static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, boo
 static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
 static inline void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
 static inline void dm_ima_measure_on_device_rename(struct mapped_device *md) {}
+static inline void dm_ima_measure_on_target_update(struct dm_target *ti) {}
 
 #endif /* CONFIG_IMA */
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bfefa100c265..f0764dd8bd4d 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -16,6 +16,7 @@
 #include "dm-verity.h"
 #include "dm-verity-fec.h"
 #include "dm-verity-verify-sig.h"
+#include "dm-ima.h"
 #include <linux/module.h>
 #include <linux/reboot.h>
 
@@ -217,10 +218,15 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 	char *envp[] = { verity_env, NULL };
 	const char *type_str = "";
 	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	int old_hash_failed = v->hash_failed;
 
 	/* Corruption should be visible in device status in all modes */
 	v->hash_failed = 1;
 
+	if (!old_hash_failed){
+		dm_ima_measure_on_target_update(v->ti);
+	}
+
 	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
 		goto out;
 
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

