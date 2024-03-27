Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA5C5E09C;
	Wed, 27 Mar 2024 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538627; cv=none; b=Ohc7qB5VDvR0LEx/V3GMoLBtRoDbNJXyEBD2FxsssN6tF1MtHr8tw60Z5UdPK9RoqdlWaDTqShTKlvrnDcYV7ThZ/wTm/6Dmp5akuIkMs+igAFhx40S4SS7j/hiNXZxy3Fsr/BkU+RY4/lGtSGcOzQYVJJCUQp5p4EFUYl9Cz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538627; c=relaxed/simple;
	bh=Dw2FWkLu7i5LsnYsMAoaIw06hqgaH+zmXALuJoxDyGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b1jwnTgOQ3QPATM3KZira7RHNTcXwFAYQSbS13fDZHQYtPljt1gOcRWUy2QwW5Ak8w9k8JTaI9k5OLycOpLr4jUXzwIyVLOE9amvompeNuKtlRp1da4+JgcwaqkvqCrfiJS39clnfJpUsidUFwsM8i1k31lZLk9eayw5uL04KjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aiypWTUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aiypWTUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231A3C433F1;
	Wed, 27 Mar 2024 11:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711538626;
	bh=Dw2FWkLu7i5LsnYsMAoaIw06hqgaH+zmXALuJoxDyGA=;
	h=From:To:Cc:Subject:Date:Reply-To:From;
	b=aiypWTUWfSOejJ+zgXreGSZx4CCGjfNWNQYgf474hXGV5xl0hEVovYSlFMRL23A9g
	 pSGu6rWhMr6uz4HHN9z1E2s8cNZPJGlyRkCHlWihTDRndvQc0ijUoTG/NpPCYF9/bS
	 sp5JndYp5++WMIBjGx3bO/cRjrjQzD+7jy8JsxnbWLS6gygWup+9a2+bQr7wkut8Ry
	 YCO6wVk7/M4GKtB+jbFH7/n1Vld2GjvoReEv5RnilHss2hrnb7NOIUFRfAWPyFqvTC
	 S6UdPhwNhoKG3yMpFvFjwnahJp6Qxzi1DsLr+LN+UytgKg6ZP3srjLKb9wktPUPzXI
	 SYp5MYwLta4iQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	Song Liu <song@kernel.org>
Subject: Patch "dm-raid: add a new helper prepare_suspend() in md_personality" has been added to the 6.7-stable tree
Date: Wed, 27 Mar 2024 07:23:44 -0400
Message-ID: <20240327112345.2780210-1-sashal@kernel.org>
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

    dm-raid: add a new helper prepare_suspend() in md_personality

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-add-a-new-helper-prepare_suspend-in-md_perso.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2eea0920d6a4eec9ef6bf65a03cc3a32bb1fb44e
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Tue Mar 5 15:23:04 2024 +0800

    dm-raid: add a new helper prepare_suspend() in md_personality
    
    [ Upstream commit 5625ff8b72b0e5c13b0fc1fc1f198155af45f729 ]
    
    There are no functional changes for now, prepare to fix a deadlock for
    dm-raid456.
    
    Cc: stable@vger.kernel.org # v6.7+
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Xiao Ni <xni@redhat.com>
    Acked-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Song Liu <song@kernel.org>
    Link: https://lore.kernel.org/r/20240305072306.2562024-8-yukuai1@huaweicloud.com
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8d38cdb221453..b8f5304ca00d1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3803,6 +3803,23 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 }
 
+static void raid_presuspend(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
+
+	if (!reshape_interrupted(mddev))
+		return;
+
+	/*
+	 * For raid456, if reshape is interrupted, IO across reshape position
+	 * will never make progress, while caller will wait for IO to be done.
+	 * Inform raid456 to handle those IO to prevent deadlock.
+	 */
+	if (mddev->pers && mddev->pers->prepare_suspend)
+		mddev->pers->prepare_suspend(mddev);
+}
+
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
@@ -4087,6 +4104,7 @@ static struct target_type raid_target = {
 	.message = raid_message,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
+	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
 	.preresume = raid_preresume,
 	.resume = raid_resume,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ea0fd76c17e75..24261f9b676d5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -649,6 +649,7 @@ struct md_personality
 	int (*start_reshape) (struct mddev *mddev);
 	void (*finish_reshape) (struct mddev *mddev);
 	void (*update_reshape_pos) (struct mddev *mddev);
+	void (*prepare_suspend) (struct mddev *mddev);
 	/* quiesce suspends or resumes internal processing.
 	 * 1 - stop new actions and wait for action io to complete
 	 * 0 - return to normal behaviour
