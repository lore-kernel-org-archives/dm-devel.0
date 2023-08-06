Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B469EB64DD
	for <dm-devel@archiver.kernel.org>; Mon,  7 Aug 2023 06:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691389790;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=99q4nuOD/5Rz4yVmBxWopoqDJ3joo+p6Rx7YzTloMbc=;
	b=NUi8aedG60wmTRYM4RSAsVqQhvSdGguiNzJx5eanbtI4ltRsHzmx3kjQzkcAGrhT8dGDHE
	PR8hEYX/yPFMw1sgenUDl8Zn13ey0kpYNS1w09coA8Lr3lgJHsmuHKaF2neWF1aXY/bGiP
	Ihc1cOfcWjW3QW4p1saefBsaMdwdVbc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-D6nyQnxSO0mERIj3kUACuw-1; Mon, 07 Aug 2023 02:29:47 -0400
X-MC-Unique: D6nyQnxSO0mERIj3kUACuw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9908B1C0724A;
	Mon,  7 Aug 2023 06:29:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A1164094DC0;
	Mon,  7 Aug 2023 06:29:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DA4F1946588;
	Mon,  7 Aug 2023 06:29:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E965F1946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  6 Aug 2023 10:21:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86070400F48; Sun,  6 Aug 2023 10:21:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E296477F63
 for <dm-devel@redhat.com>; Sun,  6 Aug 2023 10:21:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 870671C05143
 for <dm-devel@redhat.com>; Sun,  6 Aug 2023 10:21:36 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-CsTxTMPWP3usKfJeqqCIQg-1; Sun, 06 Aug 2023 06:21:34 -0400
X-MC-Unique: CsTxTMPWP3usKfJeqqCIQg-1
Received: by mail-wm1-f46.google.com with SMTP id
 5b1f17b1804b1-3fbd33a57b6so35203695e9.2
 for <dm-devel@redhat.com>; Sun, 06 Aug 2023 03:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691317293; x=1691922093;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=dVa0E3Lj0rdFfze1L/AYpOGZbcsSY27UHUkg8cU856Q=;
 b=Gwkc6JJo/QeF7+8LWyQZd0HCPvG64Sp8JcjLFuz3AHdeftDFqaqsNZWG2WuVk1O3uM
 CCe16WgvEx44/D6UBrMOFTq5nBKi/OOs+uT2jwOz5Pi0s1sd8sayac2Xx02HIvv2MPHu
 NPBOjo5JYm5qIvb5AbCIHJEzkUPqkf6S8PmkSFxiO5cKvCpcQrvSRfSXFAADt9PkN3jZ
 Q3CtNWEOErLtPTG05aa4IVNzlTfIq+PI9U8SGeHaF3b4X/rqAfI23ru0+8Y3HkPyKX+J
 i5O3LTJv76DECnmjU0A6hwNPLDXuYnulNPTZqZO2RKcDXlREmUW30vWSjFM8N87LQIKw
 nloA==
X-Gm-Message-State: AOJu0YzYQdwdBbmOs7F9N0U5YS3GggB+YJaMbkst4lqDEYUybfyUW+gM
 Nlr/qbyr9n/e301yjaCxKual/ixWKK9SkZOx01E=
X-Google-Smtp-Source: AGHT+IFsNedXrotBxfEmHnbKrcb8UioEYvlSbkEjecbtgGs+bDt8WaxpF2oBokLX2lSenJtG8nY1Bg==
X-Received: by 2002:a05:600c:2249:b0:3fb:a100:2581 with SMTP id
 a9-20020a05600c224900b003fba1002581mr5108113wmm.14.1691317293057; 
 Sun, 06 Aug 2023 03:21:33 -0700 (PDT)
Received: from loic-ThinkPad-T470p.. ([2a01:e0a:82c:5f0:2a5f:dd16:fb77:b314])
 by smtp.gmail.com with ESMTPSA id
 z10-20020a05600c220a00b003fba6a0c881sm11698279wml.43.2023.08.06.03.21.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 06 Aug 2023 03:21:32 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Sun,  6 Aug 2023 12:21:30 +0200
Message-Id: <20230806102130.164565-1-loic.poulain@linaro.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 07 Aug 2023 06:29:27 +0000
Subject: [dm-devel] [PATCH] dm-verity: Add support for fdt root-hash
 signature
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
Cc: dm-devel@redhat.com, Loic Poulain <loic.poulain@linaro.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow root_hash_sig_key_desc to be in the form of a fdt-path:fdt-prop
string so that the root hash signature is extracted from the devicetree
instead of the Linux keyring.

This allows passing a root hash signature for a mapping without the need
for a userspace signature loader (no ramdisk).

Example:
dm-mod.create="vroot,,0,ro,0 1372664 verity ... 2 root_hash_sig_key_desc /verity:vroot-hash-sig"

Will read signature from the vroot-hash-sig prop of verity node:
/ {
    verity {
        vroot-hash-sig = [ 00 3f 45 42 ... ];
    };
};

Typically, the root hash signature can be injected in fdt by the
bootloader.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/md/dm-verity-verify-sig.c | 53 ++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index 4836508ea50c..ad42e8527dd8 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -9,6 +9,7 @@
 #include <linux/verification.h>
 #include <keys/user-type.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include "dm-verity.h"
 #include "dm-verity-verify-sig.h"
 
@@ -64,6 +65,52 @@ static int verity_verify_get_sig_from_key(const char *key_desc,
 	return ret;
 }
 
+static int verity_verify_get_sig_from_fdt(const char *key_desc,
+					  struct dm_verity_sig_opts *sig_opts)
+{
+	struct device_node *node;
+	char *path, *name, *str;
+	struct property *prop;
+	int ret = 0;
+
+	str = kstrdup(key_desc, GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	path = strsep(&str, ":");
+	name = str;
+
+	if (!path || !name) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	node = of_find_node_by_path(path);
+	if (!node) {
+		ret = -ENOENT;
+		goto end;
+	}
+
+	prop = of_find_property(node, name, NULL);
+	if (!prop) {
+		ret = -ENOENT;
+		goto end;
+	}
+
+	sig_opts->sig = kmalloc(prop->length, GFP_KERNEL);
+	if (!sig_opts->sig) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	memcpy(sig_opts->sig, prop->value, prop->length);
+	sig_opts->sig_size = prop->length;
+
+end:
+	kfree(str);
+	return ret;
+}
+
 int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
 				     struct dm_verity *v,
 				     struct dm_verity_sig_opts *sig_opts,
@@ -82,7 +129,11 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
 	sig_key = dm_shift_arg(as);
 	(*argc)--;
 
-	ret = verity_verify_get_sig_from_key(sig_key, sig_opts);
+	if (sig_key[0] == '/') /* this is a fdt path */
+		ret = verity_verify_get_sig_from_fdt(sig_key, sig_opts);
+	else
+		ret = verity_verify_get_sig_from_key(sig_key, sig_opts);
+
 	if (ret < 0)
 		ti->error = DM_VERITY_VERIFY_ERR("Invalid key specified");
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

