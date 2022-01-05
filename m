Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9D9C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jan 2022 22:30:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-v5sft0SLMSOysT_0GxiEvQ-1; Wed, 05 Jan 2022 17:30:31 -0500
X-MC-Unique: v5sft0SLMSOysT_0GxiEvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA9F1083F62;
	Wed,  5 Jan 2022 22:30:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 434B25F4F4;
	Wed,  5 Jan 2022 22:30:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C40F94BB7C;
	Wed,  5 Jan 2022 22:30:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 205MUJuZ028323 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 Jan 2022 17:30:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C395253D5; Wed,  5 Jan 2022 22:30:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE5D853D4
	for <dm-devel@redhat.com>; Wed,  5 Jan 2022 22:30:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 927C53800682
	for <dm-devel@redhat.com>; Wed,  5 Jan 2022 22:30:16 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
	[209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-333--9X5PMqpP0K7fLaHKvzmsw-1; Wed, 05 Jan 2022 17:30:13 -0500
X-MC-Unique: -9X5PMqpP0K7fLaHKvzmsw-1
Received: by mail-wr1-f42.google.com with SMTP id t26so1106367wrb.4;
	Wed, 05 Jan 2022 14:30:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=IgDazm/jOndNeH1Jt12hfE4vXFNZVcG9sQ4AaULixTA=;
	b=tF/ckU0QbTDdYj17rN3iz14+mahrCrjRR9bLrEdqPVPDmDfHdfnuXlrZ476LLdBDV5
	xvI+9YqMliPHpS5X3JcTxexcnIqZTf/2BB8c9Nqub/CJtkaXbbtCUB1075nQvHiM8QMl
	dEVxMUWITRssY236XQifMQsHGT1YhgmuSg6BMcNEVsRfPX4vDEB2w/fZyN7nQqcAEG4p
	MaIiuCClfj3I63K4ug7CoQyAQQmzsLCXzZdkMInyDc9VPOIHlUV83tKcJCKrRQajkkZo
	c6qpPfMGcacfpI5WV8uMQLkeOIr2K+hAEMgPfuz1cW8AqtMtzKzMhhpqLolVJG1ShOvJ
	SOgQ==
X-Gm-Message-State: AOAM533kYOwqf3FrJQ6XdEOhDaNR8WVGtgLfhXLEBUQBY23GEOi5LaVL
	1SVSFkNycQFophrwB46KjRY=
X-Google-Smtp-Source: ABdhPJwcy/Yy0q10hprklKXJwCIZ6HwSybRpESza4oBvVo5cSM5fac9bo9Khnvf8IfdFnjcBMZDN4Q==
X-Received: by 2002:adf:fa4d:: with SMTP id y13mr4084161wrr.278.1641421811789; 
	Wed, 05 Jan 2022 14:30:11 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145])
	by smtp.gmail.com with ESMTPSA id y1sm250271wrm.3.2022.01.05.14.30.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 05 Jan 2022 14:30:11 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id 44ED3183274E8; Wed,  5 Jan 2022 22:30:10 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Wed,  5 Jan 2022 22:30:06 +0000
Message-Id: <20220105223006.162573-1-slyich@gmail.com>
MIME-Version: 1.0
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
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] kpartx/devmapper.c: fix unused-but-set variable
	error
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On gcc-12 build failed as:

    devmapper.c: In function 'dm_simplecmd':
    devmapper.c:61:13: error: unused variable 'udev_wait_flag' [-Werror=unused-variable]
       61 |         int udev_wait_flag = (task == DM_DEVICE_RESUME ||
          |             ^~~~~~~~~~~~~~

Fix error by hiding it's declaration under #ifdef that uses it.
CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 3efd6dfc..511c090f 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -58,9 +58,9 @@ out:
 int dm_simplecmd(int task, const char *name, int no_flush, uint16_t udev_flags)
 {
 	int r = 0;
+#ifdef LIBDM_API_COOKIE
 	int udev_wait_flag = (task == DM_DEVICE_RESUME ||
 			      task == DM_DEVICE_REMOVE);
-#ifdef LIBDM_API_COOKIE
 	uint32_t cookie = 0;
 #endif
 	struct dm_task *dmt;
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

