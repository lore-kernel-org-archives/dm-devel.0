Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA51FC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657118349;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tF2bxp8RiCn291hXlflTDgEX5KBOj2dT1JU1OJX/V3c=;
	b=Poy8N/OVkeq9SGLEY39splWrTrH2cz1OSPL6JGhSH8ogHXM8XL0aB66BI8AgBukt/kULqL
	wTEQTKzu15L0Xroraa167U8LZUq+ff7EwKq2AZA9sso+mR15NnLunaqCFATWPEDevmp/yI
	zkNoeMkLjKHm14yG4S4yvcqv++Zzy3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-gOQ-xlzbOd6cO4BmfIa57g-1; Wed, 06 Jul 2022 10:38:57 -0400
X-MC-Unique: gOQ-xlzbOd6cO4BmfIa57g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8F2218E0059;
	Wed,  6 Jul 2022 14:38:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6AAA1415117;
	Wed,  6 Jul 2022 14:38:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1BDB1947063;
	Wed,  6 Jul 2022 14:38:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 639BF194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4532C2024CB6; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 412432026D64
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B11810113D8
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 14:38:53 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-VCe7AcGJM8ekY8Dy-cDrtQ-1; Wed, 06 Jul 2022 10:38:45 -0400
X-MC-Unique: VCe7AcGJM8ekY8Dy-cDrtQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 0EF941FF31;
 Wed,  6 Jul 2022 14:38:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D72EE134CF;
 Wed,  6 Jul 2022 14:38:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id MLT8Mm2exWKbSgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 06 Jul 2022 14:38:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  6 Jul 2022 16:38:10 +0200
Message-Id: <20220706143822.30182-3-mwilck@suse.com>
In-Reply-To: <20220706143822.30182-1-mwilck@suse.com>
References: <20220706143822.30182-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 02/14] libmultipath: remove sysfs_get_binary()
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This function adds no value on top of sysfs_bin_attr_get_value().
Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 26 ++------------------------
 tests/test-lib.c         |  1 -
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0d8a558..7e09e4e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -263,41 +263,19 @@ declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
 
-static ssize_t
-sysfs_get_binary (struct udev_device * udev, const char *attrname,
-		  unsigned char *buff, size_t len)
-{
-	ssize_t attr_len;
-	const char * devname;
-
-	if (!udev) {
-		condlog(3, "No udev device given\n");
-		return -ENOSYS;
-	}
-
-	devname = udev_device_get_sysname(udev);
-	attr_len = sysfs_bin_attr_get_value(udev, attrname, buff, len);
-	if (attr_len < 0) {
-		condlog(3, "%s: attribute %s not found in sysfs",
-			devname, attrname);
-		return attr_len;
-	}
-	return attr_len;
-}
-
 ssize_t sysfs_get_vpd(struct udev_device * udev, unsigned char pg,
 		      unsigned char *buff, size_t len)
 {
 	char attrname[9];
 
 	snprintf(attrname, sizeof(attrname), "vpd_pg%02x", pg);
-	return sysfs_get_binary(udev, attrname, buff, len);
+	return sysfs_bin_attr_get_value(udev, attrname, buff, len);
 }
 
 ssize_t sysfs_get_inquiry(struct udev_device * udev,
 			  unsigned char *buff, size_t len)
 {
-	return sysfs_get_binary(udev, "inquiry", buff, len);
+	return sysfs_bin_attr_get_value(udev, "inquiry", buff, len);
 }
 
 int
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 6dd3ee8..0bc49d5 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -334,7 +334,6 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	if (mask & DI_SERIAL) {
 		will_return(__wrap_udev_device_get_subsystem, "scsi");
 		will_return(__wrap_udev_device_get_sysname, hbtl);
-		will_return(__wrap_udev_device_get_sysname, hbtl);
 	}
 
 	if (mask & DI_WWID) {
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

