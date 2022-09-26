Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35798C07E9D
	for <dm-devel@archiver.kernel.org>; Mon, 26 Sep 2022 12:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664195147;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hlvMV3fHY2UOtLOdkjemqy1+kMu4gAeADgrj0F3SA0k=;
	b=QVOdWs0zQroY5zOyrmatEMTkl9UMqtzv+BOuXC9eJpZQU7Id/0gnuT8fcDtFk83Udej7r6
	53nycDhqpZRQ1DshodFwu0mGEZS/Y2NRPGDDVISrYzyacNwkBjc33XuQCT25AcmXB9t7L+
	pv18un6Miel8J9Rtblg210rvGXqIs48=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-8l1KeHZ4PAGlDOsFwb777w-1; Mon, 26 Sep 2022 08:25:43 -0400
X-MC-Unique: 8l1KeHZ4PAGlDOsFwb777w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8569D185A7A3;
	Mon, 26 Sep 2022 12:25:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED198140EBF4;
	Mon, 26 Sep 2022 12:25:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC0E9194658D;
	Mon, 26 Sep 2022 12:25:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD7FC1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Sep 2022 12:25:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8AE6917595; Mon, 26 Sep 2022 12:25:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82B6517583
 for <dm-devel@redhat.com>; Mon, 26 Sep 2022 12:25:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D187101A528
 for <dm-devel@redhat.com>; Mon, 26 Sep 2022 12:25:38 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-L5NUEfjvPVmvMXU5LRckiQ-1; Mon, 26 Sep 2022 08:25:36 -0400
X-MC-Unique: L5NUEfjvPVmvMXU5LRckiQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C7D32B80926;
 Mon, 26 Sep 2022 12:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61D3C433D6;
 Mon, 26 Sep 2022 12:19:38 +0000 (UTC)
