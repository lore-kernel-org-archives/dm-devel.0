Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B5DC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 09:37:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F040064EAF
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 09:37:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F040064EAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226--XIAR9IJM_SuInvTmeEcZw-1; Mon, 01 Feb 2021 04:37:50 -0500
X-MC-Unique: -XIAR9IJM_SuInvTmeEcZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD5D7800D55;
	Mon,  1 Feb 2021 09:37:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D6196F44F;
	Mon,  1 Feb 2021 09:37:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F916180954D;
	Mon,  1 Feb 2021 09:37:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1111Gkem018365 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 31 Jan 2021 20:16:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C50E111286C; Mon,  1 Feb 2021 01:16:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 786A8111286A
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 01:16:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 971D21875049
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 01:16:43 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
	[209.85.216.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-37-kmvrx_6fNAmZaAo1pDGSdQ-1; Sun, 31 Jan 2021 20:16:40 -0500
X-MC-Unique: kmvrx_6fNAmZaAo1pDGSdQ-1
Received: by mail-pj1-f54.google.com with SMTP id my11so8742729pjb.1
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 17:16:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=RLU8sNVXRSwQvcQ9Qv8D6rwZxuEAO9er5VHUrLUQ6lo=;
	b=uPlb5aenX5cctJwSVxRgGWaEM9ondihP7C47ugqEH5Yj4sOauH50G7s/O23tTTBFS+
	TOFOyiV8EzmKc3MSjzgZwnCYax0DFDSpzPceDBvavtD789prFKrosX0sRN5Kd5lqSqix
	0JBdlusitLrXFl/d+Z6ruXu1DZ46opC5Zdmh0rqR7UH9W9iiZXi7Uw4IcyIKr8Xj1YMD
	jhxtvnAyU718xk8iwaFjwRl+OJO7a/PfyBZf8SKyUJEVYtlPVa+R4ej0cHYp1svHdEXN
	rw14PcU/RO4TS3J/EqG8RnFrZwoJ8f9ADi9NEm2Tta7AdY+xrUsnpk/V4nKtGs7Zq8b4
	2lng==
X-Gm-Message-State: AOAM53000J9pK/oi1zmgCV4kiNxHzVXsyuhoK04mE0cNyustz2/QFjjW
	9GcWlxLd5d7ZUNjhFPujxhpQEQ==
X-Google-Smtp-Source: ABdhPJy+7Y+iue1isMhdjoV1Xc/lHilNv71BbVLNluwnVBC9ltGuPGGKpSfDIeSgGZuBP/PW2ylyQQ==
X-Received: by 2002:a17:90a:7c08:: with SMTP id
	v8mr14272367pjf.135.1612142198128; 
	Sun, 31 Jan 2021 17:16:38 -0800 (PST)
Received: from [10.8.1.62] ([89.187.162.118]) by smtp.gmail.com with ESMTPSA id
	a37sm15527889pgm.79.2021.01.31.17.16.23
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 31 Jan 2021 17:16:37 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>
References: <20210126145247.1964410-1-hch@lst.de>
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <9d376309-5d67-d859-1ad0-a669bdb75cdd@cloud.ionos.com>
Date: Mon, 1 Feb 2021 02:16:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
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
X-Mailman-Approved-At: Mon, 01 Feb 2021 04:37:41 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-nilfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Chao Yu <chao@kernel.org>, linux-nfs@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, drbd-dev@tron.linbit.com,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-block@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] misc bio allocation cleanups
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Christoph,

I tried with latest for-5.12/block branch, and got below issue when 
trying to create raid1 array.

