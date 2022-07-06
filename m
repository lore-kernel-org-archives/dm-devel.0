Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A67C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657129455;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZEuQQR1noF+JcvGonlpcqiTc3kSjhjTMecqPllOneoo=;
	b=GiXweSXEalx8sOU5STH/aO0K/8QJEGrADkU5u+4EpnmQCEOetzJs9f7BT+fDcZxBPefMa0
	WEFSONRXWHtnPLbI50QUSD41OBH9yllL6iD0X6oMiZBuzM8fv2PO1vbOnmuTZHStyHQaFe
	+3CuK/AKQCzCZFTL8bjxSoY1GqgtM6g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-lwuHTcE6M---utvIEBdRkQ-1; Wed, 06 Jul 2022 13:44:14 -0400
X-MC-Unique: lwuHTcE6M---utvIEBdRkQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 133B4823F0B;
	Wed,  6 Jul 2022 17:44:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2444D492C3B;
	Wed,  6 Jul 2022 17:44:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D736F1947065;
	Wed,  6 Jul 2022 17:44:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7256A1947065
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 17:44:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63C102166B2B; Wed,  6 Jul 2022 17:44:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F9BB2166B29
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 17:44:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44E7A380114C
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 17:44:07 +0000 (UTC)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com
 [209.85.222.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-vpnW_9eJPaW8TOHBq2MCJA-1; Wed, 06 Jul 2022 13:44:05 -0400
X-MC-Unique: vpnW_9eJPaW8TOHBq2MCJA-1
Received: by mail-qk1-f180.google.com with SMTP id z7so11576486qko.8
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 10:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=CGOgkgQZQXAdQrhuO5tahsN/l1uZl0yMW/oNjzAib68=;
 b=wFKSVrDCeHelEorltEoyJCM3vyh3Pma5MQCFPlu44FP39wWeZ+XPVx7qyL+CcbdcLu
 Hx8W9vCuLxszipF4fVP1Vv4FTG3oB5tVLbt+xvb7bsFqr3H/EsJ+ru75PXLgl5GQXgco
 5DQtI0vCeNRGZGwH9RsQ6q+WLHS9/JOCIqTLRCgLN65lalN3nSRBIY+MG73+a/t5Mq/g
 F3xeAMTBaIyghZtXrWyXh7fBrNwsAVFKqlaXIa6NkM6bp1ZKFHgrvJfnOfaO3+MhhtwF
 5bd4qS/hSS7AlWFKpPRJbNQXNEOHgMz6elWgKG9IiV5+qgfIDdieNtVwwLS8hunb/vXV
 9L7g==
X-Gm-Message-State: AJIora9rMbuSk56ZRt3gP00Bvd0ihmpru2IR0lXsIe7YNmv71BtqfCK7
 oMSFsBeg2vdCY6OATC5+ayy2kteMYMhresL8lbIZtpFkiO+eaPqBx8GxJmMnKiUYzgyc74mWMMz
 sS/lmgSvCMjxJa3hYix9ygLZoU5az3iPNGzYS20dCak/KXUiHE7fwaQLxUESaG8weBrU=
X-Google-Smtp-Source: AGRyM1tUhODwWG5/sstKbjAnzaQnX7VL7/kOTwaRgoTY3Ftmym2Mbm9mh6r/EU4qNea1cCa4IXC0+w==
X-Received: by 2002:a05:620a:e06:b0:6a7:316a:33f1 with SMTP id
 y6-20020a05620a0e0600b006a7316a33f1mr28433306qkm.52.1657129444704; 
 Wed, 06 Jul 2022 10:44:04 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u12-20020a05620a454c00b006afd667535asm20912043qkp.83.2022.07.06.10.44.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 10:44:04 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed,  6 Jul 2022 13:44:01 -0400
Message-Id: <20220706174403.79317-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [5.20 PATCH v3 0/2] dm: improve bio splitting at expense
 of requeue complexity
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This v3 moves all bio_rewind() code to drivers/md/dm-io-rewind.c for
exclussive use by DM core's dm_io requeue support via dm_io_rewind().

It was determined that block core doesn't need to expose bio_rewind()
for more general use. If/when that changes we can revisit, armed with
the understanding of how DM's use of bio_rewind() has faired.

These changes are now staged for 5.20 inclussion via linux-dm.git

Ming Lei (2):
  dm: add bio_rewind() API to DM core
  dm: add two stage requeue mechanism

 drivers/md/Makefile       |   2 +-
 drivers/md/dm-core.h      |  13 +++-
 drivers/md/dm-io-rewind.c | 166 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c           | 121 +++++++++++++++++++++++++--------
 4 files changed, 273 insertions(+), 29 deletions(-)
 create mode 100644 drivers/md/dm-io-rewind.c

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

