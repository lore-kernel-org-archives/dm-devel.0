Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793877818;
	b=ql3oP/XxpHsDtf5tWQmL3PtJF7NmfN1q66vNEMiLYUOuvWNIIky+3Fi7qarCZSpfaC4b
	 fvy8oCm5Y5hjj74UirY1WbKj7flWpT2UMzKmq9SGTN/epAuZIHSWrd3v3QbujDClaDL7T
	 BKu4a+bcmxR/XBhxNlH8fbM8x5c/Xjo9cXxac17TMeufYCk7UGtuVqQFMwFkqcRfni6KX
	 veJXVH78YkJXAUyCAybzlhyH/C70w1cHASJ0A4hrNvKMT0FBwtVk/o2t+Hnt3TdJGXYYk
	 Fb90l2TIuRksCQxxza49yP75UecjYH2Tw/3JWrrqxEegCnHBtNXcdpIBfmWNO+px+vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877818;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=jxlrlKy3TTaeE3w21PhEoPtsNeB27hAJRV3bZ6cez/Q=;
	b=2fP1yNhW1+SI5LcLM7D84a8nIILOxs3GbXjH0IqlCNFJFmUUNlzmCghw48QCIAUH4Y1Q
	 io4ycVbwMD9Z/yL4PUqau9UVGJCIgjPiACdKKd9wTFNubbVbOmBgYJGeiBim0MBDgBx/Q
	 hJi8xeUGePdDQZw0E3jeVIGpKT1J28X06+5pC+q6k0yS+O+7Bl1eNlJOBY5gOR2JQ2pUy
	 wHb5zt8xgmEYhio2/mQqMBU4MkRjttYvZU4xg/NAbtCD/c8lWu330/SViPIhjHVb3C/NO
	 WfSWm3/WrxBc4fbRt9A6YDdTD1OT1HlFL+PbjPCSgpqumzwt84EsmW080FUObFEDIzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103E1606A31B
	for <dm-devel@lists.linux.dev>; Thu,  5 Nov 2026 11:23:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 103E1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4dc57e2a3f2so2644018b6e.0
        for <dm-devel@lists.linux.dev>; Thu, 05 Nov 2026 03:23:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793877817; x=1794482617;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jxlrlKy3TTaeE3w21PhEoPtsNeB27hAJRV3bZ6cez/Q=;
        b=CXzAR3vGOyus9XbAjxvd4ZbRJXH8TseCQtywpGfOCi6XKBtFlJpHrhwH8TD8d64WSm
         S706M6Hx8/Hz2lBQW/7D5CIh4mlxIYMjNdHfVIMrBDI1itPHDDi4mAkqmr6VpoEHBbuF
         NGzy4tg9qC1c+bN7SQ77YIniKYY/7+yeVkxrIq/xwgS27U9g5tz83N9Zc5k95QyP7AWU
         LQTQcQiZPaF03wev7uzUZuc5QvcFbxgNsvKza8d9UdY8Rzjtv0yI7ExzYslwnRMY1uSr
         iWSQbgpRCgFIZHyJPIuf6qLcPdv9AbW7l20mL+hH393Z2Fc0PiI3XHJJGVJ+yXG/Ziib
         85Hg==
X-Forwarded-Encrypted: i=1; AKwUvBzMMNcdMfwa+JRZskZyHZE2W0WXelYwINOmwKOAAMHNnu5gEHhbEKooZ5nxIKwegkRieUkmH1ks9w==@lists.linux.dev
X-Gm-Message-State: APuU4Z/rxdjk8lH/yLYrQ7T7hRhb3a08cel2diTULppSTlb2fNIq2n1d
	m5/nLvwSmZs3YCNTlrQCyJh49Tl+fqIn3dD+beRQJFcKJ2zbDuzsU/JR+G+y8kFp/VVpj6QP2CJ
	qV6BsA9+gpyNT48WrX9CASp3w0ms8v/7eWcyZ6rduWglMBD1olc1mAybIH6A=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:15a7:b0:4f4:4eef:52cc with SMTP id
 5614622812f47-5640de2513bmr13058770b6e.43.1793877816962; Thu, 05 Nov 2026
 03:23:36 -0800 (PST)
