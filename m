Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC9F215077
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851969; cv=none; b=p2QrZAyf9nNTow5GYvx+7btZ+eIrr4WLYPqpR1gvGoHhaj0r/2JbCzZ93YPdUHeIQFSzOkGjGQIYHA0BycfhzHhsSzCHVKOA+irPwbUhjngCUKo/wZTMTU+YLYDJ1GQLsqwKt3bpCm9HtvneoAMq4dXmAx+UoB4eBPAY2MGcp+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851969; c=relaxed/simple;
	bh=PxYJXAj9m/swhM5aTKx6c87k0wGPrha0EvV/hJPHspc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I0VbXGIFtgjSg3cs+wwC2Jzr1x73MacK9P3Du1U3ej7OH/AVxLnnICweHISO5eAdjK70tj8sPQiwvhOwqyNEfQHpdZ2k/APif37Mjk5HoLy8cSUwUpwz7hIAGP+HHwvCEbDDnmqtPBNo+YOzpSSfoVPMLF62Fedrvk9sgZU6mQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dm2LsmzKHMjD
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C3F7C1A08FF
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S6;
	Mon, 07 Jul 2025 09:32:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 02/15] md/raid1: remove struct pool_info and related code
Date: Mon,  7 Jul 2025 09:26:58 +0800
Message-Id: <20250707012711.376844-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250707012711.376844-1-yukuai1@huaweicloud.com>
References: <20250707012711.376844-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S6
X-Coremail-Antispam: 1UD129KBjvJXoW3JryDCw4xGrW3XFy8Zr1rtFb_yoW3Cr43pa
	13Was3ZF4UXrZ3WrWkJF4DuFWY9w4xWay8GFs7Ga1FvF9aqr9aqa1jyFyFgry8ZrZ8Kw1D
	AFn8trW3AF1UKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUQXo7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The struct pool_info was originally introduced mainly to support reshape
operations, serving as a parameter for mempool_init() when raid_disks
changes. Now that mempool_create_kmalloc_pool() is sufficient for this
purpose, struct pool_info and its related code are no longer needed.

