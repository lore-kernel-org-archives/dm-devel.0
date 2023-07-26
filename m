Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD702EB64DD
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690438908;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CxEaIM7owwETGNWPgOhNyXp11t8IYpQbKAABGHIEE6c=;
	b=eu1V9dfYGrLEZZ9VHhMNW76GAmrP2xtPX1OuyJ5t2RBbOZb82WdKfhlqN07rvB3qD2om79
	2evohGdn33ReO3GfDE4Iea2ueJ0P14YPv6A3/NcHTkrRnBi2yMTO6PFyjbrTn84/MinRX/
	OIEM+8yJiJfd+TGHICDYXYQd45mmkqE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-1S4gWTiaM1WaZcBxj0rXDw-1; Thu, 27 Jul 2023 02:21:45 -0400
X-MC-Unique: 1S4gWTiaM1WaZcBxj0rXDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2C1388D0F8;
	Thu, 27 Jul 2023 06:21:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD8DF140E949;
	Thu, 27 Jul 2023 06:21:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9561D1946A6E;
	Thu, 27 Jul 2023 06:21:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1ADF1946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 07:10:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC5A81121339; Wed, 26 Jul 2023 07:10:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C52B81121330
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 07:10:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A36F138008AA
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 07:10:54 +0000 (UTC)
Received: from out-60.mta0.migadu.com (out-60.mta0.migadu.com
 [91.218.175.60]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-DfIuI8C2PdCKlSvaSBKU6Q-1; Wed, 26 Jul 2023 03:10:50 -0400
X-MC-Unique: DfIuI8C2PdCKlSvaSBKU6Q-1
Message-ID: <d41d09bc-7c1c-f708-ecfa-ffac59bf58ad@linux.dev>
Date: Wed, 26 Jul 2023 15:10:21 +0800
MIME-Version: 1.0
To: Qi Zheng <zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-20-zhengqi.arch@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230724094354.90817-20-zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 27 Jul 2023 06:20:49 +0000
Subject: Re: [dm-devel] [PATCH v2 19/47] mm: thp: dynamically allocate the
 thp-related shrinkers
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
 linux-bcache@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/7/24 17:43, Qi Zheng wrote:
> Use new APIs to dynamically allocate the thp-zero and thp-deferred_split
> shrinkers.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   mm/huge_memory.c | 69 +++++++++++++++++++++++++++++++-----------------
>   1 file changed, 45 insertions(+), 24 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8c94b34024a2..4db5a1834d81 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -65,7 +65,11 @@ unsigned long transparent_hugepage_flags __read_mostly =
>   	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>   	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>   
> -static struct shrinker deferred_split_shrinker;
> +static struct shrinker *deferred_split_shrinker;
> +static unsigned long deferred_split_count(struct shrinker *shrink,
> +					  struct shrink_control *sc);
> +static unsigned long deferred_split_scan(struct shrinker *shrink,
> +					 struct shrink_control *sc);
>   
>   static atomic_t huge_zero_refcount;
>   struct page *huge_zero_page __read_mostly;
> @@ -229,11 +233,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
>   	return 0;
>   }
>   
> -static struct shrinker huge_zero_page_shrinker = {
> -	.count_objects = shrink_huge_zero_page_count,
> -	.scan_objects = shrink_huge_zero_page_scan,
> -	.seeks = DEFAULT_SEEKS,
> -};
> +static struct shrinker *huge_zero_page_shrinker;

Same as patch #17.

>   
>   #ifdef CONFIG_SYSFS
>   static ssize_t enabled_show(struct kobject *kobj,
> @@ -454,6 +454,40 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
>   }
>   #endif /* CONFIG_SYSFS */
>   
> +static int thp_shrinker_init(void)

Better to declare it as __init.

> +{
> +	huge_zero_page_shrinker = shrinker_alloc(0, "thp-zero");
> +	if (!huge_zero_page_shrinker)
> +		return -ENOMEM;
> +
> +	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
> +						 SHRINKER_MEMCG_AWARE |
> +						 SHRINKER_NONSLAB,
> +						 "thp-deferred_split");
> +	if (!deferred_split_shrinker) {
> +		shrinker_free_non_registered(huge_zero_page_shrinker);
> +		return -ENOMEM;
> +	}
> +
> +	huge_zero_page_shrinker->count_objects = shrink_huge_zero_page_count;
> +	huge_zero_page_shrinker->scan_objects = shrink_huge_zero_page_scan;
> +	huge_zero_page_shrinker->seeks = DEFAULT_SEEKS;
> +	shrinker_register(huge_zero_page_shrinker);
> +
> +	deferred_split_shrinker->count_objects = deferred_split_count;
> +	deferred_split_shrinker->scan_objects = deferred_split_scan;
> +	deferred_split_shrinker->seeks = DEFAULT_SEEKS;
> +	shrinker_register(deferred_split_shrinker);
> +
> +	return 0;
> +}
> +
> +static void thp_shrinker_exit(void)

Same as here.

> +{
> +	shrinker_unregister(huge_zero_page_shrinker);
> +	shrinker_unregister(deferred_split_shrinker);
> +}
> +
>   static int __init hugepage_init(void)
>   {
>   	int err;
> @@ -482,12 +516,9 @@ static int __init hugepage_init(void)
>   	if (err)
>   		goto err_slab;
>   
> -	err = register_shrinker(&huge_zero_page_shrinker, "thp-zero");
> -	if (err)
> -		goto err_hzp_shrinker;
> -	err = register_shrinker(&deferred_split_shrinker, "thp-deferred_split");
> +	err = thp_shrinker_init();
>   	if (err)
> -		goto err_split_shrinker;
> +		goto err_shrinker;
>   
>   	/*
>   	 * By default disable transparent hugepages on smaller systems,
> @@ -505,10 +536,8 @@ static int __init hugepage_init(void)
>   
>   	return 0;
>   err_khugepaged:
> -	unregister_shrinker(&deferred_split_shrinker);
> -err_split_shrinker:
> -	unregister_shrinker(&huge_zero_page_shrinker);
> -err_hzp_shrinker:
> +	thp_shrinker_exit();
> +err_shrinker:
>   	khugepaged_destroy();
>   err_slab:
>   	hugepage_exit_sysfs(hugepage_kobj);
> @@ -2851,7 +2880,7 @@ void deferred_split_folio(struct folio *folio)
>   #ifdef CONFIG_MEMCG
>   		if (memcg)
>   			set_shrinker_bit(memcg, folio_nid(folio),
> -					 deferred_split_shrinker.id);
> +					 deferred_split_shrinker->id);
>   #endif
>   	}
>   	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
> @@ -2925,14 +2954,6 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   	return split;
>   }
>   
> -static struct shrinker deferred_split_shrinker = {
> -	.count_objects = deferred_split_count,
> -	.scan_objects = deferred_split_scan,
> -	.seeks = DEFAULT_SEEKS,
> -	.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
> -		 SHRINKER_NONSLAB,
> -};
> -
>   #ifdef CONFIG_DEBUG_FS
>   static void split_huge_pages_all(void)
>   {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

