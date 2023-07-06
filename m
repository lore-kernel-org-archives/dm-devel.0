Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88410EB64DC
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971621;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KSn1UcvBB51IrUgsqj/dQbyI+HD+HXEkc0A2zfWNet4=;
	b=Rm+3OaYR4Ms7YZm264zmwPw2ziG37sqdpPO6ngzSDTNbdBZMrV0Fsz5PwhzZY3En7mANmI
	iovToxxIHSywsXO7DJ6FpjvIF+40ITJkU7whr08waXpS/FYvViK+BXR2XdXipxBCJfDeHO
	XnwP4Vd4bFMw6yRj6lubSEOyapC/zGc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-Sy6ww3RdNVCZdeUPZiGSxQ-1; Mon, 10 Jul 2023 02:46:59 -0400
X-MC-Unique: Sy6ww3RdNVCZdeUPZiGSxQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99D3738149C3;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 523564CD0C9;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EDF019451D1;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 575C41946588
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Jul 2023 00:24:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2F131121315; Thu,  6 Jul 2023 00:24:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBF361121314
 for <dm-devel@redhat.com>; Thu,  6 Jul 2023 00:24:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1104802666
 for <dm-devel@redhat.com>; Thu,  6 Jul 2023 00:24:54 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-4gD_-MoEOCSU7MkvFZrMOQ-1; Wed, 05 Jul 2023 20:24:53 -0400
X-MC-Unique: 4gD_-MoEOCSU7MkvFZrMOQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 797AE617AA;
 Thu,  6 Jul 2023 00:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C33B1C433C8;
 Thu,  6 Jul 2023 00:18:14 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 A1405C64459; Thu,  6 Jul 2023 00:18:14 +0000 (UTC)
MIME-Version: 1.0
From: patchwork-bot+f2fs@kernel.org
Message-Id: <168860269464.29151.2364164271547941172.git-patchwork-notify@kernel.org>
Date: Thu, 06 Jul 2023 00:18:14 +0000
References: <20230608110258.189493-2-hch@lst.de>
In-Reply-To: <20230608110258.189493-2-hch@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [f2fs-dev] [PATCH 01/30] block: also call ->open for
 incremental partition opens
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
Cc: vigneshr@ti.com, rafael@kernel.org, linux-nvme@lists.infradead.org,
 phil@philpotter.co.uk, clm@fb.com, dm-devel@redhat.com, haris.iqbal@ionos.com,
 pavel@ucw.cz, miquel.raynal@bootlin.com, jinpu.wang@ionos.com,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, richard@nod.at,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org, josef@toxicpanda.com,
 colyli@suse.de, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 viro@zeniv.linux.org.uk, dsterba@suse.com, axboe@kernel.dk, brauner@kernel.org,
 martin.petersen@oracle.com, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Jens Axboe <axboe@kernel.dk>:

