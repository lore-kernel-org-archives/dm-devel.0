Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59786C88CB6
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jun 2023 14:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686579121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c71Xtqv3gDXikdu3WNCaehzU0J+bJRND+8hygWfxZds=;
	b=WPqq/Q9dQ90A641VgNsvP+79kIDW+XfgkXrmKG1Ppl/7/w8Pd7MSnDzVZlW2qbB8N/GGBi
	7l3AWoJSWqx0mbXKSkNe5XCqTLLwlWYINl1wDxcPJNMuIQRNbMYvSLqBSaWzxq2PxrAtqp
	BQgL0YD0O2XyO3+rWWk96vmnGX0zd5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-31NFiXTROsWGd8i0zDQWMA-1; Mon, 12 Jun 2023 10:11:58 -0400
X-MC-Unique: 31NFiXTROsWGd8i0zDQWMA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F367801585;
	Mon, 12 Jun 2023 14:11:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BAA4492CA6;
	Mon, 12 Jun 2023 14:11:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 094C519465B6;
	Mon, 12 Jun 2023 14:11:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DA03194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Jun 2023 14:11:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CFEA440C20F5; Mon, 12 Jun 2023 14:11:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7CF240C20F4
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 14:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC3448007D9
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 14:11:50 +0000 (UTC)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-7779Sl2_PfKbiXYJnMWh8g-1; Mon, 12 Jun 2023 10:11:48 -0400
X-MC-Unique: 7779Sl2_PfKbiXYJnMWh8g-1
Received: by mail-io1-f53.google.com with SMTP id
 ca18e2360f4ac-7747cc8bea0so36865839f.1
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 07:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686579108; x=1689171108;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4muTChvfXbyFleywXuJztp663UoDJyd/b1njxzLhqy8=;
 b=WTRgkSXGRBpWK0ynOrM4Hz1/dWIjXFy+64jiZwqWbH1OzEy+ZY2/CCO4nDornG+Txj
 4aY6So4l8uY1+VQVUqXKYSRh+Y2DNIj2y7BrUvg+TYzDjkslw0lVjnQBrZ9k/DXcsnAG
 d6osz67ng3rqlzgSrVuXkRzz2vRtqLeVEmTwBoTLerIC/ldwL1xYV3Xh6OI/oFsK+0QC
 9XH6jP5ICOyrFSw/Kio24FaSG+1yr98fidvvkM2A0BtcEqotVVzpBhvCrqk9o4ncfVHH
 s/qVFpxfZ2tDvRw4t6pLNGfZotgq5Xt0RCBxL/4G20CrDIg8JZVPMFoIGJExVt4dj+EV
 4SZQ==
X-Gm-Message-State: AC+VfDxSTEhPYGK68u9ZwSBtocLHl3lgwITofZ+5vt3CLkwIaGiR8VdT
 HuWgfJ5juxf3yJ4MYR82AP4tKQ==
X-Google-Smtp-Source: ACHHUZ7oss5Q4qEAESR1LIaLJkD7ZwONVfsRpFehVo9Ss1V9OTMOTrOh14yI7Krm7Ivy+/EbDcrm4g==
X-Received: by 2002:a6b:690a:0:b0:77a:ee79:652 with SMTP id
 e10-20020a6b690a000000b0077aee790652mr4231482ioc.1.1686579107952; 
 Mon, 12 Jun 2023 07:11:47 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 i19-20020a02cc53000000b0041408b79f1esm2793007jaq.111.2023.06.12.07.11.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Jun 2023 07:11:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20230608110258.189493-1-hch@lst.de>
References: <20230608110258.189493-1-hch@lst.de>
Message-Id: <168657910650.933808.4041515037046679285.b4-ty@kernel.dk>
Date: Mon, 12 Jun 2023 08:11:46 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] decouple block open flags from fmode_t v2
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Thu, 08 Jun 2023 13:02:28 +0200, Christoph Hellwig wrote:
> this series adds a new blk_mode_t for block open flags instead of abusing
> fmode_t.  The block open flags work very different from the normal use of
> fmode_t and only share the basic READ/WRITE flags with it.  None of the
> other normal FMODE_* flags is used, but instead there are three
> block-specific ones not used by anyone else, which can now be removed.
> 
> Note that I've only CCed maintainers and lists for drivers and file systems
> that have non-trivial changes, as otherwise the series would spam literally
> everyone in the block and file system world.
> 
> [...]

Applied, thanks!

