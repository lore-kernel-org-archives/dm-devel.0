Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F74C001DE
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687497967;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RaQK5jg7qvukYHMUqUilCsoSb4vfKEZdNJqG4ZOWDww=;
	b=Jc23AbTuZ3Qk7UDypZ2W9f9i9snB+/tvD/mnU/JkWYIwzj7vtfvwQ58vWnBJ5TEV1GKCju
	HpG8IlFpaCU7ah8BmmLZpD9oz8rMtzmvyzzqcDoLYNeatavjhSDYRMvepdhA1rst67oOCU
	ifrD3TVm4vPWMFmGN9ncb1AGHxdfWYM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-SqlppqlcMfyyAFgvO4F_xA-1; Fri, 23 Jun 2023 01:26:03 -0400
X-MC-Unique: SqlppqlcMfyyAFgvO4F_xA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2DE73849534;
	Fri, 23 Jun 2023 05:25:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B05404067589;
	Fri, 23 Jun 2023 05:25:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5354A1949741;
	Fri, 23 Jun 2023 05:25:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39D2B1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:55:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21C7F2166B33; Thu, 22 Jun 2023 08:54:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 18AB62166B32
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:54:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECF638C5863
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:54:55 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-aixqUz1aM0WhxG8GABvIyw-1; Thu, 22 Jun 2023 04:54:52 -0400
X-MC-Unique: aixqUz1aM0WhxG8GABvIyw-1
Received: by mail-pf1-f175.google.com with SMTP id
 d2e1a72fcca58-6664ac3be47so1328445b3a.0
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 01:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687424091; x=1690016091;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=161EjO+w9TmzA/a8qJytM8fXp/e7+Gx/R5PIlDH2uAk=;
 b=bm50DN/MUYbbjPkrxgL2j71Ca/mX4U4tWPLNnWu4x8Xy67j58ZdA3obUKy6lsLXXbB
 4LstDzzIiskmOGva4E6XJuuFMqVUCqHCgKDIowWNN9r/FM/vuwXny3pJOTLdBGQ2SEhS
 yf5+7RW08adHQHG6QmzrwkDes/xo5rQN1c59/EyfjIAOjmz4DwM2fq/7mb7Rg3DQyf7a
 /Njpu04OCtDEwbyVU7o/66IuUE9zSPwaqBKnUPPfO6gZhqtMyLDQ0TPZnYWxIJxbZtrM
 QClw+x6ARqjGorZDhhvFyob0zgPn5JEWYyzdoI61I/oITM8NzGIkZBZjoXmjN4qzNJNq
 fDew==
X-Gm-Message-State: AC+VfDwVHFFyFaRxyPtFw1muFF2EEc/iy8KwL79e1OQA6a32Vw5H7NxZ
 /4DDK9I2tHfejearvGwzwr+DIg==
X-Google-Smtp-Source: ACHHUZ6Zp8ahuhiEYJqMKGH6XvbaL5lpWamc0XC/4KRVYsGWUu1w4+GFAcXsiV5/9t8MrDqgvh99eg==
X-Received: by 2002:a17:902:ea01:b0:1b3:e842:40a7 with SMTP id
 s1-20020a170902ea0100b001b3e84240a7mr20959635plg.1.1687424091188; 
 Thu, 22 Jun 2023 01:54:51 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.54.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 01:54:50 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 16:53:12 +0800
Message-Id: <20230622085335.77010-7-zhengqi.arch@bytedance.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 06/29] dm: dynamically allocate the dm-bufio
 shrinker
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
we need to dynamically allocate the dm-bufio shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct dm_bufio_client.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/md/dm-bufio.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index eea977662e81..9472470d456d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -963,7 +963,7 @@ struct dm_bufio_client {
 
 	sector_t start;
 
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 	struct work_struct shrink_work;
 	atomic_long_t need_shrink;
 
@@ -2385,7 +2385,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
 {
 	struct dm_bufio_client *c;
 
-	c = container_of(shrink, struct dm_bufio_client, shrinker);
+	c = shrink->private_data;
 	atomic_long_add(sc->nr_to_scan, &c->need_shrink);
 	queue_work(dm_bufio_wq, &c->shrink_work);
 
@@ -2394,7 +2394,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
 
 static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
+	struct dm_bufio_client *c = shrink->private_data;
 	unsigned long count = cache_total(&c->cache);
 	unsigned long retain_target = get_retain_buffers(c);
 	unsigned long queued_for_cleanup = atomic_long_read(&c->need_shrink);
@@ -2507,14 +2507,15 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	INIT_WORK(&c->shrink_work, shrink_work);
 	atomic_long_set(&c->need_shrink, 0);
 
-	c->shrinker.count_objects = dm_bufio_shrink_count;
-	c->shrinker.scan_objects = dm_bufio_shrink_scan;
-	c->shrinker.seeks = 1;
-	c->shrinker.batch = 0;
-	r = register_shrinker(&c->shrinker, "dm-bufio:(%u:%u)",
+	c->shrinker = shrinker_alloc_and_init(dm_bufio_shrink_count,
+					      dm_bufio_shrink_scan, 0, 1, 0, c);
+	if (!c->shrinker)
+		goto bad;
+
+	r = register_shrinker(c->shrinker, "dm-bufio:(%u:%u)",
 			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 	if (r)
-		goto bad;
+		goto bad_shrinker;
 
 	mutex_lock(&dm_bufio_clients_lock);
 	dm_bufio_client_count++;
@@ -2524,6 +2525,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 	return c;
 
+bad_shrinker:
+	shrinker_free(c->shrinker);
 bad:
 	while (!list_empty(&c->reserved_buffers)) {
 		struct dm_buffer *b = list_to_buffer(c->reserved_buffers.next);
@@ -2554,7 +2557,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 
 	drop_buffers(c);
 
-	unregister_shrinker(&c->shrinker);
+	unregister_and_free_shrinker(c->shrinker);
 	flush_work(&c->shrink_work);
 
 	mutex_lock(&dm_bufio_clients_lock);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

