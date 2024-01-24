Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2BA17C65
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 09:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087954; cv=none; b=DUf0E5Lqj4fz8Ammzw+SzlZ7bSm34RM5ZJIYaXEd44wUTydrBkcPHXMSrX383dX+DqMEz1Y5GD4/g+C+6jaVWGLt0DSeoJEBtWMzCyVvpTBfw0PES647sSYGiz9AIoW/RQHIJwBL5M76W3/SWu+iaoLq9wG/I2o0BdgP3znY8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087954; c=relaxed/simple;
	bh=X18KtNk96NC0AqflJWJCrao6h9w3a7IJOBSuBGFV//o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9/+RoT/AQaq4LCoTS3Pl/GPFJDKldSrvlbC6nNG+dlTOWGW9Emop3YUVlzIHQpHvprf5vBhZdsfYRQCRYCSMra2nO4jEd6tmP9P/KXQmCMR2wctBGQPkp7EZbmZeHbvROp3aDS1NKwecFq0vVBDYTJF/WdobHzWLp1L56XB5RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TKdfT6qvxz1xmZt;
	Wed, 24 Jan 2024 17:18:09 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 53C0F1A017B;
	Wed, 24 Jan 2024 17:18:47 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 24 Jan
 2024 17:18:18 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<dm-devel@lists.linux.dev>, <xni@redhat.com>, <song@kernel.org>,
	<yukuai3@huawei.com>, <jbrassow@f14.redhat.com>, <neilb@suse.de>,
	<heinzm@redhat.com>, <shli@fb.com>, <akpm@osdl.org>
CC: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2 02/11] md: don't ignore read-only array in md_check_recovery()
Date: Wed, 24 Jan 2024 17:14:12 +0800
Message-ID: <20240124091421.1261579-3-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240124091421.1261579-1-yukuai3@huawei.com>
References: <20240124091421.1261579-1-yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Usually if the array is not read-write, md_check_recovery() won't
register new sync_thread in the first place. And if the array is
read-write and sync_thread is registered, md_set_readonly() will
unregister sync_thread before setting the array read-only. md/raid
follow this behavior hence there is no problem.

After commit f52f5c71f3d4 ("md: fix stopping sync thread"), following
hang can be triggered by test shell/integrity-caching.sh:

1) array is read-only. dm-raid update super block:
rs_update_sbs
 ro = mddev->ro
 mddev->ro = 0
  -> set array read-write
 md_update_sb

2) register new sync thread concurrently.

3) dm-raid set array back to read-only:
rs_update_sbs
 mddev->ro = ro

4) stop the array:
raid_dtr
 md_stop
  stop_sync_thread
    set_bit(MD_RECOVERY_INTR, &mddev->recovery);
    md_wakeup_thread_directly(mddev->sync_thread);
    wait_event(..., !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))

5) sync thread done:
 md_do_sync
 set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 md_wakeup_thread(mddev->thread);

6) daemon thread can't unregister sync thread:
 md_check_recovery
  if (!md_is_rdwr(mddev) &&
      !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
   return;
  -> -> MD_RECOVERY_RUNNING can't be cleared, hence step 4 hang;

The root cause is that dm-raid manipulate 'mddev->ro' by itself,
however, dm-raid really should stop sync thread before setting the
array read-only. Unfortunately, I need to read more code before I
can refacter the handler of 'mddev->ro' in dm-raid, hence let's fix
the problem the easy way for now to prevent dm-raid regression.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com/
Fixes: ecbfb9f118bc ("dm raid: add raid level takeover support")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 07b80278eaa5..6906d023f1d6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9445,6 +9445,20 @@ static void md_start_sync(struct work_struct *ws)
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
 }
 
+static void unregister_sync_thread(struct mddev *mddev)
+{
+	if (!test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
+		/* resync/recovery still happening */
+		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		return;
+	}
+
+	if (WARN_ON_ONCE(!mddev->sync_thread))
+		return;
+
+	md_reap_sync_thread(mddev);
+}
+
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -9482,7 +9496,8 @@ void md_check_recovery(struct mddev *mddev)
 	}
 
 	if (!md_is_rdwr(mddev) &&
-	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
 	if ( ! (
 		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
@@ -9504,8 +9519,7 @@ void md_check_recovery(struct mddev *mddev)
 			struct md_rdev *rdev;
 
 			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-				/* sync_work already queued. */
-				clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+				unregister_sync_thread(mddev);
 				goto unlock;
 			}
 
@@ -9568,16 +9582,7 @@ void md_check_recovery(struct mddev *mddev)
 		 * still set.
 		 */
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-			if (!test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
-				/* resync/recovery still happening */
-				clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-				goto unlock;
-			}
-
-			if (WARN_ON_ONCE(!mddev->sync_thread))
-				goto unlock;
-
-			md_reap_sync_thread(mddev);
+			unregister_sync_thread(mddev);
 			goto unlock;
 		}
 
-- 
2.39.2

