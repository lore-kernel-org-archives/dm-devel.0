Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C0AC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910471;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Gbfxg2q8w8EXy6KiAM8KLxxVFvySeWyPfRsSzI/HaEg=;
	b=ISmS7sGMt86BvAIeQDaHE5HIKOVChtKFalX1rZhkS/yBLFAQnXO0Rn2+koitUdsH9jI9Ks
	utoMwLKCTwKgOtNIoSH5go2nLLijzrV1eIIRvfUcWYE9y2+6Chtw0Ihs1pi7OJJFVzuH1c
	Tc42cdjEqnbZT5cOregFg50Ca1WuzCs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-ssJHkY-rPDeC6sK0dY3_rA-1; Thu, 14 Apr 2022 00:27:50 -0400
X-MC-Unique: ssJHkY-rPDeC6sK0dY3_rA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FFE11014A61;
	Thu, 14 Apr 2022 04:27:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F804416158;
	Thu, 14 Apr 2022 04:27:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37FB41940345;
	Thu, 14 Apr 2022 04:27:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CD481940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42414C28114; Thu, 14 Apr 2022 04:27:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32309C08087;
 Thu, 14 Apr 2022 04:27:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4RiOo025309;
 Wed, 13 Apr 2022 23:27:45 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4RiGp025308;
 Wed, 13 Apr 2022 23:27:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:36 -0500
Message-Id: <1649910461-25263-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 2/7] libmultipath: make protocol_name global
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Future patches will make use of this, so move it out of
snprint_path_protocol()

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c   | 17 -----------------
 libmultipath/structs.c | 18 ++++++++++++++++++
 libmultipath/structs.h |  1 +
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index bf88f301..27c2cf1a 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -754,23 +754,6 @@ snprint_path_failures(struct strbuf *buff, const struct path * pp)
 int
 snprint_path_protocol(struct strbuf *buff, const struct path * pp)
 {
-	static const char * const protocol_name[LAST_BUS_PROTOCOL_ID + 1] = {
-		[SYSFS_BUS_UNDEF] = "undef",
-		[SYSFS_BUS_CCW] = "ccw",
-		[SYSFS_BUS_CCISS] = "cciss",
-		[SYSFS_BUS_NVME] = "nvme",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_FCP] = "scsi:fcp",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SPI] = "scsi:spi",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SSA] = "scsi:ssa",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SBP] = "scsi:sbp",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SRP] = "scsi:srp",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ISCSI] = "scsi:iscsi",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SAS] = "scsi:sas",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ADT] = "scsi:adt",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ATA] = "scsi:ata",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_USB] = "scsi:usb",
-		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC] = "scsi:unspec",
-	};
 	const char *pn = protocol_name[bus_protocol_id(pp)];
 
 	assert(pn != NULL);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 4b62da54..04cfdcdc 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -20,6 +20,24 @@
 #include "dm-generic.h"
 #include "devmapper.h"
 
+const char * const protocol_name[LAST_BUS_PROTOCOL_ID + 1] = {
+	[SYSFS_BUS_UNDEF] = "undef",
+	[SYSFS_BUS_CCW] = "ccw",
+	[SYSFS_BUS_CCISS] = "cciss",
+	[SYSFS_BUS_NVME] = "nvme",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_FCP] = "scsi:fcp",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SPI] = "scsi:spi",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SSA] = "scsi:ssa",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SBP] = "scsi:sbp",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SRP] = "scsi:srp",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ISCSI] = "scsi:iscsi",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SAS] = "scsi:sas",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ADT] = "scsi:adt",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ATA] = "scsi:ata",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_USB] = "scsi:usb",
+	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC] = "scsi:unspec",
+};
+
 struct adapter_group *
 alloc_adaptergroup(void)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d94f93a0..3722e31b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -192,6 +192,7 @@ enum scsi_protocol {
  */
 #define LAST_BUS_PROTOCOL_ID (SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC)
 unsigned int bus_protocol_id(const struct path *pp);
+extern const char * const protocol_name[];
 
 #define SCSI_INVALID_LUN ~0ULL
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

