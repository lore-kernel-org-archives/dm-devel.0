Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A54C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:30:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C900A23A84
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C900A23A84
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-q7CVxXk-M5ycKXpSsU5BJw-1; Fri, 22 Jan 2021 10:30:12 -0500
X-MC-Unique: q7CVxXk-M5ycKXpSsU5BJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D278A8144E3;
	Fri, 22 Jan 2021 15:30:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B49B860C6B;
	Fri, 22 Jan 2021 15:30:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8308F1809CA0;
	Fri, 22 Jan 2021 15:30:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFQC8r028611 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:26:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 48ED42166B27; Fri, 22 Jan 2021 15:26:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42BF02166B2B
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:26:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 366AC811E78
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:26:08 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
	[209.85.221.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-190-WY5TmLPCOSmraJ4VxYF1uw-1; Fri, 22 Jan 2021 10:26:06 -0500
X-MC-Unique: WY5TmLPCOSmraJ4VxYF1uw-1
Received: by mail-wr1-f43.google.com with SMTP id m4so5452990wrx.9
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:26:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=oz0drnykatIxvUVv11Ld/Kg9w4bHeert3CCsRVLYUmc=;
	b=JNzlQ4mfKdOPhLYC6U5nr6Pc7CA+OY7d/qyKHcuOZtz70q5dyLQCH2PFJ99QwnSON/
	WnBNNZb8J3bYbZOYJ7qi3332i7t7tGMi5Ve/dGV6MRkJhHRKpPiiK93MX9O7NVqfkYNp
	dDbTVnP0HBK2DYxS6DAC8urlW9osMgCc1lB3O6LTlS/tkmTHiFC2oBiH27p7WENZOgYa
	hs9VN9mEuwGu2dLs6adUGoIl2ft1c7EQ5uaX94H7gdkpHTVElL5PLPvf58mNElIOdN1n
	zVZtvZ8oT7rCjDWdpjJr12tC3OOr8UQswgAct+1nqIyjUhZz3An9YCEo0LB4ci6Emu+T
	4WQg==
X-Gm-Message-State: AOAM532nVVvPdege3j5I5ZxQ/BtT2NtaWzrE/3UXg37ZLy+1FUTCSozh
	R1nkIOCUunONr48tGIzjt8ia+Q==
X-Google-Smtp-Source: ABdhPJxQryvDV2XR7P3m9EMP193r/WFutDObpjwWGtkm06SRFgFSh5QucOh1xQ1xOPYCfIyHTWboMA==
X-Received: by 2002:a05:6000:1803:: with SMTP id
	m3mr4999358wrh.34.1611329164729; 
	Fri, 22 Jan 2021 07:26:04 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	r1sm12685159wrl.95.2021.01.22.07.26.02
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:26:03 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:25:55 +0200
Message-Id: <20210122152556.24822-4-ntsironis@arrikto.com>
In-Reply-To: <20210122152556.24822-1-ntsironis@arrikto.com>
References: <20210122152556.24822-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 3/4] dm era: Use correct value size in equality
	function of writeset tree
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix the writeset tree equality test function to use the right value size
when comparing two btree values.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ffbbd8740253..104fb110cd4e 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -389,7 +389,7 @@ static void ws_dec(void *context, const void *value)
 
 static int ws_eq(void *context, const void *value1, const void *value2)
 {
-	return !memcmp(value1, value2, sizeof(struct writeset_metadata));
+	return !memcmp(value1, value2, sizeof(struct writeset_disk));
 }
 
 /*----------------------------------------------------------------*/
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

