Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086FC52F90;
	Wed, 27 Mar 2024 11:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538622; cv=none; b=UoV4aT10nWLwTB5fW1Wq/xTBPBSKxE5u7X6u4r6m5EfWr/DTISc6npFyYaIg1b6MxREGQm/ZGAouqR+pLNQ2C1tXFYp1LfWO2jFC/3UfbIXHwBdxYMs/nOYRJrxp3sIvVel2Qqw4KSQrlb4dwQ0O+Jcu2CCny8tDd4wGCxbl/cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538622; c=relaxed/simple;
	bh=yz+Rd9lq6qo7Hvo2pxmsMsfEHV9TuO1mF3YeeAajhmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jAMuQiNdbL3Pnx+BP8SNomWLKi/JRQ8dL8nF6P56E4WHIA6aVbNjl7VP2K6VMTD9PIIaUITv9eJLWQ107/8GHF21laqTVe1XPI7EGv9QUBMlBxqJ7qCvZf5mCCZyfPbkbyrfJ8Y3bLRBL/wx9+lDKJvYSdpqSx2o0BgAr/I2aBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2JzQPXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2JzQPXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C93CC433C7;
	Wed, 27 Mar 2024 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711538621;
	bh=yz+Rd9lq6qo7Hvo2pxmsMsfEHV9TuO1mF3YeeAajhmM=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=P2JzQPXYp+dervhIlUr4hofsxe3z4Wxh7kCnYjSx67s73HP/6HkWgD+8SaIGaqlXd
	 0m5uMZXoLcYUQTmanlTCbCrti9LdxIjUBYbKTguEDHqSKe151+q1xLco+wm63Q54sZ
	 Nt+ReqKF9XPQiTGr2I3czvXevaceBgsj0WROpwZ6fh/0o2E1Pg0ptWJ6ztVJ47Bv1i
	 /UicQw1znmD8LXQlaz8Duk95k/KL5zWKc59k9O2Gnvric7G4EYwF5SCq7/hE0DQWUy
	 duM1SFNB5K8WZ0/wUuzQDSK+RpMY7QHr5tjWcpHjn+gWc1Sl4mPKUKShpvrtdcAbVW
	 SZqGPb4JElSMg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	Song Liu <song@kernel.org>
Subject: Patch "dm-raid: really frozen sync_thread during suspend" has been added to the 6.7-stable tree
Date: Wed, 27 Mar 2024 07:23:39 -0400
Message-ID: <20240327112340.2780052-1-sashal@kernel.org>
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

    dm-raid: really frozen sync_thread during suspend

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-really-frozen-sync_thread-during-suspend.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 4d9008a3ff3ab9b7666ea808b27216e59e0f3517
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Tue Mar 5 15:23:02 2024 +0800

    dm-raid: really frozen sync_thread during suspend
    
    [ Upstream commit 16c4770c75b1223998adbeb7286f9a15c65fba73 ]
    
    1) commit f52f5c71f3d4 ("md: fix stopping sync thread") remove
       MD_RECOVERY_FROZEN from __md_stop_writes() and doesn't realize that
       dm-raid relies on __md_stop_writes() to frozen sync_thread
       indirectly. Fix this problem by adding MD_RECOVERY_FROZEN in
       md_stop_writes(), and since stop_sync_thread() is only used for
       dm-raid in this case, also move stop_sync_thread() to
       md_stop_writes().
    2) The flag MD_RECOVERY_FROZEN doesn't mean that sync thread is frozen,
       it only prevent new sync_thread to start, and it can't stop the
       running sync thread; In order to frozen sync_thread, after seting the
       flag, stop_sync_thread() should be used.
    3) The flag MD_RECOVERY_FROZEN doesn't mean that writes are stopped, use
       it as condition for md_stop_writes() in raid_postsuspend() doesn't
       look correct. Consider that reentrant stop_sync_thread() do nothing,
       always call md_stop_writes() in raid_postsuspend().
    4) raid_message can set/clear the flag MD_RECOVERY_FROZEN at anytime,
       and if MD_RECOVERY_FROZEN is cleared while the array is suspended,
       new sync_thread can start unexpected. Fix this by disallow
       raid_message() to change sync_thread status during suspend.
    
    Note that after commit f52f5c71f3d4 ("md: fix stopping sync thread"), the
    test shell/lvconvert-raid-reshape.sh start to hang in stop_sync_thread(),
    and with previous fixes, the test won't hang there anymore, however, the
    test will still fail and complain that ext4 is corrupted. And with this
    patch, the test won't hang due to stop_sync_thread() or fail due to ext4
    is corrupted anymore. However, there is still a deadlock related to
    dm-raid456 that will be fixed in following patches.
    
    Reported-by: Mikulas Patocka <mpatocka@redhat.com>
    Closes: https://lore.kernel.org/all/e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com/
    Fixes: 1af2048a3e87 ("dm raid: fix deadlock caused by premature md_stop_writes()")
    Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
    Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
    Cc: stable@vger.kernel.org # v6.7+
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Xiao Ni <xni@redhat.com>
    Acked-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Song Liu <song@kernel.org>
    Link: https://lore.kernel.org/r/20240305072306.2562024-6-yukuai1@huaweicloud.com
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 13eb47b997f94..fff9336fee767 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3240,11 +3240,12 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	rs->md.ro = 1;
 	rs->md.in_sync = 1;
 
