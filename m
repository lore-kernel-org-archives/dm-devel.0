Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 992E9C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 23:35:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-09srClMhP3O_xdKAmdJtPg-1; Tue, 17 May 2022 19:35:13 -0400
X-MC-Unique: 09srClMhP3O_xdKAmdJtPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45A7380B712;
	Tue, 17 May 2022 23:35:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3441B1410DD5;
	Tue, 17 May 2022 23:35:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F23EA19259CF;
	Tue, 17 May 2022 23:35:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 414651949759
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 23:35:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 313CE40CF8F6; Tue, 17 May 2022 23:35:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D21040CF8F5
 for <dm-devel@redhat.com>; Tue, 17 May 2022 23:35:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 149723C02B6C
 for <dm-devel@redhat.com>; Tue, 17 May 2022 23:35:08 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-PDaI5omCOt2p3CZJlyeGGQ-1; Tue, 17 May 2022 19:35:06 -0400
X-MC-Unique: PDaI5omCOt2p3CZJlyeGGQ-1
Received: by mail-pg1-f169.google.com with SMTP id c22so608448pgu.2
 for <dm-devel@redhat.com>; Tue, 17 May 2022 16:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=dDud8QpcHOOGMYFVwG6KRCTw7kIHDGrPd+sI68v2xZg=;
 b=IaQjcqMMp4lVqrOjyPYj/Sgj4QP7B63TZTHtlniM4ZBKjSzBChpYJbFtFPLCMNC+i+
 c8J6qIj14ac2O47RDdFrJn91FqSQW5Gucpvpj5oAM2g55IuleZgg/N1GlFjyL52XVkfY
 Gd77K9rmU16+Ymlvfr9R5rDV2Aa41ZmxDyY/tiUl48hBGP3q5U6RHd3ln2ps1recJv2l
 0czUE0G1S5a9iYaPpNpjGmqtTLdPTQQ0Lf57vgVVA49geulJ8dcyX4UB8bhysB2Ka8wk
 WfiA4iiJ0QIcS1GpAfFEuJy5NIZzXhmb/uyGXrTyLA1pQyyFr4boo5ZK2DKsGGZXaLzS
 ZHWg==
X-Gm-Message-State: AOAM530hFVUsHt8x7BpX9srsqiGG3di1wDtuTi0PRYBf5EX0DUYtL8uK
 Bptw44vl4LssEgOx0T/84otjgA==
X-Google-Smtp-Source: ABdhPJyZj+2Vn+6W69AKPRTh2wk4PKvqzqVqTA63hYJRVSIAYcQ/O1m9fMYTQtqsbh7pki5RFa2oow==
X-Received: by 2002:a05:6a00:298a:b0:50e:8e3:b673 with SMTP id
 cj10-20020a056a00298a00b0050e08e3b673mr24631943pfb.28.1652830505085; 
 Tue, 17 May 2022 16:35:05 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
 by smtp.gmail.com with UTF8SMTPSA id
 l17-20020a170903245100b001617e18e253sm162705pls.143.2022.05.17.16.35.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 17 May 2022 16:35:04 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Tue, 17 May 2022 16:34:57 -0700
Message-Id: <20220517163437.v4.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
In-Reply-To: <20220517233457.1123309-1-mka@chromium.org>
References: <20220517233457.1123309-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v4 3/3] dm: verity-loadpin: Use
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
Cc: dm-devel@redhat.com, Douglas Anderson <dianders@chromium.org>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Matthias Kaehlcke <mka@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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

Changes in v4:
- none

Changes in v3:
- none

Changes in v2:
- none

 drivers/md/Makefile               | 7 +------
 include/linux/dm-verity-loadpin.h | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 71771901c823..a96441752ec7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
 obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
+obj-$(CONFIG_SECURITY_LOADPIN_VERITY)	+= dm-verity-loadpin.o
 
 ifeq ($(CONFIG_DM_INIT),y)
 dm-mod-objs			+= dm-init.o
@@ -108,12 +109,6 @@ ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
 dm-verity-objs			+= dm-verity-verify-sig.o
 endif
 
-ifeq ($(CONFIG_DM_VERITY),y)
-ifeq ($(CONFIG_SECURITY_LOADPIN),y)
-dm-verity-objs			+= dm-verity-loadpin.o
-endif
-endif
-
 ifeq ($(CONFIG_DM_AUDIT),y)
 dm-mod-objs			+= dm-audit.o
 endif
diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
index c2bfd2b9c651..dd66ece9a751 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -15,7 +15,7 @@ struct trusted_root_digest {
 	u8 data[];
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
 #else
 static inline bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
-- 
2.36.0.550.gb090851708-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

