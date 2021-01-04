Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6599C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 15:00:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DA1622286
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 15:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DA1622286
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-wkQoOKhGM2-Mslsi4MiZxQ-1; Mon, 04 Jan 2021 10:00:23 -0500
X-MC-Unique: wkQoOKhGM2-Mslsi4MiZxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38B04804002;
	Mon,  4 Jan 2021 15:00:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F0E85D9DD;
	Mon,  4 Jan 2021 15:00:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27DED4E58E;
	Mon,  4 Jan 2021 15:00:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104F0Ab7029945 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 10:00:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AE1A67B47; Mon,  4 Jan 2021 15:00:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8BC87ADB
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 15:00:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 592E3805B3B
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 15:00:08 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-6RHDrclVOhSlXzUHNEL6Ig-1; Mon, 04 Jan 2021 10:00:06 -0500
X-MC-Unique: 6RHDrclVOhSlXzUHNEL6Ig-1
Received: by mail-wm1-f41.google.com with SMTP id q75so19620107wme.2
	for <dm-devel@redhat.com>; Mon, 04 Jan 2021 07:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=zX8HfL31wQZp5jl2djKi9uuAu6EFw+BifBJL8TfPFYI=;
	b=pK4mkYl8aCZzCH2Ap/B++RAgVOfpcs5CmnVwujiOq60mZTJdMAF1K5hoWGJC6rmPjA
	TUS6Jem0zi1ZoH5U5YhYCA0GM4EAeYtmUHYYWbOlVUPq3qVRIx/6WykMoKyZqZGoy8gM
	0Wk+GClVMkgplV9RiUnWQWxBA/4jvmuPCvwxVRJDFGNsd6wOjb4Ov9xwu/ZdAXQatlCE
	Gr/rNdGfEr5o+CJH/T3A9ZEpNt0rM81g4I0nvAKtanCOYjjrOWZ2wbXM7SpTgNXb1cmG
	TRiEKEQ3QOb38Y1k8OIEcbvUDUQj5WI6+7voHmWEG3r+X69+ZS4AdVEwPCd8K4MqFlQk
	G+DQ==
X-Gm-Message-State: AOAM532i0f6O1hKoeJSSBtZ/rOhwW+2jZlHbB/FqS+p4eUpU7W+RqBTu
	ACMPPF14hMlYLb+ftkSxAFdZ7w==
X-Google-Smtp-Source: ABdhPJyZ7mnenRW8F7aJHWIfVzmZOehv2AMU4Up9FryPAzuecSePdIqVbZnPsKBWirVBfeRygVofGw==
X-Received: by 2002:a1c:9949:: with SMTP id b70mr26716903wme.72.1609772404590; 
	Mon, 04 Jan 2021 07:00:04 -0800 (PST)
Received: from dev.cfops.net (165.176.200.146.dyn.plus.net. [146.200.176.165])
	by smtp.gmail.com with ESMTPSA id
	r1sm94445954wrl.95.2021.01.04.07.00.03
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 04 Jan 2021 07:00:03 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org
Date: Mon,  4 Jan 2021 14:59:46 +0000
Message-Id: <20210104145948.1857-1-ignat@cloudflare.com>
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
Cc: Damien.LeMoal@wdc.com, herbert@gondor.apana.org.au,
	kernel-team@cloudflare.com, nobuto.murata@canonical.com,
	josef@toxicpanda.com, ebiggers@kernel.org, clm@fb.com,
	mpatocka@redhat.com, Ignat Korchagin <ignat@cloudflare.com>,
	dsterba@suse.com, mail@maciej.szmigiero.name, linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH v3 0/2] dm crypt: some fixes to support dm-crypt
	running in softirq context
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Changes from v1:
  * 0001: handle memory allocation failure for GFP_ATOMIC

Changes from v2:
  * reordered patches
  * 0002: crypt_convert will be retried from a workqueue, when a crypto request
    allocation fails with GFP_ATOMIC instead of just returning an IO error to
    the user

Ignat Korchagin (2):
  dm crypt: do not wait for backlogged crypto request completion in
    softirq
  dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq

 drivers/md/dm-crypt.c | 138 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 123 insertions(+), 15 deletions(-)

-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