Date: Mon, 26 Sep 2022 14:16:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YzGYFBv0pdt+DQg+@kroah.com>
References: <alpine.LRH.2.02.2209260418360.16612@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209260418360.16612@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] kernfs: fix a crash when two processes
 delete the same directory
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
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Christoph Lameter <cl@linux.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 26, 2022 at 07:04:52AM -0400, Mikulas Patocka wrote:
> There is a crash when running the cryptsetup testsuite on Fedora Rawhide.
> It can be reproduced by installing Rawhide with the 6.0-rc6 kernel,
> downloading and compiling the cryptsetup repository and running this test
> in a loop for about 15 minuts:
> 	while ./integrity-compat-test; do :; done
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 0 PID: 50087 at fs/kernfs/dir.c:504 __kernfs_remove.part.0+0x26f/0x2b0
>  Modules linked in: crc32_generic loop dm_integrity async_xor async_tx tls isofs uinput snd_seq_dummy snd_hrtimer nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables nfnetlink qrtr sunrpc snd_hda_codec_generic ledtrig_audio snd_hda_intel iTCO_wdt snd_intel_dspcfg intel_pmc_bxt snd_intel_sdw_acpi iTCO_vendor_support snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device joydev snd_pcm i2c_i801 snd_timer pcspkr i2c_smbus virtio_balloon snd lpc_ich soundcore zram virtio_net net_failover virtio_blk serio_raw failover qxl virtio_console drm_ttm_helper ttm ip6_tables ip_tables fuse qemu_fw_cfg
>  Unloaded tainted modules: crc32_pclmul():1 pcc_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 acpi_cpufreq():1
>  CPU: 0 PID: 50087 Comm: integritysetup Not tainted 6.0.0-0.rc6.41.fc38.x86_64 #1
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
>  RIP: 0010:__kernfs_remove.part.0+0x26f/0x2b0
>  Code: 0f 85 24 ff ff ff 4d 85 e4 0f 84 31 ff ff ff 41 0f b7 44 24 70 4c 89 e3 83 e0 0f 66 83 f8 01 0f 84 2c fe ff ff e9 50 fe ff ff <0f> 0b e9 53 fe ff ff 0f 0b e9 6b fe ff ff 48 8b 57 10 48 c7 c6 e8
>  RSP: 0018:ffffa2e001da7a78 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff8e509d111380 RCX: 0000000080200015
>  RDX: 0000000000000000 RSI: fffff015c5744440 RDI: ffff8e509d1113c8
>  RBP: ffffa2e001da7ac0 R08: 0000000000000000 R09: 0000000080200015
>  R10: 0000000000000009 R11: ffff8e514b185488 R12: ffff8e509d111380
>  R13: ffff8e5114324f98 R14: ffff8e50401e92a0 R15: 0000000000000000
>  FS:  00007fbbbdc13880(0000) GS:ffff8e53afa00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000055d1cdc94248 CR3: 0000000219990000 CR4: 00000000000006f0
>  Call Trace:
>   <TASK>
>   ? _raw_spin_unlock_irqrestore+0x23/0x40
>   ? kernfs_name_hash+0x12/0x80
>   kernfs_remove_by_name_ns+0x60/0xa0
>   sysfs_slab_add+0x166/0x200
>   __kmem_cache_create+0x3c9/0x4b0
>   kmem_cache_create_usercopy+0x202/0x340
>   kmem_cache_create+0x12/0x20
>   bioset_init+0x1fe/0x280
>   dm_table_complete+0x3cd/0x6f0
>   table_load+0x140/0x2c0
>   ? dev_suspend+0x2e0/0x2e0
>   ctl_ioctl+0x1f2/0x450
>   dm_ctl_ioctl+0xa/0x20
>   __x64_sys_ioctl+0x90/0xd0
>   do_syscall_64+0x5b/0x80
>   ? fpregs_restore_userregs+0x12/0xe0
>   ? exit_to_user_mode_prepare+0x18f/0x1f0
>   ? syscall_exit_to_user_mode+0x17/0x40
>   ? do_syscall_64+0x67/0x80
>   ? do_syscall_64+0x67/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  RIP: 0033:0x7fbbbdf27daf
>  Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
>  RSP: 002b:00007ffc3c305540 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>  RAX: ffffffffffffffda RBX: 0000000001f897e0 RCX: 00007fbbbdf27daf
>  RDX: 0000000001f8e000 RSI: 00000000c138fd09 RDI: 0000000000000006
>  RBP: 0000000000000003 R08: 0000000001f8b150 R09: 0000000000000073
>  R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbbbe57c6b6
>  R13: 00007fbbbe57c38c R14: 0000000001f8e030 R15: 00007fbbbe57c78c
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  ------------[ cut here ]------------
>  kernel BUG at mm/slub.c:381!
>  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>  CPU: 0 PID: 50087 Comm: integritysetup Tainted: G        W         -------  ---  6.0.0-0.rc6.41.fc38.x86_64 #1
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
>  RIP: 0010:__slab_free+0x11c/0x2f0
>  Code: 39 49 8b 04 24 48 89 4c 24 18 48 c1 e8 36 4c 8b ac c3 d8 00 00 00 4c 89 ef e8 90 a2 a3 00 48 8b 4c 24 18 48 89 44 24 20 eb 8e <0f> 0b f7 43 08 00 0d 21 00 75 cc 4d 85 ff 75 c7 80 4c 24 53 80 e9
>  RSP: 0018:ffffa2e001da7998 EFLAGS: 00010246
>  RAX: ffff8e5059948440 RBX: ffff8e5040042200 RCX: 0000000082000127
>  RDX: fffffffcab948440 RSI: fffff015c4665200 RDI: ffff8e5040042200
>  RBP: ffff8e5059948440 R08: 0000000000000001 R09: ffffffffae457f18
>  R10: 0000000000000009 R11: ffff8e514b185488 R12: fffff015c4665200
>  R13: ffff8e509d111398 R14: ffff8e5059948440 R15: ffff8e5059948440
>  FS:  00007fbbbdc13880(0000) GS:ffff8e53afa00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000055d1cdc94248 CR3: 0000000219990000 CR4: 00000000000006f0
>  Call Trace:
>   <TASK>
>   ? osq_unlock+0xf/0x90
>   ? rwsem_down_write_slowpath+0x1fc/0x710
>   kernfs_put.part.0+0x58/0x1a0
>   __kernfs_remove.part.0+0x17c/0x2b0
>   ? _raw_spin_unlock_irqrestore+0x23/0x40
>   ? kernfs_name_hash+0x12/0x80
>   kernfs_remove_by_name_ns+0x60/0xa0
>   sysfs_slab_add+0x166/0x200
>   __kmem_cache_create+0x3c9/0x4b0
>   kmem_cache_create_usercopy+0x202/0x340
>   kmem_cache_create+0x12/0x20
>   bioset_init+0x1fe/0x280
>   dm_table_complete+0x3cd/0x6f0
>   table_load+0x140/0x2c0
>   ? dev_suspend+0x2e0/0x2e0
>   ctl_ioctl+0x1f2/0x450
>   dm_ctl_ioctl+0xa/0x20
>   __x64_sys_ioctl+0x90/0xd0
>   do_syscall_64+0x5b/0x80
>   ? fpregs_restore_userregs+0x12/0xe0
>   ? exit_to_user_mode_prepare+0x18f/0x1f0
>   ? syscall_exit_to_user_mode+0x17/0x40
>   ? do_syscall_64+0x67/0x80
>   ? do_syscall_64+0x67/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  RIP: 0033:0x7fbbbdf27daf
>  Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
>  RSP: 002b:00007ffc3c305540 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>  RAX: ffffffffffffffda RBX: 0000000001f897e0 RCX: 00007fbbbdf27daf
>  RDX: 0000000001f8e000 RSI: 00000000c138fd09 RDI: 0000000000000006
>  RBP: 0000000000000003 R08: 0000000001f8b150 R09: 0000000000000073
>  R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbbbe57c6b6
>  R13: 00007fbbbe57c38c R14: 0000000001f8e030 R15: 00007fbbbe57c78c
>   </TASK>
>  Modules linked in: crc32_generic loop dm_integrity async_xor async_tx tls isofs uinput snd_seq_dummy snd_hrtimer nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables nfnetlink qrtr sunrpc snd_hda_codec_generic ledtrig_audio snd_hda_intel iTCO_wdt snd_intel_dspcfg intel_pmc_bxt snd_intel_sdw_acpi iTCO_vendor_support snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device joydev snd_pcm i2c_i801 snd_timer pcspkr i2c_smbus virtio_balloon snd lpc_ich soundcore zram virtio_net net_failover virtio_blk serio_raw failover qxl virtio_console drm_ttm_helper ttm ip6_tables ip_tables fuse qemu_fw_cfg
>  Unloaded tainted modules: crc32_pclmul():1 pcc_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 acpi_cpufreq():1
>  ---[ end trace 0000000000000000 ]---
>  RIP: 0010:__slab_free+0x11c/0x2f0
>  Code: 39 49 8b 04 24 48 89 4c 24 18 48 c1 e8 36 4c 8b ac c3 d8 00 00 00 4c 89 ef e8 90 a2 a3 00 48 8b 4c 24 18 48 89 44 24 20 eb 8e <0f> 0b f7 43 08 00 0d 21 00 75 cc 4d 85 ff 75 c7 80 4c 24 53 80 e9
>  RSP: 0018:ffffa2e001da7998 EFLAGS: 00010246
>  RAX: ffff8e5059948440 RBX: ffff8e5040042200 RCX: 0000000082000127
>  RDX: fffffffcab948440 RSI: fffff015c4665200 RDI: ffff8e5040042200
>  RBP: ffff8e5059948440 R08: 0000000000000001 R09: ffffffffae457f18
>  R10: 0000000000000009 R11: ffff8e514b185488 R12: fffff015c4665200
>  R13: ffff8e509d111398 R14: ffff8e5059948440 R15: ffff8e5059948440
>  FS:  00007fbbbdc13880(0000) GS:ffff8e53afa00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000055d1cdc94248 CR3: 0000000219990000 CR4: 00000000000006f0
> 
> The reason for the crash is this:
> 
> * create_bio_slab creates the bio slab with SLAB_TYPESAFE_BY_RCU - that
>   means that the slab destruction will be delayed by a rcu grace period
> 
> * when destroying a slab with SLAB_TYPESAFE_BY_RCU, the function
>   shutdown_cache adds the slab to a list and calls
>   slab_caches_to_rcu_destroy_workfn that will execute rcu_barrier() and
>   free slab caches that are on the list
> 
> * while slab_caches_to_rcu_destroy_workfn attempts to free the slab, the
>   function bioset_init creates another slab with the same name
> 
> * bioset_init goes down to sysfs_slab_add -> sysfs_remove_link ->
>   kernfs_remove_by_name -> kernfs_remove_by_name_ns
> 
> * simultaneously, slab_caches_to_rcu_destroy_workfn goes down to
>   kmem_cache_release which tries to unlink and release the slab kobject
> 
> * now, we have two processes that are simultaneously trying to delete the
>   same kobject
> 
> * kernfs_remove_by_name_ns wins the race, grabs the lock
>   &root->kernfs_rwsem and executes __kernfs_remove
> 
> * __kernfs_remove goes down to pos = kernfs_leftmost_descendant(kn), then
>   it calls kernfs_get(pos) and kernfs_drain(pos)
> 
> * kernfs_drain(pos) drops the &root->kernfs_rwsem lock temporarily
> 
> * while the lock is dropped, kmem_cache_release calls sysfs_slab_unlink
>   -> kobject_del -> __kobject_del -> sysfs_remove_dir -> kernfs_remove ->
>   __kernfs_remove
> 
> * kmem_cache_release calls sysfs_slab_release -> kobject_put -> kref_put
>   -> kobject_release -> kobject_cleanup - this frees the kobject
> 
> * then we go back to the process that dropped the lock &root->kernfs_rwsem
>   in kernfs_drain(pos) - the process re-acquires the lock and returns to
>   __kernfs_remove. The process still keeps reference to the "pos" kobject,
>   however it no longer keeps reference to the "kn" kobject (which was
>   freed in the step above). It executes kernfs_put(pos) and then continues
>   the loop with "kn" pointing to free memory
> 
> * kernfs_leftmost_descendant(kn) return "kn" because there are no files
>   under "kn". kernfs_get(pos) triggers a warning
>   WARN_ON(!atomic_read(&kn->count)). kernfs_put(pos) triggers a BUG in
>   set_freepointer because it attempts to free an object that is already
>   free
> 
> We fix this bug by grabbing a reference to "kn" in __kernfs_remove and
> dropping it when we are done. This prevents "kn" from being released when
> we drop the lock in kernfs_drain.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Milan Broz <gmazyland@gmail.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  fs/kernfs/dir.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/fs/kernfs/dir.c
> ===================================================================
> --- linux-2.6.orig/fs/kernfs/dir.c
> +++ linux-2.6/fs/kernfs/dir.c
> @@ -1364,6 +1364,12 @@ static void __kernfs_remove(struct kernf
>  		if (kernfs_active(pos))
>  			atomic_add(KN_DEACTIVATED_BIAS, &pos->active);
>  
> +	/*
> +	 * Make sure that kn won't go away while we drop the lock in
> +	 * kernfs_drain().
> +	 */
> +	kernfs_get(kn);
> +
>  	/* deactivate and unlink the subtree node-by-node */
>  	do {
>  		pos = kernfs_leftmost_descendant(kn);
> @@ -1406,6 +1412,8 @@ static void __kernfs_remove(struct kernf
>  
>  		kernfs_put(pos);
>  	} while (pos != kn);
> +
> +	kernfs_put(kn);
>  }
>  
>  /**
> 

Can you see if 4abc99652812 ("kernfs: fix use-after-free in
__kernfs_remove") in linux-next fixes this for you or not?  It seems to
be the same issue, as was also reported at:
	https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

