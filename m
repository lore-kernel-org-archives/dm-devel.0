Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F8EC433C1
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 22:34:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A13E761A3C
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 22:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A13E761A3C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-G6BBECapNAuN-UHRclXKng-1; Thu, 25 Mar 2021 18:34:36 -0400
X-MC-Unique: G6BBECapNAuN-UHRclXKng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 576398CC2C0;
	Thu, 25 Mar 2021 22:34:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E50C5B4A7;
	Thu, 25 Mar 2021 22:34:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AEA84BB7C;
	Thu, 25 Mar 2021 22:34:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12PMYQG1005278 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 18:34:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0887BF8962; Thu, 25 Mar 2021 22:34:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0222EF896B
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 22:34:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A071685A5AA
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 22:34:23 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
	[209.85.221.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-431-W6n1lwnWMYCA68vx1R3c-A-1; Thu, 25 Mar 2021 18:34:21 -0400
X-MC-Unique: W6n1lwnWMYCA68vx1R3c-A-1
Received: by mail-wr1-f52.google.com with SMTP id c8so3815270wrq.11;
	Thu, 25 Mar 2021 15:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=7kWSgkdEp85qV54zZP705++z+GcLjIJ39Ci2UWHZdxU=;
	b=DprzPO/1gYZBwiFjlQ0r4Q+cM4yme3Y31iZiSFkj/f5PQAker0EHwxILOMCIxVNiHO
	GZBhHY/CSiOjN51/B5g2Xb17wxtvyisacErjj2CC1yrNrVxvQbDnXKk8Ni+GWu6fy854
	jPDyeEaLA2URmmxrUKtrAbUWUTOJaMbBa//8HYcjUfjNwFlHjtTTTuNy/1FnFseXiedX
	o7/AUI7REYEnnWXTkq7o+lLbYKIdnv/YfIpXlE/fHCx3du6kZXIgQlU+MjgwybZlgYY7
	FQV/sqiaPHHg640amiQ/QZytWxw1Y5wj0KWAgP+hbBS6vdA6sfAnqEa3y6Z7ml5q9ciS
	5jhQ==
X-Gm-Message-State: AOAM533/3zDfP9MtXFnf9zHh3qw2TdE1M8UbrooflpFk7iI/OLl8po1A
	CKFltKS+Ca3MU+zAsadItw==
X-Google-Smtp-Source: ABdhPJzq11gLyjDSbdJA5xMczpEnR+oW+AyX/W/vLgfaduoKzcGmAW+vBz9hJ7q11JEclp5xGen4Dg==
X-Received: by 2002:a5d:664e:: with SMTP id f14mr11780665wrw.382.1616711659747;
	Thu, 25 Mar 2021 15:34:19 -0700 (PDT)
Received: from localhost (220.red-83-38-250.dynamicip.rima-tde.net.
	[83.38.250.220]) by smtp.gmail.com with ESMTPSA id
	m15sm8731241wrp.96.2021.03.25.15.34.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 25 Mar 2021 15:34:19 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 25 Mar 2021 23:34:13 +0100
Message-Id: <20210325223414.5185-2-xose.vazquez@gmail.com>
In-Reply-To: <20210325223414.5185-1-xose.vazquez@gmail.com>
References: <20210325223414.5185-1-xose.vazquez@gmail.com>
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] multipath-tools: add info about how to
	enable ALUA in Huawei OceanStor arrays
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.alua | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/README.alua b/README.alua
index 340ccba2..f9967595 100644
--- a/README.alua
+++ b/README.alua
@@ -19,3 +19,6 @@ To enable ALUA, the following options should be changed:
 - NetApp ONTAP:
    To check ALUA state: "igroup show -v <igroup_name>", and to enable ALUA:
    "igroup set <igroup_name> alua yes".
+
+- Huawei OceanStor:
+   "Host Access Mode" should be changed to "Asymmetric".
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

