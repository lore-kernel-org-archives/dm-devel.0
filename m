Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075F1C0015E
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 06:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690438895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a57d3znJSo8EcqJ93oqc71boLImVW6jmK9hhYCexkpI=;
	b=KLAk8kwPRL8HjvGXo8CpuoNxq8qDjFx6WPQLpf8gLHrY533/Suj/vsp+UkaVZu3OiGIdHi
	0JkjZoaYDPNLjqYwGJxJQ1tKwz02mbpdve1EnkC6yJVcZ7BXcp0p1YA6r88WqEWhvSZFGk
	kcVSnnDP8WUA39fGgTaTBze/7bBkUHY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-MnioQ-nfNSuZjgtndnPnyw-1; Thu, 27 Jul 2023 02:21:31 -0400
X-MC-Unique: MnioQ-nfNSuZjgtndnPnyw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F4F1381494D;
	Thu, 27 Jul 2023 06:21:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DF4B492B02;
	Thu, 27 Jul 2023 06:21:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D93E19452C4;
	Thu, 27 Jul 2023 06:21:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 23CCC1946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 06:49:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 034E9492CAC; Wed, 26 Jul 2023 06:49:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF2CC492B01
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 06:49:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D296D3C0E44F
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 06:49:21 +0000 (UTC)
Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com
 [91.218.175.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-fVFZPohLOcy66Gn1PAZCOA-1; Wed, 26 Jul 2023 02:49:20 -0400
X-MC-Unique: fVFZPohLOcy66Gn1PAZCOA-1
Message-ID: <e7204276-9de5-17eb-90ae-e51657d73ef4@linux.dev>
Date: Wed, 26 Jul 2023 14:49:05 +0800
MIME-Version: 1.0
To: Qi Zheng <zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-12-zhengqi.arch@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230724094354.90817-12-zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 27 Jul 2023 06:20:49 +0000
Subject: Re: [dm-devel] [PATCH v2 11/47] gfs2: dynamically allocate the
 gfs2-qd shrinker
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/7/24 17:43, Qi Zheng wrote:
> Use new APIs to dynamically allocate the gfs2-qd shrinker.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   fs/gfs2/main.c  |  6 +++---
>   fs/gfs2/quota.c | 26 ++++++++++++++++++++------
>   fs/gfs2/quota.h |  3 ++-
>   3 files changed, 25 insertions(+), 10 deletions(-)
>
> diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
> index afcb32854f14..e47b1cc79f59 100644
> --- a/fs/gfs2/main.c
> +++ b/fs/gfs2/main.c
> @@ -147,7 +147,7 @@ static int __init init_gfs2_fs(void)
>   	if (!gfs2_trans_cachep)
>   		goto fail_cachep8;
>   
> -	error = register_shrinker(&gfs2_qd_shrinker, "gfs2-qd");
> +	error = gfs2_qd_shrinker_init();
>   	if (error)
>   		goto fail_shrinker;
>   
> @@ -196,7 +196,7 @@ static int __init init_gfs2_fs(void)
>   fail_wq2:
>   	destroy_workqueue(gfs_recovery_wq);
>   fail_wq1:
> -	unregister_shrinker(&gfs2_qd_shrinker);
> +	gfs2_qd_shrinker_exit();
>   fail_shrinker:
>   	kmem_cache_destroy(gfs2_trans_cachep);
>   fail_cachep8:
> @@ -229,7 +229,7 @@ static int __init init_gfs2_fs(void)
>   
>   static void __exit exit_gfs2_fs(void)
>   {
> -	unregister_shrinker(&gfs2_qd_shrinker);
> +	gfs2_qd_shrinker_exit();
>   	gfs2_glock_exit();
>   	gfs2_unregister_debugfs();
>   	unregister_filesystem(&gfs2_fs_type);
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 704192b73605..bc9883cea847 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -186,13 +186,27 @@ static unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
>   	return vfs_pressure_ratio(list_lru_shrink_count(&gfs2_qd_lru, sc));
>   }
>   
> -struct shrinker gfs2_qd_shrinker = {
> -	.count_objects = gfs2_qd_shrink_count,
> -	.scan_objects = gfs2_qd_shrink_scan,
> -	.seeks = DEFAULT_SEEKS,
> -	.flags = SHRINKER_NUMA_AWARE,
> -};
> +static struct shrinker *gfs2_qd_shrinker;
> +
> +int gfs2_qd_shrinker_init(void)

It's better to declare this as __init.

> +{
> +	gfs2_qd_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "gfs2-qd");
> +	if (!gfs2_qd_shrinker)
> +		return -ENOMEM;
> +
> +	gfs2_qd_shrinker->count_objects = gfs2_qd_shrink_count;
> +	gfs2_qd_shrinker->scan_objects = gfs2_qd_shrink_scan;
> +	gfs2_qd_shrinker->seeks = DEFAULT_SEEKS;
> +
> +	shrinker_register(gfs2_qd_shrinker);
>   
> +	return 0;
> +}
> +
> +void gfs2_qd_shrinker_exit(void)
> +{
> +	shrinker_unregister(gfs2_qd_shrinker);
> +}
>   
>   static u64 qd2index(struct gfs2_quota_data *qd)
>   {
> diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
> index 21ada332d555..f9cb863373f7 100644
> --- a/fs/gfs2/quota.h
> +++ b/fs/gfs2/quota.h
> @@ -59,7 +59,8 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip,
>   }
>   
>   extern const struct quotactl_ops gfs2_quotactl_ops;
> -extern struct shrinker gfs2_qd_shrinker;
> +int gfs2_qd_shrinker_init(void);
> +void gfs2_qd_shrinker_exit(void);
>   extern struct list_lru gfs2_qd_lru;
>   extern void __init gfs2_quota_hash_init(void);
>   

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

