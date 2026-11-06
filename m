Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979221;
	b=dNV4Zzy8whGfMRX5iPMo8rH8Tt0Ucd0iZIotXjJHcZBBioPfiXzb/hEvv9/VzAOxUr/6
	 eJZgL1emOPAXFzvXaVAcZNfQf0Mv5tVYudCI/e8nXTwuwCo9jguefrRZfkWdhUpQ1x/jy
	 6UFKirSwOlDEbDveisgRNW0wIcNz+yMFElIeCo2k7NXq/GX76Lx8PDbCtHav19oIUPAaS
	 VpgmKYjBxmcsohFt//yWclXrjvDy8k/sL1Vun0q0UgIepbUNdysuU+CBbpoMx6PSj+r++
	 UFHA6qDGokFj4o8dDTXlaMqgQuH8F05QMwPiiajSAOhn3gd/ANbytyh2KR31ChSZHmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979221;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=N+c3mCCtwwdJ0beV8V8fiSYaFX8fBr6RjIsQyUPAIZs=;
	b=WgNuM1dFXlSqxp7mv/ucvLd619Bf8+f3R9p6r1/rK0oHo8IFbV+wr+leCHPq0AgbZbzR
	 8pNnaJptRZaI/8g1m2IAKx7eh/MMQ0ha5oFArs/f0rJSjSa8Bt/BskTnp4vPoH3/yVYb0
	 MVLfih87+guFMYsb3q/beZoUPwynqUWh/txJ+7qwXVEUDRl567D+75biW4XKdCMo4TJU0
	 LeaRejNtfS9F044+qxB3FGJw/D7FbdgBvU2AMZxOc9KMtn6s/hflNa5nLJmvb1VYfG8BV
	 57H7WuNCUh7n4qPOpSRExdSx5av5s+KcGE7f688LB1wInVEe0iILf74RUvcWiOuYE6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83075606A32C
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 15:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83075606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ab4f652f9bso517142b6e.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 07:33:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793979219; x=1794584019;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N+c3mCCtwwdJ0beV8V8fiSYaFX8fBr6RjIsQyUPAIZs=;
        b=pHMs0zfGkL87lqS3b3X8Di0cwyefAn7Fznyoa/c1kH08C9i3T2B02FGddIqNSxan5S
         QCWKbo2WB1Dagd1toj9UmqUy8ZJ/JjLE48UJERSfPdeXbpQNmHApt6D/QzPWmLOGR2uV
         QjXrniP/4ROkW0/l07oWmjEdu5wxxBSAFDI0FN3k+N95BGCJxD6F9a6AC07aEhnyeCGh
         PCmWXAYovqmlug93DOu9laD4iZGAWHLjEQeaNiwi4lM8l8mF+j0eXPRp6j4S0VAOFZCW
         KyyAM4EwzvAziP6r15sc8VW/bRi/8iRR1yL9Y0w8zcI1dpjMR0dy2dyNVvNYaWTM86AV
         lW5g==
X-Forwarded-Encrypted: i=1; AKwUvBz+RaU7IUdyYEVhMuFoLqBiYaKl9ufoIg/nn1s7vqzmMOvtd4vUEbLx+7HPk0NzCcUuNgzmf5Ar5Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z+eftiR1X6J3Q3bbq+kPTa0Jh4hY46XlPKlQ7WfHiu7KnKFQvX7
	wrCCCywKg8yynUCZgBZ4XhM0EHCddYbQ6n3DxuSuyJ0rTOG0EdlXa+KbQ+d9AE12Qa95Xmx9b+5
	/qsnPmfub7yRfyIETWs29KR1MpF0JhTCgaIvGe8bQKAtTRZdVCUweRbf1H7E=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6ec8:b0:4fb:8469:fc4f with SMTP id
 5614622812f47-567e106cf13mr1974564b6e.29.1793979219502; Fri, 06 Nov 2026
 07:33:39 -0800 (PST)
Date: Fri, 06 Nov 2026 07:33:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aedf353.8be4ead1.3b45e1.017d.GAE@google.com>
Subject: [syzbot] [dm?] divide error in cache_ctr
From: syzbot <syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ddfe51b0a0f5 Add linux-next specific files for 20261105
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15c38e55580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3dffa811bfeed6b4
dashboard link: https://syzkaller.appspot.com/bug?extid=3e16980543e238b95bd1
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172a6bdd580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10aa6bdd580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/181043a4bd52/disk-ddfe51b0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a69d8b670c38/vmlinux-ddfe51b0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/906d515c0893/bzImage-ddfe51b0.xz

