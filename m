Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367CBC2D0A3
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 22:14:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7EC0F206CA
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 22:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EC0F206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-RHgMCoEDM52JLyUKjEc5og-1; Thu, 29 Oct 2020 18:14:14 -0400
X-MC-Unique: RHgMCoEDM52JLyUKjEc5og-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA4E1006CB1;
	Thu, 29 Oct 2020 22:14:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C76F5C22D;
	Thu, 29 Oct 2020 22:14:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 23347CF69;
	Thu, 29 Oct 2020 22:14:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09TMDxvT011924 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Oct 2020 18:14:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5E3C2156A3D; Thu, 29 Oct 2020 22:13:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0D652156A49
	for <dm-devel@redhat.com>; Thu, 29 Oct 2020 22:13:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B9FA811E78
	for <dm-devel@redhat.com>; Thu, 29 Oct 2020 22:13:57 +0000 (UTC)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
	[209.85.221.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-577-iOw6GWgWNG-gdYlRH3E-jg-1; Thu, 29 Oct 2020 18:13:52 -0400
X-MC-Unique: iOw6GWgWNG-gdYlRH3E-jg-1
Received: by mail-wr1-f66.google.com with SMTP id b8so4463284wrn.0;
	Thu, 29 Oct 2020 15:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=xruG+14zn7klJ4QU6vU0jFajwdkm2bzLBRTVfHhQva0=;
	b=IZkV2zzV2wBOqKdwwLNkvLP3jLQCqerandRkIvWNlEmaVSIHvkRhVsq7nFt7brL0Pu
	owg76sBhwJnkHoPm+xgtAxq22COZiXYuD9gqWNkJ45emh2bm/AiRD0Kb/lIacb3LoULR
	9o92ina1h3bBu7XVVTtYaiiO3sZ06mFtO0KZSYVepDhuyyqgHhyKgeuGcRThYtpzV2t/
	ZjB0PKh5ySVo3X/k6i8+SHEQcjBjl1W382JZ8sBzl33PnYDzql05yX6BEfpGkIBMJxfO
	WXajC+Z3JXwrGsXXuUwrUUyR36vVFlBgTYFqAaLtD1Tt9VF8GWO2IbURlvvJZvsRYNp7
	pfQw==
X-Gm-Message-State: AOAM5317psP9Q++1bxD93AeyrmPBTyZ8LMd2wR54ezh67SSnVzG3P+ar
	jPse4l8ta6GEEJMHh7RKCQ==
X-Google-Smtp-Source: ABdhPJwdZyITp2Z6V/NSv/Yp35susbMd6R1MhFc5Ulzz2hGF4F8ZR30Ec7T8u/DQKpLkYhLW+Kq5+Q==
X-Received: by 2002:a5d:420b:: with SMTP id n11mr8241698wrq.218.1604009630739; 
	Thu, 29 Oct 2020 15:13:50 -0700 (PDT)
Received: from localhost (131.red-176-87-1.dynamicip.rima-tde.net.
	[176.87.1.131])
	by smtp.gmail.com with ESMTPSA id x1sm7406480wrl.41.2020.10.29.15.13.49
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Oct 2020 15:13:50 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 29 Oct 2020 23:13:47 +0100
Message-Id: <20201029221347.5266-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: Violin and Nexsan were bought
	by StorCentric
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 59bc0d6e..475489c2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1113,8 +1113,9 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	/*
-	 * Imation/Nexsan
+	 * StorCentric
 	 */
+		/* Nexsan */
 	{
 		/* E-Series */
 		.vendor        = "NEXSAN",
@@ -1143,9 +1144,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
-	/*
-	 * Violin Systems
-	 */
+		/* Violin Systems */
 	{
 		/* 3000 / 6000 Series */
 		.vendor        = "VIOLIN",
-- 
2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

