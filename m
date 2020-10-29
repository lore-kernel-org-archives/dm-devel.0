Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506FCC2D0A3
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 22:45:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8395020639
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 22:45:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8395020639
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-gitFsFZ7OPWmO3Yz9QTE6g-1; Thu, 29 Oct 2020 18:45:47 -0400
X-MC-Unique: gitFsFZ7OPWmO3Yz9QTE6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F389884DEA;
	Thu, 29 Oct 2020 22:45:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FD966EF68;
	Thu, 29 Oct 2020 22:45:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91D99CF6D;
	Thu, 29 Oct 2020 22:45:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09TMi2LL015987 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Oct 2020 18:44:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D54942166BDD; Thu, 29 Oct 2020 22:44:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF9A32166BD9
	for <dm-devel@redhat.com>; Thu, 29 Oct 2020 22:44:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5129101AA41
	for <dm-devel@redhat.com>; Thu, 29 Oct 2020 22:44:00 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-380-g8L376W5NsyBijZG79mjiw-1; Thu, 29 Oct 2020 18:43:57 -0400
X-MC-Unique: g8L376W5NsyBijZG79mjiw-1
Received: by mail-wr1-f51.google.com with SMTP id g12so4456011wrp.10;
	Thu, 29 Oct 2020 15:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=P1ciPBPE1pRXpkBhEQCzJX1V5fkJMklRgvglefXHt5g=;
	b=BhT2kEYoAhuDysQN+nJpPefpjxPQ9CUc59TbCk+VUXWwb1qVN7bItLC9sxk+78kIes
	4g4gfriMPk657GVJI1QCkDSgoQDlTE+o7BKoZiLh7YDA8/T58/276LRzrapxiZU/rdTO
	jhiWclP9mcR0Q+bu+le7vgZqgpLRsbzrzHpK7GWVpphGEqFKzQO2g4wz39liNru0eMag
	FBvnQ7l0lt8ermdZRKTqbJf+cUz8Pjop/yE7H0PCvlbv6MKzU3QLwT0G0lINl5mcYSy7
	ZdevGDwbckuZU7xtZYTdts7fIcNSWSmkWmA39QFwVn6EhaT0awdWq0Aeuzeu8CbmvcWY
	lOaw==
X-Gm-Message-State: AOAM532pZ/QTdguf5iy5kGbO6c8PFD8EJlDMXsOXsLaDsTWIKbazs6Wy
	TQSZKRkZMBL3t8wnK6GeAw==
X-Google-Smtp-Source: ABdhPJxeIzWBJ63xPWCCtfqk4AbC9wTstwIJQ2LJQ7OzDD8G1JgS4KkmIVj/XU66+mVDWlCmeFppSw==
X-Received: by 2002:adf:ed52:: with SMTP id u18mr8815717wro.357.1604011436107; 
	Thu, 29 Oct 2020 15:43:56 -0700 (PDT)
Received: from localhost (131.red-176-87-1.dynamicip.rima-tde.net.
	[176.87.1.131])
	by smtp.gmail.com with ESMTPSA id p4sm8005024wrf.67.2020.10.29.15.43.54
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Oct 2020 15:43:55 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 29 Oct 2020 23:43:53 +0100
Message-Id: <20201029224353.6258-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: add Vexata(by StorCentric) VX
	arrays
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

https://support.sas.com/resources/papers/performance-tuning-sas-vexata-systems.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f5a3729e..a54cc0a3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1190,6 +1190,14 @@ static struct hwentry default_hw[] = {
 		.product       = "Magnitude",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
+	},
+		/* Vexata */
+	{
+		/* VX */
+		.vendor        = "Vexata",
+		.product       = "VX",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
 	},
 	/*
 	 * Promise Technology
-- 
2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

