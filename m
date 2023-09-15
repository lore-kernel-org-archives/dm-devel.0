Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A08CD379F
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694808244;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rdDc7RzwDt1mM76D+ew8+mMX/drvHZYF5P7gVTKxvIo=;
	b=ZHb9UHOfpbFqz54tyDGkX+MUk272hplTq8xyj1J/CCwJ9b8sh2dEzwCS+RkWDRGOwYy9+b
	+FiQC4g3pvwuoQrssBsDVWwrTgUglyFOanneKcvm+lSSqHEYwiWPH8urYArOj2tpsMLxJW
	pI9G6/9aNeNTZ+ptQZojxGyAI+wZE08=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-JIvn2Y4rOPWL77xfD-hyNg-1; Fri, 15 Sep 2023 16:04:02 -0400
X-MC-Unique: JIvn2Y4rOPWL77xfD-hyNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E4F981707A;
	Fri, 15 Sep 2023 20:04:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F5CD21B2413;
	Fri, 15 Sep 2023 20:03:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 47931194658F;
	Fri, 15 Sep 2023 20:03:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C4241946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:03:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 04EB821CAC6B; Fri, 15 Sep 2023 20:03:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F292A21CAC76
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:03:52 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D36CF810BDB
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:03:52 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-Nvn4xExuODq1mnv4TTaBEA-1; Fri, 15 Sep 2023 16:03:48 -0400
X-MC-Unique: Nvn4xExuODq1mnv4TTaBEA-1
Received: by mail-pl1-f182.google.com with SMTP id
 d9443c01a7336-1c4194f7635so14194205ad.0
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 13:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694808227; x=1695413027;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=585ELGKH6mcU0nuyAJeZCpFUeKhNPgDgSqqVI53K3fs=;
 b=kZRpO18OZ3x0z6bDZVsvGyE0Xx+ZxmQ4HrPbtdMvDnrx9qE8lOSQw2VRfL/PxnvtJ5
 mR8OqN7UteMC7SX75sV9Ot6xuqFcK6Dmjdp/2HMwacg9hWFoHsnRBuAv3qa5UIdOp6lL
 M3tXQzEBw/QIhV31vmaPdXiMkh6nIMfzFVizMRhLv6ksJhkKEK+ojkJDYO8IQy9Ag8hf
 TveVdnHugORTZWi8xJU8WHQUytijkh21QeQdiFH7dIjLSwblK29KrsUgBLrdZIZ9gJlU
 ry4B6CMeytubxuusPktGN+VMlVXGnQMr4gvhp3pTAh0nGrlj8IaL2C1yJMLm/FEUCmEM
 Sr1g==
X-Gm-Message-State: AOJu0YzYoSeeki7pF2PDmYNnBWcDBgAiasWs4GxhqaqmbqZHMVfBFOAK
 4nP2EeuHr0Ys8Pv1NioIFKY3+w==
X-Google-Smtp-Source: AGHT+IGxirG4c1+wNpjD+C0ivacitJE7me+i97dg7mLg1+2Am2AXQTOZsLaZMKFyejKoHm2lSiLWUg==
X-Received: by 2002:a17:903:2311:b0:1c3:81b7:2385 with SMTP id
 d17-20020a170903231100b001c381b72385mr4018353plh.11.1694808227690; 
 Fri, 15 Sep 2023 13:03:47 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 je20-20020a170903265400b001bf044dc1a6sm3488624plb.39.2023.09.15.13.03.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:03:47 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri, 15 Sep 2023 13:03:45 -0700
Message-Id: <20230915200344.never.272-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1117; i=keescook@chromium.org; 
 h=from:subject:message-id;
 bh=2J6fBiPdZIR8mGnEk0bNvAHhXLvKbIZhyM289hn91M0=; 
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlBLihfwsK6T3HOV1j4wnd25zaVLF5WQpYGwyS+
 5kE88zkP0eJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZQS4oQAKCRCJcvTf3G3A
 JtSpD/9zzSwBgu0DciTVR5Kuff9eIrmBXAQb1lB9CqCovFopZkSEQY5tNgaZ78xwjchx+SUL0+w
 U596UPQfpyHBDuBCDdrWmn59UUrEv7daZ8bnNYszDjqEEloDL9evqkm1heUI+1NZHp3hBGJMY1I
 EPN/1/SnJZemS9I2Ehsn50giqtGvagxkRx4RTYc43lLCi8lyzkQpyy4aWuunQZ9b/jooQ29YCRu
 0qTTTLUZM2YFI0C6XmnedeWXMaxGCHs/UC/+f2Pa/lnMg3D8cahgzy1Meee+78H4cJCjFKRM8e8
 WfB0QQeYwFx3HGHCcMgtArJ8KYAFzMHtm7MqCvqz8smhDz+Tt6gYqVOgFvC1LUHK9dwlsPEVjg1
 mGDPElivAoJ2+o2BHgDTbzDcWqqQLoENNm2VzQWQfKmprPY/mlLkzPP8x1RWz72qpmm0qWLp/ep
 1Gf+h0kU5Mxb/1lfNNO7kryPvP1ucJ42ibtEOAszDV/9sy4qkmCInNjCBni+HPeRYChSAwjwQV5
 Giq8/cHs+mSSMRPvoBCFcwfHVqQY+zPw8VuhEnjXYnAGtAHiW6nz91S5ysEHuXjmdIZbWNmHbLT
 h55IMoKtjCzJ3T/HKqcJCJ61XbHGSK92I6vRuEyJip7zWe6rUlExh+M8SUVR6nsQ5lM9wIdus/R
 Dbhko43 8ezYT+5g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
 fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] dm crypt: Annotate struct crypt_config with
 __counted_by
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct crypt_config.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f2662c21a6df..f276e9460feb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -224,7 +224,7 @@ struct crypt_config {
 	struct mutex bio_alloc_lock;
 
 	u8 *authenc_key; /* space for keys in authenc() format (if used) */
-	u8 key[];
+	u8 key[] __counted_by(key_size);
 };
 
 #define MIN_IOS		64
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

