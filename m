Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1353BC43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 12:03:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-NbFZe3umNsa76GJCk0OY7Q-1; Thu, 09 Jun 2022 08:03:09 -0400
X-MC-Unique: NbFZe3umNsa76GJCk0OY7Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEB588027EE;
	Thu,  9 Jun 2022 12:03:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3710492C3B;
	Thu,  9 Jun 2022 12:03:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6ACAE194704D;
	Thu,  9 Jun 2022 12:03:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F3EBB1947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 12:03:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D13C118EA3; Thu,  9 Jun 2022 12:03:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC66518EA9
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 12:03:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD2838027EE
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 12:03:03 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-J6DfB4GdPE-Qz1nZBxR_bA-1; Thu, 09 Jun 2022 08:03:01 -0400
X-MC-Unique: J6DfB4GdPE-Qz1nZBxR_bA-1
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; d="scan'208";a="207547965"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 20:02:58 +0800
IronPort-SDR: G7aW6NBlhEgfK9q67pRwjy6PzMwl7coxIB/eqoktk9YEMKOMPs9TM4kDw0lTfNaLIkBY9X6RY1
 ygOJ9wucQatPVTuEtYAfMisQAIKboRAhpfcTokKt6hQNiDXkTiskpUnEdWXjGxomjvJFXtYmXp
 OEFeTiYdeoymrV9GTPcAAswkYN5qDhOAEdPDZTyfkJyT5f4PKAkqsGp+YOqp5VX8usq/13YIdY
 SJgyTIAxmA0UVppe34kVd1a8yrF/KoYX+lNOC6MNbFXGNhKzGmjd/C/vkmDomNsQTl7Qhef8hp
 o+JoE6zNlUdnUox5FbjUxkqt
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 09 Jun 2022 04:26:11 -0700
IronPort-SDR: aqJg12EBQ/vPZa3il/AjvIVCcI1/DNDxJVGj6ifIVosVxbvaNjQ+rmpgyZ+lSjl6y/zCdFMHYG
 Cv4jkNN2EGGPVh8CwlTMu/gNI+5LY0zjn8AWRAZV/nVmy7oybyAc/3UsknmSU5XokvaSX3zLUD
 pzBJVdA8AY6HDxGjHIzi7jyXOG60LiDNLLT43DttduFbGBFfgALh8V6TM0j2vebhIqWJqMZw1v
 lXlYXH1Yi6c0czcEFhJH3LBxAn/G+OCKcM4ViTpoQ0RGqgZh2b3I5WAEdVrsGk/sOmxx3r+2bR
 Jww=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 09 Jun 2022 05:02:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJjQp2rw2z1Rwrw
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 05:02:58 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 2qXTcAg7mMsD for <dm-devel@redhat.com>;
 Thu,  9 Jun 2022 05:02:57 -0700 (PDT)
Received: from [10.225.163.72] (unknown [10.225.163.72])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJjQn15FTz1Rvlc;
 Thu,  9 Jun 2022 05:02:57 -0700 (PDT)
