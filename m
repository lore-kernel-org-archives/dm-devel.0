Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCA2C001DE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477620;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5U7ifrln7uuif7vH8Sl+/LAEMHu69t/vvd8dSpXaWrY=;
	b=bKqxACVYtpJD9QWcE3mwFK3D0Dxj+rA9RQUw1O69D4bwLfU9FWlLFUgNfWyw7esAMKtO9X
	tb6qtvkKVGFE8s6c3EDUn4YD2GSzQWXEbptH5ttWw6Wy0KF2XdPwO9pyv4QDjk5wfogEnJ
	Nw9DgVuTwkzn20pOnTiCGMaY8cjB43Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-BpGygwSwN9SI1uiWkOTAug-1; Tue, 08 Aug 2023 02:53:36 -0400
X-MC-Unique: BpGygwSwN9SI1uiWkOTAug-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECA608057AA;
	Tue,  8 Aug 2023 06:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5994492C13;
	Tue,  8 Aug 2023 06:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59D201946587;
	Tue,  8 Aug 2023 06:53:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1EDC1946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 11:11:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B09921759C; Mon,  7 Aug 2023 11:11:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9289440FF
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:11:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89B758DC666
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:11:03 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-OnLwbe7wPtG9AnqHwdBu0g-1; Mon, 07 Aug 2023 07:11:01 -0400
X-MC-Unique: OnLwbe7wPtG9AnqHwdBu0g-1
Received: by mail-pf1-f173.google.com with SMTP id
 d2e1a72fcca58-6878db91494so757413b3a.0
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 04:11:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691406660; x=1692011460;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=gw0136sZs5r00/aJ54ocs9PBikYP7lRbXpwQPAfPTOc=;
 b=RitlNOEY4wJGcqYJ6f5IXziMBywlnRyXs3VTXwPPENDHXMauqRxgBjxZNKY0VBFkvY
 6Ej2Kk0FYulESm90Vva/X0+F+EkYEYmXDp8GMP8FhnxvHD1RI/p9Nb4IMLDq4kvNRbri
 gWR0PMH0WhLGmV1XMxnH3m6sNuirpRC+C8tz1Gi88p+QipG0y3YA5Mlhf0PK8UosahuV
 dWcZV4+y+1n+PlcWtrtJ1ImR7UrG3ShrVHbjLpMM1MmNuMz80l9oaTRIDftLgxM3SgJu
 LDRJfjGtQ7moAs22rYjAxsUbpuLlJcGqRyIrA+Ejy3Ap1bNPfAYPRdImMOzQH12AT0D8
 FaUw==
X-Gm-Message-State: ABy/qLZKDbsndiTXjJE9I5lWNlAr7WdThrO4g6dsIfgrOCY7nxT0A3cV
 3lmq+ga5T0TvuSLd3MR8BFzWdA==
X-Google-Smtp-Source: APBJJlEPLwCkyM2NxjgH9xwMvzhNNiNlagu6lRBAbkDAEcDSA5oH2sSREkdo5fvCbnVAS1DDWMCKvg==
X-Received: by 2002:a17:90a:4104:b0:25c:1ad3:a4a1 with SMTP id
 u4-20020a17090a410400b0025c1ad3a4a1mr24588690pjf.1.1691406660379; 
 Mon, 07 Aug 2023 04:11:00 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
 by smtp.gmail.com with ESMTPSA id
 y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.10.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Aug 2023 04:10:59 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev,
 simon.horman@corigine.com, dlemoal@kernel.org
Date: Mon,  7 Aug 2023 19:08:53 +0800
Message-Id: <20230807110936.21819-6-zhengqi.arch@bytedance.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: [dm-devel] [PATCH v4 05/48] kvm: mmu: dynamically allocate the
 x86-mmu shrinker
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
 Muchun Song <songmuchun@bytedance.com>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use new APIs to dynamically allocate the x86-mmu shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9e4cd8b4a202..0386d5ec97b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6804,11 +6804,7 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
-static struct shrinker mmu_shrinker = {
-	.count_objects = mmu_shrink_count,
-	.scan_objects = mmu_shrink_scan,
-	.seeks = DEFAULT_SEEKS * 10,
-};
+static struct shrinker *mmu_shrinker;
 
 static void mmu_destroy_caches(void)
 {
@@ -6941,10 +6937,16 @@ int kvm_mmu_vendor_module_init(void)
 	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
 		goto out;
 
-	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
-	if (ret)
+	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
+	if (!mmu_shrinker)
 		goto out_shrinker;
 
+	mmu_shrinker->count_objects = mmu_shrink_count;
+	mmu_shrinker->scan_objects = mmu_shrink_scan;
+	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
+
+	shrinker_register(mmu_shrinker);
+
 	return 0;
 
 out_shrinker:
@@ -6966,7 +6968,7 @@ void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	unregister_shrinker(&mmu_shrinker);
+	shrinker_free(mmu_shrinker);
 }
 
 /*
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

