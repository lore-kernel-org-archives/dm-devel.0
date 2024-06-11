Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B8D170842
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 05:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085287; cv=none; b=UBnYO3Bo5+CHXhqFab4/Se6SomC9qv/cW7Wa/zkb/A6+jrGFsaQCeWk4Xn2IUHJ+4ShegZQi+gaScTMErGTJZmsuaM2RGb0qjaJkx8vZ/5xZ/MvoHvXxNxphkJBWWIhUjLcCJFEj9sjxc5+IKFgz6FdU0eHHEgCrN7RDqjxjnC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085287; c=relaxed/simple;
	bh=e9ybIl9VXH/6bsUnk/AGk+UWlAZ9JY61+2+zey2aIOA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NBBrZtJuzz98Hr0IE8MsyoJUd33FZKjXUa5uGqEcEXuNaidL+EDuqDSd2GNCLq2XxZI8ppvumLIv68pnp0RpLgNsfy/Dxo5uIQbXSWo9FZ9LPZxmqbjuJeipbc3gwU6KRxNLYw5xLvKhziMerBvL3bx1R/feTSdjLlsTICA6fHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HlJp1BgW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlJp1BgW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718085284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aKlwBqTrblHFUCM4XIPMCaey107mcnx66H9NJn1ZieY=;
	b=HlJp1BgWX5Ib0g5kkruytjdbm2sTJVJrX0QzUfuQX0aM0lQXkCELKX3f5ptt8LZGBfm9b8
	93PEgaP6No3fAPgbLFq4MOsXRti2ZMqyU+86D+wxs0BFgjxx1wtjwHqJ3AhAe/Fpl4jUlw
	ivjfU0cWnzqydEyfp/dXEDsrhnDw874=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-28BDohnOMhGFPuBVKO5P6Q-1; Tue,
 11 Jun 2024 01:54:42 -0400
X-MC-Unique: 28BDohnOMhGFPuBVKO5P6Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CA601956094;
	Tue, 11 Jun 2024 05:54:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 954681956048;
	Tue, 11 Jun 2024 05:54:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45B5sdZZ822425
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 01:54:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45B5scs4822424;
	Tue, 11 Jun 2024 01:54:38 -0400
Date: Tue, 11 Jun 2024 01:54:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: dm-devel@lists.linux.dev
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Yu Kuai <yukuai3@huawei.com>
Subject: kernel WARNING on lvm2 testsuite due to MD recovery running
Message-ID: <ZmfmnReWfZxlezzD@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Running the lvm2 testsuite test lvconvert-raid-takeover.sh will
frequently triggers the following kernel WARNING at
drivers/md/dm-raid.c:4105:

WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));

(obviously since this is a WARN_ON_ONCE, you need to run
# echo 1 > /sys/kernel/debug/clear_warn_once
to see it multiple times per boot).

This issue started during the dmraid-fix-6.9 patchset, although before
that, this test was frequently hanging instead.

Here are the kernel messages around the WARNING:

--------------------------------------------

