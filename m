Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1CBC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845702;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XRFYNW+EJqnvJsPzutlxoaf9V0GxsQIC1jVFM0wJElE=;
	b=B2DuJeWzfhyFe4zUoi4TtpC2t09f0j57H0NP2jrxLXygYAEkaz4O68Kr1ruPb4MwTKp/sy
	5ctxdWyabu0hjv1L1zw40E2ttPaIIf3NHBjqjZcH45JNOgJnJHuzdk5fGUvM+c2ytp6Ifb
	SmXARuI+QrrK9DgzbILK4KOoHPMyZkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-OL40jjRHN62-_qTcfTxX4A-1; Mon, 21 Mar 2022 02:55:00 -0400
X-MC-Unique: OL40jjRHN62-_qTcfTxX4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C4C3833974;
	Mon, 21 Mar 2022 06:54:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5876F4010A03;
	Mon, 21 Mar 2022 06:54:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D296E19451F3;
	Mon, 21 Mar 2022 06:54:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05DA91949761
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 10:34:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC16956D1E0; Fri, 18 Mar 2022 10:34:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C800A56D17C
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B101D3C14CCD
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 10:34:45 +0000 (UTC)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-juy8CuqcP1OpnixI0f1ADQ-1; Fri, 18 Mar 2022 06:34:44 -0400
X-MC-Unique: juy8CuqcP1OpnixI0f1ADQ-1
Received: by mail-pj1-f70.google.com with SMTP id
 q21-20020a17090a2e1500b001c44f70fd38so4812679pjd.6
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 03:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=e6SFRMKes32y2Epjb9bRfBHy+sHjP48gM2WVhKsacmY=;
 b=TCdovSmuBDCfpBgyO9wmqscO48AEGryi3B6AwvQDQ19v69KBNfWho8GRQhBuCLZ3Mv
 zkewj6QlBL67Prs6dtvHLtmBT/fLMOUnhkim725Wow9t6VcKQ3xYzq9jy0UmYkpS/8Wz
 X6T0RHEnQHkrkAVO+lHwtyMtNil3dSQyz+QDdDtf6Pzz3xp8VR4Lkn2Jiy2/+tsRh7Ve
 XWfwkU1GudO05gPpwZi77hDtCP8LivaTggXEhjIuTmv2j+w7H8jFQ7M6YsopLXo05UVK
 Okm+DneH3W9+uZh4GXS59pOIGLY4FTR40EIkOsCW8JTKes91qSaoxwI4ENdn5EpqMr34
 VtoQ==
X-Gm-Message-State: AOAM530zNjkj7W3oTN27Hrii/drUj5YZejOtoYXkAoEnbbf4+FXfLRK+
 w2LXKNAFHnoVo5x6bABaTFhPeMtCfA1HU2rZARIUhiVtVtQXl1paYsKE+k92g6eOxTKi7fRThPw
 nB608qmKWZKHQY0w=
X-Received: by 2002:a17:902:a5c7:b0:14f:e424:3579 with SMTP id
 t7-20020a170902a5c700b0014fe4243579mr9761877plq.74.1647599683226; 
 Fri, 18 Mar 2022 03:34:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwydLGW4oyMokHqUNqgiEVlQJ73WsUZSlWeUuNnFSrLoT8M8+9OxbPejRrRKRSgMpl8ZFsEyw==
X-Received: by 2002:a17:902:a5c7:b0:14f:e424:3579 with SMTP id
 t7-20020a170902a5c700b0014fe4243579mr9761859plq.74.1647599682974; 
 Fri, 18 Mar 2022 03:34:42 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 o24-20020a17090a5b1800b001c6aaafa5fbsm1575423pji.24.2022.03.18.03.34.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 03:34:42 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri, 18 Mar 2022 18:34:23 +0800
Message-Id: <20220318103423.286410-5-coxu@redhat.com>
In-Reply-To: <20220318103423.286410-1-coxu@redhat.com>
References: <20220318103423.286410-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
Subject: [dm-devel] [RFC 4/4] dm-crypt: reuse LUKS master key in kdump kernel
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
Cc: Mike Snitzer <snitzer@redhat.com>, Baoquan He <bhe@redhat.com>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When libcryptsetup passes key string starting with ":kdump", dm-crypt
will interpret it as reusing the LUKS master key in kdump kernel.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/md/dm-crypt.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 41f9ca377312..f3986036ec40 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -42,6 +42,7 @@
 
 #include <linux/device-mapper.h>
 #include <linux/kexec.h>
+#include <linux/crash_dump.h>
 
 #include "dm-audit.h"
 
@@ -2602,13 +2603,17 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 {
 	int r = -EINVAL;
 	int key_string_len = strlen(key);
+	bool retrieve_kdump_key = false;
+
+	if (is_kdump_kernel() && !strncmp(key, ":kdump", 5))
+		retrieve_kdump_key = true;
 
 	/* Hyphen (which gives a key_size of zero) means there is no key. */
-	if (!cc->key_size && strcmp(key, "-"))
+	if (!retrieve_kdump_key && !cc->key_size && strcmp(key, "-"))
 		goto out;
 
 	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
-	if (key[0] == ':') {
+	if (!retrieve_kdump_key && key[0] == ':') {
 		r = crypt_set_keyring_key(cc, key + 1);
 		goto out;
 	}
@@ -2620,9 +2625,15 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
 
-	/* Decode key from its hex representation. */
-	if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
-		goto out;
+	if (retrieve_kdump_key) {
+		r = retrive_kdump_luks_master_key(cc->key, &cc->key_size);
+		if (r < 0)
+			goto out;
+	} else {
+		/* Decode key from its hex representation. */
+		if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
+			goto out;
+	}
 
 	r = crypt_setkey(cc);
 	if (!r)
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

