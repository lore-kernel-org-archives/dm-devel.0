Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A21ACD37AE
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694808262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=chT5dOtWrYo44Y4RK6oItmcJHmD+jv4iRXhYuQdpq7Y=;
	b=JPJMSdxHvhu6wQUdAPBj/54g3AfFPZkv8aVd5wrSWQ16+JgKT5cAO1vXX6UhZfke57yw7w
	PhIFfMCCtWU9a/W0Juh8glY/ZOlD36NUMTbSne706qXatQTqBtqK25ZRvCiExF48qwktmK
	WSvDa9rwPtDJaKxryVeU675b4QthSPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-Po5-G8a_PTiLRLAGgAJRpg-1; Fri, 15 Sep 2023 16:04:18 -0400
X-MC-Unique: Po5-G8a_PTiLRLAGgAJRpg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7222B81B15E;
	Fri, 15 Sep 2023 20:04:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DE352026D4B;
	Fri, 15 Sep 2023 20:04:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CD2F194658F;
	Fri, 15 Sep 2023 20:04:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2045A1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:04:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3C2D409AFC8; Fri, 15 Sep 2023 20:03:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC499409AFC3
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:03:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD63781D788
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:03:59 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-2D5HwjRaNfmyw6VXDlFLYw-1; Fri, 15 Sep 2023 16:03:55 -0400
X-MC-Unique: 2D5HwjRaNfmyw6VXDlFLYw-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1c364fb8a4cso23461615ad.1
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 13:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694808235; x=1695413035;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Yl8emKrmc/KfUuXy2E3tRAOG2iLFA4b4JMVH2AzKln0=;
 b=AR28NbtY7rbkKL9I/87aW6qhSQW/pCFIh59VcqYI/LNnFfB+vl0Nq/fr2NOokqTAGi
 h+9mdPTiMosaTFpyvvqfOaAGQOMpfOYY0MPWYHlSvlfXC0oHPubaaR+hksMct0uUt+1R
 PZoCnwf4juB+4D62GkgpymwuPr+nwn9xfpUuByziuE1JGeJ671SAvy2d4EJYhfbqayQX
 i5rh0b5yMF+8D+nNObWo9GVT3V69PwUzhpNzvCKESprsJUoMhVmOo5i+yc4bjJ+PxpUX
 pvEbQdfhhndBM/MKrh424IN3+VtREMXSUeKomTTlVCwK7ukiAkhi80SvBRWy1Y1zZfJZ
 qw8w==
X-Gm-Message-State: AOJu0YzWauUhynpuyBOvY/m8zlGc8KWXPGglkbvupmSohVBXlFctXkDA
 l2m5Yypll97RMKpiMSf/i63uLw==
X-Google-Smtp-Source: AGHT+IF2oW6I05JFC4LbqC0C/xSZFuoVK2mMBPB/lgVhfx8bqpQ8L6rQW3zyLUX7mUdezD2I/Z5UzA==
X-Received: by 2002:a17:903:24e:b0:1bc:6799:3f6c with SMTP id
 j14-20020a170903024e00b001bc67993f6cmr2435450plh.35.1694808234867; 
 Fri, 15 Sep 2023 13:03:54 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 jc19-20020a17090325d300b001c4247300adsm2521123plb.276.2023.09.15.13.03.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:03:54 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri, 15 Sep 2023 13:03:53 -0700
Message-Id: <20230915200352.never.118-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1103; i=keescook@chromium.org; 
 h=from:subject:message-id;
 bh=vOEysGbU/jyBebBE5nHunAiTa99HsxKjPw7GE7dUesk=; 
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlBLip2KpsBUO/hCQjlCTSWf2rc87i8jMHzNeSE
 Q8UaPFCOvWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZQS4qQAKCRCJcvTf3G3A
 JpnJD/44Xz/i8BNUv0MMMNLHpqKkkGXhsnX3/oK7sG9t5GcOmsd2TGoGmk+Mi0lfFizMo1Wu4rd
 D1aP5qTGM3Ufj8/4nIvQUnuJ3fTsDiuJGvyZidtO2mhY4z0sDqDFwq0iWQQEec4kD+wxSGPnSd3
 s+RmtXzI2BuE5DXDc1Y9jCZbMi9sQqJJq3Dp+l+vOGr+ovc/TSK4hL5tLKy3x4pyR+OL9xZbp5S
 OcnrtzlmHhv/+gzQh1TdQXFXKiZP0JpGye/uLGzm/JLBBh4O6BUf1WqE+JuZJXdyxm9IzsWyi6m
 VpTxDakDYjz3OY5vNgdASvDfGeA4tlf0faus+ogRlMXiyFWCpYxfiPCgLjLKd8j/qDY6fNFrfn2
 fMopN7jzzjuDuQKwLvwo0WreafHn/87Npf0vrNSgxxVSIDcn1xagASs2Dc+tzhrhaovAV0vg/b2
 /1k2Oi2JiXX6i+wNfGmUIBmUJC+5EggoLK9bSp8Krg5X9TWkzK5BWxIsEIFy4fChFtGDfPx/zrl
 6RE1NFzGHIuHI/9gkAs+Pd7SzewGh/0sFbi7aEB4mh9lO+nc4NikCrdZsu9L1BNxFCjwPsGL/D0
 CMh9MqgB/q+43pEGchjFoK3DQp3hz1cSDRUDWidEdAIjizb1sw6N5ohw8hOyYZ7YWMl6Jk/Zdfv
 1L0V1+E HhwIYZFg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
 fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH] dm: Annotate struct stripe_c with __counted_by
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
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
 dm-devel@redhat.com, linux-hardening@vger.kernel.org,
 Tom Rix <trix@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct stripe_c.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-stripe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e2854a3cbd28..5e70f5ae394d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -44,7 +44,7 @@ struct stripe_c {
 	/* Work struct used for triggering events*/
 	struct work_struct trigger_event;
 
-	struct stripe stripe[];
+	struct stripe stripe[] __counted_by(stripes);
 };
 
 /*
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

