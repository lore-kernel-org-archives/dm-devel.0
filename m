Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279A1A54;
	Tue, 31 Oct 2023 03:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="IAw1teNf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dbpERuvw"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id D37475C029F;
	Mon, 30 Oct 2023 23:48:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 30 Oct 2023 23:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698724128; x=1698810528; bh=b1LXrGDZzg6rcDGwcVXq/nku1LV3SPu8vEc
	6kzHIX78=; b=IAw1teNfOhAthN9/seJAqlelzv4CtLjIl6NfUnsH5lxTg/25Ik1
	1+VBHSBXL69BO8UoxUkv3PwgN25+rk48edAr5qmxV2l7V+T8raiSZfTMVwXl0Mge
	/zoAG80bn34vGbYc6LKR1e25L1gQr6MysYHCn3u1tghtnOKMyBhg9bRgdW5orvsA
	UZnz+BT+/i8LN3uIQ26u4NC4Jw02nIu+tdEKSIlFTF/nbfocihmWErEn8Macjsrq
	eRnSfLqPZoqoJidl/Mmz+5hvsTjmxqFB8cXGcVlo9e82A6V+W6Uab+ibNlK1rJ4p
	Dprey9afCqLhfe2LP3mb0atYJHNHBh3uIIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698724128; x=1698810528; bh=b1LXrGDZzg6rc
	DGwcVXq/nku1LV3SPu8vEc6kzHIX78=; b=dbpERuvwsOEEnq7050GVjwPCbz0aj
	hxGleJjU3tTgUyYoXCg/UFVvYxGT0FK17qbVR6F3rf1mk+oYdsyaQVYKtnWcvI0/
	TZ8uQdAUNiaIzTyFafsmpIQJ3h53bjDIRyXyNRYW7cEGjJtZZquxAk2jf4sVVjUr
	IoekRK0EBnA2gsh6/r87DjFpVnVBgAaqKgWg8AwvkL02PfP8K31N1+zbVVceX5ix
	+FK+kJngZtmXdVGv8UUrABLyDhai7e+IWS6cerb2JcXLkPmnnqu2bepX65XwO0SJ
	vLNsUycRwD2feiiAok7jMvxCHTJrVQszJgI/fX+6cashAgMRJDzo7dJ5A==
X-ME-Sender: <xms:IHlAZUlbGqdNjdonhhGN61zdQwKst24db4qBbUgd0x60TMvPCwq73Q>
    <xme:IHlAZT2QfpF4NMaJ8Gy3clHgOMtAujo3ZBdlE4rQYORBySDhA8e77w8-O2fvcYF6C
    OFmup1AxhtFcQ>
X-ME-Received: <xmr:IHlAZSqQFn6TbecUlvTcuJgkdlSqVrhoPh24gK8o7QNPbvB-JSJEd2P4EP_c9EK6ncgEJRWLKJhNxszLnOiWK84egnDH7-lQOpU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtuddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:IHlAZQmKvIwY0MgTTUMuhvP45crTPM_Ccbq-AvS23oK7a1TE8fqwsQ>
    <xmx:IHlAZS2g2pqfIRboGSGZUVt7nCn9V1AOV6eU2YUKql0OqNQIfn1uZg>
    <xmx:IHlAZXs9YYuHBflgWdn-azWp2HyCE37b6e8F7-_oAav4fKcx_hu3PQ>
    <xmx:IHlAZQw_HD6mceDeK2-2suMkI3FPFYaOYBBGw5wDHdu5Qn5o1ZZLSQ>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Oct 2023 23:48:46 -0400 (EDT)
Date: Tue, 31 Oct 2023 04:48:44 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUB5HFeK3eHeI8UH@mail-itl>
References: <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
 <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
 <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
 <20231030122513.6gds75hxd65gu747@quack3>
 <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sCPM8eUZCWbTx7rm"
Content-Disposition: inline
In-Reply-To: <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>