Message-ID: <1780acef-0974-3ad0-8aed-f7d37d31d5d0@opensource.wdc.com>
Date: Thu, 9 Jun 2022 21:02:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
References: <20220609114300.453650-1-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220609114300.453650-1-shinichiro.kawasaki@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] dm crypt: set bdev to clone bio
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/9/22 20:43, Shin'ichiro Kawasaki wrote:
> After the commit ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone"),
> bdev is no longer set to clone bio for ->map function. Instead, each DM
> targets shall set bdev to the clone bio by calling bio_set_dev() before
> issuing IO. Also the commit ensured that dm_zone_endio() is called from
> clone_endio() only when DM targets set bdev to the clone bio.
> 
> However, crypt_map() of dm-crypt does not call bio_set_dev() for every
> clone bio. Then dm_zone_endio() is not called at completion of the bios
> and zone locks are not properly unlocked. This triggers a hang when
> blktests block/004 is run for dm-crypt on zoned block devices [1]. To
> avoid the hang, call bio_set_dev() for every bio in crypt_map().
> 
> [1]
> 
> [ 6596.702977][T55017] run blktests block/004 at 2022-06-07 20:18:01
> [ 6805.654531][   T41] INFO: task fio:55089 blocked for more than 122 seconds.
> [ 6805.664287][   T41]       Not tainted 5.19.0-rc1+ #1
> [ 6805.671040][   T41] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 6805.682059][   T41] task:fio             state:D stack:    0 pid:55089 ppid: 55042 flags:0x00000002
> [ 6805.693538][   T41] Call Trace:
> [ 6805.697563][   T41]  <TASK>
> [ 6805.700855][   T41]  __schedule+0xd5d/0x4b70
> [ 6805.701035][   T41]  ? lock_is_held_type+0xe3/0x140
> [ 6805.701094][   T41]  ? lock_release+0x365/0x730
> [ 6805.701153][   T41]  ? io_schedule_timeout+0x150/0x150
> [ 6805.701182][   T41]  ? blk_start_plug_nr_ios+0x270/0x270
> [ 6805.701208][   T41]  schedule+0xe0/0x200
> [ 6805.701225][   T41]  io_schedule+0xbf/0x130
> [ 6805.701238][   T41]  bit_wait_io+0x17/0xe0
> [ 6805.701251][   T41]  __wait_on_bit_lock+0x11e/0x1b0
> [ 6805.701266][   T41]  ? out_of_line_wait_on_bit_lock+0xe0/0xe0
> [ 6805.701289][   T41]  out_of_line_wait_on_bit_lock+0xc6/0xe0
> [ 6805.701302][   T41]  ? __wait_on_bit_lock+0x1b0/0x1b0
> [ 6805.701311][   T41]  ? lock_is_held_type+0xe3/0x140
> [ 6805.701330][   T41]  ? cpuacct_css_alloc+0x150/0x150
> [ 6805.701355][   T41]  dm_zone_map_bio+0x4e3/0x15d0
> [ 6805.701423][   T41]  ? dm_set_zones_restrictions+0x930/0x930
> [ 6805.701443][   T41]  ? bvec_alloc+0x1a0/0x1a0
> [ 6805.701457][   T41]  ? lockdep_init_map_type+0x169/0x7a0
> [ 6805.701478][   T41]  __map_bio+0x4bc/0x6f0
> [ 6805.701500][   T41]  dm_submit_bio+0x635/0x1440
> [ 6805.701531][   T41]  ? dm_dax_direct_access+0x1c0/0x1c0
> [ 6805.701542][   T41]  ? lock_release+0x365/0x730
> [ 6805.701559][   T41]  ? reacquire_held_locks+0x4e0/0x4e0
> [ 6805.701609][   T41]  __submit_bio+0x1c0/0x2c0
> [ 6805.701638][   T41]  ? __bio_queue_enter+0x5b0/0x5b0
> [ 6805.701683][   T41]  ? lockdep_hardirqs_on_prepare+0x17b/0x410
> [ 6805.701703][   T41]  submit_bio_noacct_nocheck+0x2f8/0x810
> [ 6805.701727][   T41]  ? should_fail_request+0x70/0x70
> [ 6805.701737][   T41]  ? submit_bio_noacct+0x1079/0x1650
> [ 6805.701776][   T41]  submit_bio+0x92/0x250
> [ 6805.701829][   T41]  ? submit_bio_noacct+0x1650/0x1650
> [ 6805.701860][   T41]  submit_bio_wait+0xf2/0x1d0
> [ 6805.701873][   T41]  ? submit_bio_wait_endio+0x40/0x40
> [ 6805.701963][   T41]  ? bio_init+0x365/0x5e0
> [ 6805.701985][   T41]  __blkdev_direct_IO_simple+0x326/0x550
> [ 6805.702010][   T41]  ? blkdev_llseek+0xd0/0xd0
> [ 6805.702019][   T41]  ? truncate_folio_batch_exceptionals.part.0+0x540/0x540
> [ 6805.702044][   T41]  ? lock_is_held_type+0xe3/0x140
> [ 6805.702058][   T41]  ? find_held_lock+0x2d/0x110
> [ 6805.702087][   T41]  ? __bio_clone+0x350/0x350
> [ 6805.702124][   T41]  ? generic_update_time+0x195/0x2b0
> [ 6805.702156][   T41]  generic_file_direct_write+0x1a9/0x490
> [ 6805.702193][   T41]  __generic_file_write_iter+0x161/0x430
> [ 6805.702221][   T41]  blkdev_write_iter+0x32c/0x5a0
> [ 6805.702242][   T41]  ? blkdev_open+0x240/0x240
> [ 6805.702266][   T41]  ? do_fault+0x4bd/0xed0
> [ 6805.702278][   T41]  ? restore_exclusive_pte+0x3b0/0x3b0
> [ 6805.702303][   T41]  new_sync_write+0x2cd/0x500
> [ 6805.702320][   T41]  ? new_sync_read+0x500/0x500
> [ 6805.702355][   T41]  ? inode_security+0x54/0xf0
> [ 6805.702400][   T41]  vfs_write+0x62c/0x980
> [ 6805.702425][   T41]  __x64_sys_pwrite64+0x17a/0x1c0
> [ 6805.702439][   T41]  ? vfs_write+0x980/0x980
> [ 6805.702453][   T41]  ? syscall_enter_from_user_mode+0x20/0x70
> [ 6805.702477][   T41]  do_syscall_64+0x3a/0x80
> [ 6805.702493][   T41]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [ 6805.702507][   T41] RIP: 0033:0x7fdec0affc6f
> [ 6805.702538][   T41] RSP: 002b:00007ffd9c193620 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
> [ 6805.702554][   T41] RAX: ffffffffffffffda RBX: 0000000001170540 RCX: 00007fdec0affc6f
> [ 6805.702562][   T41] RDX: 0000000000001000 RSI: 00000000011de000 RDI: 0000000000000007
> [ 6805.702569][   T41] RBP: 00007fdea150a6c8 R08: 0000000000000000 R09: 0000000000000001
> [ 6805.702576][   T41] R10: 0000000000c00000 R11: 0000000000000293 R12: 0000000000000001
> [ 6805.702583][   T41] R13: 0000000000000000 R14: 0000000000001000 R15: 00007fdea150a6c8
> [ 6805.702634][   T41]  </TASK>
> [ 6805.702643][   T41] INFO: task fio:55091 blocked for more than 122 seconds.
> [ 6805.702651][   T41]       Not tainted 5.19.0-rc1+ #1
> [ 6805.702657][   T41] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 6805.702663][   T41] task:fio             state:D stack:    0 pid:55091 ppid: 55042 flags:0x00000002
> [ 6805.702679][   T41] Call Trace:
> [ 6805.702685][   T41]  <TASK>
> [ 6805.702703][   T41]  __schedule+0xd5d/0x4b70
> [ 6805.702719][   T41]  ? lock_is_held_type+0xe3/0x140
> [ 6805.702747][   T41]  ? lock_release+0x365/0x730
> [ 6805.702777][   T41]  ? io_schedule_timeout+0x150/0x150
> [ 6805.702829][   T41]  ? blk_start_plug_nr_ios+0x270/0x270
> [ 6805.702853][   T41]  schedule+0xe0/0x200
> [ 6805.702870][   T41]  io_schedule+0xbf/0x130
> [ 6805.702925][   T41]  bit_wait_io+0x17/0xe0
> [ 6805.702939][   T41]  __wait_on_bit_lock+0x11e/0x1b0
> [ 6805.702954][   T41]  ? out_of_line_wait_on_bit_lock+0xe0/0xe0
> [ 6805.702977][   T41]  out_of_line_wait_on_bit_lock+0xc6/0xe0
> [ 6805.702990][   T41]  ? __wait_on_bit_lock+0x1b0/0x1b0
> [ 6805.702998][   T41]  ? lock_is_held_type+0xe3/0x140
> [ 6805.703018][   T41]  ? cpuacct_css_alloc+0x150/0x150
> [ 6805.703042][   T41]  dm_zone_map_bio+0x4e3/0x15d0
> [ 6805.703082][   T41]  ? dm_set_zones_restrictions+0x930/0x930
> [ 6805.703101][   T41]  ? bvec_alloc+0x1a0/0x1a0
> [ 6805.703114][   T41]  ? lockdep_init_map_type+0x169/0x7a0
> [ 6805.703136][   T41]  __map_bio+0x4bc/0x6f0
> [ 6805.703158][   T41]  dm_submit_bio+0x635/0x1440
> [ 6805.703188][   T41]  ? dm_dax_direct_access+0x1c0/0x1c0
> [ 6805.703199][   T41]  ? lock_release+0x365/0x730
> [ 6805.703216][   T41]  ? reacquire_held_locks+0x4e0/0x4e0
> [ 6805.703267][   T41]  __submit_bio+0x1c0/0x2c0
> [ 6805.703281][   T41]  ? __bio_queue_enter+0x5b0/0x5b0
> [ 6805.703300][   T41]  ? lockdep_hardirqs_on_prepare+0x17b/0x410
> [ 6805.703320][   T41]  submit_bio_noacct_nocheck+0x2f8/0x810
> [ 6805.703343][   T41]  ? should_fail_request+0x70/0x70
> [ 6805.703353][   T41]  ? submit_bio_noacct+0x1079/0x1650
> [ 6805.703392][   T41]  submit_bio+0x92/0x250
> [ 6805.703407][   T41]  ? submit_bio_noacct+0x1650/0x1650
> [ 6805.703438][   T41]  submit_bio_wait+0xf2/0x1d0
> [ 6805.703451][   T41]  ? submit_bio_wait_endio+0x40/0x40
> [ 6805.703488][   T41]  ? bio_init+0x365/0x5e0
> [ 6805.703509][   T41]  __blkdev_direct_IO_simple+0x326/0x550
> [ 6805.703534][   T41]  ? blkdev_llseek+0xd0/0xd0
> [ 6805.703542][   T41]  ? truncate_folio_batch_exceptionals.part.0+0x540/0x540
> [ 6805.703566][   T41]  ? lock_is_held_type+0xe3/0x140
> [ 6805.703579][   T41]  ? find_held_lock+0x2d/0x110
> [ 6805.703608][   T41]  ? __bio_clone+0x350/0x350
> [ 6805.703645][   T41]  ? generic_update_time+0x195/0x2b0
> [ 6805.703675][   T41]  generic_file_direct_write+0x1a9/0x490
> [ 6805.703711][   T41]  __generic_file_write_iter+0x161/0x430
> [ 6805.703738][   T41]  blkdev_write_iter+0x32c/0x5a0
> [ 6805.703759][   T41]  ? blkdev_open+0x240/0x240
> [ 6805.703822][   T41]  ? do_fault+0x4bd/0xed0
> [ 6805.703835][   T41]  ? restore_exclusive_pte+0x3b0/0x3b0
> [ 6805.703860][   T41]  new_sync_write+0x2cd/0x500
> [ 6805.703915][   T41]  ? new_sync_read+0x500/0x500
> [ 6805.703951][   T41]  ? inode_security+0x54/0xf0
> [ 6805.703995][   T41]  vfs_write+0x62c/0x980
> [ 6805.704021][   T41]  __x64_sys_pwrite64+0x17a/0x1c0
> [ 6805.704034][   T41]  ? vfs_write+0x980/0x980
> [ 6805.704048][   T41]  ? syscall_enter_from_user_mode+0x20/0x70
> [ 6805.704073][   T41]  do_syscall_64+0x3a/0x80
> [ 6805.704100][   T41]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [ 6805.704111][   T41] RIP: 0033:0x7fdec0affc6f
> [ 6805.704120][   T41] RSP: 002b:00007ffd9c193620 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
> [ 6805.704133][   T41] RAX: ffffffffffffffda RBX: 0000000001170540 RCX: 00007fdec0affc6f
> [ 6805.704140][   T41] RDX: 0000000000001000 RSI: 00000000011de000 RDI: 0000000000000007
> [ 6805.704146][   T41] RBP: 00007fdea1568318 R08: 0000000000000000 R09: 0000000000000001
> [ 6805.704152][   T41] R10: 0000000000801000 R11: 0000000000000293 R12: 0000000000000001
> [ 6805.704158][   T41] R13: 0000000000000000 R14: 0000000000001000 R15: 00007fdea1568318
> [ 6805.704205][   T41]  </TASK>
> [ 6805.704236][   T41]
> [ 6805.704236][   T41] Showing all locks held in the system:
> [ 6805.704262][   T41] 2 locks held by pr/ttyS0/16:
> [ 6805.704285][   T41] 1 lock held by khungtaskd/41:
> [ 6805.704292][   T41]  #0: ffffffffb163b380 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260
> [ 6805.704343][   T41] 3 locks held by systemd-journal/541:
> [ 6805.705034][   T41] 1 lock held by fio/[ 6805.705051][   T41]  #0: ffff88811a04d110 (&md->io_barrier){....}-{0:0}, at: dm_get_live_table+0x5/0x110
> [ 6805.705118][   T41] 1 lock held by fio/55091:
> [ 6805.705125][   T41]  #0: ffff88811a04d110 (&md->io_barrier){....}-{0:0}, at: dm_get_live_table+0x5/0x110
> [ 6805.705162][   T41]
> [ 6805.705191][   T41] =============================================
> [ 6805.705191][   T41]
> 
> Fixes: ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/md/dm-crypt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 159c6806c19b..c68523a89428 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3378,6 +3378,8 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	struct dm_crypt_io *io;
>  	struct crypt_config *cc = ti->private;
>  
> +	bio_set_dev(bio, cc->dev->bdev);
> +
>  	/*
>  	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
>  	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
> @@ -3385,7 +3387,6 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	 */
>  	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
>  	    bio_op(bio) == REQ_OP_DISCARD)) {
> -		bio_set_dev(bio, cc->dev->bdev);
>  		if (bio_sectors(bio))
>  			bio->bi_iter.bi_sector = cc->start +
>  				dm_target_offset(ti, bio->bi_iter.bi_sector);

Looks ok to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

