Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE14C04E69
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IISo72FQpfQmNc9oHSyMSoUAZ2Tf1ljiFAlejWOVX68=;
	b=aQq8oCMkKSSR9B2WuOcjrlq6d2OirOw/z0OqsMbdICIVkp2PnzKAChqY4JKEpvVdaBuoNZ
	dFI1UNu+5/cFy45SRq0YK02tzLNr/wIcgh8BbgBOWNjP+yKO08nqYnUTClTXdj/+25RKkM
	2sE99WUnH/lxYO5SAFlr8Bzl0HblgK8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-Uulb6RS0Mku-t5vmRtAUNg-1; Mon, 10 Jul 2023 02:47:15 -0400
X-MC-Unique: Uulb6RS0Mku-t5vmRtAUNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9ABE88711E;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7A304CD0CE;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55E50194E00A;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 34B471946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 11:17:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 112862166B32; Sat, 24 Jun 2023 11:17:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 087DD2166B25
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 11:17:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E17338E44E8
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 11:17:31 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-JZgC3uirNb6vrdU2aiy3Pg-1; Sat, 24 Jun 2023 07:17:29 -0400
X-MC-Unique: JZgC3uirNb6vrdU2aiy3Pg-1
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1b5585e84b4so2535835ad.0
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 04:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687605449; x=1690197449;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=T15O6xQIwkBwwHtvfiEExn4sWPaOJ+WY8Ww0WTBtsp8=;
 b=IsUqoJ87D1kG6dt8GNS7HGA1rgZwI3cbYWaUdAi5WjIrjVP63h86Y89yL7gALIoZwv
 /b51vvH3bB3syFjZvNR0AEZQ68wvV7SZFq25lxTj2tqkJUV8+vYxMimk/xXvHzRu1Lp0
 ROJmjOsLxm5xv1SWMk9ivvUPqXCpgq577477UL04oC8Aa5XXHPcoTR729MxRbluuKtGB
 uv33K+TvVRMaZglAyXGXelSRYAtTJ/qQdws0+gUUSut3tAGZWRQeKqvHZVJB+Y/HpNt1
 NMEopF1Ds3txwheoQ1DVdBceMqFonps7fRRCEHyF6FivA1H61iyIWgrrRrAH29WE+gL1
 ZznQ==
X-Gm-Message-State: AC+VfDy0z1rKsE/E4OWj3zGhTzHtQVWGI5OTKeXhWtfiEX1lHEYHAijZ
 Tmr5EbHrYgS5I/raQ9tnLu7ckw==
X-Google-Smtp-Source: ACHHUZ6FdOiaHAk7I6ISkFgljzCcZyK3aCzvXyKEVanrKS23oGi4259EOvC6Ypj8Kzv6/iuF/wHf7Q==
X-Received: by 2002:a17:902:ecc6:b0:1ae:1364:6086 with SMTP id
 a6-20020a170902ecc600b001ae13646086mr29288550plh.2.1687605448727; 
 Sat, 24 Jun 2023 04:17:28 -0700 (PDT)
Received: from [10.4.162.153] ([139.177.225.251])
 by smtp.gmail.com with ESMTPSA id
 c13-20020a170902d48d00b001ab0a30c895sm1034090plg.202.2023.06.24.04.17.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Jun 2023 04:17:28 -0700 (PDT)
Message-ID: <8107f6d1-2f86-46f1-2b31-263928499ab6@bytedance.com>
Date: Sat, 24 Jun 2023 19:17:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Chuck Lever <cel@kernel.org>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-16-zhengqi.arch@bytedance.com>
 <ZJYTbnmRKF7j3CHW@manet.1015granger.net>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZJYTbnmRKF7j3CHW@manet.1015granger.net>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Chuck,

On 2023/6/24 05:49, Chuck Lever wrote:
> On Thu, Jun 22, 2023 at 04:53:21PM +0800, Qi Zheng wrote:
>> In preparation for implementing lockless slab shrink,
>> we need to dynamically allocate the nfsd-client shrinker,
>> so that it can be freed asynchronously using kfree_rcu().
>> Then it doesn't need to wait for RCU read-side critical
>> section when releasing the struct nfsd_net.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> For 15/29 and 16/29 of this series:
> 
> Acked-by: Chuck Lever <chuck.lever@oracle.com>

Thanks for your review! :)

And I will implement the APIs suggested by Dave in 02/29 in
the v2, so there will be some changes here, but it should
not be much. So I will keep your Acked-bys in the v2.

Thanks,
Qi

> 
> 
>> ---
>>   fs/nfsd/netns.h     |  2 +-
>>   fs/nfsd/nfs4state.c | 20 ++++++++++++--------
>>   2 files changed, 13 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
>> index ec49b200b797..f669444d5336 100644
>> --- a/fs/nfsd/netns.h
>> +++ b/fs/nfsd/netns.h
>> @@ -195,7 +195,7 @@ struct nfsd_net {
>>   	int			nfs4_max_clients;
>>   
>>   	atomic_t		nfsd_courtesy_clients;
>> -	struct shrinker		nfsd_client_shrinker;
>> +	struct shrinker		*nfsd_client_shrinker;
>>   	struct work_struct	nfsd_shrinker_work;
>>   };
>>   
>> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
>> index 6e61fa3acaf1..a06184270548 100644
>> --- a/fs/nfsd/nfs4state.c
>> +++ b/fs/nfsd/nfs4state.c
>> @@ -4388,8 +4388,7 @@ static unsigned long
>>   nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
>>   {
>>   	int count;
>> -	struct nfsd_net *nn = container_of(shrink,
>> -			struct nfsd_net, nfsd_client_shrinker);
>> +	struct nfsd_net *nn = shrink->private_data;
>>   
>>   	count = atomic_read(&nn->nfsd_courtesy_clients);
>>   	if (!count)
>> @@ -8094,14 +8093,19 @@ static int nfs4_state_create_net(struct net *net)
>>   	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
>>   	get_net(net);
>>   
>> -	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
>> -	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
>> -	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
>> -
>> -	if (register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client"))
>> +	nn->nfsd_client_shrinker = shrinker_alloc_and_init(nfsd4_state_shrinker_count,
>> +							   nfsd4_state_shrinker_scan,
>> +							   0, DEFAULT_SEEKS, 0,
>> +							   nn);
>> +	if (!nn->nfsd_client_shrinker)
>>   		goto err_shrinker;
>> +
>> +	if (register_shrinker(nn->nfsd_client_shrinker, "nfsd-client"))
>> +		goto err_register;
>>   	return 0;
>>   
>> +err_register:
>> +	shrinker_free(nn->nfsd_client_shrinker);
>>   err_shrinker:
>>   	put_net(net);
>>   	kfree(nn->sessionid_hashtbl);
>> @@ -8197,7 +8201,7 @@ nfs4_state_shutdown_net(struct net *net)
>>   	struct list_head *pos, *next, reaplist;
>>   	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
>>   
>> -	unregister_shrinker(&nn->nfsd_client_shrinker);
>> +	unregister_and_free_shrinker(nn->nfsd_client_shrinker);
>>   	cancel_work(&nn->nfsd_shrinker_work);
>>   	cancel_delayed_work_sync(&nn->laundromat_work);
>>   	locks_end_grace(&nn->nfsd4_manager);
>> -- 
>> 2.30.2
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