AI-generated root cause summary:
In drivers/md/dm-cache-target.c, calculate_discard_block_size() repeatedly
doubles discard_block_size in a loop until the origin device has no more than
MAX_DISCARD_BLOCKS (16384) discard blocks. When creating a cache target with a
sufficiently large origin length (ti->len >= 2^45 sectors), discard_block_size
doubles until it reaches 2^32 (1ULL << 32). Because too_many_discard_blocks()
uses sector_div(), which expects a 32-bit divisor (uint32_t), passing 2^32
causes the divisor to truncate to zero. This triggers an unhandled kernel divide
error (#DE), crashing the system with an Oops: divide error.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3e16980543e238b95bd1

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com

Oops: divide error: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5654 Comm: syz-executor515 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
RIP: 0010:too_many_discard_blocks drivers/md/dm-cache-target.c:2386 [inline]
RIP: 0010:calculate_discard_block_size drivers/md/dm-cache-target.c:2397 [inline]
RIP: 0010:cache_create drivers/md/dm-cache-target.c:2525 [inline]
RIP: 0010:cache_ctr+0x1a86/0x2bf0 drivers/md/dm-cache-target.c:2649
Code: 4c 8b 30 31 ff 4c 89 f6 e8 87 30 f5 f8 4d 85 f6 0f 84 81 00 00 00 4c 89 f3 48 c1 eb 20 45 89 ec 48 85 db 74 0a 4c 89 f0 31 d2 <49> f7 f4 eb 08 44 89 f0 31 d2 41 f7 f4 48 3d 00 40 00 00 76 14 4d
RSP: 0018:ffffc900038bf860 EFLAGS: 00010246
RAX: 003fffffffffffff RBX: 00000000003fffff RCX: ffff88807f1c3e80
RDX: 0000000000000000 RSI: 003fffffffffffff RDI: 0000000000000000
RBP: ffffc900038bfa38 R08: ffffc90000bbe007 R09: 0000000000000000
R10: ffffc90000bbe000 R11: fffff52000177c01 R12: 0000000000000000
R13: 0000000100000000 R14: 003fffffffffffff R15: 1ffff1100fec2462
FS:  000055557cd07400(0000) GS:ffff888123259000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004697f0 CR3: 0000000078996000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x00007fdd52f9b8c9
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdc56ed528 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 6d61722f7665642f RCX: 00007fdd52f9b8c9
RDX: 0000200000000000 RSI: 00000000c138fd09 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000013 R09: 0000000000000006
R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffdc56ed698
R13: 431bde82d7b634db R14: 00007fdd5302ec40 R15: 0000000000000002
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:too_many_discard_blocks drivers/md/dm-cache-target.c:2386 [inline]
RIP: 0010:calculate_discard_block_size drivers/md/dm-cache-target.c:2397 [inline]
RIP: 0010:cache_create drivers/md/dm-cache-target.c:2525 [inline]
RIP: 0010:cache_ctr+0x1a86/0x2bf0 drivers/md/dm-cache-target.c:2649
Code: 4c 8b 30 31 ff 4c 89 f6 e8 87 30 f5 f8 4d 85 f6 0f 84 81 00 00 00 4c 89 f3 48 c1 eb 20 45 89 ec 48 85 db 74 0a 4c 89 f0 31 d2 <49> f7 f4 eb 08 44 89 f0 31 d2 41 f7 f4 48 3d 00 40 00 00 76 14 4d
RSP: 0018:ffffc900038bf860 EFLAGS: 00010246
RAX: 003fffffffffffff RBX: 00000000003fffff RCX: ffff88807f1c3e80
RDX: 0000000000000000 RSI: 003fffffffffffff RDI: 0000000000000000
RBP: ffffc900038bfa38 R08: ffffc90000bbe007 R09: 0000000000000000
R10: ffffc90000bbe000 R11: fffff52000177c01 R12: 0000000000000000
R13: 0000000100000000 R14: 003fffffffffffff R15: 1ffff1100fec2462
FS:  000055557cd07400(0000) GS:ffff888123259000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004697f0 CR3: 0000000078996000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	4c 8b 30             	mov    (%rax),%r14
   3:	31 ff                	xor    %edi,%edi
   5:	4c 89 f6             	mov    %r14,%rsi
   8:	e8 87 30 f5 f8       	call   0xf8f53094
   d:	4d 85 f6             	test   %r14,%r14
  10:	0f 84 81 00 00 00    	je     0x97
  16:	4c 89 f3             	mov    %r14,%rbx
  19:	48 c1 eb 20          	shr    $0x20,%rbx
  1d:	45 89 ec             	mov    %r13d,%r12d
  20:	48 85 db             	test   %rbx,%rbx
  23:	74 0a                	je     0x2f
  25:	4c 89 f0             	mov    %r14,%rax
  28:	31 d2                	xor    %edx,%edx
* 2a:	49 f7 f4             	div    %r12 <-- trapping instruction
  2d:	eb 08                	jmp    0x37
  2f:	44 89 f0             	mov    %r14d,%eax
  32:	31 d2                	xor    %edx,%edx
  34:	41 f7 f4             	div    %r12d
  37:	48 3d 00 40 00 00    	cmp    $0x4000,%rax
  3d:	76 14                	jbe    0x53
  3f:	4d                   	rex.WRB


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
