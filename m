Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980397;
	b=mwTcLWrtpYqxUycR2S7DoVgM7+XFv1K94Q7nvEyJzLTbBp3O6aQ7RklufESzMFMroixI
	 +D8lx95AszPpX/sb3vjZhfz5wu6PJSQYeZ7EWFGJcOF1KxgjzwUptg1n9dcAE4rvtFMWg
	 4WKvx2xR1Ig6jHHpGYVyV1EIOC7NBKg8763dNSDmmQGI8/7j4jx2dlC8iDkma+25JFu2Y
	 4o8g4x27EjsCfrNb/+FMYDFYqeTrHdS7x6KrzjxQwri+3HBbDD7E/wcIxL8w89F/hQev+
	 D7n/RapA35qP4dul/NQ63QzXOmtX74SNElvdkxU8SpX85h6Lh5KuqIRArW7+bOYSa1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980397;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=mCDfbuXqafwmxqopFgxobKIea2hRK1phNt3ZXaJ/k8Q=;
	b=M3WDSpQN/nPnhaoorXpcH2ieUJ2e8OqKKegcHI4dk8Fc5I44XbGHNfCR+WZVPr9YLxpT
	 OA5SnHWPXROGry7DmZYJS5MNce39skUxi2mZr5TKXZSslAdJoILzq2T3IGfd0qWu/fk6m
	 55MlodVgUVybP/ApeKXsmJQn1gyq2Aa+JWXJWR9xZHcpqKPlK1dBlhNvdgYCiNIHKD7c9
	 CF/hbvFue8U7ITeOLlGGkq7mnmZ1pHnFqprIxGVjh1YoIFGA+Ei3pHUI3ER3iL2vioy8R
	 h9yEzL72ABVWM7JBhSfebYr7IJsxbnRimYzfcBiJGJtwF6W/AFw/vhHOHje6R0vRrHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5510A606A31A
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 02:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5510A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a7de733fa9so3599200b6e.3
        for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 19:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792980396; x=1793585196;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mCDfbuXqafwmxqopFgxobKIea2hRK1phNt3ZXaJ/k8Q=;
        b=EkTsW2C+Mk9Qo1VQiQ08uKngOwu7O//RgHA6gOGy4c/K55ZQARf4EWZV9isvaxLDWk
         GzO9WtuRlyHYW2eMvG4lE+5/SdEFk6omm8LTJL9nFeq9vFEWXxsUZrvLKU2ovNfW85m8
         dFnYPghDxRSdakCPlBiALsYSoYikz3gfXcJEChQcrnAyUfraOSnnH064wmfl3Nazo8eB
         O7AzpkuESt3DxgCZzeDTrNVP9hZ/BgZX86m7NFyn1uZ7BSkTfxTdF7UK3+xfyg7lR8Mf
         XzgogoYIFug3vIa0dR77OiNx1qAP/ErzMYfxfvrNxXbJJREstP12pwy1Tjq3M36/HPLV
         0ngA==
X-Forwarded-Encrypted: i=1; AKwUvBz0wB9g7sCIvdXVnmQfhuladrbmdSy7Tj1tb8fUsTVosRXPVZT/7Lc8g9XCfI7ewW+ED/g0RxrixQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJOd+GJF/kHN9WlT1/iPhOb3mKrdOKpS6txzKYKfxLyE60sthxp
	cHyq14lv7IoTrw2AuyTjPkz3iBkDeWw/v+UGKBkM851OGaSGiDz3p0D3CK5t17EGrqeqqmg/h3Q
	PCsD99iC0SlyS05n0XxU6+5vN30ZnsmAZNCMy9vqJ0KVkspQjKbYeYIIPMqM=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:448b:b0:4f5:4eb5:1cd3 with SMTP id
 5614622812f47-55c003ade87mr3311230b6e.61.1792980396367; Sun, 25 Oct 2026
 19:06:36 -0700 (PDT)
