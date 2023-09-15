Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91B5CD379F
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 20:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694808273;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4xPF9HEvkZYog2X1L9qaP4ErkEW0F5AUifPho3EqNUA=;
	b=HAp7l19f+t3B3jUW1exrbBUypld2xx3A0kb3/QUykpHSmTLD9fGbvYjGNFciDR0a0Tcbh5
	SmGEtaGjanIiptn4LoZs396RdajWZZ2Lc33tgtqSwUjWN9ncF3MQoU9KKw0QO2+jMsv+Fe
	eBcUZ0qdYMo3tsjuL/aORW+K8LwmXO8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-Ld8B1sBQOz-SPGDZPdNKfw-1; Fri, 15 Sep 2023 16:04:25 -0400
X-MC-Unique: Ld8B1sBQOz-SPGDZPdNKfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46607858299;
	Fri, 15 Sep 2023 20:04:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 32F0B2156A27;
	Fri, 15 Sep 2023 20:04:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14AE219465BB;
	Fri, 15 Sep 2023 20:04:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 04C0919465B7
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 20:04:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D91E440C6EBF; Fri, 15 Sep 2023 20:04:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D154840C6EA8
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:04:12 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B45A0858285
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 20:04:12 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-_ErRxZ2NMVq3vESeJBgtRg-1; Fri, 15 Sep 2023 16:04:10 -0400
X-MC-Unique: _ErRxZ2NMVq3vESeJBgtRg-1
Received: by mail-pf1-f179.google.com with SMTP id
 d2e1a72fcca58-68fdd6011f2so2113295b3a.3
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 13:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694808249; x=1695413049;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=PsjobygTJTSQG68McAspsAEHf2Z4NWVTVTdDWk+Khno=;
 b=OfqfurlZ/Tf2UUpnlKUex3YgyCiyEwko8NPLJWUyluc4LFD4pR6w7K5Bs/N7Ox3cZS
 UU/9dOh5gsra8TC2orsJREGPt7VD5i+WOIX+NCGdmIbovKEBIeR/1Z1Z1VALAfgGPIrF
 IExTg31IJdmQ+O2uVv1GZGRLyjzuBJJW5/xHEDBEqq2J9Ssa5KSEKzIqG2PgI/a+/lSx
 +iAConHBnTwmgqOrwYR6V5nlM8wl/sDDmAE1tfCcysWdZYNjSVnrj8WQYf7jVA8xlDqJ
 Ndla8+8AkBkkqTVa0PrcC5jWcBLZonAc9Yp/QatSjv5fuBj3+vZ0fgGEnbW9hXMyRYfc
 f6DA==
X-Gm-Message-State: AOJu0YxE2OFpK50evrgzN3l70rCJXUK3hri1IWfi6QecyHptVXJj99jK
 DgpRRZxlB63yiDOfHCLRsPS2eA==
X-Google-Smtp-Source: AGHT+IH4sLF8pnQUwMmvWkR2rN5ygHn9iSUnz/1ZVPT8sYwTtd14gWeZ3e+qyvEyDiGNHRPzG6Rx1Q==
X-Received: by 2002:a05:6a00:1882:b0:68b:f3a4:ff6b with SMTP id
 x2-20020a056a00188200b0068bf3a4ff6bmr3034695pfh.9.1694808249669; 
 Fri, 15 Sep 2023 13:04:09 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 b5-20020aa78705000000b0067b643b814csm3342707pfo.6.2023.09.15.13.04.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Sep 2023 13:04:09 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Fri, 15 Sep 2023 13:04:08 -0700
Message-Id: <20230915200407.never.611-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1191; i=keescook@chromium.org; 
 h=from:subject:message-id;
 bh=VvKOCdO6PY/NRn1of9dfjjBTN1ZCPOIIRKyzCXPi3Xs=; 
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlBLi3mSrPQ2k1ngorCbl4cZDSbvlJ0xPRobTs8
 GueuwSV7kWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZQS4twAKCRCJcvTf3G3A
 JtYGEACyVAHf3GVlw2Xkm6VuFB0xT82MYq4INcuJ+itoZaCrenWb3tCwhY+fkcq72HKGx/1b+Pv
 OErce1wHcbokBfk0DlDKQjpwTDQ30Gf5+HVA0pmgtzw+RCZpIaLZJlOwEEQCpEPlny0qSUK0yaI
 a1yOASH1d+H1/d9KHywGNJM163u97BQe/p66EQPbo3zI5lr9hfB3USLebN3whqkMloLEf/C/YKx
 mQhVgPhBYsk4XQDWg2qaUl/tPWEreLsObc5Ph5PPVD6lGYBAthn5H4yEqa5aL1Oi1Dcd+k0lmPm
 /otgAB97W1ZqTCSLxt53qsC/0r7xDwRZjAvSAkr9syY7RXz/3ALTkIhufMhLlhyrhWO/GyqE1QT
 lb1UTLNeBeXKoaEkiUartdD4xgOObsF3xCEyX5gIvcSVORT+kGYdd7JcsReF/6zy6db+bj22DwY
 2BEEgGV673w8FiKlgNdKvDLTeSO7JXALYRZAXEA9acesISfNFIXsG0nVje0xKQddBijW1EvXBdG
 H3BJrXpWLA6sppNr8YNdgcYczeF1AsmcHZbr1bjN/p4XGobHkFcsET0KbH1xxp2g2FQfJB0Bfvp
 xT8heKvTGaxyjqe3dVxh3q0znd6p8eHowg2vMIMMimkErAmjMwbC/7t3mSopit/jjHuI7TiZG1g
 iseMwLp rJU4WzBg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp;
 fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm: Annotate struct dm_bio_prison with
 __counted_by
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
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
 dm-devel@redhat.com, linux-hardening@vger.kernel.org,
 Tom Rix <trix@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct dm_bio_prison.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/dm-bio-prison-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 92afdca760ae..9ab32abe5ed4 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -26,7 +26,7 @@ struct prison_region {
 struct dm_bio_prison {
 	mempool_t cell_pool;
 	unsigned int num_locks;
-	struct prison_region regions[];
+	struct prison_region regions[] __counted_by(num_locks);
 };
 
 static struct kmem_cache *_cell_cache;
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

