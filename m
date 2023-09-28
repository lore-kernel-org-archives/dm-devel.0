Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D77CE7B05
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695883511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AWMDTJt+vvCuIGClijx/lpDNn4QGWTW256egwsRWAU4=;
	b=PUMqj+EoTl5ttuaq0iGVxqX8wqSbU+TiT5w5/9Oaps3sRDDRwu6Ku59EOfijcUSL3YbHmi
	wMQhng0jZDVzK/iVGInKql7T/U8JixMIDp5KAN6/bmyxu4SigQvNw+OCzc5qJWNhrqDycm
	fImfFqFwHTEPiJ2yjLWyZ5W7soC0p84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-yJujaKdJPoqbeN9xuVDV4g-1; Thu, 28 Sep 2023 02:45:08 -0400
X-MC-Unique: yJujaKdJPoqbeN9xuVDV4g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C856080353A;
	Thu, 28 Sep 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B32A5400F36;
	Thu, 28 Sep 2023 06:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F64519466EC;
	Thu, 28 Sep 2023 06:45:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 494451946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2735840C2070; Thu, 28 Sep 2023 06:22:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F25040C2064
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:10 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E23538001EA
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:09 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-1ivHSbOhOVaxEH1qLx2JYQ-1; Thu, 28 Sep 2023 02:22:05 -0400
X-MC-Unique: 1ivHSbOhOVaxEH1qLx2JYQ-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kf44ydz4f3lCr;
 Thu, 28 Sep 2023 14:21:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S14;
 Thu, 28 Sep 2023 14:22:00 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:28 +0800
Message-Id: <20230928061543.1845742-11-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S14
X-Coremail-Antispam: 1UD129KBjvJXoWxKFWxtrWftFWkCF1xJw1UWrg_yoWxKrWfpa
 93ta43Xr4kJr9YvFnrCF4DuF4Sg3yv93s7JrW3Ga9ayF9a9rW8Ja4fJry3ZFyrJFy8CrWf
 WrZ8tryUWrn7Ar7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
 0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
 SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH -next v3 10/25] md/raid5-cache: use
 READ_ONCE/WRITE_ONCE for 'conf->log'
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

