Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0774C0015E
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6VChOVQK7FL/zsWG6jlbh3OQEW0FnBX8/oDuubMI/y4=;
	b=gqwn+hmGV87j3CZFOgNO4zRM6AmWcic8tqwPgjesdofTR4wBTR00/vslgD9IYNLppTm/5h
	rRrpyHVbZQsFrpGXe9p3VBdsWMlOW64LZx/aaq4uNUf9NKMOs+Ue3mNgSR6+K+PG0Nyu1F
	JLedhhA+xKoRfncbWQKQkoaysOvEIGU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-yVInTxcLNQqmT9PJkJVRog-1; Mon, 10 Jul 2023 02:47:11 -0400
X-MC-Unique: yVInTxcLNQqmT9PJkJVRog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D702C3C11CD7;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1F91F66BA;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBC2D19451D0;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3110194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 21:59:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3B332166B32; Fri, 23 Jun 2023 21:59:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB1E72166B25
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 21:59:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB10B8CC204
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 21:59:47 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-84kNA_0EOkaR0Ypgx7t0LA-1; Fri, 23 Jun 2023 17:59:45 -0400
X-MC-Unique: 84kNA_0EOkaR0Ypgx7t0LA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EC17D60F93;
 Fri, 23 Jun 2023 21:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1671C433C8;
 Fri, 23 Jun 2023 21:49:36 +0000 (UTC)
Date: Fri, 23 Jun 2023 17:49:34 -0400
From: Chuck Lever <cel@kernel.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Message-ID: <ZJYTbnmRKF7j3CHW@manet.1015granger.net>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-16-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
In-Reply-To: <20230622085335.77010-16-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 15/29] NFSD: dynamically allocate the
 nfsd-client shrinker
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev, david@fromorbit.com,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
 paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-nfs@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, vbabka@suse.cz,
 brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 22, 2023 at 04:53:21PM +0800, Qi Zheng wrote:
> In preparation for implementing lockless slab shrink,
> we need to dynamically allocate the nfsd-client shrinker,
> so that it can be freed asynchronously using kfree_rcu().
> Then it doesn't need to wait for RCU read-side critical
> section when releasing the struct nfsd_net.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

For 15/29 and 16/29 of this series:

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
>  fs/nfsd/netns.h     |  2 +-
>  fs/nfsd/nfs4state.c | 20 ++++++++++++--------
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
> index ec49b200b797..f669444d5336 100644
> --- a/fs/nfsd/netns.h
> +++ b/fs/nfsd/netns.h
> @@ -195,7 +195,7 @@ struct nfsd_net {
>  	int			nfs4_max_clients;
>  
>  	atomic_t		nfsd_courtesy_clients;
> -	struct shrinker		nfsd_client_shrinker;
> +	struct shrinker		*nfsd_client_shrinker;
>  	struct work_struct	nfsd_shrinker_work;
>  };
>  
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index 6e61fa3acaf1..a06184270548 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -4388,8 +4388,7 @@ static unsigned long
>  nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	int count;
> -	struct nfsd_net *nn = container_of(shrink,
> -			struct nfsd_net, nfsd_client_shrinker);
> +	struct nfsd_net *nn = shrink->private_data;
>  
>  	count = atomic_read(&nn->nfsd_courtesy_clients);
>  	if (!count)
> @@ -8094,14 +8093,19 @@ static int nfs4_state_create_net(struct net *net)
>  	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
>  	get_net(net);
>  
> -	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
> -	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
> -	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
> -
> -	if (register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client"))
> +	nn->nfsd_client_shrinker = shrinker_alloc_and_init(nfsd4_state_shrinker_count,
> +							   nfsd4_state_shrinker_scan,
> +							   0, DEFAULT_SEEKS, 0,
> +							   nn);
> +	if (!nn->nfsd_client_shrinker)
>  		goto err_shrinker;
> +
> +	if (register_shrinker(nn->nfsd_client_shrinker, "nfsd-client"))
> +		goto err_register;
>  	return 0;
>  
> +err_register:
> +	shrinker_free(nn->nfsd_client_shrinker);
>  err_shrinker:
>  	put_net(net);
>  	kfree(nn->sessionid_hashtbl);
> @@ -8197,7 +8201,7 @@ nfs4_state_shutdown_net(struct net *net)
>  	struct list_head *pos, *next, reaplist;
>  	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
>  
> -	unregister_shrinker(&nn->nfsd_client_shrinker);
> +	unregister_and_free_shrinker(nn->nfsd_client_shrinker);
>  	cancel_work(&nn->nfsd_shrinker_work);
>  	cancel_delayed_work_sync(&nn->laundromat_work);
>  	locks_end_grace(&nn->nfsd4_manager);
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

