Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445506;
	b=CrSGjRkL4i+aWocafT1XN9C6VtmYDuQBHmCr1pzRv8TbmA3vNeyPLwWzMj9OKNHU3ywy
	 rUWeQvN4SgiNNlIbprS0CB1u9LF9RjiYQdoeBVadf+0QAVF6JqDLzdNohY5i+oebrb3NF
	 OzDnwkRJE6/NSm4FyZebn3ll5zdX65pUNxK0ufn1ex7tbOxcP7BwvYkfVRuOXOKosDVVT
	 1m3aZij35ea/IQUILwFPcRBJ1booXflEbbiyUE28Kbfy1hXPZAgx3DbXgD5FVepNWFz0N
	 qlSQnP4TFwckuLUyWXK/pBZFPdTF55QlEGYlQyVKMDE6SBiUZYbn5meCiBB2xfN6KTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445506;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=3gGSatM3MTNVUKTEsO6FRXJnlXC2DHI8VEJ4qjL3BCc=;
	b=Rsp51iQ0nYp/5wb0vJfEU/EzbZk6Q0wA/jcQAtnI2HqdmLPzqaxaRdKbx33pHMmswRGt
	 xPfsaHI/WbGoIXNZinFhAuKrw91HxNHCrISKITmdruTdjri/aRLj2VZbIuwqmBstWVJoI
	 7nsv/kgubbtuCrHYsA5RalJOfFNf5WotxFTp2HptmH4cenJenHgcoBUknEXxu8hoC1rXC
	 hJg+98Z7/Z4RayphKFhDGxE/W+IdOCQq+ikwbeXwwVJlv7J2WIQSdDxt1mNNasAWR5tjz
	 0ehVY3pqSXDhI2+mUKtDh9P/O6rRaStRDUCp5cwg1c4OIY+dqRd+OAbdFRmDncFnKJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56606606A339
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 14:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56606606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4e778acdbc6so4201594b6e.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 06:51:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445505; x=1796050305;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3gGSatM3MTNVUKTEsO6FRXJnlXC2DHI8VEJ4qjL3BCc=;
        b=ezA6TfJYi32nivAC95igMkJUGcSeiG+Ls5FoUMeY/ZxCMVDhFuDEdVZ+Y2n+Cuf6BF
         cMUYj0ZbDX7+8iHPXAh8dArAj0Pen3AygXM9iyCkpkBeeV8+EdaiW1sEoWY+7qaEE4eL
         6Bkg4Fi1IK8m8k7Lqxl3yHzzFaZS+5s7fgQ5pzcGtZwHZHGQYG9RzNRIvRPWA+MC+1TW
         weNjKDrd2N0Y9JDaj4kv59YwGOC7KB7dgjPwcpl0W0DdXvR2if2RcV21OiZ6nf+tJ99/
         jcrRYFj96j9gV3At2PPRRTIsm+8AnQCMhe77u/Ek5zYmV/jHyHAXmv/JRPhMVzYXvhkQ
         TAcg==
X-Forwarded-Encrypted: i=1; AL+hErEoZrrq5NIgtQarOPJ0UneosjLg37sVI0vEbfe6gzHb7QpV/RWPDCRaus0yaTZwXS90R6LYZ2Vevw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8rPGG6DY/ZCrrWWluIV8Ss4jdml6wAU1aBsJ9NTYhRcwcSv4Bc
	XIkoH/2yH3GuOpBre6rfBP3w45jYAqyO91lLQhjp0eo6Ej4prQUwhdtE/gvrCBTvX/EBrxGzChE
	z/UtAyvom6132N0wUZZUaQPuwFBcw2mlWq9jI04FLzqOgKRWgvTsZY0UlcXk=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f12:b0:573:52b1:baf4 with SMTP id
 5614622812f47-57a06d1900dmr12581926b6e.4.1795445505356; Mon, 23 Nov 2026
 06:51:45 -0800 (PST)
Date: Mon, 23 Nov 2026 06:51:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b045301.58b41460.7037.058a.GAE@google.com>
Subject: [syzbot] [dm?] kernel BUG in lookup
From: syzbot <syzbot+dbad68398c8646e5a382@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	ejt@redhat.com, linux-kernel@vger.kernel.org, mpatocka@redhat.com, 
	snitzer@kernel.org, snitzer@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4405c18c95d2 Merge tag 'mm-nonmm-hotfixes-stable-2026-11-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=167d394e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=dbad68398c8646e5a382
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98fce4d0b21b/non_bootable_disk-4405c18c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e57ff6d83567/vmlinux-4405c18c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e1e0c78e0187/bzImage-4405c18c.xz

The issue was bisected by AI to:

commit 9b1cc9f251affdd27f29fe46d0989ba76c33faf6
Author: Joe Thornber <ejt@redhat.com>
Date:   Fri Jan 23 10:00:07 2015 +0000

    dm cache: share cache-metadata object across inactive and active DM tables

AI reasoning:   https://syzkaller.appspot.com/ai_job?id=62801fe8-a5e6-46c1-82e8-ca23918ed904

AI-generated root cause summary:
In drivers/md/dm-cache-metadata.c, dm_cache_metadata_close() checks if the
reference count drops to zero using refcount_dec_and_test() outside table_lock
before acquiring table_lock to unlink the entry from the global table list. When
a concurrent thread invokes dm_cache_metadata_open() -> lookup_or_open() for the
same block device, it acquires table_lock while the entry remains on the list
with a refcount of 0, causing lookup() to invoke refcount_inc() on a zero
reference count and triggering a refcount saturation BUG/warning. When the
closing thread subsequently frees the object, the lookup caller is left holding
a pointer to freed memory, causing a use-after-free.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=dbad68398c8646e5a382

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dbad68398c8646e5a382@syzkaller.appspotmail.com

The cause commit was identified by AI and may be wrong.
If you agree with it, please also add:
Fixes: 9b1cc9f251af ("dm cache: share cache-metadata object across inactive and active DM tables")

refcount_t: addition on 0; use-after-free.
------------[ cut here ]------------
kernel BUG at lib/refcount.c:34!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 6177 Comm: syz.3.65 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:refcount_warn_saturate.cold+0x12/0x14 lib/refcount.c:34
Code: 89 ea be 01 00 00 00 48 c7 c7 60 f8 c3 90 e8 0b 5a 01 00 e9 13 fc 04 04 e8 01 b7 d7 00 48 c7 c7 60 4b 81 8c e8 65 9c eb ff 90 <0f> 0b e8 ed b6 d7 00 48 c7 c7 00 4c 81 8c e8 51 9c eb ff 90 0f 0b
RSP: 0018:ffffc900030377e0 EFLAGS: 00010286
RAX: 000000000000002a RBX: ffff888028614000 RCX: 0000000000000000
RDX: 000000000000002a RSI: ffffffff81ec3719 RDI: fffff52000606eed
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900030375a7 R11: 0000000000000001 R12: ffff888021894500
R13: ffff888021894500 R14: 0000000000000001 R15: dffffc0000000000
FS:  00007fe6b9bf66c0(0000) GS:ffff8880d4468000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6b9bd4ff8 CR3: 0000000060d1a000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:289 [inline]
 __refcount_inc include/linux/refcount.h:366 [inline]
 refcount_inc include/linux/refcount.h:383 [inline]
 lookup+0x105/0x120 drivers/md/dm-cache-metadata.c:809
 lookup_or_open drivers/md/dm-cache-metadata.c:825 [inline]
 dm_cache_metadata_open+0x99/0x900 drivers/md/dm-cache-metadata.c:867
 cache_create drivers/md/dm-cache-target.c:2491 [inline]
 cache_ctr+0x180e/0x3ab0 drivers/md/dm-cache-target.c:2656
 dm_table_add_target+0x58b/0xee0 drivers/md/dm-table.c:765
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x3b9/0x7b0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl+0x4d2/0xcc0 drivers/md/dm-ioctl.c:2221
 dm_ctl_ioctl+0x22/0x30 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:52 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl fs/ioctl.c:584 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x7b0 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe6bb9a9559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe6b9bf6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe6bbc26180 RCX: 00007fe6bb9a9559
RDX: 0000200000000740 RSI: 00000000c138fd09 RDI: 0000000000000004
RBP: 00007fe6bba38136 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe6bbc26218 R14: 00007fe6bbc26180 R15: 00007ffd9c449728
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:refcount_warn_saturate.cold+0x12/0x14 lib/refcount.c:34
Code: 89 ea be 01 00 00 00 48 c7 c7 60 f8 c3 90 e8 0b 5a 01 00 e9 13 fc 04 04 e8 01 b7 d7 00 48 c7 c7 60 4b 81 8c e8 65 9c eb ff 90 <0f> 0b e8 ed b6 d7 00 48 c7 c7 00 4c 81 8c e8 51 9c eb ff 90 0f 0b
RSP: 0018:ffffc900030377e0 EFLAGS: 00010286
RAX: 000000000000002a RBX: ffff888028614000 RCX: 0000000000000000
RDX: 000000000000002a RSI: ffffffff81ec3719 RDI: fffff52000606eed
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900030375a7 R11: 0000000000000001 R12: ffff888021894500
R13: ffff888021894500 R14: 0000000000000001 R15: dffffc0000000000
FS:  00007fe6b9bf66c0(0000) GS:ffff8880d4468000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6b9bd4ff8 CR3: 0000000060d1a000 CR4: 0000000000352ef0


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
