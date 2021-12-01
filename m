Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB1DC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 22:37:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-7T1f4YwuPaqnWj-i5slK9w-1; Wed, 01 Dec 2021 17:37:05 -0500
X-MC-Unique: 7T1f4YwuPaqnWj-i5slK9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BACBB343CE;
	Wed,  1 Dec 2021 22:37:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99B205D6BA;
	Wed,  1 Dec 2021 22:37:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 675194CA93;
	Wed,  1 Dec 2021 22:37:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1MZTx2013758 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 17:35:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 31B2B40CFD10; Wed,  1 Dec 2021 22:35:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C69940CFD0E
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 154C8185A7B4
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:29 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
	[209.85.128.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-335-s40wkCIKOqGZ5oAKwsHicg-1; Wed, 01 Dec 2021 17:35:25 -0500
X-MC-Unique: s40wkCIKOqGZ5oAKwsHicg-1
Received: by mail-wm1-f44.google.com with SMTP id
	77-20020a1c0450000000b0033123de3425so954023wme.0; 
	Wed, 01 Dec 2021 14:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=eXI5jYE5Pljh5LR/vDQYG7w8C+YlSSjYEUoO7kOlcs0=;
	b=WwRlIMQCd6+jPlhCu8J4PsE+lwY3ImMh2pTON+v+qs71OhjsyAcOrAzOXzn1vMCnGw
	oBHqBcmg296Q+J273fkO8rGvzSs8tK68QdaKRG1saUnpHqIOiDSv5FxwXyS17TNjGdwV
	xKbHtBGBDHlzJ9iJpeL4jNNaMhScg0tnYRtSt1LA0B7/4nBragRcq2lvOIa21DgVYN6m
	hNlx085TUS23U1otW1YK+Ntc7OK6eh9qWMSpxzj0CAZ/FKo6QzG9oLXirL9i2n7hXppB
	xy+2jklsDRlAq5w5rJCSUc9yg75GTqgRs8rljap1RvtlMqgRt6kk333+OCgxaccMdch0
	5AqA==
X-Gm-Message-State: AOAM530FDubDwRhK7GMdf/Ihicf65WQwDImyFMrc1MBrno73aCr/SXRI
	S9zsHzINOkPILLrU46OLglfDSUCPYQ==
X-Google-Smtp-Source: ABdhPJxVoRIybn2rBDp2cetrBTA2WeIoS1k6DMH9wh3LRcOeKVx0JRMFhuZeZxgK2DyShIsJunqmUw==
X-Received: by 2002:a7b:cf0f:: with SMTP id l15mr1373565wmg.92.1638398123718; 
	Wed, 01 Dec 2021 14:35:23 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50])
	by smtp.gmail.com with ESMTPSA id r8sm1024885wrz.43.2021.12.01.14.35.23
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 01 Dec 2021 14:35:23 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed,  1 Dec 2021 23:35:16 +0100
Message-Id: <20211201223518.3775-2-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH resend] multipath-tools: delete duplicate RDAC
	maintainer entries
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

Already at NetApp.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 763982cd..1cae0ca5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -439,10 +439,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 10,
 	},
 	{
-		/*
-		 * ETERNUS AB/HB
-		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
-		 */
+		/* ETERNUS AB/HB */
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_AHB",
 		.bl_product    = "Universal Xport",
@@ -762,11 +759,7 @@ static struct hwentry default_hw[] = {
 	 * Lenovo
 	 */
 	{
-		/*
-		 * DE Series
-		 *
-		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
-		 */
+		/* DE Series */
 		.vendor        = "LENOVO",
 		.product       = "DE_Series",
 		.bl_product    = "Universal Xport",
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

