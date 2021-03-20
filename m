Return-Path: <SRS0=YJnZ=IS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F561C433DB
	for <dm-devel@archiver.kernel.org>; Sat, 20 Mar 2021 02:13:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4B8F6197F
	for <dm-devel@archiver.kernel.org>; Sat, 20 Mar 2021 02:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4B8F6197F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-A6HkGWe5N1OXD7SXwjoRyQ-1; Fri, 19 Mar 2021 22:13:31 -0400
X-MC-Unique: A6HkGWe5N1OXD7SXwjoRyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 445B080D6A9;
	Sat, 20 Mar 2021 02:13:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5333E19D9D;
	Sat, 20 Mar 2021 02:13:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5E21F4BB7C;
	Sat, 20 Mar 2021 02:13:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12K2DJxu013355 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 22:13:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 401CA2026D60; Sat, 20 Mar 2021 02:13:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7972026D46
	for <dm-devel@redhat.com>; Sat, 20 Mar 2021 02:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 959AC1021E08
	for <dm-devel@redhat.com>; Sat, 20 Mar 2021 02:13:15 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-334-TE2PknaKOOCkpAKpRmdkKA-1; Fri, 19 Mar 2021 22:13:11 -0400
X-MC-Unique: TE2PknaKOOCkpAKpRmdkKA-1
Received: by mail-wm1-f53.google.com with SMTP id
	u5-20020a7bcb050000b029010e9316b9d5so6120832wmj.2; 
	Fri, 19 Mar 2021 19:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=brhnlAMYB5SOnEwubmD/NXJ1c0+rRHL9FIWIuFXdr7o=;
	b=Dkw2Jcsqg2w/be/IF7FPOIPcdEa/LyG0z2gSjJ5z1/Gk5jjwHqwfWQuu7Iqu2VZMet
	yXgLMOzlf20IfnUJdUI55K0GoNVbqZ/wZH2//Us5HrSHSu0m7guwkodr60RhFTprL6jx
	+5DwYsEeAbvnEqqDX7KFkILeiP94aISpOMV/LiIdz0L5w4FxB3OjRnPmFSzy8sLcUGAG
	g+c+GxRr0FHbGR5giu0NRa9ckfJWYUQU9513FYH9525KD9gMWIAvFI6kMYePt6N3j5mr
	52+Uw9jHEkU6f9j+7//51LUBbNg/2WY5lWBlC09rh/WDucAnDWzlKFKEqISK0wEAnJqi
	frMw==
X-Gm-Message-State: AOAM533EXUbvK7TTt/eD4nNMmbcRv6esppmw61xFnyawfMyqQjnixaUk
	U2dGZ/BkojPUJlx8o4mdfQ==
X-Google-Smtp-Source: ABdhPJzyiIif5uREx2zb2zAlTB1jKNzAv5+fi3c0RLghnzd4U27mOmko+S0rX6xLPTPY89QxAJ1L2Q==
X-Received: by 2002:a1c:4d09:: with SMTP id o9mr5882892wmh.15.1616206389691;
	Fri, 19 Mar 2021 19:13:09 -0700 (PDT)
Received: from localhost (47.red-83-37-107.dynamicip.rima-tde.net.
	[83.37.107.47]) by smtp.gmail.com with ESMTPSA id
	l15sm8386347wme.43.2021.03.19.19.13.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 19 Mar 2021 19:13:09 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 20 Mar 2021 03:13:07 +0100
Message-Id: <20210320021307.87193-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: use same format for default
	values in multipath.conf.5
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For max_sectors_kb, replace "device dependent" with its sysfs path.
And use <dev> as wildcard for device in paths.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
---
 multipath/multipath.conf.5 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 2aa0f526..064e4826 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -647,7 +647,7 @@ does not respond to the checker command after \fIchecker_timeout\fR
 seconds have elapsed, it is considered down.
 .RS
 .TP
-The default is: in \fB/sys/block/sd<x>/device/timeout\fR
+The default is: in \fB/sys/block/<dev>/device/timeout\fR
 .RE
 .
 .
@@ -1242,7 +1242,7 @@ Sets the max_sectors_kb device parameter on all path devices and the multipath
 device to the specified value.
 .RS
 .TP
-The default is: \fB<device dependent>\fR
+The default is: in \fB/sys/block/<dev>/queue/max_sectors_kb\fR
 .RE
 .
 .
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

