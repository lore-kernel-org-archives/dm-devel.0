Return-Path: <SRS0=WBCP=JG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E86C433ED
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:24:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 86926610F7
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86926610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617981852;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RExUek+Dge3kwhuB520z9HQ55iYrEHq0kR1OPp+PN4w=;
	b=SBmee5AXH+NOVK0Wn9l+6FrbA8RDs7U10YZt6zT9Wg8bgNwtp2Dh14mxuH/dPUlvQ/iIVM
	Irk9Owc0B5F4hQogSwpTcj2Gpl77Uf2VP7N+iMpky/dTcONNeaPMosJsmgLT6q8bVBYmWJ
	VYJgaNEEq5BRQYYwgj1MsK0K3kqIif4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-R90lsjoSMPmD9L0gxOpdMw-1; Fri, 09 Apr 2021 11:24:10 -0400
X-MC-Unique: R90lsjoSMPmD9L0gxOpdMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D878818BA280;
	Fri,  9 Apr 2021 15:24:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 088E61042AA7;
	Fri,  9 Apr 2021 15:24:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 274481806D0F;
	Fri,  9 Apr 2021 15:24:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 139FO0h6029335 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 11:24:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E60660C0F; Fri,  9 Apr 2021 15:24:00 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81EA160BE5;
	Fri,  9 Apr 2021 15:23:56 +0000 (UTC)
Date: Fri, 9 Apr 2021 11:23:55 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210409152355.GA15109@redhat.com>
References: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
In-Reply-To: <1617968884-15149-1-git-send-email-sergei.shtepa@veeam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	pavel.tide@veeam.com, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v8 0/4] block device interposer
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 09 2021 at  7:48am -0400,
Sergei Shtepa <sergei.shtepa@veeam.com> wrote:

