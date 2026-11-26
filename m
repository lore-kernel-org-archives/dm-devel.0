Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795685139;
	b=rECiSAI56mvuU+r2c1x2NajbA+/wFdEmZzjiP7eSf0c2Ej8ZcBsoLfVD77kQFPnty4Q5
	 6zcJPPtGltNjl2dLmT3Yxeob1DYVsVDjBIQu0UBUhsOmAGr3ikKT2Hp84WyAvM5c0k0Pm
	 IBhdAvTwUIdATDZsbWXLouj0WrkdyS2eerRDX2MNfIUNpzcL9/A5vrzh+d9HR6PkN8P6c
	 vX9QMq9lxIrXm3uB/LVLer/ylbDqZ22qqZdbQhzLaq/aqwToQ0t+cfXJiG3ZyUshF5tIQ
	 fS3Ccxa6iNJ7MBgBE0GjBWlxCw2bLH1dgk/UfqpZccbatM7iJE8FZGp4ps7PMNupb/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685139;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=FJW2OX9YfUAQ9Yp6YIC4CwXWEFSO2K1Y7iNo2CEnDww=;
	b=gw93CV3Eqg6sGwH5ab75mDnhlPxAhmkgeen3cf0KQEMHGp69fa7jM5eDO/uypUkM9iHl
	 22ZfDdl1u50PAVqXAgY3UTFVweKl73U9wqy+uYtdxyi8MTL5Rqd1gpzbNHyi5W8FAWDXP
	 pYQLGJ0btzmC7I1rwtw3h2xg5vMRG658Pcyutx9uchaECSpxpx/CUTHU4WUYOaw2nUlh7
	 umSU2N0kco7fk3Q3BdblcGNmrIe+3XG9kecChEshHec4vYnCKUSneJsaYLwi3OiBrJWVH
	 UcQe3Kj3xzBx/U2uNq69bAC3sAxQZIeXJMQkyB+MoIBf6MaKNRo6U3RJaUtpSl0OFQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CDA606A321
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 09:25:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73CDA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4db3db8687fso8481425b6e.0
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 01:25:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795685138; x=1796289938;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FJW2OX9YfUAQ9Yp6YIC4CwXWEFSO2K1Y7iNo2CEnDww=;
        b=UT2AViJu7Kr85/vxWvXT1dJfQ1647j48BwZoqsgMcHaQuf3x1deHPqegQkF5xvP4rT
         EWf768kqyvobcs7FWWSOxdIXYl5ndDlkmYyoogrEyL9JLSVEF4TxI6/PIxQnusoXcTwO
         HDqjbHgykQlLMag6vW9KxAbW1yc9tvU7j7tHXta90XpagC/66GTFyRW9c+tXmo4/2UjE
         hSdkkLFfWIQw8p4Jeofbul9hnzPr+jsbZeewFj0nu+5wHooIqf4jtyj5UXRf7axidHLb
         rCpzymOtxn3xAeRk/oHudZXFsQNfAPI3GAE7u3DqoxI6uAcd8Lb6ZxOGGB4uHoca/zGR
         2QQA==
X-Forwarded-Encrypted: i=1; AL+hErFHH1fr7ZTk3lQEJpAnUeY0hpTdXpirswAMByVGth4/jQebQvpqhgMEiFtbHh9ERiSf9RQZjceSWQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8sewa9CjeSXSr1aYzqUeI8gmcy9QkKFw4GI9FRMKkd8csjiOt9
	/DpeKTN0DxVcGV0M81jMFfnRsg1TPd/n6tz9MJ9s+IAxcv1olIHkxUM3/qrppIa8rqEmaqeo1JT
	zwqrHiUN0k2cQV/wSH6oo+Dy3vwDFvfEUsFvbbddIZ8X0jaqT531dMvQFQgo=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:179f:b0:4d6:90f3:74a2 with SMTP id
 5614622812f47-57a0c09bea9mr22441640b6e.45.1795685138534; Thu, 26 Nov 2026
 01:25:38 -0800 (PST)
Date: Thu, 26 Nov 2026 01:25:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b07fb12.1fb41460.314c8.0066.GAE@google.com>
Subject: [syzbot] [dm?] WARNING in vfree
From: syzbot <syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8d7fe9885c62 Merge tag 'hid-for-linus-2026112301' of git:/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14233865580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=462e918ed4cc6d73
dashboard link: https://syzkaller.appspot.com/bug?extid=1eda626824b6334f5ad3
compiler:       Debian clang version 22.1.8 (1~deb13u5), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e9b26d580000

The issue was bisected by AI to:

commit 7c9e6c17325fab380fbe9c9787680ff7d4a51abd
Author: Alasdair G Kergon <agk@redhat.com>
Date:   Tue Oct 21 16:44:55 2008 +0000

    dm exception store: refactor zero_area

reasoning:      https://syzkaller.appspot.com/ai_job?id=6cbd8234-0194-4412-aaf9-4e1c4e6d5e7e

AI-generated root cause summary:
In drivers/md/dm-snap-persistent.c, alloc_area() allocates three vmalloc buffers
(ps->area, ps->zero_area, and ps->header_area) for struct pstore. When
allocating ps->zero_area or ps->header_area fails (such as under memory
pressure), the error path calls vfree() on the already-allocated buffer(s) and
returns -ENOMEM without resetting ps->area (or ps->zero_area) to NULL. On
failure of persistent_read_metadata(), snapshot_ctr() tears down the exception
store via dm_exception_store_destroy() -> persistent_dtr() -> free_area(), which
invokes vfree() on the dangling ps->area (and ps->zero_area) pointer a second
time.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=1eda626824b6334f5ad3

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com

The bisection result may be wrong.
If you agree with it, please also add:
Fixes: 7c9e6c17325f ("dm exception store: refactor zero_area")

------------[ cut here ]------------
Trying to vfree() nonexistent vm area (ffffc90024410000)
WARNING: mm/vmalloc.c:3540 at vfree+0x463/0x490 mm/vmalloc.c:3539, CPU#0: syz-executor415/5665
Modules linked in:
CPU: 0 UID: 0 PID: 5665 Comm: syz-executor415 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:vfree+0x466/0x490 mm/vmalloc.c:3539
Code: e8 1f d6 98 ff 4c 89 f7 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d e9 19 f9 ff ff e8 04 d6 98 ff 48 8d 3d 4d e3 92 0f 4c 89 f6 <67> 48 0f b9 3a e9 42 fd ff ff e8 eb d5 98 ff 4c 89 e7 e8 23 00 00
RSP: 0018:ffffc9000364f868 EFLAGS: 00010293
RAX: ffffffff82307c2c RBX: 0000000000000000 RCX: ffff88803d920000
RDX: 0000000000000000 RSI: ffffc90024410000 RDI: ffffffff91c35f80
RBP: ffffc9000364fa38 R08: ffffffff9bf28a83 R09: 1ffffffff37e5150
R10: dffffc0000000000 R11: fffffbfff37e5151 R12: 1ffff1100277eb03
R13: ffff88800c1c1898 R14: ffffc90024410000 R15: 00000000ff00ff00
FS:  000055558a755400(0000) GS:ffff88808a9e9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f23c5db2bd0 CR3: 000000003f9e6000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 free_area drivers/md/dm-snap-persistent.c:207 [inline]
 persistent_dtr+0xb2/0x170 drivers/md/dm-snap-persistent.c:604
 dm_exception_store_destroy+0x5c/0xc0 drivers/md/dm-exception-store.c:257
 snapshot_ctr+0x10a0/0x1380 drivers/md/dm-snap.c:1421
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:765
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:52 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffb7fb0744b
Code: Unable to access opcode bytes at 0x7ffb7fb07421.
RSP: 002b:00007ffe9db1e5a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007ffb7fb0744b
RDX: 00007ffe9db1e600 RSI: 00000000c138fd09 RDI: 0000000000000003
RBP: 0000000000000008 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe9db1e760
R13: 00007ffe9db1f640 R14: 00007ffe9db1f660 R15: 00007ffe9db1f6b0
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 1f d6 98 ff       	call   0xff98d624
   5:	4c 89 f7             	mov    %r14,%rdi
   8:	48 83 c4 10          	add    $0x10,%rsp
   c:	5b                   	pop    %rbx
   d:	41 5c                	pop    %r12
   f:	41 5d                	pop    %r13
  11:	41 5e                	pop    %r14
  13:	41 5f                	pop    %r15
  15:	5d                   	pop    %rbp
  16:	e9 19 f9 ff ff       	jmp    0xfffff934
  1b:	e8 04 d6 98 ff       	call   0xff98d624
  20:	48 8d 3d 4d e3 92 0f 	lea    0xf92e34d(%rip),%rdi        # 0xf92e374
  27:	4c 89 f6             	mov    %r14,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 42 fd ff ff       	jmp    0xfffffd76
  34:	e8 eb d5 98 ff       	call   0xff98d624
  39:	4c 89 e7             	mov    %r12,%rdi
  3c:	e8                   	.byte 0xe8
  3d:	23 00                	and    (%rax),%eax


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#ai-bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
