Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F351C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 10:49:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-HHFABrcxNaK28p4Nx8BYjA-1; Thu, 17 Feb 2022 05:49:32 -0500
X-MC-Unique: HHFABrcxNaK28p4Nx8BYjA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E837B801ADA;
	Thu, 17 Feb 2022 10:49:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B6947B6F4;
	Thu, 17 Feb 2022 10:49:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9F5D24BB7C;
	Thu, 17 Feb 2022 10:49:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HAnJ4n021484 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 05:49:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14D1F4010A14; Thu, 17 Feb 2022 10:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1020F400F3FE
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 10:49:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB9663C11C7A
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 10:49:18 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-378-hkihhz1jMJ-x7yEwckTDoQ-3; Thu, 17 Feb 2022 05:49:16 -0500
X-MC-Unique: hkihhz1jMJ-x7yEwckTDoQ-3
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; d="scan'208";a="193180034"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 18:49:13 +0800
IronPort-SDR: DQpZ3DjtmgzaLpLDWAxdJdXEq6FBNQCaO+WAqqqW2Hcxmk3xTEOCxXT9l0/mOQyf4A4WAXztKv
	LRa6Lhg0blo0J0VTq1y+YYaG+XMg8CcEe1Sra3i5Dm2tQ6/tVYaeFDKy35Xqfk5xmM6xrQk1iC
	x+Ak3KWnLZOTHWjHgDuMqAdeeKfMoK71TnTbxVEtja0IGkjOBnvpnIdLs1qGMWgVhgG2aoK1Ek
	aQmKlCR1hJNMieBWjZTfbcip2V0yikUBcF4HQ01I0SUUI2cVRANWoE1PVUAtt0rgLjaa3QNknC
	L9AvRNYoH2nPJVIXb1hUWO9d
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	17 Feb 2022 02:22:00 -0800
IronPort-SDR: bGei9IRKMh+Hszjm/w+QQIk1LX51odvtefJ0loytX8vrWLTqpaE5rBJDGcmdCDsq4q37Us/Mp/
	yuPzxUnMSvMIWvqI+pGL8jKrXaJQPTs2cktT4A9ExLp0UdGB0JPy/xUwOz9HVJ6fc0O2+1IGKD
	3IfaQofa73mD4SHjl3PT/odWYmfGmvXAXoaIgGgtenIZBfKJGja1H6RrTEdBCeT3rL0ObKZrmL
	TxEZ8uGUwbAtgIMttDJkn9Ci8p0ZJuTyxx8UaH/B15+399XQAcczSNbyhSF7RKw2Dhd2w1bkE6
	Al8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	17 Feb 2022 02:49:15 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzs5Q0fynz1SVp2
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 02:49:14 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id 9IpKGLbNrs6O for <dm-devel@redhat.com>;
	Thu, 17 Feb 2022 02:49:13 -0800 (PST)
Received: from [10.225.163.77] (unknown [10.225.163.77])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzs5N4YMtz1Rwrw;
	Thu, 17 Feb 2022 02:49:12 -0800 (PST)
Message-ID: <1d287c7e-8aff-beea-1bd6-4b2226f9f3db@opensource.wdc.com>
Date: Thu, 17 Feb 2022 19:49:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Kirill Tkhai <ktkhai@virtuozzo.com>, "agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
References: <c64d2143-284e-7621-440c-971e3405b4d8@virtuozzo.com>
	<d209a0b1-2514-79a0-257a-22bcb372785a@virtuozzo.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <d209a0b1-2514-79a0-257a-22bcb372785a@virtuozzo.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v2] dm: Fix use-after-free in
 dm_cleanup_zoned_dev()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/17/22 19:13, Kirill Tkhai wrote:
> 
> dm_cleanup_zoned_dev() uses queue, so it must be called
> before blk_cleanup_disk() starts its killing:
> 
> blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->
> ->...RCU...->blk_free_queue_rcu()->kmem_cache_free()
> 
> Otherwise, RCU callback may be executed first,
> and dm_cleanup_zoned_dev() touches freed memory:

Mike,

Can you queue this please ?