> I think I'm ready to suggest the next version of block device interposer
> (blk_interposer). It allows to redirect bio requests to other block
> devices.
> 
> In this series of patches, I reviewed the process of attaching and
> detaching device mapper via blk_interposer.
> 
> Now the dm-target is attached to the interposed block device when the
> interposer dm-target is fully ready to accept requests, and the interposed
> block device queue is locked, and the file system on it is frozen.
> The detaching is also performed when the file system on the interposed
> block device is in a frozen state, the queue is locked, and the interposer
> dm-target is suspended.
> 
> To make it possible to lock the receipt of new bio requests without locking
> the processing of bio requests that the interposer creates, I had to change
> the submit_bio_noacct() function and add a lock. To minimize the impact of
> locking, I chose percpu_rw_sem. I tried to do without a new lock, but I'm
> afraid it's impossible.
> 
> Checking the operation of the interposer, I did not limit myself to
> a simple dm-linear. When I experimented with dm-era, I noticed that it
> accepts two block devices. Since Mike was against changing the logic in
> the dm-targets itself to support the interrupter, I decided to add the
> [interpose] option to the block device path.
> 
>  echo "0 ${DEV_SZ} era ${META} [interpose]${DEV} ${BLK_SZ}" | \
>  	dmsetup create dm-era --interpose
> 
> I believe this option can replace the DM_INTERPOSE_FLAG flag. Of course,
> we can assume that if the device cannot be opened with the FMODE_EXCL,
> then it is considered an interposed device, but it seems to me that
> algorithm is unsafe. I hope to get Mike's opinion on this.
> 
> I have successfully tried taking snapshots. But I ran into a problem
> when I removed origin-target:
> [   49.031156] ------------[ cut here ]------------
> [   49.031180] kernel BUG at block/bio.c:1476!
> [   49.031198] invalid opcode: 0000 [#1] SMP NOPTI
> [   49.031213] CPU: 9 PID: 636 Comm: dmsetup Tainted: G            E     5.12.0-rc6-ip+ #52
> [   49.031235] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   49.031257] RIP: 0010:bio_split+0x74/0x80
> [   49.031273] Code: 89 c7 e8 5f 56 03 00 41 8b 74 24 28 48 89 ef e8 12 ea ff ff f6 45 15 01 74 08 66 41 81 4c 24 14 00 01 4c 89 e0 5b 5d 41 5c c3 <0f> 0b 0f 0b 0f 0b 45 31 e4 eb ed 90 0f 1f 44 00 00 39 77 28 76 05
> [   49.031322] RSP: 0018:ffff9a6100993ab0 EFLAGS: 00010246
> [   49.031337] RAX: 0000000000000008 RBX: 0000000000000000 RCX: ffff8e26938f96d8
> [   49.031357] RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff8e26937d1300
> [   49.031375] RBP: ffff8e2692ddc000 R08: 0000000000000000 R09: 0000000000000000
> [   49.031394] R10: ffff8e2692b1de00 R11: ffff8e2692b1de58 R12: ffff8e26937d1300
> [   49.031413] R13: ffff8e2692ddcd18 R14: ffff8e2691d22140 R15: ffff8e26937d1300
> [   49.031432] FS:  00007efffa6e7800(0000) GS:ffff8e269bc80000(0000) knlGS:0000000000000000
> [   49.031453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   49.031470] CR2: 00007efffa96cda0 CR3: 0000000114bd0000 CR4: 00000000000506e0
> [   49.031490] Call Trace:
> [   49.031501]  dm_submit_bio+0x383/0x500 [dm_mod]
> [   49.031522]  submit_bio_noacct+0x370/0x770
> [   49.031537]  submit_bh_wbc+0x160/0x190
> [   49.031550]  __sync_dirty_buffer+0x65/0x130
> [   49.031564]  ext4_commit_super+0xbc/0x120 [ext4]
> [   49.031602]  ext4_freeze+0x54/0x80 [ext4]
> [   49.031631]  freeze_super+0xc8/0x160
> [   49.031643]  freeze_bdev+0xb2/0xc0
> [   49.031654]  lock_bdev_fs+0x1c/0x30 [dm_mod]
> [   49.031671]  __dm_suspend+0x2b9/0x3b0 [dm_mod]
> [   49.032095]  dm_suspend+0xed/0x160 [dm_mod]
> [   49.032496]  ? __find_device_hash_cell+0x5b/0x2a0 [dm_mod]
> [   49.032897]  ? remove_all+0x30/0x30 [dm_mod]
> [   49.033299]  dev_remove+0x4c/0x1c0 [dm_mod]
> [   49.033679]  ctl_ioctl+0x1a5/0x470 [dm_mod]
> [   49.034067]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
> [   49.034432]  __x64_sys_ioctl+0x83/0xb0
> [   49.034785]  do_syscall_64+0x33/0x80
> [   49.035139]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> When suspend is executed for origin-target before the interposer is
> being detached, in the origin_map() function the value of the
> o->split_binary variable is zero, since no snapshots were connected to it.
> I think that if no snapshots are connected, then it does not make sense
> to split the bio request into parts.

The dm-snapshot code requires careful order of operations.  You say you
removed the origin target.. please show exactly what you did.  Your 4th
patch shouldn't be tied to this patchset. Can be dealt with
independently.

> Changes summary for this patchset v7:
>   * The attaching and detaching to interposed device moved to
>     __dm_suspend() and __dm_resume() functions.

Why? Those hooks are inherently more constrained.  And in the case of
resume, failure is not an option.

>   * Redesigned th submit_bio_noacct() function and added a lock for the
>     block device interposer.
>   * Adds [interpose] option to block device patch in dm table.

I'm struggling to see why you need "[interpose]" (never mind that this
idea of device options is a new construct): what are the implications?
Are you saying that a table will have N devices with only a subset that
are interposed?

Just feels very awkward but I'll try to keep an open mind until I can
better understand.

>   * Fix origin_map() then o->split_binary value is zero.

Overall this effort, while appreciated in general, is getting more and
more muddled -- you're having to sprinkle obscure code all over DM. And
your patch headers are severely lacking for a v8 patch
submission. Terse bullet points don't paint a very comprehensive
picture. Please detail how a user is expected to drive this (either in
patch headers and/or some Documentation file).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

