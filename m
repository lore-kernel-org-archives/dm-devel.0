Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B0DC04A94
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wpmU/zGac4jtiW8IdN7zZsTl8ajiij8TV0w0Z1Hnex0=;
	b=aut+aiQkRFzGn9TmU5MO9UBiuX9iRuozTV1SAVXBQN4waeycsbRATyaDVVoOtfU1t373Ez
	l1L2qQoQaUJ6PfR9LJSsqycOlwU45F9TcoCQYUWEDfwBIfXlbtp9LqnRToDWUqhFQK/Fd+
	aixkO196PURpGCoknBmUEjs2eGqmS2I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-mUe22AWpOrmpTAMhd9uZOA-1; Thu, 27 Jul 2023 13:55:17 -0400
X-MC-Unique: mUe22AWpOrmpTAMhd9uZOA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71F21185A7A8;
	Thu, 27 Jul 2023 17:55:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CADC201EE6E;
	Thu, 27 Jul 2023 17:55:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A1CC1946A74;
	Thu, 27 Jul 2023 17:54:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B97CB1946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 08:30:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A613246A3A9; Thu, 27 Jul 2023 08:30:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E1EF492C13
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:30:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E6CE8870DD
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:30:10 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-xxcvW3KBMkG4ZvKHenSUAA-1; Thu, 27 Jul 2023 04:30:08 -0400
X-MC-Unique: xxcvW3KBMkG4ZvKHenSUAA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6549661D96;
 Thu, 27 Jul 2023 08:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06711C433C7;
 Thu, 27 Jul 2023 08:30:02 +0000 (UTC)
Message-ID: <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
Date: Thu, 27 Jul 2023 17:30:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Qi Zheng <zhengqi.arch@bytedance.com>, akpm@linux-foundation.org,
 david@fromorbit.com, tkhai@ya.ru, vbabka@suse.cz, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230727080502.77895-29-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
Subject: Re: [dm-devel] [PATCH v3 28/49] dm zoned: dynamically allocate the
 dm-zoned-meta shrinker
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/27/23 17:04, Qi Zheng wrote:
> In preparation for implementing lockless slab shrink, use new APIs to
> dynamically allocate the dm-zoned-meta shrinker, so that it can be freed
> asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
> read-side critical section when releasing the struct dmz_metadata.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 9d3cca8e3dc9..0bcb26a43578 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -187,7 +187,7 @@ struct dmz_metadata {
>  	struct rb_root		mblk_rbtree;
>  	struct list_head	mblk_lru_list;
>  	struct list_head	mblk_dirty_list;
> -	struct shrinker		mblk_shrinker;
> +	struct shrinker		*mblk_shrinker;
>  
>  	/* Zone allocation management */
>  	struct mutex		map_lock;
> @@ -615,7 +615,7 @@ static unsigned long dmz_shrink_mblock_cache(struct dmz_metadata *zmd,
>  static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
>  					       struct shrink_control *sc)
>  {
> -	struct dmz_metadata *zmd = container_of(shrink, struct dmz_metadata, mblk_shrinker);
> +	struct dmz_metadata *zmd = shrink->private_data;
>  
>  	return atomic_read(&zmd->nr_mblks);
>  }
> @@ -626,7 +626,7 @@ static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
>  static unsigned long dmz_mblock_shrinker_scan(struct shrinker *shrink,
>  					      struct shrink_control *sc)
>  {
> -	struct dmz_metadata *zmd = container_of(shrink, struct dmz_metadata, mblk_shrinker);
> +	struct dmz_metadata *zmd = shrink->private_data;
>  	unsigned long count;
>  
>  	spin_lock(&zmd->mblk_lock);
> @@ -2936,19 +2936,23 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>  	 */
>  	zmd->min_nr_mblks = 2 + zmd->nr_map_blocks + zmd->zone_nr_bitmap_blocks * 16;
>  	zmd->max_nr_mblks = zmd->min_nr_mblks + 512;
> -	zmd->mblk_shrinker.count_objects = dmz_mblock_shrinker_count;
> -	zmd->mblk_shrinker.scan_objects = dmz_mblock_shrinker_scan;
> -	zmd->mblk_shrinker.seeks = DEFAULT_SEEKS;
>  
>  	/* Metadata cache shrinker */
> -	ret = register_shrinker(&zmd->mblk_shrinker, "dm-zoned-meta:(%u:%u)",
> -				MAJOR(dev->bdev->bd_dev),
> -				MINOR(dev->bdev->bd_dev));
> -	if (ret) {
> -		dmz_zmd_err(zmd, "Register metadata cache shrinker failed");
> +	zmd->mblk_shrinker = shrinker_alloc(0,  "dm-zoned-meta:(%u:%u)",
> +					    MAJOR(dev->bdev->bd_dev),
> +					    MINOR(dev->bdev->bd_dev));
> +	if (!zmd->mblk_shrinker) {
> +		dmz_zmd_err(zmd, "Allocate metadata cache shrinker failed");

ret is not set here, so dmz_ctr_metadata() will return success. You need to add:
		ret = -ENOMEM;
or something.
>  		goto err;
>  	}
>  
> +	zmd->mblk_shrinker->count_objects = dmz_mblock_shrinker_count;
> +	zmd->mblk_shrinker->scan_objects = dmz_mblock_shrinker_scan;
> +	zmd->mblk_shrinker->seeks = DEFAULT_SEEKS;
> +	zmd->mblk_shrinker->private_data = zmd;
> +
> +	shrinker_register(zmd->mblk_shrinker);

I fail to see how this new shrinker API is better... Why isn't there a
shrinker_alloc_and_register() function ? That would avoid adding all this code
all over the place as the new API call would be very similar to the current
shrinker_register() call with static allocation.

> +
>  	dmz_zmd_info(zmd, "DM-Zoned metadata version %d", zmd->sb_version);
>  	for (i = 0; i < zmd->nr_devs; i++)
>  		dmz_print_dev(zmd, i);
> @@ -2995,7 +2999,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>   */
>  void dmz_dtr_metadata(struct dmz_metadata *zmd)
>  {
> -	unregister_shrinker(&zmd->mblk_shrinker);
> +	shrinker_free(zmd->mblk_shrinker);
>  	dmz_cleanup_metadata(zmd);
>  	kfree(zmd);
>  }

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

