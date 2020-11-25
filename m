Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818DBC5519F
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:16:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C57C7208B8
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:16:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C57C7208B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Zi2ECaIbO_-wjo62bikceQ-1; Wed, 25 Nov 2020 02:16:29 -0500
X-MC-Unique: Zi2ECaIbO_-wjo62bikceQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16031101AFC4;
	Wed, 25 Nov 2020 07:16:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBCC65C1A3;
	Wed, 25 Nov 2020 07:16:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD4621809CA2;
	Wed, 25 Nov 2020 07:16:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AP6Bsex016572 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 01:11:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9B7D92026D37; Wed, 25 Nov 2020 06:11:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D532026D35
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 06:11:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEEB1103B805
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 06:11:47 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-292-PQNul98tOjyWEosHsdKdxw-1; Wed, 25 Nov 2020 01:11:42 -0500
X-MC-Unique: PQNul98tOjyWEosHsdKdxw-1
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CgrB346lSzhfQ7;
	Wed, 25 Nov 2020 14:11:23 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
	(10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.487.0;
	Wed, 25 Nov 2020 14:11:36 +0800
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-39-hch@lst.de>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <fec5c478-c7cb-ce29-a35d-3474fae1c96d@huawei.com>
Date: Wed, 25 Nov 2020 14:11:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
	Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-39-hch@lst.de>
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
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
X-Mailman-Approved-At: Wed, 25 Nov 2020 02:15:21 -0500
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Konrad
	Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 38/45] block: switch partition lookup to use
 struct block_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2020/11/24 21:27, Christoph Hellwig wrote:
> Use struct block_device to lookup partitions on a disk.  This removes
> all usage of struct hd_struct from the I/O path, and this allows removing
> the percpu refcount in struct hd_struct.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---
>   block/bio.c                        |  4 +-
>   block/blk-core.c                   | 66 ++++++++++++++----------------
>   block/blk-flush.c                  |  2 +-
>   block/blk-mq.c                     |  9 ++--
>   block/blk-mq.h                     |  7 ++--
>   block/blk.h                        |  4 +-
>   block/genhd.c                      | 56 +++++++++++++------------
>   block/partitions/core.c            |  7 +---
>   drivers/block/drbd/drbd_receiver.c |  2 +-
>   drivers/block/drbd/drbd_worker.c   |  2 +-
>   drivers/block/zram/zram_drv.c      |  2 +-
>   drivers/md/bcache/request.c        |  4 +-
>   drivers/md/dm.c                    |  4 +-
>   drivers/md/md.c                    |  4 +-
>   drivers/nvme/target/admin-cmd.c    | 20 ++++-----
>   fs/ext4/super.c                    | 18 +++-----
>   fs/ext4/sysfs.c                    | 10 +----
>   fs/f2fs/f2fs.h                     |  2 +-
>   fs/f2fs/super.c                    |  6 +--

For f2fs part,

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,

>   include/linux/blkdev.h             |  8 ++--
>   include/linux/genhd.h              |  4 +-
>   include/linux/part_stat.h          | 17 ++++----
>   22 files changed, 120 insertions(+), 138 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

