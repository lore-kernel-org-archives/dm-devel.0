Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE2E19A298
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731926093; cv=none; b=MUpIzCLqaHV3HfZXRz8IWJTLMZs89tQZS68mLlxwMUFA2qt4H5vWSje67D3XGWBl26nCYG9NTiQqfkt5trUm+MRbqQWdiG2FlW0zoczSlPFmzcyVwc2MtQ03JaRXGo55hmb6MhR2MTVz3DwLMjF7aTfpEKD3VqdyXsyrSmFuAYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731926093; c=relaxed/simple;
	bh=cBp3yUUy9DNvN+REf7TehRRGcJO5OMgYBSuviMX0yFI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=O+rE9dtxkwDUQpl+8+bSHSEr5Gij7sdORkDZphXwYky1DHkXb1E8wglXAgiNflHwXewNBMJh9No68YmJPmIKZsiP1UMiBQW28jH3rZrJ44X9bug3RG0aMuVwVfqbu2AZ5shFxF+Pzs9q9raenC8BszfNxwbEKZRQiMf9epKfaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PUabLKLn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUabLKLn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731926090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sNvRxkqFSfDxfYHJKq8h50cJqbDnWLxMw7iTzA83QMs=;
	b=PUabLKLnJbgSZJG7feYozJSozAxq2qpDq1SUCMlSoY2w6zuxD4k2jC1AXMBVP+nDPs94w+
	y9XXprV9vQfiDDO4UHXwmahQUV9Iej6VhAJV2qHvcHu1Zwhn/IkBcuT6O6R3McDXX/21hy
	E5QDcIsTfr0ZAUU3vzRStzFj3Rus6wY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-_gdjaThYN42YF2wip7O8lA-1; Mon,
 18 Nov 2024 05:34:45 -0500
X-MC-Unique: _gdjaThYN42YF2wip7O8lA-1
X-Mimecast-MFC-AGG-ID: _gdjaThYN42YF2wip7O8lA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 692931955F41;
	Mon, 18 Nov 2024 10:34:43 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6748A1955F49;
	Mon, 18 Nov 2024 10:34:40 +0000 (UTC)
Date: Mon, 18 Nov 2024 11:34:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Song Liu <song@kernel.org>
cc: Genes Lists <lists@sapience.com>, dm-devel@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    yukuai3@huawei.com, linux-raid@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux@leemhuis.info
Subject: Re: md-raid 6.11.8 page fault oops
In-Reply-To: <CAPhsuW4kNYbcXERCQFqO-r8Q_rCLxrkQPt777cB_8TwyBfy8FA@mail.gmail.com>
Message-ID: <3441514c-c18e-4711-35be-1e8eda119677@redhat.com>
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com> <CAPhsuW4kNYbcXERCQFqO-r8Q_rCLxrkQPt777cB_8TwyBfy8FA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-373633788-1731926083=:1407836"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-373633788-1731926083=:1407836
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Fri, 15 Nov 2024, Song Liu wrote:

> + dm folks
> 
> It appears the crash happens in dm.c:clone_endio. Commit
> aaa53168cbcc486ca1927faac00bd99e81d4ff04 made some
> changes to clone_endio, but I haven't looked into it.
> 
> Thanks,
> Song

Hi

That commit just adds a test for tio->ti being NULL, so I doubt that it 
caused this error.

Mikulas


