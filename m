Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794602027;
	b=3Bhv2Qp0GlfdNl4VmKOkjQKFSfithgx9YeNrHsa5Egn+3la7gF0qjgtRMCYe/sH+m4Ub
	 qVjDiOJevI1nFoD8Jak8jH5k/qgqK6D4V5aDMoT6D4tm6KrrayA1WW0aJ7n+gtkaJuVwO
	 lOVHql1b4zN1jWr4e5SHPR2jkwIizWDCH9kHLI4RteN5g/ekT+UcYm8o5JJzs2rx1ABLc
	 tNCA9Riud0ilrw8LcfPVIhLVg7UNUj1bKMWRCsOhlTxEbFq61d4l7lQhMgli18Hns23j2
	 mnQpniqhemNbnO2dxMafNruJ96RtMb0c+s+8FMgBqjWk4rx8HCkgx7gjAIex0pGCsMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794602027;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=iWwIl8HauuujeGrP8eubDZBpZTq0nypgUvneOZeGjKc=;
	b=MD7iZk4+oV5+sylW5RZtFn+RHAREcZmrmYtjdvnBQScSxk8hQzDSOM9w4r4BaFPfjHw+
	 CAcMp7DxWmOQ8EwW+/PF9PU/L2DYWPdYil49NtZQaR4F2iLzSf3ylaoDoPyJNdh+x0cbS
	 Jb7qbMnVbXYxV402++VQIdmBobUiXVKNVfCqcgF6/FCyloiir3X5TFsbbeogWBj/RL8dS
	 LVtd4196kPoKrVdqCt+RO5uZpOKWXyv72Z3s2Dvr1eLtlJ5mUF6McQZlNPG8Euapr16F3
	 Mq+6RNEE90dImK1gI0Sl5PsG1yoUarRIQP9kX6ygBFqV06dI4lmzCL2FibNJwIwhf2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A771F606A8B0
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 20:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A771F606A8B0
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4db3db8687fso1994930b6e.0
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794602025; x=1795206825;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iWwIl8HauuujeGrP8eubDZBpZTq0nypgUvneOZeGjKc=;
        b=ksSNVpkEbSC40T+SNEDro3dbwbIFZP+zxLsUEXGDHAG+8LasedMYLH7eu5d/bCa9GX
         NhYxcOvSc3viFj/yWtpxfLtJcnNsQXkXNNPAgps0262Ctsf0w6dBT6qyPqg41O+zMBcz
         OOybQkA0bdOsDaNe95Po5xpJL4Nf3gvqp3EuKGhZKs9kgZHUQy806gzMg3Spf4dlcwd5
         DzlToU7izsez188Dt9nNECbi1DzY4Jabr+j1xgfWZEOmtOiqLDmgQrrsGUhnHxvI10ZL
         +0FRGtgyMnDroZA5vwBseVEsI2eLEjc9vNE7FICWIH41zvnoWPzt8GSxAolmBcniCl/w
         p5kA==
X-Forwarded-Encrypted: i=1; AL+hErH10sdOBSGL5ob+mkwpAazOBcdzcqjZjBrqh9ZUb+BLGwZI5JpAtrMhna9scmbdsXg2ykcn1NC+nQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z90SGFxX01MjPbtmewNwSXkkpHGA7UvsrfwdzDNucRTQONKqnMB
	CDF10F443uFw6T4JpPx3iMDOWS97pWzyKGyKXXPVIWIcCwA9liiyCeP/ZFGUBpwu93LaUTkODas
	abTmuaCTz44mXDD+wjXT9IeGlnqvKhRhHZ8dGfHYL1Z8OZ8tsRxfZNGvYIvY=
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6807:b0:4ea:18f:649f with SMTP id
 5614622812f47-56e5fe406d6mr3563619b6e.3.1794602025760; Fri, 13 Nov 2026
 12:33:45 -0800 (PST)
Date: Fri, 13 Nov 2026 12:33:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af77429.fe96acdb.12252b.000a.GAE@google.com>
Subject: [syzbot] Monthly dm report (Nov 2026)
From: syzbot <syzbot+listc84b10870f589e14c482@syzkaller.appspotmail.com>
To: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mpatocka@redhat.com, snitzer@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello dm maintainers/developers,

This is a 31-day syzbot report for the dm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/dm

During the period, 6 new issues were detected and 0 were fixed.
In total, 6 issues are still open and 3 have already been fixed.
There are also 5 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 646     Yes   KASAN: slab-use-after-free Read in snapshot_ctr
                  https://syzkaller.appspot.com/bug?extid=8e6fc64255334ccf3ab3
<2> 479     Yes   KASAN: null-ptr-deref Read in dm_kcopyd_client_destroy
                  https://syzkaller.appspot.com/bug?extid=a2626a25eb2595e3ec3c
<3> 26      Yes   KASAN: slab-use-after-free Read in pool_ctr
                  https://syzkaller.appspot.com/bug?extid=83827f9a59abe148bff4

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
