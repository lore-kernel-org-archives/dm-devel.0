Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02841D63DA
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693360; cv=none; b=DewSnIcUsIwCw5cAfZ6JtdTCuwcJQ3Xs5e+6dlEZaPwKGa8icuSq01s8E3xvhudStE0W62OraZiHb1Vo5Ske3A2pn6XpGiQhwf9d4dx1NgbcHEOZ1vzDxVJz4e5Zd6JhTUaq7knOJrUUXKwO+2Jpqaw95/FQDsAnYyvcZsCY9pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693360; c=relaxed/simple;
	bh=c3U4vj1tROLjdAuqAJZu2zj7KvchIp+cFt3x1V4k2ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OFvv5efIS4gfoI/zdIdahm7XbQRB9vjNCG3XLYyMu3A0YCYFB22npOWAdISBKCQsimz1RJeoytkC3hHVY6V/1KLtypI1qJYPfFuYyHq0tsVy0WLtKwMlTAMrHAA91Vv76fSocnUSE9rgbpmgobv2k4EuV5R2m9UOoX2h2HzrSo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnid0Tz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnid0Tz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD321C4AF09
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731693359;
	bh=c3U4vj1tROLjdAuqAJZu2zj7KvchIp+cFt3x1V4k2ao=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hnid0Tz4VjJqP6vBaw57fFeoLy18e5WwwDrI6xpkqtgxZHQXYtsivtlilEMqCLkP3
	 HiCUxoNWmOfIf6xRAhP3c1oCPA0/rzbesUoJu3BRms5qdDhMKTClJdnbHzUGch2beR
	 mAzyvYI8UmpmBr7Kv+hzwN5aN7TqsotIuFYNO0JlXr+KG62EFp44eAcgl+LYrnhmJY
	 fZMvSpqPBIMJmRYAFPq5vR5lCaOkMhvW9dTdhYZM8spkWyuiZ58W5j9G6fZr84kq4a
	 l5ZJrS2xGD8xzAmT4u5nKg7cwX/K6LQMlowb2Ti7YaMb+4DYMCLoxnyJW4SPxaJIOr
	 v75U1nrR3wn8g==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a4c303206eso7439345ab.3
        for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 09:55:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWupZr0rz3qnqw55QcMeFLrYTpYEpbiFXQkcXmf70Od1Vyh7k07NqbUgZCxu37+lW+MTETmNHIe0g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx05oy3UctcO9surxGPElaoPCZcZKdrwnwFPuJ1KDosxg2KBaS8
	fP0u8WMdwabe9S1UpD6ZeH9NkThOiVAA1ITEqboCH5eXs+YRaptMm9SckORe22FbFyDzvF/BrSj
	Pz/8LEgmVZnh1/lUdEjfbT/7lvXg=
X-Google-Smtp-Source: AGHT+IHGJmdnpKxhumbzS9QtvOcZ0iqM1DxeHPyIqCnLp5yzlaq0b6dxEWz3J8U2e4EBkL+PdFRHWNoA1ZSl3OGCV2g=
X-Received: by 2002:a05:6e02:3202:b0:3a7:20d5:8157 with SMTP id
 e9e14a558f8ab-3a7480435bbmr34011075ab.11.1731693359044; Fri, 15 Nov 2024
 09:55:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
In-Reply-To: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
From: Song Liu <song@kernel.org>
Date: Fri, 15 Nov 2024 09:55:47 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4kNYbcXERCQFqO-r8Q_rCLxrkQPt777cB_8TwyBfy8FA@mail.gmail.com>
Message-ID: <CAPhsuW4kNYbcXERCQFqO-r8Q_rCLxrkQPt777cB_8TwyBfy8FA@mail.gmail.com>
Subject: Re: md-raid 6.11.8 page fault oops
To: Genes Lists <lists@sapience.com>, dm-devel@lists.linux.dev, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux@leemhuis.info
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+ dm folks

It appears the crash happens in dm.c:clone_endio. Commit
aaa53168cbcc486ca1927faac00bd99e81d4ff04 made some
changes to clone_endio, but I haven't looked into it.

Thanks,
Song

