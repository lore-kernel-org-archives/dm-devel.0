Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44FDDC41513
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690267397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PNVgmoTMjpL/0Xi6dhQVjMQ6lUjVxNfS+BPJvEqh278=;
	b=MmX4NeymlL0hFAJ848p0WoMq3jQE/FTNCI0hgZBELOVqff90WGkF3TE7P4grL9cYJsnSCC
	ElrHacPbMa4mD3mZa2eCqGQdPqI2eicYztR9u+bbfgLIczVw54Wv919WEjmujLdD9B1zdt
	dSE2Lpkl9d3hP7TIKUuOJBbEpFDpFOM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-Gm0z3PazPqurUQx-1kjfYw-1; Tue, 25 Jul 2023 02:43:13 -0400
X-MC-Unique: Gm0z3PazPqurUQx-1kjfYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1FC8830DC0;
	Tue, 25 Jul 2023 06:42:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFAB4F783B;
	Tue, 25 Jul 2023 06:42:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 980341937761;
	Tue, 25 Jul 2023 06:42:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BEE41946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Jul 2023 03:01:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F41EC2C857; Tue, 25 Jul 2023 03:01:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 474DFC2C856
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 03:01:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 265003806712
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 03:01:25 +0000 (UTC)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-7ROa2QhrO5O7T_Q9PGWKbA-1; Mon, 24 Jul 2023 23:01:22 -0400
X-MC-Unique: 7ROa2QhrO5O7T_Q9PGWKbA-1
Received: by mail-pf1-f182.google.com with SMTP id
 d2e1a72fcca58-682a5465e9eso1177326b3a.1
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 20:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690254081; x=1690858881;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=BOm9JtzAMmxvhoSbX2NtL3QoGfALrOaBCsSuiN3HvS8=;
 b=Xi5EpVZVYgyuup5HkOov9MIBlBYDfnxxbVeXjtG+4bnT9lpZECyrJyVXSDdvCJDL5q
 BTDPWOptu5gCYMJ1Ak92/fdpAtYLKG+HPsg1x5ixS0t0WsULymuKHubUvTkKD/Oi3YvS
 V2+4BxgyCGCSYzuDQfcYAjqvSLhicyrL1UUNEikV03VAn2QTK1jQlKjGnVyfJDwhzj1c
 18wW+CO2RSV6pRDlLmVWCtFpC+gHJQNUikamHhat2/phMi4IO95CpXNmygX0NCrXiYJ9
 JGGIh0FT8Q02bz5qZ50iW5ZIuKrTD5MhQT3IQUM7O9UybcbrIzU3cFuO47qnp2wANJjh
 guyQ==
X-Gm-Message-State: ABy/qLb8u7XqbqBRswYa2SaPntGFu/PxdpSQHMmKyJ3EnodzylOiGlMA
 SCtjA3Vl4gxBALIDVkLM4Xw8hA==
X-Google-Smtp-Source: APBJJlFM6WPSihXOKl0X4zg92CAAfeqIP/jkVagMNd5II31TO+klkQLkXzKhhJFyUFA6pGL+niCVGA==
X-Received: by 2002:a05:6a20:160d:b0:111:a0e5:d2b7 with SMTP id
 l13-20020a056a20160d00b00111a0e5d2b7mr15056320pzj.4.1690254081364; 
 Mon, 24 Jul 2023 20:01:21 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 fe15-20020a056a002f0f00b0066ccb8e8024sm8472563pfb.30.2023.07.24.20.01.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 24 Jul 2023 20:01:20 -0700 (PDT)
Message-ID: <9b149dd9-1617-9af4-4252-6d0df01f93b1@bytedance.com>
Date: Tue, 25 Jul 2023 11:01:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Peter Zijlstra <peterz@infradead.org>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-4-zhengqi.arch@bytedance.com>
 <20230724122549.GA3731903@hirez.programming.kicks-ass.net>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230724122549.GA3731903@hirez.programming.kicks-ass.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 25 Jul 2023 06:42:42 +0000
Subject: Re: [dm-devel] [PATCH v2 03/47] mm: shrinker: add infrastructure
 for dynamically allocating shrinker
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
 linux-arm-msm@vger.kernel.org, linux-nfs@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, brauner@kernel.org, tytso@mit.edu,
 gregkh@linuxfoundation.org, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, senozhatsky@chromium.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Peter,

On 2023/7/24 20:25, Peter Zijlstra wrote:
> On Mon, Jul 24, 2023 at 05:43:10PM +0800, Qi Zheng wrote:
> 
>> +void shrinker_unregister(struct shrinker *shrinker)
>> +{
>> +	struct dentry *debugfs_entry;
>> +	int debugfs_id;
>> +
>> +	if (!shrinker || !(shrinker->flags & SHRINKER_REGISTERED))
>> +		return;
>> +
>> +	down_write(&shrinker_rwsem);
>> +	list_del(&shrinker->list);
>> +	shrinker->flags &= ~SHRINKER_REGISTERED;
>> +	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
>> +		unregister_memcg_shrinker(shrinker);
>> +	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
>> +	up_write(&shrinker_rwsem);
>> +
>> +	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
> 
> Should there not be an rcu_barrier() right about here?

The shrinker_debugfs_remove() will wait for debugfs_file_put() to
return, so when running here, all shrinker debugfs operations have
been completed. And the slab shrink will hold the read lock of
shrinker_rwsem to traverse the shrinker_list, so when we hold the
write lock of shrinker_rwsem to delete the shrinker from the
shrinker_list, the shrinker will not be executed again.

So I think there is no need to add a rcu_barrier() here. Please let
me know if I missed something.

Thanks,
Qi

> 
>> +
>> +	kfree(shrinker->nr_deferred);
>> +	shrinker->nr_deferred = NULL;
>> +
>> +	kfree(shrinker);
>> +}
>> +EXPORT_SYMBOL(shrinker_unregister);
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

