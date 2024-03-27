Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B1612C536;
	Wed, 27 Mar 2024 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540211; cv=none; b=GSlC2svkfNUXyB86YlOLHwflhWcePRRK5d2vV8FzqZyRh+QO3QZ+MPUeNO1MWxKMydJYfQVrEWLAP9JUSqFPYnwS9V0GOYFc7veSWrthNGcCmAyTyhjLPBR5p073DR7Ob5Y2KbXR3064Cye0DPXQMrre1Bf2JhQ76EXFE87/DsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540211; c=relaxed/simple;
	bh=MLtXcvWDNIQcktxocnXksRMKJFxtW6M2D42SSzmCOKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Go6vzRqp2OC7/1fXqjP1LDjXegQSRARdohXM3Dz9YtOEH9MdDbx1WJFjk/M28P0MnGCZ5VMJaeaLRaWiE8MkBbARcXEgfyKF4X88bFsyXMR/76cRCQfxPTKInY6gUFbniwglQaNjtBiKmo34Nnb9xHlxSx0RiLctgewJJu+nFyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fe46Gmnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fe46Gmnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A7FC433F1;
	Wed, 27 Mar 2024 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540211;
	bh=MLtXcvWDNIQcktxocnXksRMKJFxtW6M2D42SSzmCOKg=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=fe46Gmnm8zf6U4SgTs5NuQ7r21F9ZzehrdOHmhrRN/hjgPv1Ug2b4q48aizc5L4Tu
	 vI2u1y6EdjEKfwROVcQ0s4VLLXnZL6SA2AaTxUuIhsOw0cGWQXeh18fBLbGq52NGv0
	 pb20pNf6sE11Gpja3bjO3nU08psZuKjFt/Z4plIm+OTZvptgFMcqk5rF3rjoH7bw+O
	 NMVrMliedWcyP0EqI9c10e3f3oUmKORaDMNDcHvOXYvQtIUcOUrmfmtLkF5knuqMuV
	 P2HwGclua3xTLeyMan6L0YkCimn9AmP6cYLM5jV9nrEauAovZvXpvj135tda5aBXWk
	 p9bmmxXdKK3Mw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 5.10-stable tree
Date: Wed, 27 Mar 2024 07:50:09 -0400
Message-ID: <20240327115009.2815215-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit dc4a65976fa0b7d9af41e525bbf2627eb88ccae3
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
index e523ecdf947f4..99995b1804b32 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4019,7 +4019,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
