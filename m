Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A078686;
	Fri, 22 Mar 2024 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711135969; cv=none; b=moJfUYfjZCAx0mc/arH3d08blxC0rbQvrSFJnM0+FC77RldaC3Fv2HwGXojM5CNl4o8qUUh2o35yyGK070LKMO4sl8biloAjfPsRgfTB/HSB5Qc1KDnFE4568Oh77e7a1D1hfv53dWkbj49vs7076CcEh/PalCh9R1lEW5ZUjiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711135969; c=relaxed/simple;
	bh=2MO2OeD8hw4SHwzqoQ344ipy+Mgs7EicK1kscOCHFvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qIjK5PUk+7JPRoe9AiruYzex8yBfoJJmJoNc5sMLYa6cGqhN8tsIuhRV+vQgxLgduH1+qUUUI1qwaD4wtzwGUVsCtJTFUEJA6+T8yLIyfAEQZL49p/ljpplellqfaLcl/Sxp2eXEGpGs8VmNkQ+aDMgLlt8EH1KrqR0w6e+JcmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNqwPK1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNqwPK1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD4C433C7;
	Fri, 22 Mar 2024 19:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711135969;
	bh=2MO2OeD8hw4SHwzqoQ344ipy+Mgs7EicK1kscOCHFvw=;
	h=From:To:Cc:Subject:Date:From;
	b=lNqwPK1F14arjkZ0AsU2efm/vRGtIiWp7EgekOQ38XEQbA4dCmvVRhnS3xT5WeC5A
	 yWmonihx/DsUEb1fBvUZ7i0ucQ7spMfrhwSuqrB2FphK745ogHMvsJGGW5TVAzzFwM
	 VM7HbvF4jUkw11EJCstM4L5ZgLm9CexYXFT/eyNQJd/MfGtZNaoJYhKthWMAe1GZ1P
	 dDBd54zlq+3N/pK0ViO8CUAufSWHvlhouxtzeC1WxAOe2Gsur36qsFxEf6lPaBSygO
	 yoRzTQAyDziTD95VrYIIewWkmDgjImhgJ6Oom0XptJ45futrMeTI9AhOM6zJmOk3GZ
	 OjwOGofXyr7xA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm: call the resume method on internal suspend" has been added to the 5.10-stable tree
Date: Fri, 22 Mar 2024 14:41:29 -0400
Message-ID: <20240322184129.138687-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm: call the resume method on internal suspend

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-call-the-resume-method-on-internal-suspend.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 606ae1d70a585ddbf30940deab8ce72b70b3eba3
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Mon Mar 11 15:06:39 2024 +0100

    dm: call the resume method on internal suspend
    
    [ Upstream commit 65e8fbde64520001abf1c8d0e573561b4746ef38 ]
    
    There is this reported crash when experimenting with the lvm2 testsuite.
    The list corruption is caused by the fact that the postsuspend and resume
    methods were not paired correctly; there were two consecutive calls to the
    origin_postsuspend function. The second call attempts to remove the
    "hash_list" entry from a list, while it was already removed by the first
    call.
    
    Fix __dm_internal_resume so that it calls the preresume and resume
    methods of the table's targets.
    
    If a preresume method of some target fails, we are in a tricky situation.
    We can't return an error because dm_internal_resume isn't supposed to
    return errors. We can't return success, because then the "resume" and
    "postsuspend" methods would not be paired correctly. So, we set the
    DMF_SUSPENDED flag and we fake normal suspend - it may confuse userspace
    tools, but it won't cause a kernel crash.
    
    ------------[ cut here ]------------
    kernel BUG at lib/list_debug.c:56!
    invalid opcode: 0000 [#1] PREEMPT SMP
    CPU: 1 PID: 8343 Comm: dmsetup Not tainted 6.8.0-rc6 #4
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
    RIP: 0010:__list_del_entry_valid_or_report+0x77/0xc0
    <snip>
    RSP: 0018:ffff8881b831bcc0 EFLAGS: 00010282
    RAX: 000000000000004e RBX: ffff888143b6eb80 RCX: 0000000000000000
    RDX: 0000000000000001 RSI: ffffffff819053d0 RDI: 00000000ffffffff
    RBP: ffff8881b83a3400 R08: 00000000fffeffff R09: 0000000000000058
    R10: 0000000000000000 R11: ffffffff81a24080 R12: 0000000000000001
    R13: ffff88814538e000 R14: ffff888143bc6dc0 R15: ffffffffa02e4bb0
    FS:  00000000f7c0f780(0000) GS:ffff8893f0a40000(0000) knlGS:0000000000000000
    CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
    CR2: 0000000057fb5000 CR3: 0000000143474000 CR4: 00000000000006b0
    Call Trace:
     <TASK>
     ? die+0x2d/0x80
     ? do_trap+0xeb/0xf0
     ? __list_del_entry_valid_or_report+0x77/0xc0
     ? do_error_trap+0x60/0x80
     ? __list_del_entry_valid_or_report+0x77/0xc0
     ? exc_invalid_op+0x49/0x60
     ? __list_del_entry_valid_or_report+0x77/0xc0
     ? asm_exc_invalid_op+0x16/0x20
     ? table_deps+0x1b0/0x1b0 [dm_mod]
     ? __list_del_entry_valid_or_report+0x77/0xc0
     origin_postsuspend+0x1a/0x50 [dm_snapshot]
     dm_table_postsuspend_targets+0x34/0x50 [dm_mod]
     dm_suspend+0xd8/0xf0 [dm_mod]
     dev_suspend+0x1f2/0x2f0 [dm_mod]
     ? table_deps+0x1b0/0x1b0 [dm_mod]
     ctl_ioctl+0x300/0x5f0 [dm_mod]
     dm_compat_ctl_ioctl+0x7/0x10 [dm_mod]
     __x64_compat_sys_ioctl+0x104/0x170
     do_syscall_64+0x184/0x1b0
     entry_SYSCALL_64_after_hwframe+0x46/0x4e
    RIP: 0033:0xf7e6aead
    <snip>
    ---[ end trace 0000000000000000 ]---
    
    Fixes: ffcc39364160 ("dm: enhance internal suspend and resume interface")
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9029c1004b933..dc8498b4b5c13 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2733,6 +2733,9 @@ static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_fla
 
 static void __dm_internal_resume(struct mapped_device *md)
 {
+	int r;
+	struct dm_table *map;
+
 	BUG_ON(!md->internal_suspend_count);
 
 	if (--md->internal_suspend_count)
@@ -2741,12 +2744,23 @@ static void __dm_internal_resume(struct mapped_device *md)
 	if (dm_suspended_md(md))
 		goto done; /* resume from nested suspend */
 
-	/*
-	 * NOTE: existing callers don't need to call dm_table_resume_targets
-	 * (which may fail -- so best to avoid it for now by passing NULL map)
-	 */
-	(void) __dm_resume(md, NULL);
-
+	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	r = __dm_resume(md, map);
+	if (r) {
+		/*
+		 * If a preresume method of some target failed, we are in a
+		 * tricky situation. We can't return an error to the caller. We
+		 * can't fake success because then the "resume" and
+		 * "postsuspend" methods would not be paired correctly, and it
+		 * would break various targets, for example it would cause list
+		 * corruption in the "origin" target.
+		 *
+		 * So, we fake normal suspend here, to make sure that the
+		 * "resume" and "postsuspend" methods will be paired correctly.
+		 */
+		DMERR("Preresume method failed: %d", r);
+		set_bit(DMF_SUSPENDED, &md->flags);
+	}
 done:
 	clear_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
 	smp_mb__after_atomic();
