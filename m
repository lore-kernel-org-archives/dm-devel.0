Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC32C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 21:14:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-ZbJL4fBvNTSkVCidgwSv4g-1; Mon, 23 May 2022 17:14:14 -0400
X-MC-Unique: ZbJL4fBvNTSkVCidgwSv4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6BDA3831C47;
	Mon, 23 May 2022 21:14:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B31BE112131B;
	Mon, 23 May 2022 21:14:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FEC21947B84;
	Mon, 23 May 2022 21:14:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B3311947B83
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 21:14:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 195942166B2F; Mon, 23 May 2022 21:14:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14A222166B25
 for <dm-devel@redhat.com>; Mon, 23 May 2022 21:14:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED5A33C19024
 for <dm-devel@redhat.com>; Mon, 23 May 2022 21:14:10 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-WBLEqZyVM6yuQYaq4wdHig-1; Mon, 23 May 2022 17:14:09 -0400
X-MC-Unique: WBLEqZyVM6yuQYaq4wdHig-1
Received: by mail-pg1-f180.google.com with SMTP id r71so14743020pgr.0
 for <dm-devel@redhat.com>; Mon, 23 May 2022 14:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=7sQ9oR+xbg8R35wvoreY201E08AeVxeiXWdeAF7cXRM=;
 b=yDJ6+M3RKnSLozeXIoi1wXEyNddIW2Na6VEaZPYhQrHh6wKBOxWoXHDdTcfifj5o0Y
 Yegr1D3EQgVj2FBLTn77l3t+TThFdVaOOUEcxNjIZ7fHvnnJJBTxNN9H5oGQoSn4O9E5
 eGFYXeGy1aaEmYvXUFzSwZLFl8qMK/4brQ9CV2qBqZQ+tbpMN6TgeWeet/w/yf5OAFZk
 bFrrIdd9QhwNgj45tjVcJQOOEPPZursuuYziAzO21KP7i6hv+aroHHolj/L5S3QnKeR+
 M/pzc2xF9gUD5KZsWsUGCBPK1WBMWdX+rcZIAjLGubWATunpp173KWLxQsL5Eo3pguhH
 LpJw==
X-Gm-Message-State: AOAM532QZD+9v62VqBZz8xLnI5h2Ue1EI1TZgSuQOUjkaunWGhrMd1t5
 NZLzCIUz5/bfg6WJUSdJosMtGA==
X-Google-Smtp-Source: ABdhPJwjJqrTLcWA+nZYZEnU+6VaXKXbwTOJORpnOZ2WXLEU4bYD4BuxvIye0UbjX4g50uxPfvLoDg==
X-Received: by 2002:a63:82c7:0:b0:3f9:e153:6a54 with SMTP id
 w190-20020a6382c7000000b003f9e1536a54mr12840592pgd.409.1653340448097; 
 Mon, 23 May 2022 14:14:08 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:d9e2:8472:9ac:8532])
 by smtp.gmail.com with UTF8SMTPSA id
 s17-20020a170903215100b0015e8d4eb1b7sm5571230ple.1.2022.05.23.14.14.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 23 May 2022 14:14:07 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 23 May 2022 14:14:00 -0700
Message-Id: <20220523141325.v6.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
In-Reply-To: <20220523211400.290537-1-mka@chromium.org>
References: <20220523211400.290537-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v6 3/3] dm: verity-loadpin: Use
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Acked-by: Kees Cook <keescook@chromium.org>
---

Changes in v6:
- none

Changes in v5:
- added 'Acked-by' tag from Kees

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
index fb695ecaa5d5..552b817ab102 100644
--- a/include/linux/dm-verity-loadpin.h
+++ b/include/linux/dm-verity-loadpin.h
@@ -15,7 +15,7 @@ struct dm_verity_loadpin_trusted_root_digest {
 	u8 data[];
 };
 
-#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)
 bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev);
 #else
 static inline bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
-- 
2.36.1.124.g0e6072fb45-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

