Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855B4CA7C;
	Mon, 30 Oct 2023 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="V6bAWfyL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ryS2LRe2"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 5A8EA5C00F8;
	Mon, 30 Oct 2023 12:51:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 30 Oct 2023 12:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698684672; x=1698771072; bh=vFT3biKe+R2SZSGOpiXEA/apBlYAwDLEu0q
	/hncIIzA=; b=V6bAWfyLaPvvM/YLRo91+csURkXKz4WDZAFA3U8HKBNwmv8m0oN
	39yN7RvWV/kFSWkWwz7NN4ENPfCJA9DFwODdKHokWetcBYP22qTvrhgMekWEnnC8
	lnPe0IvUQecH8FoSzVa7K6dAMfFdYCfxvIVOE7Ums6yJpyhTvlIflZBG1/BARA9V
	4efIkgcTxtWq+mpKAsliJixhnBtMIEcAAPNqTgHo+eHjyrG9fPRGO9ByPGVk6o0T
	1zkfpREsDgU/JM39qqBYT+J5cJOPUGbp71DgHvYk5kFvpoX+OBr/11pjaU+so8YR
	L9iQ344d+psyAqy/P1/Q2yQA7BpQbKu7Eow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698684672; x=1698771072; bh=vFT3biKe+R2SZ
	SGOpiXEA/apBlYAwDLEu0q/hncIIzA=; b=ryS2LRe2uAoLeFn3tlWlYMBYQgYVw
	2V4Kf5VC5Tfzc9CzZNASWDgA15e1Ycro1Bw2kF9kNxvwEZ7027NfmXn49e3+rN0c
	RdEmpMuXcSCsmlt+wG/qBztY3Zue0JhGRPBfOJtYdbPpt8F1gdWYgqalCNozrgPd
	WN3bIL62FhKxtLczRMlqF3kPKz36DfFyt0/oYY1CC6KPQDHPsebXT72qh0dwl2zt
	li6uTQHRZH2Y/DEMQslvravHKPfCq6BuSZ+QWs0MTggo21UFOjn8zKuY6D4ENGm2
	LwKnw5cpRK6ax1IngKg4Z4bSNPBOdtRtAJjjvnsUmCJevJnfPj/yI1aHA==
X-ME-Sender: <xms:_94_ZTmhhOp5ltdvXAJtBlk8h2dhBEARvBR2etZTEu6DDj3ZIVPceg>
    <xme:_94_ZW3301memA1nZ1BuLvlaE6mV0qTX8PpLuYXrUqF7uHBc-5p98xL_3BHz0bj3j
    rLYY1qtIeZz6A>
X-ME-Received: <xmr:_94_ZZqfaEUX3M-YD0r3VD7whbXmfGrUk82sdXjTbljVIIA-ZkEmRL0VMDFJn56TdElszXBuj9tbO77-VXQbNhUR2db7G7rgwXY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddttddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:_94_Zbm8y3-yfNxRUF6hzyk5jdftOYX2H3ILM7omgCQJHZlKefMEJg>
    <xmx:_94_ZR1VHRpZHK_tkh3KCRwtgs6qPVNa4ByZ56-rdIy6FBodf-17zA>
    <xmx:_94_Zavnl5bSPE8gG6Bvp6WAut61Wv9S1bfbD2C8sLhZMkd9eHPOWg>
    <xmx:AN8_Zbx9HQtu9gH-9h3q4L8jFJ325v-jvo7GAY5LKeNuYKA7mKh-kw>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Oct 2023 12:51:09 -0400 (EDT)
Date: Mon, 30 Oct 2023 17:51:07 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Jan Kara <jack@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZT/e/EaBIkJEgevQ@mail-itl>
References: <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
 <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
 <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
 <20231030122513.6gds75hxd65gu747@quack3>
 <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MgdTOJabKUs9zLjX"
Content-Disposition: inline
In-Reply-To: <20231030155603.k3kejytq2e4vnp7z@quack3>


