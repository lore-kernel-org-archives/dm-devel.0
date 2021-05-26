Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC60C4707F
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:09:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8920613F1
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8920613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-0zcvLVgcNZqiJcvCsZ280w-1; Tue, 25 May 2021 21:09:53 -0400
X-MC-Unique: 0zcvLVgcNZqiJcvCsZ280w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AA9818358F3;
	Wed, 26 May 2021 01:09:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB46460C04;
	Wed, 26 May 2021 01:09:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3C20180B464;
	Wed, 26 May 2021 01:09:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q19iT5020088 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 21:09:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 174E420287CC; Wed, 26 May 2021 01:09:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1230820287A8
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A98DC80D0E0
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-228-Eeg7Cw8ZPlaXqqdbzWoTcQ-1;
	Tue, 25 May 2021 21:09:39 -0400
X-MC-Unique: Eeg7Cw8ZPlaXqqdbzWoTcQ-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9FAD520B800D;
	Tue, 25 May 2021 18:00:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9FAD520B800D
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com
Date: Tue, 25 May 2021 17:59:52 -0700
Message-Id: <20210526005954.31564-6-tusharsu@linux.microsoft.com>
In-Reply-To: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
References: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	zohar@linux.ibm.com, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC 5/7] dm: measure data on device rename
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A given block device is identified by it's name and UUID.  However, both
these parameters can be renamed.  For an external attestation service to
correctly attest a given device, it needs to keep track of these rename
events.

Fix if there are any separator characters in the new name/UUID. Update 
the device data for IMA with the new values. Measure both old device
data and the new device name/UUID parameters in the same IMA measurement
event, so that the old and new values can be connected later.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-ima.c   | 70 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |  1 +
 drivers/md/dm-ioctl.c |  3 ++
 3 files changed, 74 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 6670b5f74004..511d471648a1 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -361,11 +361,81 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	return;
 }
 
+/*
+ * Measure IMA data on device rename
+ */
+void dm_ima_measure_on_device_rename(struct mapped_device *md)
+{
+	char *old_device_data = NULL, *new_device_data = NULL, *combined_device_data = NULL;
+	char *new_dev_name = NULL, *new_dev_uuid = NULL;
+	unsigned int noio_flag;
+	sector_t capacity;
+
+	noio_flag = memalloc_noio_save();
+	new_device_data = kzalloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+
+	if (!new_device_data)
+		return;
+
+	noio_flag = memalloc_noio_save();
+	new_dev_name = kzalloc(DM_NAME_LEN*2, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+	if (!new_dev_name)
+		goto error;
+
+	memalloc_noio_restore(noio_flag);
+	new_dev_uuid = kzalloc(DM_UUID_LEN*2, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+	if (!new_dev_uuid)
+		goto error;
+
+	if (dm_copy_name_and_uuid(md, new_dev_name, new_dev_uuid))
+		goto error;
+
+	fix_separator_chars(&new_dev_name);
+	fix_separator_chars(&new_dev_uuid);
+
+	noio_flag = memalloc_noio_save();
+	combined_device_data = kzalloc(DM_IMA_DEVICE_BUF_LEN * 2, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+
+	if (!combined_device_data)
+		goto error;
+
+	capacity = get_capacity(md->disk);
+
+	old_device_data = md->ima.device_data;
+
+	scnprintf(new_device_data, DM_IMA_DEVICE_BUF_LEN,
+		  "name=%s;uuid=%s;capacity=%llu;major=%d;minor=%d;minor_count=%d;num_targets=%u;",
+		  new_dev_name, new_dev_uuid, capacity, md->disk->major, md->disk->first_minor,
+		  md->disk->minors, md->ima.num_targets);
+	md->ima.device_data = new_device_data;
+	md->ima.device_data_len = strlen(new_device_data);
+
+	scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2, "%snew_name=%s;new_uuid=%s;",
+		  old_device_data, new_dev_name, new_dev_uuid);
+
+	dm_ima_measure_data("device_rename", combined_device_data, strlen(combined_device_data));
+
+	goto exit;
+
+error:
+	kfree(new_device_data);
+exit:
+	kfree(combined_device_data);
+	kfree(old_device_data);
+	kfree(new_dev_name);
+	kfree(new_dev_uuid);
+}
+
 #else
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 void dm_ima_measure_on_device_remove(struct mapped_device *md) {}
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
+void dm_ima_measure_on_device_rename(struct mapped_device *md) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index ed633e031a18..340032f1d07f 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -36,5 +36,6 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md);
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
+void dm_ima_measure_on_device_rename(struct mapped_device *md);
 
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b4f47d596985..9d8258dd014e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -486,6 +486,9 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	md = hc->md;
+
+	dm_ima_measure_on_device_rename(md);
+
 	up_write(&_hash_lock);
 	kfree(old_name);
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