[   80.605832] BUG: kernel NULL pointer dereference, address: 
0000000000000018
[   80.606159] #PF: supervisor read access in kernel mode
[   80.606159] #PF: error_code(0x0000) - not-present page
[   80.606159] PGD 0 P4D 0
[   80.606159] Oops: 0000 [#1] SMP NOPTI
[   80.606159] CPU: 1 PID: 207 Comm: mdadm Not tainted 5.11.0-rc5+ #37
[   80.606159] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.10.2-1ubuntu1 04/01/2014
[   80.606159] RIP: 0010:bdev_read_only+0x0/0x30
[   80.606159] Code: 89 df 5b 5d e9 71 21 e7 ff 81 e6 ff ff 0f 00 48 c7 
c7 40 99 d9 9e e8 0f e5 04 00 eb a0 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 
00 <80> 7f 18 00 b8 01 00 00 00 75 11 48 8b 97 60 03 00 00 48 8b 4a 40
[   80.606159] RSP: 0018:ffffb14f405dfd38 EFLAGS: 00000246
[   80.606159] RAX: 0000000000000000 RBX: ffff9b0e0863b018 RCX: 
ffff9b0e01edc000
[   80.606159] RDX: ffff9b0e01b54c00 RSI: ffff9b0e0863b000 RDI: 
0000000000000000
[   80.606159] RBP: ffff9b0e01272200 R08: 0000000000000000 R09: 
0000000000000000
[   80.606159] R10: ffffee978004da40 R11: 0000000000000cc0 R12: 
ffff9b0e0863b000
[   80.606159] R13: ffff9b0e01f2cc00 R14: ffff9b0e0863b000 R15: 
0000000000000000
[   80.606159] FS:  00007f522ec65740(0000) GS:ffff9b0e7bc80000(0000) 
knlGS:0000000000000000
[   80.606159] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.606159] CR2: 0000000000000018 CR3: 0000000001364000 CR4: 
00000000000006e0
[   80.606159] Call Trace:
[   80.606159]  bind_rdev_to_array+0x2f7/0x380
[   80.606159]  ? cred_has_capability+0x80/0x120
[   80.606159]  md_add_new_disk+0x204/0x630
[   80.606159]  ? security_capable+0x33/0x50
[   80.606159]  md_ioctl+0xee7/0x1690
[   80.606159]  ? selinux_file_ioctl+0x143/0x200
[   80.606159]  blkdev_ioctl+0x1ff/0x240
[   80.606159]  block_ioctl+0x34/0x40
[   80.606159]  __x64_sys_ioctl+0x89/0xc0
[   80.606159]  do_syscall_64+0x33/0x40
[   80.606159]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   80.606159] RIP: 0033:0x7f522e564317
[   80.606159] Code: b3 66 90 48 8b 05 71 4b 2d 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 41 4b 2d 00 f7 d8 64 89 01 48
[   80.606159] RSP: 002b:00007ffc3abd96f8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[   80.606159] RAX: ffffffffffffffda RBX: 00005653ee690350 RCX: 
00007f522e564317
[   80.606159] RDX: 00005653ee694058 RSI: 0000000040140921 RDI: 
0000000000000004
[   80.606159] RBP: 00005653ee690410 R08: 00007f522e839db0 R09: 
0000000000000000
[   80.606159] R10: 00005653ee690010 R11: 0000000000000246 R12: 
0000000000000000
[   80.606159] R13: 0000000000000000 R14: 0000000000000000 R15: 
00005653ee694010
[   80.606159] Modules linked in:
[   80.606159] CR2: 0000000000000018
[   80.622996] ---[ end trace 22144b856a3c1001 ]---
[   80.623285] RIP: 0010:bdev_read_only+0x0/0x30
[   80.623501] Code: 89 df 5b 5d e9 71 21 e7 ff 81 e6 ff ff 0f 00 48 c7 
c7 40 99 d9 9e e8 0f e5 04 00 eb a0 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 
00 <80> 7f 18 00 b8 01 00 00 00 75 11 48 8b 97 60 03 00 00 48 8b 4a 40
[   80.624544] RSP: 0018:ffffb14f405dfd38 EFLAGS: 00000246
[   80.624788] RAX: 0000000000000000 RBX: ffff9b0e0863b018 RCX: 
ffff9b0e01edc000
[   80.625136] RDX: ffff9b0e01b54c00 RSI: ffff9b0e0863b000 RDI: 
0000000000000000
[   80.625449] RBP: ffff9b0e01272200 R08: 0000000000000000 R09: 
0000000000000000
[   80.625761] R10: ffffee978004da40 R11: 0000000000000cc0 R12: 
ffff9b0e0863b000
[   80.626112] R13: ffff9b0e01f2cc00 R14: ffff9b0e0863b000 R15: 
0000000000000000
[   80.626429] FS:  00007f522ec65740(0000) GS:ffff9b0e7bc80000(0000) 
knlGS:0000000000000000
[   80.626784] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.627035] CR2: 0000000000000018 CR3: 0000000001364000 CR4: 
00000000000006e0
Killed


Thanks,
Guoqing

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

