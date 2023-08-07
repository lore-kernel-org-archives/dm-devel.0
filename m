Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3D9C07E8D
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477630;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zi3iyq90MMGK/in4yOI7FzkukW9tE4rdh0ZMKooSFbY=;
	b=FRCMAYn0w/D0X/lfTAU3+pL2tvhSkOsI8GGRtBOD2XNOTNUsr7umP3hvrr5eRcwVqb5KSD
	xiAS1nJuKW/uH38VIQ3Qpem/1BBgImRoSTytn1NS9ui9DzANbYaN4bSnKbMfb3nlfn/MS7
	gkYV8VYx6hB6EygDbPzKw8coq87Z8vM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-_L4it3WRPyem6IONt-OpQQ-1; Tue, 08 Aug 2023 02:53:42 -0400
X-MC-Unique: _L4it3WRPyem6IONt-OpQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E5A21044595;
	Tue,  8 Aug 2023 06:53:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62F001121314;
	Tue,  8 Aug 2023 06:53:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84E1319452CD;
	Tue,  8 Aug 2023 06:53:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 555031946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 11:14:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A929140EBD7; Mon,  7 Aug 2023 11:14:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22AC6140E962
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:14:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E467F3C0E461
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:14:42 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-mKRcx6LyMP6qjL5lG9IyUw-1; Mon, 07 Aug 2023 07:14:41 -0400
X-MC-Unique: mKRcx6LyMP6qjL5lG9IyUw-1
Received: by mail-pj1-f52.google.com with SMTP id
 98e67ed59e1d1-26890669c8eso931994a91.1
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 04:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691406880; x=1692011680;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=uDu/4z0sff3MNLq2Hem41DvJLtW9HR7Ht2OY0+o3IBw=;
 b=KZWQ7P0qZiUgJzMmUtsonUiIT70KaQvovT8AOkKaxCOJmF6Xbhhstugv6XabpyWnwA
 55mCO8IIK/xjgPcryoCKVnswS4WYh6bbqKX8vRG7QCL2Iz+aEUiaD+ZMp47/1IFBIb24
 bTJ4Muvv+KEOCtr5cAFkO0rwvaERDwAi2jHykyMLUPMVwPpnuS5j9F5sDKr23QCbeQz1
 L1o8ArkklQ5B+y5apRHnXMYAzoQYQwDCiNt7j1YowIOum9PYyCqmVJ/U9VZhQzCoKOv1
 JDRoZ7lcMCCZjOe0WV+itIHiWq2LZeMsZOIJyctaCAHyZTjyvSjtkftk5zn9cCu4O22C
 MV5A==
X-Gm-Message-State: ABy/qLYrhq6VLYw04a3HTBEdWQ8NqXRIclSD8BDNdzazAHyUmkiPPbd/
 9UAECpuEl6oKggsaZyuTZvO7KQ==
X-Google-Smtp-Source: APBJJlE+JUQU2KnCMqxKRhVbnyE7g/MjXwiwJL23ihCwbN9GtK/yS0Snkx/m2fq2fyEzRCC+VQ52VA==
X-Received: by 2002:a17:90a:1f83:b0:268:3dc6:f0c5 with SMTP id
 x3-20020a17090a1f8300b002683dc6f0c5mr25034377pja.0.1691406879873; 
 Mon, 07 Aug 2023 04:14:39 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
 by smtp.gmail.com with ESMTPSA id
 y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.14.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Aug 2023 04:14:39 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev,
 simon.horman@corigine.com, dlemoal@kernel.org
Date: Mon,  7 Aug 2023 19:09:10 +0800
Message-Id: <20230807110936.21819-23-zhengqi.arch@bytedance.com>
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: [dm-devel] [PATCH v4 22/48] mm: workingset: dynamically allocate
 the mm-shadow shrinker
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use new APIs to dynamically allocate the mm-shadow shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/workingset.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index da58a26d0d4d..3c53138903a7 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -763,13 +763,6 @@ static unsigned long scan_shadow_nodes(struct shrinker *shrinker,
 					NULL);
 }
 
-static struct shrinker workingset_shadow_shrinker = {
-	.count_objects = count_shadow_nodes,
-	.scan_objects = scan_shadow_nodes,
-	.seeks = 0, /* ->count reports only fully expendable nodes */
-	.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE,
-};
-
 /*
  * Our list_lru->lock is IRQ-safe as it nests inside the IRQ-safe
  * i_pages lock.
@@ -778,9 +771,10 @@ static struct lock_class_key shadow_nodes_key;
 
 static int __init workingset_init(void)
 {
+	struct shrinker *workingset_shadow_shrinker;
 	unsigned int timestamp_bits;
 	unsigned int max_order;
-	int ret;
+	int ret = -ENOMEM;
 
 	BUILD_BUG_ON(BITS_PER_LONG < EVICTION_SHIFT);
 	/*
@@ -797,17 +791,24 @@ static int __init workingset_init(void)
 	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
 	       timestamp_bits, max_order, bucket_order);
 
-	ret = prealloc_shrinker(&workingset_shadow_shrinker, "mm-shadow");
-	if (ret)
+	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
+						    SHRINKER_MEMCG_AWARE,
+						    "mm-shadow");
+	if (!workingset_shadow_shrinker)
 		goto err;
+
 	ret = __list_lru_init(&shadow_nodes, true, &shadow_nodes_key,
-			      &workingset_shadow_shrinker);
+			      workingset_shadow_shrinker);
 	if (ret)
 		goto err_list_lru;
-	register_shrinker_prepared(&workingset_shadow_shrinker);
+
+	workingset_shadow_shrinker->count_objects = count_shadow_nodes;
+	workingset_shadow_shrinker->scan_objects = scan_shadow_nodes;
+
+	shrinker_register(workingset_shadow_shrinker);
 	return 0;
 err_list_lru:
-	free_prealloced_shrinker(&workingset_shadow_shrinker);
+	shrinker_free(workingset_shadow_shrinker);
 err:
 	return ret;
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

