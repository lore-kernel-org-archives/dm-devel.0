Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0F86AC0;
	Wed, 27 Mar 2024 11:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539620; cv=none; b=oB/XtymxeCCB9UPbuas14oacpjF57ZydjQU6Xna1PlOHMA/cpu3+WuOTAu/3HBZtJP0yWA37ypv6s43RYIPxFjHUugGdvIl3b1OnCK/eFVUlm9yxXU0FclaUmvYmvmZ9AARlbPVqZeJqAiwr0GTmCvZf+HrXDsrf+PnuQawu4WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539620; c=relaxed/simple;
	bh=14+zCH7KXyilTLvNggL1x70vEotkTm2BT+DtYuEv/zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mXAAndhwki8eOYwHP+JgW0MjOFituUm7Av3cPSVLdMuZh7HTI8dC4iDu8fDK9x+e93lKyyPcWDfKvnMAxYZdJPvWaMANGDGXW+FrRq1nLQ9Toz0xKBSlVikGKXuSHWdq46IrcZBXfsZXgGNVCtEGc6b4P1YOJs/fXgfyZ8eSvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzuOqfZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzuOqfZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2806BC433C7;
	Wed, 27 Mar 2024 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711539619;
	bh=14+zCH7KXyilTLvNggL1x70vEotkTm2BT+DtYuEv/zQ=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=YzuOqfZW21mmxzmSy8eNzbpUoZVv+PIQkoDi3cQsMBmKERreYWBuWv3gwIwqwAGlj
	 32uTyfq2s8e9RxJiDorVvLYpyJawbML6pVdUPH6vBDNohUX8sqCXGhqAgawgMCXZKC
	 99xoHe2LpZAS1QRscyQP7AqhR5WsWL18d852X5sLLMDROmhNrln4SMze6yJf2WQLDy
	 bPKLh3TV73cgflFBNSlTQOSL1mJkZXSoO/2CNCkg7zPMyafkiWqNL3astRX8c2gfnt
	 SPcA0jByWL2soNtXgwxzxViI4Fxmry+K0v9YqD9wKZgYPPwAhTrnzYAxWenIKEO3nx
	 dljrN6aW9rKKA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 6.1-stable tree
Date: Wed, 27 Mar 2024 07:40:17 -0400
Message-ID: <20240327114018.2804652-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 8b5d27db21256ac02299f073de624f3774bfd465
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
index bf833ca880bc1..99b4738e867a8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4046,7 +4046,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