Remove struct pool_info and all associated code.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 49 +++++++++++++---------------------------------
 drivers/md/raid1.h | 20 -------------------
 2 files changed, 14 insertions(+), 55 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8249cbb89fec..3a31e230727c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -127,10 +127,9 @@ static inline struct r1bio *get_resync_r1bio(struct bio *bio)
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1bio_pool_alloc(gfp_t gfp_flags, struct r1conf *conf)
 {
-	struct pool_info *pi = data;
-	int size = offsetof(struct r1bio, bios[pi->raid_disks]);
+	int size = offsetof(struct r1bio, bios[conf->raid_disks * 2]);
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
 	return kzalloc(size, gfp_flags);
@@ -145,18 +144,18 @@ static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
-	struct pool_info *pi = data;
+	struct r1conf *conf = data;
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int need_pages;
 	int j;
 	struct resync_pages *rps;
 
-	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
+	r1_bio = r1bio_pool_alloc(gfp_flags, conf);
 	if (!r1_bio)
 		return NULL;
 
-	rps = kmalloc_array(pi->raid_disks, sizeof(struct resync_pages),
+	rps = kmalloc_array(conf->raid_disks * 2, sizeof(struct resync_pages),
 			    gfp_flags);
 	if (!rps)
 		goto out_free_r1bio;
@@ -164,7 +163,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
-	for (j = pi->raid_disks ; j-- ; ) {
+	for (j = conf->raid_disks * 2; j-- ; ) {
 		bio = bio_kmalloc(RESYNC_PAGES, gfp_flags);
 		if (!bio)
 			goto out_free_bio;
@@ -177,11 +176,11 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	 * If this is a user-requested check/repair, allocate
 	 * RESYNC_PAGES for each bio.
 	 */
-	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery))
-		need_pages = pi->raid_disks;
+	if (test_bit(MD_RECOVERY_REQUESTED, &conf->mddev->recovery))
+		need_pages = conf->raid_disks * 2;
 	else
 		need_pages = 1;
-	for (j = 0; j < pi->raid_disks; j++) {
+	for (j = 0; j < conf->raid_disks * 2; j++) {
 		struct resync_pages *rp = &rps[j];
 
 		bio = r1_bio->bios[j];
@@ -207,7 +206,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		resync_free_pages(&rps[j]);
 
 out_free_bio:
-	while (++j < pi->raid_disks) {
+	while (++j < conf->raid_disks * 2) {
 		bio_uninit(r1_bio->bios[j]);
 		kfree(r1_bio->bios[j]);
 	}
@@ -220,12 +219,12 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
-	struct pool_info *pi = data;
+	struct r1conf *conf = data;
 	int i;
 	struct r1bio *r1bio = __r1_bio;
 	struct resync_pages *rp = NULL;
 
-	for (i = pi->raid_disks; i--; ) {
+	for (i = conf->raid_disks * 2; i--; ) {
 		rp = get_resync_pages(r1bio->bios[i]);
 		resync_free_pages(rp);
 		bio_uninit(r1bio->bios[i]);
@@ -2745,7 +2744,7 @@ static int init_resync(struct r1conf *conf)
 	BUG_ON(mempool_initialized(&conf->r1buf_pool));
 
 	return mempool_init(&conf->r1buf_pool, buffs, r1buf_pool_alloc,
-			    r1buf_pool_free, conf->poolinfo);
+			    r1buf_pool_free, conf);
 }
 
 static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
@@ -2755,7 +2754,7 @@ static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
 	struct bio *bio;
 	int i;
 
-	for (i = conf->poolinfo->raid_disks; i--; ) {
+	for (i = conf->raid_disks * 2; i--; ) {
 		bio = r1bio->bios[i];
 		rps = bio->bi_private;
 		bio_reset(bio, NULL, 0);
@@ -3120,11 +3119,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto abort;
 
-	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
-	if (!conf->poolinfo)
-		goto abort;
-	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-
 	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
 	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS, r1bio_size);
 	if (!conf->r1bio_pool)
@@ -3134,8 +3128,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (err)
 		goto abort;
 
-	conf->poolinfo->mddev = mddev;
-
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	conf->raid_disks = mddev->raid_disks;
@@ -3201,7 +3193,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
-		kfree(conf->poolinfo);
 		kfree(conf->nr_pending);
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
@@ -3314,7 +3305,6 @@ static void raid1_free(struct mddev *mddev, void *priv)
 	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
-	kfree(conf->poolinfo);
 	kfree(conf->nr_pending);
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
@@ -3368,7 +3358,6 @@ static int raid1_reshape(struct mddev *mddev)
 	 * devices have the higher raid_disk numbers.
 	 */
 	mempool_t *newpool, *oldpool;
-	struct pool_info *newpoolinfo;
 	size_t new_r1bio_size;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
@@ -3400,23 +3389,15 @@ static int raid1_reshape(struct mddev *mddev)
 			return -EBUSY;
 	}
 
-	newpoolinfo = kmalloc(sizeof(*newpoolinfo), GFP_KERNEL);
-	if (!newpoolinfo)
-		return -ENOMEM;
-	newpoolinfo->mddev = mddev;
-	newpoolinfo->raid_disks = raid_disks * 2;
-
 	new_r1bio_size = offsetof(struct r1bio, bios[raid_disks * 2]);
 	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
 	if (!newpool) {
-		kfree(newpoolinfo);
 		return -ENOMEM;
 	}
 	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
 					 raid_disks, 2),
 			     GFP_KERNEL);
 	if (!newmirrors) {
-		kfree(newpoolinfo);
 		mempool_destroy(newpool);
 		return -ENOMEM;
 	}
@@ -3442,8 +3423,6 @@ static int raid1_reshape(struct mddev *mddev)
 	}
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
-	kfree(conf->poolinfo);
-	conf->poolinfo = newpoolinfo;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	mddev->degraded += (raid_disks - conf->raid_disks);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 652c347b1a70..d236ef179cfb 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -49,22 +49,6 @@ struct raid1_info {
 	sector_t	seq_start;
 };
 
-/*
- * memory pools need a pointer to the mddev, so they can force an unplug
- * when memory is tight, and a count of the number of drives that the
- * pool was allocated for, so they know how much to allocate and free.
- * mddev->raid_disks cannot be used, as it can change while a pool is active
- * These two datums are stored in a kmalloced struct.
- * The 'raid_disks' here is twice the raid_disks in r1conf.
- * This allows space for each 'real' device can have a replacement in the
- * second half of the array.
- */
-
-struct pool_info {
-	struct mddev *mddev;
-	int	raid_disks;
-};
-
 struct r1conf {
 	struct mddev		*mddev;
 	struct raid1_info	*mirrors;	/* twice 'raid_disks' to
@@ -114,10 +98,6 @@ struct r1conf {
 	 */
 	int			recovery_disabled;
 
-	/* poolinfo contains information about the content of the
-	 * mempools - it changes when the array grows or shrinks
-	 */
-	struct pool_info	*poolinfo;
 	mempool_t		*r1bio_pool;
 	mempool_t		r1buf_pool;
 
-- 
2.39.2