[ 3501.753486] device-mapper: raid: Device 0 specified for rebuild;
clearing sup
erblock
[ 3501.754571] device-mapper: raid: Superblocks created for new raid set
[ 3501.765179] md/raid:mdX: not clean -- starting background
reconstruction
[ 3501.765726] md/raid:mdX: device dm-13 operational as raid disk 1
[ 3501.766190] md/raid:mdX: device dm-15 operational as raid disk 2
[ 3501.766683] md/raid:mdX: device dm-17 operational as raid disk 3
[ 3501.767513] md/raid:mdX: raid level 5 active with 3 out of 4 devices,
algorit
hm 4
[ 3501.768105] device-mapper: raid: raid456 discard support disabled due
to disc
ard_zeroes_data uncertainty.
[ 3501.768866] device-mapper: raid: Set
dm-raid.devices_handle_discard_safely=Y
to override.
[ 3501.784007] mdX: bitmap file is out of date, doing full recovery
[ 3501.793924] md: recovery of RAID array mdX
[ 3501.799962] md/raid:mdX: not clean -- starting background
reconstruction
[ 3501.800524] md/raid:mdX: device dm-13 operational as raid disk 1
[ 3501.801008] md/raid:mdX: device dm-15 operational as raid disk 2
[ 3501.801479] md/raid:mdX: device dm-17 operational as raid disk 3
[ 3501.801800] md: mdX: recovery done.
[ 3501.802264] md/raid:mdX: raid level 5 active with 3 out of 4 devices,
algorithm 4
[ 3501.803087] device-mapper: raid: raid456 discard support disabled due
to discard_zeroes_data uncertainty.
[ 3501.803979] device-mapper: raid: Set
dm-raid.devices_handle_discard_safely=Y to override.
[ 3501.816712] md: resync of RAID array mdX
[ 3501.817265] md: mdX: resync interrupted.
[ 3501.888714] ------------[ cut here ]------------
RNING: CPU: 0 PID: 4049 at drivers/md/dm-raid.c:4105
raid_resume+0xee/0x100 [dm_raid]
[ 3501.893749] Modules linked in: raid1 raid0 brd dm_raid raid456
async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq
nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set rfkill nf_tables
nfnetlink intel_rapl_msr intel_rapl_common intel_uncore_frequency_common
kvm_intel kvm iTCO_wdt iTCO_vendor_support rapl virtio_balloon i2c_i801
pcspkr i2c_smbus lpc_ich joydev drm fuse xfs libcrc32c ahci libahci
crct10dif_pclmul virtio_net crc32_pclmul net_failover libata
crc32c_intel failover ghash_clmulni_intel dimlib virtio_blk
virtio_console serio_raw dm_mirror dm_region_hash dm_log dm_mod
[ 3501.903305] CPU: 0 PID: 4049 Comm: lvm Kdump: loaded Not tainted
6.10.0-rc2 #1
[ 3501.904012] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-1.fc39 04/01/2014
[ 3501.904756] RIP: 0010:raid_resume+0xee/0x100 [dm_raid]
[ 3501.905185] Code: 48 85 69 ff 48 8b b3 80 01 00 00 48 89 c7 e8 a9 aa
e9 ce 48 8b 83 40 02 00 00 f6 c4 02 0f 85 58 ff ff ff 0f 0b e9 51 ff ff
ff <0f> 0b e9 59 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
[ 3501.906717] RSP: 0018:ff7151910117fc98 EFLAGS: 00010202
[ 3501.907181] RAX: 0000000000000209 RBX: ff2420d341bd8000 RCX:
ff7151910117fb60
[ 3501.907800] RDX: 0000000000010000 RSI: 0000000000000000 RDI:
ff2420d34a468840
[ 3501.908520] RBP: ff2420d341bd8058 R08: 0000000000000000 R09:
ffffffff8fdbcdad
[ 3501.909227] R10: ff2420d34e5dfa00 R11: 0000000000000200 R12:
0000000000000000
[ 3501.909958] R13: ff2420d35550ec00 R14: ff2420d3f08b9600 R15:
0000000000004800
[ 3501.910612] FS:  00007f1bdc778740(0000) GS:ff2420d4b7800000(0000)
knlGS:0000000000000000
[ 3501.911340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3501.911876] CR2: 000055c2cf0bbcf0 CR3: 000000011545a003 CR4:
0000000000771ef0
[ 3501.912451] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 3501.913054] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 3501.913661] PKRU: 55555554
[ 3501.913906] Call Trace:
[ 3501.914166]  <TASK>
[ 3501.914381]  ? __warn+0x7f/0x120
[ 3501.914735]  ? raid_resume+0xee/0x100 [dm_raid]
[ 3501.915183]  ? report_bug+0x18a/0x1a0
[ 3501.915549]  ? handle_bug+0x3c/0x70
[ 3501.915887]  ? exc_invalid_op+0x14/0x70
[ 3501.916280]  ? asm_exc_invalid_op+0x16/0x20
[ 3501.916710]  ? super_written+0x2d/0x100
[ 3501.917111]  ? raid_resume+0xee/0x100 [dm_raid]
[ 3501.917560]  dm_table_resume_targets+0x80/0xe0 [dm_mod]
[ 3501.918081]  __dm_resume+0x16/0x70 [dm_mod]
[ 3501.918466]  dm_resume+0xab/0xc0 [dm_mod]
[ 3501.918867]  do_resume+0x15d/0x270 [dm_mod]
[ 3501.919288]  ctl_ioctl+0x203/0x350 [dm_mod]
[ 3501.919753]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
[ 3501.920155]  __x64_sys_ioctl+0x8a/0xc0
[ 3501.920539]  do_syscall_64+0x79/0x150
[ 3501.920909]  ? clear_bhb_loop+0x25/0x80
[ 3501.921304]  ? clear_bhb_loop+0x25/0x80
[ 3501.921669]  ? clear_bhb_loop+0x25/0x80
[ 3501.922057]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 3501.922533] RIP: 0033:0x7f1bdc50357b
[ 3501.922933] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c
89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 68 0f 00 f7 d8 64 89 01 48
[ 3501.924716] RSP: 002b:00007fffe2d93e88 EFLAGS: 00000206 ORIG_RAX:
0000000000000010
[ 3501.925390] RAX: ffffffffffffffda RBX: 000055c2a50c7660 RCX:
00007f1bdc50357b
[ 3501.926017] RDX: 000055c2ce6b9c90 RSI: 00000000c138fd06 RDI:
0000000000000004
[ 3501.926595] RBP: 000055c2a51751ba R08: 0000000000000000 R09:
00000000000f4240
[ 3501.927164] R10: 0000000000000001 R11: 0000000000000206 R12:
000055c2ce6b9d40
[ 3501.927772] R13: 000055c2a51751ba R14: 000055c2ce6b9c90 R15:
000055c2ce6c7720
[ 3501.928478]  </TASK>
[ 3501.928728] ---[ end trace 0000000000000000 ]---
[ 3501.941257] md: recovery of RAID array mdX
[ 3501.946534] md: mdX: recovery interrupted.
[ 3502.004627] md: recovery of RAID array mdX
[ 3502.013666] md: mdX: recovery done.

-----------------------------------------

It appears that the issue is that when a dm-raid device table is first
loaded, raid_ctr() can set MD_RECOVERY_RUNNING through the following
call chain

md_run -> raidX_run -> setup_conf -> raidXd -> md_check_recovery

In md_check_recovery(), MD_RECOVERY_RUNNING can be set here, even though
MD_RECOVERY_FROZEN is already set:

                        /*
                         * Let md_start_sync() to remove and add rdevs
                         * to the
                         * array.
                         */
                        if (md_spares_need_change(mddev)) {
                                set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
                                queue_work(md_misc_wq, &mddev->sync_work);
                        }

To verify that this is the cause of the problem, the following naive
patch stops the kernel WARNINGS:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..9cb4b400318f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9629,7 +9629,8 @@ void md_check_recovery(struct mddev *mddev)
                         * Let md_start_sync() to remove and add rdevs
                         * to the
                         * array.
                         */
-                       if (md_spares_need_change(mddev)) {
+                       if (md_spares_need_change(mddev) &&
+                           !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
                                set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
                                queue_work(md_misc_wq, &mddev->sync_work);
                        }

Is this the correct way to fix this?

-Ben

