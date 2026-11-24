Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494748;
	b=U+f/QOMg53/JK2HhG6UKEN4wbqSAgB5ksNyJyxhgRmGCF4kT8C8kB5wa9a0agXjJlHRw
	 Or4q7pwIFyCfSiwsY2M2NyTbN/PTnJBvZRmn0qZlXp09wNwMm8R+ud4monc/MZcwUXArw
	 PKz8SD/YuJ7lvC40fDzaTwnQk7Hfxf/4xJs+0o/C1enr56MoqXAW6nZKHJtxESSqFzLWt
	 k33+J1ZX7mCxiklNSf/LNMdrfnjCiHiHQF3TYWqyuxkNCTB1DLWkd2thp95N7nq9wyM+l
	 tFeadn2zMz26vVqqU0wUuh7A6Y+z7eYM+1cw7Z9gfk6IDwTtuDCrdksTc+bGq9o1tRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494748;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=f4tXd6JwbEV+PY45SHAcOw2QQtqiosg/oxeaDPLz+6M=;
	b=URwLPl7hoesvfLRPOU4FySjdpPejBCwP27oNe5V65ERXjwz8leCGTMMJbVabKD105zRC
	 /nbWipi9zAwz+ZYqi2eyPEmSsps/2pxEQyLFsAnlBd9hX6MadjLPhZhJ7T3T0nwkFSo1r
	 8xrqenqTDlxNj/i7uq9wd++qW3eG0WDYZAJvraLzp5CENjdvAKW2t/bBbHJTaeU+xzs5X
	 /xpy+umtUkGC0xLTOAoHFNLSqlKbMdOgzp/nLYCbouS1sMnrwpOA8POOGK0XXZ4pJqf1K
	 MO+l1I1uL13KCulxmeA3d9IQcqGnGuYVFP3rPgYGuuCepRf01wkdx9E7ACtG3mXQfhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2140606A321
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2140606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ea2c058e67so4643858b6e.1
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795494747; x=1796099547;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f4tXd6JwbEV+PY45SHAcOw2QQtqiosg/oxeaDPLz+6M=;
        b=Yg5E2LoGf5nPDH17VkZUKM4PtQeX4U+WNmePCerxEGUiDgJpzN2Ohc/ZSrGNp+r63U
         o5smuFB1dFbsWz7FM9WoSsFIKTFk+DBuYo7F+TNk0NQJOFK/q2wZeMY1Lrtj30RSptZH
         S99EHzH1XVqw1r7S23kl3dFn6j8NNa88+Ey4GI4Fd/Bw6iTRIBhGrbxAgbJRdUuG8hZw
         W4KsqTXKuIdLTwvs27Qxi6weAnhxikZpnk00CKyTLTUY7lFgmY5UfuVJF9dlfEa2wIJR
         qgNdCNOskgGIiU7KxGOrKrZG4YRa6dZObVg6QnWOY//wuglt80XQX5oJe7YVlmIFw1d+
         8sZA==
X-Forwarded-Encrypted: i=1; AL+hErGP9IM5g+eqVMN9ZMwj02l5leEx6i3AV5RWPYL9joz/UUxGBccK6ZbIUE3dBK40j2ygpdkU+UkQqw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9pVtDtBf6KsHX+vhXdSNcveFNduiOZ1Xq6/eBt51ji3fzFVRuS
	iQ8DWdOpQ8eoD8j37ozY7Ktj0lviCwqmdHd4D2eU+hwWf9jOmOfHbBA2VsAt7NEvxbU7Q4aSRrm
	FwZXUx/QMNmBDwcYStnI9CqWBE/OjrNynQotcAbaCSR1kIZRsqGbrEw07pjA=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f13:b0:4e9:df3c:c45c with SMTP id
 5614622812f47-57a09c0f808mr13733212b6e.19.1795494746847; Mon, 23 Nov 2026
 20:32:26 -0800 (PST)
Date: Mon, 23 Nov 2026 20:32:26 -0800
In-Reply-To: <6b045301.58b41460.7037.058a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b05135a.71deaa98.2984e6.0014.GAE@google.com>
Subject: Re: [syzbot] [dm?] kernel BUG in lookup
From: syzbot <syzbot+dbad68398c8646e5a382@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	ejt@redhat.com, linux-kernel@vger.kernel.org, mpatocka@redhat.com, 
	snitzer@kernel.org, snitzer@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d7fe9885c62 Merge tag 'hid-for-linus-2026112301' of git:/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=114e6b4d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=dbad68398c8646e5a382
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154e6b4d580000

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
CPU: 1 UID: 0 PID: 6093 Comm: syz-executor381 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:refcount_warn_saturate.cold+0x12/0x14 lib/refcount.c:34
Code: 89 ea be 01 00 00 00 48 c7 c7 e0 08 c4 90 e8 0b 5a 01 00 e9 e3 43 05 04 e8 f1 c9 d7 00 48 c7 c7 00 53 81 8c e8 35 98 eb ff 90 <0f> 0b e8 dd c9 d7 00 48 c7 c7 a0 53 81 8c e8 21 98 eb ff 90 0f 0b
RSP: 0018:ffffc900039a77e0 EFLAGS: 00010286
RAX: 000000000000002a RBX: ffff88801ef92000 RCX: 0000000000000000
RDX: 000000000000002a RSI: ffffffff81ec4dd9 RDI: fffff52000734eed
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900039a75a7 R11: 0000000000000001 R12: ffff888021af6780
R13: ffff888021af6780 R14: 0000000000000000 R15: ffff88802dbe1000
FS:  00007f79d04be6c0(0000) GS:ffff8880d4561000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f79d0cbeff8 CR3: 000000002ed19000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:289 [inline]
 __refcount_inc include/linux/refcount.h:366 [inline]
 refcount_inc include/linux/refcount.h:383 [inline]
 lookup+0x105/0x120 drivers/md/dm-cache-metadata.c:809
 lookup_or_open drivers/md/dm-cache-metadata.c:835 [inline]
 dm_cache_metadata_open+0x5a9/0x900 drivers/md/dm-cache-metadata.c:867
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
RIP: 0033:0x7f79d14f7fcb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007f79d04bdae0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f79d14f7fcb
RDX: 00007f79d04bdb40 RSI: 00000000c138fd09 RDI: 000000000000000d
RBP: 000000000000000d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f79d04bdfa0
R13: 00007f79d04bdca0 R14: 0001000000000000 R15: 00007f79d04be0a0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:refcount_warn_saturate.cold+0x12/0x14 lib/refcount.c:34
Code: 89 ea be 01 00 00 00 48 c7 c7 e0 08 c4 90 e8 0b 5a 01 00 e9 e3 43 05 04 e8 f1 c9 d7 00 48 c7 c7 00 53 81 8c e8 35 98 eb ff 90 <0f> 0b e8 dd c9 d7 00 48 c7 c7 a0 53 81 8c e8 21 98 eb ff 90 0f 0b
RSP: 0018:ffffc900039a77e0 EFLAGS: 00010286
RAX: 000000000000002a RBX: ffff88801ef92000 RCX: 0000000000000000
RDX: 000000000000002a RSI: ffffffff81ec4dd9 RDI: fffff52000734eed
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900039a75a7 R11: 0000000000000001 R12: ffff888021af6780
R13: ffff888021af6780 R14: 0000000000000000 R15: ffff88802dbe1000
FS:  00007f79d04be6c0(0000) GS:ffff8880d4461000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f79d04bdff8 CR3: 000000002ed19000 CR4: 0000000000352ef0
