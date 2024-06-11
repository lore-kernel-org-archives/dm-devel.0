Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA78B17CA1E
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112204; cv=none; b=k9yZKczqxs6z6JctHCFtYFAoyA65NzUCkzH4XhnniX9K9wxX1wQKJCST3j5AZ+Kgez368iq1ihhpzBqAZ1ELdj1OIneEQaKDA1CjKLY/uU8QBbUL68RdMnYOJ90W547fRYAy9ofUAAkvTB7/OWSnIEQ+/oeYfkeFNcNK4Gz8EfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112204; c=relaxed/simple;
	bh=DDkrz2i0JEe2gPELxEBAe6ARcT9lOu83O/Ruqy3iLME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mw03HgNQzw0xWzFiMC3GAtd42O3jLTyUz1VWyhDZ0U+we5re78fYC8PSWLA5eVsfzZNJ+X8G15W3mVXH/k5SRCTcvY8yfmjXmESSsCx7AwSqez36t8FIdz2q8P74Zqjh/Lyp37RYobNX4xSCq9YL3roX/YoraWi0rmYr8smklAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8Vz3GhBz4f3lfZ
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D9BAF1A016E
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S10;
	Tue, 11 Jun 2024 21:23:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 06/12] md: remove parameter check_seq for stop_sync_thread()
Date: Tue, 11 Jun 2024 21:22:45 +0800
Message-Id: <20240611132251.1967786-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S10
X-Coremail-Antispam: 1UD129KBjvJXoWxGF1ftw18tFW5Cw45GrWDXFb_yoWrJr4rpr
	WfXF98Ar4UArWfZrW7Ka4DZay5Zw1Iqa4DtFy3u3yfJ3Z3trsrGFyY93WUAFykGa4rX3Zx
	AayrJF4fZa4xGr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
	WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbmZ
	X7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Caller will always set MD_RECOVERY_FROZEN if check_seq is true, and
always clear MD_RECOVERY_FROZEN if check_seq is false, hence replace
the parameter with test_bit() to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d035cd52e49a..44cb18ec1c52 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4961,15 +4961,10 @@ action_show(struct mddev *mddev, char *page)
  * @locked:	if set, reconfig_mutex will still be held after this function
  *		return; if not set, reconfig_mutex will be released after this
  *		function return.
- * @check_seq:	if set, only wait for curent running sync_thread to stop, noted
- *		that new sync_thread can still start.
  */
-static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
+static void stop_sync_thread(struct mddev *mddev, bool locked)
 {
-	int sync_seq;
-
-	if (check_seq)
-		sync_seq = atomic_read(&mddev->sync_seq);
+	int sync_seq = atomic_read(&mddev->sync_seq);
 
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		if (!locked)
@@ -4990,7 +4985,8 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)));
+		   (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery) &&
+		    sync_seq != atomic_read(&mddev->sync_seq)));
 
 	if (locked)
 		mddev_lock_nointr(mddev);
@@ -5001,7 +4997,7 @@ void md_idle_sync_thread(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, true);
+	stop_sync_thread(mddev, true);
 }
 EXPORT_SYMBOL_GPL(md_idle_sync_thread);
 
@@ -5010,7 +5006,7 @@ void md_frozen_sync_thread(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 }
 EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
 
@@ -5035,7 +5031,7 @@ static void idle_sync_thread(struct mddev *mddev)
 		return;
 	}
 
-	stop_sync_thread(mddev, false, true);
+	stop_sync_thread(mddev, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -5049,7 +5045,7 @@ static void frozen_sync_thread(struct mddev *mddev)
 		return;
 	}
 
-	stop_sync_thread(mddev, false, false);
+	stop_sync_thread(mddev, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -6544,7 +6540,7 @@ void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
@@ -6612,7 +6608,7 @@ static int md_set_readonly(struct mddev *mddev)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	stop_sync_thread(mddev, false, false);
+	stop_sync_thread(mddev, false);
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 	mddev_lock_nointr(mddev);
@@ -6658,7 +6654,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 
 	if (mddev->sysfs_active ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-- 
2.39.2

