Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3403FC64E7B
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 16:07:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 67CB52222A
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 16:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeYfOY1y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67CB52222A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606838855;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=euJZQsT0Pd6Y3UtNEpvxArXJHilNKDG89W6+Zyv5xGs=;
	b=KeYfOY1y9Q5iRC7+GKjS6jRmLP++D5rXO9ACjCl7mpmAXFNPa7qIaRltRknX8gli1B33nn
	msJFIaGcE/6ucsF/T7QOGaP901Qh96OdCXwxt5FucYmXL5loQgeaRAa7vA3m0xV/VbhY8r
	0M/Fq23f9bt5Xu4wBy+myHgY+h5Jz/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-mW7aYZKdMNCO0yFhWo6y6w-1; Tue, 01 Dec 2020 11:07:33 -0500
X-MC-Unique: mW7aYZKdMNCO0yFhWo6y6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A461B3E756;
	Tue,  1 Dec 2020 16:07:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C93FC19C71;
	Tue,  1 Dec 2020 16:07:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 196731809C9F;
	Tue,  1 Dec 2020 16:07:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1G7LMH026868 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 11:07:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E17872026D16; Tue,  1 Dec 2020 16:07:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA99B2026D12
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 16:07:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 790D680120A
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 16:07:18 +0000 (UTC)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
	[209.85.219.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-491-N-sqjN9mNTm9cpOnW87QRA-1; Tue, 01 Dec 2020 11:07:12 -0500
X-MC-Unique: N-sqjN9mNTm9cpOnW87QRA-1
Received: by mail-qv1-f65.google.com with SMTP id 62so1031960qva.11;
	Tue, 01 Dec 2020 08:07:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
	:in-reply-to:references;
	bh=HDs+wOaN7N1oAjDOJXdaryAzxarmO9q6Cf3R5Ld01fE=;
	b=YfLQGmz2vGrRNSMJ+lDHxVvBgYaOSQst3uZraoX7RM8f7xP2FvJc6WIJLlhHXcUNL6
	0GzGIx5JkUmYErnEgzvCWb9eGMwVI8JMy+65Nu7KaQ3nXUkSngj5oUB9Ve9YGESXHdC7
	m3QVMOyr5WiOEtamk3Dcxr7benF8PHi0kGcOBO/i6sH9C+3I/ZT8NM/EI06eIwCGp/xc
	1yXGTsWZYgtXO+c5Yiob2P3vhguGDsridvA/QpSgu5kzu5DU21wZOjFjzWwDVhIvJely
	Aza9RdEhl5LVRFbQTYXSdJOmZZq9uXfT4uAmhZJHOC3d5MQHHhUhbbE2myYn5n6tlAxR
	ck6g==
X-Gm-Message-State: AOAM532pUTNSUG2VsKVTQVPA2d1Ge+fTXCOsy2RZOuqOqyj7N8F9xNS5
	uJdFAQgEM59E3xmx5OktbwE=
X-Google-Smtp-Source: ABdhPJwhC2uejtnz+5vT2sYN3igQEt6dMIe1e7vEZH7+ShhdQHDFCQvBWTHFB8LX9qWcDXHrU7i12w==
X-Received: by 2002:ad4:5441:: with SMTP id h1mr3605049qvt.4.1606838831033;
	Tue, 01 Dec 2020 08:07:11 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	y3sm2061476qkl.110.2020.12.01.08.07.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 01 Dec 2020 08:07:10 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Tue,  1 Dec 2020 11:07:09 -0500
Message-Id: <20201201160709.31748-1-snitzer@redhat.com>
In-Reply-To: <20201130171805.77712-1-snitzer@redhat.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, bjohnsto@redhat.com,
	jdorminy@redhat.com, martin.petersen@oracle.com
Subject: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors limit
	stacking
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

commit 22ada802ede8 ("block: use lcm_not_zero() when stacking
chunk_sectors") broke chunk_sectors limit stacking. chunk_sectors must
reflect the most limited of all devices in the IO stack.

Otherwise malformed IO may result. E.g.: prior to this fix,
->chunk_sectors = lcm_not_zero(8, 128) would result in
blk_max_size_offset() splitting IO at 128 sectors rather than the
required more restrictive 8 sectors.

And since commit 07d098e6bbad ("block: allow 'chunk_sectors' to be
non-power-of-2") care must be taken to properly stack chunk_sectors to
be compatible with the possibility that a non-power-of-2 chunk_sectors
may be stacked. This is why gcd() is used instead of reverting back
to using min_not_zero().

Fixes: 22ada802ede8 ("block: use lcm_not_zero() when stacking chunk_sectors")
Fixes: 07d098e6bbad ("block: allow 'chunk_sectors' to be non-power-of-2")
Cc: stable@vger.kernel.org
Reported-by: John Dorminy <jdorminy@redhat.com>
Reported-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-settings.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

v2: use gcd(), instead of min_not_zero(), as suggested by John Dorminy

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9741d1d83e98..659cdb8a07fe 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -547,7 +547,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
-	t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
+
+	/* Set non-power-of-2 compatible chunk_sectors boundary */
+	if (b->chunk_sectors)
+		t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

