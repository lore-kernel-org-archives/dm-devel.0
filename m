Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5EBC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:41:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 368276135F
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 368276135F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-k-D1EM40PkWBvarCs07wCA-1; Tue, 28 Sep 2021 16:41:01 -0400
X-MC-Unique: k-D1EM40PkWBvarCs07wCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1A69801E72;
	Tue, 28 Sep 2021 20:40:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6939E5E255;
	Tue, 28 Sep 2021 20:40:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E87381800FE4;
	Tue, 28 Sep 2021 20:40:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18SKdnW1008841 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 16:39:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0132250167; Tue, 28 Sep 2021 20:39:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF8A7422DF
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 20:39:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 987A5185A7A4
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 20:39:24 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
	[209.85.221.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-266-cZQ8GaoHObaTwlqnfDIfRA-1; Tue, 28 Sep 2021 16:39:20 -0400
X-MC-Unique: cZQ8GaoHObaTwlqnfDIfRA-1
Received: by mail-wr1-f47.google.com with SMTP id d6so474580wrc.11;
	Tue, 28 Sep 2021 13:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=ov5ThezqBPHOLksKmvSo4VfeYsu9vzRyR2SAXIqxRZc=;
	b=25iagbV1Gak73gLPeTv1iO4U16IshL7y8nhGBT8ouAMjektQAhpfSs25VXgAo+ubQ7
	rESt0wV+PA1KJ9Mb0hyOvBU5sy/6Zwq1Epq3keGWo64UiwnnWBohZ8ppbVNBFoaLTbVz
	b7R5mAIucGIxiPiwfNHdejL3jQFTsnRNfChVMZDh8irinB+pFhGFWf71YGh3lLjeigSu
	EAdj18ANOYvXW0/tIMEDn+VjgECS/9yMY2KNOImAmwmDaJ9klVf5t6lSZzJXCMcFO3DZ
	Sjh8CGcXxvq2kJgkEaK277p+SFs9t9GNA0tfuyMj1c/HNvIpArr357YCHKgrtXt1hQxX
	dmzQ==
X-Gm-Message-State: AOAM5319DaOFuPlUGt11J1Lp2qYx+g8FsGZDFpZpQEB7L25P6oTgbOXU
	+7OcA9XnxygCVg70edUB3d0SH3pU+A==
X-Google-Smtp-Source: ABdhPJz+zKrzGPhCyMOZ9YiaD0bLwLqpsvuWddS4c+G2Yx2MqpfwFpTlZu8HcR1yuvgQRlNJTsBBmQ==
X-Received: by 2002:a5d:46ca:: with SMTP id g10mr2430248wrs.269.1632861559259; 
	Tue, 28 Sep 2021 13:39:19 -0700 (PDT)
Received: from localhost ([90.160.137.52])
	by smtp.gmail.com with ESMTPSA id o13sm234464wri.53.2021.09.28.13.39.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 28 Sep 2021 13:39:18 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Tue, 28 Sep 2021 22:39:17 +0200
Message-Id: <20210928203917.25237-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: remove Compellent maintainer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

e-mail was bounced: 550 5.1.1 User Unknown

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7fc5bc04..763982cd 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -361,11 +361,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/*
-		 * SC Series, formerly Compellent
-		 *
-		 * Maintainer: Sean McGinnis <sean_mcginnis@dell.com>
-		 */
+		/* SC Series, formerly Compellent */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

