Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5556EC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664460734;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U2lGV9UnZ9mjCZx4x/9AA+HclQKT6hOSfAkdwtB/saE=;
	b=f3MQhoCRQ8Di00FZ2/ZCK0B8htJRtVUKQo7pa9WuOPjvKP8g0IQfyGauuiBYPLXbqMKkh8
	+QqLv0iydnH8NBSbdKcq01ohz3LVy1IEf/FpGYcIm1gbQkEl81o+3AXrJaxI3/2N5F2cFg
	7mRnVFHWzrqvTcusIwr2VPfhF9vZ6fA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-EfHQEG4FN62vV3ymrctjpA-1; Thu, 29 Sep 2022 10:12:12 -0400
X-MC-Unique: EfHQEG4FN62vV3ymrctjpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B0F187A382;
	Thu, 29 Sep 2022 14:12:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C94CA40C206B;
	Thu, 29 Sep 2022 14:12:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7F171946A45;
	Thu, 29 Sep 2022 14:12:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F57B19465B8
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Sep 2022 14:12:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D16FC492B05; Thu, 29 Sep 2022 14:12:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9C65492B04
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 14:12:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BF4B185A794
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 14:12:05 +0000 (UTC)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
 [209.85.208.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-548-9O86GmiDN-W9E_AUUkSxoQ-1; Thu, 29 Sep 2022 10:12:03 -0400
X-MC-Unique: 9O86GmiDN-W9E_AUUkSxoQ-1
Received: by mail-ed1-f44.google.com with SMTP id z2so2171188edi.1
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 07:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=XCaflBNzsF3gWvBUaD2qX6zs31ZsPsIx7b6l1Hq92FA=;
 b=INTMVjqn9re8vVl0a6y/6U/+2Qs93sUcuovfZPpI73kyPZnjOueXJ5Qs4TZk+mqDR3
 NNZEdeq3bZ2Yg3PN5f6WCmLRG2BCkDXHIld9ubHJOysPgFRQKRarOGfrustB1UbUoZPC
 3bmQZQjq4ieI4BS0TFqmWrb76jrkaLS+lvsDDisWL/R9y3yxEc4j6TjKVz60W4Bj1NKG
 UwGdB/SKO68Allh5FYsjAkz9cf/RXuGPd0IttyoVuusG8PMEE0n2OJC8whPc0NrF18N+
 m3yR9LyMBGXvZmXNf/6RIFIoPnJQJqtfUQ1xyz0MdGds4RqmQUyMRGDbEUqyzEuLX9Ht
 szXg==
X-Gm-Message-State: ACrzQf1D+xe4IVnFjc0WTOZJXhNIbwRTP+LXjjE/2KbOPJvHK1AUAz+d
 QfoLmNuCWSAr0uUotmYKkmC58Q==
X-Google-Smtp-Source: AMsMyM477WCnpF8yVEYYySeiqoFVHDuWpu5g/gmW//tawjP06HhG5gTQ0QtpC/IU5M1OziE8IxUG8Q==
X-Received: by 2002:a05:6402:2547:b0:450:668c:9d93 with SMTP id
 l7-20020a056402254700b00450668c9d93mr3606189edb.92.1664460722432; 
 Thu, 29 Sep 2022 07:12:02 -0700 (PDT)
Received: from marvin.hq.arr ([185.109.18.135])
 by smtp.gmail.com with ESMTPSA id
 k13-20020a50ce4d000000b0045769dee1fdsm5420803edj.29.2022.09.29.07.12.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Sep 2022 07:12:01 -0700 (PDT)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Thu, 29 Sep 2022 17:11:48 +0300
Message-Id: <20220929141148.29284-1-ntsironis@arrikto.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH] dm clone: Fix typo in block_device format
 specifier
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
Cc: ntsironis@arrikto.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use %pg for printing the block device name, instead of %pd.

Fixes: 385411ffba0c ("dm: stop using bdevname")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-clone-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 811b0a5379d0..2f1cc66d2641 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2035,7 +2035,7 @@ static void disable_passdown_if_not_supported(struct clone *clone)
 		reason = "max discard sectors smaller than a region";
 
 	if (reason) {
-		DMWARN("Destination device (%pd) %s: Disabling discard passdown.",
+		DMWARN("Destination device (%pg) %s: Disabling discard passdown.",
 		       dest_dev, reason);
 		clear_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags);
 	}
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