'conf->log' is set with 'reconfig_mutex' grabbed, however, readers are
not procted, hence use READ_ONCE/WRITE_ONCE to prevent reading abnormal
value.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5-cache.c | 47 +++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 518b7cfa78b9..889bba60d6ff 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -327,8 +327,9 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 void r5c_check_stripe_cache_usage(struct r5conf *conf)
 {
 	int total_cached;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
-	if (!r5c_is_writeback(conf->log))
+	if (!r5c_is_writeback(log))
 		return;
 
 	total_cached = atomic_read(&conf->r5c_cached_partial_stripes) +
@@ -344,7 +345,7 @@ void r5c_check_stripe_cache_usage(struct r5conf *conf)
 	 */
 	if (total_cached > conf->min_nr_stripes * 1 / 2 ||
 	    atomic_read(&conf->empty_inactive_list_nr) > 0)
-		r5l_wake_reclaim(conf->log, 0);
+		r5l_wake_reclaim(log, 0);
 }
 
 /*
@@ -353,7 +354,9 @@ void r5c_check_stripe_cache_usage(struct r5conf *conf)
  */
 void r5c_check_cached_full_stripe(struct r5conf *conf)
 {
-	if (!r5c_is_writeback(conf->log))
+	struct r5l_log *log = READ_ONCE(conf->log);
+
+	if (!r5c_is_writeback(log))
 		return;
 
 	/*
@@ -363,7 +366,7 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
 	if (atomic_read(&conf->r5c_cached_full_stripes) >=
 	    min(R5C_FULL_STRIPE_FLUSH_BATCH(conf),
 		conf->chunk_sectors >> RAID5_STRIPE_SHIFT(conf)))
-		r5l_wake_reclaim(conf->log, 0);
+		r5l_wake_reclaim(log, 0);
 }
 
 /*
@@ -396,7 +399,7 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
  */
 static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	if (!r5c_is_writeback(log))
 		return 0;
@@ -449,7 +452,7 @@ static inline void r5c_update_log_state(struct r5l_log *log)
 void r5c_make_stripe_write_out(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	BUG_ON(!r5c_is_writeback(log));
 
@@ -491,7 +494,7 @@ static void r5c_handle_parity_cached(struct stripe_head *sh)
  */
 static void r5c_finish_cache_stripe(struct stripe_head *sh)
 {
-	struct r5l_log *log = sh->raid_conf->log;
+	struct r5l_log *log = READ_ONCE(sh->raid_conf->log);
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
 		BUG_ON(test_bit(STRIPE_R5C_CACHING, &sh->state));
@@ -692,7 +695,7 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 
 	/* wait superblock change before suspend */
 	wait_event(mddev->sb_wait,
-		   conf->log == NULL ||
+		   !READ_ONCE(conf->log) ||
 		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
 		    (locked = mddev_trylock(mddev))));
 	if (locked) {
@@ -1151,7 +1154,7 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 static sector_t r5c_calculate_new_cp(struct r5conf *conf)
 {
 	struct stripe_head *sh;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	sector_t new_cp;
 	unsigned long flags;
 
@@ -1159,12 +1162,12 @@ static sector_t r5c_calculate_new_cp(struct r5conf *conf)
 		return log->next_checkpoint;
 
 	spin_lock_irqsave(&log->stripe_in_journal_lock, flags);
-	if (list_empty(&conf->log->stripe_in_journal_list)) {
+	if (list_empty(&log->stripe_in_journal_list)) {
 		/* all stripes flushed */
 		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
 		return log->next_checkpoint;
 	}
-	sh = list_first_entry(&conf->log->stripe_in_journal_list,
+	sh = list_first_entry(&log->stripe_in_journal_list,
 			      struct stripe_head, r5c);
 	new_cp = sh->log_start;
 	spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
@@ -1399,7 +1402,7 @@ void r5c_flush_cache(struct r5conf *conf, int num)
 	struct stripe_head *sh, *next;
 
 	lockdep_assert_held(&conf->device_lock);
-	if (!conf->log)
+	if (!READ_ONCE(conf->log))
 		return;
 
 	count = 0;
@@ -1420,7 +1423,7 @@ void r5c_flush_cache(struct r5conf *conf, int num)
 
 static void r5c_do_reclaim(struct r5conf *conf)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	struct stripe_head *sh;
 	int count = 0;
 	unsigned long flags;
@@ -1549,7 +1552,7 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 {
 	struct mddev *mddev = thread->mddev;
 	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	if (!log)
 		return;
@@ -1591,7 +1594,7 @@ void r5l_quiesce(struct r5l_log *log, int quiesce)
 
 bool r5l_log_disk_error(struct r5conf *conf)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	/* don't allow write if journal disk is missing */
 	if (!log)
@@ -2635,7 +2638,7 @@ int r5c_try_caching_write(struct r5conf *conf,
 			  struct stripe_head_state *s,
 			  int disks)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	int i;
 	struct r5dev *dev;
 	int to_cache = 0;
@@ -2802,7 +2805,7 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 				 struct stripe_head *sh,
 				 struct stripe_head_state *s)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	int i;
 	int do_wakeup = 0;
 	sector_t tree_index;
@@ -2941,7 +2944,7 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 /* check whether this big stripe is in write back cache. */
 bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	sector_t tree_index;
 	void *slot;
 
@@ -3049,14 +3052,14 @@ int r5l_start(struct r5l_log *log)
 void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	if (!log)
 		return;
 
 	if ((raid5_calc_degraded(conf) > 0 ||
 	     test_bit(Journal, &rdev->flags)) &&
-	    conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK)
+	    log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		schedule_work(&log->disable_writeback_work);
 }
 
@@ -3145,7 +3148,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->stripe_in_journal_lock);
 	atomic_set(&log->stripe_in_journal_count, 0);
 
-	conf->log = log;
+	WRITE_ONCE(conf->log, log);
 
 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
@@ -3173,7 +3176,7 @@ void r5l_exit_log(struct r5conf *conf)
 	 * 'reconfig_mutex' is held by caller, set 'confg->log' to NULL to
 	 * ensure disable_writeback_work wakes up and exits.
 	 */
-	conf->log = NULL;
+	WRITE_ONCE(conf->log, NULL);
 	wake_up(&conf->mddev->sb_wait);
 	flush_work(&log->disable_writeback_work);
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

