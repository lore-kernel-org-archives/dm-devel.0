Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCD2C56201
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:32:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D4C03204EC
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:32:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4C03204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-HMoawYkINTepYysE7O2LAA-1; Tue, 24 Nov 2020 08:32:08 -0500
X-MC-Unique: HMoawYkINTepYysE7O2LAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D43C18C43C4;
	Tue, 24 Nov 2020 13:32:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B94E5D719;
	Tue, 24 Nov 2020 13:32:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F10FF1809CA1;
	Tue, 24 Nov 2020 13:32:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODVxvf018689 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:31:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3A1231003330; Tue, 24 Nov 2020 13:31:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35BB0100414F
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:31:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 237FA1875040
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:31:59 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-223-aq3szRtYPZKqTAEZ9uC0eg-1; Tue, 24 Nov 2020 08:31:53 -0500
X-MC-Unique: aq3szRtYPZKqTAEZ9uC0eg-1
Received: from [2001:4bb8:180:5443:c70:4a89:bc61:3] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1khYMx-0006bA-OT; Tue, 24 Nov 2020 13:28:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Nov 2020 14:27:30 +0100
Message-Id: <20201124132751.3747337-25-hch@lst.de>
In-Reply-To: <20201124132751.3747337-1-hch@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: [dm-devel] [PATCH 24/45] blk-cgroup: stop abusing get_gendisk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Properly open the device instead of relying on deep internals by
using get_gendisk.  Note that this uses FMODE_NDELAY without either
FMODE_READ or FMODE_WRITE, which is a special open mode to allow
for opening without media access, thus avoiding unexpexted interactions
especially on removable media.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c         | 42 +++++++++++++++++++-------------------
 block/blk-iocost.c         | 36 ++++++++++++++++----------------
 include/linux/blk-cgroup.h |  4 ++--
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 54fbe1e80cc41a..23437b96ea41e6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -556,22 +556,22 @@ static struct blkcg_gq *blkg_lookup_check(struct blkcg *blkcg,
 }
 
 /**
- * blkg_conf_prep - parse and prepare for per-blkg config update
+ * blkcg_conf_open_bdev - parse and open bdev for per-blkg config update
  * @inputp: input string pointer
  *
  * Parse the device node prefix part, MAJ:MIN, of per-blkg config update
- * from @input and get and return the matching gendisk.  *@inputp is
+ * from @input and get and return the matching bdev.  *@inputp is
  * updated to point past the device node prefix.  Returns an ERR_PTR()
  * value on error.
  *
  * Use this function iff blkg_conf_prep() can't be used for some reason.
  */
-struct gendisk *blkcg_conf_get_disk(char **inputp)
+struct block_device *blkcg_conf_open_bdev(char **inputp)
 {
 	char *input = *inputp;
 	unsigned int major, minor;
-	struct gendisk *disk;
-	int key_len, part;
+	struct block_device *bdev;
+	int key_len;
 
 	if (sscanf(input, "%u:%u%n", &major, &minor, &key_len) != 2)
 		return ERR_PTR(-EINVAL);
@@ -581,16 +581,16 @@ struct gendisk *blkcg_conf_get_disk(char **inputp)
 		return ERR_PTR(-EINVAL);
 	input = skip_spaces(input);
 
-	disk = get_gendisk(MKDEV(major, minor), &part);
-	if (!disk)
+	bdev = blkdev_get_by_dev(MKDEV(major, minor), FMODE_NDELAY, NULL);
+	if (!bdev)
 		return ERR_PTR(-ENODEV);
-	if (part) {
-		put_disk_and_module(disk);
+	if (bdev_is_partition(bdev)) {
+		blkdev_put(bdev, FMODE_NDELAY);
 		return ERR_PTR(-ENODEV);
 	}
 
 	*inputp = input;
-	return disk;
+	return bdev;
 }
 
 /**
@@ -607,18 +607,18 @@ struct gendisk *blkcg_conf_get_disk(char **inputp)
  */
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   char *input, struct blkg_conf_ctx *ctx)
-	__acquires(rcu) __acquires(&disk->queue->queue_lock)
+	__acquires(rcu) __acquires(&bdev->bd_disk->queue->queue_lock)
 {
-	struct gendisk *disk;
+	struct block_device *bdev;
 	struct request_queue *q;
 	struct blkcg_gq *blkg;
 	int ret;
 
-	disk = blkcg_conf_get_disk(&input);
-	if (IS_ERR(disk))
-		return PTR_ERR(disk);
+	bdev = blkcg_conf_open_bdev(&input);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
-	q = disk->queue;
+	q = bdev->bd_disk->queue;
 
 	rcu_read_lock();
 	spin_lock_irq(&q->queue_lock);
@@ -689,7 +689,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto success;
 	}
 success:
