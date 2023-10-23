Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B39219EC
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDF4UbZb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698094783;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Dk12Ao0JK3ApywKV7eglJItO57LezrQU+CIsHyCGXmo=;
	b=eDF4UbZbT4MkoioUbTzd919d7aP03Co6u4UToq0LaiZNGYtsryx5vcTVoxKXqzkkGbSoL/
	OGIg4mp5yNSD3hymjdd2nfZCkEmSSylk3lzuM2ZMf1CraTiO1A5PgmqrLN+Ds8v3+iOC+i
	IovzT9AVUw4TXfkicaQvVv8BBlFa1fQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-zpb1iBVrMGK9ZT4Wcnlr6g-1; Mon,
 23 Oct 2023 16:59:42 -0400
X-MC-Unique: zpb1iBVrMGK9ZT4Wcnlr6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 523463810B1B
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 20:59:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B6721C060AE
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 20:59:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14B891946589
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 20:59:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7B8D1946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 Oct 2023 20:59:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 76AD5492BFD; Mon, 23 Oct 2023 20:59:40 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 610D7492BFB;
 Mon, 23 Oct 2023 20:59:40 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 3252830C0521; Mon, 23 Oct 2023 20:59:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 2DF233FB77; Mon, 23 Oct 2023 22:59:40 +0200 (CEST)
Date: Mon, 23 Oct 2023 22:59:40 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Marek_Marczykowski-G=F3recki?=
 <marmarek@invisiblethingslab.com>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
In-Reply-To: <ZTNH0qtmint/zLJZ@mail-itl>
Message-ID: <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com>
References: <ZTNH0qtmint/zLJZ@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, regressions@lists.linux.dev,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="185210117-2082018339-1698094780=:2210101"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-2082018339-1698094780=:2210101
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

Hi

It's hard to say what causes this. Perhaps dm-crypt exhausts all the 
higher-order pages and some subsystem stalls because of it.

In drivers/md/dm-crypt.c in function crypt_alloc_buffer there is
"unsigned int order = MAX_ORDER - 1"

What happens if you set the "order" variable to some small value, like 1, 
2 or 3. Does the problem go away? Could you find a threshold value 
(something between 0 and MAX_ORDER-1) where the bug starts to appear?

What happens if you replace
"pages = alloc_pages(gfp_mask"
with
"pages = alloc_pages((gfp_mask & ~__GFP_KSWAPD_RECLAIM)"
? Does the bug go away?

Mikulas


On Sat, 21 Oct 2023, Marek Marczykowski-Górecki wrote:

