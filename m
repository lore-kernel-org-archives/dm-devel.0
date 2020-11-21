Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43A7C2D0E4
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDC4720729
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDC4720729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-_HEIrfzlMLGb-YvDg4u_bQ-1; Mon, 23 Nov 2020 03:40:31 -0500
X-MC-Unique: _HEIrfzlMLGb-YvDg4u_bQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3379835B70;
	Mon, 23 Nov 2020 08:40:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C626C5C1BD;
	Mon, 23 Nov 2020 08:40:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9AD131809CA5;
	Mon, 23 Nov 2020 08:40:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ALMN5ct032391 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 21 Nov 2020 17:23:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CB7F1002941; Sat, 21 Nov 2020 22:23:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 187281002050
	for <dm-devel@redhat.com>; Sat, 21 Nov 2020 22:23:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7BBD811E76
	for <dm-devel@redhat.com>; Sat, 21 Nov 2020 22:23:00 +0000 (UTC)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
	[209.85.208.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-391-MZNOAV2gPzuP-N46zOxBNg-1; Sat, 21 Nov 2020 17:22:56 -0500
X-MC-Unique: MZNOAV2gPzuP-N46zOxBNg-1
Received: by mail-lj1-f194.google.com with SMTP id y16so13933389ljk.1;
	Sat, 21 Nov 2020 14:22:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=kJ8b4BvA6wzfK+FWWv7arlDw3Ty0opb4cjar+bLcvtg=;
	b=gu8aZSD1ql/zmcJQX/j8GcuUJ62KI87OffVbby+aNQTikfS+VeTA9wbwjWOXi/QjWh
	cHVsdRq1DU2ObVx0vtdFgJbwSOP4dqRmF7PmDWzStQSafKn3GJEcU8lFVSE8yDcQ8R/V
	QVqTGMbqmxeN+WgdW3e7U8AEq+VhKsE6kelX7ZwCtO/9NYvkilp3m5YfM4aXeogBsG8w
	OH0I4+xklnZog30Ja6dMZCi6qEcSQh3EJyy089lLEhmEUQlDpnECcC+7x43Xh7I45rDG
	/z3gylRrwkVKbq4IHGlo+u0+RKSTRn8qXIU7KxVS601p1MMMqhZ8xyqBCBoxJrlPKx68
	iOKA==
X-Gm-Message-State: AOAM530n3q2hq6TpBAzX0Mp1T0mG1DgezF235jFDaBrrp/E5elUGHB78
	aDrFmQflx16imdrImyuvauAHOokByiOHrg==
X-Google-Smtp-Source: ABdhPJxvunX+BdmeGkwBuIss2DHdAFmv5GOCUSZYkJiwA4Sbm+21EhyDXFNsdHffLvAN1Ee1v1SaHA==
X-Received: by 2002:a2e:b6cd:: with SMTP id m13mr11062641ljo.310.1605997374390;
	Sat, 21 Nov 2020 14:22:54 -0800 (PST)
Received: from localhost.localdomain (h-158-174-22-6.NA.cust.bahnhof.se.
	[158.174.22.6])
	by smtp.gmail.com with ESMTPSA id k9sm837450lfk.288.2020.11.21.14.22.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 21 Nov 2020 14:22:53 -0800 (PST)
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Sat, 21 Nov 2020 23:22:48 +0100
Message-Id: <20201121222248.6859-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:39:39 -0500
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [dm-devel] [PATCH] dm crypt: Constify static crypt_iv_operations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The only usage of these structs is to assign their address to the
iv_gen_ops field in the crypt config struct, which is a pointer to
const. Make them const like the rest of the static crypt_iv_operations
structs. This allows the compiler to put them in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 392337f16ecf..53791138d78b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1090,16 +1090,16 @@ static const struct crypt_iv_operations crypt_iv_tcw_ops = {
 	.post	   = crypt_iv_tcw_post
 };
 
-static struct crypt_iv_operations crypt_iv_random_ops = {
+static const struct crypt_iv_operations crypt_iv_random_ops = {
 	.generator = crypt_iv_random_gen
 };
 
-static struct crypt_iv_operations crypt_iv_eboiv_ops = {
+static const struct crypt_iv_operations crypt_iv_eboiv_ops = {
 	.ctr	   = crypt_iv_eboiv_ctr,
 	.generator = crypt_iv_eboiv_gen
 };
 
-static struct crypt_iv_operations crypt_iv_elephant_ops = {
+static const struct crypt_iv_operations crypt_iv_elephant_ops = {
 	.ctr	   = crypt_iv_elephant_ctr,
 	.dtr	   = crypt_iv_elephant_dtr,
 	.init	   = crypt_iv_elephant_init,
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

