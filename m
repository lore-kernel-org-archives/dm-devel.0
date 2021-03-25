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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBF9C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 22:34:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6B7661A3C
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 22:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6B7661A3C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-93R_3QFKMC2M37gTDYfr7g-1; Thu, 25 Mar 2021 18:34:35 -0400
X-MC-Unique: 93R_3QFKMC2M37gTDYfr7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B314B1052A16;
	Thu, 25 Mar 2021 22:34:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92FB388F10;
	Thu, 25 Mar 2021 22:34:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E09341809C83;
	Thu, 25 Mar 2021 22:34:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12PMYORq005272 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 18:34:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4E49F2157F24; Thu, 25 Mar 2021 22:34:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48AD82157F23
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 22:34:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F4237800140
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 22:34:21 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
	[209.85.221.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-17-C4I2twuAME6X_VaAoJTpuQ-1; Thu, 25 Mar 2021 18:34:19 -0400
X-MC-Unique: C4I2twuAME6X_VaAoJTpuQ-1
Received: by mail-wr1-f48.google.com with SMTP id v11so3825396wro.7;
	Thu, 25 Mar 2021 15:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=rvDJcSuhahwZKUR7zftgbeJV6zOq1fQBVl22nQPZMOU=;
	b=Cs/h/Aj0RgdOkrSVQA5JmIkwhFig5VUcAOiz/wT4eQ7MzT0/7g/ixsMIfczh3OnRRV
	+zOj8SsfsEckytEelseG9MEXinkLUk6HrGZ7twV5jT42n4FKfxwrMgMkqDM+hSuzrtRg
	gGGj872OAmJQodC/TDsIjApQS/YdnE8A27z0eDNCyBZb43paIY4lQ7kfAke/23SOJHSK
	30ALmU+LganB8AbmOSAzU6UbV1acL6gZKhjmKiwEiwBaownK+BjBiLkeK8gghWdxYkD2
	i5ZVASdaRkyeVMQ9t6T+ppC/MVqvxz2baj9vQvD7lBCIHZ4GUYM+qU1/unMK8XU4UWgR
	veCw==
X-Gm-Message-State: AOAM532+vNJNc21VCe3HTolGF2kBBEneeoI9b2U0/XoHWXMPsNdYjrlg
	LNHeH1k7TseL8210jkMIdA==
X-Google-Smtp-Source: ABdhPJw8W/n+Au8xdjsOiRQ0jCUtO607ylASoTcLx3+ixW34GbzW/52TZVdmnhpnsB2CrclsmQzyjg==
X-Received: by 2002:adf:e485:: with SMTP id i5mr11314651wrm.26.1616711658328; 
	Thu, 25 Mar 2021 15:34:18 -0700 (PDT)
Received: from localhost (220.red-83-38-250.dynamicip.rima-tde.net.
	[83.38.250.220]) by smtp.gmail.com with ESMTPSA id
	e13sm9995464wrg.72.2021.03.25.15.34.17
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 25 Mar 2021 15:34:17 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 25 Mar 2021 23:34:12 +0100
Message-Id: <20210325223414.5185-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH 0/2] multipath-tools: add more ALUA info to docs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Xose Vazquez Perez (2):
  multipath-tools: add info about how to enable ALUA in Huawei OceanStor arrays
  multipath-tools: add more info about ALUA for CLARiiON arrays

 README.alua | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
BTW, some "new" generations of fully symmetrical Active-Active arrays support ALUA
(by default ???), but in the multipath-tools hwtable they are defined as "multibus":
- IBM DS8000, since ???
- IBM XIV, since Gen2 with microcode 10.2.1
- EMC SYMMETRIX, since VMAX 3 with HYPERMAX OS 5977.811.784
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

