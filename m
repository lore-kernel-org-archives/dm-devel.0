Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE62DC001DF
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971631;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=02cvu0yx5pi4sSEv1JTzo+5YAdbMLBkn9qsh55kbtUA=;
	b=Rc9xQUi/hmzwKnpd1OXcKzcQjLB4hTk4mU4HwvpVfGJhST+tv4chqIZkHZf8pshZ0FW5N8
	XqJ8eGl5/rulYymFg6YN6Nz9dm6RzU3hJcjgr6J/FaUTQI0rXQkZogM4nziEqHYdWKRLOL
	0RNdEElG2smvFV3FkgCN02opNECqnVo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-XwnslzCSM-iHY7bR5_saBQ-1; Mon, 10 Jul 2023 02:47:05 -0400
X-MC-Unique: XwnslzCSM-iHY7bR5_saBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74BD738149BA;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 58BB2C5760A;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E056319451F6;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C32B61946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 13:24:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9DEFD14682F7; Fri, 23 Jun 2023 13:24:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 961B614682FD
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:24:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B908104458C
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:24:38 +0000 (UTC)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com
 [209.85.166.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-Um-7Xz2iNe26xU74HhIrlw-1; Fri, 23 Jun 2023 09:24:36 -0400
X-MC-Unique: Um-7Xz2iNe26xU74HhIrlw-1
Received: by mail-io1-f54.google.com with SMTP id
 ca18e2360f4ac-780c89d1998so2499239f.1
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687526676; x=1690118676;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=gz92l7DBmLTrf6935v1JTyj18AL7FL04QRL4qQAWqJU=;
 b=CTYXL1uNagl/b928PLJ7EWGiqc/BPJZN+z0Pq83HgOssuxsjVmxXtSMvkVouotXrLk
 /yJcyr9/1yr8l/iFe705KJgoXxrQtZuw9jmjFFsTScHXEphGC+DymbhSBeVI3zxLDSsW
 F5fRJPGaHHwyYGZnJuIST7rT3W0VCGQIk0SYzY7IFgeNYuYF7arNwPRDPDjCBJ7Y/dmn
 o5vCo/H9/e4hZHb+tjYysLWfdXNK59JGe6L7uR5jbkAmlXToneJGFcsNttn0C8Rr0XRe
 ZBtOSinSve2xsGmZ980GQGODpueVKIYKPkpBmlruS+AVeAzekJOwqw7f2ZmYvU6HAGz9
 dURQ==
X-Gm-Message-State: AC+VfDwXAQaOjQNMyXaOx/RYCB+PbjQWfqV9bp2XOM27Vem4Skd6JnXa
 WRfVwmFg6bvM9AxovU0CmxDTdw==
X-Google-Smtp-Source: ACHHUZ5gEbRKgAaE+N8YtReVmyo3V0rllQa6wCPNTx2RvtSftj/ir5NFrmfS2AckYJcn//Bnc41ZpQ==
X-Received: by 2002:a6b:1581:0:b0:780:c6bb:ad8d with SMTP id
 123-20020a6b1581000000b00780c6bbad8dmr5508761iov.0.1687526676020; 
 Fri, 23 Jun 2023 06:24:36 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 w5-20020a17090a380500b0025bcdada95asm1562852pjb.38.2023.06.23.06.24.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Jun 2023 06:24:35 -0700 (PDT)
Message-ID: <f8d924e7-8faf-438d-4d2f-5f806ef88a49@bytedance.com>
Date: Fri, 23 Jun 2023 21:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-30-zhengqi.arch@bytedance.com>
 <20230623052554.GA11471@google.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230623052554.GA11471@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 29/29] mm: shrinker: move shrinker-related
 code into a separate file
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Sergey,

On 2023/6/23 13:25, Sergey Senozhatsky wrote:
> On (23/06/22 16:53), Qi Zheng wrote:
>> +/*
>> + * Remove one
>> + */
>> +void unregister_shrinker(struct shrinker *shrinker)
>> +{
>> +	struct dentry *debugfs_entry;
>> +	int debugfs_id;
>> +
>> +	if (!(shrinker->flags & SHRINKER_REGISTERED))
>> +		return;
>> +
>> +	shrinker_put(shrinker);
>> +	wait_for_completion(&shrinker->completion_wait);
>> +
>> +	mutex_lock(&shrinker_mutex);
>> +	list_del_rcu(&shrinker->list);
> 
> Should this function wait for RCU grace period(s) before it goes
> touching shrinker fields?

Why? We will free this shrinker instance by rcu after executing
unregister_shrinker(). So it is safe to touch shrinker fields here.

> 
>> +	shrinker->flags &= ~SHRINKER_REGISTERED;
>> +	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
>> +		unregister_memcg_shrinker(shrinker);
>> +	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
>> +	mutex_unlock(&shrinker_mutex);
>> +
>> +	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
>> +
>> +	kfree(shrinker->nr_deferred);
>> +	shrinker->nr_deferred = NULL;
>> +}
>> +EXPORT_SYMBOL(unregister_shrinker);
> 
> [..]
> 
>> +void shrinker_free(struct shrinker *shrinker)
>> +{
>> +	kfree(shrinker);
>> +}
>> +EXPORT_SYMBOL(shrinker_free);
>> +
>> +void unregister_and_free_shrinker(struct shrinker *shrinker)
>> +{
>> +	unregister_shrinker(shrinker);
>> +	kfree_rcu(shrinker, rcu);
>> +}
> 
> Seems like this
> 
> 	unregister_shrinker();
> 	shrinker_free();
> 
> is not exact equivalent of this
> 
> 	unregister_and_free_shrinker();

Yes, my original intention is that shrinker_free() is only used to
handle the case where register_shrinker() returns failure.

I will implement the method suggested by Dave in 02/29. Those APIs are
more concise and will bring more benefits. :)

Thanks,
Qi



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

