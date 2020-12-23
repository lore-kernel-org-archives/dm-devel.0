Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D201C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 21:48:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7BA6F22473
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 21:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BA6F22473
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-blhlhPYoN3u7VN5tpAz-fA-1; Wed, 23 Dec 2020 16:48:32 -0500
X-MC-Unique: blhlhPYoN3u7VN5tpAz-fA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25E4915723;
	Wed, 23 Dec 2020 21:48:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0275614F5;
	Wed, 23 Dec 2020 21:48:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 669F24BB7B;
	Wed, 23 Dec 2020 21:48:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNLmNAl008859 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 16:48:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CF68E1102E06; Wed, 23 Dec 2020 21:48:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB7171102E03
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:48:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87F458007DF
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:48:21 +0000 (UTC)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
	[209.85.166.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-FDI2dlEnPMO2hX3uMFLA0A-1; Wed, 23 Dec 2020 16:48:18 -0500
X-MC-Unique: FDI2dlEnPMO2hX3uMFLA0A-1
Received: by mail-il1-f169.google.com with SMTP id k8so419098ilr.4
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 13:48:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
	bh=Ot709l7N9jM/Qj4o5CjYijxrdyqy2VZV5y7sJypbrQg=;
	b=B/qjv0PTCMRGCKNY0Xtn4ATDAPpiz98QDe3jbVNZanLgj0ymDMUFAcrcP5WcVPWprk
	jt4KhZNv4q7FB18dG0uwXdhyFnUb1gcJQf3sQ7i0JzJHRttr+0iYPdE/mS6Pkqmta/QU
	o5/7HYhU278to0FpFbvX6NMPyVuVrHO3782Nnw2qxdJOEDZWrswTHIEIMSyH53TAJi9x
	rlTSgNB922CewfJvgCU9wEN/rOT48ANXYW36V0yA6HKyuLxdql28pSJnthwzTdQb4ZZh
	7Lt4k8Wr3vxU0diBxQOvN8ZmNKAzXKwsoS3a4+UwknlVxF6BGh8PwwxPPt1LkYlLZ/kD
	FQoQ==
X-Gm-Message-State: AOAM530tw5LMjL11lcb7F2vFfFGA0c6agCmxida73aTUPRtLYIPn/ZoL
	tX2hJrqxtA1Fgomn63qiu/j2/xmyguIXRk+Gazg1J2m6E5oJYG/sP+U=
X-Google-Smtp-Source: ABdhPJz3o7IrY3zsUzJoodDyyLFCnecvTCodRzLvEs9GvMh9+HWjPfL6hwqoaJl5FFXZuZBgch/xOXH0+Yeik304X2k=
X-Received: by 2002:a92:cdac:: with SMTP id g12mr27018983ild.145.1608760097667;
	Wed, 23 Dec 2020 13:48:17 -0800 (PST)
MIME-Version: 1.0
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 23 Dec 2020 21:48:07 +0000
Message-ID: <CALrw=nGkAgqPDCaYLKreD3+6MGZOW1krAfVfvV0mKH-rjHriFQ@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>,
	jefflexu@linux.alibaba.com, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: kernel-team <kernel-team@cloudflare.com>
Subject: [dm-devel] dm crypt: export sysfs of kcryptd workqueue - broken
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Looks like a2b8b2d975673b1a50ab0bcce5d146b9335edfad broke the ability
to reload dm-crypt targets.

I usually used to enable additional flags like this on an existing
dm-crypt instance:

ignat@dev:~$ sudo dmsetup table --showkeys test | sed 's/$/ 2
no_read_workqueue no_write_workqueue/' | sudo dmsetup reload test

Now the command fails with below:

device-mapper: reload ioctl on test  failed: Cannot allocate memory
Command failed.

I also get this in the kernel log:

[   61.138067][ T2594] sysfs: cannot create duplicate filename
'/devices/virtual/workqueue/kcryptd-251:0'
[   61.139949][ T2594] CPU: 0 PID: 2594 Comm: dmsetup Not tainted 5.10.0+ #48
[   61.141176][ T2594] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 0.0.0 02/06/2015
[   61.142726][ T2594] Call Trace:
[   61.143293][ T2594]  dump_stack+0x7d/0xa3
[   61.144030][ T2594]  sysfs_warn_dup.cold+0x17/0x24
[   61.144897][ T2594]  sysfs_create_dir_ns+0x1f3/0x270
[   61.145844][ T2594]  ? sysfs_create_mount_point+0x90/0x90
[   61.146830][ T2594]  ? _raw_spin_lock+0x81/0xd0
[   61.147674][ T2594]  kobject_add_internal+0x2a6/0x860
[   61.148594][ T2594]  ? table_load+0x2d7/0x690
[   61.149372][ T2594]  ? ctl_ioctl+0x3a1/0x950
[   61.150122][ T2594]  kobject_add+0x125/0x190
[   61.150914][ T2594]  ? kset_create_and_add+0x160/0x160
[   61.151812][ T2594]  ? unpoison_range+0x3a/0x60
[   61.152616][ T2594]  ? ____kasan_kmalloc.constprop.0+0x82/0xa0
[   61.153633][ T2594]  ? unpoison_range+0x3a/0x60
[   61.154459][ T2594]  device_add+0x2d7/0x1a40
[   61.155235][ T2594]  ? dev_set_name+0xb0/0xe0
[   61.156001][ T2594]  ? memset+0x20/0x40
[   61.156680][ T2594]  ? __fw_devlink_link_to_suppliers+0x560/0x560
[   61.157762][ T2594]  ? pm_runtime_init+0x2a3/0x380
[   61.158646][ T2594]  workqueue_sysfs_register+0x17e/0x370
[   61.159593][ T2594]  alloc_workqueue+0x559/0xb50
[   61.160401][ T2594]  ? workqueue_sysfs_register+0x370/0x370
[   61.161387][ T2594]  ? sscanf+0xab/0xe0
[   61.162063][ T2594]  ? bioset_init+0x41a/0x710
[   61.162870][ T2594]  crypt_ctr+0x24d5/0x2f90
[   61.163624][ T2594]  ? crypt_ctr_cipher_new.constprop.0+0xa30/0xa30
[   61.164703][ T2594]  ? realloc_argv+0xd2/0x110
[   61.165492][ T2594]  ? dm_table_destroy+0x410/0x410
[   61.166357][ T2594]  dm_table_add_target+0x45d/0xc40
[   61.167239][ T2594]  ? dm_table_create+0xd8/0x320
[   61.168090][ T2594]  ? dm_split_args+0x580/0x580
[   61.168910][ T2594]  ? __mutex_lock_slowpath+0x10/0x10
[   61.169800][ T2594]  ? dm_table_create+0x12b/0x320
[   61.170651][ T2594]  table_load+0x2d7/0x690
[   61.171395][ T2594]  ? __kasan_kmalloc_large+0x89/0xb0
[   61.172295][ T2594]  ? dev_suspend+0x4a0/0x4a0
[   61.173109][ T2594]  ? __kmalloc_node+0x275/0x320
[   61.173960][ T2594]  ? __might_fault+0x4f/0x70
[   61.174733][ T2594]  ctl_ioctl+0x3a1/0x950
[   61.175492][ T2594]  ? dev_suspend+0x4a0/0x4a0
[   61.176248][ T2594]  ? free_params+0x30/0x30
[   61.176968][ T2594]  dm_ctl_ioctl+0xa/0x10
[   61.177659][ T2594]  __x64_sys_ioctl+0x7ff/0x1110
[   61.178472][ T2594]  ? generic_block_fiemap+0x60/0x60
[   61.179308][ T2594]  do_syscall_64+0x33/0x40
[   61.180045][ T2594]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   61.181007][ T2594] RIP: 0033:0x7f48230e0427
[   61.181722][ T2594] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26
00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10
00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8
64 89 01 48
[   61.184908][ T2594] RSP: 002b:00007ffd1469cb68 EFLAGS: 00000202
ORIG_RAX: 0000000000000010
[   61.186262][ T2594] RAX: ffffffffffffffda RBX: 00007f48231bea7f
RCX: 00007f48230e0427
[   61.187590][ T2594] RDX: 0000556251e1dea0 RSI: 00000000c138fd09
RDI: 0000000000000003
[   61.188970][ T2594] RBP: 00007ffd1469cc20 R08: 00007f482320d310
R09: 00007ffd1469c9d0
[   61.190290][ T2594] R10: 00007f482320c65a R11: 0000000000000202
R12: 00007f482320c65a
[   61.191639][ T2594] R13: 00007f482320c65a R14: 00007f482320c65a
R15: 00007f482320c65a
[   61.193014][ T2594] kobject_add_internal failed for kcryptd-251:0
with -EEXIST, don't try to register things with the same name in the
same directory.
[   61.201542][ T2594] device-mapper: table: 251:0: crypt: Couldn't
create kcryptd queue
[   61.203050][ T2594] device-mapper: ioctl: error adding target to table

Seems we're missing a clean-up somewhere, so it tries to create multiple queues.

Regards,
Ignat

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

