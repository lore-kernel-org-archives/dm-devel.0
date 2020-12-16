Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCC5C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:18:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B980A22A99
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:18:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B980A22A99
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-6aopzMrpNVODZvxwA_V0Sg-1; Wed, 16 Dec 2020 17:18:00 -0500
X-MC-Unique: 6aopzMrpNVODZvxwA_V0Sg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDCA2803625;
	Wed, 16 Dec 2020 22:17:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57EFD10013C0;
	Wed, 16 Dec 2020 22:17:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 923DA49;
	Wed, 16 Dec 2020 22:17:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGMHpQA013442 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 17:17:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5404B2166B2C; Wed, 16 Dec 2020 22:17:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F1232166B27
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 22:17:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D585E858280
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 22:17:48 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
	[209.85.221.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-357-XtkaCHYnPHOBisTQyziswg-1; Wed, 16 Dec 2020 17:17:44 -0500
X-MC-Unique: XtkaCHYnPHOBisTQyziswg-1
Received: by mail-wr1-f48.google.com with SMTP id d13so6402156wrc.13;
	Wed, 16 Dec 2020 14:17:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=sZ5ZUpVYmABZvtY0iLuKCgQ3vOnOzWDu+yoQ2aCQ5fk=;
	b=Uw9annuydX/nuliNWY5ZPOOmmoTIXAdEBxPzPRIyvxDFjebUURCICqT/4S4r3cXcnW
	6UcmpU/C1BM1oXLETzNzicJ+EBnbLGR8b7L4CCkpBIxXyB4FbsxWdCtAxpGxPR4w11g5
	RQXXpU6EfzbLJ1aa/bsZ0RsJu6KzY2Xh+a/EQ2+IL2G/vsSXOsUl+3oqMPGEwgjIVD1v
	C1MPrSiw7PBwgYnRy6kv7rlYnnPSFtyjXRGpQ/VVGJvqaGutfgfpcZKl1PycFMMBr7B3
	LuYAeN7mYGlRNTl31HVTyOVOgbC80V9WV91KXG5dQDVOx/J3SblJcYG0aJMrljUz8Fiq
	c2EA==
X-Gm-Message-State: AOAM533Ovs9jaoIQmKPABTQZwF+DxCsB+1jBGdxmumDPT/xFjlVG9pa7
	0Ms0jXKervSI7oS0M8f90w==
X-Google-Smtp-Source: ABdhPJzkCNasljZnqAamglCYpqR/2F6MfcxM6FpuTDoMD5Hcd013QSDHbSENC0s2oAHwCUZFYaGdSw==
X-Received: by 2002:a5d:650f:: with SMTP id x15mr40497912wru.332.1608157063280;
	Wed, 16 Dec 2020 14:17:43 -0800 (PST)
Received: from localhost (10.red-176-87-2.dynamicip.rima-tde.net.
	[176.87.2.10])
	by smtp.gmail.com with ESMTPSA id h3sm5005842wmm.4.2020.12.16.14.17.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Dec 2020 14:17:42 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 16 Dec 2020 23:17:39 +0100
Message-Id: <20201216221740.10170-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH resend] multipath-tools: add Vexata(by
	StorCentric) VX arrays
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

https://support.sas.com/resources/papers/performance-tuning-sas-vexata-systems.pdf

Reviewed-by: Martin Wilck <mwilck@suse.com>
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

