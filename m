Return-Path: <SRS0=xCF1=ED=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35DDC55178
	for <dm-devel@archiver.kernel.org>; Wed, 28 Oct 2020 14:22:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E934224734
	for <dm-devel@archiver.kernel.org>; Wed, 28 Oct 2020 14:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E934224734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-Rn8UcTYiPG2VFxUELV2n8Q-1; Wed, 28 Oct 2020 10:22:12 -0400
X-MC-Unique: Rn8UcTYiPG2VFxUELV2n8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71FFF8049E0;
	Wed, 28 Oct 2020 14:22:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D97660BF1;
	Wed, 28 Oct 2020 14:22:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3252044A6C;
	Wed, 28 Oct 2020 14:22:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09SEEN1K000729 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Oct 2020 10:14:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E54B100321A; Wed, 28 Oct 2020 14:14:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A68C110F725
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 14:14:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 066EE80351B
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 14:14:21 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
	[209.85.128.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-163-RT7wnhF4OESspVsainFwJQ-1; Wed, 28 Oct 2020 10:14:16 -0400
X-MC-Unique: RT7wnhF4OESspVsainFwJQ-1
Received: by mail-wm1-f45.google.com with SMTP id l20so3378327wme.0;
	Wed, 28 Oct 2020 07:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=z30I0sFlH0ObfCQuQHQH0g6K5nLixAEObUnOF2cDkr4=;
	b=asGDlyM8YtT1iiYjvm2PWGci02ByIQfuXpY3a5QFjuNvHa+0Y5bqB8oh6ErV8rJv5L
	FjuCef1TjtJ6pMBzmh2jUsv4yAbrSZApdgK6kS+vsZdCK3OTLig5WqO+wOHhP3Wn2aWl
	JujAfMnwc6lovFM0Nr86fA98ZNioxbsIBGwCA20NXw6EAj/kw+3DwF8ifTH8h1xPSa0P
	lXSUz8+gEBs2GA2Ssr6LMrtC40jtUQ5vJJhJAyVM3c7oPp+m6zsE5EmOnB8xRu1YpL8I
	FsNOBRfPBro7cOqEV1bbYMnHMq4plaFsdqBXwEUBHKxwQLUM3UL8q5gkZPLT88t6yzee
	86pA==
X-Gm-Message-State: AOAM5308CWQRb2vD+H92/39l6lpbn3SHapzV9mz/om5AWIR4NBPaJbW9
	HqLTN+o8RScy7eUBPKLWwTswx5HwJw==
X-Google-Smtp-Source: ABdhPJxmmjxGrSFKQl6c9Y0u/rs7zZAI1muupQak7XLmoNnA5d0kmhlFJoPwLxzURX1HbUhVLGCEGQ==
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr8510812wmj.109.1603894453716; 
	Wed, 28 Oct 2020 07:14:13 -0700 (PDT)
Received: from localhost (95.red-95-127-150.staticip.rima-tde.net.
	[95.127.150.95]) by smtp.gmail.com with ESMTPSA id
	x10sm6775868wrp.62.2020.10.28.07.14.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 28 Oct 2020 07:14:13 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 28 Oct 2020 15:14:11 +0100
Message-Id: <20201028141411.23806-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: delete auto-generated
	tests/test-log.d file with make clean
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 502377f0..884c4611 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -84,7 +84,7 @@ valgrind_clean:
 
 clean: test_clean valgrind_clean dep_clean
 	$(RM) $(TESTS:%=%-test) $(OBJS) *.o.wrap
-	$(RM) -rf lib
+	$(RM) -rf lib test-log.d
 
 .SECONDARY: $(OBJS)
 
-- 
2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