--MgdTOJabKUs9zLjX
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 30 Oct 2023 17:51:07 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Jan Kara <jack@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Mon, Oct 30, 2023 at 04:56:03PM +0100, Jan Kara wrote:
> On Mon 30-10-23 15:08:56, Mikulas Patocka wrote:
> > On Mon, 30 Oct 2023, Marek Marczykowski-G=C3=B3recki wrote:
> >=20
> > > > Well, it would be possible that larger pages in a bio would trip e.=
g. bio
> > > > splitting due to maximum segment size the disk supports (which can =
be e.g.
> > > > 0xffff) and that upsets something somewhere. But this is pure
> > > > speculation. We definitely need more debug data to be able to tell =
more.
> > >=20
> > > I can collect more info, but I need some guidance how :) Some patch
> > > adding extra debug messages?
> > > Note I collect those via serial console (writing to disk doesn't work
> > > when it freezes), and that has some limits in the amount of data I can
> > > extract especially when printed quickly. For example sysrq-t is too m=
uch.
> > > Or maybe there is some trick to it, like increasing log_bug_len?
> >=20
> > If you can do more tests, I would suggest this:
> >=20
> > We already know that it works with order 3 and doesn't work with order =
4.
> >=20
> > So, in the file include/linux/mmzone.h, change PAGE_ALLOC_COSTLY_ORDER=
=20
> > from 3 to 4 and in the file drivers/md/dm-crypt.c leave "unsigned int=
=20
> > order =3D PAGE_ALLOC_COSTLY_ORDER" there.
> >=20
> > Does it deadlock or not?
> >=20
> > So, that we can see whether the deadlock depends on=20
> > PAGE_ALLOC_COSTLY_ORDER or whether it is just a coincidence.
>=20
> Good idea. Also if the kernel hangs, please find kcryptd processes. In wh=
at
> state are they? If they are sleeping, please send what's in
> /proc/<kcryptd-pid>/stack. Thanks!

Will do.

In the meantime, while testing version with PAGE_ALLOC_COSTLY_ORDER=3D4,
and order=3DPAGE_ALLOC_COSTLY_ORDER, I'm getting crash like this (see
important note below both traces):

    [   92.668486] BUG: unable to handle page fault for address: ffff8880c7=
