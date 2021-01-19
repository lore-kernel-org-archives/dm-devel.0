Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB18BC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 20:40:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4798E23107
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 20:40:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4798E23107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-B8asVnsgMh-S-vE08MFv0g-1; Tue, 19 Jan 2021 15:40:53 -0500
X-MC-Unique: B8asVnsgMh-S-vE08MFv0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44C9D800D53;
	Tue, 19 Jan 2021 20:40:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B600D5D760;
	Tue, 19 Jan 2021 20:40:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B4E3180954D;
	Tue, 19 Jan 2021 20:40:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10JKeea0028665 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 15:40:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DE816A9F37; Tue, 19 Jan 2021 20:40:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D98BCA9FA1
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 20:40:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 959AC8001B8
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 20:40:35 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
	[209.85.128.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-571-9bjiR1F5Nl2T0Zj_v-nGCg-1; Tue, 19 Jan 2021 15:40:33 -0500
X-MC-Unique: 9bjiR1F5Nl2T0Zj_v-nGCg-1
Received: by mail-wm1-f44.google.com with SMTP id u14so928748wmq.4
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 12:40:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=Hqz5KkIUWAsMMr4Nkw2DHVorD8Rmr14UkHNWJhlYZr4=;
	b=YC+ewY2EnPBauG0Dtrz2CJDhTV9ixSB5hkRDFflj5XEvg9VLjtMv+ED+VIfrznw3dw
	7kZqh7UNHsuWpv7UqSXsFcZTzskHyEkhthcAD3MI/dWRjS/dIU3q3iBJbOBPy7sAPsXe
	Hunh6g6GE/sxSguZu5R7OkBKjdSdYsRCdvO6z2o4ehXzgxZsScBp50sAC6vsVaW9QMDl
	yILbF3cTujfCgvyb6FP401wtZkoCvYvZpHJuBtqhqJicvlKpcxtJ5I39SWeLnWo/3hnc
	H/qPROdw1nwi9upuVd2g1qTEM+2f67duYzn8Wbdwexauwt7nqF/LuTloERFBlJPZ0OBa
	RTSQ==
X-Gm-Message-State: AOAM53183/SUTOqA7l0FqTXf/pkreIX++OUNq1IuSh5rU0QaEvbymFfQ
	lIdBelo+/lf+YhGsZGMbIq85vw==
X-Google-Smtp-Source: ABdhPJxhg7dmzxe2FdXAxsUXYiD0FnIa6AXlhUScb/esR/2HsvsfX6Iamf+TH80zY5689pHsjLT1lQ==
X-Received: by 2002:a7b:cbd5:: with SMTP id n21mr1280568wmi.5.1611088832105;
	Tue, 19 Jan 2021 12:40:32 -0800 (PST)
Received: from localhost.localdomain (29.177.200.146.dyn.plus.net.
	[146.200.177.29]) by smtp.gmail.com with ESMTPSA id
	x128sm6642847wmb.29.2021.01.19.12.40.31
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 19 Jan 2021 12:40:31 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org
Date: Tue, 19 Jan 2021 20:40:15 +0000
Message-Id: <20210119204015.49516-1-ignat@cloudflare.com>
MIME-Version: 1.0
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
Cc: pavel@denx.de, kernel-team@cloudflare.com, stable@vger.kernel.org,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH] dm crypt: fix invalid copy paste in
	crypt_alloc_req_aead
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In commit d68b295 ("dm crypt: use GFP_ATOMIC when allocating crypto requests
from softirq") I wrongly copy pasted crypto request allocation code from
crypt_alloc_req_skcipher to crypt_alloc_req_aead. It is OK from runtime
perspective as both simple encryption request pointer and AEAD request pointer
are part of a union, but may confuse code reviewers.

Fixes: d68b295 ("dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c874710f0bc..5a55617a08e6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1481,9 +1481,9 @@ static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 static int crypt_alloc_req_aead(struct crypt_config *cc,
 				 struct convert_context *ctx)
 {
-	if (!ctx->r.req) {
-		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
-		if (!ctx->r.req)
+	if (!ctx->r.req_aead) {
+		ctx->r.req_aead = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		if (!ctx->r.req_aead)
 			return -ENOMEM;
 	}
 
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

