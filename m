Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E8AC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4812A206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4812A206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-V3KA48jUO9i9XIoCwwvBZA-1; Mon, 04 Jan 2021 14:04:02 -0500
X-MC-Unique: V3KA48jUO9i9XIoCwwvBZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 395C5107ACFE;
	Mon,  4 Jan 2021 19:03:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A3621001E73;
	Mon,  4 Jan 2021 19:03:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E44265003B;
	Mon,  4 Jan 2021 19:03:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT8tiDH010797 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 03:55:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F23C2026D49; Tue, 29 Dec 2020 08:55:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A77D2026D47
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 08:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 465DB101A560
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 08:55:44 +0000 (UTC)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
	[209.85.210.201]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-456-NAkjc2XmPT2-DtPeFu8ULg-1; Tue, 29 Dec 2020 03:55:40 -0500
X-MC-Unique: NAkjc2XmPT2-DtPeFu8ULg-1
Received: by mail-pf1-f201.google.com with SMTP id 22so4274155pfv.22
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 00:55:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=2LL28w8HYDB56TY4Xorb2dz9gBz+2+A0z3a585XX/NA=;
	b=bKf/3JEHItykqAvRN8stWPXZ11jUxJSgrrP3lP9KPsI5G9X/+U3JDRBPIOfuX1zUPb
	2B8FeTRrbv+gTDvMYjSVS1aUlru10v9CLsE7RJfqTUKjuiuAmZLlpccb2q4NTsK0Gu5r
	/Lka6Yb6hlD09vlZRMtJPFjLYGEWNl+BNOdN40hr3R++ZVzLMi96ngw+944X+Ic4UiiK
	rFj5F6ZFBUmiq+rbfK9wus/Uo5kTy3ethvDuh9/SV3cfkHVi3ftsE7z3wKW6ya0xAyp2
	bOH0+5ZDfzeAabQoofWhm7VhbKVug+mSdGQADYst06nUP2Re+yvX5mJ7DySxap0B4L88
	3IAw==
X-Gm-Message-State: AOAM533EwWti0kCrFguf+40VWS7boO3qAw1pGfouE2QgtgLk8lUkF1JD
	pfXIXcNCmNaI+JdJAYNWt2CRP00A3iw=
X-Google-Smtp-Source: ABdhPJy6RhyhTBX3auLabsBxWya+RNuNUROjMBZdQZOWghOMiLaEGenNF5fpXuLFLtCdUUfLnFSYw+uPxJE=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:a17:902:a585:b029:db:feae:425c with
	SMTP id
	az5-20020a170902a585b02900dbfeae425cmr48031963plb.25.1609232138954;
	Tue, 29 Dec 2020 00:55:38 -0800 (PST)
Date: Tue, 29 Dec 2020 08:55:23 +0000
In-Reply-To: <20201229085524.2795331-1-satyat@google.com>
Message-Id: <20201229085524.2795331-6-satyat@google.com>
Mime-Version: 1.0
References: <20201229085524.2795331-1-satyat@google.com>
From: Satya Tangirala <satyat@google.com>
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v3 5/6] dm: Verify inline encryption capabilities
 of new table when it is loaded
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

DM only allows the table to be swapped if the new table's inline encryption
capabilities are a superset of the old table's. We only check that this
constraint is true when the table is actually swapped in (in
dm_swap_table()). But this allows a user to load an unacceptable table
without any complaint from DM, only for DM to throw an error when the
device is resumed, and the table is swapped in.

This patch makes DM verify the inline encryption capabilities of the new
table when the table is loaded. DM continues to verify and use the
capabilities at the time of table swap, since the capabilities of
underlying child devices can expand during the time between the table load
and table swap (which in turn can cause the capabilities of this parent
device to expand as well).

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/md/dm-ioctl.c |  8 ++++++++
 drivers/md/dm.c       | 25 +++++++++++++++++++++++++
 drivers/md/dm.h       | 19 +++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5e306bba4375..055a3c745243 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1358,6 +1358,10 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 		goto err_unlock_md_type;
 	}
 
+	r = dm_verify_inline_encryption(md, t);
+	if (r)
+		goto err_unlock_md_type;
+
 	if (dm_get_md_type(md) == DM_TYPE_NONE) {
 		/* Initial table load: acquire type of table. */
 		dm_set_md_type(md, dm_table_get_type(t));
@@ -2115,6 +2119,10 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	if (r)
 		goto err_destroy_table;
 
+	r = dm_verify_inline_encryption(md, t);
+	if (r)
+		goto err_destroy_table;
+
 	md->type = dm_table_get_type(t);
 	/* setup md->queue to reflect md's type (may block) */
 	r = dm_setup_md_queue(md, t);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b8844171d8e4..04322de34d29 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2094,6 +2094,31 @@ dm_construct_keyslot_manager(struct mapped_device *md, struct dm_table *t)
 	return ksm;
 }
 
+/**
+ * dm_verify_inline_encryption() - Verifies that the current keyslot manager of
+ *				   the mapped_device can be replaced by the
+ *				   keyslot manager of a given dm_table.
+ * @md: The mapped_device
+ * @t: The dm_table
+ *
+ * In particular, this function checks that the keyslot manager that will be
+ * constructed for the dm_table will support a superset of the capabilities that
+ * the current keyslot manager of the mapped_device supports.
+ *
+ * Return: 0 if the table's keyslot_manager can replace the current keyslot
+ *	   manager of the mapped_device. Negative value otherwise.
+ */
+int dm_verify_inline_encryption(struct mapped_device *md, struct dm_table *t)
+{
+	struct blk_keyslot_manager *ksm = dm_construct_keyslot_manager(md, t);
+
+	if (IS_ERR(ksm))
+		return PTR_ERR(ksm);
+	dm_destroy_keyslot_manager(ksm);
+
+	return 0;
+}
+
 static void dm_update_keyslot_manager(struct request_queue *q,
 				      struct blk_keyslot_manager *ksm)
 {
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index fffe1e289c53..eaf92e4cbe70 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -208,4 +208,23 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
  */
 unsigned dm_get_reserved_bio_based_ios(void);
 
+/*
+ *  Inline Encryption
+ */
+struct blk_keyslot_manager;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+
+int dm_verify_inline_encryption(struct mapped_device *md, struct dm_table *t);
+
+#else /* !CONFIG_BLK_INLINE_ENCRYPTION */
+
+static inline int dm_verify_inline_encryption(struct mapped_device *md,
+					      struct dm_table *t)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_BLK_INLINE_ENCRYPTION */
+
 #endif
-- 
2.29.2.729.g45daf8777d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

