Received: from mail-oo2-f0.google.com (mail-oo2-f0.google.com [74.125.231.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B92559CB9
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089407; cv=none; b=n/0nBtTn1HMHudkTO82nrNdB+ktDQHL637mOYUpeWaESg8d5vHcep7UZOqFjL8wMMnNMY32AacEk5hzw4qSIteu4KFb709wHMzoMkgmP6S0co+UMXKzGjUGHg2gNnNuxZJLU25QV33tYdFxTnY6V/rSlchNZNAorK8gdYJUcOvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089407; c=relaxed/simple;
	bh=UFEL4EbqlZlIl2PIgjhTvGMox+QLWc5x/ZYc30QxGhU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tS4oCqCm0cJDqlQJqTK1GXEqZRMv+7u52PQ8DCo4oD/1161rqrDLLQrzFTXhqIi27NktnAHj8kEQafyWM7EU71ZzfLHBa8/a/4jjE/wzZOJyCD8b7D10C7oZglkbVEQaS31yJ3RFeHsPG7Mfh1oB8AEIqNvT402fa9WNXNadROQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f0.google.com with SMTP id 006d021491bc7-6a3900cb2b5so2128584eaf.0
        for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 08:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790089404; x=1790694204;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A9RFz1m3zhfRPFD7q79owZVbEzWSRMClL3oSCIMR9lY=;
        b=Y4JwYDqudObpOQRmImEt616E3KLlkc0kqc6dalfkYd6agcvu1FinHInEqI6LFM/o42
         h97tSeBpMDrcSuIqq1pnPXENvfWsyBFFZyhNVjeuYGkXdk/h3t5YPB5UQheMXk0peSXB
         tDS7dlr3Xll2O18ZtMek7ytF4zsTHsJ3LDBPFPmNck8vqeH0/g+KVAnAeCrjHTidS8+J
         QxZ+pMx3ddUbBTKzFw/MwVAWIec+5ZO87RF1ksRuusL2V4ICgyDfcmZ6Ku0fnw1pkxuH
         UtNQiyoi7D7jrVPJEJppbcaOdcETsNj1KXPj9U7aL+2Cv+4pwbzlKwVaP5r7B9kB0GvJ
         sTbw==
X-Forwarded-Encrypted: i=1; AKwUvByV9S/zSWxQFgWvxryGxE6S6to3WU7B0mS/2gfXWrGRBoEkQRZMkYc0hjFAYSt5VvcqdFnR1CUCFA==@lists.linux.dev
X-Gm-Message-State: AFuF++nwtwi57mmLEQEqm0kdLCq4Gt8POMXeQK2460wh1axunmE9KfFy
	LVr2XRzIZ0bPFmY1unRPtS3TD87z1zl7OY1Xz4waOrJ4MAqrz7S3L5AuUUDRRB8S4FSNfkk42wX
	5BqE6QOX2tmdMgevl0S6fQPLdg8xYlHkRIZZEyrmOaXz676hfyKaPbp+VYHM=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:188a:b0:6b7:8415:d78f with SMTP id
 006d021491bc7-6ca9ca56035mr12207866eaf.58.1790089374715; Tue, 22 Sep 2026
 08:02:54 -0700 (PDT)
Date: Tue, 22 Sep 2026 08:02:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab2989e.a6af0033.177e91.0022.GAE@google.com>
Subject: [syzbot] [dm?] KASAN: slab-use-after-free Read in dm_table_get_mode
From: syzbot <syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=116dd805580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
dashboard link: https://syzkaller.appspot.com/bug?extid=bdff1ecf726d2af66afd
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e8f805580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17efe805580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-38872197.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-38872197.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Image-38872197.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in dm_table_get_mode+0x60/0x68 drivers/md/dm-table.c:2121
Read of size 4 at addr ffff0000d75134f4 by task syz.1.7295/2493

CPU: 0 UID: 0 PID: 2493 Comm: syz.1.7295 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/14/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xb0/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0x8c/0xc4 mm/kasan/report.c:595
 __asan_report_load4_noabort+0x20/0x2c mm/kasan/report_generic.c:380
 dm_table_get_mode+0x60/0x68 drivers/md/dm-table.c:2121
 do_resume drivers/md/dm-ioctl.c:1317 [inline]
 dev_suspend+0x40c/0x750 drivers/md/dm-ioctl.c:1360
 ctl_ioctl drivers/md/dm-ioctl.c:2213 [inline]
 dm_ctl_ioctl+0x884/0xbbc drivers/md/dm-ioctl.c:2235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590

Allocated by task 2493:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:78
 kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:570
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x9c/0xb4 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2f4/0x5fc mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 dm_table_create+0x8c/0x2ac drivers/md/dm-table.c:136
 table_load+0x104/0x764 drivers/md/dm-ioctl.c:1631
 ctl_ioctl drivers/md/dm-ioctl.c:2213 [inline]
 dm_ctl_ioctl+0x884/0xbbc drivers/md/dm-ioctl.c:2235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590

Freed by task 2494:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:78
 kasan_save_free_info+0x54/0x6c mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x74/0xa4 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kfree+0x188/0x698 mm/slub.c:6801
 dm_table_destroy+0x32c/0x3a0 drivers/md/dm-table.c:210
 do_resume drivers/md/dm-ioctl.c:1341 [inline]
 dev_suspend+0x5a4/0x750 drivers/md/dm-ioctl.c:1360
 ctl_ioctl drivers/md/dm-ioctl.c:2213 [inline]
 dm_ctl_ioctl+0x884/0xbbc drivers/md/dm-ioctl.c:2235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590

The buggy address belongs to the object at ffff0000d7513400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 244 bytes inside of
 freed 512-byte region [ffff0000d7513400, ffff0000d7513600)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000d7511c00 pfn:0x117510
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x5ffc00000000240(workingset|head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000240 ffff0000c0001c80 fffffdffc3c21e10 fffffdffc35db510
raw: ffff0000d7511c00 000000000010000f 00000000f5000000 0000000000000000
head: 05ffc00000000240 ffff0000c0001c80 fffffdffc3c21e10 fffffdffc35db510
head: ffff0000d7511c00 000000000010000f 00000000f5000000 0000000000000000
head: 05ffc00000000002 fffffdffc35d4401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000d7513380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff0000d7513400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff0000d7513480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff0000d7513500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff0000d7513580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