> 
>  BUG: KASAN: use-after-free in dm_cleanup_zoned_dev+0x33/0xd0
>  Read of size 8 at addr ffff88805ac6e430 by task dmsetup/681
> 
>  CPU: 4 PID: 681 Comm: dmsetup Not tainted 5.17.0-rc2+ #6
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x57/0x7d
>   print_address_description.constprop.0+0x1f/0x150
>   ? dm_cleanup_zoned_dev+0x33/0xd0
>   kasan_report.cold+0x7f/0x11b
>   ? dm_cleanup_zoned_dev+0x33/0xd0
>   dm_cleanup_zoned_dev+0x33/0xd0
>   __dm_destroy+0x26a/0x400
>   ? dm_blk_ioctl+0x230/0x230
>   ? up_write+0xd8/0x270
>   dev_remove+0x156/0x1d0
>   ctl_ioctl+0x269/0x530
>   ? table_clear+0x140/0x140
>   ? lock_release+0xb2/0x750
>   ? remove_all+0x40/0x40
>   ? rcu_read_lock_sched_held+0x12/0x70
>   ? lock_downgrade+0x3c0/0x3c0
>   ? rcu_read_lock_sched_held+0x12/0x70
>   dm_ctl_ioctl+0xa/0x10
>   __x64_sys_ioctl+0xb9/0xf0
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7fb6dfa95c27
>  Code: 00 00 00 48 8b 05 69 92 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 92 0c 00 f7 d8 64 89 01 48
>  RSP: 002b:00007fff882c6c28 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
>  RAX: ffffffffffffffda RBX: 00007fb6dfb73a8e RCX: 00007fb6dfa95c27
>  RDX: 00007fb6e01d7ca0 RSI: 00000000c138fd04 RDI: 0000000000000003
>  RBP: 00007fff882c6ce0 R08: 00007fb6dfbc3558 R09: 00007fff882c6a90
>  R10: 00007fb6dfbc28a2 R11: 0000000000000206 R12: 00007fb6dfbc28a2
>  R13: 00007fb6dfbc28a2 R14: 00007fb6dfbc28a2 R15: 00007fb6dfbc28a2
>   </TASK>
> 
>  Allocated by task 673:
>   kasan_save_stack+0x1e/0x40
>   __kasan_slab_alloc+0x66/0x80
>   kmem_cache_alloc_node+0x1ca/0x460
>   blk_alloc_queue+0x33/0x4e0
>   __blk_alloc_disk+0x1b/0x60
>   dm_create+0x368/0xa20
>   dev_create+0xb9/0x170
>   ctl_ioctl+0x269/0x530
>   dm_ctl_ioctl+0xa/0x10
>   __x64_sys_ioctl+0xb9/0xf0
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>  Freed by task 0:
>   kasan_save_stack+0x1e/0x40
>   kasan_set_track+0x21/0x30
>   kasan_set_free_info+0x20/0x30
>   __kasan_slab_free+0xfb/0x130
>   slab_free_freelist_hook+0x7d/0x150
>   kmem_cache_free+0x13c/0x340
>   rcu_do_batch+0x2d9/0x820
>   rcu_core+0x3b8/0x570
>   __do_softirq+0x1c4/0x63d
> 
>  Last potentially related work creation:
>   kasan_save_stack+0x1e/0x40
>   __kasan_record_aux_stack+0x96/0xa0
>   call_rcu+0xc4/0x8f0
>   kobject_put+0xd9/0x270
>   disk_release+0xee/0x120
>   device_release+0x59/0xf0
>   kobject_put+0xd9/0x270
>   cleanup_mapped_device+0x12b/0x1b0
>   __dm_destroy+0x26a/0x400
>   dev_remove+0x156/0x1d0
>   ctl_ioctl+0x269/0x530
>   dm_ctl_ioctl+0xa/0x10
>   __x64_sys_ioctl+0xb9/0xf0
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>  The buggy address belongs to the object at ffff88805ac6e180
>   which belongs to the cache request_queue of size 2992
>  The buggy address is located 688 bytes inside of
>   2992-byte region [ffff88805ac6e180, ffff88805ac6ed30)
>  The buggy address belongs to the page:
>  page:000000000837df3c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5ac68
>  head:000000000837df3c order:3 compound_mapcount:0 compound_pincount:0
>  flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
>  raw: 000fffffc0010200 0000000000000000 dead000000000122 ffff888001e58280
>  raw: 0000000000000000 00000000800a000a 00000001ffffffff 0000000000000000
>  page dumped because: kasan: bad access detected
> 
>  Memory state around the buggy address:
>   ffff88805ac6e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88805ac6e380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  >ffff88805ac6e400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                       ^
>   ffff88805ac6e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88805ac6e500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ==================================================================
> 
> Fixes: bb37d77239af "dm: introduce zone append emulation"
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
> v2: Split long commit message line and delete [xxx] time prefix from kernel output.
> 
>  drivers/md/dm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index dcbd6d201619..d472fe5dbc1d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1607,6 +1607,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  		md->dax_dev = NULL;
>  	}
>  
> +	dm_cleanup_zoned_dev(md);
>  	if (md->disk) {
>  		spin_lock(&_minor_lock);
>  		md->disk->private_data = NULL;
> @@ -1627,7 +1628,6 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  	mutex_destroy(&md->swap_bios_lock);
>  
>  	dm_mq_cleanup_mapped_device(md);
> -	dm_cleanup_zoned_dev(md);
>  }
>  
>  /*
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

