Return-Path: <SRS0=SrOh=MF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78667C07E9A
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:55:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F0F4D6100C
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0F4D6100C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-eOQ9IgifPS-aY90IhdNumA-1; Mon, 12 Jul 2021 20:55:52 -0400
X-MC-Unique: eOQ9IgifPS-aY90IhdNumA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E205280006E;
	Tue, 13 Jul 2021 00:55:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 835E018A50;
	Tue, 13 Jul 2021 00:55:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49A821809C99;
	Tue, 13 Jul 2021 00:55:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16D0tgL6025259 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Jul 2021 20:55:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D32DF2051AC7; Tue, 13 Jul 2021 00:55:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD83A2041AB6
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECAB2185A794
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:39 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-518-ydNg2oYDO7yq5-0WxhA7zg-1;
	Mon, 12 Jul 2021 20:55:38 -0400
X-MC-Unique: ydNg2oYDO7yq5-0WxhA7zg-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 946E020B8016;
	Mon, 12 Jul 2021 17:49:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 946E020B8016
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Mon, 12 Jul 2021 17:49:02 -0700
Message-Id: <20210713004904.8808-6-tusharsu@linux.microsoft.com>
In-Reply-To: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16D0tgL6025259
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	linux-integrity@vger.kernel.org, zohar@linux.ibm.com
Subject: [dm-devel] [PATCH 5/7] dm: measure data on device rename
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Update the device data with the new values for IMA measurements.  Measure
both old and new device name/UUID parameters in the same IMA measurement
event, so that the old and the new values can be connected later.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-ima.c   | 49 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |  1 +
 drivers/md/dm-ioctl.c |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index b1e1cf6bb4e7..36f99848825a 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -664,12 +664,61 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	kfree(device_table_data);
 }
 
+/*
+ * Measure IMA data on device rename.
+ */
+void dm_ima_measure_on_device_rename(struct mapped_device *md)
+{
+	char *old_device_data = NULL, *new_device_data = NULL, *combined_device_data = NULL;
+	char *new_dev_name = NULL, *new_dev_uuid = NULL, *capacity_str = NULL;
+	bool noio = true;
+	int r;
+
+	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
+					      md->ima.active_table.num_targets, noio))
+		return;
+
+	if (dm_ima_alloc_and_copy_name_uuid(md, &new_dev_name, &new_dev_uuid, noio))
+		goto error;
+
+	combined_device_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN * 2, GFP_KERNEL, noio);
+	if (!combined_device_data)
+		goto error;
+
+	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (r)
+		goto error;
+
+	old_device_data = md->ima.active_table.device_metadata;
+
+	md->ima.active_table.device_metadata = new_device_data;
+	md->ima.active_table.device_metadata_len = strlen(new_device_data);
+
+	scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2, "%snew_name=%s,new_uuid=%s;%s",
+		  old_device_data, new_dev_name, new_dev_uuid, capacity_str);
+
+	dm_ima_measure_data("device_rename", combined_device_data, strlen(combined_device_data),
+			    noio);
+
+	goto exit;
+
+error:
+	kfree(new_device_data);
+exit:
+	kfree(capacity_str);
+	kfree(combined_device_data);
+	kfree(old_device_data);
+	kfree(new_dev_name);
+	kfree(new_dev_uuid);
+}
+
 #else
 void dm_ima_reset_data(struct mapped_device *md) {}
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
+void dm_ima_measure_on_device_rename(struct mapped_device *md) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index a17ae953dc67..b1cf014d538d 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -51,5 +51,6 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
+void dm_ima_measure_on_device_rename(struct mapped_device *md);
 
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b07c19037c7c..e45f6c6ef84a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -485,6 +485,9 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	md = hc->md;
+
+	dm_ima_measure_on_device_rename(md);
+
 	up_write(&_hash_lock);
 	kfree(old_name);
 
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