--sCPM8eUZCWbTx7rm
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 31 Oct 2023 04:48:44 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Mon, Oct 30, 2023 at 06:50:35PM +0100, Mikulas Patocka wrote:
> On Mon, 30 Oct 2023, Marek Marczykowski-G=C3=B3recki wrote:
> > Then retried with order=3DPAGE_ALLOC_COSTLY_ORDER and
> > PAGE_ALLOC_COSTLY_ORDER back at 3, and also got similar crash.
>=20
> So, does it mean that even allocating with order=3DPAGE_ALLOC_COSTLY_ORDE=
R=20
> isn't safe?

That seems to be another bug, see below.

> Try enabling CONFIG_DEBUG_VM (it also needs CONFIG_DEBUG_KERNEL) and try=
=20
> to provoke a similar crash. Let's see if it crashes on one of the=20
> VM_BUG_ON statements.

This was very interesting idea. With this, immediately after login I get
the crash like below. Which makes sense, as this is when pulseaudio
starts and opens /dev/snd/*. I then tried with the dm-crypt commit
reverted and still got the crash! But, after blacklisting snd_pcm,
there is no BUG splat, but the storage freeze still happens on vanilla 6.5.=
6.

The snd_pcm BUG splat:

[   51.082877] page:00000000d8fdb7f1 refcount:0 mapcount:0 mapping:00000000=
00000000 index:0x0 pfn:0x11b7d9
[   51.082919] flags: 0x200000000000000(node=3D0|zone=3D2)
[   51.082924] page_type: 0xffffffff()
[   51.082929] raw: 0200000000000000 dead000000000100 dead000000000122 0000=
000000000000
[   51.082934] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000=
000000000000
[   51.082938] page dumped because: VM_BUG_ON_FOLIO(((unsigned int) folio_r=
ef_count(folio) + 127u <=3D 127u))
[   51.082969] ------------[ cut here ]------------
[   51.082972] kernel BUG at include/linux/mm.h:1406!
[   51.082980] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   51.082986] CPU: 5 PID: 3893 Comm: alsa-sink-Gener Tainted: G        W  =
        6.5.6-dirty #359
[   51.082992] Hardware name: Star Labs StarBook/StarBook, BIOS 8.97 10/03/=
2023
[   51.082997] RIP: e030:snd_pcm_mmap_data_fault+0x11d/0x140 [snd_pcm]
[   51.083015] Code: 48 2b 05 8e 7b 67 c2 48 01 f0 48 c1 e8 0c 48 c1 e0 06 =
48 03 05 6c 7b 67 c2 e9 4c ff ff ff 48 c7 c6 d8 71 1c c0 e8 93 1e 0e c1 <0f=
> 0b 48 83 ef 01 e9 4d ff ff ff 48 8b 05 51 47 89 c2 eb c9 66 66
[   51.083023] RSP: e02b:ffffc90041be7e00 EFLAGS: 00010246
[   51.083028] RAX: 000000000000005c RBX: ffffc90041be7e28 RCX: 00000000000=
00000
[   51.083033] RDX: 0000000000000000 RSI: 0000000000000027 RDI: 00000000fff=
fffff
[   51.083038] RBP: ffff888102e75f18 R08: 00000000ffffdfff R09: 00000000000=
00001
[   51.083042] R10: 00000000ffffdfff R11: ffffffff82a5ddc0 R12: ffff888102e=
75f18
[   51.083047] R13: 0000000000000255 R14: ffff888100955e80 R15: ffff888102e=
75f18
[   51.083056] FS:  00007f51d354f6c0(0000) GS:ffff888189740000(0000) knlGS:=
0000000000000000
[   51.083061] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.083065] CR2: 00007f51d36f6000 CR3: 000000011b53e000 CR4: 00000000000=
50660
[   51.083072] Call Trace:
[   51.083076]  <TASK>
[   51.083078]  ? die+0x31/0x80
[   51.083085]  ? do_trap+0xd5/0x100
[   51.083089]  ? snd_pcm_mmap_data_fault+0x11d/0x140 [snd_pcm]
[   51.083103]  ? do_error_trap+0x65/0x90
[   51.083107]  ? snd_pcm_mmap_data_fault+0x11d/0x140 [snd_pcm]
[   51.083120]  ? exc_invalid_op+0x50/0x70
[   51.083127]  ? snd_pcm_mmap_data_fault+0x11d/0x140 [snd_pcm]
[   51.083140]  ? asm_exc_invalid_op+0x1a/0x20
[   51.083146]  ? snd_pcm_mmap_data_fault+0x11d/0x140 [snd_pcm]
[   51.083159]  __do_fault+0x29/0x110
[   51.083165]  __handle_mm_fault+0x5fb/0xc40
[   51.083170]  handle_mm_fault+0x91/0x1e0
[   51.083173]  do_user_addr_fault+0x216/0x5d0
[   51.083179]  ? check_preemption_disabled+0x31/0xf0
[   51.083185]  exc_page_fault+0x71/0x160
[   51.083189]  asm_exc_page_fault+0x26/0x30
[   51.083195] RIP: 0033:0x7f51e56793ca
[   51.083198] Code: c5 fe 7f 07 c5 fe 7f 47 20 c5 fe 7f 47 40 c5 fe 7f 47 =
60 c5 f8 77 c3 66 0f 1f 84 00 00 00 00 00 40 0f b6 c6 48 89 d1 48 89 fa <f3=
> aa 48 89 d0 c5 f8 77 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
[   51.083207] RSP: 002b:00007f51d354c528 EFLAGS: 00010202
[   51.083211] RAX: 0000000000000000 RBX: 00007f51d354ec80 RCX: 00000000000=
034e0
[   51.083216] RDX: 00007f51d36f5000 RSI: 0000000000000000 RDI: 00007f51d36=
f6000
[   51.083220] RBP: 000055fec98b2f60 R08: 00007f51cc0031c0 R09: 00000000000=
00000
[   51.083224] R10: 0000000000000000 R11: 0000000000000101 R12: 000055fec98=
b2f60
[   51.083228] R13: 00007f51d354c630 R14: 0000000000000000 R15: 000055fec78=
ba680
[   51.083233]  </TASK>
[   51.083235] Modules linked in: snd_hda_codec_hdmi snd_sof_pci_intel_tgl =
snd_sof_intel_hda_common snd_soc_hdac_hda soundwire_intel soundwire_generic=
_allocation snd_sof_intel_hda_mlink soundwire_cadence snd_sof_intel_hda snd=
_hda_codec_generic snd_sof_pci ledtrig_audio snd_sof snd_sof_utils snd_sof_=
xtensa_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core soundwire=
_bus snd_soc_core snd_compress snd_pcm_dmaengine ac97_bus snd_hda_intel snd=
_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hwdep snd_hda_core snd_s=
eq snd_seq_device hid_multitouch snd_pcm i2c_i801 idma64 iwlwifi i2c_smbus =
i2c_designware_platform i2c_designware_core snd_timer snd soundcore efivarf=
s i2c_hid_acpi i2c_hid pinctrl_tigerlake pinctrl_intel xen_acpi_processor x=
en_pciback xen_blkback xen_gntalloc xen_gntdev xen_evtchn uinput
[   51.083293] ---[ end trace 0000000000000000 ]---
[   51.083296] RIP: e030:snd_pcm_mmap_data_fault+0x11d/0x140 [snd_pcm]
[   51.083310] Code: 48 2b 05 8e 7b 67 c2 48 01 f0 48 c1 e8 0c 48 c1 e0 06 =
48 03 05 6c 7b 67 c2 e9 4c ff ff ff 48 c7 c6 d8 71 1c c0 e8 93 1e 0e c1 <0f=
> 0b 48 83 ef 01 e9 4d ff ff ff 48 8b 05 51 47 89 c2 eb c9 66 66
[   51.083318] RSP: e02b:ffffc90041be7e00 EFLAGS: 00010246
[   51.083323] RAX: 000000000000005c RBX: ffffc90041be7e28 RCX: 00000000000=
00000
[   51.083327] RDX: 0000000000000000 RSI: 0000000000000027 RDI: 00000000fff=
fffff
[   51.083331] RBP: ffff888102e75f18 R08: 00000000ffffdfff R09: 00000000000=
00001
[   51.083335] R10: 00000000ffffdfff R11: ffffffff82a5ddc0 R12: ffff888102e=
75f18
[   51.083340] R13: 0000000000000255 R14: ffff888100955e80 R15: ffff888102e=
75f18
[   51.083347] FS:  00007f51d354f6c0(0000) GS:ffff888189740000(0000) knlGS:=
0000000000000000
[   51.083353] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.083356] CR2: 00007f51d36f6000 CR3: 000000011b53e000 CR4: 00000000000=
50660

Having discovered that, I'm redoing recent tests with snd_pcm
blacklisted. I'll get back to debugging snd_pcm issue separately.

Plain 6.5.6 (so order =3D MAX_ORDER - 1, and PAGE_ALLOC_COSTLY_ORDER=3D3), =
in frozen state:

[  143.195348] sysrq: Show Blocked State
[  143.195471] task:lvm             state:D stack:13312 pid:4882  ppid:2025=
   flags:0x00004002
[  143.195504] Call Trace:
[  143.195514]  <TASK>
[  143.195526]  __schedule+0x30e/0x8b0
[  143.195550]  ? __pfx_dev_suspend+0x10/0x10
[  143.195569]  schedule+0x59/0xb0
[  143.195582]  io_schedule+0x41/0x70
[  143.195595]  dm_wait_for_completion+0x19d/0x1b0
[  143.195671]  ? __pfx_autoremove_wake_function+0x10/0x10
[  143.195693]  __dm_suspend+0x79/0x190
[  143.195707]  ? __pfx_dev_suspend+0x10/0x10
[  143.195723]  dm_internal_suspend_noflush+0x57/0x80
[  143.195740]  pool_presuspend+0xc7/0x130
[  143.195759]  dm_table_presuspend_targets+0x38/0x60
[  143.195774]  __dm_suspend+0x34/0x190
[  143.195788]  ? preempt_count_add+0x69/0xa0
[  143.195805]  ? __pfx_dev_suspend+0x10/0x10
[  143.195819]  dm_suspend+0xbb/0xe0
[  143.195835]  ? preempt_count_add+0x46/0xa0
[  143.195851]  dev_suspend+0x18e/0x2d0
[  143.195867]  ? __pfx_dev_suspend+0x10/0x10
[  143.195882]  ctl_ioctl+0x329/0x640
[  143.195901]  dm_ctl_ioctl+0x9/0x10
[  143.195917]  __x64_sys_ioctl+0x8f/0xd0
[  143.195938]  do_syscall_64+0x3c/0x90
[  143.195954]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  143.195975] RIP: 0033:0x7f2e0ab1fe0f
[  143.195989] RSP: 002b:00007ffd59a16e60 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  143.196011] RAX: ffffffffffffffda RBX: 000056289d130840 RCX: 00007f2e0ab=
1fe0f
[  143.196029] RDX: 000056289d120b80 RSI: 00000000c138fd06 RDI: 00000000000=
00003
[  143.196046] RBP: 000056289d120b80 R08: 000056289a7eb190 R09: 00007ffd59a=
16d20
[  143.196063] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
0000c
[  143.196080] R13: 000056289a7e4cf0 R14: 000056289a77e14d R15: 000056289d1=
20bb0
[  143.196098]  </TASK>
[  143.196106] task:blkdiscard      state:D stack:13672 pid:4884  ppid:2025=
   flags:0x00000002
[  143.196130] Call Trace:
[  143.196139]  <TASK>
[  143.196147]  __schedule+0x30e/0x8b0
[  143.196162]  schedule+0x59/0xb0
[  143.196175]  schedule_timeout+0x14c/0x160
[  143.196193]  io_schedule_timeout+0x4b/0x70
[  143.196207]  wait_for_completion_io+0x81/0x130
[  143.196226]  submit_bio_wait+0x5c/0x90
[  143.196241]  blkdev_issue_discard+0x94/0xe0
[  143.196260]  blkdev_common_ioctl+0x79e/0x9c0
[  143.196279]  blkdev_ioctl+0xc7/0x270
[  143.196293]  __x64_sys_ioctl+0x8f/0xd0
[  143.196310]  do_syscall_64+0x3c/0x90
[  143.196324]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  143.196343] RIP: 0033:0x7fa6cebcee0f
[  143.196354] RSP: 002b:00007ffe6700fa80 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  143.196374] RAX: ffffffffffffffda RBX: 0000000280000000 RCX: 00007fa6ceb=
cee0f
[  143.196391] RDX: 00007ffe6700fb50 RSI: 0000000000001277 RDI: 00000000000=
00003
[  143.196408] RBP: 0000000000000003 R08: 0000000000000071 R09: 00000000000=
00004
[  143.196424] R10: 00007ffe67064170 R11: 0000000000000246 R12: 00000000400=
00000
[  143.196441] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[  143.196460]  </TASK>

for f in $(grep -l crypt /proc/*/comm); do head $f ${f/comm/stack}; done
=3D=3D> /proc/3761/comm <=3D=3D
kworker/u12:7-kcryptd/252:0

