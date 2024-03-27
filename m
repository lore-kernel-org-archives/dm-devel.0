Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB6D85941;
	Wed, 27 Mar 2024 11:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539929; cv=none; b=nmf/MMq3h/2Nh/B2dQ0lTtWhYII0kLsE+jTiEewkLx66HZOL941JADCfgb2EwUa8KJJq4Cq1P8IDDHnhobdj/R4HGLUqzn4R0JP0X+LTBIYpp20AkLDWBOjS6ggvEoj4EApw+gglhNSN5WJ5igODS/Gg7est2mnokRf9/FDXfW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539929; c=relaxed/simple;
	bh=7I83Jvs6rGgh0kHXw24qn4qD+RIaaBK42xNgrdFLYdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MclZQqWVfjao6nPW/wI8nUzdz1pf7xcHTvXVWySBvlbSlRaZEp4BVUZ9L8dykEzmyk0+5En6W2BATBVbEIrojsOFWhw0YCJgrLcl+4CA/p/BKRHQcb5BSaXBxJ0zNt2eU09aNe4tp+3PdumQ1xnJWgKMsSa9nJN0t2Be33cmKWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM/hwDJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM/hwDJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91553C433F1;
	Wed, 27 Mar 2024 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711539929;
	bh=7I83Jvs6rGgh0kHXw24qn4qD+RIaaBK42xNgrdFLYdA=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=EM/hwDJ/es6xiNzUzFm10Gcb9VVBdmfTfrZPJagHQpnHYKWhJ+9E44ENDu1oR2SDW
	 nKIHyRPaaMzXQrE21otZ1sz2b6s6/UkMHcvt7oS7NA/89hlMpsH6fOvqnoe/Cuvn1S
	 CxcP5dF8o5l1RWaLdZcYZV4XBJL6/17dcMyPQT5xngKVSiJPaYe9j+PCpsTfQxG7k7
	 SaW+OfT9HY0xoxyyIKlVicysiw7x32uLaqjGsRU22q1kRNlHgVYErBAQq+dYGME/uK
	 IdyplS0J9/gN+j0du4sgdMP9brblAQzZuJgAG0/EmNZhRVdRIT2dEkSeI6KxZu3bAm
	 apRDqwh0o7OaQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 5.15-stable tree
Date: Wed, 27 Mar 2024 07:45:27 -0400
Message-ID: <20240327114527.2810247-1-sashal@kernel.org>
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

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 26a41ac8f4a7cb8cce93b6647df69a7afbe61f54
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
index 04769fb20cf7f..5d1006142aaed 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4049,7 +4049,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
