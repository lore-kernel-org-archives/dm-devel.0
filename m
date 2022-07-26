Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF89C00144
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 20:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658866715;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ESiBDEF78tsoZ3i+xkrEqx7T/6TMZWmOZY8GGd3Mrjo=;
	b=Hjj5TcUa++zYUq7HayddoDlZphfUDwBy5l65I7FwypUFGfAs2hOjXDtGb2GZzq6hCeVewC
	1Tbx6KtWzp75T097FCZk7SDW3TKsKmdhkk7LmSgr4BGx4OqtErOS1yFWfearkFqCUJTSrv
	dTiT+4TnUy1VbCddGidUj+V6+gVHsTI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-FhuhqiJrPtSvinMktVl5UQ-1; Tue, 26 Jul 2022 16:18:34 -0400
X-MC-Unique: FhuhqiJrPtSvinMktVl5UQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A9B785A584;
	Tue, 26 Jul 2022 20:18:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1B0A2026D2D;
	Tue, 26 Jul 2022 20:18:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BE201945D8F;
	Tue, 26 Jul 2022 20:18:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 409161945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 20:18:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3038940CFD0A; Tue, 26 Jul 2022 20:18:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C3DA40CF8EE
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 20:18:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12AEA811E81
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 20:18:27 +0000 (UTC)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-IldCnm0XN1WZzgIHHKcVqg-1; Tue, 26 Jul 2022 16:18:25 -0400
X-MC-Unique: IldCnm0XN1WZzgIHHKcVqg-1
Received: by mail-lj1-f171.google.com with SMTP id w18so6629739lje.1
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 13:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PtbnOtHKF34Czdwa9qoW+EQoP3N+APT3kbr7xICR+X0=;
 b=p5ITBlaDuLfGpjCZFtpJCpKSGJpSxJmzFnnGx1KdFJwfSXL48r9LqxrhlB6nAws/go
 qx8n35DrzfObgcdEVBhdix2+Pzs9CU6J7epYNoGbF3qsqEBQCNkIWmUDTQCIoKDzW3os
 ZJRilniW84qO2N+P9s0BN+nWUIui7wKsKigKYy1GN7t945aTeiAC0dhP2SznYWWUKJQT
 he04n1+RDvmnQ7iL22kt+07ixBM0+eZnZwooFO+HeKCuAxm3C463gPKMr7X9QD9n9+Uh
 IkJgwqFR82V3uOeNWsweYDTuwSwv6JN02iX3G6PsVlaYZCtoKHly+xKN5UYMNNbQxK8+
 tOLA==
X-Gm-Message-State: AJIora9mCSECW0gG6r+05sEz69qkQmUknne7Bafgseq5ZBvaxzIDP4zq
 WpS6pw3f++D/trGkrG4SFKkWbnRO2Pve2Gvw31FU6w==
X-Google-Smtp-Source: AGRyM1sfpsovTlWHz8HLA+NykILl5UbmqH2OCLATBvy5YiaUMqiNMLvt2Wk3YWNxMUjFpbh9UyV5eR/2UsMaULk97q0=
X-Received: by 2002:a2e:a305:0:b0:25d:ffe6:9cbc with SMTP id
 l5-20020a2ea305000000b0025dffe69cbcmr4904831lje.298.1658866703498; Tue, 26
 Jul 2022 13:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220726160959.89247-1-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
From: Nathan Huckleberry <nhuck@google.com>
Date: Tue, 26 Jul 2022 13:18:00 -0700
Message-ID: <CAJkfWY78s68M6xgTWoWKXVW=Sb+qAop5VSCi6ZXbQXnfmYMAkQ@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 0/6] dm verity: optionally use tasklets
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hey Mike,

On Tue, Jul 26, 2022 at 9:10 AM Mike Snitzer <snitzer@kernel.org> wrote:
>
> Hi,
>
> Please see this updated patchset that reflects what I've staged for
> the 5.20 merge window, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
>
> My only outstanding question, from previous v1 patchset, is: should
> the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
> (I doubt it has a significant impact on performance but if you have
> insight on why you made that change, and if it meaningful, I'd happily
> apply the change).

In my testing, WQ_HIGHPRI reduced latency in both cases. I tested how
long each configuration spent waiting for work-queue jobs to be
scheduled. The numbers look consistent across the three runs I did.
See below.

Total verity work-queue wait times (ms):
Normal WQ: 880.960, 789.517, 898.852
High Priority WQ: 528.824, 439.191, 433.300
Tasklets + Normal WQ: 242.594, 145.106, 272.642
Tasklets + High Priority WQ: 85.343, 60.787, 70.620

WQ_HIGHPRI is useful even if try_verify_in_tasklet is not used.

Thanks,
Huck


>
> I've tested using cryptsetup's testsuite (which has dm-verity tests)
> but I haven't tested the "try_verify_in_tasklet" feature.
>
> I'd welcome review and focused "try_verify_in_tasklet" testing.
>
> Thanks,
> Mike
>
> Mike Snitzer (3):
>   dm verity: allow optional args to alter primary args handling
>   dm bufio: conditionally enable branching for DM_BUFIO_CLIENT_NO_SLEEP
>   dm verity: conditionally enable branching for "try_verify_in_tasklet"
>
> Nathan Huckleberry (3):
>   dm bufio: Add flags argument to dm_bufio_client_create
>   dm bufio: Add DM_BUFIO_CLIENT_NO_SLEEP flag
>   dm verity: Add optional "try_verify_in_tasklet" feature
>
>  drivers/md/dm-bufio.c                         |  32 ++++-
>  drivers/md/dm-ebs-target.c                    |   3 +-
>  drivers/md/dm-integrity.c                     |   2 +-
>  drivers/md/dm-snap-persistent.c               |   2 +-
>  drivers/md/dm-verity-fec.c                    |   4 +-
>  drivers/md/dm-verity-target.c                 | 121 +++++++++++++++---
>  drivers/md/dm-verity.h                        |   7 +-
>  drivers/md/persistent-data/dm-block-manager.c |   3 +-
>  include/linux/dm-bufio.h                      |   8 +-
>  9 files changed, 154 insertions(+), 28 deletions(-)
>
> --
> 2.32.1 (Apple Git-133)
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

