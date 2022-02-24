Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4123AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Feb 2022 21:23:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-hRaHqvTDOj6ulf4rggdj2g-1; Thu, 24 Feb 2022 16:23:49 -0500
X-MC-Unique: hRaHqvTDOj6ulf4rggdj2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F08A118766D2;
	Thu, 24 Feb 2022 21:23:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B775452EF;
	Thu, 24 Feb 2022 21:23:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A205B1809C98;
	Thu, 24 Feb 2022 21:23:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21OLNf8G010956 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Feb 2022 16:23:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A88C1400F3F3; Thu, 24 Feb 2022 21:23:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A46F04010A08
	for <dm-devel@redhat.com>; Thu, 24 Feb 2022 21:23:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C59C10F9707
	for <dm-devel@redhat.com>; Thu, 24 Feb 2022 21:23:41 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
	[209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-553-tfRWEBW8O9SuY31PJD2xJQ-1; Thu, 24 Feb 2022 16:23:37 -0500
X-MC-Unique: tfRWEBW8O9SuY31PJD2xJQ-1
Received: by mail-wr1-f42.google.com with SMTP id p9so1553183wra.12;
	Thu, 24 Feb 2022 13:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=A9gJR5InNNIoO8eMEATYatIPN3cvp2hhH5GA+EZqWi8=;
	b=tnEoyHbU2perm4sS0VZloS4VaqhIAM3Ap2wnybHnlcwljEzYBei5g6v7WbJJaj3NFY
	CwQYbIzIWGmInMhMjJF/LVJt8PrWPRkt/1KPjEedXlLDHcmYDg5gXGBf3JZ3iaxwl40b
	GgJwAsyATN5JswTaSozFYZBBUwllH17kO59dEsNIM2xQyguhPu6NBFD/5asx5T3FszuC
	f0wvVeRM4WrRG07ht3t4Nn8g9QWD90wwzPWNBbrXdnZy5WaiHxmuGvxf3TqfFZ9qXonn
	hmF5SnlXYYYauA/Q6/p94fdLar8O9bmPF4ms5WhlM7HV2oBsIqEAbpwsH9lY/SzE+Wca
	UwaQ==
X-Gm-Message-State: AOAM531xcuBiPKnKaOUm+knYJhBc5pkxT3sP21IVHHzlVsD46Ra9uCIY
	oc5pIjxgJaJ6LVUoPU5usA==
X-Google-Smtp-Source: ABdhPJwlBWTHp3MppRYYGS0SN0bxc3rgjQzBaM7J+6sCoaUnfZF976utp76sJvPzlvEOuR+hGXb8Ew==
X-Received: by 2002:a05:6000:1445:b0:1e8:49ec:5c22 with SMTP id
	v5-20020a056000144500b001e849ec5c22mr3677027wrx.87.1645737815768;
	Thu, 24 Feb 2022 13:23:35 -0800 (PST)
Received: from localhost (223.red-81-39-136.dynamicip.rima-tde.net.
	[81.39.136.223]) by smtp.gmail.com with ESMTPSA id
	p4-20020a05600c430400b0037bf8409eccsm557805wme.23.2022.02.24.13.23.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 24 Feb 2022 13:23:35 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 24 Feb 2022 22:23:34 +0100
Message-Id: <20220224212334.25798-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] multipath-tools: add HPE as vendor for OPEN-
	(XP8 arrays)
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

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index cace23b7..7a4b78f1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -467,8 +467,8 @@ static struct hwentry default_hw[] = {
 	 * Maintainer: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
 	 */
 	{
-		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HP XP */
-		.vendor        = "(HITACHI|HP)",
+		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HPE XP */
+		.vendor        = "(HITACHI|HP|HPE)",
 		.product       = "^OPEN-",
 		.pgpolicy      = MULTIBUS,
 	},
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