-	/* Keep array frozen until resume. */
-	set_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
-
 	/* Has to be held on running the array */
 	mddev_suspend_and_lock_nointr(&rs->md);
+
+	/* Keep array frozen until resume. */
+	md_frozen_sync_thread(&rs->md);
+
 	r = md_run(&rs->md);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
 	if (r) {
@@ -3722,6 +3723,9 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	if (test_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
+		return -EBUSY;
+
 	if (!strcasecmp(argv[0], "frozen"))
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	else
@@ -3796,10 +3800,11 @@ static void raid_postsuspend(struct dm_target *ti)
 	struct raid_set *rs = ti->private;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
-		/* Writes have to be stopped before suspending to avoid deadlocks. */
-		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
-			md_stop_writes(&rs->md);
-
+		/*
+		 * sync_thread must be stopped during suspend, and writes have
+		 * to be stopped before suspending to avoid deadlocks.
+		 */
+		md_stop_writes(&rs->md);
 		mddev_suspend(&rs->md, false);
 	}
 }
@@ -4012,8 +4017,6 @@ static int raid_preresume(struct dm_target *ti)
 	}
 
 	/* Check for any resize/reshape on @rs and adjust/initiate */
-	/* Be prepared for mddev_resume() in raid_resume() */
-	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->recovery_cp && mddev->recovery_cp < MaxSector) {
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		mddev->resync_min = mddev->recovery_cp;
@@ -4055,10 +4058,12 @@ static void raid_resume(struct dm_target *ti)
 		if (mddev->delta_disks < 0)
 			rs_set_capacity(rs);
 
+		WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery));
+		WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
 		mddev_lock_nointr(mddev);
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		mddev->ro = 0;
 		mddev->in_sync = 0;
+		md_unfrozen_sync_thread(mddev);
 		mddev_unlock_and_resume(mddev);
 	}
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index bae513018849a..c052edeb21606 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6369,7 +6369,6 @@ static void md_clean(struct mddev *mddev)
 
 static void __md_stop_writes(struct mddev *mddev)
 {
-	stop_sync_thread(mddev, true, false);
 	del_timer_sync(&mddev->safemode_timer);
 
 	if (mddev->pers && mddev->pers->quiesce) {
@@ -6394,6 +6393,8 @@ static void __md_stop_writes(struct mddev *mddev)
 void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	stop_sync_thread(mddev, true, false);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
