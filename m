Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE7DC47089
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670432943;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Fywwj2NwYt99gK+R39vlN5GJToQSafOAt91TbtcBgSY=;
	b=XsGm/lIjAnUWzAFGTQSR8UcDxHK434IE4uxHrdA8keB1jbQvekyjOf3Xzf3uVNVDw+UNHb
	+JGqQgvYFQUMddy2tg+8AnwlFQsx7HHlSNIXYQbpCtG23rbZrBfgTtUccIbKsexeVd/qLF
	edq25HVLUfXheC0FKJzC9gA4oYcN70E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-DV9jAgCUMwqCuCFxh_aueg-1; Wed, 07 Dec 2022 12:08:59 -0500
X-MC-Unique: DV9jAgCUMwqCuCFxh_aueg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDA76185A7A3;
	Wed,  7 Dec 2022 17:08:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A05839D7C;
	Wed,  7 Dec 2022 17:08:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4B66D19465B9;
	Wed,  7 Dec 2022 17:08:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADACB19465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 17:08:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9EE95492B05; Wed,  7 Dec 2022 17:08:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 962E0492B04
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 17:08:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A5A485A588
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 17:08:55 +0000 (UTC)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-240-EmtZJ4KtPWiP5O0VAaIsGQ-1; Wed, 07 Dec 2022 12:08:53 -0500
X-MC-Unique: EmtZJ4KtPWiP5O0VAaIsGQ-1
Received: by mail-io1-f49.google.com with SMTP id e189so12178806iof.1
 for <dm-devel@redhat.com>; Wed, 07 Dec 2022 09:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+r3z2TzChBc0Vs/D1sJ6f4Z6Cq8sqK5Sifftb2ph/uA=;
 b=e7ipYMNqPH4zF6+uIps8Edw7oYZVdGGXg15/RwGdySV1TJnUFaHP6dE9Msp3Mf9nbz
 /citvbPFz4PFWbakK3TUielga0chCvA+Kv5MgdBEPb3M+lOzB16bUwdEewt36oHKSuL6
 i3yzReAjWQf8nFfG7oXC+qhdECTqIzVTza0kPaWmw8k2iYzGHBqrkkaUs6MfgH0evANK
 gE96TLAF2IdCdQMmPeqwhaaBLyY2uwM2VXuj2CfZHdtAgjMKYHC8fxOvvk8YyYhM+C15
 +Cv/zj4KPuJEmpgMnynN/18ER/cva+aCjZvuQHctZd5Sk6mKr2NQEhCEASdN6nQPm85x
 TfNA==
X-Gm-Message-State: ANoB5pll3hXSkytVHNBBuWY26T1JS5AGHOkyvpKnhEadlegAep1mNtMp
 eVKuRNuRQ8WuHvufopZJm/bkFQ==
X-Google-Smtp-Source: AA0mqf7yLejbRNfqMUu3ilEvsYdDj7YhVkPipELjA6VqWKNVXZJlTdAqiTcfQmriCKmlYB7qULxDWg==
X-Received: by 2002:a05:6638:1124:b0:38a:171a:dee with SMTP id
 f4-20020a056638112400b0038a171a0deemr12454949jar.292.1670432932906; 
 Wed, 07 Dec 2022 09:08:52 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 o27-20020a02a1db000000b0038a0c2ae99bsm7327723jah.18.2022.12.07.09.08.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 07 Dec 2022 09:08:52 -0800 (PST)
Message-ID: <eaf4f9a8-dfc6-402e-4a1a-732034d1512d@kernel.dk>
Date: Wed, 7 Dec 2022 10:08:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221206181536.13333-1-gulam.mohamed@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [RFC] block: Change the granularity of io ticks from
 ms to ns
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
Cc: nvdimm@lists.linux.dev, philipp.reisner@linbit.com, song@kernel.org,
 dm-devel@redhat.com, ira.weiny@intel.com, agk@redhat.com,
 drbd-dev@lists.linbit.com, dave.jiang@intel.com, minchan@kernel.org,
 vishal.l.verma@intel.com, kent.overstreet@gmail.com, ngupta@vflare.org,
 kch@nvidia.com, konrad.wilk@oracle.com, snitzer@kernel.org, colyli@suse.de,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 christoph.boehmwalder@linbit.com, dan.j.williams@intel.com,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 junxiao.bi@oracle.com, senozhatsky@chromium.org, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/6/22 11:15?AM, Gulam Mohamed wrote:
> Use ktime to change the granularity of IO accounting in block layer from
> milli-seconds to nano-seconds to get the proper latency values for the
> devices whose latency is in micro-seconds. After changing the granularity
> to nano-seconds the iostat command, which was showing incorrect values for
> %util, is now showing correct values.
> 
> We did not work on the patch to drop the logic for
> STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.
> 
> The iostat command was run after starting the fio with following command
> on an NVME disk. For the same fio command, the iostat %util was showing
> ~100% for the disks whose latencies are in the range of microseconds.
> With the kernel changes (granularity to nano-seconds), the %util was
> showing correct values. Following are the details of the test and their
> output:

As mentioned, this will most likely have a substantial performance
impact. I'd test it, but your patch is nowhere near applying to the
current block tree. Please resend it against for-6.2/block so it can
get tested.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

