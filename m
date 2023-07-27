Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161A5C00528
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480542;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JMxXIlkOK65Kc6NerkLZJCNTlBHg3JJanArOfekJVYw=;
	b=Pj+tREXXJxf9mlZgxg8Mw5tzp1MlLVUK2Xaaavf0iiOesKPicJ2UC73dNNdg5lwDvrWnrp
	xBSrMkP31XzlhyCdL6djdfyUfDhJ3llS9kcvxonjyTs8ej7BhY8yW6qFt/rKv4DSXMXGxb
	8ttXJtQcERLnpYCEcSavGuoaOYNuSaQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-686-yC8lHLUMPbiZAdpwIlMeCw-1; Thu, 27 Jul 2023 13:55:39 -0400
X-MC-Unique: yC8lHLUMPbiZAdpwIlMeCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C52A0104459B;
	Thu, 27 Jul 2023 17:55:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A962040C2063;
	Thu, 27 Jul 2023 17:55:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B39819451E5;
	Thu, 27 Jul 2023 17:55:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 067401946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 08:55:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E8F1F492B01; Thu, 27 Jul 2023 08:55:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1642492CA6
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6657185A7A3
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:55:44 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-s-DJsyE6ONGTQ0c3vLPuKA-1; Thu, 27 Jul 2023 04:55:42 -0400
X-MC-Unique: s-DJsyE6ONGTQ0c3vLPuKA-1
Received: by mail-pf1-f181.google.com with SMTP id
 d2e1a72fcca58-6862d4a1376so198459b3a.0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 01:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690448142; x=1691052942;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=WiPjRg1/kjwO6K5zl232SDHPqYtmZOtFvHbsJXMq+7g=;
 b=EVb4dZMSG0k8pG6R87ukq7oNxS25k3qBQp9ARPdXt6WdTCUZqAFvXfc2o/ICJz26xR
 KYIs5xtPrqPIsCyx6Hawd+rHgO7p3vIXpKfXlD7K6RsT19H6qBcRpWW+ytumquGdHFkO
 mNhYdOcvsb3RMxIpm9VJD9CIDuyrB6tz/DPQyxkP0MInwoMKaQXmARCo5XqazLTCJNYG
 owzyt2NLquZdYlC9KNMtW4JKnG7s3MWTDSVXEj4n12MrJ36056mDAYwgxzkDWbbB9LZc
 5IdqBHYssxhvbvJ5EWdv8QYiHsnv/gZs6ietMJgvaZz+SpWpmMEGj7k4rTjhYqgtKCzm
 gF/Q==
X-Gm-Message-State: ABy/qLYCzKUpGRNUNKvZweb9mpLiSo7JiAqYwCKO0tgmVAqkEjKejxy4
 IFMxGSM5kRMPqLAUxFQC93Wr4w==
X-Google-Smtp-Source: APBJJlGwmdjot/rbtwF9nTotnOmqaOAtVmCVUqRrFxhkDx7eGx5gFUYRsJSjv9frk6zdjI0egP1lkA==
X-Received: by 2002:a17:902:e891:b0:1b3:d4bb:3515 with SMTP id
 w17-20020a170902e89100b001b3d4bb3515mr5854967plg.0.1690448141745; 
 Thu, 27 Jul 2023 01:55:41 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 iy15-20020a170903130f00b001bbb1eec92esm1023927plb.281.2023.07.27.01.55.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 27 Jul 2023 01:55:41 -0700 (PDT)
Message-ID: <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
Date: Thu, 27 Jul 2023 16:55:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Damien Le Moal <dlemoal@kernel.org>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
 <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 yujie.liu@intel.com, vbabka@suse.cz, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, tytso@mit.edu, netdev@vger.kernel.org,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi,