> On Fri, Nov 15, 2024 at 4:12 AM Genes Lists <lists@sapience.com> wrote:
> >
> > md-raid crashed with kernel NULL pointer deref on stable 6.11.8.
> >
> > Happened with raid6 while rsync was writing (data was pulled over
> > network).
> >
> > This rsync happens twice every day without a problem. This was the
> > second run after booting 6.11.8, so will see if/when it happens again -
> > and if frequent enough to make a bisect possible.
> >
> > Nonetheless, reporting now in case it's helpful.
> >
> > Full dmesg attached but the interesting part is:
> >
> > [33827.216164] BUG: kernel NULL pointer dereference, address:
> > 0000000000000050
> > [33827.216183] #PF: supervisor read access in kernel mode
> > [33827.216193] #PF: error_code(0x0000) - not-present page
> > [33827.216203] PGD 0 P4D 0
> > [33827.216211] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
> > [33827.216221] CPU: 4 UID: 0 PID: 793 Comm: md127_raid6 Not tainted
> > 6.11.8-stable-1 #21 1400000003000000474e5500ae13c727d476f9ab
> > [33827.216240] Hardware name: To Be Filled By O.E.M. To Be Filled By
> > O.E.M./Z370 Extreme4, BIOS P4.20 10/31/2019
> > [33827.216254] RIP: 0010:clone_endio+0x43/0x1f0 [dm_mod]
> > [33827.216279] Code: 4c 8b 77 e8 65 48 8b 1c 25 28 00 00 00 48 89 5c 24
> > 08 48 89 fb 88 44 24 07 4d 85 f6 0f 84 11 01 00 00 49 8b 56 08 4c 8b 6b
> > e0 <48> 8b 6a 50 4d 8b 65 38 3c 05 0f 84 0b 01 00 00 66 90 48 85 ed 74
> > [33827.216304] RSP: 0018:ffffb9610101bb40 EFLAGS: 00010282
> > [33827.216315] RAX: 0000000000000000 RBX: ffff9b15b8c5c598 RCX:
> > 000000000015000c
> > [33827.216326] RDX: 0000000000000000 RSI: ffffec17e1944200 RDI:
> > ffff9b15b8c5c598
> > [33827.216338] RBP: 0000000000000000 R08: ffff9b1825108c00 R09:
> > 000000000015000c
> > [33827.216349] R10: 000000000015000c R11: 00000000ffffffff R12:
> > ffff9b10da026000
> > [33827.216360] R13: ffff9b15b8c5c520 R14: ffff9b10ca024440 R15:
> > ffff9b1474cb33c0
> > [33827.216372] FS:  0000000000000000(0000) GS:ffff9b185ee00000(0000)
> > knlGS:0000000000000000
> > [33827.216385] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [33827.216394] CR2: 0000000000000050 CR3: 00000001f4e22005 CR4:
> > 00000000003706f0
> > [33827.216406] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> > [33827.216417] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> > [33827.216429] Call Trace:
> > [33827.216435]  <TASK>
> > [33827.216442]  ? __die_body.cold+0x19/0x27
> > [33827.216453]  ? page_fault_oops+0x15a/0x2d0
> > [33827.216465]  ? exc_page_fault+0x7e/0x180
> > [33827.216475]  ? asm_exc_page_fault+0x26/0x30
> > [33827.216486]  ? clone_endio+0x43/0x1f0 [dm_mod
> > 1400000003000000474e5500e90ca42f094c5280]
> > [33827.216510]  clone_endio+0x120/0x1f0 [dm_mod
> > 1400000003000000474e5500e90ca42f094c5280]
> > [33827.216533]  md_end_clone_io+0x42/0xa0 [md_mod
> > 1400000003000000474e55004ac7ec7b1ac1c22c]
> > [33827.216559]  handle_stripe_clean_event+0x1e6/0x430 [raid456
> > 1400000003000000474e550080acde909728c7a9]
> > [33827.216583]  handle_stripe+0x9a3/0x1c00 [raid456
> > 1400000003000000474e550080acde909728c7a9]
> > [33827.216606]  handle_active_stripes.isra.0+0x381/0x5b0 [raid456
> > 1400000003000000474e550080acde909728c7a9]
> > [33827.216625]  ? psi_task_switch+0xb7/0x200
> > [33827.216637]  raid5d+0x450/0x670 [raid456
> > 1400000003000000474e550080acde909728c7a9]
> > [33827.216655]  ? lock_timer_base+0x76/0xa0
> > [33827.216666]  md_thread+0xa2/0x190 [md_mod
> > 1400000003000000474e55004ac7ec7b1ac1c22c]
> > [33827.216689]  ? __pfx_autoremove_wake_function+0x10/0x10
> > [33827.216701]  ? __pfx_md_thread+0x10/0x10 [md_mod
> > 1400000003000000474e55004ac7ec7b1ac1c22c]
> > [33827.216723]  kthread+0xcf/0x100
> > [33827.216731]  ? __pfx_kthread+0x10/0x10
> > [33827.216740]  ret_from_fork+0x31/0x50
> > [33827.216749]  ? __pfx_kthread+0x10/0x10
> > [33827.216757]  ret_from_fork_asm+0x1a/0x30
> > [33827.216769]  </TASK>
> >
> > --
> > Gene
> >
> 
---1463811712-373633788-1731926083=:1407836--

