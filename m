Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009840;
	b=d6hsgFwFY+/Yw7cxq5vYvEQQxrKLeikYdXg/IhskZXGZ/Q7v4Deq+Y6rXkZyXfDwYqwh
	 LZTC+uP3Sji+aj7+Vk+HxAQv7mWSbJlqgw7MiYvouysPsk0Jh719MWSo4YO9423RHaKhl
	 eIcV+Vkaq5gQzGm3uKd/TOhO3lOgW5J1A1sWouG3woFwt6EJhZJT+gO2QGw/lFmw1bEGg
	 H8kQHgfzr1i1kOhwYA5LvHOBjeZmHi29ZBbHsUOUgkDua6F+rZSD7UpmJUFr3OALDIkRi
	 J/jIUHo/JVwSpFFDcbBGXh1RQQW492AbYQGYGGSvMpzCc3Iiwz7vG4CO6jMHvV0lpSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009840;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=oe3qxDxEEBCgkMf3LaoAvV0Pg0/IXg79f/nMkFBr+bY=;
	b=JYtBbb89DsMyy7VAjOIRCwiQOWGfhd3l+7Qq9/g+OYGJlAM8cEKZGUl+3YpyTwlwFzeY
	 Hip/DWAXA+sxl6dWI2kWu4B+26rhdI87avWHC2HBB7z/0D6sIOR8BqmgOveoqsuw/BFQp
	 LDT9BLBMjc1VbMPZ9BXi061TbRsTzHna99t+BAUnOfGbGVXKHmhYH0Dk1UsPw5SQwz4vs
	 S4d696iLiZ6JoBThpBAc8pJ2VgDnahtQJas79FRjNg6TvpHOieb8WHF7zY2InGfLH4KwK
	 B38lIdKiT9eVYywHbNl+SOL8apuM3m314VnsuNnVKdhTxASlsZBCJbYT3JqMA7YIdDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91500606A32A
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 13:50:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91500606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-574ae6cc614so2039233b6e.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 05:50:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795009839; x=1795614639;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oe3qxDxEEBCgkMf3LaoAvV0Pg0/IXg79f/nMkFBr+bY=;
        b=1reBtRi44lGXsw9yjGDGOoTuT8TwcAfQbyHUOYUQuItgPuqxFajrpH9wlO3bY7ZhiR
         MY2eZ++AUMolOOhvZseLXoXQCpFGlK5scmFctc99civogZifP2x4XSv/VakI/5vU0m9h
         lWcOcKnd4FTX6d7/xrQ2FOg82N6Q3d4OtQ8HdS/NyRPoT28PVdRRK2qA9ppBe89sUe0I
         9nYlrPgnJuvnhM9VXGjUTNV/sZiDIx34lSEavipR4l/UQ6sytjN844uaLiDsDrteXZGV
         co1/2Z2KjmnN9OGprtZXWJzcIzrxKDDhjYf7qDdMhKR58VleQgQjdiYB2/EmVpRGLsr7
         Svew==
X-Forwarded-Encrypted: i=1; AL+hErHRLax+9kKf+zTGr8ZJQMVmrZJnTyM6aKmgaTq0eoZRq0dfaNT4GEDmcDy1Ss/pr43ZXU4pHEbcSg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9dsoKYbomJL0QJWSBOuoLJec9M9lqG02LCFw8hMWAXmwWKrfmc
	ocdwNgQXSUUrx27t6qH/lqXRicTAsw1OKy/9HSb0+HiqQL26xaQPQEtK2a2U+fcrLccfm0BwdsR
	0CBPYUSQBhocnhKgeLbzRZpFW3NJ2I4lsmkf+l+Z7K7QeVW74s+AvAUzbqaI=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c1d4:b0:4dd:f8bb:e1bd with SMTP id
 5614622812f47-575dd62583amr4190167b6e.13.1795009839590; Wed, 18 Nov 2026
 05:50:39 -0800 (PST)