On Thu,  8 Jun 2023 13:02:29 +0200 you wrote:
> For whole devices ->open is called for each open, but for partitions it
> is only called on the first open of a partition, e.g.:
> 
>   open("/dev/vdb", ...)
>   open("/dev/vdb", ...)
>     - 2 call to ->open
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,01/30] block: also call ->open for incremental partition opens
    https://git.kernel.org/jaegeuk/f2fs/c/9d1c92872e70
  - [f2fs-dev,02/30] cdrom: remove the unused bdev argument to cdrom_open
    https://git.kernel.org/jaegeuk/f2fs/c/764b83100b9a
  - [f2fs-dev,03/30] cdrom: remove the unused mode argument to cdrom_ioctl
    https://git.kernel.org/jaegeuk/f2fs/c/473399b50de1
  - [f2fs-dev,04/30] cdrom: remove the unused cdrom_close_write release code
    https://git.kernel.org/jaegeuk/f2fs/c/a4cec8bc14c0
  - [f2fs-dev,05/30] cdrom: track if a cdrom_device_info was opened for data
    https://git.kernel.org/jaegeuk/f2fs/c/8cdf433e2b8e
  - [f2fs-dev,06/30] cdrom: remove the unused mode argument to cdrom_release
    https://git.kernel.org/jaegeuk/f2fs/c/7ae24fcee992
  - [f2fs-dev,07/30] block: pass a gendisk on bdev_check_media_change
    https://git.kernel.org/jaegeuk/f2fs/c/444aa2c58cb3
  - [f2fs-dev,08/30] block: pass a gendisk to ->open
    https://git.kernel.org/jaegeuk/f2fs/c/d32e2bf83791
  - [f2fs-dev,09/30] block: remove the unused mode argument to ->release
    https://git.kernel.org/jaegeuk/f2fs/c/ae220766d87c
  - [f2fs-dev,10/30] block: rename blkdev_close to blkdev_release
    https://git.kernel.org/jaegeuk/f2fs/c/7ee34cbc291a
  - [f2fs-dev,11/30] swsusp: don't pass a stack address to blkdev_get_by_path
    https://git.kernel.org/jaegeuk/f2fs/c/c889d0793d9d
  - [f2fs-dev,12/30] bcache: don't pass a stack address to blkdev_get_by_path
    https://git.kernel.org/jaegeuk/f2fs/c/29499ab060fe
  - [f2fs-dev,13/30] rnbd-srv: don't pass a holder for non-exclusive blkdev_get_by_path
    https://git.kernel.org/jaegeuk/f2fs/c/5ee607675deb
  - [f2fs-dev,14/30] btrfs: don't pass a holder for non-exclusive blkdev_get_by_path
    https://git.kernel.org/jaegeuk/f2fs/c/2ef789288afd
  - [f2fs-dev,15/30] block: use the holder as indication for exclusive opens
    https://git.kernel.org/jaegeuk/f2fs/c/2736e8eeb0cc
  - [f2fs-dev,16/30] block: add a sb_open_mode helper
    https://git.kernel.org/jaegeuk/f2fs/c/3f0b3e785e8b
  - [f2fs-dev,17/30] fs: remove sb->s_mode
    https://git.kernel.org/jaegeuk/f2fs/c/81b1fb7d17c0
  - [f2fs-dev,18/30] scsi: replace the fmode_t argument to scsi_cmd_allowed with a simple bool
    https://git.kernel.org/jaegeuk/f2fs/c/5f4eb9d5413f
  - [f2fs-dev,19/30] scsi: replace the fmode_t argument to scsi_ioctl with a simple bool
    https://git.kernel.org/jaegeuk/f2fs/c/2e80089c1824
  - [f2fs-dev,20/30] scsi: replace the fmode_t argument to ->sg_io_fn with a simple bool
    https://git.kernel.org/jaegeuk/f2fs/c/1991299e49fa
  - [f2fs-dev,21/30] nvme: replace the fmode_t argument to the nvme ioctl handlers with a simple bool
    https://git.kernel.org/jaegeuk/f2fs/c/7d9d7d59d44b
  - [f2fs-dev,22/30] mtd: block: use a simple bool to track open for write
    https://git.kernel.org/jaegeuk/f2fs/c/658afed19cee
  - [f2fs-dev,23/30] rnbd-srv: replace sess->open_flags with a "bool readonly"
    https://git.kernel.org/jaegeuk/f2fs/c/99b07780814e
  - [f2fs-dev,24/30] ubd: remove commented out code in ubd_open
    https://git.kernel.org/jaegeuk/f2fs/c/bd6abfc8e789
  - [f2fs-dev,25/30] block: move a few internal definitions out of blkdev.h
    https://git.kernel.org/jaegeuk/f2fs/c/cfb425761c79
  - [f2fs-dev,26/30] block: remove unused fmode_t arguments from ioctl handlers
    https://git.kernel.org/jaegeuk/f2fs/c/5e4ea834676e
  - [f2fs-dev,27/30] block: replace fmode_t with a block-specific type for block open flags
    https://git.kernel.org/jaegeuk/f2fs/c/05bdb9965305
  - [f2fs-dev,28/30] block: always use I_BDEV on file->f_mapping->host to find the bdev
    https://git.kernel.org/jaegeuk/f2fs/c/4e762d862344
  - [f2fs-dev,29/30] block: store the holder in file->private_data
    https://git.kernel.org/jaegeuk/f2fs/c/ee3249a8ce78
  - [f2fs-dev,30/30] fs: remove the now unused FMODE_* flags
    https://git.kernel.org/jaegeuk/f2fs/c/0733ad800291

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

