Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8084AC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:44:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0074C60FC3
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:44:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0074C60FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-5e6QCTkvP-mDk4tDNWFqxA-1; Wed, 11 Aug 2021 20:44:25 -0400
X-MC-Unique: 5e6QCTkvP-mDk4tDNWFqxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4030B760C6;
	Thu, 12 Aug 2021 00:44:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75CF8620DE;
	Thu, 12 Aug 2021 00:44:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A3D924BB7C;
	Thu, 12 Aug 2021 00:44:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17C0iCDP017047 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 20:44:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 39F0910FAD3; Thu, 12 Aug 2021 00:44:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3537010FAD5
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 00:44:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77EC8101A529
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 00:44:09 +0000 (UTC)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-572-pMk9Bn-YMOmJX_C-e9qjAA-1;
	Wed, 11 Aug 2021 20:44:06 -0400
X-MC-Unique: pMk9Bn-YMOmJX_C-e9qjAA-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
	snitzer@redhat.com
References: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
Message-ID: <318fe9e7-1136-5716-f600-709f1fe321d8@linux.dev>
Date: Thu, 12 Aug 2021 08:43:54 +0800
MIME-Version: 1.0
In-Reply-To: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] block: move some macros to blkdev.h
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Gentle ping ...

On 7/21/21 10:53 AM, Guoqing Jiang wrote:
> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
>
> Move them (PAGE_SECTORS_SHIFT, PAGE_SECTORS and SECTOR_MASK) to the
> generic header file to remove redundancy.
>
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> ---
>   drivers/block/brd.c           | 3 ---
>   drivers/block/null_blk/main.c | 4 ----
>   drivers/md/bcache/util.h      | 2 --
>   include/linux/blkdev.h        | 4 ++++
>   include/linux/device-mapper.h | 1 -
>   5 files changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 95694113e38e..58ec167aa018 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -27,9 +27,6 @@
>   
>   #include <linux/uaccess.h>
>   
> -#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
> -#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
> -
>   /*
>    * Each block ramdisk device has a radix_tree brd_pages of pages that stores
>    * the pages containing the block device's contents. A brd page's ->index is
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index d734e9ee1546..f128242d1170 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -11,10 +11,6 @@
>   #include <linux/init.h>
>   #include "null_blk.h"
>   
> -#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
> -#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
> -#define SECTOR_MASK		(PAGE_SECTORS - 1)
> -
>   #define FREE_BATCH		16
>   
>   #define TICKS_PER_SEC		50ULL
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index bca4a7c97da7..b64460a76267 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -15,8 +15,6 @@
>   
>   #include "closure.h"
>   
> -#define PAGE_SECTORS		(PAGE_SIZE / 512)
> -
>   struct closure;
>   
>   #ifdef CONFIG_BCACHE_DEBUG
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3177181c4326..0d0b6967c954 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -941,6 +941,10 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>   #define SECTOR_SIZE (1 << SECTOR_SHIFT)
>   #endif
>   
> +#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
> +#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
> +#define SECTOR_MASK		(PAGE_SECTORS - 1)
> +
>   /*
>    * blk_rq_pos()			: the current sector
>    * blk_rq_bytes()		: bytes left in the entire request
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 7457d49acf9a..94f2cd6a8e83 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -151,7 +151,6 @@ typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
>   		void *addr, size_t bytes, struct iov_iter *i);
>   typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
>   		size_t nr_pages);
> -#define PAGE_SECTORS (PAGE_SIZE / 512)
>   
>   void dm_error(const char *message);
>   

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

