Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7873F1FCC
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4Y+2KgP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698228842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mcgkz6oC5GwJhZbkmLRu3knSvzWo3/bl97oIvE5nm+w=;
	b=P4Y+2KgP3kO3nDAFye++EVTcx4YbJmftzMNwrOkm4nxDv6JS5vD5szQH4ovvDu2pFEBJpT
	UXffAz8zaiWj9gem7V+ymKBccVRHWNwoThGNc9771YRIHt6YPinjSk+eHkVKV1Bh0s+9dq
	ZksJTUb/Ydr2ks6plm6dRKNvP3dwKYY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-yeP_7W7vMtmWi9z_Xx9UWg-1; Wed, 25 Oct 2023 06:13:59 -0400
X-MC-Unique: yeP_7W7vMtmWi9z_Xx9UWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 984A1828B23;
	Wed, 25 Oct 2023 10:13:58 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CFF22026D4C;
	Wed, 25 Oct 2023 10:13:58 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 54DD330C051E; Wed, 25 Oct 2023 10:13:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 4D3E03D939;
	Wed, 25 Oct 2023 12:13:58 +0200 (CEST)
Date: Wed, 25 Oct 2023 12:13:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    Vlastimil Babka <vbabka@suse.cz>
cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <ZTiJ3CO8w0jauOzW@mail-itl>
Message-ID: <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
References: <ZTNH0qtmint/zLJZ@mail-itl> <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com> <ZTiHQDY54E7WAld+@mail-itl> <ZTiJ3CO8w0jauOzW@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-1011092206-1698228758=:2580838"
Content-ID: <72ee3997-934c-8652-bd1b-e8bd7113af5d@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1011092206-1698228758=:2580838
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <891b24a-d47e-4bc2-b921-96025231598@redhat.com>

So, I forward this to memory management maintainers.

What do you think? - We have a problem that if dm-crypt allocates pages 
with order > 3 (PAGE_ALLOC_COSTLY_ORDER), the system occasionally freezes 
waiting in writeback.

dm-crypt allocates the pages with GFP_NOWAIT | __GFP_HIGHMEM | 
__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP, so it 
shouldn't put any pressure on the system. If the allocations fails, it 
falls back to smaller order allocation or to mempool as a last resort.

When the freeze happens, there is "349264kB" free memory - so the system 
is not short on memory.

Should we restrict the dm-crypt allocation size to 
PAGE_ALLOC_COSTLY_ORDER? Or is it a bug somewhere in memory management 
system that needs to be fixes there?

Mikulas


On Wed, 25 Oct 2023, Marek Marczykowski-Górecki wrote:

> On Wed, Oct 25, 2023 at 05:10:56AM +0200, Marek Marczykowski-Górecki wrote:
> > On Mon, Oct 23, 2023 at 10:59:40PM +0200, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > It's hard to say what causes this. Perhaps dm-crypt exhausts all the 
> > > higher-order pages and some subsystem stalls because of it.
> > > 
> > > In drivers/md/dm-crypt.c in function crypt_alloc_buffer there is
> > > "unsigned int order = MAX_ORDER - 1"
> > > 
> > > What happens if you set the "order" variable to some small value, like 1, 
> > > 2 or 3. Does the problem go away? Could you find a threshold value 
> > > (something between 0 and MAX_ORDER-1) where the bug starts to appear?
> > 
> > With 3 and lower it seems to work, with 4 it freezes. My test is not
> > 100% reproducible, but I've repeated it a few times and got rather
> > consistent results on this system (i3-1315U, NVMe).
> > 
> > BTW, when trying on a much older system (Thinkpad P52 with i7-8750H) I
> > couldn't reproduce the issue at all. But OTOH, I hit it once on a system
> > with i7-7600U and otherwise similar specs but much different workload
> > (several more VMs accessing the data). I'm not sure if that info helps
> > at all...
> > 
> > > 
> > > What happens if you replace
> > > "pages = alloc_pages(gfp_mask"
> > > with
> > > "pages = alloc_pages((gfp_mask & ~__GFP_KSWAPD_RECLAIM)"
> > > ? Does the bug go away?
> > 
> > In a limited test, with order restored to MAX_ORDER - 1, no, still got
> > the issue, and got this via sysrq (just one task listed):
> > 
> > [  516.375254] sysrq: Show Blocked State
> > [  516.375461] task:dd              state:D stack:13072 pid:4385  ppid:4371   flags:0x00004002
> > [  516.375496] Call Trace:
> > [  516.375507]  <TASK>
> > [  516.375518]  __schedule+0x30e/0x8b0
> > [  516.375549]  schedule+0x59/0xb0
> > [  516.375566]  io_schedule+0x41/0x70
> > [  516.375582]  folio_wait_bit_common+0x12c/0x300
> > [  516.375603]  ? __pfx_wake_page_function+0x10/0x10
> > [  516.375623]  folio_wait_writeback+0x27/0x80
> > [  516.375639]  __filemap_fdatawait_range+0x7b/0xe0
> > [  516.375656]  file_write_and_wait_range+0x86/0xb0
> > [  516.375672]  blkdev_fsync+0x33/0x60
> > [  516.375693]  __x64_sys_fdatasync+0x4a/0x90
> > [  516.375713]  do_syscall_64+0x3c/0x90
> > [  516.375729]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > [  516.375751] RIP: 0033:0x7fd718562da4
> > [  516.375764] RSP: 002b:00007ffea3815278 EFLAGS: 00000202 ORIG_RAX: 000000000000004b
> > [  516.375784] RAX: ffffffffffffffda RBX: 0000000000015200 RCX: 00007fd718562da4
> > [  516.375801] RDX: 0000000000028000 RSI: 0000000000000000 RDI: 0000000000000001
> > [  516.375817] RBP: 00007fd71845e6c0 R08: 00000000ffffffff R09: 0000000000000000
> > [  516.375833] R10: 0000000000000022 R11: 0000000000000202 R12: 0000000000000000
> > [  516.375848] R13: 0000000000000000 R14: 0000000000028000 R15: 0000000000000000
> > [  516.375865]  </TASK>
> > 
> > (it is dd writing to LVM thin volume, where PV is on dm-crypt)
> 
> In this bad state, I extracted some more info on memory:
> 
> /proc/meminfo:
> 
> MemTotal:        3983088 kB
> MemFree:          349264 kB
> MemAvailable:    3474744 kB
> Buffers:         1511732 kB
> Cached:          1608132 kB
> SwapCached:           12 kB
> Active:           203136 kB
> Inactive:        3147696 kB
> Active(anon):       1288 kB
> Inactive(anon):   252128 kB
> Active(file):     201848 kB
> Inactive(file):  2895568 kB
> Unevictable:       46064 kB
> Mlocked:           39920 kB
> SwapTotal:       4112380 kB
> SwapFree:        4112124 kB
> Dirty:                 0 kB
> Writeback:          8556 kB
> AnonPages:        277020 kB
> Mapped:           137424 kB
> Shmem:             13792 kB
> KReclaimable:      91728 kB
> Slab:             182428 kB
> SReclaimable:      91728 kB
> SUnreclaim:        90700 kB
> KernelStack:        5776 kB
> PageTables:         7480 kB
> SecPageTables:         0 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     6103924 kB
> Committed_AS:     990924 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:       11560 kB
> VmallocChunk:          0 kB
> Percpu:             2528 kB
> DirectMap4k:     4325764 kB
> DirectMap2M:           0 kB
> 
> and also:
> [ 1168.537096] sysrq: Show Memory
> [ 1168.537192] Mem-Info:
> [ 1168.537206] active_anon:322 inactive_anon:63032 isolated_anon:0
> [ 1168.537206]  active_file:50462 inactive_file:723892 isolated_file:0
> [ 1168.537206]  unevictable:11516 dirty:1 writeback:2139
> [ 1168.537206]  slab_reclaimable:22932 slab_unreclaimable:22675
> [ 1168.537206]  mapped:34357 shmem:3448 pagetables:1870
> [ 1168.537206]  sec_pagetables:0 bounce:0
> [ 1168.537206]  kernel_misc_reclaimable:0
> [ 1168.537206]  free:87499 free_pcp:1642 free_cma:0
> [ 1168.537279] Node 0 active_anon:1288kB inactive_anon:252128kB active_file:201848kB inactive_file:2895568kB unevictable:46064kB isolated(anon):0kB isolated(file):0kB mapped:137428kB dirty:4kB writeback:8556kB shmem:13792kB writeback_tmp:0kB kernel_stack:5776kB pagetables:7480kB sec_pagetables:0kB all_unreclaimable? no
> [ 1168.537332] Node 0 DMA free:15488kB boost:0kB min:32kB low:44kB high:56kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:84kB inactive_file:352kB unevictable:0kB writepending:84kB present:15996kB managed:15936kB mlocked:0kB bounce:0kB free_pcp:12kB local_pcp:0kB free_cma:0kB
> [ 1168.537387] lowmem_reserve[]: 0 1728 3857 3857
> [ 1168.537409] Node 0 DMA32 free:155300kB boost:0kB min:3552kB low:5320kB high:7088kB reserved_highatomic:0KB active_anon:16kB inactive_anon:3368kB active_file:5660kB inactive_file:1585120kB unevictable:0kB writepending:7576kB present:1924360kB managed:1803376kB mlocked:0kB bounce:0kB free_pcp:3184kB local_pcp:864kB free_cma:0kB
> [ 1168.537464] lowmem_reserve[]: 0 0 2129 2129
> [ 1168.537483] Node 0 Normal free:179208kB boost:0kB min:4376kB low:6556kB high:8736kB reserved_highatomic:2048KB active_anon:1272kB inactive_anon:248760kB active_file:196104kB inactive_file:1310096kB unevictable:46064kB writepending:900kB present:2253948kB managed:2163776kB mlocked:39920kB bounce:0kB free_pcp:3372kB local_pcp:632kB free_cma:0kB
> [ 1168.537540] lowmem_reserve[]: 0 0 0 0
> [ 1168.537557] Node 0 DMA: 4*4kB (UM) 4*8kB (UM) 3*16kB (UM) 3*32kB (U) 3*64kB (U) 2*128kB (UM) 0*256kB 1*512kB (M) 2*1024kB (UM) 0*2048kB 3*4096kB (M) = 15488kB
> [ 1168.537624] Node 0 DMA32: 1945*4kB (UME) 1446*8kB (UME) 953*16kB (UME) 1410*32kB (UM) 297*64kB (UM) 162*128kB (UM) 60*256kB (UM) 22*512kB (UM) 7*1024kB (UM) 1*2048kB (U) 0*4096kB = 155300kB
> [ 1168.537695] Node 0 Normal: 3146*4kB (UMEH) 2412*8kB (UMEH) 1444*16kB (UMEH) 1138*32kB (UMEH) 486*64kB (UME) 97*128kB (UM) 13*256kB (UM) 8*512kB (M) 2*1024kB (M) 5*2048kB (M) 6*4096kB (UM) = 179208kB
> [ 1168.537767] 779973 total pagecache pages
> [ 1168.537778] 3 pages in swap cache
> [ 1168.537788] Free swap  = 4112124kB
> [ 1168.537798] Total swap = 4112380kB
> [ 1168.537807] 1048576 pages RAM
> [ 1168.537817] 0 pages HighMem/MovableOnly
> [ 1168.537827] 52804 pages reserved
> 
> 
> > 
> > > 
> > > Mikulas
> > > 
> > > 
> > > On Sat, 21 Oct 2023, Marek Marczykowski-Górecki wrote:
> > > 
> > > > Hi,
> > > > 
> > > > Since updating from 6.4.13 to 6.5.5 occasionally I hit a storage
> > > > subsystem freeze - any I/O ends up frozen. I'm not sure what exactly
> > > > triggers the issue, but often it happens when doing some LVM operations
> > > > (lvremove, lvrename etc) on a dm-thin volume together with bulk data
> > > > copy to/from another LVM thin volume with ext4 fs.
> > > > 
> > > > The storage stack I use is:
> > > >   nvme -> dm-crypt (LUKS) -> dm-thin (LVM thin pool) -> ext4
> > > > 
> > > > And this whole thing running in a (PV) dom0 under Xen, on Qubes OS 4.2 to be
> > > > specific.
> > > > 
> > > > I can reproduce the issue on at least 3 different machines. I did tried
> > > > also 6.5.6 and the issue is still there. I haven't checked newer
> > > > versions, but briefly reviewed git log and haven't found anything
> > > > suggesting a fix to similar issue.
> > > > 
> > > > I managed to bisect it down to this commit:
> > > > 
> > > >     commit 5054e778fcd9cd29ddaa8109077cd235527e4f94
> > > >     Author: Mikulas Patocka <mpatocka@redhat.com>
> > > >     Date:   Mon May 1 09:19:17 2023 -0400
> > > > 
> > > >     dm crypt: allocate compound pages if possible
> > > >     
> > > >     It was reported that allocating pages for the write buffer in dm-crypt
> > > >     causes measurable overhead [1].
> > > >     
> > > >     Change dm-crypt to allocate compound pages if they are available. If
> > > >     not, fall back to the mempool.
> > > >     
> > > >     [1] https://listman.redhat.com/archives/dm-devel/2023-February/053284.html
> > > >     
> > > >     Suggested-by: Matthew Wilcox <willy@infradead.org>
> > > >     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > >     Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > > > 
> > > > TBH, I'm not sure if the bug is in this commit, or maybe in some
> > > > functions it uses (I don't see dm-crypt functions directly involved in
> > > > the stack traces I collected). But reverting this commit on top of 6.5.6
> > > > seems to fix the issue.
> > > > 
> > > > I tried also CONFIG_PROVE_LOCKING, but it didn't show any issue.
> > > > 
> > > > I managed to collect "blocked tasks" dump via sysrq below. Few more can
> > > > be found at https://github.com/QubesOS/qubes-issues/issues/8575
> > > > 
> > > >     [ 4246.558313] sysrq: Show Blocked State
> > > >     [ 4246.558388] task:journal-offline state:D stack:0     pid:8098  ppid:1      flags:0x00000002
> > > >     [ 4246.558407] Call Trace:
> > > >     [ 4246.558414]  <TASK>
> > > >     [ 4246.558422]  __schedule+0x23d/0x670
> > > >     [ 4246.558440]  schedule+0x5e/0xd0
> > > >     [ 4246.558450]  io_schedule+0x46/0x70
> > > >     [ 4246.558461]  folio_wait_bit_common+0x13d/0x350
> > > >     [ 4246.558475]  ? __pfx_wake_page_function+0x10/0x10
> > > >     [ 4246.558488]  folio_wait_writeback+0x2c/0x90
> > > >     [ 4246.558498]  mpage_prepare_extent_to_map+0x15c/0x4d0
> > > >     [ 4246.558512]  ext4_do_writepages+0x25f/0x770
> > > >     [ 4246.558523]  ext4_writepages+0xad/0x180
> > > >     [ 4246.558533]  do_writepages+0xcf/0x1e0
> > > >     [ 4246.558543]  ? __seccomp_filter+0x32a/0x4f0
> > > >     [ 4246.558554]  filemap_fdatawrite_wbc+0x63/0x90
> > > >     [ 4246.558567]  __filemap_fdatawrite_range+0x5c/0x80
> > > >     [ 4246.558578]  file_write_and_wait_range+0x4a/0xb0
> > > >     [ 4246.558588]  ext4_sync_file+0x88/0x380
> > > >     [ 4246.558598]  __x64_sys_fsync+0x3b/0x70
> > > >     [ 4246.558609]  do_syscall_64+0x5c/0x90
> > > >     [ 4246.558621]  ? exit_to_user_mode_prepare+0xb2/0xd0
> > > >     [ 4246.558632]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > > >     [ 4246.558644] RIP: 0033:0x7710cf124d0a
> > > >     [ 4246.558654] RSP: 002b:00007710ccdfda40 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
> > > >     [ 4246.558668] RAX: ffffffffffffffda RBX: 000064bb92f67e60 RCX: 00007710cf124d0a
> > > >     [ 4246.558679] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000028
> > > >     [ 4246.558691] RBP: 000064bb92f72670 R08: 0000000000000000 R09: 00007710ccdfe6c0
> > > >     [ 4246.558702] R10: 00007710cf0adfee R11: 0000000000000293 R12: 000064bb92505940
> > > >     [ 4246.558713] R13: 0000000000000002 R14: 00007ffc05649500 R15: 00007710cc5fe000
> > > >     [ 4246.558728]  </TASK>
> > > >     [ 4246.558836] task:lvm             state:D stack:0     pid:7835  ppid:5665   flags:0x00004006
> > > >     [ 4246.558852] Call Trace:
> > > >     [ 4246.558857]  <TASK>
> > > >     [ 4246.558863]  __schedule+0x23d/0x670
> > > >     [ 4246.558874]  schedule+0x5e/0xd0
> > > >     [ 4246.558884]  io_schedule+0x46/0x70
> > > >     [ 4246.558894]  dm_wait_for_bios_completion+0xfc/0x110
> > > >     [ 4246.558909]  ? __pfx_autoremove_wake_function+0x10/0x10
> > > >     [ 4246.558922]  __dm_suspend+0x7e/0x1b0
> > > >     [ 4246.558932]  dm_internal_suspend_noflush+0x5c/0x80
> > > >     [ 4246.558946]  pool_presuspend+0xcc/0x130 [dm_thin_pool]
> > > >     [ 4246.558968]  dm_table_presuspend_targets+0x3f/0x60
> > > >     [ 4246.558980]  __dm_suspend+0x41/0x1b0
> > > >     [ 4246.558991]  dm_suspend+0xc0/0xe0
> > > >     [ 4246.559001]  dev_suspend+0xa5/0xd0
> > > >     [ 4246.559011]  ctl_ioctl+0x26e/0x350
> > > >     [ 4246.559020]  ? __pfx_dev_suspend+0x10/0x10
> > > >     [ 4246.559032]  dm_ctl_ioctl+0xe/0x20
> > > >     [ 4246.559041]  __x64_sys_ioctl+0x94/0xd0
> > > >     [ 4246.559052]  do_syscall_64+0x5c/0x90
> > > >     [ 4246.559062]  ? do_syscall_64+0x6b/0x90
> > > >     [ 4246.559072]  ? do_syscall_64+0x6b/0x90
> > > >     [ 4246.559081]  ? xen_pv_evtchn_do_upcall+0x54/0xb0
> > > >     [ 4246.559093]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > > >     [ 4246.559104] RIP: 0033:0x7f1cb77cfe0f
> > > >     [ 4246.559112] RSP: 002b:00007fff870f2560 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > >     [ 4246.559141] RAX: ffffffffffffffda RBX: 00005b8d13c16580 RCX: 00007f1cb77cfe0f
> > > >     [ 4246.559152] RDX: 00005b8d144a2180 RSI: 00000000c138fd06 RDI: 0000000000000003
> > > >     [ 4246.559164] RBP: 00005b8d144a2180 R08: 00005b8d132b1190 R09: 00007fff870f2420
> > > >     [ 4246.559175] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
> > > >     [ 4246.559186] R13: 00005b8d132aacf0 R14: 00005b8d1324414d R15: 00005b8d144a21b0
> > > >     [ 4246.559199]  </TASK>
> > > >     [ 4246.559207] task:kworker/u8:3    state:D stack:0     pid:8033  ppid:2      flags:0x00004000
> > > >     [ 4246.559222] Workqueue: writeback wb_workfn (flush-253:4)
> > > >     [ 4246.559238] Call Trace:
> > > >     [ 4246.559244]  <TASK>
> > > >     [ 4246.559249]  __schedule+0x23d/0x670
> > > >     [ 4246.559260]  schedule+0x5e/0xd0
> > > >     [ 4246.559270]  io_schedule+0x46/0x70
> > > >     [ 4246.559280]  folio_wait_bit_common+0x13d/0x350
> > > >     [ 4246.559290]  ? __pfx_wake_page_function+0x10/0x10
> > > >     [ 4246.559302]  mpage_prepare_extent_to_map+0x309/0x4d0
> > > >     [ 4246.559314]  ext4_do_writepages+0x25f/0x770
> > > >     [ 4246.559324]  ext4_writepages+0xad/0x180
> > > >     [ 4246.559334]  do_writepages+0xcf/0x1e0
> > > >     [ 4246.559344]  ? find_busiest_group+0x42/0x1a0
> > > >     [ 4246.559354]  __writeback_single_inode+0x3d/0x280
> > > >     [ 4246.559368]  writeback_sb_inodes+0x1ed/0x4a0
> > > >     [ 4246.559381]  __writeback_inodes_wb+0x4c/0xf0
> > > >     [ 4246.559393]  wb_writeback+0x298/0x310
> > > >     [ 4246.559403]  wb_do_writeback+0x230/0x2b0
> > > >     [ 4246.559414]  wb_workfn+0x5f/0x260
> > > >     [ 4246.559424]  ? _raw_spin_unlock+0xe/0x30
> > > >     [ 4246.559434]  ? finish_task_switch.isra.0+0x95/0x2b0
> > > >     [ 4246.559447]  ? __schedule+0x245/0x670
> > > >     [ 4246.559457]  process_one_work+0x1df/0x3e0
> > > >     [ 4246.559466]  worker_thread+0x51/0x390
> > > >     [ 4246.559475]  ? __pfx_worker_thread+0x10/0x10
> > > >     [ 4246.559484]  kthread+0xe5/0x120
> > > >     [ 4246.559495]  ? __pfx_kthread+0x10/0x10
> > > >     [ 4246.559504]  ret_from_fork+0x31/0x50
> > > >     [ 4246.559514]  ? __pfx_kthread+0x10/0x10
> > > >     [ 4246.559523]  ret_from_fork_asm+0x1b/0x30
> > > >     [ 4246.559536]  </TASK>
> > > > 
> > > > -- 
> > > > Best Regards,
> > > > Marek Marczykowski-Górecki
> > > > Invisible Things Lab
> > > > 
> > 
> > 
> > -- 
> > Best Regards,
> > Marek Marczykowski-Górecki
> > Invisible Things Lab
> 
> 
> 
> -- 
> Best Regards,
> Marek Marczykowski-Górecki
> Invisible Things Lab
> 
--185210117-1011092206-1698228758=:2580838--