=3D=3D> /proc/3761/stack <=3D=3D
[<0>] worker_thread+0xab/0x3b0
[<0>] kthread+0xef/0x120
[<0>] ret_from_fork+0x2c/0x50
[<0>] ret_from_fork_asm+0x1b/0x30
=3D=3D> /proc/51/comm <=3D=3D
cryptd

=3D=3D> /proc/51/stack <=3D=3D
[<0>] rescuer_thread+0x2d5/0x390
[<0>] kthread+0xef/0x120
[<0>] ret_from_fork+0x2c/0x50
[<0>] ret_from_fork_asm+0x1b/0x30
=3D=3D> /proc/556/comm <=3D=3D
kcryptd_io/252:

=3D=3D> /proc/556/stack <=3D=3D
[<0>] rescuer_thread+0x2d5/0x390
[<0>] kthread+0xef/0x120
[<0>] ret_from_fork+0x2c/0x50
[<0>] ret_from_fork_asm+0x1b/0x30
=3D=3D> /proc/557/comm <=3D=3D
kcryptd/252:0

=3D=3D> /proc/557/stack <=3D=3D
[<0>] rescuer_thread+0x2d5/0x390
[<0>] kthread+0xef/0x120
[<0>] ret_from_fork+0x2c/0x50
[<0>] ret_from_fork_asm+0x1b/0x30
=3D=3D> /proc/558/comm <=3D=3D
dmcrypt_write/252:0

