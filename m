Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CED1C64E75
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:16:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 66E7420B80
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66E7420B80
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-VBI0KvnzPMiKsFk1GrGhNw-1; Wed, 25 Nov 2020 02:16:23 -0500
X-MC-Unique: VBI0KvnzPMiKsFk1GrGhNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC7831009464;
	Wed, 25 Nov 2020 07:16:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF1D35C1A3;
	Wed, 25 Nov 2020 07:16:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A56475002E;
	Wed, 25 Nov 2020 07:16:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AP6AZ7P016475 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 01:10:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BEE56A37AA; Wed, 25 Nov 2020 06:10:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B903BA37AC
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 06:10:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99D74800B3B
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 06:10:33 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-477-PiiSPlw9N2CjXsEmOO6sxw-1; Wed, 25 Nov 2020 01:10:29 -0500
X-MC-Unique: PiiSPlw9N2CjXsEmOO6sxw-1
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cgr8c4ZrLzhYVP;
	Wed, 25 Nov 2020 14:10:08 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
	(10.3.19.209) with Microsoft SMTP Server (TLS) id 14.3.487.0;
	Wed, 25 Nov 2020 14:10:21 +0800
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-31-hch@lst.de>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <fe5b2763-a7c7-98dd-d87e-d3fa6767eebb@huawei.com>
Date: Wed, 25 Nov 2020 14:10:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
	Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-31-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
Subject: Re: [dm-devel] [PATCH 30/45] block: remove the nr_sects field in
 struct hd_struct
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
> Now that the hd_struct always has a block device attached to it, there is
> no need for having two size field that just get out of sync.
> 
> Additional the field in hd_struct did not use proper serializiation,
> possibly allowing for torn writes.  By only using the block_device field
> this problem also gets fixed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   block/bio.c                        |  4 +-
>   block/blk-core.c                   |  2 +-
>   block/blk.h                        | 53 ----------------------
>   block/genhd.c                      | 55 +++++++++++-----------
>   block/partitions/core.c            | 17 ++++---
>   drivers/block/loop.c               |  1 -
>   drivers/block/nbd.c                |  2 +-
>   drivers/block/xen-blkback/common.h |  4 +-
>   drivers/md/bcache/super.c          |  2 +-
>   drivers/s390/block/dasd_ioctl.c    |  4 +-
>   drivers/target/target_core_pscsi.c |  7 +--
>   fs/block_dev.c                     | 73 +-----------------------------
>   fs/f2fs/super.c                    |  2 +-

For f2fs part,

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,

>   fs/pstore/blk.c                    |  2 +-
>   include/linux/genhd.h              | 29 +++---------
>   kernel/trace/blktrace.c            |  2 +-
>   16 files changed, 60 insertions(+), 199 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

