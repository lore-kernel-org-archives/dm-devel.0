Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2501EB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687497994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3rdkDBS6MNAcMIl4tMXUvujO3MqrNocZ46LVgZme9jc=;
	b=BOWgk607DHBE/6vpgyQeahthWbMy3JR3xlL38dT7HCsc8nIabrNcG7oEyYmFI2wjCFpohr
	jXfhL2x6JTVm2vVOyRgKCclaBi+uR6E1pbD11ku1U589ja/hAEtmk3ExS4Pk8cTqHlp3ND
	itZoH68PWGvl1IZWplyz3VrDks3NbMA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-WWvQmIrONO2o_XS9BWhCZA-1; Fri, 23 Jun 2023 01:26:22 -0400
X-MC-Unique: WWvQmIrONO2o_XS9BWhCZA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 756AF1C07599;
	Fri, 23 Jun 2023 05:26:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6245B492CAD;
	Fri, 23 Jun 2023 05:26:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3B5A19543BB;
	Fri, 23 Jun 2023 05:25:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 341891946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:55:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DED5425356; Thu, 22 Jun 2023 08:55:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0640340D1A4
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:55:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEFAD8C5860
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:55:02 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-Upfa1qKiPCqTi04s05aWkw-1; Thu, 22 Jun 2023 04:55:00 -0400
X-MC-Unique: Upfa1qKiPCqTi04s05aWkw-1
Received: by mail-pl1-f169.google.com with SMTP id
 d9443c01a7336-1b5585e84b4so6827215ad.0
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 01:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687424099; x=1690016099;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=8pXD3DmjPUfWk2+jjA+m+4zKKy0fC+8AwUsZhq2lRmk=;
 b=UBmlm6wVigk5K5w+HSa+aHpH4GH8vfJ5+D0yU7L+6g+Nir8kxbkzhNIfJraIOtOfYV
 877pp/kIapDZ0fAJ4AwBlt438lGwlBWEgo3Qh2fUMHco9XFJp1ZjOO5fsVhU3lwOOMEB
 aw5fwe1dZrZJNbGO0aRJajFUiw1o4Y3V9XIOvUDJ+zyM4hXju5f7IoDGdM/nXL8wThNK
 yXrZdB5/DKGtWXeNY2xxG7ydhgDhaLtuuLX0Xd5lDKp0esJ2TreB0L1v77r8tAXCzgt3
 PEx+syPU0qhu+PI1fOCDS77QD5p4gw8gSQzH6F1edZC7L13Vdz00hjaK3UOeSOt1QdNQ
 rwBA==
X-Gm-Message-State: AC+VfDzaI88s9h1r/gqUQ0bZswkmOaHFP3mb9jDIqchd2yoIra/TzxOx
 zuF/SocSOhivprf/S1OnjyWVuQ==
X-Google-Smtp-Source: ACHHUZ6uW4WhSYRgUY2aQCit4ogoH8R/r57rghu14Eyu6d6WG0AvLb+rcmWHNr1Voea08aO5tIYo3Q==
X-Received: by 2002:a17:902:ecc6:b0:1ae:1364:6086 with SMTP id
 a6-20020a170902ecc600b001ae13646086mr21600250plh.2.1687424099018; 
 Thu, 22 Jun 2023 01:54:59 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.54.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 01:54:58 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 16:53:13 +0800
Message-Id: <20230622085335.77010-8-zhengqi.arch@bytedance.com>
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
Subject: [dm-devel] [PATCH 07/29] dm zoned: dynamically allocate the
 dm-zoned-meta shrinker
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the dm-zoned-meta shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct dmz_metadata.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/md/dm-zoned-metadata.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 9d3cca8e3dc9..41b10ffb968a 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -187,7 +187,7 @@ struct dmz_metadata {
 	struct rb_root		mblk_rbtree;
 	struct list_head	mblk_lru_list;
 	struct list_head	mblk_dirty_list;
-	struct shrinker		mblk_shrinker;
+	struct shrinker		*mblk_shrinker;
 
 	/* Zone allocation management */
 	struct mutex		map_lock;
@@ -615,7 +615,7 @@ static unsigned long dmz_shrink_mblock_cache(struct dmz_metadata *zmd,
 static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
 					       struct shrink_control *sc)
 {
-	struct dmz_metadata *zmd = container_of(shrink, struct dmz_metadata, mblk_shrinker);
+	struct dmz_metadata *zmd = shrink->private_data;
 
 	return atomic_read(&zmd->nr_mblks);
 }
@@ -626,7 +626,7 @@ static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
 static unsigned long dmz_mblock_shrinker_scan(struct shrinker *shrink,
 					      struct shrink_control *sc)
 {
-	struct dmz_metadata *zmd = container_of(shrink, struct dmz_metadata, mblk_shrinker);
+	struct dmz_metadata *zmd = shrink->private_data;
 	unsigned long count;
 
 	spin_lock(&zmd->mblk_lock);
@@ -2936,17 +2936,22 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	 */
 	zmd->min_nr_mblks = 2 + zmd->nr_map_blocks + zmd->zone_nr_bitmap_blocks * 16;
 	zmd->max_nr_mblks = zmd->min_nr_mblks + 512;
-	zmd->mblk_shrinker.count_objects = dmz_mblock_shrinker_count;
-	zmd->mblk_shrinker.scan_objects = dmz_mblock_shrinker_scan;
-	zmd->mblk_shrinker.seeks = DEFAULT_SEEKS;
+
+	zmd->mblk_shrinker = shrinker_alloc_and_init(dmz_mblock_shrinker_count,
+						     dmz_mblock_shrinker_scan,
+						     0, DEFAULT_SEEKS, 0, zmd);
+	if (!zmd->mblk_shrinker) {
+		dmz_zmd_err(zmd, "allocate metadata cache shrinker failed");
+		goto err;
+	}
 
 	/* Metadata cache shrinker */
-	ret = register_shrinker(&zmd->mblk_shrinker, "dm-zoned-meta:(%u:%u)",
+	ret = register_shrinker(zmd->mblk_shrinker, "dm-zoned-meta:(%u:%u)",
 				MAJOR(dev->bdev->bd_dev),
 				MINOR(dev->bdev->bd_dev));
 	if (ret) {
 		dmz_zmd_err(zmd, "Register metadata cache shrinker failed");
-		goto err;
+		goto err_shrinker;
 	}
 
 	dmz_zmd_info(zmd, "DM-Zoned metadata version %d", zmd->sb_version);
@@ -2982,6 +2987,8 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	*metadata = zmd;
 
 	return 0;
+err_shrinker:
+	shrinker_free(zmd->mblk_shrinker);
 err:
 	dmz_cleanup_metadata(zmd);
 	kfree(zmd);
@@ -2995,7 +3002,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
  */
 void dmz_dtr_metadata(struct dmz_metadata *zmd)
 {
-	unregister_shrinker(&zmd->mblk_shrinker);
+	unregister_and_free_shrinker(zmd->mblk_shrinker);
 	dmz_cleanup_metadata(zmd);
 	kfree(zmd);
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

