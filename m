Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297E2C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jan 2022 06:25:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-oYgcs5k2OIat1iXRLXWbuQ-1; Mon, 24 Jan 2022 01:25:55 -0500
X-MC-Unique: oYgcs5k2OIat1iXRLXWbuQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49F0E83DD22;
	Mon, 24 Jan 2022 06:25:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABE4155F78;
	Mon, 24 Jan 2022 06:25:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E420B4CA93;
	Mon, 24 Jan 2022 06:25:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20NMljU9005797 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 Jan 2022 17:47:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7B0C540C1247; Sun, 23 Jan 2022 22:47:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76BD340C1242
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 22:47:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AA6C3C0219A
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 22:47:45 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
	[209.85.221.48]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-645-wlBSoVCDMMmnBcW1PpaTFw-1; Sun, 23 Jan 2022 17:47:43 -0500
X-MC-Unique: wlBSoVCDMMmnBcW1PpaTFw-1
Received: by mail-wr1-f48.google.com with SMTP id e8so8532913wrc.0;
	Sun, 23 Jan 2022 14:47:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=/5S9xyESZcclPaDw6CXf6+0+vxSG5iw7208cSFoi+Ek=;
	b=hAa6w1CcizoRrW2Ngm9rRMqJ0XfpVTESZ6q0Rp6x84sSyb+L0LcnJOXR/QeuONbSCs
	koOIQbfp173FB9IjwITraxjrj/w1HFLWVGQ0Q1bNJHT6A0xoVA4RFCdvv52Qq7OMn5QE
	m5DxPaf/mFekYVjRBR4VPushp7BOkbBhWSEETRxHIL30SzImhgDhyU0Bl9l8iuOaKO9k
	E7S7tZ1E637Z/V09EIM1nbSIih/Im96gJRmR+ABoXZnZgkyeHHXEn6VaxflkTTNWVTIy
	r4seBB2SNvGlDUy51XVDVdTjDH6r+lMZmds9iP0aw89R8BiFBanTkKFVI9M1LmApkVFf
	A0ww==
X-Gm-Message-State: AOAM533U6CT+9cX8xtbRmp06eEO3Wyfe/zvOC8FqeB5Ay6uhJaAnFUSi
	HM3RLtjXgoDQbDb/AwrCTsCOm9b5MEbs3w==
X-Google-Smtp-Source: ABdhPJwgQfGhLKl/aE6FaexUpoUSwbCHdwzqIBIatkY66lzhhjF6X11hlksM/fh8scWrKDOqpbeshw==
X-Received: by 2002:a05:6000:1884:: with SMTP id
	a4mr12195041wri.316.1642978061708; 
	Sun, 23 Jan 2022 14:47:41 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net.
	[80.193.200.194]) by smtp.gmail.com with ESMTPSA id
	p14sm1643086wmq.40.2022.01.23.14.47.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 23 Jan 2022 14:47:41 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com
Date: Sun, 23 Jan 2022 22:47:40 +0000
Message-Id: <20220123224740.6875-1-colin.i.king@gmail.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Mon, 24 Jan 2022 01:25:45 -0500
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm: make static read-only array table const
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

The static array table as read-only so it make sense to make
it const. Add in the int type to clean up checkpatch warning.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/md/dm-cache-policy-smq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index b61aac00ff40..19eac5d980a8 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1026,7 +1026,9 @@ static unsigned default_promote_level(struct smq_policy *mq)
 	 * This scheme reminds me of a graph of entropy vs probability of a
 	 * binary variable.
 	 */
-	static unsigned table[] = {1, 1, 1, 2, 4, 6, 7, 8, 7, 6, 4, 4, 3, 3, 2, 2, 1};
+	static const unsigned int table[] = {
+		1, 1, 1, 2, 4, 6, 7, 8, 7, 6, 4, 4, 3, 3, 2, 2, 1
+	};
 
 	unsigned hits = mq->cache_stats.hits;
 	unsigned misses = mq->cache_stats.misses;
-- 
2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

