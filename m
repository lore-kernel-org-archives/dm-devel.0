Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793286121;
	b=jILG8LnMJFzOs1hF6To+45gJEe+qP8NFUSRE6KZXVIkmn0VIQpQlU+IhYI35fTEdxvmP
	 2VO1LtXjq/hWZwglF+8pQbXprZLj04PW1Ssg9fW3+Gttja7nJCTS00UaKjfoFypXVIthg
	 B4dNgE4IgBPO5BK7MqqFpSnDTWbXisPesVPL/T2mma9lK9lDj5PRyhaOk92nEENrQ3rQ5
	 hKy8Ab2ZfUgzGGnrlmozVX4z7k/qulR1q1DUMswNPsm5OO3JRp5l2bP7adZlj3XQm6FhM
	 zsMzTleIsm3AWXzjsypnF452Z45mnvHQYKP6owhdg48QPqdnqPZ0FYFQx6c1VrmUwpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793286121;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=tlm0i/X00g3mnPKVrqb6Nd424jvsp5LSqDun6WcTekQ=;
	b=UtOn9Ypfu/brYbYqMFs/sM/WUxXmla0hnF0tJCLM5sk/pQCNIcMrXZ2ONiQfX98bx0Sx
	 v/pI3ZZo1kqnvcm51f6UyCnwkd0psXMW3PG6yY7J7ecnPK3Y7S0Blvf6xviEsSlZH0dFb
	 2AsyTMbL6cNI2zFA92W7+RxjHup+rhnhaHo2fSGbtXxAFnHUQTo7uGDm4GjFWOfRXJn8j
	 wRnbZJco+wkczq9YJx5Fjl1ZrV/UWT2UXXjlYXIPBqeVe0ooPCgHGxlZZ3SD8qSt/sdXS
	 aIfw0PnZZaXtc4t/xQ4tzC3nUstYXt8PxTDQdYdrG5hpsKTewqc3uIQ8fBXo5pNq35Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED5606A31C
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 15:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82ED5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a45b3f0bdfso3002016b6e.1
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 08:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793286120; x=1793890920;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tlm0i/X00g3mnPKVrqb6Nd424jvsp5LSqDun6WcTekQ=;
        b=dilzJkRr9+d2NWFtdqtwnHDB1/PADx3VyV8j/roviN/KPpWzytOOlft0GYj0h6OGcX
         wGhZ90/15r6Qg1wBR+yxBIsMCIKIJ8SfeTguB9tXGHzctXeOp30jB9pg6Nwo5w2kA5Wq
         ES5SY4PJlIparoYra+tYKaGFEfUCL7c/4Txep6EbKYHNg1uO4HNHzOnONeXGj4JTl16F
         qPkvIsoEYAsu8LFsoEpsCg+kABljhBmOksgXfZFW7o7SXxTsk+q1QLMxIWZ3PdL57FSc
         dnrBSekiBFqOTTcLzdXbx/ztOH+zA7g6WN5njURE2ID8AU3jKQABNOqs61C+fkzmBUw2
         ee3w==
X-Forwarded-Encrypted: i=1; AKwUvBzHcH6UeCS4cFMGzsEzvaB9O9c2hhwtE/FjlS15QZeaPN+IJseKQvnKhkA153riHl2v4pfwVpFQRw==@lists.linux.dev
X-Gm-Message-State: AFq9FYL9+yOCuwO8Pei+xq0WUEdS0KpHtYn/FM48OIlNliDth54QuK6b
	Cla5+EZlzM1ksAA+BvMQ+Lxy1ntg57XQj74DoetbxDhqfi/fZ8KftF9l0JHU/el4fz7m2XxBO/Z
	bOffRNqoUzTHvyAm3ZByK3bJcftqV1QP9iMT/3CdF4qfx1uf7k8LgbS9XLLE=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6408:b0:4b3:3e1:4a25 with SMTP id
 5614622812f47-56385c45dc6mr3774403b6e.11.1793286120516; Thu, 29 Oct 2026
 08:02:00 -0700 (PDT)
Date: Thu, 29 Oct 2026 08:02:00 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae35fe8.ca891901.26044a.014c.GAE@google.com>
Subject: [syzbot] [dm?] KASAN: slab-use-after-free Read in dm_put_device
From: syzbot <syzbot+9519233e6d144970bbc2@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    330517c63aa9 Merge tag 'char-misc-7.4-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13608531580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b03c85f3988bfcd5
dashboard link: https://syzkaller.appspot.com/bug?extid=9519233e6d144970bbc2
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bd638e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15bd638e580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-330517c6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecb230491807/vmlinux-330517c6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ace3132a7acc/bzImage-330517c6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9519233e6d144970bbc2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:650 [inline]
BUG: KASAN: slab-use-after-free in string+0x471/0x4d0 lib/vsprintf.c:732
Read of size 1 at addr ffff888030bb3db4 by task syz.0.17/6012

