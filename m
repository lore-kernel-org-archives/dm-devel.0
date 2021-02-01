Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8ADAC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:10:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2050E64E2B
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2050E64E2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-1c4Ff538PMiFMLgdmPbrFg-1; Mon, 01 Feb 2021 00:10:46 -0500
X-MC-Unique: 1c4Ff538PMiFMLgdmPbrFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C697E612B0;
	Mon,  1 Feb 2021 05:10:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F4545D961;
	Mon,  1 Feb 2021 05:10:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72BE650038;
	Mon,  1 Feb 2021 05:10:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1115AdPf015713 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 00:10:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 870C51111A5C; Mon,  1 Feb 2021 05:10:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8353D1111C9F
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 722AC801223
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:39 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
	[209.85.219.202]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-510-QtOgbNW1Mp2x8pc-InZwYw-1; Mon, 01 Feb 2021 00:10:37 -0500
X-MC-Unique: QtOgbNW1Mp2x8pc-InZwYw-1
Received: by mail-yb1-f202.google.com with SMTP id 203so18378814ybz.2
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 21:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=tsR7HhO1/8EFXvkT3LKZR+I5g9ZmXVYdpiXsfnhKFQE=;
	b=O+Nfr/asHJbf+VeYwaOypZDhDYGOVTVx6NE9MOOc5IXV44RP+pkAN2sIvSEYlB6TF5
	7FxMj+qvg7fC43MixJHR4vX4FM004VtAWUmPN7WrkOwcVFuwZOzHHmQP5MQVZ7F+JdvH
	aoIPObU7F8jFfGqe02xdxwx+UEgT3hkGte1FER9qEMxjdE41zulJDpAYd3KnfeacPQb/
	3aFIX4oqAo6LoY0LsGjmGHpeTttSmL+wgEI79iJydvN86ao7tHKEBByXKVNLSq7XCgRE
	naXEh3sEeLCoEXeYkBWJSrnIxz6VMAIuW/4BgINNfjlBo4DwczIe3Rit76uqXfHWxlCD
	qOcg==
X-Gm-Message-State: AOAM533M56L8njVJpIFL4bgfL81QNAfjBd4JknpLEb82V9LWhaTa2GbQ
	501X3CoMasAZfUHrKUCCJ/SwO3tND3E=
X-Google-Smtp-Source: ABdhPJzHvb+x5wi/WXBWFc/y/S6NWvFLWKYpHtLIzOFQg75s1lLXTb+FaOcNF1B8+TRzc4ds1FTwCDFqop4=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:a25:1402:: with SMTP id
	2mr19186874ybu.15.1612156236927; 
	Sun, 31 Jan 2021 21:10:36 -0800 (PST)
Date: Mon,  1 Feb 2021 05:10:19 +0000
In-Reply-To: <20210201051019.1174983-1-satyat@google.com>
Message-Id: <20210201051019.1174983-6-satyat@google.com>
Mime-Version: 1.0
References: <20210201051019.1174983-1-satyat@google.com>
From: Satya Tangirala <satyat@google.com>
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v4 5/5] dm: set DM_TARGET_PASSES_CRYPTO feature
	for some targets
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-linear and dm-flakey obviously can pass through inline crypto support.

Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/md/dm-flakey.c | 4 +++-
 drivers/md/dm-linear.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index a2cc9e45cbba..30c6bc151213 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -482,8 +482,10 @@ static struct target_type flakey_target = {
 	.name   = "flakey",
 	.version = {1, 5, 0},
 #ifdef CONFIG_BLK_DEV_ZONED
-	.features = DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO,
 	.report_zones = flakey_report_zones,
+#else
+	.features = DM_TARGET_PASSES_CRYPTO,
 #endif
 	.module = THIS_MODULE,
 	.ctr    = flakey_ctr,
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 00774b5d7668..fc9c4272c10d 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -229,10 +229,11 @@ static struct target_type linear_target = {
 	.version = {1, 4, 0},
 #ifdef CONFIG_BLK_DEV_ZONED
 	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
-		    DM_TARGET_ZONED_HM,
+		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO,
 	.report_zones = linear_report_zones,
 #else
-	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
+		    DM_TARGET_PASSES_CRYPTO,
 #endif
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
-- 
2.30.0.365.g02bc693789-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