=3D=3D> /proc/558/stack <=3D=3D
[<0>] dmcrypt_write+0x6a/0x140
[<0>] kthread+0xef/0x120
[<0>] ret_from_fork+0x2c/0x50
[<0>] ret_from_fork_asm+0x1b/0x30
=3D=3D> /proc/717/comm <=3D=3D
kworker/u12:6-kcryptd/252:0

=3D=3D> /proc/717/stack <=3D=3D
[<0>] worker_thread+0xab/0x3b0
[<0>] kthread+0xef/0x120
[<0>] ret_from_fork+0x2c/0x50
[<0>] ret_from_fork_asm+0x1b/0x30


Then tried:
 - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D4 - cannot reproduce,
 - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D5 - cannot reproduce,
 - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D6 - freeze rather quickly

I've retried the PAGE_ALLOC_COSTLY_ORDER=3D4,order=3D5 case several times
and I can't reproduce the issue there. I'm confused...

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--sCPM8eUZCWbTx7rm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVAeRwACgkQ24/THMrX
1yyAbAf8C1c0HlDZTaucuIDaz6Z6srvlesKu8+GU2TqjZ3sZCw5VPqt3pHxOR2c7
+flv+Np3jGMARWja9aZ8cAi5ejL09Hilf0DPhDRhi+MlindRz5NNnc9mRULLlEQO
D7M3sx9eIUqt9cC8FhKNMZ3injfKPMP7Qb8vAFaIY8SRMFDmLAB3zlE51XHPNCHj
oiLUY+pjrBg/2mHYMgGL1Fa4tsi8V0tgmKuLhlReTttBgh05f0OCQDUdb1vcIfc8
iehCon82bQpIEjmKSll36eFo/inhiBaD6Q/9dIiPmuRlKaSd8PV1iH7h/g2kzVR5
c4Po91i0BeDROxOof5211MmCDkeV7Q==
=b8da
-----END PGP SIGNATURE-----

--sCPM8eUZCWbTx7rm--