> Hi,
> 
> Since updating from 6.4.13 to 6.5.5 occasionally I hit a storage
> subsystem freeze - any I/O ends up frozen. I'm not sure what exactly
> triggers the issue, but often it happens when doing some LVM operations
> (lvremove, lvrename etc) on a dm-thin volume together with bulk data
> copy to/from another LVM thin volume with ext4 fs.
> 
> The storage stack I use is:
>   nvme -> dm-crypt (LUKS) -> dm-thin (LVM thin pool) -> ext4
> 
> And this whole thing running in a (PV) dom0 under Xen, on Qubes OS 4.2 to be
> specific.
> 
> I can reproduce the issue on at least 3 different machines. I did tried
> also 6.5.6 and the issue is still there. I haven't checked newer
> versions, but briefly reviewed git log and haven't found anything
> suggesting a fix to similar issue.
> 
> I managed to bisect it down to this commit:
> 
>     commit 5054e778fcd9cd29ddaa8109077cd235527e4f94
>     Author: Mikulas Patocka <mpatocka@redhat.com>
>     Date:   Mon May 1 09:19:17 2023 -0400
> 
>     dm crypt: allocate compound pages if possible
>     
>     It was reported that allocating pages for the write buffer in dm-crypt
>     causes measurable overhead [1].
>     
>     Change dm-crypt to allocate compound pages if they are available. If
>     not, fall back to the mempool.
>     
>     [1] https://listman.redhat.com/archives/dm-devel/2023-February/053284.html
>     
>     Suggested-by: Matthew Wilcox <willy@infradead.org>
>     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>     Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> 
> TBH, I'm not sure if the bug is in this commit, or maybe in some
> functions it uses (I don't see dm-crypt functions directly involved in
> the stack traces I collected). But reverting this commit on top of 6.5.6
> seems to fix the issue.
> 
> I tried also CONFIG_PROVE_LOCKING, but it didn't show any issue.
> 
> I managed to collect "blocked tasks" dump via sysrq below. Few more can
> be found at https://github.com/QubesOS/qubes-issues/issues/8575
> 
>     [ 4246.558313] sysrq: Show Blocked State
>     [ 4246.558388] task:journal-offline state:D stack:0     pid:8098  ppid:1      flags:0x00000002
>     [ 4246.558407] Call Trace:
>     [ 4246.558414]  <TASK>
>     [ 4246.558422]  __schedule+0x23d/0x670
>     [ 4246.558440]  schedule+0x5e/0xd0
>     [ 4246.558450]  io_schedule+0x46/0x70
>     [ 4246.558461]  folio_wait_bit_common+0x13d/0x350
>     [ 4246.558475]  ? __pfx_wake_page_function+0x10/0x10
>     [ 4246.558488]  folio_wait_writeback+0x2c/0x90
>     [ 4246.558498]  mpage_prepare_extent_to_map+0x15c/0x4d0
>     [ 4246.558512]  ext4_do_writepages+0x25f/0x770
>     [ 4246.558523]  ext4_writepages+0xad/0x180
>     [ 4246.558533]  do_writepages+0xcf/0x1e0
>     [ 4246.558543]  ? __seccomp_filter+0x32a/0x4f0
>     [ 4246.558554]  filemap_fdatawrite_wbc+0x63/0x90
>     [ 4246.558567]  __filemap_fdatawrite_range+0x5c/0x80
>     [ 4246.558578]  file_write_and_wait_range+0x4a/0xb0
>     [ 4246.558588]  ext4_sync_file+0x88/0x380
>     [ 4246.558598]  __x64_sys_fsync+0x3b/0x70
>     [ 4246.558609]  do_syscall_64+0x5c/0x90
>     [ 4246.558621]  ? exit_to_user_mode_prepare+0xb2/0xd0
>     [ 4246.558632]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>     [ 4246.558644] RIP: 0033:0x7710cf124d0a
>     [ 4246.558654] RSP: 002b:00007710ccdfda40 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
>     [ 4246.558668] RAX: ffffffffffffffda RBX: 000064bb92f67e60 RCX: 00007710cf124d0a
>     [ 4246.558679] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000028
>     [ 4246.558691] RBP: 000064bb92f72670 R08: 0000000000000000 R09: 00007710ccdfe6c0
>     [ 4246.558702] R10: 00007710cf0adfee R11: 0000000000000293 R12: 000064bb92505940
>     [ 4246.558713] R13: 0000000000000002 R14: 00007ffc05649500 R15: 00007710cc5fe000
>     [ 4246.558728]  </TASK>
>     [ 4246.558836] task:lvm             state:D stack:0     pid:7835  ppid:5665   flags:0x00004006
>     [ 4246.558852] Call Trace:
>     [ 4246.558857]  <TASK>
>     [ 4246.558863]  __schedule+0x23d/0x670
>     [ 4246.558874]  schedule+0x5e/0xd0
>     [ 4246.558884]  io_schedule+0x46/0x70
>     [ 4246.558894]  dm_wait_for_bios_completion+0xfc/0x110
>     [ 4246.558909]  ? __pfx_autoremove_wake_function+0x10/0x10
>     [ 4246.558922]  __dm_suspend+0x7e/0x1b0
>     [ 4246.558932]  dm_internal_suspend_noflush+0x5c/0x80
>     [ 4246.558946]  pool_presuspend+0xcc/0x130 [dm_thin_pool]
>     [ 4246.558968]  dm_table_presuspend_targets+0x3f/0x60
>     [ 4246.558980]  __dm_suspend+0x41/0x1b0
>     [ 4246.558991]  dm_suspend+0xc0/0xe0
>     [ 4246.559001]  dev_suspend+0xa5/0xd0
>     [ 4246.559011]  ctl_ioctl+0x26e/0x350
>     [ 4246.559020]  ? __pfx_dev_suspend+0x10/0x10
>     [ 4246.559032]  dm_ctl_ioctl+0xe/0x20
>     [ 4246.559041]  __x64_sys_ioctl+0x94/0xd0
>     [ 4246.559052]  do_syscall_64+0x5c/0x90
>     [ 4246.559062]  ? do_syscall_64+0x6b/0x90
>     [ 4246.559072]  ? do_syscall_64+0x6b/0x90
>     [ 4246.559081]  ? xen_pv_evtchn_do_upcall+0x54/0xb0
>     [ 4246.559093]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>     [ 4246.559104] RIP: 0033:0x7f1cb77cfe0f
>     [ 4246.559112] RSP: 002b:00007fff870f2560 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>     [ 4246.559141] RAX: ffffffffffffffda RBX: 00005b8d13c16580 RCX: 00007f1cb77cfe0f
>     [ 4246.559152] RDX: 00005b8d144a2180 RSI: 00000000c138fd06 RDI: 0000000000000003
>     [ 4246.559164] RBP: 00005b8d144a2180 R08: 00005b8d132b1190 R09: 00007fff870f2420
>     [ 4246.559175] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
>     [ 4246.559186] R13: 00005b8d132aacf0 R14: 00005b8d1324414d R15: 00005b8d144a21b0
>     [ 4246.559199]  </TASK>
>     [ 4246.559207] task:kworker/u8:3    state:D stack:0     pid:8033  ppid:2      flags:0x00004000
>     [ 4246.559222] Workqueue: writeback wb_workfn (flush-253:4)
>     [ 4246.559238] Call Trace:
>     [ 4246.559244]  <TASK>
>     [ 4246.559249]  __schedule+0x23d/0x670
>     [ 4246.559260]  schedule+0x5e/0xd0
>     [ 4246.559270]  io_schedule+0x46/0x70
>     [ 4246.559280]  folio_wait_bit_common+0x13d/0x350
>     [ 4246.559290]  ? __pfx_wake_page_function+0x10/0x10
>     [ 4246.559302]  mpage_prepare_extent_to_map+0x309/0x4d0
>     [ 4246.559314]  ext4_do_writepages+0x25f/0x770
>     [ 4246.559324]  ext4_writepages+0xad/0x180
>     [ 4246.559334]  do_writepages+0xcf/0x1e0
>     [ 4246.559344]  ? find_busiest_group+0x42/0x1a0
>     [ 4246.559354]  __writeback_single_inode+0x3d/0x280
>     [ 4246.559368]  writeback_sb_inodes+0x1ed/0x4a0
>     [ 4246.559381]  __writeback_inodes_wb+0x4c/0xf0
>     [ 4246.559393]  wb_writeback+0x298/0x310
>     [ 4246.559403]  wb_do_writeback+0x230/0x2b0
>     [ 4246.559414]  wb_workfn+0x5f/0x260
>     [ 4246.559424]  ? _raw_spin_unlock+0xe/0x30
>     [ 4246.559434]  ? finish_task_switch.isra.0+0x95/0x2b0
>     [ 4246.559447]  ? __schedule+0x245/0x670
>     [ 4246.559457]  process_one_work+0x1df/0x3e0
>     [ 4246.559466]  worker_thread+0x51/0x390
>     [ 4246.559475]  ? __pfx_worker_thread+0x10/0x10
>     [ 4246.559484]  kthread+0xe5/0x120
>     [ 4246.559495]  ? __pfx_kthread+0x10/0x10
>     [ 4246.559504]  ret_from_fork+0x31/0x50
>     [ 4246.559514]  ? __pfx_kthread+0x10/0x10
>     [ 4246.559523]  ret_from_fork_asm+0x1b/0x30
>     [ 4246.559536]  </TASK>
> 
> -- 
> Best Regards,
> Marek Marczykowski-Górecki
> Invisible Things Lab
> 
--185210117-2082018339-1698094780=:2210101--

