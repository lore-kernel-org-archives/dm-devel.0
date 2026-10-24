Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792856982;
	b=ZdPazpHcBtlLDlPnyG+EP+mvCIGEgziW5jfV9NiVnoVdfmq0ohoOB9aYG1tbzEHGhtOk
	 rJ02Ttl8vGDXRP+Gg7RaZgsaWxvoyfKKYWsw+fVWciPDOXKQFNswVeICx+bzNXQSf0UgQ
	 amrE9sgnhN0JHJlfdIroF27q1A13/uKOm6TQB8mHu4cUB6Nl0QcE2kMwKc8DsNhY5dlPZ
	 M3r4AQkACAzKkCilBB4Vsr+ml2wWt7kQuK3wmVjO/K5v7hEfTmjN1DvK9NjjwdIR0kOOA
	 T2o6ljvZhaCjBReJQpoOjTsJOTJllFTazAkFtIaFBp2mNjaRjzCs8sMAokAjyB2wFTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792856982;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=wblaXljSo131LqOUdT42ykZ2Daqoeu17S/51SQCuRm8=;
	b=OlnrF6gcVkd2vtLepU1eD/M51GjYtS3PRhv4XLUKih2r1g5EZZYEmLiwZbDGTYtZbJxg
	 7A6jypAs984L7Wn93rkCq7zENn/hJc56scy1H0C5LY6epxOcI0xatK3GaKDrHXeeFsh2Y
	 nMyVzngcP4kfKcTb09nGrY5+LGvFQF5zilkWWTHrZ9ZV4RMt4AL+7qjvp2dE1zmGQF3F+
	 Bi5e4zDy89R+ErjfhR9Yu1/GLVDV9pFPnuAiDZXquoNc8qAJ9fa2AG23NdKBgUbkCaEjK
	 /PPaBDWVZsvQno89RTzKBSROycAT/TrGj0tk7T1UVNRtaclBPphgVjo3PLzCnmV1D+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43010606A31B
	for <dm-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43010606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4e937c5bd4fso1636118b6e.2
        for <dm-devel@lists.linux.dev>; Sat, 24 Oct 2026 08:49:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792856981; x=1793461781;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wblaXljSo131LqOUdT42ykZ2Daqoeu17S/51SQCuRm8=;
        b=Khv48zJCM3yB2KE35rbhwAchshX8amijPrNgDXiDPcpg2vUuDzpCKQKjt8zHy5pXZl
         CpUnBJhOgTJarDwPEOQMHmVVwFidBZY/qqbcnNndzdZ81jysJZYH6w3NQ7GgdItPtTzV
         HU5eRtw40AI43s6uDUFrGcVeLZf5TbAO5dZo760RqD4Cd6Zar8EQgN5Jsr9DCHNkoMzp
         3Sx1kQ/4aZ41LBy+pOARwdz4TQ65VZDoxvK94YJ4lrQiizEW5z0FJ4SxoY9eYdTqIvbI
         M/Wh9ZxmMTSVNyodX2ByyDOlS9iepTUelRZRkvqi6565SsNTLVvGUG8ebUFv+/MCPMFu
         OqEg==
X-Forwarded-Encrypted: i=1; AKwUvBwX21FHKfisTkVJ5mjQrMHIaVNMqO4yrn4TkmgLWiq3/7FfiTMpaTyNOpID3nvlrp1ZFFJID1A42A==@lists.linux.dev
X-Gm-Message-State: AFq9FYIsMl60qWS1XGixXXOrgdt4o8Rs7+E2aP0Ews6xdN5U3Pzz9p2z
	sxCpMz6Gn/dIoSMtCh8JBWrtVqJhhzo5ucrFyllpsOOEA7YECaTaWgCYalo05G4Z60ACiL8YFof
	9RCpwxan28yuCmOO4hMn8xnLqqjdi3yoBZfrZzH/5NPrLaCNl1n9VR6wv0Do=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3a0c:b0:4f4:b5ba:a241 with SMTP id
 5614622812f47-55c003614e5mr1705811b6e.39.1792856981116; Sat, 24 Oct 2026
 08:49:41 -0700 (PDT)
Date: Sat, 24 Oct 2026 08:49:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adcd395.998fdb85.f0000.0011.GAE@google.com>
Subject: [syzbot] [dm?] KASAN: slab-use-after-free Read in snapshot_ctr
From: syzbot <syzbot+8e6fc64255334ccf3ab3@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f47d223627f8 Merge tag 'vfs-7.4-rc1.sync_close' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127202a5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=97e47414c855a3d8
dashboard link: https://syzkaller.appspot.com/bug?extid=8e6fc64255334ccf3ab3
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a47f71580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13edba35580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f47d2236.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a94d6307dbbf/vmlinux-f47d2236.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f114012b9c35/bzImage-f47d2236.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8e6fc64255334ccf3ab3@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in snapshot_ctr+0x5cb/0x1340 drivers/md/dm-snap.c:1282
Read of size 8 at addr ffff888038e19518 by task syz.0.17/5512

CPU: 0 UID: 0 PID: 5512 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 snapshot_ctr+0x5cb/0x1340 drivers/md/dm-snap.c:1282
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
RIP: 0033:0x7f239a99f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb38c50f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f239ac25fa0 RCX: 00007f239a99f559
RDX: 0000200000001640 RSI: 00000000c138fd09 RDI: 0000000000000003
RBP: 00007f239aa36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f239ac25fac R14: 00007f239ac25fa0 R15: 00007f239ac25fa0
 </TASK>

Allocated by task 5512:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_node_noprof+0x3d1/0x620 mm/slub.c:5582
 _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
 open_table_device drivers/md/dm.c:733 [inline]
 dm_get_table_device+0x23e/0x740 drivers/md/dm.c:821
 dm_get_device+0x327/0x760 drivers/md/dm-table.c:388
 snapshot_ctr+0x2b2/0x1340 drivers/md/dm-snap.c:1267
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

Freed by task 5512:
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
 snapshot_ctr+0x471/0x1340 drivers/md/dm-snap.c:1277
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

The buggy address belongs to the object at ffff888038e19500
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 24 bytes inside of
 freed 96-byte region [ffff888038e19500, ffff888038e19560)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x38e19
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801c041280 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 195, tgid 195 (kworker/u4:7), ts 22161879156
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
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x47b/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 lsm_blob_alloc security/security.c:218 [inline]
 lsm_task_alloc security/security.c:270 [inline]
 security_task_alloc+0x4d/0x330 security/security.c:2785
 copy_process+0x1c7a/0x44b0 kernel/fork.c:2301
 kernel_clone+0x2d7/0x940 kernel/fork.c:2785
 user_mode_thread+0x115/0x180 kernel/fork.c:2862
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:169
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
page last free pid 195 tgid 195 ts 22161737366 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 ___free_pages_bulk mm/kasan/shadow.c:333 [inline]
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:385 [inline]
 __kasan_populate_vmalloc+0x12d/0x1c0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0xd1a/0x1420 mm/vmalloc.c:2145
 __get_vm_area_node+0x200/0x2f0 mm/vmalloc.c:3248
 __vmalloc_node_range_noprof+0x343/0x1540 mm/vmalloc.c:4064
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4165
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct+0x2c6/0xa00 kernel/fork.c:930
 copy_process+0x7ef/0x44b0 kernel/fork.c:2143
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
 ffff888038e19400: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
 ffff888038e19480: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
>ffff888038e19500: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                            ^
 ffff888038e19580: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888038e19600: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
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
