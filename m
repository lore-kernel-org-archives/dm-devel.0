Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A527C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 22:35:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-YH_nh4x4Pxu_LdV4cHJ5zw-1; Wed, 01 Dec 2021 17:35:49 -0500
X-MC-Unique: YH_nh4x4Pxu_LdV4cHJ5zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C86801B00;
	Wed,  1 Dec 2021 22:35:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DE565D6CF;
	Wed,  1 Dec 2021 22:35:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5D01B4BB7C;
	Wed,  1 Dec 2021 22:35:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1MZc5V013787 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 17:35:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 634F151DD; Wed,  1 Dec 2021 22:35:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D4F551DC
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A3B285A5AA
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:31 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
	[209.85.128.50]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-596-TZ7ylqWJN8yOCcSCzzNhtw-1; Wed, 01 Dec 2021 17:35:27 -0500
X-MC-Unique: TZ7ylqWJN8yOCcSCzzNhtw-1
Received: by mail-wm1-f50.google.com with SMTP id 137so21588490wma.1;
	Wed, 01 Dec 2021 14:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=scIydzjecadjDER0cqC+NNEp68vC4KwTS1DiHnnZzcM=;
	b=Iq3hbVq/bpH5zF7w1bIi8FUN7n9DDrXHHL/p+WmDUAp56JoCSkgElgxtUnyNrgFJvM
	jb7mL0bsuEPHB8CR5tCrPzPUrryrT4ynOiVK+TUXv6hd4qEMIrP8ONcrOxHyU1YKrQ3G
	wu+vEZybYtYs6MpxQfCb0D1UxfCTxe2t6rP+0rrWfWAVGM+OcPYXoZlxcqTOyAOyDi1u
	FmtScHqb97Ewl2FQeGktREbrshFUQsdueMDorQN0AjJdgxlpXg2bPbMBRXQPrjwqJYVu
	aQcObbKCsZM+ZA4sSdC8sLg3Y96bqPqTOV8huKnCiszKk6xv4NB6noCW2qOQU07GWCwL
	GA5Q==
X-Gm-Message-State: AOAM531MFoIcljh25t+ZJM7hefjP+VNGxqjSkHh6ubBKVaHStfeu+1r8
	aDbCFa64oKtAlQXiljhCyA==
X-Google-Smtp-Source: ABdhPJzpKcn38KxBJ3/GSxJ1m3qeumC1URYC1xH+yE6LVq7BIuwQfQsk1wR7gpDdYoXHeGkYaJlxbA==
X-Received: by 2002:a05:600c:a0b:: with SMTP id
	z11mr1297339wmp.147.1638398126113; 
	Wed, 01 Dec 2021 14:35:26 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50])
	by smtp.gmail.com with ESMTPSA id s8sm995063wra.9.2021.12.01.14.35.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 01 Dec 2021 14:35:25 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed,  1 Dec 2021 23:35:18 +0100
Message-Id: <20211201223518.3775-4-xose.vazquez@gmail.com>
In-Reply-To: <20211201223518.3775-1-xose.vazquez@gmail.com>
References: <20211201223518.3775-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH resend] multipath-tools: remove Hannes as IBM
	arrays maintainer
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

Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 763982cd..11282699 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -482,8 +482,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * IBM
-	 *
-	 * Maintainer: Hannes Reinecke <hare@suse.de>
 	 */
 	{
 		/* ProFibre 4000R */
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

