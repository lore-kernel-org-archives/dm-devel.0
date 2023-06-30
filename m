Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA2DEB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jun 2023 18:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688150308;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5IeNm6K2uPNVIUdfU9NpzIykQRMaA5L9GGnkMIg99oA=;
	b=XeIt9fcgYEuevciVU8UHHaVcWaLQgo0LwX5qsDBSUYijEXFGh8iAsHLKnOOaSxw0GBsKKE
	FDYjSMnqB2ufEuCK+DAabE6X4deBSm4YEgQJENGZiqPeEla/PPrvUCWwjbT1T3V5KZRAMv
	iBLkwRxuMjAV3kDj7JG3OAK/zZSpeb4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-nJ2mb1A-PMCn7OEnj8JmCA-1; Fri, 30 Jun 2023 14:38:25 -0400
X-MC-Unique: nJ2mb1A-PMCn7OEnj8JmCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16327800159;
	Fri, 30 Jun 2023 18:38:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B3C7200C0CD;
	Fri, 30 Jun 2023 18:38:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EECED19465B6;
	Fri, 30 Jun 2023 18:38:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A046A19465B3
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Jun 2023 18:14:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 493D2200B677; Fri, 30 Jun 2023 18:14:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4208D200A3AD
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 18:14:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 253172A5957B
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 18:14:16 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-hxXHIozZOHaqVfqFUeJKAg-1; Fri,
 30 Jun 2023 14:14:13 -0400
X-MC-Unique: hxXHIozZOHaqVfqFUeJKAg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2FE3C21845;
 Fri, 30 Jun 2023 18:14:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2B6B138F8;
 Fri, 30 Jun 2023 18:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id jJ52OXMbn2ReZAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 30 Jun 2023 18:14:11 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 30 Jun 2023 20:14:07 +0200
Message-ID: <20230630181407.14302-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] libmultipath: ignore nvme devices if nvme native
 multipath is enabled
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If the nvme native multipath driver is enabled, blacklist nvme devices
for dm-multipath by default. This is particularly useful with
"find_multipaths greedy".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 35 ++++++++++++++++++++++++++++++++---
 tests/blacklist.c        | 30 ++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 8d15d2e..75100b2 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -2,6 +2,8 @@
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
 #include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
 #include <libudev.h>
 
 #include "checkers.h"
@@ -191,6 +193,27 @@ find_blacklist_device (const struct _vector *blist, const char *vendor,
 	return 0;
 }
 
+/*
+ * Test if nvme native multipath is enabled. If the sysfs file can't
+ * be accessed, multipath is either disabled at compile time, or no
+ * nvme driver is loaded at all. Thus treat errors as "no".
+ */
+static bool nvme_multipath_enabled(void)
+{
+	static const char fn[] = "/sys/module/nvme_core/parameters/multipath";
+	int fd, len;
+	char buf[2];
+
+	fd = open(fn, O_RDONLY);
+	if (fd == -1)
+		return false;
+
+	len = read(fd, buf, sizeof(buf));
+	close(fd);
+
+	return (len >= 1 && buf[0] == 'Y');
+}
+
 int
 setup_default_blist (struct config * conf)
 {
@@ -198,9 +221,15 @@ setup_default_blist (struct config * conf)
 	struct hwentry *hwe;
 	int i;
 
-	if (store_ble(conf->blist_devnode, "!^(sd[a-z]|dasd[a-z]|nvme[0-9])", ORIGIN_DEFAULT))
-		return 1;
-
+	if (nvme_multipath_enabled()) {
+		if (store_ble(conf->blist_devnode, "!^(sd[a-z]|dasd[a-z])",
+			      ORIGIN_DEFAULT))
+			return 1;
+	} else {
+		if (store_ble(conf->blist_devnode, "!^(sd[a-z]|dasd[a-z]|nvme[0-9])",
+			      ORIGIN_DEFAULT))
+			return 1;
+	}
 	if (store_ble(conf->elist_property, "(SCSI_IDENT_|ID_WWN)", ORIGIN_DEFAULT))
 		return 1;
 
diff --git a/tests/blacklist.c b/tests/blacklist.c
index 882aa3a..65002eb 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -17,6 +17,8 @@
  */
 #include <stdarg.h>
 #include <stddef.h>
+#include <unistd.h>
+#include <fcntl.h>
 #include <setjmp.h>
 #include <cmocka.h>
 #include "globals.c"
@@ -220,12 +222,36 @@ static void test_devnode_missing(void **state)
 			 MATCH_NOTHING);
 }
 
+/* copy of the same function in libmultipath/blacklist.c */
+static bool nvme_multipath_enabled(void)
+{
+	static const char fn[] = "/sys/module/nvme_core/parameters/multipath";
+	int fd, len;
+	char buf[2];
+
+	fd = open(fn, O_RDONLY);
+	if (fd == -1)
+		return false;
+
+	len = read(fd, buf, sizeof(buf));
+	close(fd);
+
+	return (len >= 1 && buf[0] == 'Y');
+}
+
 static void test_devnode_default(void **state)
 {
 	assert_int_equal(filter_devnode(blist_devnode_default, NULL, "sdaa"),
 			 MATCH_NOTHING);
-	assert_int_equal(filter_devnode(blist_devnode_default, NULL, "nvme0n1"),
-			 MATCH_NOTHING);
+	if (nvme_multipath_enabled()) {
+		expect_condlog(3, "nvme0n1: device node name blacklisted\n");
+		assert_int_equal(filter_devnode(blist_devnode_default, NULL,
+						"nvme0n1"),
+				 MATCH_DEVNODE_BLIST);
+	} else
+		assert_int_equal(filter_devnode(blist_devnode_default, NULL,
+						"nvme0n1"),
+				 MATCH_NOTHING);
 	assert_int_equal(filter_devnode(blist_devnode_default, NULL, "dasda"),
 			 MATCH_NOTHING);
 	expect_condlog(3, "hda: device node name blacklisted\n");
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

