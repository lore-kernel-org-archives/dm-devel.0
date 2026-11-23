Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460750;
	b=Drk2xtvLRIkzeGBhT9D3tAx8eI84ASjNAMPuUpyVdmItiEzCbNv1rPJIuu3hXAb9O3bN
	 5wMUhusqinOp4tQgi/tAdmw5gRQ+VPBWI64Km2/mkLXv9SGgxWCmwuMZO17+AX8ou4EO3
	 YpVc8k8N6d0tvatFh7rnyGiba+OPtPVgbmBNB242zxyKX1iWXxSbAfZrzAE4r6NtqUY9T
	 8lr/7mCauykyJvE0Qrjl+JjtFJcVQRVJALxQ2xeR7VZNbCgkLV2+G7+GFKIqwyNwyiG/O
	 /0nC8tRH7jIWIoKcYVXMTz/Op7N1F6lOhG61wZuGd23430yfU10tdmqn/8yQMS02Lvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460750;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=FapoBdtE6dpS5OngMDMUrCMDlakW/qoOLk+qWyJob5c=;
	b=bkFNx+c7APLZd0BcBySst5PYlFI41fsrCbePNBS4bezJYHi/zJHsz60YRzAeZQc5I0K5
	 /ggsIcC2+GYCLxQtRTtGlpdPiddZWnBzhEUb3WyhbX5VGB+q4X5+/mxGdkU1C3KRkoP7t
	 KO1hRzT6RjINJmQ2aD/ZPmuEvB57OV/D9r/rp+TwAaeAyE283GsJjHE3W3M0sgxbin0CE
	 3GF6IHx7/FYUfPHKEZxm/8JoxI2fuLxMqRZDImIpZa1S7jdHTK42kUpkR25//kGFejpds
	 1YIo0wINoVHkBsBLD07qg+h0euERWt/2h1qI2oF56UAHxLWLLakzyBI7ij6NTDxChYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8A3606A32A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 19:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D8A3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-540537f959fso4022705b6e.0
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 11:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460749; x=1796065549;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FapoBdtE6dpS5OngMDMUrCMDlakW/qoOLk+qWyJob5c=;
        b=PUPkP/2McfSmJcN0RKy3+96+ZZYtT7utTxUuqV53NJYPvAeyEPjQkjfQLliAQ9o/lA
         O7O0FhoK+d9+MCHduM4asizi+4ymP+Q8kTej4w+eTwzg5mfcBBV6BkTBKK2DMuSzGjy6
         5d2MX2LujtJP1NiTgc2M1pjbvqKuu5Sd5Jvvb5h6NQ9sSYBEEsWwmWCaBxzMu/HY4Z3S
         cEYSOGhF0KYMLemRar/WgmooxiMBCsYQrqGen4gPMp147WrGaeNuf/tASdQVmmxOJNoq
         vhYfJOdfPsZGVD9iET2sJ8sEq4wtgGq+fESbuYNEJIVqYZVW5bNoJZl1Bgj5wGQ6MOcl
         mOsQ==
X-Forwarded-Encrypted: i=1; AL+hErFudECmYvKX3578uMAWihKwaT6bM4GOLFU8Tx+eBinHI6JbxdDw7iaQwbatY3GTspRc63jzKX4SEg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8BDN2DgIx4cp2RZzEKaYwu05voYo4RN7mpfKMOqBPOy7AFlH3Q
	n3P1HcMAW2q0Cl61qpeTOkW6QgmImMdAWQ7iZHUrmcxyur5/4VRKbzvFD2fTa8BU0CPMJ1v9yQh
	wQdkzkW6mgOG546/mpBQ15IrwiiO/I8JXU59WTn4IHkO9avkq5jwn/TEaFKQ=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1383:b0:55b:f88d:6ed4 with SMTP id
 5614622812f47-57a09c0f646mr13201052b6e.22.1795460749697; Mon, 23 Nov 2026
 11:05:49 -0800 (PST)
Date: Mon, 23 Nov 2026 11:05:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b048e8d.71deaa98.2984e6.000f.GAE@google.com>
Subject: [syzbot] [dm?] UBSAN: shift-out-of-bounds in verity_ctr
From: syzbot <syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a041bdbe1f3a arm64: Drop stdint.h type overrides from asm/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=141908e9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e8e6c1701ad8af2
dashboard link: https://syzkaller.appspot.com/bug?extid=3f8f5b65af8de862dcec
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1437db63580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109d0763580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ed0e5cdd75d2/disk-a041bdbe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/219ccd252cd7/vmlinux-a041bdbe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/adb21ff27181/Image-a041bdbe.gz.xz

The issue was bisected by AI to:

commit b1bf2de07271932326af847a3c6a01fdfd29d4be
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Jul 10 22:41:16 2013 +0000

    dm verity: fix inability to use a few specific devices sizes

AI reasoning:   https://syzkaller.appspot.com/ai_job?id=8e0ed690-e35a-4012-88f9-7dc58c455e6c

AI-generated root cause summary:
In verity_ctr() in drivers/md/dm-verity-target.c, the loop computing v->levels
checks `v->hash_per_block_bits * v->levels < 64` before incrementing v->levels,
allowing `v->levels * v->hash_per_block_bits` to reach 64 or more while still
passing the `DM_VERITY_MAX_LEVELS` (63) check. When computing the block count
`s` for the top Merkle tree level (`i = v->levels - 1`), `verity_ctr()` shifts
64-bit `sector_t` values by `(i + 1) * v->hash_per_block_bits` (>= 64),
triggering UBSAN shift-out-of-bounds. Additionally, the numerator
`v->data_blocks + ((sector_t)1 << shift) - 1` is not protected against 64-bit
`sector_t` overflow.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3f8f5b65af8de862dcec

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com

The cause commit was identified by AI and may be wrong.
If you agree with it, please also add:
Fixes: b1bf2de07271 ("dm verity: fix inability to use a few specific devices sizes")

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in drivers/md/dm-verity-target.c:1590:38
shift exponent 64 is too large for 64-bit type 'sector_t' (aka 'unsigned long long')
CPU: 1 UID: 0 PID: 4949 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 ubsan_epilogue+0x14/0x48 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x224/0x264 lib/ubsan.c:494
 verity_ctr+0xfc8/0x1660 drivers/md/dm-verity-target.c:1590
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
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
---[ end trace ]---
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in drivers/md/dm-verity-target.c:1591:6
shift exponent 64 is too large for 64-bit type 'sector_t' (aka 'unsigned long long')
CPU: 1 UID: 0 PID: 4949 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 ubsan_epilogue+0x14/0x48 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x224/0x264 lib/ubsan.c:494
 verity_ctr+0x1000/0x1660 drivers/md/dm-verity-target.c:1591
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
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
---[ end trace ]---
device-mapper: table: 248:0: verity: Hash device is too small (-E2BIG)
device-mapper: ioctl: error adding target to table


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about AI bisection see: https://goo.gl/tpsmEJ#ai-bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
