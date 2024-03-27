Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D766212BEB0;
	Wed, 27 Mar 2024 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540458; cv=none; b=RDaUrream8S5f0CQrhaCODUKooNJWZXiDLf/b35Sa22IcleBL2Wxsr3YgAeROVHeVg91f4cUz78BOmCsYYxpvqcKiEwCP37wgvUFyAn87aRXbo845ATwGc6p3ls3tKk3MWJuOBFcX16RdllgWWqZAPmh5HdrXcqwnadFYYhxCcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540458; c=relaxed/simple;
	bh=kkU/V6GNkHng9aUSGGbuJyANINjcEWks00wqMjnEAAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+fTw3rkSnSnqR5bvcg8gxzD0nOmS5x12Q07AIuHJmX0EaumWAoqnNEkAddd8SeeJhy6HQZhqg3C5QQg0tEz1OmAtGl6T4RZ/pTRKcVnIS9NOIvPhxvmOvap6BEHRurgOgPwM8VEW/AKPZ3FXoGqDefc0ZJZGYdhrPunt1Po6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWSqByTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWSqByTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2132C433C7;
	Wed, 27 Mar 2024 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540458;
	bh=kkU/V6GNkHng9aUSGGbuJyANINjcEWks00wqMjnEAAw=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=jWSqByTWhLUhvMHHGBVKRdAnD3IVa2U/vkfUaH+uJ4qUZzVmpKP9GaGBQf84jkPOt
	 xWgHqzjyMiSTuxuimpqdl/3IkT3unt1hlGye0jpmlSNIFBv+C1qxOXSTKnkFZQH9Bt
	 EWxk2zClpYiShB+73Udsdst4qWo3CzAeoz/UUcpt69UYSrCUx3UW2T+E+c+zXuLKy5
	 X+ogw0edDSvS/H675ZhpRbX5pJM5wuAQPqfHxjnvkXbikDI7WaBD4sg4bPsNa+/pIN
	 68RLx14YGN6eFpSDfnE4A976bd19Pa8xgKj4YHoe4PJk9Gn1zp3/xd4E0+9YfN7Mhw
	 UAzmOJQ6ibOqQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 5.4-stable tree
Date: Wed, 27 Mar 2024 07:54:16 -0400
Message-ID: <20240327115417.2819638-1-sashal@kernel.org>
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

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e326ab70723f47af48a50805b544d29f691bd0f8
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
index 1ccd765fad938..25eecb92f5f38 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4027,7 +4027,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
