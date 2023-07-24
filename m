Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2638C0015E
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 06:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690267411;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O6V9Yr9vx1M0oUVyKSvmXT6DbWSOGlg9o6S1/ERsrTE=;
	b=eqcV0guGUnX73u+BZCwJ2/hCfRmFOcCcfflIIaIrAwdxzSTRJwx4UPBhxuz9MryRmwS0g8
	SZDvt9DQ7EOW2c6Q2iRnFIZ0vFjs6yIfWhKgd1/7N/lwqoeLFE4GxhEdsqSOAGNn120kh/
	XG8SfJ48OH9mDmAmAlG+D+sxoozgHRg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-sIMPi1JfOY64iZLQ8R2yZg-1; Tue, 25 Jul 2023 02:43:27 -0400
X-MC-Unique: sIMPi1JfOY64iZLQ8R2yZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A81A43C11C8C;
	Tue, 25 Jul 2023 06:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97283F66A0;
	Tue, 25 Jul 2023 06:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CBD71946A50;
	Tue, 25 Jul 2023 06:42:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B07681946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Jul 2023 12:24:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77EC81415115; Mon, 24 Jul 2023 12:24:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F493140E952
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 12:24:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41289185A78F
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 12:24:59 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-uWt2weEzPVC2e11KwuFx3Q-1; Mon, 24 Jul 2023 08:24:57 -0400
X-MC-Unique: uWt2weEzPVC2e11KwuFx3Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 397746113E;
 Mon, 24 Jul 2023 12:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7639DC433C7;
 Mon, 24 Jul 2023 12:17:53 +0000 (UTC)
Message-ID: <d79d3ef43b3a61be99e53a77fa9eb19af7fc550f.camel@kernel.org>
From: Jeff Layton <jlayton@kernel.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>, akpm@linux-foundation.org, 
 david@fromorbit.com, tkhai@ya.ru, vbabka@suse.cz, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu, 
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org, 
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
Date: Mon, 24 Jul 2023 08:17:52 -0400
In-Reply-To: <20230724094354.90817-36-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-36-zhengqi.arch@bytedance.com>
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 25 Jul 2023 06:42:42 +0000
Subject: Re: [dm-devel] [PATCH v2 35/47] nfsd: dynamically allocate the
 nfsd-reply shrinker
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
 linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2023-07-24 at 17:43 +0800, Qi Zheng wrote:
> In preparation for implementing lockless slab shrink, use new APIs to
> dynamically allocate the nfsd-reply shrinker, so that it can be freed
> asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
> read-side critical section when releasing the struct nfsd_net.
> 
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  fs/nfsd/netns.h    |  2 +-
>  fs/nfsd/nfscache.c | 31 ++++++++++++++++---------------
>  2 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
> index f669444d5336..ab303a8b77d5 100644
> --- a/fs/nfsd/netns.h
> +++ b/fs/nfsd/netns.h
> @@ -177,7 +177,7 @@ struct nfsd_net {
>  	/* size of cache when we saw the longest hash chain */
>  	unsigned int             longest_chain_cachesize;
>  
> -	struct shrinker		nfsd_reply_cache_shrinker;
> +	struct shrinker		*nfsd_reply_cache_shrinker;
>  
>  	/* tracking server-to-server copy mounts */
>  	spinlock_t              nfsd_ssc_lock;
> diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
> index 6eb3d7bdfaf3..9f0ab65e4125 100644
> --- a/fs/nfsd/nfscache.c
> +++ b/fs/nfsd/nfscache.c
> @@ -200,26 +200,29 @@ int nfsd_reply_cache_init(struct nfsd_net *nn)
>  {
>  	unsigned int hashsize;
>  	unsigned int i;
> -	int status = 0;
>  
>  	nn->max_drc_entries = nfsd_cache_size_limit();
>  	atomic_set(&nn->num_drc_entries, 0);
>  	hashsize = nfsd_hashsize(nn->max_drc_entries);
>  	nn->maskbits = ilog2(hashsize);
>  
> -	nn->nfsd_reply_cache_shrinker.scan_objects = nfsd_reply_cache_scan;
> -	nn->nfsd_reply_cache_shrinker.count_objects = nfsd_reply_cache_count;
> -	nn->nfsd_reply_cache_shrinker.seeks = 1;
> -	status = register_shrinker(&nn->nfsd_reply_cache_shrinker,
> -				   "nfsd-reply:%s", nn->nfsd_name);
> -	if (status)
> -		return status;
> -
>  	nn->drc_hashtbl = kvzalloc(array_size(hashsize,
>  				sizeof(*nn->drc_hashtbl)), GFP_KERNEL);
>  	if (!nn->drc_hashtbl)
> +		return -ENOMEM;
> +
> +	nn->nfsd_reply_cache_shrinker = shrinker_alloc(0, "nfsd-reply:%s",
> +						       nn->nfsd_name);
> +	if (!nn->nfsd_reply_cache_shrinker)
>  		goto out_shrinker;
>  
> +	nn->nfsd_reply_cache_shrinker->scan_objects = nfsd_reply_cache_scan;
> +	nn->nfsd_reply_cache_shrinker->count_objects = nfsd_reply_cache_count;
> +	nn->nfsd_reply_cache_shrinker->seeks = 1;
> +	nn->nfsd_reply_cache_shrinker->private_data = nn;
> +
> +	shrinker_register(nn->nfsd_reply_cache_shrinker);
> +
>  	for (i = 0; i < hashsize; i++) {
>  		INIT_LIST_HEAD(&nn->drc_hashtbl[i].lru_head);
>  		spin_lock_init(&nn->drc_hashtbl[i].cache_lock);
> @@ -228,7 +231,7 @@ int nfsd_reply_cache_init(struct nfsd_net *nn)
>  
>  	return 0;
>  out_shrinker:
> -	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
> +	kvfree(nn->drc_hashtbl);
>  	printk(KERN_ERR "nfsd: failed to allocate reply cache\n");
>  	return -ENOMEM;
>  }
> @@ -238,7 +241,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
>  	struct nfsd_cacherep *rp;
>  	unsigned int i;
>  
> -	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
> +	shrinker_unregister(nn->nfsd_reply_cache_shrinker);
>  
>  	for (i = 0; i < nn->drc_hashsize; i++) {
>  		struct list_head *head = &nn->drc_hashtbl[i].lru_head;
> @@ -322,8 +325,7 @@ nfsd_prune_bucket_locked(struct nfsd_net *nn, struct nfsd_drc_bucket *b,
>  static unsigned long
>  nfsd_reply_cache_count(struct shrinker *shrink, struct shrink_control *sc)
>  {
> -	struct nfsd_net *nn = container_of(shrink,
> -				struct nfsd_net, nfsd_reply_cache_shrinker);
> +	struct nfsd_net *nn = shrink->private_data;
>  
>  	return atomic_read(&nn->num_drc_entries);
>  }
> @@ -342,8 +344,7 @@ nfsd_reply_cache_count(struct shrinker *shrink, struct shrink_control *sc)
>  static unsigned long
>  nfsd_reply_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
> -	struct nfsd_net *nn = container_of(shrink,
> -				struct nfsd_net, nfsd_reply_cache_shrinker);
> +	struct nfsd_net *nn = shrink->private_data;
>  	unsigned long freed = 0;
>  	LIST_HEAD(dispose);
>  	unsigned int i;

Acked-by: Jeff Layton <jlayton@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

