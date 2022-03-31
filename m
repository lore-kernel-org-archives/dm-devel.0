Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A585CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648743730;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wOxf1iarpQ5Lp6P7Lv11/YgBXecKGFYD29fQexC6+XU=;
	b=Gzf8F/FxSECY+mayjumvOJSoHn3o6NMIglLhJu82eyHqGQ8DZk2T11HafzkLFdZc1Kzn5X
	qcbJQ2kKslSSQfQ3IYtpQuzT0VnZHnyoUAqNvBYkylyC7qpVMqpZxS3TsiUpFJ6ekoy7Up
	NrSjnADxBN2BRDnz/XchOXWa6H3CGCw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-7C3bN3mkO96W6hmJOsAQEw-1; Thu, 31 Mar 2022 12:22:09 -0400
X-MC-Unique: 7C3bN3mkO96W6hmJOsAQEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A89C100BAAF;
	Thu, 31 Mar 2022 16:22:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5302C4C7A1;
	Thu, 31 Mar 2022 16:22:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A7301947BBB;
	Thu, 31 Mar 2022 16:22:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 21B0519451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 16:22:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3A771417201; Thu, 31 Mar 2022 16:22:02 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB8461400C2B;
 Thu, 31 Mar 2022 16:22:02 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 22VGM2bK023131; Thu, 31 Mar 2022 12:22:02 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 22VGM26H023127; Thu, 31 Mar 2022 12:22:02 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 31 Mar 2022 12:22:02 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <CAH6w=ayZoHOnN5Pj=BVbFhi5OweCy8bX3u6nKtL3PJoyLtQUHA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2203311207540.22503@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2203301424570.11614@file01.intranet.prod.int.rdu2.redhat.com>
 <CAH6w=ayZoHOnN5Pj=BVbFhi5OweCy8bX3u6nKtL3PJoyLtQUHA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] oops s dm-integrity (fwd)
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
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 31 Mar 2022, Mike Snitzer wrote:

> Not seen it, looks like Milan is running cryotsetup 'make check' in a
> KVM guest on a 5.17-rc7 kernel.
> 
> I tested dm-5.18 like crazy with cryptsetup's testsuite.  It was based
> on 5.17-rc2 (and a ton of block changes).
> 
> Have you been able to reproduce on final 5.17 (or even same kernel as Milan)?

I've tried cryptsetup "make check" on the current 5.18 (with slab 
debugging enabled) and got these stacktraces. There's clearly some memory 
corruption going on. I'll continue to investigate it.

Mikulas

[13668.733488] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[13668.735277] Call trace:
[13668.735951]  dump_backtrace.part.0+0xb8/0xcc
[13668.737085]  show_stack+0x14/0x30
[13668.737973]  dump_stack_lvl+0x64/0x7c
[13668.738978]  dump_stack+0x14/0x2c
[13668.739868]  print_trailer+0x14c/0x15c
[13668.740811]  check_bytes_and_report+0xf4/0x140
[13668.741903]  check_object+0x1a4/0x274
[13668.742815]  free_debug_processing+0x188/0x38c
[13668.743904]  __slab_free+0x27c/0x434
[13668.744788]  kfree+0x23c/0x27c
[13668.745554]  kvfree+0x34/0x40
[13668.746355]  dm_integrity_dtr+0x88/0x35c [dm_integrity]
[13668.747795]  dm_table_destroy+0x54/0x11c [dm_mod]
[13668.749130]  __dm_destroy+0x154/0x29c [dm_mod]
[13668.750383]  dm_destroy+0x10/0x20 [dm_mod]
[13668.751553]  dev_remove+0xf4/0x150 [dm_mod]
[13668.752733]  ctl_ioctl+0x244/0x660 [dm_mod]
[13668.753897]  dm_ctl_ioctl+0xc/0x20 [dm_mod]
[13668.755060]  __arm64_sys_ioctl+0xac/0xd0
[13668.756156]  el0_svc_common.constprop.0+0x5c/0x134
[13668.757449]  do_el0_svc+0x1c/0x2c
[13668.758340]  el0_svc+0x14/0x50
[13668.759187]  el0t_64_sync_handler+0x9c/0x120
[13668.760356]  el0t_64_sync+0x148/0x14c

