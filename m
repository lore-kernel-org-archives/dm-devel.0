Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793557530;
	b=1SSiV5lJ+ENYBF+930MFlduapx9Hi5XaxMNmavhJhEOqQifmB7JOngdr+X/p/3Fn9S4p
	 mxj/mfoQRaXO+0gRC8ty9+orPvBHYNd5Gh39iOlC1j9Ilw7qAg2daroZ+J6tzGkFwM2sm
	 VSEfFDLyGUT+TqMN9Dx/2up5R20LtEazZn8/+BSCitmCzbU3V7OervSFZ2mRcJu0EPO2+
	 Vf7GJJ/pZXjbhuMw/rmN+opdKejgQtMc8p1DdGFMXMkgC1p6X9gHkREAe06Bmz6HmaP8/
	 UM+8dAdwWSzLUSiQWZxKIK8/IDYuHNfbdNqCyuSW0wNf9QJfHM5n0dObPQmbYX05e5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793557530;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=YlgnKU2M9F6XavLQeW9oq1oj0gNtN8PMPAnq00uylBA=;
	b=OGrPj5j8KduBi/IZqBYW+UUvH6OPBIrPi7mvXw3kP84zdxPj90Q6oTlnFjE9nAWQSl9S
	 wqd5LBOav/4GF2FJKYpQ+ZLFLZzxpZD2I22cNDfiptQEKHpoRUmN3Ceo6BOmNflH0y7vb
	 8t4fbpGRa6ZCo3wzOc3jcA5bxwslTE6+ksnWHQ2a0JPL3b/0H5rDLzcC7ISz9nXBywzhf
	 KU2s0dg57pRE7c0/sZC6l9wCnZ8Y5+dMBNlJ0/o0Z9mnWNqV+GTGdoucLo6V4LQk8OivB
	 mkV5RVZR/s11a3SXJLLeKYuLjMnfQyfca5A81Kso5mj2qcgjDmqFMyP2QwQmLJ1yBRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5D8606A326
	for <dm-devel@lists.linux.dev>; Sun,  1 Nov 2026 18:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E5D8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab4f652f9bso1934499b6e.0
        for <dm-devel@lists.linux.dev>; Sun, 01 Nov 2026 10:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793557528; x=1794162328;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YlgnKU2M9F6XavLQeW9oq1oj0gNtN8PMPAnq00uylBA=;
        b=xorGgAqXF0EueeBAh161qGpTaSfpYtdeTrT/oLYK9TPX/SLCGz7Sq7URj88rJdC0VP
         wtZ4XE+FgrRz5CMA79BS0AWqY6L9VDOofq2FCWKIiaCeAtaj11ueZWxak64TiT+JnU9l
         8IlxUk+2rqdZIoIeFZ4I+u/h1dDk+S99Zv6bjbJhoEvxx9xWO4P//IbPUsDUhYUq7jEl
         KJyJTW+Hr73PTXSMhwN4DU+cJev3hyl/hZmu+YhYVQ8hVIZTZMAaJoQ7WZL9gqk0q8dP
         07Jm60LETh61w+hLNTN21baapkHow7qIx+1zIvGWuhmDORP3O5aYITjv/PDYoI2K1MRk
         Wqqg==
X-Forwarded-Encrypted: i=1; AKwUvBx1Tlxhq2uRNLm9iiCN4pwmZujrWo41qqF8vGZDKWjh1PLP0q/5u8TPX0wqr0/2es6/OxJq9hHDgg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJDvIrj4tpPWkRueGoH9KQ49LvhqAIcrv/sFKjin2C7Khds8B17
	nkpT7qjGf+eBqmF+DiaDDM740oil9PpuqEKWoafnkznF7jr6K05/X6ywRKuLXgyYyJ/ID1wrFeH
	5m7gKRy7pWhS/fWIfhLUQ1FXUUxJyKWApZ0pkID+UG7c7AJtET6LdXIpIJgY=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f13:b0:4e4:627a:e094 with SMTP id
 5614622812f47-5640dc2c8a7mr5312584b6e.11.1793557528715; Sun, 01 Nov 2026
 10:25:28 -0800 (PST)
