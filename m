Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88C9C4332F
	for <dm-devel@archiver.kernel.org>; Sun, 25 Dec 2022 11:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671968457;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BE/Y1wu53ivbeL7MirWuVnhuBlliBJBt4+gtru5+el0=;
	b=Mx7uJjdLBdejaHbMKhauC2jIm+M/dxCiqJ8EDYdCPiqDMqDLI89hjxzZgV17WGhjWKgrYd
	PWTbitBsz+INHwl+NLi82TEIwN5Vr6UgdeKJY4q9F7w4YVduS285ZTgo/VnHmQ+AEGrNJp
	om45m8/M7F2ANrhRVE0NrOquZjfzrjs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-XWdpaUcEOD2fYoa5AfFV_A-1; Sun, 25 Dec 2022 06:40:53 -0500
X-MC-Unique: XWdpaUcEOD2fYoa5AfFV_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 655CF1C05EBD;
	Sun, 25 Dec 2022 11:40:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96768140EBF6;
	Sun, 25 Dec 2022 11:40:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F46E1946588;
	Sun, 25 Dec 2022 11:40:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E71D51946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Dec 2022 11:40:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0C7C40C2064; Sun, 25 Dec 2022 11:40:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C8E2440C2005
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 11:40:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 155473C0252D
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 11:40:35 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-z3KvPj5oOr-8xR3rOA83Sw-1; Sun, 25 Dec 2022 06:40:28 -0500
X-MC-Unique: z3KvPj5oOr-8xR3rOA83Sw-1
Received: by mail-wr1-f45.google.com with SMTP id bs20so6112660wrb.3;
 Sun, 25 Dec 2022 03:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ZHIIoLI6GIci6V+pJYW1QHErBVX3zcPxWh+ZJQxLA0o=;
 b=k/JEdyEv0RbQ0L+vFcnv9mQdnkyWsBzv94jEY9fQ50d0O8Tx42Uh8avI4nhWs1mAu1
 /o48AReMAPsDl7jNMgfL7HVndNVxva2bhCzaiAQrNn68vgRu2THGysE3KSFt0dEEruPd
 XIykbwdIbeeKuyofoUDXCDiMT0D4OAs14AwjqyXi9AFt1zmh5leDNDVgViaB+LRIH7vA
 +h4SJMHEyRx4jluVlUBueKVeJHl1VrhZYJ1po2JIkPMUTE/2vGjYOX3CrIVs/KY6M1SG
 AYKNCZah+La/zKx7lUIBngj6Bjf6ttwcY+wYUPDtW5e88U1QUGIJAx8mZJhXdRa6oWmj
 SZNg==
X-Gm-Message-State: AFqh2kpqrtDnvQwo4fFEJa3fNJthZoQCJ4l755ERx5z0zK4SbhM/q9DI
 6+XVrz3yi7P9Xu5raI4gRnQ=
X-Google-Smtp-Source: AMrXdXtOU+j5gb521X9u9SLkgvSyxLbk+fAjhclAlSe9w631NeEuF0qIeOMvF5fteB8K21s8/zxQPQ==
X-Received: by 2002:adf:f30f:0:b0:242:864e:c71c with SMTP id
 i15-20020adff30f000000b00242864ec71cmr8954222wro.24.1671968426666; 
 Sun, 25 Dec 2022 03:40:26 -0800 (PST)
Received: from [192.168.64.177] (bzq-219-42-90.isdn.bezeqint.net.
 [62.219.42.90]) by smtp.gmail.com with ESMTPSA id
 e16-20020adfdbd0000000b002362f6fcaf5sm7652128wrj.48.2022.12.25.03.40.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 25 Dec 2022 03:40:26 -0800 (PST)
Message-ID: <1d0eb8e4-a91f-4635-bac7-9bc6cefbeff0@grimberg.me>
Date: Sun, 25 Dec 2022 13:40:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To: Gulam Mohamed <gulam.mohamed@oracle.com>, linux-block@vger.kernel.org
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH for-6.2/block V3 1/2] block: Data type
 conversion for IO accounting
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
Cc: nvdimm@lists.linux.dev, shminderjit.singh@oracle.com,
 linux-kernel@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
 ira.weiny@intel.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 dave.jiang@intel.com, christoph.boehmwalder@linbit.com,
 vishal.l.verma@intel.com, konrad.wilk@oracle.com, joe.jin@oracle.com,
 kent.overstreet@gmail.com, ngupta@vflare.org, kch@nvidia.com,
 senozhatsky@chromium.org, snitzer@kernel.org, colyli@suse.de,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 dan.j.williams@intel.com, axboe@kernel.dk, martin.petersen@oracle.com,
 rajesh.sivaramasubramaniom@oracle.com, philipp.reisner@linbit.com,
 junxiao.bi@oracle.com, minchan@kernel.org, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 12/21/22 06:05, Gulam Mohamed wrote:
> Change the data type of start and end time IO accounting variables in,
> block layer, from "unsigned long" to "u64". This is to enable nano-seconds
> granularity, in next commit, for the devices whose latency is less than
> milliseconds.
> 
> Changes from V2 to V3
> =====================
> 1. Changed all the required variables data-type to u64 as part of this
>     first patch
> 2. Create a new setting '2' for iostats in sysfs in next patch
> 3. Change the code to get the ktime values when iostat=2 in next patch
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> ---
>   block/blk-core.c              | 24 ++++++++++++------------
>   block/blk.h                   |  2 +-
>   drivers/block/drbd/drbd_int.h |  2 +-
>   drivers/block/zram/zram_drv.c |  4 ++--
>   drivers/md/bcache/request.c   | 10 +++++-----
>   drivers/md/dm-core.h          |  2 +-
>   drivers/md/dm.c               |  2 +-
>   drivers/md/md.h               |  2 +-
>   drivers/md/raid1.h            |  2 +-
>   drivers/md/raid10.h           |  2 +-
>   drivers/md/raid5.c            |  2 +-
>   drivers/nvdimm/btt.c          |  2 +-
>   drivers/nvdimm/pmem.c         |  2 +-
>   include/linux/blk_types.h     |  2 +-
>   include/linux/blkdev.h        | 12 ++++++------
>   include/linux/part_stat.h     |  2 +-

nvme-mpath now also has stats, so struct nvme_request should also be
updated.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