Date: Wed, 18 Nov 2026 05:50:39 -0800
In-Reply-To: <6aec63fe.5f5735a5.290c1c.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afdad2f.15a38f0c.5f8d.0009.GAE@google.com>
Subject: Re: [syzbot] [raid?] BUG: unable to handle kernel paging request in remove_spares
From: syzbot <syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dayou5941@163.com, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, liyouhong@kylinos.cn, magiclinan@didiglobal.com, 
	mpatocka@redhat.com, sashiko-bot@kernel.org, snitzer@kernel.org, 
	song@kernel.org, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    20eef29b7c84 Merge tag 'arc-fixes-7.4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1186ff3d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=a53c2918175b36cfd601
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f8f94d580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173f9411580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-20eef29b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bb852a1ddb76/vmlinux-20eef29b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4c636c3f4242/bzImage-20eef29b.xz

AI-generated root cause summary:
In the MD (Multiple Devices / RAID) subsystem, md_start_sync is scheduled as a
work item on the md_misc workqueue to initiate resynchronization or manage spare
devices. For read-only arrays (!md_is_rdwr(mddev)), md_start_sync executes
remove_and_add_spares(), which invokes remove_spares(). However, md_start_sync
fails to verify whether the array's personality (mddev->pers) is still valid
before calling into personality operations, and array stop/detach sequences do
not ensure that mddev->sync_work is completely halted or prevented from running
after mddev->pers is cleared. When remove_spares() executes with mddev->pers ==
NULL, it attempts to invoke mddev->pers->hot_remove_disk (located at offset
0x50), triggering a NULL pointer dereference crash.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=a53c2918175b36cfd601

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
CPU: 2 UID: 0 PID: 66 Comm: kworker/2:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: md_misc md_start_sync
RIP: 0010:remove_spares+0x147/0x540 drivers/md/md.c:10182
Code: 67 60 f9 45 84 ff 74 55 e8 e6 6c 60 f9 48 8b 44 24 10 80 38 00 0f 85 83 03 00 00 49 8b 45 08 48 8d 78 50 48 89 fa 48 c1 ea 03 <42> 80 3c 22 00 0f 85 78 03 00 00 48 89 de 4c 89 ef 48 8b 40 50 2e
RSP: 0018:ffffc90000d47a10 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff888059649108 RCX: 0000000000000000
RDX: 000000000000000a RSI: ffffffff88ae1bfa RDI: 0000000000000050
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffff8880596491cf R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888059648058 R14: ffff888059648070 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880d4669000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30924008 CR3: 0000000051ca3000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 remove_and_add_spares+0x6c7/0x7f0 drivers/md/md.c:10207
 md_start_sync+0x736/0xea0 drivers/md/md.c:10323
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:remove_spares+0x147/0x540 drivers/md/md.c:10182
Code: 67 60 f9 45 84 ff 74 55 e8 e6 6c 60 f9 48 8b 44 24 10 80 38 00 0f 85 83 03 00 00 49 8b 45 08 48 8d 78 50 48 89 fa 48 c1 ea 03 <42> 80 3c 22 00 0f 85 78 03 00 00 48 89 de 4c 89 ef 48 8b 40 50 2e
RSP: 0018:ffffc90000d47a10 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff888059649108 RCX: 0000000000000000
RDX: 000000000000000a RSI: ffffffff88ae1bfa RDI: 0000000000000050
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffff8880596491cf R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888059648058 R14: ffff888059648070 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880d4669000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30924008 CR3: 0000000051ca3000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	67 60                	addr32 (bad)
   2:	f9                   	stc
   3:	45 84 ff             	test   %r15b,%r15b
   6:	74 55                	je     0x5d
   8:	e8 e6 6c 60 f9       	call   0xf9606cf3
   d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  12:	80 38 00             	cmpb   $0x0,(%rax)
  15:	0f 85 83 03 00 00    	jne    0x39e
  1b:	49 8b 45 08          	mov    0x8(%r13),%rax
  1f:	48 8d 78 50          	lea    0x50(%rax),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	42 80 3c 22 00       	cmpb   $0x0,(%rdx,%r12,1) <-- trapping instruction
  2f:	0f 85 78 03 00 00    	jne    0x3ad
  35:	48 89 de             	mov    %rbx,%rsi
  38:	4c 89 ef             	mov    %r13,%rdi
  3b:	48 8b 40 50          	mov    0x50(%rax),%rax
  3f:	2e                   	cs
