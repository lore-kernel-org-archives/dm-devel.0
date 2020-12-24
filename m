Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6832CC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DCCFB206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCCFB206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-hRsg0UW-MpOAVMnHBSFX_Q-1; Mon, 04 Jan 2021 14:04:10 -0500
X-MC-Unique: hRsg0UW-MpOAVMnHBSFX_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51A611005504;
	Mon,  4 Jan 2021 19:04:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34C061001E73;
	Mon,  4 Jan 2021 19:04:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0D7F61809CBA;
	Mon,  4 Jan 2021 19:04:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BO2VnIk003164 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 21:31:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6153D2026D3A; Thu, 24 Dec 2020 02:31:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C9F12026D48
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 02:31:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE07180018D
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 02:31:46 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-492-SlU5tb6lMFWzXsgC81qCoA-1;
	Wed, 23 Dec 2020 21:31:44 -0500
X-MC-Unique: SlU5tb6lMFWzXsgC81qCoA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R431e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UJb3v1l_1608776183
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UJb3v1l_1608776183) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 24 Dec 2020 10:16:23 +0800
To: Ignat Korchagin <ignat@cloudflare.com>,
	device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
References: <CALrw=nGkAgqPDCaYLKreD3+6MGZOW1krAfVfvV0mKH-rjHriFQ@mail.gmail.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <9b86dd1c-8370-eaeb-db43-48f88759dade@linux.alibaba.com>
Date: Thu, 24 Dec 2020 10:16:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALrw=nGkAgqPDCaYLKreD3+6MGZOW1krAfVfvV0mKH-rjHriFQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: kernel-team <kernel-team@cloudflare.com>
Subject: Re: [dm-devel] dm crypt: export sysfs of kcryptd workqueue - broken
 dmsetup reload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sorry for the bug.

It seems that the reload table routine will create new table prior to
destroying old table, in which case the duplicate sysfs name collision
happens when creating the new table.

Maybe we could add a hash string (hashed from the address of struct
dm_table) as part of the sysfs name such as kcryptd-252:0-dsfggfh...,
since the value of 'struct dm_table *' differs at that time. But I
wonder it may not be acceptable to export such nonsense hash string to
the user space....

