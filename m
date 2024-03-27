Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D9345BEB;
	Wed, 27 Mar 2024 11:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538028; cv=none; b=jTiq1ni+NnKUDIFsxA5UJNjbg1JOb8UBp5/Hm2RLf8x4sumAC3OD4Vxr7i/l33d27pv6rRIhA0Hc8Bv/DVjUiXvPaawXNMSFMasWwFWYbGNGzkYy3hce1UQkn+Ppkq1JTzX/LOMpq/D8vTsoskS7S7zs/zaiMu4+CyPMBjkNIWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538028; c=relaxed/simple;
	bh=C7yEltsrySIl/iRQRc3C/GaM5wBkn/BevXNKqcBL0eA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EzOUtfq0IYDU2KdDON5IxFTQ8NNDptDcV6MgBtIsZ6NDK/W5/1lpEtFl+Q/27/SKTJSOXGqX2HD29awny6g6I4q8bwijzjD4ivf+IZYPUx+iLAYOZ0twbOVGHtO+XehbtW2+8W0FGkS8FDGTJRcDKuOYSYdS4qc01t3W7i8L57Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMA4Il4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMA4Il4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656CAC433F1;
	Wed, 27 Mar 2024 11:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711538028;
	bh=C7yEltsrySIl/iRQRc3C/GaM5wBkn/BevXNKqcBL0eA=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=CMA4Il4fyFKDHjpTrti785PnoXBI4lpiCR81+VfmHDo/S3+qyaRJqWBNR+bhE2sKs
	 S1QcTDUgWwThnw34PIIQpWWtYGOcXdOaxdHf4zxkfpaGnTSKD+CaFBGie2Sk14h3aY
	 jEgDdDZ3l4hhKj3b2iQ7pyluFoxKwdwfDqt0zUyUQiqbiD9BpOqJqUeTSXw/mMuW0p
	 wpQ72ErDKg+OE+6E4yW3M8AEbtSpprM8horbs1Yrn6TCaHI0wbjkld7HR2uvYVp3V4
	 DRMV7UGEKThvjVrl/tv4v1x38tKhCbX9AR08PCKbcYFNjQvI7wC8VvXynMovjJyD+Z
	 Zh1O6wg2V6ozQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 6.8-stable tree
Date: Wed, 27 Mar 2024 07:13:46 -0400
Message-ID: <20240327111346.2748621-1-sashal@kernel.org>
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

    dm-raid: fix lockdep waring in "pers->hot_add_disk"

to the 6.8-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-6.8 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 536e66694259aab8c1e869aa670b4b0d5805f925
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Tue Mar 5 15:23:06 2024 +0800

    dm-raid: fix lockdep waring in "pers->hot_add_disk"
    
    [ Upstream commit 95009ae904b1e9dca8db6f649f2d7c18a6e42c75 ]
    
    The lockdep assert is added by commit a448af25becf ("md/raid10: remove
    rcu protection to access rdev from conf") in print_conf(). And I didn't
    notice that dm-raid is calling "pers->hot_add_disk" without holding
    'reconfig_mutex'.
    
    "pers->hot_add_disk" read and write many fields that is protected by
    'reconfig_mutex', and raid_resume() already grab the lock in other
    contex. Hence fix this problem by protecting "pers->host_add_disk"
    with the lock.
    
    Fixes: 9092c02d9435 ("DM RAID: Add ability to restore transiently failed devices on resume")
    Fixes: a448af25becf ("md/raid10: remove rcu protection to access rdev from conf")
    Cc: stable@vger.kernel.org # v6.7+
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Xiao Ni <xni@redhat.com>
    Acked-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Song Liu <song@kernel.org>
    Link: https://lore.kernel.org/r/20240305072306.2562024-10-yukuai1@huaweicloud.com
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 063f1266ec462..d97355e9b9a6e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4091,7 +4091,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