CPU: 0 UID: 0 PID: 6012 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 string_nocheck lib/vsprintf.c:650 [inline]
 string+0x471/0x4d0 lib/vsprintf.c:732
 vsnprintf+0x422/0x1300 lib/vsprintf.c:2948
 vprintk_store+0x3b3/0xbe0 kernel/printk/printk.c:2307
 vprintk_emit+0x139/0x6b0 kernel/printk/printk.c:2455
 _printk+0xcf/0x110 kernel/printk/printk.c:2504
 dm_put_device+0x2fa/0x3a0 drivers/md/dm-table.c:467
 pool_ctr+0x3b8/0x2380 drivers/md/dm-thin.c:3431
 dm_table_add_target+0x58b/0xee0 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x3b9/0x7b0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl+0x4d2/0xcc0 drivers/md/dm-ioctl.c:2221
 dm_ctl_ioctl+0x22/0x30 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcd6159f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcc68ce338 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fcd61825fa0 RCX: 00007fcd6159f559
RDX: 00002000000004c0 RSI: 00000000c138fd09 RDI: 0000000000000003
RBP: 00007fcd61636b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcd61825fac R14: 00007fcd61825fa0 R15: 00007fcd61825fa0
 </TASK>

Allocated by task 6012:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_node_noprof+0x30c/0x710 mm/slub.c:5699
 _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
 open_table_device drivers/md/dm.c:733 [inline]
 dm_get_table_device+0x2fc/0x820 drivers/md/dm.c:821
 dm_get_device+0x525/0x7e0 drivers/md/dm-table.c:388
 pool_ctr+0x2a8/0x2380 drivers/md/dm-thin.c:3329
 dm_table_add_target+0x58b/0xee0 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x3b9/0x7b0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl+0x4d2/0xcc0 drivers/md/dm-ioctl.c:2221
 dm_ctl_ioctl+0x22/0x30 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6012:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2780 [inline]
 slab_free mm/slub.c:6630 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6923
 close_table_device drivers/md/dm.c:798 [inline]
 dm_put_table_device+0x2bf/0x380 drivers/md/dm.c:841
 upgrade_mode drivers/md/dm-table.c:326 [inline]
 dm_get_device+0x3f1/0x7e0 drivers/md/dm-table.c:399
 pool_ctr+0x362/0x2380 drivers/md/dm-thin.c:3336
 dm_table_add_target+0x58b/0xee0 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x3b9/0x7b0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl+0x4d2/0xcc0 drivers/md/dm-ioctl.c:2221
 dm_ctl_ioctl+0x22/0x30 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888030bb3d80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 52 bytes inside of
 freed 96-byte region [ffff888030bb3d80, ffff888030bb3de0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888030bb3c80 pfn:0x30bb3
flags: 0xfff00000000200(workingset|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000200 ffff88801d442280 ffffea00008fef50 ffffea0000ba1e50
raw: ffff888030bb3c80 0000000000200016 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 446, tgid 446 (kworker/u33:10), ts 8752841003
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1854
 prep_new_page mm/page_alloc.c:1862 [inline]
 get_page_from_freelist+0x1113/0x35e0 mm/page_alloc.c:3933
 __alloc_frozen_pages_noprof+0x2f6/0x3190 mm/page_alloc.c:5429
 alloc_slab_page mm/slub.c:3384 [inline]
 allocate_slab mm/slub.c:3499 [inline]
 new_slab+0xb1/0x6d0 mm/slub.c:3550
 refill_objects+0xe3/0x410 mm/slub.c:7539
 refill_sheaf mm/slub.c:2917 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4811
 alloc_from_pcs mm/slub.c:4887 [inline]
 slab_alloc_node mm/slub.c:5021 [inline]
 __kmalloc_cache_node_noprof+0x517/0x710 mm/slub.c:5695
 _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
 __get_vm_area_node+0x124/0x350 mm/vmalloc.c:3237
 __vmalloc_node_range_noprof+0x2ad/0x1440 mm/vmalloc.c:4079
 __vmalloc_node_noprof+0xad/0xf0 mm/vmalloc.c:4180
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct kernel/fork.c:930 [inline]
 copy_process+0x80b/0x84c0 kernel/fork.c:2141
 kernel_clone+0x176/0x9d0 kernel/fork.c:2783
 user_mode_thread+0xd1/0x120 kernel/fork.c:2860
 call_usermodehelper_exec_work kernel/umh.c:169 [inline]
 call_usermodehelper_exec_work+0xcb/0x180 kernel/umh.c:155
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
page last free pid 446 tgid 446 ts 8752713246 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1401 [inline]
 __free_frozen_pages+0x7b4/0x1110 mm/page_alloc.c:2952
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
 __kasan_populate_vmalloc+0x1ea/0x210 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0x963/0x2bc0 mm/vmalloc.c:2145
 __get_vm_area_node+0x1ed/0x350 mm/vmalloc.c:3248
 __vmalloc_node_range_noprof+0x2ad/0x1440 mm/vmalloc.c:4079
 __vmalloc_node_noprof+0xad/0xf0 mm/vmalloc.c:4180
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct kernel/fork.c:930 [inline]
 copy_process+0x80b/0x84c0 kernel/fork.c:2141
 kernel_clone+0x176/0x9d0 kernel/fork.c:2783
 user_mode_thread+0xd1/0x120 kernel/fork.c:2860
 call_usermodehelper_exec_work kernel/umh.c:169 [inline]
 call_usermodehelper_exec_work+0xcb/0x180 kernel/umh.c:155
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888030bb3c80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888030bb3d00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff888030bb3d80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                     ^
 ffff888030bb3e00: 00 00 00 00 00 00 00 00 00 03 fc fc fc fc fc fc
 ffff888030bb3e80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
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