[13639.738726] Call trace:
[13639.741794]  __switch_to+0xe8/0x140
[13639.744081]  dstopt_offload+0xba560/0x10c330
[13639.746941]  print_trailer+0xd0/0x15c
[13639.750017]  check_bytes_and_report+0xf4/0x140
[13639.752944]  check_object+0x1a4/0x274
[13639.756056]  free_debug_processing+0x188/0x38c
[13639.758998]  __slab_free+0x27c/0x434
[13639.762141]  kfree+0x23c/0x27c
[13639.765058]  kvfree+0x34/0x40
[13639.767840]  dm_integrity_dtr+0x88/0x35c [dm_integrity]
[13639.770597]  dm_table_destroy+0x54/0x11c [dm_mod]
[13639.773937]  __dm_destroy+0x154/0x29c [dm_mod]
[13639.777147]  dm_destroy+0x10/0x20 [dm_mod]
[13639.780271]  dev_remove+0xf4/0x150 [dm_mod]
[13639.783318]  ctl_ioctl+0x244/0x660 [dm_mod]
[13639.786384]  dm_ctl_ioctl+0xc/0x20 [dm_mod]
[13639.789452]  __arm64_sys_ioctl+0xac/0xd0
[13639.792516]  el0_svc_common.constprop.0+0x5c/0x134
[13639.795510]  do_el0_svc+0x1c/0x2c
[13639.798741]  el0_svc+0x14/0x50
[13639.801591]  el0t_64_sync_handler+0x9c/0x120
[13639.804378]  el0t_64_sync+0x148/0x14c

[13618.686535] =============================================================================
[13618.687921] BUG kmalloc-128k (Not tainted): Right Redzone overwritten
[13618.688984] -----------------------------------------------------------------------------
[13618.688984] 
[13618.690531] 0xfffffc00ccec0000-0xfffffc00ccec0007 @offset=262144. First byte 0x26 instead of 0xcc
[13618.691980] Allocated in 0xf3e51e7b9f122643 age=86 cpu=3 pid=23374
[13618.693031]  0xfffffe00a470735c
[13618.693581]  __kmalloc+0x280/0x290
[13618.694162]  kvmalloc_node+0x54/0xd0
[13618.694780]  dm_integrity_ctr+0xfcc/0x14cc [dm_integrity]
[13618.695731]  dm_table_add_target+0x11c/0x30c [dm_mod]
[13618.696815]  table_load+0x11c/0x354 [dm_mod]
[13618.697726]  ctl_ioctl+0x244/0x660 [dm_mod]
[13618.698619]  dm_ctl_ioctl+0xc/0x20 [dm_mod]
[13618.699485]  __arm64_sys_ioctl+0xac/0xd0
[13618.700279]  el0_svc_common.constprop.0+0x5c/0x134
[13618.701259]  do_el0_svc+0x1c/0x2c
[13618.701943]  el0_svc+0x14/0x50
[13618.702561]  el0t_64_sync_handler+0x9c/0x120
[13618.703411]  el0t_64_sync+0x148/0x14c
[13618.704149] Freed in kvfree+0x34/0x40 age=99 cpu=2 pid=23359
[13618.705316]  kfree+0x23c/0x27c
[13618.705954]  kvfree+0x34/0x40
[13618.706567]  dm_integrity_dtr+0x88/0x35c [dm_integrity]
[13618.707606]  dm_table_destroy+0x54/0x11c [dm_mod]
[13618.708627]  __dm_destroy+0x154/0x29c [dm_mod]
[13618.709596]  dm_destroy+0x10/0x20 [dm_mod]
[13618.710458]  dev_remove+0xf4/0x150 [dm_mod]
[13618.711343]  ctl_ioctl+0x244/0x660 [dm_mod]
[13618.712227]  dm_ctl_ioctl+0xc/0x20 [dm_mod]
[13618.713097]  __arm64_sys_ioctl+0xac/0xd0
[13618.713916]  el0_svc_common.constprop.0+0x5c/0x134
[13618.714884]  do_el0_svc+0x1c/0x2c
[13618.715572]  el0_svc+0x14/0x50

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

