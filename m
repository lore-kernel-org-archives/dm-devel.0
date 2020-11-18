Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23117C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 07:44:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 71AE5246BB
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 07:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71AE5246BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-prr_6GbOOK2AhWZBeGadWQ-1; Thu, 19 Nov 2020 02:44:16 -0500
X-MC-Unique: prr_6GbOOK2AhWZBeGadWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C4951005D50;
	Thu, 19 Nov 2020 07:44:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5806560BE2;
	Thu, 19 Nov 2020 07:44:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E03CF180954D;
	Thu, 19 Nov 2020 07:44:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI8uK1Y019884 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 03:56:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B9FF5B0790; Wed, 18 Nov 2020 08:56:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABF92B17D8
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:56:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD1C980018B
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:56:17 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-503-HBOYj4EGMROfz4xK6pre5w-1;
	Wed, 18 Nov 2020 03:56:13 -0500
X-MC-Unique: HBOYj4EGMROfz4xK6pre5w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E6417AD2F;
	Wed, 18 Nov 2020 08:56:11 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
From: Jan Beulich <jbeulich@suse.com>
Message-ID: <22ca5396-0253-f286-9eab-d417b2e0b3ad@suse.com>
Date: Wed, 18 Nov 2020 09:56:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-1-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 19 Nov 2020 02:44:06 -0500
Cc: linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: Re: [dm-devel] merge struct block_device and struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Christoph,

On 18.11.2020 09:47, Christoph Hellwig wrote:
> Diffstat:
>  block/bio.c                                  |    6 
>  block/blk-cgroup.c                           |   50 +-
>  block/blk-core.c                             |   85 +--
>  block/blk-flush.c                            |    2 
>  block/blk-iocost.c                           |   36 -
>  block/blk-lib.c                              |    2 
>  block/blk-merge.c                            |    6 
>  block/blk-mq.c                               |   11 
>  block/blk-mq.h                               |    5 
>  block/blk.h                                  |   92 ----
>  block/genhd.c                                |  444 +++++---------------
>  block/ioctl.c                                |    7 
>  block/partitions/core.c                      |  238 +++--------
>  drivers/block/drbd/drbd_receiver.c           |    2 
>  drivers/block/drbd/drbd_worker.c             |    2 
>  drivers/block/loop.c                         |   21 
>  drivers/block/nbd.c                          |    6 
>  drivers/block/xen-blkback/common.h           |    4 
>  drivers/block/xen-blkfront.c                 |   20 
>  drivers/block/zram/zram_drv.c                |   20 
>  drivers/md/bcache/request.c                  |    4 
>  drivers/md/bcache/super.c                    |   53 --
>  drivers/md/dm-table.c                        |    9 
>  drivers/md/dm.c                              |   16 
>  drivers/md/md.c                              |    8 
>  drivers/mtd/mtdsuper.c                       |   17 
>  drivers/nvme/target/admin-cmd.c              |   20 
>  drivers/s390/block/dasd.c                    |    8 
>  drivers/s390/block/dasd_ioctl.c              |    9 
>  drivers/scsi/scsicam.c                       |    2 
>  drivers/target/target_core_file.c            |    6 
>  drivers/target/target_core_pscsi.c           |    7 
>  drivers/usb/gadget/function/storage_common.c |    8 
>  fs/block_dev.c                               |  578 ++++++++-------------------
>  fs/btrfs/sysfs.c                             |   15 
>  fs/btrfs/volumes.c                           |   13 
>  fs/ext4/super.c                              |   18 
>  fs/ext4/sysfs.c                              |   10 
>  fs/f2fs/checkpoint.c                         |    5 
>  fs/f2fs/f2fs.h                               |    2 
>  fs/f2fs/super.c                              |    8 
>  fs/f2fs/sysfs.c                              |    9 
>  fs/inode.c                                   |    3 
>  fs/internal.h                                |    7 
>  fs/io_uring.c                                |   10 
>  fs/pipe.c                                    |    5 
>  fs/pstore/blk.c                              |    2 
>  fs/quota/quota.c                             |   40 +
>  fs/statfs.c                                  |    2 
>  fs/super.c                                   |   86 ----
>  include/linux/blk-cgroup.h                   |    4 
>  include/linux/blk_types.h                    |   26 +
>  include/linux/blkdev.h                       |   24 -
>  include/linux/fs.h                           |    5 
>  include/linux/genhd.h                        |  104 ----
>  include/linux/part_stat.h                    |   17 
>  init/do_mounts.c                             |  271 +++++-------
>  kernel/trace/blktrace.c                      |   54 --
>  mm/filemap.c                                 |    9 
>  59 files changed, 837 insertions(+), 1716 deletions(-)

since this isn't the first series from you recently spamming
xen-devel, may I ask that you don't Cc entire series to lists
which are involved with perhaps just one out of the many patches?
IMO Cc lists should be compiled on a per-patch basis; the cover
letter may of course be sent to the union of all of them.

Thanks much,
Jan

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

