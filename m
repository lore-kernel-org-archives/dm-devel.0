Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C56165BCB;
	Fri, 22 Mar 2024 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711131970; cv=none; b=dXKPffLporT8T5p0Kqrwp8Y10r6Zq463aYwvhieqdrUHwbsADO8oujGYy4Ejk2sDBZZbhdyaPzSJJqvZB/9Sb+TLL87XLVEJMtZr25qrbBlBjkL+NhPf6vwZ8zdVNTaYHODCkUYfH8bi5d/9+DZCQ71SaFBLC2VdFujVi62NvTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711131970; c=relaxed/simple;
	bh=pcP94xVQwA7FBDKV4GxZuobzeESgo2uq+Ed11i6ZN7M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oyE9UT7vpPgDgHYNqnioe7uxPpuCxGFXFnB6y27uL2YgWN69dATJBU3UDMglXWo2ZWgwi2d5xoBQFHvo0Thu6I0l71YR3gdABtQemBkoptB1rLcoh33KmMC5NyXlslphh9kXihGRhwV5oqEk1yrbrQ5JzBNO4FmY8KxyIQHF+Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t4vxYUAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4vxYUAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5720CC433F1;
	Fri, 22 Mar 2024 18:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711131970;
	bh=pcP94xVQwA7FBDKV4GxZuobzeESgo2uq+Ed11i6ZN7M=;
	h=From:To:Cc:Subject:Date:From;
	b=t4vxYUAFMjwwosbgDn64nkqHn1a1TSayIIOG1ENJ0EHcLYUc1A5rDl1vFTBo+43cd
	 RqgE06M9zMbMk81Y7BI5J58bcOTzYYUo6F9QVPpmPPabRFEVZEpKm1SsAxn2UgQhrM
	 3e4h2QvlkaCKK9gCOOmBByo2YOiL76L3ezGSP/iMtlM4UBgHs+7aZ62EQwldoIHLA5
	 /sNUY+mjkSCLOOI7QlG/b0Bg2cRNezLCzXG9R4dt3OsEUpBoV4ezjUWegwfV/jmSPU
	 QdOORJZ3VNbspktusEVQaWbAEHu/TdboDyfkYcBR6+9l9d9Kexsk1PtHORliu2Rkxh
	 W9/W8yFmunzcA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm: call the resume method on internal suspend" has been added to the 6.7-stable tree
Date: Fri, 22 Mar 2024 13:34:49 -0400
Message-ID: <20240322173450.77910-1-sashal@kernel.org>
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

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-call-the-resume-method-on-internal-suspend.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit ee46f088bdd1daa9355a38fae647f3f5bdabcf9f
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
index 23c32cd1f1d88..4ff9bebb81ad5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2945,6 +2945,9 @@ static void __dm_internal_suspend(struct mapped_device *md, unsigned int suspend
 
 static void __dm_internal_resume(struct mapped_device *md)
 {
+	int r;
+	struct dm_table *map;
+
 	BUG_ON(!md->internal_suspend_count);
 
 	if (--md->internal_suspend_count)
@@ -2953,12 +2956,23 @@ static void __dm_internal_resume(struct mapped_device *md)
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
