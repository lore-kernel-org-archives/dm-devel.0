Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C8FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jan 2022 14:06:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-yPcL5CLrMdC-3UnN9kZHQA-1; Tue, 25 Jan 2022 09:06:20 -0500
X-MC-Unique: yPcL5CLrMdC-3UnN9kZHQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D09C84DA48;
	Tue, 25 Jan 2022 14:06:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD6FF7BB41;
	Tue, 25 Jan 2022 14:06:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B12231809CB8;
	Tue, 25 Jan 2022 14:06:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20PE63nb023654 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 Jan 2022 09:06:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F33451454543; Tue, 25 Jan 2022 14:06:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF5D41454539
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 14:06:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0CF83C118C3
	for <dm-devel@redhat.com>; Tue, 25 Jan 2022 14:06:02 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[85.215.255.20]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-32-nq1e26CpNAqq_gcXmHprSw-1; Tue, 25 Jan 2022 09:05:58 -0500
X-MC-Unique: nq1e26CpNAqq_gcXmHprSw-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
	with ESMTPSA id 23d6f4y0PE5rNWI
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Tue, 25 Jan 2022 15:05:53 +0100 (CET)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Tue, 25 Jan 2022 15:05:47 +0100
Message-Id: <20220125140547.714184-1-public@thson.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, Thore Sommer <public@thson.de>
Subject: [dm-devel] [PATCH] dm ima: fix wrong length calculation for no_data
	string
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

All entries measured by dm ima are prefixed by a version string
(dm_version=N.N.N). When there is no data to measure, the entire buffer is
overwritten with a string containing the version string again and the
length of that string is added to the length of the version string.
The new length is now wrong because it contains the version string twice.

This caused entries like this:
dm_version=4.45.0;name=test,uuid=test;table_clear=no_data; \
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00 \
current_device_capacity=204808;

Signed-off-by: Thore Sommer <public@thson.de>
---
 drivers/md/dm-ima.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 957999998d70..1842d3a958ef 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -455,7 +455,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
 			  "%sname=%s,uuid=%s;device_resume=no_data;",
 			  DM_IMA_VERSION_STR, dev_name, dev_uuid);
-		l += strlen(device_table_data);
+		l = strlen(device_table_data);
 
 	}
 
@@ -568,7 +568,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
 			  "%sname=%s,uuid=%s;device_remove=no_data;",
 			  DM_IMA_VERSION_STR, dev_name, dev_uuid);
-		l += strlen(device_table_data);
+		l = strlen(device_table_data);
 	}
 
 	memcpy(device_table_data + l, remove_all_str, remove_all_len);
@@ -654,7 +654,7 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
 			  "%sname=%s,uuid=%s;table_clear=no_data;",
 			   DM_IMA_VERSION_STR, dev_name, dev_uuid);
-		l += strlen(device_table_data);
+		l = strlen(device_table_data);
 	}
 
 	capacity_len = strlen(capacity_str);
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

