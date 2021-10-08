Return-Path: <SRS0=oblJ=O4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6727C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  8 Oct 2021 15:06:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B63B60FDC
	for <dm-devel@archiver.kernel.org>; Fri,  8 Oct 2021 15:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B63B60FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-m26EhubOOwa13pNUj9PPuQ-1; Fri, 08 Oct 2021 11:06:56 -0400
X-MC-Unique: m26EhubOOwa13pNUj9PPuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9578713967A3;
	Fri,  8 Oct 2021 15:06:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDA8860C05;
	Fri,  8 Oct 2021 15:06:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 978884EA2A;
	Fri,  8 Oct 2021 15:06:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 198F6iYM003964 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Oct 2021 11:06:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3F0042166B40; Fri,  8 Oct 2021 15:06:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38EE62166B41
	for <dm-devel@redhat.com>; Fri,  8 Oct 2021 15:06:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBA6280018D
	for <dm-devel@redhat.com>; Fri,  8 Oct 2021 15:06:33 +0000 (UTC)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
	[209.85.221.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-291-k5r_LifpN46BoBz_2xIQ0Q-1; Fri, 08 Oct 2021 11:06:30 -0400
X-MC-Unique: k5r_LifpN46BoBz_2xIQ0Q-1
Received: by mail-wr1-f53.google.com with SMTP id i12so18164380wrb.7;
	Fri, 08 Oct 2021 08:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=uK4PzeK/5E4tloYhmpv28yHQkJOmGhi2bG/rPQo732I=;
	b=zrMXb8LOMnys8gHQH0/PfRmv5OsOOmxNXoOOB/fkvRJ6ebCOm+tbb7Eg72cSM0MWFa
	eQXUg2k1woCRNSvPJosJkI6ah6Qu6rKlYnXNJ8OuUe5MzleGcVcx2SqJlvSSxiz2c3rq
	WpsH0FaIiKQJcn21ekKIwnUaZeZ9CoS/6WvvH7XtkObDi0PDGMu1WP7EtYe5gYNeoAu9
	yrTRzwzWd6Cmq5L4hIvkugRgiTZeKJdr363G8y47RlI4DZ0HnjIMhlsgEHDdm9wnJ06Q
	yv5ZMOFk8+7yY5XeoR++enWndpxNXG0VnAW9VnlRZdoPO5tvKnPz1OojjSxGhzUymuY3
	fNYA==
X-Gm-Message-State: AOAM532KMleSUzLl4TIG/dNUO0xXA98nroCZBiIsx56cojIZPt1hCzmU
	dxHbAhS+/wKk9js4V4lGkg==
X-Google-Smtp-Source: ABdhPJx8GIxUf1wNKUiZwR6OHKHVh5S/LevYtbfxN+ZXOHS1YHj+FkmQ4VWUWnKBFT7QmNmTs+OMPg==
X-Received: by 2002:a05:600c:3b26:: with SMTP id
	m38mr884733wms.0.1633705588717; 
	Fri, 08 Oct 2021 08:06:28 -0700 (PDT)
Received: from localhost (67.red-83-32-34.dynamicip.rima-tde.net.
	[83.32.34.67])
	by smtp.gmail.com with ESMTPSA id y5sm3014660wma.5.2021.10.08.08.06.27
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 08 Oct 2021 08:06:28 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri,  8 Oct 2021 17:06:26 +0200
Message-Id: <20211008150626.8894-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: dm-devel is a closed ml
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

Just for subscribers

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index b15c265f..2d3d1023 100644
--- a/README.md
+++ b/README.md
@@ -77,7 +77,7 @@ Maintainer
 ==========
 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
-Device-mapper development mailing list <dm-devel@redhat.com>
+Device-mapper development mailing list (subscribers-only) <dm-devel@redhat.com>
 
 
 Licence
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

