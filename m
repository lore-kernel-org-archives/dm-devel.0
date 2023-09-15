Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4253CCD37A7
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694808245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PM1lVnbiQMvPMcvrDSbUQinfcHgD+tfdtUfLcQd9eGo=;
	b=WjHrreKKHl/FLhqqGWh/gYs6ii58s3CLQHIFeLoGZ3+RSSCE9hoo+yawFJ0Vt64am2Szso
	ussfxz8q5hK9PhiEUU15T/GfKd4c7eDPeMD6/ZA6RkyyobbpXGVp96X0GTvgfExnHgrYlB
	Ne1bNAJcKzI9OKY3wIdvzrJTEwthfzM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-_IIgFgNrO7KHe1AMJToC2g-1; Fri, 15 Sep 2023 16:04:02 -0400
X-MC-Unique: _IIgFgNrO7KHe1AMJToC2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E4BB1875045;
	Fri, 15 Sep 2023 20:04:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 51C6C21B20B1;
	Fri, 15 Sep 2023 20:03:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19EAE194658C;
	Fri, 15 Sep 2023 20:03:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8787F1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:03:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61FFF1054F83; Fri, 15 Sep 2023 20:03:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A2821054F81
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:03:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE172811E88
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:03:41 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-zHhumgEHMWi0RcDh7Ufx2w-1; Fri, 15 Sep 2023 16:03:39 -0400
X-MC-Unique: zHhumgEHMWi0RcDh7Ufx2w-1
Received: by mail-pf1-f173.google.com with SMTP id
 d2e1a72fcca58-68fbbea0dfeso2136591b3a.0
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 13:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694808218; x=1695413018;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3EcXc4p/OZvjhpZjniZGrlHnagHBjkD/G1KmRx4RQEY=;
 b=j6hWeF5XtHO2GxZcCwAQUvh9AX5gDbMklHeTWKshAZ2Cp27cHs6l0PkbraUOtrnmHU
 Y4gNHWTBwJAdsayF5zxSxgM2V7lltkjlLXhauRcevKGXdyu9harI2b2MHlA0WUjxEGa0
 Oi40k4kppcKEsroC/Xg9Iy6TkCkIkDCgR7yR3YRkD2MN4nTRpEXcC5ymgwBqOxDKZhld
 RczupVLk/hejR9rKu7MFTHF+1TnxrB+js3gFqyQnYcEZme68YQ4yDirZzcogIB/xuKNH
 3AyL70pl64rYfJk4+sbZBJf0Za56dRjvx8b9KbkkzUyn2YcTXA62B5ho1HOcXnVQreQo
 KHSQ==
X-Gm-Message-State: AOJu0YwCV7dWP6Hde/NiO0X0Si8i4KBBGm0T6Ki6FhvmNNhsCykYFJaW
 gA8V1qgc8ar0hJV/Ta5/YyRefw==
X-Google-Smtp-Source: AGHT+IHzIIRXAsC49F/G94cgVOd9c2WBf+CMYStzd0rWb8+BhqsZLM2DtQPyl2+9IiDNZBy2vC9pbA==
X-Received: by 2002:a05:6a00:c90:b0:68f:e0f0:85f4 with SMTP id
 a16-20020a056a000c9000b0068fe0f085f4mr2391932pfv.25.1694808218030; 
 Fri, 15 Sep 2023 13:03:38 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 q15-20020a62e10f000000b00682c1db7551sm3307074pfh.49.2023.09.15.13.03.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:03:37 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri, 15 Sep 2023 13:03:36 -0700
Message-Id: <20230915200335.never.098-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1112; i=keescook@chromium.org; 
 h=from:subject:message-id;
 bh=3ZvYiEsZZa56aKWu6y0PnTbRMpo38Aw/L94IEjhb4Tc=; 
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlBLiYTyy1xh5VON0ySJo9kFErTAbQFWQI95vz1
 9vW2hZ7e5yJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZQS4mAAKCRCJcvTf3G3A
 JplJD/9wyOg+Xy09KCd38SWSRoERMIlg+91bNOk9bfpY2aBh3lv91ulrX53nyRunUA02GCG0EfT
 KAEZKI/2vR7K3DBBGzndXE8/eZki/GOdVUVAeIotscDIQCswSFeVrPWcOV3gTKNHmwDOJNqOhae
 PXNwG5Fgv7FNEY68jEyyJq4BJdATKz4lEL2woZ62IGNRNGGyUT3Q6evSPpB9naGIxdq7i7gJLHa
 gmgONPB6bRaS7U+Q5O3fAbI/UjYhNV6MUMaAZ/6yxpkewG6Hb5yTuQ2/YXGsq+XrBOs39PS5vNe
 CQHDFiZIzLg+vEWzFlW91THnSxrlYY2q6TLb0Me7nkxnaPKsKFuFzwL9rq25nET6JP8hINETJqP
 sKfWeuhy321LLzTGS0XNBrP4VFsDkLPcCtHrp7CfWyeiXBKQrr42xZF+wKEuBTjbW0PEgo7bQjl
 bT6fQJjM95fDf2EJQOHoz5ttA5z/PHK5QF973oyfgK6eq7AzwKyj9oFFf4Y4GF9wu+Z/PNq04hS
 D2n58sWCRuH4/7eJMNIl5O5bAZATtf3lObXLRtL5OJXZq58zG/uMp1o40da7W/RtbTMPq3Hc2uT
 XGJPSvkjpqXA3X/A86g6vAHjsFuoJZce8yvX4diqSLCWDA+NivlRwzcXDgEyaPnbMxxonfsAsaT
 K5u/Ioo p9oiGWzQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
 fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH] dm raid: Annotate struct raid_set with
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

As found with Coccinelle[1], add __counted_by for struct raid_set.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5f9991765f27..9755788e8b78 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -254,7 +254,7 @@ struct raid_set {
 		int mode;
 	} journal_dev;
 
-	struct raid_dev dev[];
+	struct raid_dev dev[] __counted_by(raid_disks);
 };
 
 static void rs_config_backup(struct raid_set *rs, struct rs_layout *l)
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