On 12/24/20 5:48 AM, Ignat Korchagin wrote:
> Hi,
> 
> Looks like a2b8b2d975673b1a50ab0bcce5d146b9335edfad broke the ability
> to reload dm-crypt targets.
> 
> I usually used to enable additional flags like this on an existing
> dm-crypt instance:
> 
> ignat@dev:~$ sudo dmsetup table --showkeys test | sed 's/$/ 2
> no_read_workqueue no_write_workqueue/' | sudo dmsetup reload test
> 
> Now the command fails with below:
> 
> device-mapper: reload ioctl on test  failed: Cannot allocate memory
> Command failed.
> 
> I also get this in the kernel log:
> 
> [   61.138067][ T2594] sysfs: cannot create duplicate filename
> '/devices/virtual/workqueue/kcryptd-251:0'
> [   61.139949][ T2594] CPU: 0 PID: 2594 Comm: dmsetup Not tainted 5.10.0+ #48
> [   61.141176][ T2594] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 0.0.0 02/06/2015
> [   61.142726][ T2594] Call Trace:
> [   61.143293][ T2594]  dump_stack+0x7d/0xa3
> [   61.144030][ T2594]  sysfs_warn_dup.cold+0x17/0x24
> [   61.144897][ T2594]  sysfs_create_dir_ns+0x1f3/0x270
> [   61.145844][ T2594]  ? sysfs_create_mount_point+0x90/0x90
> [   61.146830][ T2594]  ? _raw_spin_lock+0x81/0xd0
> [   61.147674][ T2594]  kobject_add_internal+0x2a6/0x860
> [   61.148594][ T2594]  ? table_load+0x2d7/0x690
> [   61.149372][ T2594]  ? ctl_ioctl+0x3a1/0x950
> [   61.150122][ T2594]  kobject_add+0x125/0x190
> [   61.150914][ T2594]  ? kset_create_and_add+0x160/0x160
> [   61.151812][ T2594]  ? unpoison_range+0x3a/0x60
> [   61.152616][ T2594]  ? ____kasan_kmalloc.constprop.0+0x82/0xa0
> [   61.153633][ T2594]  ? unpoison_range+0x3a/0x60
> [   61.154459][ T2594]  device_add+0x2d7/0x1a40
> [   61.155235][ T2594]  ? dev_set_name+0xb0/0xe0
> [   61.156001][ T2594]  ? memset+0x20/0x40
> [   61.156680][ T2594]  ? __fw_devlink_link_to_suppliers+0x560/0x560
> [   61.157762][ T2594]  ? pm_runtime_init+0x2a3/0x380
> [   61.158646][ T2594]  workqueue_sysfs_register+0x17e/0x370
> [   61.159593][ T2594]  alloc_workqueue+0x559/0xb50
> [   61.160401][ T2594]  ? workqueue_sysfs_register+0x370/0x370
> [   61.161387][ T2594]  ? sscanf+0xab/0xe0
> [   61.162063][ T2594]  ? bioset_init+0x41a/0x710
> [   61.162870][ T2594]  crypt_ctr+0x24d5/0x2f90
> [   61.163624][ T2594]  ? crypt_ctr_cipher_new.constprop.0+0xa30/0xa30
> [   61.164703][ T2594]  ? realloc_argv+0xd2/0x110
> [   61.165492][ T2594]  ? dm_table_destroy+0x410/0x410
> [   61.166357][ T2594]  dm_table_add_target+0x45d/0xc40
> [   61.167239][ T2594]  ? dm_table_create+0xd8/0x320
> [   61.168090][ T2594]  ? dm_split_args+0x580/0x580
> [   61.168910][ T2594]  ? __mutex_lock_slowpath+0x10/0x10
> [   61.169800][ T2594]  ? dm_table_create+0x12b/0x320
> [   61.170651][ T2594]  table_load+0x2d7/0x690
> [   61.171395][ T2594]  ? __kasan_kmalloc_large+0x89/0xb0
> [   61.172295][ T2594]  ? dev_suspend+0x4a0/0x4a0
> [   61.173109][ T2594]  ? __kmalloc_node+0x275/0x320
> [   61.173960][ T2594]  ? __might_fault+0x4f/0x70
> [   61.174733][ T2594]  ctl_ioctl+0x3a1/0x950
> [   61.175492][ T2594]  ? dev_suspend+0x4a0/0x4a0
> [   61.176248][ T2594]  ? free_params+0x30/0x30
> [   61.176968][ T2594]  dm_ctl_ioctl+0xa/0x10
> [   61.177659][ T2594]  __x64_sys_ioctl+0x7ff/0x1110
> [   61.178472][ T2594]  ? generic_block_fiemap+0x60/0x60
> [   61.179308][ T2594]  do_syscall_64+0x33/0x40
> [   61.180045][ T2594]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   61.181007][ T2594] RIP: 0033:0x7f48230e0427
> [   61.181722][ T2594] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26
> 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10
> 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8
> 64 89 01 48
> [   61.184908][ T2594] RSP: 002b:00007ffd1469cb68 EFLAGS: 00000202
> ORIG_RAX: 0000000000000010
> [   61.186262][ T2594] RAX: ffffffffffffffda RBX: 00007f48231bea7f
> RCX: 00007f48230e0427
> [   61.187590][ T2594] RDX: 0000556251e1dea0 RSI: 00000000c138fd09
> RDI: 0000000000000003
> [   61.188970][ T2594] RBP: 00007ffd1469cc20 R08: 00007f482320d310
> R09: 00007ffd1469c9d0
> [   61.190290][ T2594] R10: 00007f482320c65a R11: 0000000000000202
> R12: 00007f482320c65a
> [   61.191639][ T2594] R13: 00007f482320c65a R14: 00007f482320c65a
> R15: 00007f482320c65a
> [   61.193014][ T2594] kobject_add_internal failed for kcryptd-251:0
> with -EEXIST, don't try to register things with the same name in the
> same directory.
> [   61.201542][ T2594] device-mapper: table: 251:0: crypt: Couldn't
> create kcryptd queue
> [   61.203050][ T2594] device-mapper: ioctl: error adding target to table
> 
> Seems we're missing a clean-up somewhere, so it tries to create multiple queues.
> 
> Regards,
> Ignat
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

