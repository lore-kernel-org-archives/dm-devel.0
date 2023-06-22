Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A76C0015E
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687498009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CxcE1EaemCR5/R/y3/qwj0JV/P47LjGUKlerjotCnP0=;
	b=Qbl+xOiLrjJPbLadX4mghL0J34x2QDhMjkBzMSA0aj3G+85iYg4pswkYJOv4ne34dyW2S7
	tpyXacO0mVVaiFWypScy8EUVsm/U4ZVxLemwfJmi73STzUP08SZSMvOtzgxi9bXxDgq8GR
	yUnJyZQAwEZ2Lrl0wboTVE8UvwPYLpo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-W3vFUCOzM_G-AXqSu1Kh4Q-1; Fri, 23 Jun 2023 01:26:42 -0400
X-MC-Unique: W3vFUCOzM_G-AXqSu1Kh4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F38C8384952F;
	Fri, 23 Jun 2023 05:25:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E15B740C6CD1;
	Fri, 23 Jun 2023 05:25:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 26BD71949738;
	Fri, 23 Jun 2023 05:25:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 223971946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:41:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C88EE112132E; Thu, 22 Jun 2023 08:41:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C163B112132C
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:41:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A42F18AB380
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:41:02 +0000 (UTC)
Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com
 [95.215.58.39]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-kBkRh_SEPUCITWApHJcXNw-1; Thu, 22 Jun 2023 04:41:00 -0400
X-MC-Unique: kBkRh_SEPUCITWApHJcXNw-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 08:39:11 +0000
Message-Id: <20230622083932.4090339-9-qi.zheng@linux.dev>
In-Reply-To: <20230622083932.4090339-1-qi.zheng@linux.dev>
References: <20230622083932.4090339-1-qi.zheng@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 08/29] md/raid5: dynamically allocate the
 md-raid5 shrinker
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
 linux-ext4@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the md-raid5 shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct r5conf.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/md/raid5.c | 28 +++++++++++++++++-----------
 drivers/md/raid5.h |  2 +-
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f4eea1bbbeaf..4866cad1ad62 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7391,7 +7391,7 @@ static void free_conf(struct r5conf *conf)
 
 	log_exit(conf);
 
-	unregister_shrinker(&conf->shrinker);
+	unregister_and_free_shrinker(conf->shrinker);
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
@@ -7439,7 +7439,7 @@ static int raid5_alloc_percpu(struct r5conf *conf)
 static unsigned long raid5_cache_scan(struct shrinker *shrink,
 				      struct shrink_control *sc)
 {
-	struct r5conf *conf = container_of(shrink, struct r5conf, shrinker);
+	struct r5conf *conf = shrink->private_data;
 	unsigned long ret = SHRINK_STOP;
 
 	if (mutex_trylock(&conf->cache_size_mutex)) {
@@ -7460,7 +7460,7 @@ static unsigned long raid5_cache_scan(struct shrinker *shrink,
 static unsigned long raid5_cache_count(struct shrinker *shrink,
 				       struct shrink_control *sc)
 {
-	struct r5conf *conf = container_of(shrink, struct r5conf, shrinker);
+	struct r5conf *conf = shrink->private_data;
 
 	if (conf->max_nr_stripes < conf->min_nr_stripes)
 		/* unlikely, but not impossible */
@@ -7695,16 +7695,21 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	 * it reduces the queue depth and so can hurt throughput.
 	 * So set it rather large, scaled by number of devices.
 	 */
-	conf->shrinker.seeks = DEFAULT_SEEKS * conf->raid_disks * 4;
-	conf->shrinker.scan_objects = raid5_cache_scan;
-	conf->shrinker.count_objects = raid5_cache_count;
-	conf->shrinker.batch = 128;
-	conf->shrinker.flags = 0;
-	ret = register_shrinker(&conf->shrinker, "md-raid5:%s", mdname(mddev));
+	conf->shrinker = shrinker_alloc_and_init(raid5_cache_count,
+						 raid5_cache_scan, 128,
+						 DEFAULT_SEEKS * conf->raid_disks * 4,
+						 0, conf);
+	if (!conf->shrinker) {
+		pr_warn("md/raid:%s: couldn't allocate shrinker.\n",
+			mdname(mddev));
+		goto abort;
+	}
+
+	ret = register_shrinker(conf->shrinker, "md-raid5:%s", mdname(mddev));
 	if (ret) {
 		pr_warn("md/raid:%s: couldn't register shrinker.\n",
 			mdname(mddev));
-		goto abort;
+		goto abort_shrinker;
 	}
 
 	sprintf(pers_name, "raid%d", mddev->new_level);
@@ -7717,7 +7722,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	}
 
 	return conf;
-
+abort_shrinker:
+	shrinker_free(conf->shrinker);
  abort:
 	if (conf)
 		free_conf(conf);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6a92fafb0748..806f84681599 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -670,7 +670,7 @@ struct r5conf {
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	unsigned long		cache_state;
-	struct shrinker		shrinker;
+	struct shrinker		*shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

