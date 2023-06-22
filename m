Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25598C0015E
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687498012;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FyACrvzp0LgLajxlGeuRsxxjkBEraosmx5suUlKSvmc=;
	b=bZIYWeDaU3bzVqI33KzmdW/f7LPpeYUU2d2aKq94c6DFtpYyITO8c7jKDNDCuHK/Y0gzRJ
	MMnnSPlJd3pZvidnNGTY5sMnGrJktAuYTZMPiVRJYC7ZUg5AldJdleewAJeE1REV3gSJ3C
	Fg3x6u6zskln7nlYzpb1Gyvxr6FVTJY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-SRWKmVsKPAimiV9DJujNdA-1; Fri, 23 Jun 2023 01:26:47 -0400
X-MC-Unique: SRWKmVsKPAimiV9DJujNdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2994C1064AFC;
	Fri, 23 Jun 2023 05:26:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19613404A425;
	Fri, 23 Jun 2023 05:26:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6DDF193775B;
	Fri, 23 Jun 2023 05:25:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8ED241946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:55:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6C0D841EF82; Thu, 22 Jun 2023 08:55:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63D57492C13
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:55:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 495C03C13509
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:55:30 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-mbQcmkxANQi-sJgrP1A3BA-1; Thu, 22 Jun 2023 04:55:24 -0400
X-MC-Unique: mbQcmkxANQi-sJgrP1A3BA-1
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1b5466bc5f8so9653965ad.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 01:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687424123; x=1690016123;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=u/vExFBLW3qTniAw4XeP9KQ69i9zow/4wwrpInqlwjM=;
 b=O1eZDhka1JtisGYzUcIY+LizRYi9AWM8jDH6FZuIchvEGEPSY919UtOLoZdoCMcWKW
 eRUE5vvVl3KzoFl2iN5TdqosQ87WIvzXWbgwEwn5+PzXvn0RyRP5K4XTcH2PkJUR/sZ9
 v23e6M0BYC3pNKswF/SfoomPAapbQcI8m5aN8hKTjNklbsZS43Mcgs+qthRkv6snoafe
 +ob3EBsNOjujxzSKf1nFW4jgxZXil/g589j8Tpqxo0RqA7js14JlH1JFwWIzWh2u9sOc
 +gsd3XFWqValmKMLSX6E2NfBK2d2cgOy3ZkHl1fzVpmASoTH5jW4uiHWUBGolpx+XrHB
 qH2A==
X-Gm-Message-State: AC+VfDyygL1vxoCEEPsRZo4OeQ+zQZ3FFUUSmPydrXmrrNCZGZvwfSBj
 HuScZYRp2qjtYIzvacIOLia5Zw==
X-Google-Smtp-Source: ACHHUZ4R6XsCch8DMbBn2ilzIIAPskFMWcDdECndDXpbpwroXAZTFBoXbn8TaLTiXdt1Xz94/St+OA==
X-Received: by 2002:a17:902:dac6:b0:1a1:956d:2281 with SMTP id
 q6-20020a170902dac600b001a1956d2281mr22035085plx.3.1687424123198; 
 Thu, 22 Jun 2023 01:55:23 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.55.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 01:55:22 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 16:53:16 +0800
Message-Id: <20230622085335.77010-11-zhengqi.arch@bytedance.com>
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 10/29] vmw_balloon: dynamically allocate the
 vmw-balloon shrinker
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the vmw-balloon shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct vmballoon.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/misc/vmw_balloon.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 9ce9b9e0e9b6..2f86f666b476 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -380,7 +380,7 @@ struct vmballoon {
 	/**
 	 * @shrinker: shrinker interface that is used to avoid over-inflation.
 	 */
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 
 	/**
 	 * @shrinker_registered: whether the shrinker was registered.
@@ -1569,7 +1569,7 @@ static unsigned long vmballoon_shrinker_count(struct shrinker *shrinker,
 static void vmballoon_unregister_shrinker(struct vmballoon *b)
 {
 	if (b->shrinker_registered)
-		unregister_shrinker(&b->shrinker);
+		unregister_and_free_shrinker(b->shrinker);
 	b->shrinker_registered = false;
 }
 
@@ -1581,14 +1581,18 @@ static int vmballoon_register_shrinker(struct vmballoon *b)
 	if (!vmwballoon_shrinker_enable)
 		return 0;
 
-	b->shrinker.scan_objects = vmballoon_shrinker_scan;
-	b->shrinker.count_objects = vmballoon_shrinker_count;
-	b->shrinker.seeks = DEFAULT_SEEKS;
+	b->shrinker = shrinker_alloc_and_init(vmballoon_shrinker_count,
+					      vmballoon_shrinker_scan,
+					      0, DEFAULT_SEEKS, 0, b);
+	if (!b->shrinker)
+		return -ENOMEM;
 
-	r = register_shrinker(&b->shrinker, "vmw-balloon");
+	r = register_shrinker(b->shrinker, "vmw-balloon");
 
 	if (r == 0)
 		b->shrinker_registered = true;
+	else
+		shrinker_free(b->shrinker);
 
 	return r;
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