[01/30] block: also call ->open for incremental partition opens
        commit: 9d1c92872e7082f100f629a58b32fa0214aa1aec
[02/30] cdrom: remove the unused bdev argument to cdrom_open
        commit: 764b83100b9aff52f950e408539c22a37cdedae8
[03/30] cdrom: remove the unused mode argument to cdrom_ioctl
        commit: 473399b50de1fdc12606254351273c71d1786251
[04/30] cdrom: remove the unused cdrom_close_write release code
        commit: a4cec8bc14c02e15006a71f02b0e1bbc72b9f796
[05/30] cdrom: track if a cdrom_device_info was opened for data
        commit: 8cdf433e2b8e4fc6c7b4393deb93fb258175d537
[06/30] cdrom: remove the unused mode argument to cdrom_release
        commit: 7ae24fcee9929f9002b84d8121144b2b3590b58c
[07/30] block: pass a gendisk on bdev_check_media_change
        commit: 444aa2c58cb3b6cfe3b7cc7db6c294d73393a894
[08/30] block: pass a gendisk to ->open
        commit: d32e2bf83791727a84ad5d3e3d713e82f9adbe30
[09/30] block: remove the unused mode argument to ->release
        commit: ae220766d87cd6799dbf918fea10613ae14c0654
[10/30] block: rename blkdev_close to blkdev_release
        commit: 7ee34cbc291a28134b60683b246ba58b4b676ec3
[11/30] swsusp: don't pass a stack address to blkdev_get_by_path
        commit: c889d0793d9dc07e94a5fddcc05356157fab00b7
[12/30] bcache: don't pass a stack address to blkdev_get_by_path
        commit: 29499ab060fec044161be73fb0e448eab97b4813
[13/30] rnbd-srv: don't pass a holder for non-exclusive blkdev_get_by_path
        commit: 5ee607675debef509946f8a251d4c30a21493ec2
[14/30] btrfs: don't pass a holder for non-exclusive blkdev_get_by_path
        commit: 2ef789288afd365f4245ba97e56189062de5148e
[15/30] block: use the holder as indication for exclusive opens
        commit: 2736e8eeb0ccdc71d1f4256c9c9a28f58cc43307
[16/30] block: add a sb_open_mode helper
        commit: 3f0b3e785e8b54a40c530fa77b7ab37bec925c57
[17/30] fs: remove sb->s_mode
        commit: 81b1fb7d17c0110df839e13468ada9e99bb6e5f4
[18/30] scsi: replace the fmode_t argument to scsi_cmd_allowed with a simple bool
        commit: 5f4eb9d5413fdfc779c099fdaf0ff417eb163145
[19/30] scsi: replace the fmode_t argument to scsi_ioctl with a simple bool
        commit: 2e80089c18241699c41d0af0669cb93844ff0dc1
[20/30] scsi: replace the fmode_t argument to ->sg_io_fn with a simple bool
        commit: 1991299e49fa58c3ba7e91599932f84bf537d592
[21/30] nvme: replace the fmode_t argument to the nvme ioctl handlers with a simple bool
        commit: 7d9d7d59d44b7e9236d168472aa222b6543fae25
[22/30] mtd: block: use a simple bool to track open for write
        commit: 658afed19ceed54a52b9e9e69c0791c8868ff55d
[23/30] rnbd-srv: replace sess->open_flags with a "bool readonly"
        commit: 99b07780814e89f16bec2773c237eb25121f8502
[24/30] ubd: remove commented out code in ubd_open
        commit: bd6abfc8e7898ce2163a1ffdbb9ec71a0a081267
[25/30] block: move a few internal definitions out of blkdev.h
        commit: cfb425761c79b6056ae5bb73f8d400f03b513959
[26/30] block: remove unused fmode_t arguments from ioctl handlers
        commit: 5e4ea834676e3b8965344ca61d36e1ae236249eb
[27/30] block: replace fmode_t with a block-specific type for block open flags
        commit: 05bdb9965305bbfdae79b31d22df03d1e2cfcb22
[28/30] block: always use I_BDEV on file->f_mapping->host to find the bdev
        commit: 4e762d8623448bb9d32711832ce977a65ff7636a
[29/30] block: store the holder in file->private_data
        commit: ee3249a8ce78ef014a71b05157a43fba8dc764e3
[30/30] fs: remove the now unused FMODE_* flags
        commit: 0733ad8002916b9dbbbcfe6e92ad44d2657de1c1

Best regards,
-- 
Jens Axboe



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

