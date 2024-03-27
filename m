Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C752F90;
	Wed, 27 Mar 2024 11:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538624; cv=none; b=h0+uPlrK72buALSzVr521eLLBQCUmpKXStjtQDRJ1FuJJWZ0iqb1IqhikSN7IEGRhyMe+HLKNFMpaDjy4dO+D4XqT1WXZU/RmcRHm1za5xLczhqucuK7WHhwL/pGU70csaXzUkW5Waa5AqPGArQitzrPJ9oUwoRVnRatHhAE3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538624; c=relaxed/simple;
	bh=D+OMzhHTIXYA0/VmDBNXOkCk1XuMXdGcUGYRO7hoy+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iwEW1BuO3Egq7JB0XGrr5iOt54T1ZutmuHTzYeFFq4B8YNVy0dvltExv7Un5D2ls3RW7ddRHdXNojApBuURstE2W2zijwh1KgVwzHVwjtUCMFDUgykDwf7d0gGZTcZi4jyRezdMLyUL30MAkjfrSbmg8JK/WrzEth9zv4SFa1V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjpVXiUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjpVXiUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97178C433F1;
	Wed, 27 Mar 2024 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711538624;
	bh=D+OMzhHTIXYA0/VmDBNXOkCk1XuMXdGcUGYRO7hoy+8=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=hjpVXiUEysVKpQkP6feVMtHNasGtiFpBEAbvR4U9ogGXypHb4dnWX8IcpwrIx7eKt
	 /2AiGbnUNnmK0kQh5P2uID6XHf/R7/g+s+M6IF6iapn/2VwPubhTcMTdWeDm3AFV+r
	 bFdd681VbjlaI+h+hep1e8CfBazTQ92u9Oi5CGzNKNMzlGKucFeGkQ4a1WEhN8lYr2
	 JOkIqXfGaTt/O/GD0omGzfMY/C9S+LbTuSxN/XsHMsKdYS6fndgrcbg7Grol7glNjT
	 4J0whzXJgC0knWuVWtbR6Yjg2sr8fCWBpqUptugOWihM8EhtIbKgAUKRW4a0aD+pVz
	 BEReaup3QbrTw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "md/dm-raid: don't call md_reap_sync_thread() directly" has been added to the 6.7-stable tree
Date: Wed, 27 Mar 2024 07:23:42 -0400
Message-ID: <20240327112342.2780132-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Reply-To: stable@vger.kernel.org
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    md/dm-raid: don't call md_reap_sync_thread() directly

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     md-dm-raid-don-t-call-md_reap_sync_thread-directly.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 0c0a9af923658fed374bcc356f52a74ae76e3b13
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Tue Mar 5 15:23:03 2024 +0800

    md/dm-raid: don't call md_reap_sync_thread() directly
    
    [ Upstream commit cd32b27a66db8776d8b8e82ec7d7dde97a8693b0 ]
    
    Currently md_reap_sync_thread() is called from raid_message() directly
    without holding 'reconfig_mutex', this is definitely unsafe because
    md_reap_sync_thread() can change many fields that is protected by
    'reconfig_mutex'.
    
    However, hold 'reconfig_mutex' here is still problematic because this
    will cause deadlock, for example, commit 130443d60b1b ("md: refactor
    idle/frozen_sync_thread() to fix deadlock").
    
    Fix this problem by using stop_sync_thread() to unregister sync_thread,
    like md/raid did.
    
    Fixes: be83651f0050 ("DM RAID: Add message/status support for changing sync action")
    Cc: stable@vger.kernel.org # v6.7+
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Xiao Ni <xni@redhat.com>
    Acked-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Song Liu <song@kernel.org>
    Link: https://lore.kernel.org/r/20240305072306.2562024-7-yukuai1@huaweicloud.com
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index fff9336fee767..8d38cdb221453 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3719,6 +3719,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
+	int ret = 0;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
@@ -3726,17 +3727,24 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (test_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
 		return -EBUSY;
 
-	if (!strcasecmp(argv[0], "frozen"))
-		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	else
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	if (!strcasecmp(argv[0], "frozen")) {
+		ret = mddev_lock(mddev);
+		if (ret)
+			return ret;
 
-	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
-		if (mddev->sync_thread) {
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
-		}
-	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
+		md_frozen_sync_thread(mddev);
+		mddev_unlock(mddev);
+	} else if (!strcasecmp(argv[0], "idle")) {
+		ret = mddev_lock(mddev);
+		if (ret)
+			return ret;
+
+		md_idle_sync_thread(mddev);
+		mddev_unlock(mddev);
+	}
+
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
 	else if (!strcasecmp(argv[0], "resync"))
 		; /* MD_RECOVERY_NEEDED set below */
