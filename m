Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785AFC7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686141105;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O4YGeb48m8Hdk6UUstc/WktK73/WX3nZooXBFW/PKLc=;
	b=N1eHkn0P+xV2i35sAwNhz1nGcg+jNCbCfNNra+LmCAI2lFH5GWQfR0cG95J9KB6hsrcSBT
	0XXbqQasoD27MNP7LlcUY35VDwqZTFWPbDu5sG48mq2cKbt2Q/WNzp+HvAXDybDoP4AOko
	DnjycshMQ47jsbxOyhI7IXxTGGJnQuA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-SxNLID8vMWCr9WSdxhIpTQ-1; Wed, 07 Jun 2023 08:31:43 -0400
X-MC-Unique: SxNLID8vMWCr9WSdxhIpTQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48BB68032F1;
	Wed,  7 Jun 2023 12:31:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 388B0477F61;
	Wed,  7 Jun 2023 12:31:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0522319452C6;
	Wed,  7 Jun 2023 12:31:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9A09D19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 12:29:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A2A240CFD46; Wed,  7 Jun 2023 12:29:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82D2F40CFD47
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:29:10 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C5298030D2
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:29:10 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-gmeCHibVMJaglDNgabbGcA-1; Wed,
 07 Jun 2023 08:29:08 -0400
X-MC-Unique: gmeCHibVMJaglDNgabbGcA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 9B91C219E0;
 Wed,  7 Jun 2023 12:29:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 520DB13776;
 Wed,  7 Jun 2023 12:29:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id cBHGEhN4gGTwRQAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 07 Jun 2023 12:29:07 +0000
Message-ID: <a17bacdb-3fa2-3b81-8852-efc06f788885@suse.de>
Date: Wed, 7 Jun 2023 14:29:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-17-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230606073950.225178-17-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 16/31] block: use the holder as indication
 for exclusive opens
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/6/23 09:39, Christoph Hellwig wrote:
> The current interface for exclusive opens is rather confusing as it
> requires both the FMODE_EXCL flag and a holder.  Remove the need to pass
> FMODE_EXCL and just key off the exclusive open off a non-NULL holder.
> 
> For blkdev_put this requires adding the holder argument, which provides
> better debug checking that only the holder actually releases the hold,
> but at the same time allows removing the now superfluous mode argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bdev.c                        | 37 ++++++++++++++++------------
>   block/fops.c                        |  6 +++--
>   block/genhd.c                       |  5 ++--
>   block/ioctl.c                       |  5 ++--
>   drivers/block/drbd/drbd_nl.c        | 23 ++++++++++-------
>   drivers/block/pktcdvd.c             | 13 +++++-----
>   drivers/block/rnbd/rnbd-srv.c       |  4 +--
>   drivers/block/xen-blkback/xenbus.c  |  2 +-
>   drivers/block/zram/zram_drv.c       |  8 +++---
>   drivers/md/bcache/super.c           | 15 ++++++------
>   drivers/md/dm.c                     |  6 ++---
>   drivers/md/md.c                     | 38 +++++++++++++++--------------
>   drivers/mtd/devices/block2mtd.c     |  4 +--
>   drivers/nvme/target/io-cmd-bdev.c   |  2 +-
>   drivers/s390/block/dasd_genhd.c     |  2 +-
>   drivers/target/target_core_iblock.c |  6 ++---
>   drivers/target/target_core_pscsi.c  |  8 +++---
>   fs/btrfs/dev-replace.c              |  6 ++---
>   fs/btrfs/ioctl.c                    | 12 ++++-----
>   fs/btrfs/volumes.c                  | 28 ++++++++++-----------
>   fs/btrfs/volumes.h                  |  6 ++---
>   fs/erofs/super.c                    |  7 +++---
>   fs/ext4/super.c                     | 11 +++------
>   fs/f2fs/super.c                     |  2 +-
>   fs/jfs/jfs_logmgr.c                 |  6 ++---
>   fs/nfs/blocklayout/dev.c            |  4 +--
>   fs/nilfs2/super.c                   |  6 ++---
>   fs/ocfs2/cluster/heartbeat.c        |  4 +--
>   fs/reiserfs/journal.c               | 19 +++++++--------
>   fs/reiserfs/reiserfs.h              |  1 -
>   fs/super.c                          | 20 +++++++--------
>   fs/xfs/xfs_super.c                  | 15 ++++++------
>   include/linux/blkdev.h              |  2 +-
>   kernel/power/hibernate.c            | 12 +++------
>   kernel/power/power.h                |  2 +-
>   kernel/power/swap.c                 | 21 +++++++---------
>   mm/swapfile.c                       |  7 +++---
>   37 files changed, 183 insertions(+), 192 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

