Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792928810;
	b=LWS0EsHoGlK6b/ffWFJ17w+0WF5D7BpVpnVteOG/fu8iH1xEXtxfjC9hUbduYs3Mg34R
	 CFMebK/oklEzDd17wxcbvzkwSIYDdY6PKT6ggWAxZMBZHEUoP5eto3ZCYuUdAwDH8gj9s
	 otub9a3m2rKcVVzlvwh4Q5jz/CazR+SfXCWDJOhaGzV1BBQvASoW6YwLibq4nwT41SmVE
	 t/PkbLQjvpQ+u/nbEwGURQtRXw7M5xzmNcb/Z7VWxE/uVXG1whaXYXyEpFB59SxO+YR7v
	 i2ZWipU+pa+1mN4+y2PENgqhc3qbnlq5PIK71GYC0DTmeYnLpLcxoROVszvi/gsHOPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792928810;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=34EPicobVnv5oflPmgJcIKRaZYIcjTZOAEPlpjR6amk=;
	b=Wsx1r9LkewvexLK5iKXnNRNHDk15UCPAsKBK8L+Xkp2LAkx/vxaXoHc2KpnvU6BSID74
	 aovRwHvCzPPYBNbDQ/Wg2SHcB64Oxd3f5jpypJJJ6iBYH8ibE151T361y1xj2OcQklntc
	 POmvGuMBTpW/1tq4RxuVyLQvDtIerWPOR6IVzBPswMp89eTz+Uk0MIdBM4oRAhhSC5ckb
	 U9ExFhsHuOjLBeMK9Thfr0j75SADest3R/8Xe1bUznO8VUzHIqBidKfSm0eJ11EKJImeA
	 WtqTTh3lcwaSLUtn8tpL7jGQUg/CRAzHRA1m0GVci/oMo8eEovNowYdgvm03xcE46dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C2606A321
	for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 11:46:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F19C2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4dc57e2a3f2so3584051b6e.0
        for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 04:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792928809; x=1793533609;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=34EPicobVnv5oflPmgJcIKRaZYIcjTZOAEPlpjR6amk=;
        b=ILtdKuZeU/YDy5xgVBxyNU11ERf0tmLUUL/K/cHUi9f2mVEma/uKRSI4LGKMubLeou
         HBeo8kyNwMCPAa6plIqHjkNfqYGS9cQ845dePwvI6jbnT8wQOuzh0Cfb92YADFYmMdlO
         BpuLeI36xTr0nbJAg3fDHWYmc6KXCdSLDlP/vZOSeM4iyQeVS80JQ5gqziKNpLltko9v
         PHa61X8PwlX0xvdAr2AHqf+oi0lrx7IYaYfHer0CT/vebJvGLndK//WC+/OMSBkRmp/T
         zd5OaC2Pel++XDJ/G+sUPebprC05oGoDQdKxeiTmJAA7SusNPY1ogXMSkNeTOZ5GfxqU
         YuKw==
X-Forwarded-Encrypted: i=1; AKwUvBwTnR3Dg+imB+262f9WJJW1zFlpbNshYgSRjmbNIwVjVallf+OB8qwwteu4aEyj9RMBK2NRc3QH3Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYIKqljz1yjB0IOh7/J7VorDRU2cp0sUlYLKb2atKcjbSWCD+Fn0
	0RRgLIXqyy71An+MmzquKYVzflIriDnTP4uFIQFcDsxEw7kta2/UoDGr4fl4eDU+H3dqacGSAHF
	20wPoYcv/yfApTa42lAMAVdK62qTwQuArR5Mqul2wHNgmiaaeQDeaPwlAtGY=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f46:b0:4fb:a089:bf23 with SMTP id
 5614622812f47-55c0039ebb2mr2411383b6e.49.1792928808935; Sun, 25 Oct 2026
 04:46:48 -0700 (PDT)
Date: Sun, 25 Oct 2026 04:46:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6addec28.412b1182.196980.00aa.GAE@google.com>
Subject: [syzbot] [dm?] KASAN: null-ptr-deref Read in dm_kcopyd_client_destroy
From: syzbot <syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4169c9c90532 powerpc/irq: Fix build with CONFIG_PROC_FS=n
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=126fa38e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e397d1e24d3cb03
dashboard link: https://syzkaller.appspot.com/bug?extid=a2626a25eb2595e3ec3c
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166fa38e580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com

workqueue: Failed to create a rescuer kthread for wq "kcopyd": -EINTR
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
BUG: KASAN: null-ptr-deref in dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
Read of size 4 at addr 0000000000000174 by task syz.2.19/6560

CPU: 0 UID: 0 PID: 6560 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
 dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
 __destroy+0x172/0x2f0 drivers/md/dm-cache-target.c:1973
 cache_create drivers/md/dm-cache-target.c:2604 [inline]
 cache_ctr+0x1674/0x2bf0 drivers/md/dm-cache-target.c:2649
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5b039f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5b11ce028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fb5b0626180 RCX: 00007fb5b039f559
RDX: 0000200000000280 RSI: 00000000c138fd09 RDI: 0000000000000004
RBP: 00007fb5b0436b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb5b0626218 R14: 00007fb5b0626180 R15: 00007fff197480a8
 </TASK>
==================================================================


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
