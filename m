Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C02C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A7AE61215
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A7AE61215
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-Gl8FlMePMpe1dEfaxdgoXA-1; Thu, 11 Nov 2021 03:16:53 -0500
X-MC-Unique: Gl8FlMePMpe1dEfaxdgoXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 767F91019982;
	Thu, 11 Nov 2021 08:16:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38A591037F3A;
	Thu, 11 Nov 2021 08:16:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 149371832DD7;
	Thu, 11 Nov 2021 08:16:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB7v6nZ018558 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 02:57:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D26DE4047279; Thu, 11 Nov 2021 07:57:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE082404727F
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 07:57:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4C9E811E80
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 07:57:06 +0000 (UTC)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
	[209.85.210.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-375-EhJ5l27uPFCvqHrPGwFwhA-1; Thu, 11 Nov 2021 02:57:04 -0500
X-MC-Unique: EhJ5l27uPFCvqHrPGwFwhA-1
Received: by mail-pf1-f182.google.com with SMTP id o4so4911045pfp.13;
	Wed, 10 Nov 2021 23:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=RyhYx0Yjx3c0gD9sFK1NOJQka/tEBMj1zX12qg04JEo=;
	b=zYHYPwsWqwqE3NAKjOU9CXIAXZWjcdjcD5HAdxgLBliVleHE3yDHt0EPXN+TwnYjTu
	cjs9areUImbG7Rxm/5qOwkpdZ4A5fO8L33FZNpwHl2WgkYE9cPnvQvemh4Y9toL4iLk5
	bGotiRvNup4SuRWtPetGFBctvYJejmfdKjmTyWGPsSJZSirCs2rLACUqHcRklA4cooxU
	P7H2QXkjkoY7J1almgHCwVbfiEuOGxb7NP4mU8sra9j2Deh1zD/Uxr/+ThV+hGZGZoMR
	YA09yMFCx76fzf2NRWyBLWHI/oR2MzYiGG9Tn/nGV3inoFakebfvWbQZqTAWzD4P296w
	av/A==
X-Gm-Message-State: AOAM531ROHvTg+p+VXnkCOuLi3foNo2e45AnvzRNi5aknBbzRnesQJEO
	APOpXbKDw0l2R/HEooZpWx45NlmK1LU=
X-Google-Smtp-Source: ABdhPJz5D6/eJ1FPoLwGQME8M/qbVyHCI8LxgpxgV0fzYz9JLNtR/Xf2gwv/4ElW9L0AdRkzWYTBVQ==
X-Received: by 2002:a62:ea16:0:b0:47b:f3d7:7a9 with SMTP id
	t22-20020a62ea16000000b0047bf3d707a9mr5098046pfh.60.1636617423168;
	Wed, 10 Nov 2021 23:57:03 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
	by smtp.gmail.com with ESMTPSA id e24sm1938078pfn.8.2021.11.10.23.57.01
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 10 Nov 2021 23:57:02 -0800 (PST)
From: cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To: agk@redhat.com
Date: Thu, 11 Nov 2021 07:56:59 +0000
Message-Id: <20211111075659.158155-1-ran.jianping@zte.com.cn>
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
X-Mailman-Approved-At: Thu, 11 Nov 2021 03:16:24 -0500
Cc: dm-devel@redhat.com, ran jianping <ran.jianping@zte.com.cn>,
	linux-kernel@vger.kernel.org, snitzer@redhat.com,
	Zeal Robot <zealci@zte.com.cn>
Subject: [dm-devel] [PATCH] dm snapshot: remove unneeded variable
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: ran jianping <ran.jianping@zte.com.cn>

Fix the following coccicheck review:
./drivers/md/dm-snap-transient.c:91:10-12: Unneeded variable

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 drivers/md/dm-snap-transient.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 0e0ae4c36b37..d95b59855da0 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -88,7 +88,6 @@ static unsigned transient_status(struct dm_exception_store *store,
 				 status_type_t status, char *result,
 				 unsigned maxlen)
 {
-	unsigned sz = 0;
 
 	switch (status) {
 	case STATUSTYPE_INFO:
@@ -101,7 +100,7 @@ static unsigned transient_status(struct dm_exception_store *store,
 		break;
 	}
 
-	return sz;
+	return 0;
 }
 
 static struct dm_exception_store_type _transient_type = {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

