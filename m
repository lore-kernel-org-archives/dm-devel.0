Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC7B8173D;
	Wed, 27 Mar 2024 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539185; cv=none; b=oUjUqFxo6dT8nh1LO2f5ZajDdmn0n81cO3jk684ghwBkdZE5yJ7dFFPtzJQJIZzR+LamgijURq/zPAGwBL5MhD5R8st3EpSLNY69Argf9DTS3p0XhAuEY/ibUy7P7uBKG+v01AU7+z1rqHCSGoVMywDc9XdXgGBnwEQrOQbxsFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539185; c=relaxed/simple;
	bh=j6GokdrcgqfuCqZBjXSjmikK6huQq8OjWKBwSY64S5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fVtHbFAq8okRjW663XZp/G2XNOWYlXyFI8DJSMY0EpDXNy6KMnWf60ddPKcJLwBYWPS92FGCT3jjVWkrZia6+N6jWZl5J1YqbSXVIgf9tvo/LA7NUKSNeX5goz5EsnKiBCkb5kvR6WNci7J9LI5oLjJ7q3Hz1qvmrUb/KZXDQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlXEv9Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlXEv9Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C00C433F1;
	Wed, 27 Mar 2024 11:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711539184;
	bh=j6GokdrcgqfuCqZBjXSjmikK6huQq8OjWKBwSY64S5Q=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=hlXEv9Wl7IKV38UI3QnJmy2dIZM+Sa8Z0IHhPxjPi1liReB4XGAONuLM2MSl6emY+
	 FGi/5HIFotXrXqQLnaN/Qn8xoVd4PGDuQFMD7go5iW1hASd4J6OeHJBxGluvBL+Krr
	 jcS+J+wsnTHFU5FMOXTs/MMf4mlY1cWcQSHrj6553wBtsjZeTgwAaLIGs58VHkclfT
	 wmf9KUtuOfisCM7Qbpbq9/M3r+Ni5AJ6nz+vTJrnY5A3dKHggcdcrisJpP+bHP8xDJ
	 tnn5X/nQggRyH7wvdd4H05wXuTfFMAbMHwAXGUpjgaRDwy2UZ4yB9RpZflDtuTIS3G
	 SDbzF0QmVGCRg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-raid: fix lockdep waring in "pers->hot_add_disk"" has been added to the 6.6-stable tree
Date: Wed, 27 Mar 2024 07:33:02 -0400
Message-ID: <20240327113302.2796955-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-lockdep-waring-in-pers-hot_add_disk.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 03b6302b16568735c98c5658aefb1f39d76f4d79
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
index 3d8ee9eb59ea6..385e24f55ec00 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4042,7 +4042,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
