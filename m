Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F69C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 17:21:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFD4361352
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 17:21:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFD4361352
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-n5EZ7_mMMtq-JP1YW4IZIw-1; Tue, 28 Sep 2021 13:21:24 -0400
X-MC-Unique: n5EZ7_mMMtq-JP1YW4IZIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4DC1801B3D;
	Tue, 28 Sep 2021 17:21:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 256C64ED99;
	Tue, 28 Sep 2021 17:21:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E79361800B9E;
	Tue, 28 Sep 2021 17:21:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18SHLFal025976 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 13:21:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E126B21415A7; Tue, 28 Sep 2021 17:21:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D994021417FB
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 17:21:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0E9818A6532
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 17:21:05 +0000 (UTC)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
	[209.85.221.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-286-zhxt4uJHOO-MAB49QoEk5Q-1; Tue, 28 Sep 2021 13:21:03 -0400
X-MC-Unique: zhxt4uJHOO-MAB49QoEk5Q-1
Received: by mail-wr1-f53.google.com with SMTP id w29so59205174wra.8;
	Tue, 28 Sep 2021 10:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=2X0Bc/7cAO9TowfVqpaMHlpS2E19W+xeRgV+wtg7Kc0=;
	b=dG7UW9Jwvs89USormZoYDaj/qVzpC3tsB08doOwlbhDKmr+aJ6bOKuJ2dVXtOFEUyo
	truK+SYFkhvWlr7GvHytZz6R0YGNoXx/kXVN4msb5XFmeDDRxrGIRGjkW7GKBDjBT1eZ
	2isSWxokQ0mXPjbTdB10Y9NdmIJ4IoVXjleZ2qi6hPPWGYlAQfCBZxFXjUCKMn26m1ra
	LsAv+APJGw925ySC01JKBC8joLru3NRchceAR/e5zwplny5DWmWswpLSIezzOdHPylbS
	4L3p593TMhsRiYWbiUrmZsC7ECqRMWW+71XgZhRyG6eTLbiVAervpu9lo7WMsILR46N1
	47tg==
X-Gm-Message-State: AOAM530+BIuKcfa4HTeDgySVIQcqNzPAIHz64/agHM6kP5k6m341kqr/
	aSgWAS248FPnhG65nHWefnMVd3qyzg==
X-Google-Smtp-Source: ABdhPJzDTN9NC91c6B/k6nMlLlozoAMLM6N5koNtyZYd/03fjF6A8Vn2SR1NxFUbwewvG2Bo8KbU2w==
X-Received: by 2002:adf:cc82:: with SMTP id p2mr1540508wrj.5.1632849662324;
	Tue, 28 Sep 2021 10:21:02 -0700 (PDT)
Received: from localhost ([90.160.137.52]) by smtp.gmail.com with ESMTPSA id
	o13sm26055077wri.53.2021.09.28.10.21.01
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 28 Sep 2021 10:21:01 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Tue, 28 Sep 2021 19:20:59 +0200
Message-Id: <20210928172059.16830-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: make EMC/SYMMETRIX config work
	with alua and multibus
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

ALUA is supported since VMAX3 and HYPERMAX OS 5977.811.784, pag#113:
https://www.delltechnologies.com/en-us/collaterals/unauth/technical-guides-support-information/products/storage-2/docu5128.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f115c4f9..7095aaf1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -329,8 +329,9 @@ static struct hwentry default_hw[] = {
 		/* Symmetrix / DMX / VMAX / PowerMax */
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.no_path_retry = 6,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
 		/* DGC CLARiiON CX/AX / VNX and Unity */
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

