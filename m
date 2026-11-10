Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332205;
	b=vaOPo7dXTUvuBOs9uSWt9ih2xNDOv1Nl43HbdMrVAYwf1I6m2Q45UzC1wvbdxBB+Yafw
	 +J83PQHbNOZjv2Cv2hle/VLeK+bPG0Qady+QZtgJxt84lCkrCHUkg7MH1ESrZ/QH0Poaa
	 k01lhMXHPcar8tcVbbj9Z7VTjXLoRXnDQik41sKYQpYCXY2B62zdoIg5ko/IdJbfCNPie
	 1M8qfRK5NrXvBVWUT1NRDLOKdU5Fg/rXs3BuEIHp/wd9EloMJLLcPcLSlOcghsvZzcqbH
	 oc6CGIvHt+SBr5nkXXwsnqCwAxaZ3Uafq6KQzcmOAryaKMeCXQ+v7HIfXsvR0RCb7eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332205;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=o15bVl2NPmsMHAkRA8VnBe/GHoz1nq9rW0/fvlACR98=;
	b=Ob/BIGfpFG7QIRIR8S/PuEdqJwHub/H0LPW1t2iLn/KU/s2msbk23q2EeceNwP0250d+
	 SehH3u5rg4U3A0LhI/E583DL6pXQmPsATyVrLzdjJYkwdczAFR9KNsv3U52rr7FamaDq3
	 47C9dUTmnGFLw1e2fh0qdvJok9ObVUhlPPJWYQpgrbyra66ClkrF/WiLVviYJyHZgrh4N
	 DZnhhZunMk6R+0PUXoyh13DV4MA1ulP0CXa+bWGkHq3cnXodX+qkqkKVByFnKF+W3XA3S
	 cxJ1Qs3YFqyBEHK8qB03WkyDTSlDE0Zd1BapHHHoqkz82syEu9P73byfTfcH/8is4ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490D606A331
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 17:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B490D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab260600easo3322206b6e.1
        for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 09:36:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794332204; x=1794937004;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o15bVl2NPmsMHAkRA8VnBe/GHoz1nq9rW0/fvlACR98=;
        b=qAvZ6f4GjyDyXc1vZOR7tQmozDhDHUz0zRp3LgP2/VbToi8czyxy2ZeOVJgFkJloeP
         uCKbQpsdk4H90MASamSGSwi5/BvsutsJ2kBgIT9br9aY9I2Cmjamkr2IBFCixg8IzFwD
         Oc/9swX4EtCVUWuCZlsMPSxmqcSlhWbIIRxSjruBRbzSW9DVhETW6HCUw6khCxcbYMYH
         qQPVDV2/7c9BjQfs6IES+HPjfFVBvXroQRMNWgpk/MM+/R78PGwOTPBeYSGHkjPGc5g2
         NoIenmDZc45Va810wkIOZ3nGlr8gHtH+0CM12dn9lsfm/+y19nb1IX+mugZd2SEMd0bC
         6clw==
X-Forwarded-Encrypted: i=1; AL+hErEE1KCEcGvc3vUKe+1+zCaqAvanbWVNz4/usTGyBhU3iFsks8oyfK4aWuCklkgEuP/ZufGQOlBHpQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+ua6/AncfniqNi/SVIiLsdrKmh0T6B1yoALdM8zkwuJBMfoZ5m
	YaYAwj/001KuXBNKEQ0NJKxE5JFCR982HLexiKAb9RRysdHC3ICzCBldoPbrvjPfTbop45gv1B+
	/a8RiaHA6k9Gkmu4UC4D7RYvakkV2IF1+47u7vOO8Yxz/uFAJJpGtMSXyIL8=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c1cc:b0:4ea:935e:43d6 with SMTP id
 5614622812f47-568813afb63mr1698457b6e.45.1794332203769; Tue, 10 Nov 2026
 09:36:43 -0800 (PST)
Date: Tue, 10 Nov 2026 09:36:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af3562b.17ff5aea.1b027f.0196.GAE@google.com>
Subject: [syzbot] [dm?] WARNING in integrity_commit
From: syzbot <syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7475ea8b5861 Linux 7.4-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135bf8ad580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=94dac3c75477e184f0b0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-7475ea8b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/db4e8a9a4461/vmlinux-7475ea8b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2abcfcabee20/bzImage-7475ea8b.xz

AI-generated root cause summary:
In drivers/md/dm-integrity.c, journal accounting variables (including
ic->free_sectors, ic->free_section, and section counts) are initialized
exclusively within replay_journal() rather than during target allocation in
dm_integrity_ctr(). When a dm-integrity target configured in journal mode ('J')
is resumed, dm_integrity_resume() checks whether the on-disk superblock was
modified while suspended; if superblock_changed() evaluates to true, it logs an
error and jumps to skip_writes, completely bypassing replay_journal(). When the
device is subsequently suspended or receives a flush bio, integrity_commit() is
scheduled and calls pad_uncommitted(), which validates that total journal
sections match the sum of uncommitted, committed, and free sectors; because
replay_journal() was skipped, these counters remain zero, causing the invariant
check to fail and trigger the WARN_ON.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=94dac3c75477e184f0b0

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com

------------[ cut here ]------------
ic->journal_sections * ic->journal_section_entries != (ic->n_uncommitted_sections + ic->n_committed_sections) * ic->journal_section_entries + ic->free_sectors
WARNING: drivers/md/dm-integrity.c:2885 at pad_uncommitted drivers/md/dm-integrity.c:2885 [inline], CPU#2: kworker/2:1/64
WARNING: drivers/md/dm-integrity.c:2885 at integrity_commit.cold+0x6/0x75 drivers/md/dm-integrity.c:2917, CPU#2: kworker/2:1/64
Modules linked in:
CPU: 2 UID: 0 PID: 64 Comm: kworker/2:1 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: dm-integrity-commit integrity_commit
RIP: 0010:pad_uncommitted drivers/md/dm-integrity.c:2885 [inline]
RIP: 0010:integrity_commit.cold+0x6/0x75 drivers/md/dm-integrity.c:2917
Code: ff e9 4d b2 63 07 48 8b 7c 24 58 e8 a1 b3 23 01 e9 e7 fe ff ff 48 8b 7c 24 40 e8 92 b3 23 01 e9 21 ff ff ff e8 78 48 a9 00 90 <0f> 0b 90 41 54 8b 8c 24 d0 00 00 00 89 da 44 89 f6 41 89 d9 45 89
RSP: 0018:ffffc90000d27a68 EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000050 RCX: 0000000000000001
RDX: ffff8880212bcb00 RSI: ffffffff81653888 RDI: 0000000000000004
RBP: 0000000000000050 R08: 0000000000000050 R09: 0000000000000000
R10: 0000000000000003 R11: 000000000000776b R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 1ffff920001a4f6a
FS:  0000000000000000(0000) GS:ffff8880d4671000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd7a3d25ff8 CR3: 000000005b7c4000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