Date: Sun, 01 Nov 2026 10:25:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae78418.6552420f.2a0efc.005b.GAE@google.com>
Subject: [syzbot] [dm?] BUG: unable to handle kernel NULL pointer dereference
 in dm_bufio_client_create
From: syzbot <syzbot+41e0d7cdfb1ecfc4a007@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    abf8c33470f7 Merge tag 'spi-fix-v7.4-merge-window' of git:..
git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux master
console output: https://syzkaller.appspot.com/x/log.txt?x=1578f6ea580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b38f05ed2b645c41
dashboard link: https://syzkaller.appspot.com/bug?extid=41e0d7cdfb1ecfc4a007
compiler:       arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fc4be0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134c528d580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-abf8c334.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dc6a6b2fa900/vmlinux-abf8c334.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a24896395af6/zImage-abf8c334.xz

AI-generated root cause summary:
In drivers/md/dm-thin.c, pool_ctr() attempts to ensure metadata and data devices
are distinct by checking strcmp(argv[0], argv[1]), which fails when different
path strings resolve to the same device. When the pool is created with read_only
mode, dm_get_device() opens the metadata device as read-only, and the subsequent
open of the data device as read-write invokes upgrade_mode() in
drivers/md/dm-table.c, which frees the old table device via
dm_put_table_device(). This leaves metadata_dev as a dangling pointer
(use-after-free); when metadata_dev->bdev is subsequently read as NULL from the
freed slab entry and passed to dm_bufio_client_create(), dereferencing
bdev->bd_dev causes an immediate kernel NULL pointer dereference.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=41e0d7cdfb1ecfc4a007

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+41e0d7cdfb1ecfc4a007@syzkaller.appspotmail.com

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000024 when read
[00000024] *pgd=86ce2003, *pmd=df568003
Internal error: Oops: 205 [#1] SMP ARM
Modules linked in:
CPU: 0 UID: 0 PID: 4130 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
PC is at dm_bufio_client_create+0x298/0x5fc drivers/md/dm-bufio.c:2585
LR is at __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
LR is at _raw_spin_unlock_irqrestore+0x30/0x54 kernel/locking/spinlock.c:221
pc : [<812f4044>]    lr : [<81c19680>]    psr: 60000013
sp : df9f1b30  ip : df9f1aa8  fp : df9f1bd4
r10: 00000000  r9 : df9f1b48  r8 : 837359c4
r7 : 83735984  r6 : 8633b638  r5 : 00000000  r4 : 8633b600
r3 : 00000000  r2 : 00000000  r1 : ffc00000  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 30c5387d  Table: 86a96cc0  DAC: fffffffd
Register r0 information: NULL pointer
Register r1 information: non-paged memory
Register r2 information: NULL pointer
Register r3 information: NULL pointer
Register r4 information: slab kmalloc-512 start 8633b600 pointer offset 0 size 512
Register r5 information: NULL pointer
Register r6 information: slab kmalloc-512 start 8633b600 pointer offset 56 size 512
Register r7 information: non-slab/vmalloc memory
Register r8 information: non-slab/vmalloc memory
Register r9 information: 2-page vmalloc region starting at 0xdf9f0000 allocated at kernel_clone+0xc4/0x440 kernel/fork.c:2784
Register r10 information: NULL pointer
Register r11 information: 2-page vmalloc region starting at 0xdf9f0000 allocated at kernel_clone+0xc4/0x440 kernel/fork.c:2784
Register r12 information: 2-page vmalloc region starting at 0xdf9f0000 allocated at kernel_clone+0xc4/0x440 kernel/fork.c:2784
Process syz.2.17 (pid: 4130, stack limit = 0xdf9f0000)
Stack: (0xdf9f1b30 to 0xdf9f2000)
1b20:                                     00000001 00000000 00001fff 00000006
1b40: 00000000 00000008 00000008 00000000 00000000 00000000 00000000 00000000
1b60: 00000000 625f6d64 6f696675 6675625f 2d726566 00312d38 00000000 00000000
1b80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1ba0: 00000000 5d3b91d7 80579764 863f8c80 00000000 00001000 00000006 00000000
1bc0: 00000000 00000800 df9f1c0c df9f1bd8 8130d108 812f3db8 8130d020 8130d03c
1be0: 00000000 868f1040 00000000 868f0c00 00000000 00000000 00000000 00000000
1c00: df9f1c34 df9f1c10 81329660 8130d0a4 868f1040 8276076c 826a9678 00000000
1c20: 83735a70 00000000 df9f1cb4 df9f1c38 81322274 813295d4 00000000 00000000
1c40: 835c30a0 863f87c0 8417c000 86852000 83735a60 00000003 863f894c 00000800
1c60: 863f87cc 00000000 00000014 00000000 812e5f44 00000000 00000007 00000000
1c80: 863f8858 5d3b91d7 00000000 863c7180 868f1040 00000000 00000000 00000800
1ca0: 00000000 00000000 df9f1d0c df9f1cb8 812e623c 81321df0 00000008 df9f1d2c
1cc0: 868f1040 00000000 85b2db60 85b2db50 df9f1d0c 00000006 863f8840 5d3b91d7
1ce0: 86852000 0000006f 85b2db38 85b2db60 85b2da00 00000000 85b2dba8 86852000
1d00: df9f1d64 df9f1d10 812ec884 812e60b0 00000800 00000000 85b2db60 85b2da00
1d20: 812eabcc 863c7180 00000000 863c7180 00000000 5d3b91d7 df9f1d54 812ec740
1d40: 85b2da00 200006c0 863f0e80 00000009 000001a8 000001a8 df9f1f04 df9f1d68
1d60: 812eaa04 812ec74c df9f1e74 81ee19d4 8259d20c 8088542c 81ee1718 00000077
1d80: 85b2db31 b5403587 00000000 00000000 00000001 00000000 00000004 00000032
1da0: 00000000 000001a8 00000138 00000001 00000000 00020000 00000000 00000000
1dc0: 0000f800 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1de0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1e80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1ea0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1ec0: 00000000 00000000 00000000 00000000 00000003 5d3b91d7 df9f1ef4 00000000
1ee0: 863f0e80 c138fd09 200006c0 863f0e80 00000003 84d3be80 df9f1f14 df9f1f08
1f00: 812eaf64 812ea79c df9f1fa4 df9f1f18 805f2e84 812eaf60 df9f1f4c df9f1f28
1f20: 8035d380 8036088c ffffffff 81c0c4c0 df9f1f54 df9f1f40 8025cbac 00000001
1f40: df9f1fa4 df9f1f50 8035dc54 8035d1f8 00000000 00000001 ffffffff 8341a10c
1f60: 00000000 00000000 00000000 00000000 00000000 5d3b91d7 df9f1fac 00000000
1f80: 00000000 00356310 00000036 8020029c 84d3be80 00000036 00000000 df9f1fa8
1fa0: 80200060 805f2c4c 00000000 00000000 00000003 c138fd09 200006c0 00000000
1fc0: 00000000 00000000 00356310 00000036 003562d8 00000000 00000008 00000000
1fe0: 7ecaa7a0 7ecaa790 0001903c 00130cf0 60000010 00000003 00000000 00000000
Call trace: 
[<812f3dac>] (dm_bufio_client_create) from [<8130d108>] (dm_block_manager_create+0x70/0xb0 drivers/md/persistent-data/dm-block-manager.c:397)
 r10:00000800 r9:00000000 r8:00000000 r7:00000006 r6:00001000 r5:00000000
 r4:863f8c80
[<8130d098>] (dm_block_manager_create) from [<81329660>] (__create_persistent_data_objects drivers/md/dm-thin-metadata.c:791 [inline])
[<8130d098>] (dm_block_manager_create) from [<81329660>] (dm_pool_metadata_open+0x98/0x15c drivers/md/dm-thin-metadata.c:980)
 r8:00000000 r7:00000000 r6:00000000 r5:00000000 r4:868f0c00
[<813295c8>] (dm_pool_metadata_open) from [<81322274>] (pool_create drivers/md/dm-thin.c:2946 [inline])
[<813295c8>] (dm_pool_metadata_open) from [<81322274>] (__pool_find drivers/md/dm-thin.c:3113 [inline])
[<813295c8>] (dm_pool_metadata_open) from [<81322274>] (pool_ctr+0x490/0xa64 drivers/md/dm-thin.c:3363)
 r9:00000000 r8:83735a70 r7:00000000 r6:826a9678 r5:8276076c r4:868f1040
[<81321de4>] (pool_ctr) from [<812e623c>] (dm_table_add_target+0x198/0x3bc drivers/md/dm-table.c:749)
 r10:00000000 r9:00000000 r8:00000800 r7:00000000 r6:00000000 r5:868f1040
 r4:863c7180
[<812e60a4>] (dm_table_add_target) from [<812ec884>] (populate_table drivers/md/dm-ioctl.c:1602 [inline])
[<812e60a4>] (dm_table_add_target) from [<812ec884>] (table_load+0x144/0x3d4 drivers/md/dm-ioctl.c:1645)
 r10:86852000 r9:85b2dba8 r8:00000000 r7:85b2da00 r6:85b2db60 r5:85b2db38
 r4:0000006f
[<812ec740>] (table_load) from [<812eaa04>] (ctl_ioctl+0x274/0x7c4 drivers/md/dm-ioctl.c:2221)
 r10:000001a8 r9:000001a8 r8:00000009 r7:863f0e80 r6:200006c0 r5:85b2da00
 r4:812ec740
[<812ea790>] (ctl_ioctl) from [<812eaf64>] (dm_ctl_ioctl+0x10/0x14 drivers/md/dm-ioctl.c:2243)
 r10:84d3be80 r9:00000003 r8:863f0e80 r7:200006c0 r6:c138fd09 r5:863f0e80
 r4:00000000
[<812eaf54>] (dm_ctl_ioctl) from [<805f2e84>] (vfs_ioctl fs/ioctl.c:51 [inline])
[<812eaf54>] (dm_ctl_ioctl) from [<805f2e84>] (do_vfs_ioctl fs/ioctl.c:551 [inline])
[<812eaf54>] (dm_ctl_ioctl) from [<805f2e84>] (__do_sys_ioctl fs/ioctl.c:595 [inline])
[<812eaf54>] (dm_ctl_ioctl) from [<805f2e84>] (sys_ioctl+0x244/0xb5c fs/ioctl.c:583)
[<805f2c40>] (sys_ioctl) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xdf9f1fa8 to 0xdf9f1ff0)
1fa0:                   00000000 00000000 00000003 c138fd09 200006c0 00000000
1fc0: 00000000 00000000 00356310 00000036 003562d8 00000000 00000008 00000000
1fe0: 7ecaa7a0 7ecaa790 0001903c 00130cf0
 r10:00000036 r9:84d3be80 r8:8020029c r7:00000036 r6:00356310 r5:00000000
 r4:00000000
Code: e3a05000 e3a01000 e34f1fc0 e1a00005 (e5932024) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	e3a05000 	mov	r5, #0
   4:	e3a01000 	mov	r1, #0
   8:	e34f1fc0 	movt	r1, #65472	@ 0xffc0
   c:	e1a00005 	mov	r0, r5
* 10:	e5932024 	ldr	r2, [r3, #36]	@ 0x24 <-- trapping instruction


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
