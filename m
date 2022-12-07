Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A74DC4708D
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 23:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670454526;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jgfUom3bM8uaQKS6mmlulPKzAgpjcnGxJrFHKQMI1sU=;
	b=BqiLVebohE9QXH+V7wVHfCg1MsW1MF8Y2nWAiEpg0pfGtv60W2LunTOqPPc/qBdm+6Li0d
	/n9VUu43naW746tzyVb5O46HfDfVomaE5jsF4hw+WnannOEI0nYBTujWy6B0VLTIV3N/i7
	WNdbCEDRKALQUbi2uEfMy0bgeeoqrug=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-CiWu766xM02pPygWkPFAYA-1; Wed, 07 Dec 2022 18:08:43 -0500
X-MC-Unique: CiWu766xM02pPygWkPFAYA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A28429ABA3A;
	Wed,  7 Dec 2022 23:08:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEA51492B05;
	Wed,  7 Dec 2022 23:08:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE70A19465B9;
	Wed,  7 Dec 2022 23:08:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AEF7F19465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 23:08:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F414492CA4; Wed,  7 Dec 2022 23:08:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EBEA492CA2
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 23:08:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65258805AC5
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 23:08:39 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-99-DV4biJDqMZCgVth_rnm7HQ-1; Wed, 07 Dec 2022 18:08:37 -0500
X-MC-Unique: DV4biJDqMZCgVth_rnm7HQ-1
Received: by mail-pj1-f44.google.com with SMTP id o12so19111188pjo.4
 for <dm-devel@redhat.com>; Wed, 07 Dec 2022 15:08:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=8cz7FtbLCIk84E/qnSv5m0mZi4Cb+DIbSaYsI85FKRg=;
 b=Bn6R3hkXbHMLg6t5B+o+/XI8bFdhuK2oU56h3lUSPJ0i+gXWC1EOIjbEYoq8Xjd4AM
 riLYUo/mSSITUNIBiWQAYu3rJl1zvcPdDs0MlBRFMAwrZOeW1SSCNwaaTMiRVWs6bgvk
 BlX37nl4qhu5lBZXKrsKbyXOcKcoVJrfVjQNe45l3EHuHTMEJCEd7tqeZCh2hPZtLBeL
 aMlLWlMxnKHyUwl1jrPePIonXfWl2Fmct1MDFYRmOy6zN7hrSAojRJefw0sJ0HNqW6M9
 7zla7mv+/AiiNSL+jM+lyYTqxQZiVgbFCKwpUu1DisJDx14jhrfLi5lIln7XltaX2LyV
 ZycA==
X-Gm-Message-State: ANoB5pnoy2QWLJOlMH6+9PrBhRsgjB9xBv5v5yzWm//ZaLfmOWCM4Yo6
 XyL3eYkx4B66aQ5Vvx97Qcm/1A==
X-Google-Smtp-Source: AA0mqf6NChvQ+6VGxcj9TuOceBjh4tzkE39hbYJ44cM567wbm+gRoT462mEspyLU7F6tqEVSBYhuIQ==
X-Received: by 2002:a17:90b:3687:b0:219:468e:88ac with SMTP id
 mj7-20020a17090b368700b00219468e88acmr47734105pjb.105.1670454516121; 
 Wed, 07 Dec 2022 15:08:36 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 u126-20020a627984000000b00575caf80d08sm14105794pfc.31.2022.12.07.15.08.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 07 Dec 2022 15:08:35 -0800 (PST)
Message-ID: <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
Date: Wed, 7 Dec 2022 16:08:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [RFC for-6.2/block V2] block: Change the granularity
 of io ticks from ms to ns
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
 vishal.l.verma@intel.com, joe.jin@oracle.com, kent.overstreet@gmail.com,
 ngupta@vflare.org, kch@nvidia.com, konrad.wilk@oracle.com, snitzer@kernel.org,
 colyli@suse.de, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 christoph.boehmwalder@linbit.com, dan.j.williams@intel.com,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 junxiao.bi@oracle.com, senozhatsky@chromium.org, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/7/22 3:32?PM, Gulam Mohamed wrote:
> As per the review comment from Jens Axboe, I am re-sending this patch
> against "for-6.2/block".
> 
> 
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

My default peak testing runs at 122M IOPS. That's also the peak IOPS of
the devices combined, and with iostats disabled. If I enabled iostats,
then the performance drops to 112M IOPS. It's no longer device limited,
that's a drop of about 8.2%.

Adding this patch, and with iostats enabled, performance is at 91M IOPS.
That's a ~25% drop from no iostats, and a ~19% drop from the iostats we
have now...

Here's what I'd like to see changed:

- Split the patch up. First change all the types from unsigned long to
  u64, that can be done while retaining jiffies.

- Add an iostats == 2 setting, which enables this higher resolution
  mode. We'd still default to 1, lower granularity iostats enabled.

I think that's cleaner than one big patch, and means that patch 1 should
not really have any noticeable changes. That's generally how I like to
get things split. With that, then I think there could be a way to get
this included.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

