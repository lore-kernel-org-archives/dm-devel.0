Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892E6C4332F
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:23:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-rGf5E2A3MuOl_XWisIHiYw-1; Wed, 04 May 2022 17:23:29 -0400
X-MC-Unique: rGf5E2A3MuOl_XWisIHiYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89295833966;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73F3E2026D2D;
	Wed,  4 May 2022 21:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 091DE19451F2;
	Wed,  4 May 2022 21:23:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07BC91947046
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 19:54:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE92CC28112; Wed,  4 May 2022 19:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA122C28101
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D23D0185A7B2
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:54:31 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-WB8oQN8PP0WOrsOUBc94Zw-1; Wed, 04 May 2022 15:54:30 -0400
X-MC-Unique: WB8oQN8PP0WOrsOUBc94Zw-1
Received: by mail-pj1-f45.google.com with SMTP id
 cx11-20020a17090afd8b00b001d9fe5965b3so6085204pjb.3
 for <dm-devel@redhat.com>; Wed, 04 May 2022 12:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qM82pLe5LIpNsG3poDlPVKU5bEYefBi/IlcSrVO4JAI=;
 b=NNSHYZSZtfoFv/zdMFl7CDo/xmAfkDceHEQQ9hxJ5ZxfjNGva9YeIcfkvY/YxhdH/q
 +Oouf6LNOqJNIf3p5jXZ7UfaJT/dns4VDyuVY1fvrAb8KPL5svFRWrrSOARZWc6UDAnD
 EK1Um9vl99UHBa4HBnosIueZD0OydgTtc3feFYA+g4eCYFnqp67DXhapwz/NqroE7elH
 HtNL6Z88+dIZSAICg/dRccThNqBPJHk0QXQL6i7J2IKPrR7sKCr9xR7+qswcz+gxDJTm
 RflMXkONkAvHalxcrHV3qx8qQyQENqhn9dDqmKT25D3HsaQ77Q8Nnbt1Tu/o4GURF0qX
 kuDA==
X-Gm-Message-State: AOAM5317XByXht3QNunPG7PpBD6eMyGXji3pPj4U1cU1d7V07ashCWyv
 +6aaowaCmgs/ql+HhlP/DFWSXQ==
X-Google-Smtp-Source: ABdhPJyQN0M+9153jv/w/MlWINhzXu1GoODr13+92d+vbgDekp0dhUhMFOATx1GkA2fDTz3kWcPUcw==
X-Received: by 2002:a17:903:1249:b0:15e:8b15:b7d2 with SMTP id
 u9-20020a170903124900b0015e8b15b7d2mr24555926plh.150.1651694068934; 
 Wed, 04 May 2022 12:54:28 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:35b6:c77b:be04:3bd5])
 by smtp.gmail.com with UTF8SMTPSA id
 t3-20020a17090aae0300b001d5e1b124a0sm3727332pjq.7.2022.05.04.12.54.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 12:54:28 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Wed,  4 May 2022 12:54:19 -0700
Message-Id: <20220504125404.v3.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
In-Reply-To: <20220504195419.1143099-1-mka@chromium.org>
References: <20220504195419.1143099-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 04 May 2022 21:23:25 +0000
Subject: [dm-devel] [PATCH v3 3/3] dm: verity-loadpin: Use
 CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
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
Cc: Douglas Anderson <dianders@chromium.org>,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The verity glue for LoadPin is only needed when CONFIG_SECURITY_LOADPIN_VERITY
is set, use this option for conditional compilation instead of the combo of
CONFIG_DM_VERITY and CONFIG_SECURITY_LOADPIN.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v3:
- none

Changes in v2:
- none

 drivers/md/Makefile               | 7 +------
 include/linux/dm-verity-loadpin.h | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e12cd004d375..a96441752ec7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
 obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
+obj-$(CONFIG_SECURITY_LOADPIN_VERITY)	+= dm-verity-loadpin.o
 
 ifeq ($(CONFIG_DM_INIT),y)
 dm-mod-objs			+= dm-init.o
@@ -100,12 +101,6 @@ ifeq ($(CONFIG_IMA),y)
 dm-mod-objs			+= dm-ima.o
 endif
 
-ifeq ($(CONFIG_DM_VERITY),y)
-ifeq ($(CONFIG_SECURITY_LOADPIN),y)
-dm-mod-objs			+= dm-verity-loadpin.o
-endif
-endif
-
 ifeq ($(CONFIG_DM_VERITY_FEC),y)
 dm-verity-objs			+= dm-verity-fec.o
 endif
diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
index 12a86911d05a..be63ac76f98d 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -13,7 +13,7 @@ struct trusted_root_digest {
 	struct list_head node;
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests);
 bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md);
 #else
-- 
2.36.0.464.gb9c8b46e94-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

