Return-Path: <SRS0=pCrV=OO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF15C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 24 Sep 2021 22:27:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 58CAA61250
	for <dm-devel@archiver.kernel.org>; Fri, 24 Sep 2021 22:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58CAA61250
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-mjeRSbilOvyh8EChlmRwKQ-1; Fri, 24 Sep 2021 18:27:53 -0400
X-MC-Unique: mjeRSbilOvyh8EChlmRwKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D981C1084683;
	Fri, 24 Sep 2021 22:27:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4C985D6CF;
	Fri, 24 Sep 2021 22:27:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CF164EA29;
	Fri, 24 Sep 2021 22:27:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18OMRihN032226 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 24 Sep 2021 18:27:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AEBBE1FA85D; Fri, 24 Sep 2021 22:27:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A96DE1FA85C
	for <dm-devel@redhat.com>; Fri, 24 Sep 2021 22:27:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62DC106655A
	for <dm-devel@redhat.com>; Fri, 24 Sep 2021 22:27:41 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
	[209.85.221.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-187-aEFsoHdUN4eA81_dM88UYw-1; Fri, 24 Sep 2021 18:27:40 -0400
X-MC-Unique: aEFsoHdUN4eA81_dM88UYw-1
Received: by mail-wr1-f54.google.com with SMTP id r23so6298588wra.6;
	Fri, 24 Sep 2021 15:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=y3yCP7sm2xesMQ9NAwXD/7f/5NIX4BKCPaOmHhBqmtI=;
	b=Dof4xYp0YPu7pcgSpVItWx3izplunMDz7SQjP5R89ldP1htH/856HNAXO7zmCipexD
	nngvDUDtat86quIfxILo/Ej1UhuMtwoFnUS+FnsKZ1Ib82/LvKCd/UqqHB59xzEQHJoZ
	g6m8M0H42Ttvq4vmD5wud1l9hFZtf5JkeBO8pm0BSSS20Ygx+bpqh0CBrxN7v+J94gaS
	LkMDMQqz1t9hThgOjnUZobEyZ30Pm6PCLGEuTvP/Ui+i7O7/lP83UaoiNqCc788cdykH
	czfAO6FfNF80cwgzEcFK9bnZaqrHdUTWHac9TKY7p6l2a0XSeotOGdPlYpjpiUGQxjrb
	j/Ow==
X-Gm-Message-State: AOAM5339CEVltpwCed3YQQYf5fop/c1AnuJaWrRF0D74EUs+XtSCP2D7
	lq75rKcJrTwZ6FOOhYy6LeJZOZLEZQ==
X-Google-Smtp-Source: ABdhPJzxamfqr/jUHhsRosEX06+nNWwX7qrhaSvpxmcSL11BbLH1MQTbGn4V6y6T+HR7mBLq3XJgWQ==
X-Received: by 2002:a5d:6846:: with SMTP id o6mr14388642wrw.327.1632522458576; 
	Fri, 24 Sep 2021 15:27:38 -0700 (PDT)
Received: from localhost (7.red-79-159-142.dynamicip.rima-tde.net.
	[79.159.142.7]) by smtp.gmail.com with ESMTPSA id
	a202sm14009408wmd.15.2021.09.24.15.27.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 24 Sep 2021 15:27:38 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 25 Sep 2021 00:27:36 +0200
Message-Id: <20210924222736.22853-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: make IBM/XIV config work with
	alua and multibus
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

And add recommended pgfailback value.

ALUA is supported since XIV_Gen2 and microcode 10.2.1
(All ports across all controllers in single Target Port Group)

https://www.ibm.com/support/pages/ibm-flashsystem%C2%AE-a9000-and-a9000r-hyperswap-solution-deployment-linux%C2%AE-ibm-z-systems%C2%AE
https://www.google.com/search?q=%222810XIV%22+%22path_grouping_policy%22+site%3Aibm.com

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0caac0da..72f81c60 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -712,7 +712,8 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(XIV|IBM)",
 		.product       = "(NEXTRA|2810XIV)",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = 15,
 	},
 	{
 		/* TMS RamSan / FlashSystem 710/720/810/820/840/900 */
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