Date: Sun, 25 Oct 2026 19:06:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adeb5ac.a6443767.132891.0053.GAE@google.com>
Subject: [syzbot] [dm?] KASAN: slab-use-after-free Read in pool_ctr
From: syzbot <syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4df4d2a577db Merge tag 'acpi-7.4-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1640f481580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fe03d9a06fc7d5c0
dashboard link: https://syzkaller.appspot.com/bug?extid=83827f9a59abe148bff4
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1140f481580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11246621580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4df4d2a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ff9ee3e3fda0/vmlinux-4df4d2a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a29eeaefab21/bzImage-4df4d2a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in pool_ctr+0x874/0xd60 drivers/md/dm-thin.c:3363
Read of size 8 at addr ffff8880340cc698 by task syz.0.17/5507

CPU: 0 UID: 0 PID: 5507 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 pool_ctr+0x874/0xd60 drivers/md/dm-thin.c:3363
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
RIP: 0033:0x7fad75f9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe43dedf68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fad76225fa0 RCX: 00007fad75f9f559
RDX: 00002000000003c0 RSI: 00000000c138fd09 RDI: 0000000000000003
RBP: 00007fad76036b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fad76225fac R14: 00007fad76225fa0 R15: 00007fad76225fa0
 </TASK>

Allocated by task 5507:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_node_noprof+0x3cc/0x620 mm/slub.c:5582
 _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
 open_table_device drivers/md/dm.c:733 [inline]
 dm_get_table_device+0x23e/0x730 drivers/md/dm.c:821
 dm_get_device+0x327/0x760 drivers/md/dm-table.c:388
 pool_ctr+0x4ae/0xd60 drivers/md/dm-thin.c:3329
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

Freed by task 5507:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6802
 close_table_device drivers/md/dm.c:798 [inline]
 dm_put_table_device+0x255/0x2a0 drivers/md/dm.c:841
 upgrade_mode drivers/md/dm-table.c:326 [inline]
 dm_get_device+0x56f/0x760 drivers/md/dm-table.c:399
 pool_ctr+0x585/0xd60 drivers/md/dm-thin.c:3336
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

The buggy address belongs to the object at ffff8880340cc680
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 24 bytes inside of
 freed 96-byte region [ffff8880340cc680, ffff8880340cc6e0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x340cc
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801c041280 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2, tgid 2 (kthreadd), ts 9397553089
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __kmalloc_cache_node_noprof+0x446/0x620 mm/slub.c:5578
 _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
 __get_vm_area_node+0x155/0x2f0 mm/vmalloc.c:3237
 __vmalloc_node_range_noprof+0x343/0x1540 mm/vmalloc.c:4064
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4165
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct+0x2c6/0xa00 kernel/fork.c:930
 copy_process+0x7ea/0x44b0 kernel/fork.c:2143
 kernel_clone+0x2d7/0x940 kernel/fork.c:2785
 kernel_thread+0x13f/0x1b0 kernel/fork.c:2846
 create_kthread kernel/kthread.c:459 [inline]
 kthreadd+0x4ec/0x6e0 kernel/kthread.c:817
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
page last free pid 38 tgid 38 ts 9396138651 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
 __kasan_populate_vmalloc+0x1a8/0x1c0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0xd10/0x1410 mm/vmalloc.c:2145
 __get_vm_area_node+0x200/0x2f0 mm/vmalloc.c:3248
 __vmalloc_node_range_noprof+0x343/0x1540 mm/vmalloc.c:4064
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4165
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct+0x2c6/0xa00 kernel/fork.c:930
 copy_process+0x7ea/0x44b0 kernel/fork.c:2143
 kernel_clone+0x2d7/0x940 kernel/fork.c:2785
 user_mode_thread+0x115/0x180 kernel/fork.c:2862
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:169
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff8880340cc580: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff8880340cc600: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff8880340cc680: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                            ^
 ffff8880340cc700: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff8880340cc780: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
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
