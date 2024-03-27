Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694512D200;
	Wed, 27 Mar 2024 11:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540643; cv=none; b=Smq0ykjz7tvNE1QzxmPFqj45lLyTEFTZ7tITxGiKKemDLOo7dsie5FbJfkpIWlyQoZz0swJEQw2LLgrvbLre0MZsTKraGiFpTz0iTM+sjId8bzkUOJheKDFJLNU/hIfyjIIcLb1GooJE9hpd1vcN+oscMWISdtci65DqWybza64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540643; c=relaxed/simple;
	bh=Z72P05lRn/ftrZ8xPXWCX7i9zWc1Pei+lnW/yl70jIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZqMuXqJIeANwPA85nnnW5zy78m9AUFqNPxdjwesvjO5mzNcEd7wzDvFXu9Mk0gngHChEGMQoSN9oxUrrymBPfsXmU3uCfw8Nxi1ybUFyUc3kBLj1cNKtnsJCL/k8fBDTSWrqObeRP6B1tkPf+gVCdSOXjIVYz+flqjJBdGNcEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSqybJPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSqybJPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BABC433C7;
	Wed, 27 Mar 2024 11:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540643;
	bh=Z72P05lRn/ftrZ8xPXWCX7i9zWc1Pei+lnW/yl70jIc=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=VSqybJPWwiIXFHUM3hR8t+68Su4uByFakymM8HVC3sdAbzTl3z7nzzIIMhV663J44
	 e5Rp/FPxL5VTLpREPPvrMRUesUuGhBXhKDgsBwDlqYsZNQu2IT73gwra+JqjaMmRFw
	 yRUTEeAIAVT1zvcoSF7SYylT/MFHJaQDRxH1FWn3RrmrOIDZk6qpI8iukaRzqtd4zR
	 jTQUqDg+yOcs7/71hshH8aSijjKsKQ4xZtdpcQN2OccPtQfP3x/e7WcXmUt9X6FlBP
	 RmGGIoieaOJsTxbDc3KeZOPniIj4bj7eiHMnnmafy1qMi5+GCyS6b95y0BqmHBet7l
	 q9+SeU9T2J78g==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 4.19-stable tree
Date: Wed, 27 Mar 2024 07:57:21 -0400
Message-ID: <20240327115721.2822756-1-sashal@kernel.org>
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

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 1b3818962a987bdc835b4603c3028f209b754aa5
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
index 1759134fce824..2a8746f9c6d87 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4023,7 +4023,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
