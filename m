Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7341C3DA40
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 06:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690267397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pc5yzJ4r90EHnaM8SJSFt7A22u5DoMnAuFmYKhhEYw4=;
	b=XCYEVrkGuOV2FWxA8/ARTDL6z5pFRt+gb//rUz/xBV3pJmVDh4xyB0rlB/K6dfJ9I+HI85
	Au7oSHUsHxEtgG7VhhQiVR/CZtwatHb+TixJwXy/EB+4GP2KdvBp1HTmtK68PE1b4l96ga
	UgDuzqD5PSryh9iTHbu3FA8MQEy1BGo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-HjroEAxXOUqAsNX4scIwXw-1; Tue, 25 Jul 2023 02:43:14 -0400
X-MC-Unique: HjroEAxXOUqAsNX4scIwXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C50A1C07554;
	Tue, 25 Jul 2023 06:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA9B5C2C856;
	Tue, 25 Jul 2023 06:42:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D634193739F;
	Tue, 25 Jul 2023 06:42:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 943DF1946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Jul 2023 09:53:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7EBAF492C13; Mon, 24 Jul 2023 09:53:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76EB446A3A9
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 09:53:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57D5329AB3F3
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 09:53:37 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-Y7NuMMrTO2iE8idbz2AlhQ-1; Mon, 24 Jul 2023 05:53:30 -0400
X-MC-Unique: Y7NuMMrTO2iE8idbz2AlhQ-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-682eef7d752so1028862b3a.0
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 02:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690192409; x=1690797209;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=tgz3Agis5n4s/WxjwmGNRU8p70ZOSlVCE9Y6IFYv5Fc=;
 b=NpqnleuFR18hT24ETk6Z/bEKtLtE/IKsscb6ezV9hdKMap9vpumOz+KxA3he85kuMc
 vl0RBbqfcCAhlZvGpoLyI4uIrZ3yKjFe49jfW8QCRkEpXYwxR8m+t3B2lOnLKUrw4PX7
 ggMyrt351Rocd5k2pB4OA/mCnUmEpbrePBDaYKVgqj8QWevygNAoLiN6wnp8Dw/rNxQ6
 TR9b8JFr9vsoZLzaJoEJwawQgvyGvIfBE+CSy/oexfv6KOMqHwpSRoD5t0a+3pdEdPrV
 duLbKMr09H2tFRrhlVQ2C2JKfH/ZnewEcfMxuxT+D+8eSoOur5GiLImtEesaunx+tZSd
 HuwA==
X-Gm-Message-State: ABy/qLaq8nexDPxoHynGqhJj4foYrXb3l1GB1RJYq2TMyrhi4KmgIq6Y
 sTtMpMwArXvxCO7E8LTBKLUy2g==
X-Google-Smtp-Source: APBJJlGQECD+YmQyidx3CbYp8mtos2ukz3b+adApuBRwpx+yQP4R50i+1wYRdDRgYwf/0cvAmnpMMg==
X-Received: by 2002:a17:902:f681:b0:1b8:a469:53d8 with SMTP id
 l1-20020a170902f68100b001b8a46953d8mr12732513plg.0.1690192409468; 
 Mon, 24 Jul 2023 02:53:29 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.53.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 24 Jul 2023 02:53:29 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
Date: Mon, 24 Jul 2023 17:43:49 +0800
Message-Id: <20230724094354.90817-43-zhengqi.arch@bytedance.com>
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 25 Jul 2023 06:42:42 +0000
Subject: [dm-devel] [PATCH v2 42/47] drm/ttm: introduce pool_shrink_rwsem
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, the synchronize_shrinkers() is only used by TTM pool. It only
requires that no shrinkers run in parallel.

After we use RCU+refcount method to implement the lockless slab shrink,
we can not use shrinker_rwsem or synchronize_rcu() to guarantee that all
shrinker invocations have seen an update before freeing memory.

So we introduce a new pool_shrink_rwsem to implement a private
synchronize_shrinkers(), so as to achieve the same purpose.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 15 +++++++++++++++
 include/linux/shrinker.h       |  2 --
 mm/shrinker.c                  | 15 ---------------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index e1eb73d0b72a..8a35fd48ec46 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -74,6 +74,7 @@ static struct ttm_pool_type global_dma32_uncached[MAX_ORDER + 1];
 static spinlock_t shrinker_lock;
 static struct list_head shrinker_list;
 static struct shrinker *mm_shrinker;
+static DECLARE_RWSEM(pool_shrink_rwsem);
 
 /* Allocate pages of size 1 << order with the given gfp_flags */
 static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
@@ -317,6 +318,7 @@ static unsigned int ttm_pool_shrink(void)
 	unsigned int num_pages;
 	struct page *p;
 
+	down_read(&pool_shrink_rwsem);
 	spin_lock(&shrinker_lock);
 	pt = list_first_entry(&shrinker_list, typeof(*pt), shrinker_list);
 	list_move_tail(&pt->shrinker_list, &shrinker_list);
@@ -329,6 +331,7 @@ static unsigned int ttm_pool_shrink(void)
 	} else {
 		num_pages = 0;
 	}
+	up_read(&pool_shrink_rwsem);
 
 	return num_pages;
 }
@@ -572,6 +575,18 @@ void ttm_pool_init(struct ttm_pool *pool, struct device *dev,
 }
 EXPORT_SYMBOL(ttm_pool_init);
 
+/**
+ * synchronize_shrinkers - Wait for all running shrinkers to complete.
+ *
+ * This is useful to guarantee that all shrinker invocations have seen an
+ * update, before freeing memory, similar to rcu.
+ */
+static void synchronize_shrinkers(void)
+{
+	down_write(&pool_shrink_rwsem);
+	up_write(&pool_shrink_rwsem);
+}
+
 /**
  * ttm_pool_fini - Cleanup a pool
  *
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index e464b4e9be0e..23ea9360c5d8 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -105,8 +105,6 @@ void shrinker_free_non_registered(struct shrinker *shrinker);
 void shrinker_register(struct shrinker *shrinker);
 void shrinker_unregister(struct shrinker *shrinker);
 
-extern void synchronize_shrinkers(void);
-
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
 extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 2f3635ad1b45..3c4d3fe2fa17 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -660,18 +660,3 @@ void shrinker_unregister(struct shrinker *shrinker)
 	kfree(shrinker);
 }
 EXPORT_SYMBOL(shrinker_unregister);
-
-/**
- * synchronize_shrinkers - Wait for all running shrinkers to complete.
- *
- * This is equivalent to calling unregister_shrink() and register_shrinker(),
- * but atomically and with less overhead. This is useful to guarantee that all
- * shrinker invocations have seen an update, before freeing memory, similar to
- * rcu.
- */
-void synchronize_shrinkers(void)
-{
-	down_write(&shrinker_rwsem);
-	up_write(&shrinker_rwsem);
-}
-EXPORT_SYMBOL(synchronize_shrinkers);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

