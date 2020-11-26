Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12C5C6379D
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:01:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 412092145D
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:01:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 412092145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-4mHxXthOP2O6U7vJR917YQ-1; Thu, 26 Nov 2020 12:01:45 -0500
X-MC-Unique: 4mHxXthOP2O6U7vJR917YQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A592B84A5F0;
	Thu, 26 Nov 2020 17:01:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8803F63BA7;
	Thu, 26 Nov 2020 17:01:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58B6C180954D;
	Thu, 26 Nov 2020 17:01:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQH1cJ3028115 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 12:01:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91870114B301; Thu, 26 Nov 2020 17:01:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D53A114B303
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:01:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66D56800157
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:01:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-433-mlOix3w_P7-eKwVrmLB7_Q-1;
	Thu, 26 Nov 2020 12:01:31 -0500
X-MC-Unique: mlOix3w_P7-eKwVrmLB7_Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A8F99ACC4;
	Thu, 26 Nov 2020 17:01:29 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 7DBAB1E10D0; Thu, 26 Nov 2020 18:01:29 +0100 (CET)
Date: Thu, 26 Nov 2020 18:01:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126170129.GT422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-35-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-35-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 34/44] block: move make_it_fail to struct
	block_device
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:04:12, Christoph Hellwig wrote:
> Move the make_it_fail flag to struct block_device an turn it into a bool
> in preparation of killing struct hd_struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/blk-core.c          | 3 ++-
>  block/genhd.c             | 4 ++--
>  include/linux/blk_types.h | 3 +++
>  include/linux/genhd.h     | 3 ---
>  4 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9a3793d5ce38d4..9121390be97a76 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -668,7 +668,8 @@ __setup("fail_make_request=", setup_fail_make_request);
>  
>  static bool should_fail_request(struct hd_struct *part, unsigned int bytes)
>  {
> -	return part->make_it_fail && should_fail(&fail_make_request, bytes);
> +	return part->bdev->bd_make_it_fail &&
> +		should_fail(&fail_make_request, bytes);
>  }
>  
>  static int __init fail_make_request_debugfs(void)
> diff --git a/block/genhd.c b/block/genhd.c
> index a964e7532fedd5..0371558ccde14c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1284,7 +1284,7 @@ ssize_t part_fail_show(struct device *dev,
>  {
>  	struct hd_struct *p = dev_to_part(dev);
>  
> -	return sprintf(buf, "%d\n", p->make_it_fail);
> +	return sprintf(buf, "%d\n", p->bdev->bd_make_it_fail);
>  }
>  
>  ssize_t part_fail_store(struct device *dev,
> @@ -1295,7 +1295,7 @@ ssize_t part_fail_store(struct device *dev,
>  	int i;
>  
>  	if (count > 0 && sscanf(buf, "%d", &i) > 0)
> -		p->make_it_fail = (i == 0) ? 0 : 1;
> +		p->pdev->bd_make_it_fail = (i == 0) ? 0 : 1;
>  
>  	return count;
>  }
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index c0591e52d7d7ce..b237f1e4081405 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -52,6 +52,9 @@ struct block_device {
>  	struct super_block	*bd_fsfreeze_sb;
>  
>  	struct partition_meta_info *bd_meta_info;
> +#ifdef CONFIG_FAIL_MAKE_REQUEST
> +	bool			bd_make_it_fail;
> +#endif
>  } __randomize_layout;
>  
>  #define bdev_whole(_bdev) \
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index b4a5c05593b99c..349cf6403ccddc 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -56,9 +56,6 @@ struct hd_struct {
>  	struct block_device *bdev;
>  	struct device __dev;
>  	int policy, partno;
> -#ifdef CONFIG_FAIL_MAKE_REQUEST
> -	int make_it_fail;
> -#endif
>  	struct rcu_work rcu_work;
>  };
>  
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

