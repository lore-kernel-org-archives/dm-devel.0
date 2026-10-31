Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793466207;
	b=xtEVb+nn1dpdXrmQHEqfhLm2ZgSaIb+0btZBI6HJtRS+26bg2qWc5Wc4S71tw3cze5wO
	 EoLpXL92dflRCDuExbJWvIk6CUEAQYYVkxGE//wkuvLpG0J95vkf9EgSQrbdSzeJXUN/U
	 gZ5kZ4k2vjyjOQ8+HVYzzXScJBvO0s3CEzkpxTD3mPu7iqqsaSsQqBsB768Itc/z0r+8Y
	 3JbfpMZUyJOI3A+rF3GNeZ/kmoe7ZVxA8/qJfRyz0qeab7CWXJ8+jUTOwikzYIRHMqrJW
	 Txj2X2aSc2CjKkOLOcD2fTvlROwg1+XA0jYxb0eKOKfKu2Kvrd1eK+oHw+dptXbcq1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793466207;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=MlMtqKj18iSXb8nw+n8INtP/5uNxGvguzDAOdopuKYY=;
	b=TXoXidXc2b+jn/QznzjXwi8mJ9HO2r0E8tbgZW9jt70K2YzzydX0jJqaPhPK/tn9+x47
	 Ra444y5UgvKQaEJ0dYDsKcjiQZXvjj2i8kBrdZK6FKR3xnqoZCJ0kJ0o0uZepj0p5GosR
	 MZ8RmKz/d4oBwxvWomF6/iavPTJwEv6S10ND09Wn+Wu5pIWW7l4phzDQ27ZJjewQdxw6Y
	 oTBzl79WO1VfYTc8I+yUSwoIWtfYHlvVuheTSRAP5e7Lmu8Zvak0wCoDpSur0JeqDgvT5
	 tMeWVeDK5HDz4DLvYQoh7z2y+mXOVSEhbgufwL8vYoih54lkeibiCoHMScxcISPWK0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD1606A31C
	for <dm-devel@lists.linux.dev>; Sat, 31 Oct 2026 17:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFCD1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-5640a2d9708so2479562b6e.1
        for <dm-devel@lists.linux.dev>; Sat, 31 Oct 2026 10:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793466206; x=1794071006;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MlMtqKj18iSXb8nw+n8INtP/5uNxGvguzDAOdopuKYY=;
        b=A5G7wi7ry1Fvq80qzDIDEcuVU0GkmHLIyjvHKnnUNYGKp8tY7RP3XmiPxNcncDs/59
         p5jA2BXPmZxLT52Nru8Cdt/MDHUMKdj8AThTtshl7cK/82XnB+OGrnlZGrYmQW6y28/G
         qbIJdVpMnRaxcbj0awwXsA7j2G/BrPJDgtLCdDSNwNXpnOoy8kJGGqqvvhR8FNM6+VgI
         gaJ0kFt2yEyT42XSkvjVTNofQjtF/nGZt6W8IPOutaavcEEb2LBIv0P5sB3ytvSbJrZj
         CINBpgd5x0x4L01aGZjmjPuFZkWvlN0CMBe4nHl+5i2QP1qZluKYF4Oez0TVBG2CUqaP
         n8TQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjKKMoKIesz8zay8bNgF7ub+uY22DbvVy6ObsbeauwmZDL2qqYFTZau+4civ2KRNgYmVtXj2ZRww==@lists.linux.dev
X-Gm-Message-State: AFq9FYLCcjDAGSUS2NwaH3NK5ULTjjqKTxYKSczoIJlZidlwUrnazsGw
	wZLY/nBkXPOnTVbYYPrKrLpuztUKMUVJ8TMJjLnGiJdGTucC+7PzGqdOV8AXy6NEA+vhQx8mGWU
	McU2f8fMCA44N8hcZCC8UmXVAlZJd3Wv6liDxWKliqqtEosdy2sWRI+u1+5I=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b07:b0:4c4:5f5b:6918 with SMTP id
 5614622812f47-5640ddf9e47mr3620539b6e.16.1793466205822; Sat, 31 Oct 2026
 10:03:25 -0700 (PDT)
