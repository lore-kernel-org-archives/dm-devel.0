Received: from mail-oo2-f8.google.com (mail-oo2-f8.google.com [74.125.231.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E086B47CC6F
	for <dm-devel@lists.linux.dev>; Fri, 18 Sep 2026 20:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789762667; cv=none; b=I6S/tYXYNRGOhszjLhhBCbIeVhda+865hH9/xX6qfNzbfAYTA8vgfzad+i/I9AAWiXTQnM6nF6Ygv9mvonpFBmuzM5Tqu60X54ORhfna6XDfwj7tCw0BDIzO4VdLSpEHi2j7LBAzNtGrBufXcbvBSeCzj5gSwykJeC7VeYs1uls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789762667; c=relaxed/simple;
	bh=q0DqR53jvk8/6wDSZpNrXQ1oOkJBbuD4N9THdvot1fk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SKwrGHZkDMWwoIc8mCvSiNkglPtzeiPSwksIyvhDxm2VUZhfbHfMF6wCGnSdP1B5GU2Nkl4nbB9aGG8+hIlEo7vdxQSNUl6CTPOcUIL7jskn1bvUp1heJWFNWz4WBkbd9f6dbuXoGmOHiUpOy/OoQZldhLB4+OsWB74cEanmk0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f8.google.com with SMTP id 006d021491bc7-6b1b1ca0f3aso307985eaf.0
        for <dm-devel@lists.linux.dev>; Fri, 18 Sep 2026 13:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762665; x=1790367465;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31T92JRQIq//qGkaa1ybOrg/ZWigPJrzAlxjgm/xLN8=;
        b=ftUUzOeMyZk2Mh2obq72pu2mSUGl5B0sfys5CSEklZ9rbOz61EpHwj1KLknl8MHTpI
         fKn/YPuP/pSSDvZCveXvvMkMb0Am15d2B513OwzblpxB9sc3u5jl22tbLEfj7cM4IgY8
         H+dz06ig/aGhjRiDDBDRozktcdDTt7LLla6XEcd93GzHjQyZIbg++30jkQJ47EF/GBpQ
         DZrL3UgyCeSA4X/ovMxg5JKPTAilq5jFg3/P/fk2Ox9gI+2M74vJA4535acHMvuLgj1M
         AmsBoHGRvNv5W734ZSkGGM16JjhHvOH2fIc1rbFpBg+t45BKj2Y4LwYaAj7Fj/VXICFI
         DxPw==
X-Forwarded-Encrypted: i=1; AKwUvBz0Z01GWB11NfX8PeqJ8QADbJWqp294qyLB9HnBf5M5Ng4rO8P/NoF6L6dxEceKsXPhAosz5EJ7UA==@lists.linux.dev
X-Gm-Message-State: AFuF++lD75vL541y0rY8sB0DOSEE/aFJCzJ6hNo7iUuCAYBqCED0B8aJ
	G61PNdP+wwQlCBzchrDS+ceKlM0PdeK+F+JOoNpcChxxuKoJUNIUDSvU++wL0R+H3Jj+3I4K8ZP
	8xNWkO9zpJ5bqIU6oM5WvcmQKuA8x1LhlOt6ACsSl3kSYGHkiIv/4j3/79qo=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f031:b0:6ca:3ce1:ed48 with SMTP id
 006d021491bc7-6ca9a22ad94mr3839824eaf.11.1789762664824; Fri, 18 Sep 2026
 13:17:44 -0700 (PDT)
Date: Fri, 18 Sep 2026 13:17:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aad9c68.87c06881.1db2b3.0024.GAE@google.com>
Subject: [syzbot] [dm?] KASAN: slab-out-of-bounds Read in ctl_ioctl
From: syzbot <syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5dd1818b15d9 Merge tag 'for-next-keys-v7.3-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ce47f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84649d3ff8d550cb
dashboard link: https://syzkaller.appspot.com/bug?extid=48d935cf48a4a76be346
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1124d7f9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ce47f9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5dd1818b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/efc8284ce34a/vmlinux-5dd1818b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/aeaa3f5a6989/bzImage-5dd1818b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in instrument_copy_to_user include/linux/instrumented.h:129 [inline]
BUG: KASAN: slab-out-of-bounds in _inline_copy_to_user include/linux/uaccess.h:201 [inline]
BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x93/0xd0 lib/usercopy.c:24
Read of size 312 at addr ffff8880511e2c00 by task syz.0.17/5924

CPU: 3 UID: 0 PID: 5924 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
 instrument_copy_to_user include/linux/instrumented.h:129 [inline]
 _inline_copy_to_user include/linux/uaccess.h:201 [inline]
 _copy_to_user+0x93/0xd0 lib/usercopy.c:24
 copy_to_user include/linux/uaccess.h:230 [inline]
 ctl_ioctl+0x5c2/0xcc0 drivers/md/dm-ioctl.c:2225
 dm_ctl_ioctl+0x22/0x30 drivers/md/dm-ioctl.c:2235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0a62b9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4ea84718 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0a62e25fa0 RCX: 00007f0a62b9e159
RDX: 0000200000000000 RSI: 00000000c138fd02 RDI: 0000000000000003
RBP: 00007f0a62c3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0a62e25fac R14: 00007f0a62e25fa0 R15: 00007f0a62e25fa0
 </TASK>

Allocated by task 5924:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5414 [inline]
 __kvmalloc_node_noprof+0x35b/0x9b0 mm/slub.c:7014
 copy_params drivers/md/dm-ioctl.c:2098 [inline]
 ctl_ioctl+0x944/0xcc0 drivers/md/dm-ioctl.c:2202
 dm_ctl_ioctl+0x22/0x30 drivers/md/dm-ioctl.c:2235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880511e2c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 allocated 305-byte region [ffff8880511e2c00, ffff8880511e2d31)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x511e0
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801c042c80 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801c042c80 dead000000000100 dead000000000122
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5135, tgid 5135 (udevd), ts 53647527683
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 kernfs_fop_open+0x23d/0xd50 fs/kernfs/file.c:634
 do_dentry_open+0x6ab/0x14d0 fs/open.c:996
 vfs_open+0x82/0x3f0 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x19fa/0x2440 fs/namei.c:5000
 do_file_open+0x20e/0x430 fs/namei.c:5029
 do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x12d/0x210 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 12 tgid 12 ts 52862857394 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_pages_ok+0x73b/0x1050 mm/page_alloc.c:1596
 fq_reset include/net/fq_impl.h:386 [inline]
 ieee80211_txq_teardown_flows+0x16f/0x280 net/mac80211/tx.c:1656
 ieee80211_unregister_hw+0x5d/0x360 net/mac80211/main.c:1723
 mac80211_hwsim_del_radio drivers/net/wireless/virtual/mac80211_hwsim_main.c:6256 [inline]
 hwsim_exit_net+0x891/0x1500 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7269
 ops_exit_list net/core/net_namespace.c:200 [inline]
 ops_undo_list+0x2ee/0xab0 net/core/net_namespace.c:253
 cleanup_net+0x499/0x920 net/core/net_namespace.c:706
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
 process_scheduled_works kernel/workqueue.c:3479 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff8880511e2c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880511e2c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880511e2d00: 00 00 00 00 00 00 01 fc fc fc fc fc fc fc fc fc
                                     ^
 ffff8880511e2d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880511e2e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
