Return-Path: <SRS0=qylv=OV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96594C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 10:42:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C7C761361
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 10:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8C7C761361
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-7dHsT1YFP3qU9r2xYszijw-1; Fri, 01 Oct 2021 06:42:48 -0400
X-MC-Unique: 7dHsT1YFP3qU9r2xYszijw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6687100C660;
	Fri,  1 Oct 2021 10:42:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B15B5BAE5;
	Fri,  1 Oct 2021 10:42:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9607A4E58F;
	Fri,  1 Oct 2021 10:42:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 191AgecX029355 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 1 Oct 2021 06:42:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DB1B92051CF7; Fri,  1 Oct 2021 10:42:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2EDB2167D9A
	for <dm-devel@redhat.com>; Fri,  1 Oct 2021 10:42:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F4E6800141
	for <dm-devel@redhat.com>; Fri,  1 Oct 2021 10:42:38 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
	[209.85.221.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-401-Q7eKt0NbMiqoH40YULey1Q-1; Fri, 01 Oct 2021 06:42:36 -0400
X-MC-Unique: Q7eKt0NbMiqoH40YULey1Q-1
Received: by mail-wr1-f43.google.com with SMTP id v25so4148590wra.2;
	Fri, 01 Oct 2021 03:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=eXI5jYE5Pljh5LR/vDQYG7w8C+YlSSjYEUoO7kOlcs0=;
	b=K0qGC6tNqhZ0kRevGK0zy1uEl+gDSSx9ZzUceXj87QXuVZIeXAnftSmMrszdCivLrZ
	6YemymuZOdfipPEOQ45nl+2lCCvyl+mj30MnHUPXvyzkKK25yDqvT2RpV8lRXuMBPee5
	pd1KUc0oUvWtvWZ19GCNCHeKpOE1laTqpCcz+cQmHuwik1WJl5os+z3hezIzblt3IMzW
	+qIexzee7LZuECecm1PQbft+gKKDnGecCt0kQnW/CRKDfEsRHpWJw/48eyuCOofZP/Lk
	Na26IePmsBU1QOVgMGQKo12b8v/gOS2YfGi8KnY+5SEKmhfMN7lD4yBufmO/yHKAUVLv
	3Bkg==
X-Gm-Message-State: AOAM532bLYibpv3USIaofyOQqtMZZkY2LjGeA7MajSw8T2GAOStStx7n
	7x2qEpvUdplu3ccklmYoqw==
X-Google-Smtp-Source: ABdhPJyk80I7+LfgzZoRnZcC7LcI3c7zadASm1vma1s9R6iN3gK/GQPrAGPl1smjAwExrxUHcZbcPw==
X-Received: by 2002:a05:6000:d2:: with SMTP id
	q18mr11616464wrx.4.1633084955122; 
	Fri, 01 Oct 2021 03:42:35 -0700 (PDT)
Received: from localhost (67.red-83-32-34.dynamicip.rima-tde.net.
	[83.32.34.67]) by smtp.gmail.com with ESMTPSA id
	f17sm5841733wru.69.2021.10.01.03.42.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 01 Oct 2021 03:42:34 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri,  1 Oct 2021 12:42:33 +0200
Message-Id: <20211001104233.4242-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: delete duplicate RDAC
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

