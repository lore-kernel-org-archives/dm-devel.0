Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC74C41513
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jul 2023 06:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690786135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LBy7l3Oih2zLcLGDmsTMBluJzntoPgMC93zlC09Fabg=;
	b=IHK2/77h+0z0PRAaOcwA1hJOLTTBvm743eWzB39DC2XC2LOjQa3cL5YIE2oh2+6RxIdfpf
	0wNqnWcZiHXF12CqTYyQLRfVMLR4MBdIzrocEgWCafkmyNIpMqkkpZF1Y8bq+s64th9pGK
	UUDi57qPZ5KP+bPDO8q+LLy5yJgreYU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-689-G5cTNrxrP7KBGSbE7PhH9g-1; Mon, 31 Jul 2023 02:48:52 -0400
X-MC-Unique: G5cTNrxrP7KBGSbE7PhH9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94EDD3C0F676;
	Mon, 31 Jul 2023 06:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DECC40D2839;
	Mon, 31 Jul 2023 06:48:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FA411946594;
	Mon, 31 Jul 2023 06:48:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C3B11946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Jul 2023 08:19:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73FBA1121330; Fri, 28 Jul 2023 08:19:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C1821120AC7
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 08:19:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9E6D185A78B
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 08:19:20 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-dMqUKm9hNk6WnDF1zml8DA-1; Fri, 28 Jul 2023 04:19:16 -0400
X-MC-Unique: dMqUKm9hNk6WnDF1zml8DA-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-6862d4a1376so444352b3a.0
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 01:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690532355; x=1691137155;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0Vz5i3f1KwBqEHtOj3kkD+u+idA4hMEDLOXYQ/Zmb7I=;
 b=Qs2vz489R7c+QcfJ23lL9wx+bfuFnheRhxfHv4AeCra5Rlnc1uCQVCQeeB7YiA3Bqs
 N8L3yjJEqVROLsUqnPfoloZndNaDB1w2zHsnXK+143T0xUI7hqZshEnxDD22N+obQpNv
 a3iZePyg/QJ9SwqOMiY+eNlP6HuCbl7ySyGlMs18m6d+rEyLqsBGNZ4cA6QcLEcr9K8+
 I37aalrKN/2SMgrp8c3GvoOCP+ak1bZUDUTuob1nkyGriW8Ucq4WE3R/7a8tzbZut2Dm
 W65JzAJxcWzq8dmhbS8SQq27IqIJ+Am8f051luFL1r0TT3m9yVaB8WRPGx+/ouJFoWpr
 mDLg==
X-Gm-Message-State: ABy/qLblogxZI3ElZQsTVCUsseidpaXnYgJnfr5VU2t23SWHETPP/38u
 S4h9iz3imfcn3TNd2UWOYpS6wQ==
X-Google-Smtp-Source: APBJJlFUUUMvBrf6ibd1LKjgOpEN2XEkSNdXdEqaA3c50PeJDSflhjqiMTE27IMY1LDD8QpZTvY8yg==
X-Received: by 2002:a05:6a21:329f:b0:134:76d6:7f7 with SMTP id
 yt31-20020a056a21329f00b0013476d607f7mr2068612pzb.4.1690532355159; 
 Fri, 28 Jul 2023 01:19:15 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 j63-20020a638b42000000b005637030d00csm2862658pge.30.2023.07.28.01.19.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 28 Jul 2023 01:19:14 -0700 (PDT)
Message-ID: <99d0958d-8446-6fe9-a0fb-f562cb04c7c8@bytedance.com>
Date: Fri, 28 Jul 2023 16:19:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Simon Horman <simon.horman@corigine.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-5-zhengqi.arch@bytedance.com>
 <ZMN4mjsF1QEsvW7D@corigine.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZMN4mjsF1QEsvW7D@corigine.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 31 Jul 2023 06:48:47 +0000
Subject: Re: [dm-devel] [PATCH v3 04/49] mm: shrinker: remove redundant
 shrinker_rwsem in debugfs operations
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
 linux-bcache@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 yujie.liu@intel.com, vbabka@suse.cz, linux-raid@vger.kernel.org,
 brauner@kernel.org, tytso@mit.edu, gregkh@linuxfoundation.org,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Simon,

On 2023/7/28 16:13, Simon Horman wrote:
> On Thu, Jul 27, 2023 at 04:04:17PM +0800, Qi Zheng wrote:
>> The debugfs_remove_recursive() will wait for debugfs_file_put() to return,
>> so the shrinker will not be freed when doing debugfs operations (such as
>> shrinker_debugfs_count_show() and shrinker_debugfs_scan_write()), so there
>> is no need to hold shrinker_rwsem during debugfs operations.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>   mm/shrinker_debug.c | 14 --------------
>>   1 file changed, 14 deletions(-)
>>
>> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
>> index 3ab53fad8876..f1becfd45853 100644
>> --- a/mm/shrinker_debug.c
>> +++ b/mm/shrinker_debug.c
>> @@ -55,11 +55,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>>   	if (!count_per_node)
>>   		return -ENOMEM;
>>   
>> -	ret = down_read_killable(&shrinker_rwsem);
>> -	if (ret) {
>> -		kfree(count_per_node);
>> -		return ret;
>> -	}
>>   	rcu_read_lock();
> 
> Hi Qi Zheng,
> 
> As can be seen in the next hunk, this function returns 'ret'.
> However, with this change 'ret' is uninitialised unless
> signal_pending() returns non-zero in the while loop below.

Thanks for your feedback, the 'ret' should be initialized to 0,
will fix it.

Thanks,
Qi

> 
> This is flagged in a clan-16 W=1 build.
> 
>   mm/shrinker_debug.c:87:11: warning: variable 'ret' is used uninitialized whenever 'do' loop exits because its condition is false [-Wsometimes-uninitialized]
>           } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   mm/shrinker_debug.c:92:9: note: uninitialized use occurs here
>           return ret;
>                  ^~~
>   mm/shrinker_debug.c:87:11: note: remove the condition if it is always true
>           } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                    1
>   mm/shrinker_debug.c:77:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>                   if (!memcg_aware) {
>                       ^~~~~~~~~~~~
>   mm/shrinker_debug.c:92:9: note: uninitialized use occurs here
>           return ret;
>                  ^~~
>   mm/shrinker_debug.c:77:3: note: remove the 'if' if its condition is always false
>                   if (!memcg_aware) {
>                   ^~~~~~~~~~~~~~~~~~~
>   mm/shrinker_debug.c:52:9: note: initialize the variable 'ret' to silence this warning
>           int ret, nid;
>                  ^
>                   = 0
> 
>>   
>>   	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
>> @@ -92,7 +87,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>>   	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>>   
>>   	rcu_read_unlock();
>> -	up_read(&shrinker_rwsem);
>>   
>>   	kfree(count_per_node);
>>   	return ret;
> 
> ...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

