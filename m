Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35CD6C41513
	for <dm-devel@archiver.kernel.org>; Tue, 15 Aug 2023 20:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692129869;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z8yZ3RNoUwBL8KHZSBx81hSn/u8QjU+xBCHUQCpvjdM=;
	b=Pv+QRLHteFRXtzc9/RFCcIywBmlkgY3dntyfxwGw8k8TOqAy0qV75m3abD/beLYxE1feTe
	wXmrYO3eWPafn8gLqHHY66nFecN3jA6MXeUkz+7y46/YsOdQtWRCpg7LLL2jzGv2b9jkgF
	ibQSW2V5wKC3aMWoGV4XkC8ApdGuGtM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-689--vYTGmWuPwGWZqksvK8okA-1; Tue, 15 Aug 2023 16:04:25 -0400
X-MC-Unique: -vYTGmWuPwGWZqksvK8okA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 773D0800C78;
	Tue, 15 Aug 2023 20:04:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 085DC1121318;
	Tue, 15 Aug 2023 20:04:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99AF81946589;
	Tue, 15 Aug 2023 20:04:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 018CE194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Aug 2023 09:15:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3EB1492C18; Tue, 15 Aug 2023 09:15:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB923492C13
 for <dm-devel@redhat.com>; Tue, 15 Aug 2023 09:15:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AED823801BE5
 for <dm-devel@redhat.com>; Tue, 15 Aug 2023 09:15:04 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-al4nyJXkOcKpR4KeX3M40Q-1; Tue, 15 Aug 2023 05:15:02 -0400
X-MC-Unique: al4nyJXkOcKpR4KeX3M40Q-1
Received: by mail-pl1-f178.google.com with SMTP id
 d9443c01a7336-1bb91c20602so9096575ad.0
 for <dm-devel@redhat.com>; Tue, 15 Aug 2023 02:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692090901; x=1692695701;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=N6UPah3rxy6GE+IW6hhaEXFukV19/RQgo9PDGSDaxjc=;
 b=MzCzTY/TCYwFXmyOTaVFrRWKjl8FlofemJD4q3/4CxU9LuhQx6xfUBDnWxrowsKEeL
 7XWCKJTbzbkPfoGTW9WqjUiTWfu6LZJ6UYXO2tIW0UrrqSHZpbMbFG6RftaJqy0ORaSj
 4jceMLjLKJSlQwm0KUQJ4qjrh0b7Q8HpI4E/KQX1S5uWRwqcoolQCHUY6cUDEqiw4GHh
 1JIbZcylkLoVKuDuVGBhDAjSwbvj6+MGzlHj+kEwHLEKhNcvz9309pJ44xcb/EtiRMj0
 AL+Nb6KnGsnyNfOCXedHRgFyUruo2yrzdteV48XoV7/xyCxr8Oy7t9oMwE3BT/t0PkIZ
 Z/9Q==
X-Gm-Message-State: AOJu0YxJAkBcRU2/O1lurzPcwIVND40T8rQMf3ymBqgv7ygdb+9Tl8dN
 o/2yjB/UklU0NNq2TnOlEOuXXw==
X-Google-Smtp-Source: AGHT+IGKaQyK0d17VyjHV7p/Fr8yAF+2JMAJsl65uoihXD9UcmAUSi1eF134pFnOBdZUKl9ThFMr5Q==
X-Received: by 2002:a17:902:e5c8:b0:1bb:83ec:832 with SMTP id
 u8-20020a170902e5c800b001bb83ec0832mr13866844plf.2.1692090901535; 
 Tue, 15 Aug 2023 02:15:01 -0700 (PDT)
Received: from ?IPV6:fdbd:ff1:ce00:1c25:884:3ed:e1db:b610?
 ([240e:694:e21:b::2]) by smtp.gmail.com with ESMTPSA id
 io13-20020a17090312cd00b001b39ffff838sm10630843plb.25.2023.08.15.02.14.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Aug 2023 02:15:01 -0700 (PDT)
Message-ID: <4f64cd2d-90e8-7902-7ef7-1ac58d51b2a8@bytedance.com>
Date: Tue, 15 Aug 2023 17:14:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
To: Muchun Song <muchun.song@linux.dev>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-2-zhengqi.arch@bytedance.com>
 <FC3AE898-443D-4ACB-BCB4-0F8F2F48CDD0@linux.dev>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <FC3AE898-443D-4ACB-BCB4-0F8F2F48CDD0@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 15 Aug 2023 20:04:08 +0000
Subject: Re: [dm-devel] [PATCH v4 01/48] mm: move some shrinker-related
 function declarations to mm/internal.h
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
Cc: kvm@vger.kernel.org, djwong@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, david@fromorbit.com,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 Linux-MM <linux-mm@kvack.org>, dm-devel@redhat.com,
 linux-mtd@lists.infradead.org, cel@kernel.org, x86@kernel.org,
 steven.price@arm.com, cluster-devel@redhat.com, simon.horman@corigine.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-arm-msm@vger.kernel.org,
 linux-nfs@vger.kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org,
 dlemoal@kernel.org, yujie.liu@intel.com, Vlastimil Babka <vbabka@suse.cz>,
 linux-raid@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 tytso@mit.edu, Greg KH <gregkh@linuxfoundation.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>,
 netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/8/15 16:36, Muchun Song wrote:
> 
> 
>> On Aug 7, 2023, at 19:08, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>
>> The following functions are only used inside the mm subsystem, so it's
>> better to move their declarations to the mm/internal.h file.
>>
>> 1. shrinker_debugfs_add()
>> 2. shrinker_debugfs_detach()
>> 3. shrinker_debugfs_remove()
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> 
> One nit bellow.
> 
> [...]
> 
>> +
>> +/*
>> + * shrinker related functions
>> + */
> 
> This is a multi-comment format. "/* shrinker related functions. */" is
> the right one-line format of comment.

Will do.

Thanks,
Qi

> 
>> +
>> +#ifdef CONFIG_SHRINKER_DEBUG
>> +extern int shrinker_debugfs_add(struct shrinker *shrinker);
>> +extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
>> +      int *debugfs_id);
>> +extern void shrinker_debugfs_remove(struct dentry *debugfs_entry,
>> +    int debugfs_id);
>> +#else /* CONFIG_SHRINKER_DEBUG */
>> +static inline int shrinker_debugfs_add(struct shrinker *shrinker)
>> +{
>> +	return 0;
>> +}
>> +static inline struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
>> +     int *debugfs_id)
>> +{
>> +	*debugfs_id = -1;
>> +	return NULL;
>> +}
>> +static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
>> +	int debugfs_id)
>> +{
>> +}
>> +#endif /* CONFIG_SHRINKER_DEBUG */
>> +
>> #endif /* __MM_INTERNAL_H */
>> -- 
>> 2.30.2
>>
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

