Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3757CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 04:04:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-H15S7tpIPOGMLAq3vhZm1A-1; Thu, 31 Mar 2022 00:04:03 -0400
X-MC-Unique: H15S7tpIPOGMLAq3vhZm1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 864E83C01D9D;
	Thu, 31 Mar 2022 04:04:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 739822026D65;
	Thu, 31 Mar 2022 04:04:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E80E19451F3;
	Thu, 31 Mar 2022 04:04:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5A3CE19451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 19:23:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 22FE0C15D7B; Wed, 30 Mar 2022 19:23:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E856C15D42
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 19:23:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 065933C02B8A
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 19:23:19 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-bqkPLHtEONaVtJTKP8Jp0g-1; Wed, 30 Mar 2022 15:23:16 -0400
X-MC-Unique: bqkPLHtEONaVtJTKP8Jp0g-1
Received: by mail-pf1-f171.google.com with SMTP id h19so18713296pfv.1
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 12:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZHtyaTDCFwT16k5cdDfPF/P2EA5gPFqUR2PCvm4ECgI=;
 b=Hgg+tKDLQ1C0JKOj8aX7icmaWNG4u9FX0Jdd1Op99RcHqzdao0iH/D6XplYvvddXDf
 JehDb4ZYktX3ETr1bGQFfqdHKOnR7mC15axTvjJWOljEjeu82kf7Dx1wksae7BCS6fAK
 x0l4sCxCFw1KEJsSzFPfZqBT5EGWRAsZO723l5qVCz1sHSBe8W2431jSYBQHW8zSczb/
 8XqGnxGjhenAoepmSpdQdOKEGBtYctsgQH8BfbmulRV/UzjGhKEMTEk30+OKj/3+iMZo
 IMAyHP1RB16xXFRcw4usxC59n9JuyJ4qh4pbXdoCyOQs2Eys2pdps6+QdM2YMZ1sjCHY
 HKfA==
X-Gm-Message-State: AOAM530XMk2YRr37fDFtvFHX77SamjMbLD57V/L780xr0JJ88nDuK6EJ
 dZKSIMJhM93yDQciVkE2hX8=
X-Google-Smtp-Source: ABdhPJzwW5Uj3tPdbpOaNG5QzaofCKC1qF7aDIo6ArraeWowHZ4NFFbLL3rxw31k/agc3F4ivB+E5w==
X-Received: by 2002:a05:6a00:ad0:b0:4f7:a357:6899 with SMTP id
 c16-20020a056a000ad000b004f7a3576899mr34729945pfl.80.1648668195778; 
 Wed, 30 Mar 2022 12:23:15 -0700 (PDT)
Received: from fedora (136-24-99-118.cab.webpass.net. [136.24.99.118])
 by smtp.gmail.com with ESMTPSA id
 h6-20020a056a00218600b004f65315bb37sm26083117pfi.13.2022.03.30.12.23.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 12:23:15 -0700 (PDT)
Date: Wed, 30 Mar 2022 08:28:28 -0400
From: Dennis Zhou <dennis@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <YkRM7Iyp8m6A1BCl@fedora>
References: <YkSK6mU1fja2OykG@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YkSK6mU1fja2OykG@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Thu, 31 Mar 2022 04:03:21 +0000
Subject: Re: [dm-devel] can we reduce bio_set_dev overhead due to
 bio_associate_blkg?
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
Cc: tj@kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
 linux-block@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

On Wed, Mar 30, 2022 at 12:52:58PM -0400, Mike Snitzer wrote:
> Hey Tejun and Dennis,
> 
> I recently found that due to bio_set_dev()'s call to
> bio_associate_blkg(), bio_set_dev() needs much more cpu than ideal;
> especially when doing 4K IOs via io_uring's HIPRI bio-polling.
> 
> I'm very naive about blk-cgroups.. so I'm hopeful you or others can
> help me cut through this to understand what the ideal outcome should
> be for DM's bio clone + remap heavy use-case as it relates to
> bio_associate_blkg.
> 
> If I hack dm-linear with a local __bio_set_dev that simply removes
> the call to bio_associate_blkg() my IOPS go from ~980K to 995K.
> 
> Looking at what is happening a bit, relative to this DM bio cloning
> usecase, it seems __bio_clone() calls bio_clone_blkg_association() to
> clone the blkg from DM device, then dm-linear.c:linear_map's call
> to bio_set_dev() will cause bio_associate_blkg(bio) to reuse the css
> but then it triggers an update because the bdev is being remapped in
> the bio (due to linear_map sending the IO to the real underlying
> device). End result _seems_ like collective wasteful effort to get the
> blk-cgroup resources setup properly in the face of a simple remap.
> 
> Seems the current DM pattern is causing repeat blkg work for _every_
> remapped bio?  Do you see a way to speed up repeat calls to
> bio_associate_blkg()?
> 

I must admit I wrote this with limited knowledge of bio cloning at the
time. I can fill in the thought process here.

The idea was every bio should have a blkg associated with it for io
accounting and things like blk-iolatency and blk-iocost. The device
abstraction I believe means we can set limits here as well on submission
rate to the md device.

I think cloning is a special case that I might have gotten wrong. If
there is a bio_set_dev() call after each clone(), then the
bio_clone_blkg_association() is excess work. We'd need to audit how
bio_alloc_clone() is being used to be safe. Alternatively, we could opt
for a bio_alloc_clone_noblkg(), but that's a little bit uglier.

1. bio_set_dev() above md <- needed so we can do throttling on the md.
2. bio_alloc_clone() <- doesn't need to clone the blkg() info.
3. bio_set_dev() in md <- sets the right underlying device association.

Thanks,
Dennis

> Test kernel is my latest dm-5.19 branch (though latest Linus 5.18-rc0
> kernel should be fine too):
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
> 
> I'm using dm-linear ontop on a 16G blk-mq null_blk device:
> 
> modprobe null_blk queue_mode=2 poll_queues=2 bs=4096 gb=16
> SIZE=`blockdev --getsz /dev/nullb0`
> echo "0 $SIZE linear /dev/nullb0 0" | dmsetup create linear
> 
> And running the workload with fio using this wrapper script:
> io_uring.sh 20 1 /dev/mapper/linear 4096
> 
> #!/bin/bash
> 
> RTIME=$1
> JOBS=$2
> DEV=$3
> BS=$4
> 
> QD=64
> BATCH=16
> HI=1
> 
> fio --bs=$BS --ioengine=io_uring --fixedbufs --registerfiles --hipri=$HI \
>         --iodepth=$QD \
>         --iodepth_batch_submit=$BATCH \
>         --iodepth_batch_complete_min=$BATCH \
>         --filename=$DEV \
>         --direct=1 --runtime=$RTIME --numjobs=$JOBS --rw=randread \
>         --name=test --group_reporting

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