On Fri, Nov 15, 2024 at 4:12=E2=80=AFAM Genes Lists <lists@sapience.com> wr=
ote:
>
> md-raid crashed with kernel NULL pointer deref on stable 6.11.8.
>
> Happened with raid6 while rsync was writing (data was pulled over
> network).
>
> This rsync happens twice every day without a problem. This was the
> second run after booting 6.11.8, so will see if/when it happens again -
> and if frequent enough to make a bisect possible.
>
> Nonetheless, reporting now in case it's helpful.
>
> Full dmesg attached but the interesting part is:
>
> [33827.216164] BUG: kernel NULL pointer dereference, address:
> 0000000000000050
> [33827.216183] #PF: supervisor read access in kernel mode
> [33827.216193] #PF: error_code(0x0000) - not-present page
> [33827.216203] PGD 0 P4D 0
> [33827.216211] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
> [33827.216221] CPU: 4 UID: 0 PID: 793 Comm: md127_raid6 Not tainted
> 6.11.8-stable-1 #21 1400000003000000474e5500ae13c727d476f9ab
> [33827.216240] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./Z370 Extreme4, BIOS P4.20 10/31/2019
> [33827.216254] RIP: 0010:clone_endio+0x43/0x1f0 [dm_mod]
> [33827.216279] Code: 4c 8b 77 e8 65 48 8b 1c 25 28 00 00 00 48 89 5c 24
> 08 48 89 fb 88 44 24 07 4d 85 f6 0f 84 11 01 00 00 49 8b 56 08 4c 8b 6b
> e0 <48> 8b 6a 50 4d 8b 65 38 3c 05 0f 84 0b 01 00 00 66 90 48 85 ed 74
> [33827.216304] RSP: 0018:ffffb9610101bb40 EFLAGS: 00010282
> [33827.216315] RAX: 0000000000000000 RBX: ffff9b15b8c5c598 RCX:
> 000000000015000c
> [33827.216326] RDX: 0000000000000000 RSI: ffffec17e1944200 RDI:
> ffff9b15b8c5c598
> [33827.216338] RBP: 0000000000000000 R08: ffff9b1825108c00 R09:
> 000000000015000c
> [33827.216349] R10: 000000000015000c R11: 00000000ffffffff R12:
> ffff9b10da026000
> [33827.216360] R13: ffff9b15b8c5c520 R14: ffff9b10ca024440 R15:
> ffff9b1474cb33c0
> [33827.216372] FS:  0000000000000000(0000) GS:ffff9b185ee00000(0000)
> knlGS:0000000000000000
> [33827.216385] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [33827.216394] CR2: 0000000000000050 CR3: 00000001f4e22005 CR4:
> 00000000003706f0
> [33827.216406] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [33827.216417] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [33827.216429] Call Trace:
> [33827.216435]  <TASK>
> [33827.216442]  ? __die_body.cold+0x19/0x27
> [33827.216453]  ? page_fault_oops+0x15a/0x2d0
> [33827.216465]  ? exc_page_fault+0x7e/0x180
> [33827.216475]  ? asm_exc_page_fault+0x26/0x30
> [33827.216486]  ? clone_endio+0x43/0x1f0 [dm_mod
> 1400000003000000474e5500e90ca42f094c5280]
> [33827.216510]  clone_endio+0x120/0x1f0 [dm_mod
> 1400000003000000474e5500e90ca42f094c5280]
> [33827.216533]  md_end_clone_io+0x42/0xa0 [md_mod
> 1400000003000000474e55004ac7ec7b1ac1c22c]
> [33827.216559]  handle_stripe_clean_event+0x1e6/0x430 [raid456
> 1400000003000000474e550080acde909728c7a9]
> [33827.216583]  handle_stripe+0x9a3/0x1c00 [raid456
> 1400000003000000474e550080acde909728c7a9]
> [33827.216606]  handle_active_stripes.isra.0+0x381/0x5b0 [raid456
> 1400000003000000474e550080acde909728c7a9]
> [33827.216625]  ? psi_task_switch+0xb7/0x200
> [33827.216637]  raid5d+0x450/0x670 [raid456
> 1400000003000000474e550080acde909728c7a9]
> [33827.216655]  ? lock_timer_base+0x76/0xa0
> [33827.216666]  md_thread+0xa2/0x190 [md_mod
> 1400000003000000474e55004ac7ec7b1ac1c22c]
> [33827.216689]  ? __pfx_autoremove_wake_function+0x10/0x10
> [33827.216701]  ? __pfx_md_thread+0x10/0x10 [md_mod
> 1400000003000000474e55004ac7ec7b1ac1c22c]
> [33827.216723]  kthread+0xcf/0x100
> [33827.216731]  ? __pfx_kthread+0x10/0x10
> [33827.216740]  ret_from_fork+0x31/0x50
> [33827.216749]  ? __pfx_kthread+0x10/0x10
> [33827.216757]  ret_from_fork_asm+0x1a/0x30
> [33827.216769]  </TASK>
>
> --
> Gene
>