Date: Thu, 05 Nov 2026 03:23:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aec6738.059f5055.2712e4.0005.GAE@google.com>
Subject: [syzbot] [dm?] WARNING in raid_resume
From: syzbot <syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8b7179210b22 Add linux-next specific files for 20261104
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=149d5969580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5dad87d6a9d5ee90
dashboard link: https://syzkaller.appspot.com/bug?extid=8b22a0459202f76b4096
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/24dabb992a55/disk-8b717921.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/efb6c59219d5/vmlinux-8b717921.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ced4d906c236/bzImage-8b717921.xz

AI-generated root cause summary:
In dm-raid, the target expects the underlying MD sync thread recovery state to
remain frozen (MD_RECOVERY_FROZEN) from creation (raid_ctr()) or postsuspend
(raid_postsuspend()) until resume (raid_resume()). When reshaping a RAID10 array
with a dirty region bitmap, raid_preresume() executes rs_start_reshape(), which
calls raid10_start_reshape(). If an error occurs (such as bitmap resize
failure), raid10_start_reshape() branches to its abort label, which
unconditionally executes `mddev->recovery = 0;`, wiping out MD_RECOVERY_FROZEN.
Because raid_preresume() swallows the reshape failure to continue without
change, the subsequent call to raid_resume() encounters RT_FLAG_RS_SUSPENDED
with MD_RECOVERY_FROZEN missing, triggering the assertion
WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)).

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=8b22a0459202f76b4096

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com

device-mapper: table: 248:14: thin-pool: Error opening metadata block device (-ENOENT)
device-mapper: ioctl: error adding target to table
mdX: bitmap file is out of date, doing full recovery
------------[ cut here ]------------
!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)
WARNING: drivers/md/dm-raid.c:4139 at raid_resume+0x11fe/0x1290 drivers/md/dm-raid.c:4139, CPU#0: syz.5.1272/11312
Modules linked in:
CPU: 0 UID: 0 PID: 11312 Comm: syz.5.1272 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
RIP: 0010:raid_resume+0x11fe/0x1290 drivers/md/dm-raid.c:4139
Code: c6 05 0f 85 fc 08 01 48 c7 c7 40 78 3d 8d be 2d 10 00 00 48 c7 c2 e0 b8 3d 8d e8 2d ec d6 f8 e9 b5 fe ff ff e8 13 95 fb f8 90 <0f> 0b 90 e9 63 fe ff ff e8 05 95 fb f8 90 0f 0b 90 e9 c5 fe ff ff
RSP: 0018:ffffc900039e78c0 EFLAGS: 00010283
RAX: ffffffff88cdbd5d RBX: 0000000000000000 RCX: 0000000000080000
RDX: ffffc90010680000 RSI: 0000000000001342 RDI: 0000000000001343
RBP: ffffc900039e7a40 R08: ffff888078c6c2bf R09: 1ffff1100f18d857
R10: dffffc0000000000 R11: ffffed100f18d858 R12: 1ffff9200073cf28
R13: ffff888078c6c058 R14: dffffc0000000000 R15: ffff888078c6c000
FS:  00007fbfa88c06c0(0000) GS:ffff888123161000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005561081d2138 CR3: 000000007ce32000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000001800
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dm_table_resume_targets+0x299/0x3f0 drivers/md/dm-table.c:2204
 __dm_resume+0x22/0x1d0 drivers/md/dm.c:3117
 dm_resume+0x21a/0x2e0 drivers/md/dm.c:3163
 do_resume drivers/md/dm-ioctl.c:1332 [inline]
 dev_suspend+0x6ff/0xaa0 drivers/md/dm-ioctl.c:1368
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x00007fbfa799fb19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfa88c0028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbfa7c25fa0 RCX: 00007fbfa799fb19
RDX: 0000200000000480 RSI: 00000000c138fd06 RDI: 0000000000000003
RBP: 00007fbfa7a37b70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbfa7c26038 R14: 00007fbfa7c25fa0 R15: 00007fffea1356a8
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