Date: Sat, 31 Oct 2026 10:03:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae61f5d.61c4c7f9.11e392.001b.GAE@google.com>
Subject: [syzbot] [dm?] WARNING: zero-size vmalloc in cache_ctr
From: syzbot <syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7a19f0cc94ad Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=149de721580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6602d83d2f34eb80
dashboard link: https://syzkaller.appspot.com/bug?extid=c8564fc0a96e3ecbe4d4
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c56469580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1330b721580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/26f2e4202da9/disk-7a19f0cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1e23a9081d19/vmlinux-7a19f0cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b51f551829ee/Image-7a19f0cc.gz.xz

AI-generated root cause summary:
In drivers/md/dm-cache-target.c, calculate_discard_block_size() doubles
discard_block_size beyond 32 bits when origin_sectors is very large, and calls
sector_div() which truncates the divisor to a 32-bit uint32_t, resulting in
division by zero. On arm64, division by zero architecturally yields 0, setting
discard_nr_blocks to 0 and triggering a zero-size vzalloc() that hits
WARN_ON_ONCE(!size) in __vmalloc_node_range_noprof; the error is subsequently
caught by dm-cache-target and cleanly returned as -ENOMEM. On x86_64, the same
division by zero triggers an unhandled #DE divide error kernel oops.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=c8564fc0a96e3ecbe4d4

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/vmalloc.c:4037 at __vmalloc_node_range_noprof+0xe7c/0xe9c mm/vmalloc.c:-1, CPU#1: syz.0.17/4933
Modules linked in:
CPU: 1 UID: 0 PID: 4933 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/14/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : __vmalloc_node_range_noprof+0xe7c/0xe9c mm/vmalloc.c:-1
lr : __vmalloc_node_range_noprof+0xe78/0xe9c mm/vmalloc.c:4037
sp : ffff800098787520
x29: ffff800098787660 x28: 00e8000000000703 x27: 0000000000000000
x26: 0000000000000000 x25: ffff7000130f0ec0 x24: fffffdffbf800000
x23: 0000000000000000 x22: 00000000ffffffff x21: 0000000000000000
x20: 0000000000000dc0 x19: dfff800000000000 x18: ffff8001237d4000
x17: ffff0001acf92e25 x16: ffff0000ca311d94 x15: 0000000000000009
x14: 00000000006328cc x13: 0000000000000001 x12: 0000000000000000
x11: ffffc1ffbf800000 x10: 000000f000000000 x9 : 0000000000000000
x8 : 0000000000000000 x7 : 00000000ffffffff x6 : 0000000000000000
x5 : 00e8000000000703 x4 : 0000000000000dc0 x3 : ffff800080aa2768
x2 : 0000000000000000 x1 : ffff0000ca311d80 x0 : 0000000000000000
Call trace:
 __vmalloc_node_range_noprof+0xe7c/0xe9c mm/vmalloc.c:-1 (P)
 __vmalloc_node_noprof+0xec/0x14c mm/vmalloc.c:4165
 vzalloc_noprof+0x3c/0x4c mm/vmalloc.c:4243
 alloc_bitset drivers/md/dm-cache-policy-internal.h:126 [inline]
 cache_create drivers/md/dm-cache-target.c:2529 [inline]
 cache_ctr+0x1258/0x1f1c drivers/md/dm-cache-target.c:2649
 dm_table_add_target+0x44c/0xb18 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x27c/0x764 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x884/0xbbc drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:796
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:815
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
irq event stamp: 8668
hardirqs last  enabled at (8667): [<ffff800080ade8fc>] seqcount_lockdep_reader_access+0x68/0xcc include/linux/seqlock.h:75
hardirqs last disabled at (8668): [<ffff8000868b91fc>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:483
softirqs last  enabled at (8614): [<ffff80008013c764>] local_bh_enable include/linux/bottom_half.h:33 [inline]
softirqs last  enabled at (8614): [<ffff80008013c764>] put_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:251 [inline]
softirqs last  enabled at (8614): [<ffff80008013c764>] kernel_neon_begin+0x294/0x400 arch/arm64/kernel/fpsimd.c:1924
softirqs last disabled at (8612): [<ffff80008013c5ec>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (8612): [<ffff80008013c5ec>] get_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:234 [inline]
softirqs last disabled at (8612): [<ffff80008013c5ec>] kernel_neon_begin+0x11c/0x400 arch/arm64/kernel/fpsimd.c:1883
---[ end trace 0000000000000000 ]---
device-mapper: table: 248:0: cache: could not allocate discard bitset (-ENOMEM)
device-mapper: ioctl: error adding target to table


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
