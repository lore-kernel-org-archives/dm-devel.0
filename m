Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F4313C672
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 01:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218150; cv=none; b=SCvScZ8h9s7ghqGiJjpoLMobf5nUOMaVcB4STWfqpHRWE5+C+f7+vGt3qhdq1L4FROPsnRIzqGHq5pPQMCoaUUQ+5PDT3rdZDtv5n0TrYW+hhR7EcXOScmCXE75BpRDVyeDWllybMEWsUHdRzILA/qvx/+Dxlp1grxAVOQSaUqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218150; c=relaxed/simple;
	bh=dZUWovCd9fNOy2fyKYX2nZD0pt4n2TnyvzaT97C5lno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I1usAZvZwHQf3WN6uKpoC8fZj8P1a6aO09LCs2RnF7EajwEsbKFn9uuebMzVunGT6aeInwi73yKSDlM/8sOD6JIlkd7rZngKcrjMSziWFNPmIxuuD84LaNmXTaWZLYLjnohLNv099n5yD2LI9dfn5VixjlkHrx5T10YldFbqkfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VZZD92fv5z4f3jYQ
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:28:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id AE0071A016E
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:29:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDeJjxm5MuXMA--.59814S8;
	Thu, 09 May 2024 09:29:05 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.10 4/9] md: factor out helper to start reshape from action_store()
Date: Thu,  9 May 2024 09:18:55 +0800
Message-Id: <20240509011900.2694291-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDeJjxm5MuXMA--.59814S8
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF1kJF1UtrW7tw4xWFg_yoWrGF17pa
	yftFn5ArW5JrW3Xw4UJF1DuayFgr1xtrZrtrW7W34fJF1fKrn7G3WYga1UJr98ta4rAr4Y
	qa1DtFW5CFWj9aUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF18B
	UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, just to make code cleaner and prepare
for following refactor.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 67 +++++++++++++++++++++++++++++++------------------
 drivers/md/md.h |  2 +-
 2 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48ec35342d1b..7600da89d909 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4914,7 +4914,7 @@ enum sync_action md_sync_action(struct mddev *mddev)
 	return ACTION_IDLE;
 }
 
-enum sync_action md_sync_action_by_name(char *page)
+enum sync_action md_sync_action_by_name(const char *page)
 {
 	enum sync_action action;
 
@@ -5055,6 +5055,45 @@ static void frozen_sync_thread(struct mddev *mddev)
 	mutex_unlock(&mddev->sync_mutex);
 }
 
+static int mddev_start_reshape(struct mddev *mddev)
+{
+	int ret;
+
+	if (mddev->pers->start_reshape == NULL)
+		return -EINVAL;
+
+	ret = mddev_lock(mddev);
+	if (ret)
+		return ret;
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		mddev_unlock(mddev);
+		return -EBUSY;
+	}
+
+	if (mddev->reshape_position == MaxSector ||
+	    mddev->pers->check_reshape == NULL ||
+	    mddev->pers->check_reshape(mddev)) {
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		ret = mddev->pers->start_reshape(mddev);
+		if (ret) {
+			mddev_unlock(mddev);
+			return ret;
+		}
+	} else {
+		/*
+		 * If reshape is still in progress, and md_check_recovery() can
+		 * continue to reshape, don't restart reshape because data can
+		 * be corrupted for raid456.
+		 */
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	}
+
+	mddev_unlock(mddev);
+	sysfs_notify_dirent_safe(mddev->sysfs_degraded);
+	return 0;
+}
+
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
@@ -5074,32 +5113,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	} else if (cmd_match(page, "reshape")) {
-		int err;
-		if (mddev->pers->start_reshape == NULL)
-			return -EINVAL;
-		err = mddev_lock(mddev);
-		if (!err) {
-			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-				err =  -EBUSY;
-			} else if (mddev->reshape_position == MaxSector ||
-				   mddev->pers->check_reshape == NULL ||
-				   mddev->pers->check_reshape(mddev)) {
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-				err = mddev->pers->start_reshape(mddev);
-			} else {
-				/*
-				 * If reshape is still in progress, and
-				 * md_check_recovery() can continue to reshape,
-				 * don't restart reshape because data can be
-				 * corrupted for raid456.
-				 */
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-			}
-			mddev_unlock(mddev);
-		}
+		int err = mddev_start_reshape(mddev);
+
 		if (err)
 			return err;
-		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 	} else {
 		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 72ca7a796df5..cf54870e89db 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -865,7 +865,7 @@ extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
 extern enum sync_action md_sync_action(struct mddev *mddev);
-extern enum sync_action md_sync_action_by_name(char *page);
+extern enum sync_action md_sync_action_by_name(const char *page);
 extern char *md_sync_action_name(enum sync_action action);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
-- 
2.39.2

