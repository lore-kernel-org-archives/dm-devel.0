Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AE1C433E9
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7C042068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7C042068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-1-5hct6iO_mw8uCK3Rfx6g-1; Mon, 04 Jan 2021 14:04:10 -0500
X-MC-Unique: 1-5hct6iO_mw8uCK3Rfx6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C91A9CC24;
	Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48E5C71C88;
	Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1EB1B1809CB9;
	Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT8txSJ010842 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 03:55:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AB6332166B2C; Tue, 29 Dec 2020 08:55:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A552E2166B2A
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 08:55:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C366800198
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 08:55:57 +0000 (UTC)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
	[209.85.160.202]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-472-kRuP1EyKOO-2rH53JtCRAw-1; Tue, 29 Dec 2020 03:55:54 -0500
X-MC-Unique: kRuP1EyKOO-2rH53JtCRAw-1
Received: by mail-qt1-f202.google.com with SMTP id c14so7275525qtn.5
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 00:55:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=3bO6YItz9vvTQJgokX465W6GGn8iDP/PMw/J2QDO/So=;
	b=LvzdZjB+UnSzsnGQIXtk95goH2Haa98it42nbKlYzUsWgUmygizF7xtGi/lN4B30vv
	6iGnLrxEoDVGt9x9ZoqCf1ZLmb+m/lMdhXYllXyWSBmZ4tJmBLEOfU6Wwey4nlEeLrTH
	7Wkjf0p/xr21f9jg467mn6IumMrPv+3o43NwdegoLXW2foWQLBBzSTjaOST2gRf/Cb7x
	UdR8sN2SA6AaMWxMAh63bcc4ognq97ZpNPFV7ebgAut7Vy1jkG48EDnxsSKodSYPhrkY
	WtBErfagWQX0HlwxIg1yyWIM7hv53mf086Houum4fw1ZjqUDQdFFEoe4gyXKMkDTjK/J
	Mb0Q==
X-Gm-Message-State: AOAM530CPYN94KiGUrEvvw/l/0HMEVUEr33KWmpa3UdaVTBKd96OHHN8
	TRay3Ym9zkrKnj0AZe9eFFflQpma+ks=
X-Google-Smtp-Source: ABdhPJxhU4q7GN5C1Z1AyzKVyRUGN5znZ+v3G/MJUPuiA4RVAhWGOcFupFszWQEI8exuXS9BJFU+l6WmdIw=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:a0c:99c8:: with SMTP id
	y8mr50020306qve.35.1609232154123; 
	Tue, 29 Dec 2020 00:55:54 -0800 (PST)
Date: Tue, 29 Dec 2020 08:55:24 +0000
In-Reply-To: <20201229085524.2795331-1-satyat@google.com>
Message-Id: <20201229085524.2795331-7-satyat@google.com>
Mime-Version: 1.0
References: <20201229085524.2795331-1-satyat@google.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v3 6/6] dm: set DM_TARGET_PASSES_CRYPTO feature
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
2.29.2.729.g45daf8777d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