-	ctx->disk = disk;
+	ctx->bdev = bdev;
 	ctx->blkg = blkg;
 	ctx->body = input;
 	return 0;
@@ -700,7 +700,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	spin_unlock_irq(&q->queue_lock);
 	rcu_read_unlock();
 fail:
-	put_disk_and_module(disk);
+	blkdev_put(bdev, FMODE_NDELAY);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
 	 * short msleep().  It isn't strictly necessary but queue
@@ -723,11 +723,11 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
  * with blkg_conf_prep().
  */
 void blkg_conf_finish(struct blkg_conf_ctx *ctx)
-	__releases(&ctx->disk->queue->queue_lock) __releases(rcu)
+	__releases(&ctx->bdev->bd_disk->queue->queue_lock) __releases(rcu)
 {
-	spin_unlock_irq(&ctx->disk->queue->queue_lock);
+	spin_unlock_irq(&ctx->bdev->bd_disk->queue->queue_lock);
 	rcu_read_unlock();
-	put_disk_and_module(ctx->disk);
+	blkdev_put(ctx->bdev, FMODE_NDELAY);
 }
 EXPORT_SYMBOL_GPL(blkg_conf_finish);
 
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index bbe86d1199dc5b..9f219718e9813c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3120,23 +3120,23 @@ static const match_table_t qos_tokens = {
 static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 			     size_t nbytes, loff_t off)
 {
-	struct gendisk *disk;
+	struct block_device *bdev;
 	struct ioc *ioc;
 	u32 qos[NR_QOS_PARAMS];
 	bool enable, user;
 	char *p;
 	int ret;
 
-	disk = blkcg_conf_get_disk(&input);
-	if (IS_ERR(disk))
-		return PTR_ERR(disk);
+	bdev = blkcg_conf_open_bdev(&input);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
-	ioc = q_to_ioc(disk->queue);
+	ioc = q_to_ioc(bdev->bd_disk->queue);
 	if (!ioc) {
-		ret = blk_iocost_init(disk->queue);
+		ret = blk_iocost_init(bdev->bd_disk->queue);
 		if (ret)
 			goto err;
-		ioc = q_to_ioc(disk->queue);
+		ioc = q_to_ioc(bdev->bd_disk->queue);
 	}
 
 	spin_lock_irq(&ioc->lock);
@@ -3231,12 +3231,12 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
-	put_disk_and_module(disk);
+	blkdev_put(bdev, FMODE_NDELAY);
 	return nbytes;
 einval:
 	ret = -EINVAL;
 err:
-	put_disk_and_module(disk);
+	blkdev_put(bdev, FMODE_NDELAY);
 	return ret;
 }
 
@@ -3287,23 +3287,23 @@ static const match_table_t i_lcoef_tokens = {
 static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 				    size_t nbytes, loff_t off)
 {
-	struct gendisk *disk;
+	struct block_device *bdev;
 	struct ioc *ioc;
 	u64 u[NR_I_LCOEFS];
 	bool user;
 	char *p;
 	int ret;
 
-	disk = blkcg_conf_get_disk(&input);
-	if (IS_ERR(disk))
-		return PTR_ERR(disk);
+	bdev = blkcg_conf_open_bdev(&input);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
 
-	ioc = q_to_ioc(disk->queue);
+	ioc = q_to_ioc(bdev->bd_disk->queue);
 	if (!ioc) {
-		ret = blk_iocost_init(disk->queue);
+		ret = blk_iocost_init(bdev->bd_disk->queue);
 		if (ret)
 			goto err;
-		ioc = q_to_ioc(disk->queue);
+		ioc = q_to_ioc(bdev->bd_disk->queue);
 	}
 
 	spin_lock_irq(&ioc->lock);
@@ -3356,13 +3356,13 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
-	put_disk_and_module(disk);
+	blkdev_put(bdev, FMODE_NDELAY);
 	return nbytes;
 
 einval:
 	ret = -EINVAL;
 err:
-	put_disk_and_module(disk);
+	blkdev_put(bdev, FMODE_NDELAY);
 	return ret;
 }
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c8fc9792ac776d..b9f3c246c3c908 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -197,12 +197,12 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v);
 
 struct blkg_conf_ctx {
-	struct gendisk			*disk;
+	struct block_device		*bdev;
 	struct blkcg_gq			*blkg;
 	char				*body;
 };
 
-struct gendisk *blkcg_conf_get_disk(char **inputp);
+struct block_device *blkcg_conf_open_bdev(char **inputp);
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   char *input, struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