b64098
    [   92.668558] #PF: supervisor read access in kernel mode
    [   92.668574] #PF: error_code(0x0000) - not-present page
    [   92.668590] PGD 2a32067 P4D 2a32067 PUD 12868a067 PMD 0=20
    [   92.668617] Oops: 0000 [#1] PREEMPT SMP NOPTI
    [   92.668637] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W       =
   6.5.6-dirty #354
    [   92.668658] Hardware name: Star Labs StarBook/StarBook, BIOS 8.97 10=
/03/2023
    [   92.668675] RIP: e030:__free_one_page+0x301/0x3e0
    [   92.668704] Code: 02 0f 85 c1 fe ff ff 49 c1 e6 04 49 8d 4c 24 08 4a=
 8d 94 36 c0 00 00 00 48 8d 34 80 48 8d 04 70 4c 01 fa 48 c1 e0 03 49 01 c6=
 <4b> 8b b4 37 c0 00 00 00 48 89 4e 08 49 89 74 24 08 49 89 54 24 10
    [   92.668738] RSP: e02b:ffffc90040154c60 EFLAGS: 00010006
    [   92.668754] RAX: 0000000000000058 RBX: 0000000000000001 RCX: ffff888=
075f66bc0
    [   92.668773] RDX: ffff8880c7b64098 RSI: 0000000000000005 RDI: 0000000=
000000000
    [   92.668789] RBP: fffffe7a01d7d9ae R08: ffff888075f66b38 R09: fffffe7=
a01d7d9ac
    [   92.668805] R10: ffffea0004b35bc8 R11: 0000000000000001 R12: ffff888=
075f66bb8
    [   92.668821] R13: 0000000000000000 R14: 0000000051bfd4d8 R15: ffff888=
075f66b00
    [   92.668854] FS:  0000000000000000(0000) GS:ffff888189740000(0000) kn=
lGS:0000000000000000
    [   92.668874] CS:  10000e030 DS: 002b ES: 002b CR0: 0000000080050033
    [   92.668889] CR2: ffff8880c7b64098 CR3: 0000000133cf8000 CR4: 0000000=
000050660
    [   92.668912] Call Trace:
    [   92.668924]  <IRQ>
    [   92.668934]  ? __die+0x1e/0x60
    [   92.668955]  ? page_fault_oops+0x178/0x4a0
    [   92.668975]  ? exc_page_fault+0x14e/0x160
    [   92.668994]  ? asm_exc_page_fault+0x26/0x30
    [   92.669014]  ? __free_one_page+0x301/0x3e0
    [   92.669027]  free_pcppages_bulk+0x11c/0x2b0
    [   92.669042]  free_unref_page+0x10d/0x170
    [   92.669058]  crypt_free_buffer_pages+0x1f4/0x250
    [   92.669079]  crypt_endio+0x48/0x70
    [   92.669094]  blk_mq_end_request_batch+0xd0/0x400
    [   92.669114]  nvme_irq+0x6d/0x80
    [   92.669132]  ? __pfx_nvme_pci_complete_batch+0x10/0x10
    [   92.669148]  __handle_irq_event_percpu+0x42/0x1a0
    [   92.669166]  handle_irq_event+0x33/0x70
    [   92.669179]  handle_edge_irq+0x9e/0x240
    [   92.669197]  handle_irq_desc+0x36/0x50
    [   92.669215]  __evtchn_fifo_handle_events+0x1af/0x1d0
    [   92.669236]  __xen_evtchn_do_upcall+0x70/0xd0
    [   92.669255]  __xen_pv_evtchn_do_upcall+0x3d/0x70
    [   92.669275]  xen_pv_evtchn_do_upcall+0xd9/0x110
    [   92.669294]  </IRQ>
    [   92.669302]  <TASK>
    [   92.669310]  exc_xen_hypervisor_callback+0x8/0x20
    [   92.669330] RIP: e030:xen_hypercall_xen_version+0xa/0x20
    [   92.669348] Code: 51 41 53 b8 10 00 00 00 0f 05 41 5b 59 c3 cc cc cc=
 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 51 41 53 b8 11 00 00 00 0f 05=
 <41> 5b 59 c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
    [   92.669380] RSP: e02b:ffffc900400c7e08 EFLAGS: 00000246
    [   92.669394] RAX: 0000000000040011 RBX: 0000000000000000 RCX: fffffff=
f81fc222a
    [   92.669411] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000=
000000000
    [   92.669426] RBP: ffffc900400c7eb0 R08: 0000000000000000 R09: 0000000=
0000001ba
    [   92.669442] R10: 0000000000007ff0 R11: 0000000000000246 R12: ffff888=
18976c540
    [   92.669458] R13: ffff888101e10000 R14: 0000000000000000 R15: 0000000=
000000402
    [   92.669475]  ? xen_hypercall_xen_version+0xa/0x20
    [   92.669493]  ? pmu_msr_read+0x3c/0xd0
    [   92.669510]  ? xen_force_evtchn_callback+0xd/0x20
    [   92.669526]  ? check_events+0x16/0x30
    [   92.669540]  ? xen_irq_enable_direct+0x1d/0x30
    [   92.669556]  ? finish_task_switch.isra.0+0x8e/0x270
    [   92.669576]  ? __switch_to+0x165/0x3b0
    [   92.669590]  ? __schedule+0x316/0x8b0
    [   92.669609]  ? schedule_idle+0x25/0x40
    [   92.669626]  ? cpu_startup_entry+0x25/0x30
    [   92.669641]  ? cpu_bringup_and_idle+0x89/0xa0
    [   92.669660]  ? asm_cpu_bringup_and_idle+0x9/0x10
    [   92.669680]  </TASK>
    [   92.669688] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_gene=
ric ledtrig_audio snd_sof_pci_intel_tgl snd_sof_intel_hda_common snd_soc_hd=
ac_hda soundwire_intel soundwire_generic_allocation snd_sof_intel_hda_mlink=
 soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof snd_sof_utils snd_=
sof_xtensa_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core sound=
wire_bus snd_soc_core snd_compress snd_pcm_dmaengine ac97_bus snd_hda_intel=
 snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hwdep hid_multitouch=
 snd_hda_core snd_seq snd_seq_device idma64 snd_pcm i2c_designware_platform=
 iwlwifi i2c_designware_core snd_timer snd soundcore i2c_i801 i2c_smbus efi=
varfs i2c_hid_acpi i2c_hid pinctrl_tigerlake pinctrl_intel xen_acpi_process=
or xen_pciback xen_blkback xen_gntalloc xen_gntdev xen_evtchn uinput
    [   92.669901] CR2: ffff8880c7b64098
    [   92.669915] ---[ end trace 0000000000000000 ]---
    [   92.669930] RIP: e030:__free_one_page+0x301/0x3e0
    [   92.669946] Code: 02 0f 85 c1 fe ff ff 49 c1 e6 04 49 8d 4c 24 08 4a=
 8d 94 36 c0 00 00 00 48 8d 34 80 48 8d 04 70 4c 01 fa 48 c1 e0 03 49 01 c6=
 <4b> 8b b4 37 c0 00 00 00 48 89 4e 08 49 89 74 24 08 49 89 54 24 10
    [   92.669977] RSP: e02b:ffffc90040154c60 EFLAGS: 00010006
    [   92.669992] RAX: 0000000000000058 RBX: 0000000000000001 RCX: ffff888=
075f66bc0
    [   92.670008] RDX: ffff8880c7b64098 RSI: 0000000000000005 RDI: 0000000=
000000000
    [   92.670024] RBP: fffffe7a01d7d9ae R08: ffff888075f66b38 R09: fffffe7=
a01d7d9ac
    [   92.670040] R10: ffffea0004b35bc8 R11: 0000000000000001 R12: ffff888=
075f66bb8
    [   92.670055] R13: 0000000000000000 R14: 0000000051bfd4d8 R15: ffff888=
075f66b00
    [   92.670083] FS:  0000000000000000(0000) GS:ffff888189740000(0000) kn=
lGS:0000000000000000
    [   92.670101] CS:  10000e030 DS: 002b ES: 002b CR0: 0000000080050033
    [   92.670116] CR2: ffff8880c7b64098 CR3: 0000000133cf8000 CR4: 0000000=
000050660
    [   92.670148] Kernel panic - not syncing: Fatal exception in interrupt
    [   92.670177] ------------[ cut here ]------------
    [   92.670188] WARNING: CPU: 5 PID: 0 at kernel/smp.c:766 smp_call_func=
tion_many_cond+0x4db/0x560
    [   92.670219] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_gene=
ric ledtrig_audio snd_sof_pci_intel_tgl snd_sof_intel_hda_common snd_soc_hd=
ac_hda soundwire_intel soundwire_generic_allocation snd_sof_intel_hda_mlink=
 soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof snd_sof_utils snd_=
sof_xtensa_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core sound=
wire_bus snd_soc_core snd_compress snd_pcm_dmaengine ac97_bus snd_hda_intel=
 snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hwdep hid_multitouch=
 snd_hda_core snd_seq snd_seq_device idma64 snd_pcm i2c_designware_platform=
 iwlwifi i2c_designware_core snd_timer snd soundcore i2c_i801 i2c_smbus efi=
varfs i2c_hid_acpi i2c_hid pinctrl_tigerlake pinctrl_intel xen_acpi_process=
or xen_pciback xen_blkback xen_gntalloc xen_gntdev xen_evtchn uinput
    [   92.670400] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D W       =
   6.5.6-dirty #354
    [   92.670419] Hardware name: Star Labs StarBook/StarBook, BIOS 8.97 10=
/03/2023
    [   92.670434] RIP: e030:smp_call_function_many_cond+0x4db/0x560
    [   92.670455] Code: f0 52 1b 81 48 89 74 24 08 e8 d1 c8 f6 ff 48 8b 74=
 24 08 65 ff 0d 5d 70 e7 7e 0f 85 bb fd ff ff 0f 1f 44 00 00 e9 b1 fd ff ff=
 <0f> 0b e9 69 fb ff ff 8b 7c 24 38 e8 d5 4f f7 ff 84 c0 0f 84 a8 fd
    [   92.670486] RSP: e02b:ffffc900401549d0 EFLAGS: 00010006
    [   92.670500] RAX: 0000000080010007 RBX: 0000000000000000 RCX: 0000000=
000000000
    [   92.670516] RDX: 0000000000000000 RSI: ffffffff826f3c61 RDI: fffffff=
f82cbc1d0
    [   92.670531] RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000=
000000001
    [   92.670546] R10: 00000000ffffdfff R11: ffffffff82a5ddc0 R12: 0000000=
000000005
    [   92.670562] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
    [   92.670588] FS:  0000000000000000(0000) GS:ffff888189740000(0000) kn=
lGS:0000000000000000
    [   92.670606] CS:  10000e030 DS: 002b ES: 002b CR0: 0000000080050033
    [   92.670620] CR2: ffff8880c7b64098 CR3: 0000000133cf8000 CR4: 0000000=
000050660
    [   92.670642] Call Trace:
    [   92.670650]  <IRQ>
    [   92.670659]  ? smp_call_function_many_cond+0x4db/0x560
    [   92.670677]  ? __warn+0x7c/0x130
    [   92.670693]  ? smp_call_function_many_cond+0x4db/0x560
    [   92.670711]  ? report_bug+0x191/0x1c0
    [   92.670726]  ? handle_bug+0x3c/0x80
    [   92.670742]  ? exc_invalid_op+0x17/0x70
    [   92.670758]  ? asm_exc_invalid_op+0x1a/0x20
    [   92.670775]  ? smp_call_function_many_cond+0x4db/0x560
    [   92.670793]  ? __pfx_stop_self+0x10/0x10
    [   92.670811]  ? _printk+0x5f/0x80
    [   92.670823]  ? __pfx_stop_self+0x10/0x10
    [   92.670840]  smp_call_function+0x38/0x70
    [   92.670857]  panic+0x19c/0x320
    [   92.670873]  oops_end+0xd8/0xe0
    [   92.670887]  page_fault_oops+0x19c/0x4a0
    [   92.670905]  exc_page_fault+0x14e/0x160
    [   92.670921]  asm_exc_page_fault+0x26/0x30
    [   92.670937] RIP: e030:__free_one_page+0x301/0x3e0
    [   92.670952] Code: 02 0f 85 c1 fe ff ff 49 c1 e6 04 49 8d 4c 24 08 4a=
 8d 94 36 c0 00 00 00 48 8d 34 80 48 8d 04 70 4c 01 fa 48 c1 e0 03 49 01 c6=
 <4b> 8b b4 37 c0 00 00 00 48 89 4e 08 49 89 74 24 08 49 89 54 24 10
    [   92.670983] RSP: e02b:ffffc90040154c60 EFLAGS: 00010006
    [   92.670997] RAX: 0000000000000058 RBX: 0000000000000001 RCX: ffff888=
075f66bc0
    [   92.671013] RDX: ffff8880c7b64098 RSI: 0000000000000005 RDI: 0000000=
000000000
    [   92.671028] RBP: fffffe7a01d7d9ae R08: ffff888075f66b38 R09: fffffe7=
a01d7d9ac
    [   92.671044] R10: ffffea0004b35bc8 R11: 0000000000000001 R12: ffff888=
075f66bb8
    [   92.671059] R13: 0000000000000000 R14: 0000000051bfd4d8 R15: ffff888=
075f66b00
    [   92.671077]  free_pcppages_bulk+0x11c/0x2b0
    [   92.671091]  free_unref_page+0x10d/0x170
    [   92.671106]  crypt_free_buffer_pages+0x1f4/0x250
    [   92.671122]  crypt_endio+0x48/0x70
    [   92.671136]  blk_mq_end_request_batch+0xd0/0x400
    [   92.671152]  nvme_irq+0x6d/0x80
    [   92.671166]  ? __pfx_nvme_pci_complete_batch+0x10/0x10
    [   92.671181]  __handle_irq_event_percpu+0x42/0x1a0
    [   92.671196]  handle_irq_event+0x33/0x70
    [   92.671208]  handle_edge_irq+0x9e/0x240
    [   92.671224]  handle_irq_desc+0x36/0x50
    [   92.671241]  __evtchn_fifo_handle_events+0x1af/0x1d0
    [   92.671258]  __xen_evtchn_do_upcall+0x70/0xd0
    [   92.671275]  __xen_pv_evtchn_do_upcall+0x3d/0x70
    [   92.671292]  xen_pv_evtchn_do_upcall+0xd9/0x110
    [   92.671308]  </IRQ>
    [   92.671316]  <TASK>
    [   92.671324]  exc_xen_hypervisor_callback+0x8/0x20
    [   92.671342] RIP: e030:xen_hypercall_xen_version+0xa/0x20
    [   92.671360] Code: 51 41 53 b8 10 00 00 00 0f 05 41 5b 59 c3 cc cc cc=
 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 51 41 53 b8 11 00 00 00 0f 05=
 <41> 5b 59 c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
    [   92.671390] RSP: e02b:ffffc900400c7e08 EFLAGS: 00000246
    [   92.671403] RAX: 0000000000040011 RBX: 0000000000000000 RCX: fffffff=
f81fc222a
    [   92.671419] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000=
000000000
    [   92.671434] RBP: ffffc900400c7eb0 R08: 0000000000000000 R09: 0000000=
0000001ba
    [   92.671449] R10: 0000000000007ff0 R11: 0000000000000246 R12: ffff888=
18976c540
    [   92.671465] R13: ffff888101e10000 R14: 0000000000000000 R15: 0000000=
000000402
    [   92.671481]  ? xen_hypercall_xen_version+0xa/0x20
    [   92.671499]  ? pmu_msr_read+0x3c/0xd0
    [   92.671514]  ? xen_force_evtchn_callback+0xd/0x20
    [   92.671529]  ? check_events+0x16/0x30
    [   92.671543]  ? xen_irq_enable_direct+0x1d/0x30
    [   92.671560]  ? finish_task_switch.isra.0+0x8e/0x270
    [   92.671579]  ? __switch_to+0x165/0x3b0
    [   92.671593]  ? __schedule+0x316/0x8b0
    [   92.671611]  ? schedule_idle+0x25/0x40
    [   92.671631]  ? cpu_startup_entry+0x25/0x30
    [   92.671644]  ? cpu_bringup_and_idle+0x89/0xa0
    [   92.671663]  ? asm_cpu_bringup_and_idle+0x9/0x10
    [   92.671683]  </TASK>
    [   92.671691] ---[ end trace 0000000000000000 ]---
    [   92.671782] Kernel Offset: disabled
    (XEN) Hardware Dom0 crashed: rebooting machine in 5 seconds.


If I change order=3DPAGE_ALLOC_COSTLY_ORDER+1, then this:


    [ 2205.112802] BUG: unable to handle page fault for address: ffffffff89=
630301
    [ 2205.112866] #PF: supervisor write access in kernel mode
    [ 2205.112882] #PF: error_code(0x0002) - not-present page
    [ 2205.112899] PGD 2a35067 P4D 2a35067 PUD 2a36067 PMD 0=20
    [ 2205.112921] Oops: 0002 [#1] PREEMPT SMP NOPTI
    [ 2205.112946] CPU: 0 PID: 12609 Comm: kworker/u12:9 Tainted: G        =
W          6.5.6-dirty #355
    [ 2205.112979] Hardware name: Star Labs StarBook/StarBook, BIOS 8.97 10=
/03/2023
    [ 2205.112997] Workqueue: kcryptd/252:0 kcryptd_crypt
    [ 2205.113022] RIP: e030:get_page_from_freelist+0x281/0x10c0
    [ 2205.113044] Code: 6c 05 18 49 89 df 8b 5c 24 34 49 8b 47 18 48 39 c5=
 0f 84 85 02 00 00 49 8b 47 18 48 8b 48 08 48 8b 30 48 8d 50 f8 48 89 4e 08=
 <48> 89 31 48 b9 00 01 00 00 00 00 ad de 48 89 08 48 83 c1 22 48 89
    [ 2205.113079] RSP: e02b:ffffc90041ea7c48 EFLAGS: 00010283
    [ 2205.113096] RAX: ffffea00059b9248 RBX: 0000000000000001 RCX: fffffff=
f89630301
    [ 2205.113117] RDX: ffffea00059b9240 RSI: ffffea00059b9201 RDI: 0000000=
000000001
    [ 2205.113134] RBP: ffff888189631718 R08: 000000000000c000 R09: 0000000=
00003cb07
    [ 2205.113153] R10: 0000000000000001 R11: fefefefefefefeff R12: ffff888=
075f66b00
    [ 2205.113171] R13: ffff888189631700 R14: 0000000000000000 R15: ffff888=
189631700
    [ 2205.113208] FS:  0000000000000000(0000) GS:ffff888189600000(0000) kn=
lGS:0000000000000000
    [ 2205.113229] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 2205.113245] CR2: ffffffff89630301 CR3: 00000001049d0000 CR4: 0000000=
000050660
    [ 2205.113272] Call Trace:
    [ 2205.113285]  <TASK>
    [ 2205.113295]  ? __die+0x1e/0x60
    [ 2205.113312]  ? page_fault_oops+0x178/0x4a0
    [ 2205.113330]  ? exc_page_fault+0x14e/0x160
    [ 2205.113346]  ? asm_exc_page_fault+0x26/0x30
    [ 2205.113363]  ? get_page_from_freelist+0x281/0x10c0
    [ 2205.113379]  ? get_page_from_freelist+0x227/0x10c0
    [ 2205.113396]  __alloc_pages+0x1dd/0x300
    [ 2205.113412]  crypt_page_alloc+0x29/0x60
    [ 2205.113425]  mempool_alloc+0x81/0x1b0
    [ 2205.113443]  kcryptd_crypt+0x293/0x4b0
    [ 2205.113458]  process_one_work+0x1e0/0x3e0
    [ 2205.113476]  worker_thread+0x49/0x3b0
    [ 2205.113490]  ? _raw_spin_lock_irqsave+0x22/0x50
    [ 2205.113510]  ? __pfx_worker_thread+0x10/0x10
    [ 2205.113527]  kthread+0xef/0x120
    [ 2205.113541]  ? __pfx_kthread+0x10/0x10
    [ 2205.113554]  ret_from_fork+0x2c/0x50
    [ 2205.113568]  ? __pfx_kthread+0x10/0x10
    [ 2205.113581]  ret_from_fork_asm+0x1b/0x30
    [ 2205.113598]  </TASK>
    [ 2205.113606] Modules linked in: snd_hda_codec_hdmi snd_sof_pci_intel_=
tgl snd_sof_intel_hda_common snd_soc_hdac_hda soundwire_intel soundwire_gen=
eric_allocation snd_sof_intel_hda_mlink soundwire_cadence snd_sof_intel_hda=
 snd_sof_pci snd_hda_codec_generic snd_sof ledtrig_audio snd_sof_utils snd_=
sof_xtensa_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core sound=
wire_bus snd_soc_core snd_compress snd_pcm_dmaengine ac97_bus snd_hda_intel=
 snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hwdep snd_hda_core s=
nd_seq snd_seq_device snd_pcm hid_multitouch snd_timer snd i2c_designware_p=
latform i2c_designware_core i2c_i801 soundcore iwlwifi idma64 i2c_smbus i2c=
_hid_acpi i2c_hid pinctrl_tigerlake pinctrl_intel xen_acpi_processor xen_pc=
iback xen_blkback xen_gntalloc xen_gntdev xen_evtchn uinput efivarfs
    [ 2205.113795] CR2: ffffffff89630301
    [ 2205.113808] ---[ end trace 0000000000000000 ]---
    [ 2205.113822] RIP: e030:get_page_from_freelist+0x281/0x10c0
    [ 2205.113839] Code: 6c 05 18 49 89 df 8b 5c 24 34 49 8b 47 18 48 39 c5=
 0f 84 85 02 00 00 49 8b 47 18 48 8b 48 08 48 8b 30 48 8d 50 f8 48 89 4e 08=
 <48> 89 31 48 b9 00 01 00 00 00 00 ad de 48 89 08 48 83 c1 22 48 89
    [ 2205.113873] RSP: e02b:ffffc90041ea7c48 EFLAGS: 00010283
    [ 2205.113887] RAX: ffffea00059b9248 RBX: 0000000000000001 RCX: fffffff=
f89630301
    [ 2205.113903] RDX: ffffea00059b9240 RSI: ffffea00059b9201 RDI: 0000000=
000000001
    [ 2205.113919] RBP: ffff888189631718 R08: 000000000000c000 R09: 0000000=
00003cb07
    [ 2205.113935] R10: 0000000000000001 R11: fefefefefefefeff R12: ffff888=
075f66b00
    [ 2205.113950] R13: ffff888189631700 R14: 0000000000000000 R15: ffff888=
189631700
    [ 2205.113980] FS:  0000000000000000(0000) GS:ffff888189600000(0000) kn=
lGS:0000000000000000
    [ 2205.113998] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 2205.114012] CR2: ffffffff89630301 CR3: 00000001049d0000 CR4: 0000000=
