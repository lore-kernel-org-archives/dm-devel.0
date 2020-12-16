Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4A9C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8058121D93
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8058121D93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-bBm-YAxaMtOPpo2Rz_JP7Q-1; Mon, 04 Jan 2021 14:03:21 -0500
X-MC-Unique: bBm-YAxaMtOPpo2Rz_JP7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA8D0107ACE4;
	Mon,  4 Jan 2021 19:03:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44586272AB;
	Mon,  4 Jan 2021 19:03:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E0DC9180954D;
	Mon,  4 Jan 2021 19:03:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGDL64S011759 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 08:21:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC77CB07B1; Wed, 16 Dec 2020 13:21:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6148ADF98
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 13:21:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60E37800183
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 13:21:02 +0000 (UTC)
Received: from leibniz.telenet-ops.be (leibniz.telenet-ops.be
	[195.130.137.77]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-227-JXKCvGGENnuYtoKDQDY8LA-1; Wed, 16 Dec 2020 08:21:00 -0500
X-MC-Unique: JXKCvGGENnuYtoKDQDY8LA-1
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be
	[IPv6:2a02:1800:120:4::f00:14])
	by leibniz.telenet-ops.be (Postfix) with ESMTPS id 4Cwwc15HTrzMqhgQ
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 14:15:45 +0100 (CET)
Received: from ramsan.of.borg ([84.195.186.194])
	by xavier.telenet-ops.be with bizsmtp
	id 51Fk240074C55Sk011Fk5z; Wed, 16 Dec 2020 14:15:44 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtps (TLS1.3) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.93)
	(envelope-from <geert@linux-m68k.org>)
	id 1kpWee-00BAb1-40; Wed, 16 Dec 2020 14:15:44 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
	(envelope-from <geert@linux-m68k.org>)
	id 1kpWed-005XXy-F0; Wed, 16 Dec 2020 14:15:43 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Jiri Kosina <trivial@kernel.org>
Date: Wed, 16 Dec 2020 14:15:42 +0100
Message-Id: <20201216131542.1320550-1-geert+renesas@glider.be>
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGDL64S011759
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:11 -0500
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [dm-devel] [PATCH trivial] dm crypt: Spelling s/cihper/cipher/
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix a misspelling of "cipher".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 392337f16ecfd87f..3e6a06c93865e311 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -133,7 +133,7 @@ enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
 	     DM_CRYPT_WRITE_INLINE };
 
 enum cipher_flags {
-	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
+	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
 };
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

