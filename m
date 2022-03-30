Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E532C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 04:04:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-qJP2qK-kO1iR4jPFT5u8uA-1; Thu, 31 Mar 2022 00:03:55 -0400
X-MC-Unique: qJP2qK-kO1iR4jPFT5u8uA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0087F80346F;
	Thu, 31 Mar 2022 04:03:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62A3EC15D42;
	Thu, 31 Mar 2022 04:03:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D95E19451F3;
	Thu, 31 Mar 2022 04:03:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9A1519451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 16:53:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8CFA432475; Wed, 30 Mar 2022 16:53:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4B4E57E40E
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 16:53:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACAAA1C01E88
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 16:53:02 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-TuRNlKhhNVKpHQ26Ilc-Ow-1; Wed, 30 Mar 2022 12:53:01 -0400
X-MC-Unique: TuRNlKhhNVKpHQ26Ilc-Ow-1
Received: by mail-qt1-f181.google.com with SMTP id t7so18590336qta.10
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 09:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
 :content-disposition;
 bh=DCyj2h8Dyfgvj0yFsW9pEgqH+Yiq59PwixRUyZw8nsU=;
 b=XwX24852E5/VsILYTm/iTo51vUJ+Sae7T1gNA1saaDwYNijtqleFGU1OUPzrRGmRL1
 6ygqhg5xEgw3zfjw2nnLBfeNoGfBccOw0mP0z+M1ZrObJKGRgwts3fzofNxVIlzpvQUB
 mAY9vIbxiqgPbeg0/4gpp5Lycdp4TRAEcXTg8w4F0oKHQHu/lHDMvTFaAFNE5Snk6CVr
 EXiqgZVRRXl/1joKP0Nl1Yi7Yr4q6baFlpvyqsvpYUifJZl+N/VE409kUlz8DI6KC8ko
 erXb4UOilDm9PqUzr4nSA1HfLJQcssH0s8v1+2su6vkozeCX0WADDbc+AvSRxoRHUDrn
 0zuw==
X-Gm-Message-State: AOAM5314CS5Lpz3u1Ez1kkbFFJrBBYyvsiZ70XyJC5nfdAi1HATZYi6d
 JtbWb61jGQgN87UcYNYlxcUGGGc=
X-Google-Smtp-Source: ABdhPJyi6dMu69H3/JMdAZkKfzcZKrpkGifKmMBPz1vbayqx22rOZG5aY5frWWaRoxtInlriFgcGZw==
X-Received: by 2002:ac8:5c05:0:b0:2e1:de0f:d974 with SMTP id
 i5-20020ac85c05000000b002e1de0fd974mr423619qti.632.1648659180461; 
 Wed, 30 Mar 2022 09:53:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w3-20020a05622a190300b002e1f084d84bsm18106868qtc.50.2022.03.30.09.52.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 09:52:59 -0700 (PDT)
Date: Wed, 30 Mar 2022 12:52:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: tj@kernel.org, dennis@kernel.org
Message-ID: <YkSK6mU1fja2OykG@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Thu, 31 Mar 2022 04:03:21 +0000
Subject: [dm-devel] can we reduce bio_set_dev overhead due to
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hey Tejun and Dennis,

I recently found that due to bio_set_dev()'s call to
bio_associate_blkg(), bio_set_dev() needs much more cpu than ideal;
especially when doing 4K IOs via io_uring's HIPRI bio-polling.

I'm very naive about blk-cgroups.. so I'm hopeful you or others can
help me cut through this to understand what the ideal outcome should
be for DM's bio clone + remap heavy use-case as it relates to
bio_associate_blkg.

If I hack dm-linear with a local __bio_set_dev that simply removes
the call to bio_associate_blkg() my IOPS go from ~980K to 995K.

Looking at what is happening a bit, relative to this DM bio cloning
usecase, it seems __bio_clone() calls bio_clone_blkg_association() to
clone the blkg from DM device, then dm-linear.c:linear_map's call
to bio_set_dev() will cause bio_associate_blkg(bio) to reuse the css
but then it triggers an update because the bdev is being remapped in
the bio (due to linear_map sending the IO to the real underlying
device). End result _seems_ like collective wasteful effort to get the
blk-cgroup resources setup properly in the face of a simple remap.

Seems the current DM pattern is causing repeat blkg work for _every_
remapped bio?  Do you see a way to speed up repeat calls to
bio_associate_blkg()?

Test kernel is my latest dm-5.19 branch (though latest Linus 5.18-rc0
kernel should be fine too):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19

I'm using dm-linear ontop on a 16G blk-mq null_blk device:

modprobe null_blk queue_mode=2 poll_queues=2 bs=4096 gb=16
SIZE=`blockdev --getsz /dev/nullb0`
echo "0 $SIZE linear /dev/nullb0 0" | dmsetup create linear

And running the workload with fio using this wrapper script:
io_uring.sh 20 1 /dev/mapper/linear 4096

#!/bin/bash

RTIME=$1
JOBS=$2
DEV=$3
BS=$4

QD=64
BATCH=16
HI=1

fio --bs=$BS --ioengine=io_uring --fixedbufs --registerfiles --hipri=$HI \
        --iodepth=$QD \
        --iodepth_batch_submit=$BATCH \
        --iodepth_batch_complete_min=$BATCH \
        --filename=$DEV \
        --direct=1 --runtime=$RTIME --numjobs=$JOBS --rw=randread \
        --name=test --group_reporting

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

