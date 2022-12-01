Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67160C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 02:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669860677;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5hz9fzEcSa05ui0lzVuZi5VrtcgtIFre7lMyFJJ2G+o=;
	b=IL1AtCU9ywE34csuHKMpd+GQfOIHSXrQWCnKKZB8D8fIjygzSbWZWBh9p/4//QQ9mDI10k
	2H+CCZfw2tM9aHvBigDzBVhs760SYcYrwima+2foy3Lii6gryhP7cvpw0jLOh7UceoskyO
	Gg5OLxHhwj1njvcj2ZprEL+2cKwvZd4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-1MkAMDVgN3yb5jb2InVc0Q-1; Wed, 30 Nov 2022 21:11:14 -0500
X-MC-Unique: 1MkAMDVgN3yb5jb2InVc0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 947C2802804;
	Thu,  1 Dec 2022 02:11:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8492D4EA4E;
	Thu,  1 Dec 2022 02:11:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3CBD219465A0;
	Thu,  1 Dec 2022 02:11:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF4461946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 02:11:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0B5B2024CBE; Thu,  1 Dec 2022 02:11:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9B712024CC0
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 02:11:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A801185A792
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 02:11:09 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-8icVInLjPjOI9zuTC-xiGQ-1; Wed, 30 Nov 2022 21:11:05 -0500
X-MC-Unique: 8icVInLjPjOI9zuTC-xiGQ-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NN00C2S1xzmVtn;
 Thu,  1 Dec 2022 10:10:19 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 10:11:00 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 10:10:59 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20221130133134.2870646-1-chengzhihao1@huawei.com>
 <Y4eE4HVuXQZY4AMv@redhat.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <dc77578e-3fbc-d3f7-d38b-bd4ad34c09ee@huawei.com>
Date: Thu, 1 Dec 2022 10:10:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <Y4eE4HVuXQZY4AMv@redhat.com>
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v3] dm thin: Fix ABBA deadlock between
 shrink_slab and dm_pool_abort_metadata
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
Cc: jack@suse.cz, dm-devel@redhat.com, yi.zhang@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, ejt@redhat.com, Martin.Wilck@suse.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

> On Wed, Nov 30 2022 at  8:31P -0500
> Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> 
>> Following concurrent processes:
>>
>>            P1(drop cache)                P2(kworker)
[...]
>> 2.31.1
>>
> 
> I've picked your patch up and folded into these following changes:
> 
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 7729372519b8..1a62226ac34e 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -776,12 +776,15 @@ static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool f
>   	return r;
>   }
>   
> -static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd)
> +static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd,
> +					      bool destroy_bm)
>   {
>   	dm_sm_destroy(pmd->data_sm);
>   	dm_sm_destroy(pmd->metadata_sm);
>   	dm_tm_destroy(pmd->nb_tm);
>   	dm_tm_destroy(pmd->tm);
> +	if (destroy_bm)
> +		dm_block_manager_destroy(pmd->bm);
>   }
>   
>   static int __begin_transaction(struct dm_pool_metadata *pmd)
> @@ -987,10 +990,8 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
>   			       __func__, r);
>   	}
>   	pmd_write_unlock(pmd);
> -	if (!pmd->fail_io) {
> -		__destroy_persistent_data_objects(pmd);
> -		dm_block_manager_destroy(pmd->bm);
> -	}
> +	if (!pmd->fail_io)
> +		__destroy_persistent_data_objects(pmd, true);
>   
>   	kfree(pmd);
>   	return 0;
> @@ -1863,9 +1864,16 @@ int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
>   	int r = -EINVAL;
>   	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
>   
> -	if (pmd->fail_io)
> -		return -EINVAL;
> +	/* fail_io is double-checked with pmd->root_lock held below */
> +	if (unlikely(pmd->fail_io))
> +		return r;
>   
> +	/*
> +	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
> +	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
> +	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
> +	 * - must take shrinker_rwsem without holding pmd->root_lock
> +	 */
>   	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
>   					 THIN_MAX_CONCURRENT_LOCKS);
>   
> @@ -1876,11 +1884,10 @@ int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
>   	}
>   
>   	__set_abort_with_changes_flags(pmd);
> -	__destroy_persistent_data_objects(pmd);
> +	__destroy_persistent_data_objects(pmd, false);
>   	old_bm = pmd->bm;
>   	if (IS_ERR(new_bm)) {
> -		/* Return back if creating dm_block_manager failed. */
> -		DMERR("could not create block manager");
> +		DMERR("could not create block manager during abort");
>   		pmd->bm = NULL;
>   		r = PTR_ERR(new_bm);
>   		goto out_unlock;
> 

Hi,Mike
This version is great, thanks for reviewing and modifying.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