On 2023/7/27 16:30, Damien Le Moal wrote:
> On 7/27/23 17:04, Qi Zheng wrote:
>> In preparation for implementing lockless slab shrink, use new APIs to
>> dynamically allocate the dm-zoned-meta shrinker, so that it can be freed
>> asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
>> read-side critical section when releasing the struct dmz_metadata.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>   drivers/md/dm-zoned-metadata.c | 28 ++++++++++++++++------------
>>   1 file changed, 16 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>> index 9d3cca8e3dc9..0bcb26a43578 100644
>> --- a/drivers/md/dm-zoned-metadata.c
>> +++ b/drivers/md/dm-zoned-metadata.c
>> @@ -187,7 +187,7 @@ struct dmz_metadata {
>>   	struct rb_root		mblk_rbtree;
>>   	struct list_head	mblk_lru_list;
>>   	struct list_head	mblk_dirty_list;
>> -	struct shrinker		mblk_shrinker;
>> +	struct shrinker		*mblk_shrinker;
>>   
>>   	/* Zone allocation management */
>>   	struct mutex		map_lock;
>> @@ -615,7 +615,7 @@ static unsigned long dmz_shrink_mblock_cache(struct dmz_metadata *zmd,
>>   static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
>>   					       struct shrink_control *sc)
>>   {
>> -	struct dmz_metadata *zmd = container_of(shrink, struct dmz_metadata, mblk_shrinker);
>> +	struct dmz_metadata *zmd = shrink->private_data;
>>   
>>   	return atomic_read(&zmd->nr_mblks);
>>   }
>> @@ -626,7 +626,7 @@ static unsigned long dmz_mblock_shrinker_count(struct shrinker *shrink,
>>   static unsigned long dmz_mblock_shrinker_scan(struct shrinker *shrink,
>>   					      struct shrink_control *sc)
>>   {
>> -	struct dmz_metadata *zmd = container_of(shrink, struct dmz_metadata, mblk_shrinker);
>> +	struct dmz_metadata *zmd = shrink->private_data;
>>   	unsigned long count;
>>   
>>   	spin_lock(&zmd->mblk_lock);
>> @@ -2936,19 +2936,23 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>>   	 */
>>   	zmd->min_nr_mblks = 2 + zmd->nr_map_blocks + zmd->zone_nr_bitmap_blocks * 16;
>>   	zmd->max_nr_mblks = zmd->min_nr_mblks + 512;
>> -	zmd->mblk_shrinker.count_objects = dmz_mblock_shrinker_count;
>> -	zmd->mblk_shrinker.scan_objects = dmz_mblock_shrinker_scan;
>> -	zmd->mblk_shrinker.seeks = DEFAULT_SEEKS;
>>   
>>   	/* Metadata cache shrinker */
>> -	ret = register_shrinker(&zmd->mblk_shrinker, "dm-zoned-meta:(%u:%u)",
>> -				MAJOR(dev->bdev->bd_dev),
>> -				MINOR(dev->bdev->bd_dev));
>> -	if (ret) {
>> -		dmz_zmd_err(zmd, "Register metadata cache shrinker failed");
>> +	zmd->mblk_shrinker = shrinker_alloc(0,  "dm-zoned-meta:(%u:%u)",
>> +					    MAJOR(dev->bdev->bd_dev),
>> +					    MINOR(dev->bdev->bd_dev));
>> +	if (!zmd->mblk_shrinker) {
>> +		dmz_zmd_err(zmd, "Allocate metadata cache shrinker failed");
> 
> ret is not set here, so dmz_ctr_metadata() will return success. You need to add:
> 		ret = -ENOMEM;
> or something.

Indeed, will fix.

>>   		goto err;
>>   	}
>>   
>> +	zmd->mblk_shrinker->count_objects = dmz_mblock_shrinker_count;
>> +	zmd->mblk_shrinker->scan_objects = dmz_mblock_shrinker_scan;
>> +	zmd->mblk_shrinker->seeks = DEFAULT_SEEKS;
>> +	zmd->mblk_shrinker->private_data = zmd;
>> +
>> +	shrinker_register(zmd->mblk_shrinker);
> 
> I fail to see how this new shrinker API is better... Why isn't there a
> shrinker_alloc_and_register() function ? That would avoid adding all this code
> all over the place as the new API call would be very similar to the current
> shrinker_register() call with static allocation.

In some registration scenarios, memory needs to be allocated in advance.
So we continue to use the previous prealloc/register_prepared()
algorithm. The shrinker_alloc_and_register() is just a helper function
that combines the two, and this increases the number of APIs that
shrinker exposes to the outside, so I choose not to add this helper.

Thanks,
Qi

> 
>> +
>>   	dmz_zmd_info(zmd, "DM-Zoned metadata version %d", zmd->sb_version);
>>   	for (i = 0; i < zmd->nr_devs; i++)
>>   		dmz_print_dev(zmd, i);
>> @@ -2995,7 +2999,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>>    */
>>   void dmz_dtr_metadata(struct dmz_metadata *zmd)
>>   {
>> -	unregister_shrinker(&zmd->mblk_shrinker);
>> +	shrinker_free(zmd->mblk_shrinker);
>>   	dmz_cleanup_metadata(zmd);
>>   	kfree(zmd);
>>   }
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

