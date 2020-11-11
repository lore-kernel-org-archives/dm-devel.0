Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F6AC5517A
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 11:34:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DE592075A
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 11:34:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DE592075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-8F3-nyfmNhqsFHxfMilaPg-1; Wed, 11 Nov 2020 06:33:59 -0500
X-MC-Unique: 8F3-nyfmNhqsFHxfMilaPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B00B98015F8;
	Wed, 11 Nov 2020 11:33:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90DDA7666E;
	Wed, 11 Nov 2020 11:33:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BDEE8180954D;
	Wed, 11 Nov 2020 11:33:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AB2g3k7015322 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 10 Nov 2020 21:42:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 799F8200A7DC; Wed, 11 Nov 2020 02:42:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74A77200E213
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 02:42:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13522102F1E0
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 02:42:01 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
	[209.85.219.202]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-259-1kJ6L1TuMiuucIViL0gajg-1; Tue, 10 Nov 2020 21:41:59 -0500
X-MC-Unique: 1kJ6L1TuMiuucIViL0gajg-1
Received: by mail-yb1-f202.google.com with SMTP id t71so880720ybi.3
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 18:41:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
	:to:cc;
	bh=OUUVYD1R785BEy2RCsP0C8sEZy7udFaGjiORPSK5eA4=;
	b=aszEI6NQbL/fpaeLSra56HEgoi9Fy/Dv7VGoJKeMk9mnYSUFo0L0h0bvQ8cZ5y7V4g
	V6ZxNunEPptXrbE1iQmCBO50yeslIpHW8LolpzHo3sDNRRBwuCMiw8Olo4rpdHUTzCsS
	TH6G0YZ4TZWkbzJHVKgzq8JhDyFkNj3G8HCVjpIP+IgRXXySaXG8LYwPlojgf58pmDPT
	i6WT3LB9QIlf/z0djepAfr8S+uR8cqLAkz1fk5WN3U8YBiuVbM3I54ApJaLAsv+EfTSk
	Nqr/rsH457gR8haVy9/qHAFFz1fLa8I1YdIyhUrduCIKlr8M/YErrrVK6/pAbCVfznDg
	nFGA==
X-Gm-Message-State: AOAM530JzI4SPMa/4HBThd18wzAdEByLZ1HlKXwxhJEReQgnKcFyp/Uf
	15vLOMZnHcM4UINmLtJ1ebP+gvCzQ6RFfX9ut1A=
X-Google-Smtp-Source: ABdhPJwPg4i8FsskSCpJr28arcLUIKNAAIxC1mde4fbI6yBQbYaURLDP3XHyTL2hLmSLv+hmkyMSeZn/bUQxuAxxMPg=
X-Received: from ndesaulniers1.mtv.corp.google.com
	([2620:15c:211:202:f693:9fff:fef4:4d25])
	(user=ndesaulniers job=sendgmr) by 2002:a25:b445:: with SMTP id
	c5mr29391620ybg.355.1605062518302; Tue, 10 Nov 2020 18:41:58 -0800 (PST)
Date: Tue, 10 Nov 2020 18:41:40 -0800
Message-Id: <20201111024140.1483879-1-ndesaulniers@google.com>
Mime-Version: 1.0
From: Nick Desaulniers <ndesaulniers@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
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
X-Mailman-Approved-At: Wed, 11 Nov 2020 06:33:51 -0500
Cc: Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
	clang-built-linux@googlegroups.com, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Rob Herring <robherring2@gmail.com>
Subject: [dm-devel] [PATCH] Revert "dm cache: fix arm link errors with
	inline"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This reverts commit 43aeaa29573924df76f44eda2bbd94ca36e407b5.

Since
commit 0bddd227f3dc ("Documentation: update for gcc 4.9 requirement")
the minimum supported version of GCC is gcc-4.9. It's now safe to remove
this code.

Link: https://github.com/ClangBuiltLinux/linux/issues/427
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/md/dm-cache-target.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9644424591da..4bc453f5bbaa 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -712,10 +712,6 @@ static bool block_size_is_power_of_two(struct cache *cache)
 	return cache->sectors_per_block_shift >= 0;
 }
 
-/* gcc on ARM generates spurious references to __udivdi3 and __umoddi3 */
-#if defined(CONFIG_ARM) && __GNUC__ == 4 && __GNUC_MINOR__ <= 6
-__always_inline
-#endif
 static dm_block_t block_div(dm_block_t b, uint32_t n)
 {
 	do_div(b, n);
-- 
2.29.2.222.g5d2a92d10f8-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

