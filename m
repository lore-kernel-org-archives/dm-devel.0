Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9E4C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 20:22:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1962464E6B
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 20:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1962464E6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-oMcy9V-sNR2goEtI_RtAXw-1; Tue, 23 Feb 2021 15:22:28 -0500
X-MC-Unique: oMcy9V-sNR2goEtI_RtAXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14FC4804036;
	Tue, 23 Feb 2021 20:22:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A84610016DB;
	Tue, 23 Feb 2021 20:22:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4AE5118095CB;
	Tue, 23 Feb 2021 20:22:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NKMIPq029842 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 15:22:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ACEEF202E940; Tue, 23 Feb 2021 20:22:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7AED2026D48
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 20:22:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E31628CBAB7
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 20:22:15 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
	[209.85.128.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-470-JWSe2iSyNMeMBQ9lSk-qVA-1; Tue, 23 Feb 2021 15:22:11 -0500
X-MC-Unique: JWSe2iSyNMeMBQ9lSk-qVA-1
Received: by mail-wm1-f47.google.com with SMTP id x16so3646278wmk.3;
	Tue, 23 Feb 2021 12:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=BkPOxcgjrqWtZmRCdmfyLFJG8McoAwV+9oi6TjuwMnk=;
	b=HGEp9+dpzyn3pfD3irZjhDkh7HxtrKCFKd0B/S7M1X0Oh5aQwB1HI3bv2uqFRcd5mt
	HoXuQVe9L4R2y9+QfStbmQUgxYWJtDDP71yaY6dg9oktSnFPpkkCOhE5/AInJeKrHnQe
	FwLzrt25tURFhouqGaY+XkVQJcrp6CtRuxyqWuZ76enszIb2NfljLkd2CfW3c/jwImCD
	JC+2BPZmKW/uOpRJ+R8Zzwsx8X0Yl4Vcs0ADslmDm7dsusxd4oYKyCOgTBX6uYA+Lvh2
	A8Sd8dHFlTKk87fjiQ2YvRgiy+u/ZT9vodQES6dgZQcijfqOaKYQ8ci5RZEh9ObO+WA+
	oqtQ==
X-Gm-Message-State: AOAM532t1qDvVNhDF5k1MTj+M2l+EY1GjgtLpaj2AEz3XH4X/a2U4wIi
	HOERWfrpL9mddIe0sd1l//NPIfyKx7A=
X-Google-Smtp-Source: ABdhPJw1gZf5OWCT9QjMn2XBExF7dqGlffcNklaIuAYRmwYLCtHi8+TmvmO7NtM2yVt/Y0W6TGl47g==
X-Received: by 2002:a05:600c:4f86:: with SMTP id
	n6mr479726wmq.22.1614111729857; 
	Tue, 23 Feb 2021 12:22:09 -0800 (PST)
Received: from merlot.mazyland.net (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.googlemail.com with ESMTPSA id
	w4sm3718072wmc.13.2021.02.23.12.22.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 23 Feb 2021 12:22:09 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@redhat.com
Date: Tue, 23 Feb 2021 21:21:20 +0100
Message-Id: <20210223202121.898736-1-gmazyland@gmail.com>
In-Reply-To: <20210222211528.848441-1-gmazyland@gmail.com>
References: <20210222211528.848441-1-gmazyland@gmail.com>
MIME-Version: 1.0
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
Cc: mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>,
	stable@vger.kernel.org
Subject: [dm-devel] [PATCH 1/2] dm-bufio: subtract the number of initial
	sectors in dm_bufio_get_device_size
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

From: Mikulas Patocka <mpatocka@redhat.com>

dm_bufio_get_device_size returns returns the device size in blocks. Before
returning the value, we must subtract the nubmer of starting sectors. The
number of starting sectos may not be divisible by block size.

Note that currently, no target is using dm_bufio_set_sector_offset and
dm_bufio_get_device_size simultaneously, so this patch has no effect.
However, an upcoming patch that fixes dm-verity-fec needs this change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Milan Broz <gmazyland@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-bufio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index fce4cbf9529d..50f3e673729c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1526,6 +1526,10 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_size);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
 	sector_t s = i_size_read(c->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (s >= c->start)
+		s -= c->start;
+	else
+		s = 0;
 	if (likely(c->sectors_per_block_bits >= 0))
 		s >>= c->sectors_per_block_bits;
 	else
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