000050660
    [ 2205.114038] note: kworker/u12:9[12609] exited with irqs disabled
    [ 2205.114100] note: kworker/u12:9[12609] exited with preempt_count 2

Then retried with order=3DPAGE_ALLOC_COSTLY_ORDER and
PAGE_ALLOC_COSTLY_ORDER back at 3, and also got similar crash.

Both happened only after logging into X session (lightdm -> Xfce) and
starting xfce4-terminal. If I use text console/ssh/serial and leave
lightdm at login screen, then it does not crash (this is in fact how I
did most previous tests). I have no idea if it's related to some other
bug somewhere else (graphics driver?), or simply higher memory usage due
to the whole Xfce session running.
It could be also a coincidence, the sample size is rather small...
But could be also some memory corruption that depending on memory layout
sometimes results in a crash and sometimes in "just" storage freeze.

Note this all is still on top of 6.5.6 with changes we discuss here. If
you believe it's another issue that got fixed in the meantime, I can
switch to another version, but otherwise I'd like to limit changes.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--MgdTOJabKUs9zLjX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmU/3vwACgkQ24/THMrX
1yyHkwf+O2jKAOIqbVO2p23qEqz9Qoo12Fue4NhNFar4N7DLZ5QsqtOkanh6IcIq
HKOgaX7Dx3A51XWAZak8nIX5rKQtTvmN4WWq0qOZO/dfQ/SGWoIMeWskEzSaZtwN
3Iim1aeBNPaWFYBWbiaxZGBvz+MF0uEbXxVRhA8tDGvkgxsrUm1DGi9iHTUz4CEe
EsvnzI9sWR6iplrMEjOUEAFFwKyTTfjLIuRm5AC2Oz6/rWmpR835Ts0TJs7yhLaa
iVpPMTD9qGgUfe7g2Ka+wTj6zL1pHc/8+wQgcecFqe/xMyPLNsiidwRwA0v/eViN
qAsCZzH5IaL6REBO/lXdyzGRZHP8ig==
=CXAo
-----END PGP SIGNATURE-----

--MgdTOJabKUs9zLjX--
