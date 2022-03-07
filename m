Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CD7C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646671570;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rzcO74K9C2/YWoVSYbln2xgkS1ywoTxmwseBQQvCRAY=;
	b=KA2TFTdrdAgh3EYKW6i4OkicIl5OAv0aP6P/i7DiMPZ1oKJ/1erFqYJVzwN7sNGfxAi2o5
	8i/zGKhRJvtr/Lbag1XWrBLNu8zUdkMXmeMTX6ACCw7H9igXZJTmRTI7+Y/59oj1tiVM5L
	jEM5szdUtJnXNFhxfWYHtm+0oXtSYhw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-b6yrOyT5PaunI_1SvNY2yg-1; Mon, 07 Mar 2022 11:46:06 -0500
X-MC-Unique: b6yrOyT5PaunI_1SvNY2yg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 062883C17B4D;
	Mon,  7 Mar 2022 16:46:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1F2B84010FCD;
	Mon,  7 Mar 2022 16:46:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87F8319305AB;
	Mon,  7 Mar 2022 16:46:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EBD2919305AA
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 16:46:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C951814582F1; Mon,  7 Mar 2022 16:46:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C583014582EF
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 16:46:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABEEC101AA48
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 16:46:01 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-XgwgmFF-NCaOdwIVkoSJuQ-1; Mon, 07 Mar 2022 11:46:00 -0500
X-MC-Unique: XgwgmFF-NCaOdwIVkoSJuQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 u12-20020a05620a0c4c00b00475a9324977so11926206qki.13
 for <dm-devel@redhat.com>; Mon, 07 Mar 2022 08:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gQIljNs+HnPVBhwvccBM/a6HAzcLYmbphJvQWks4uMk=;
 b=G/aC0zVS92BYHL3ScmE3jAwypqzKf7zWKKgz7A38HcXJOve43UWtdEH+CYnbJTEwgI
 tLbNCGpVazSUJdcAJrKWqIK2onm8oOIcQt6f9wRwmaiLMF50z8PgUW+MMJ5qV8LzKxSF
 9opdSbHZDQjiRHvFws4AWLX1+eymo5SMJnI5yq2YzB1LwDbEig+zonIs7d7008Ddow33
 KFlgWm51Uh2qNNTKiMSxUbXH6briwWDZ/1RT01upEVlb7hekBBdVLy9OcmHMM62LT3Rh
 zPQDNYcD2RIsY+BnlSCKwjfCg1XZZGcElMm1lADVmzaY2l0B470CIey50kyxnoP08X3r
 BJVg==
X-Gm-Message-State: AOAM533s0kALTq3rHILWaSGqFFYw4oqIM90zDRMoUQjgKm9btiPoC9bt
 IeeBkxazA2BbGWckaT3ZSXYXpNxdEMwd+zg/S+p5yD4VIWZdMKPuNLsy0Z2g+5iOpPTVlZCRYB2
 PQF6Dk3hhAf4X4Q==
X-Received: by 2002:a37:a281:0:b0:67b:3c17:ffdb with SMTP id
 l123-20020a37a281000000b0067b3c17ffdbmr1804600qke.105.1646671559872; 
 Mon, 07 Mar 2022 08:45:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJowvkQ9JuNtYI6Fa6y2uE4tce9y9q4q4RqiB5JwP0KtCgDOCEZhmREbXaLeegbAPRVmOsKQ==
X-Received: by 2002:a37:a281:0:b0:67b:3c17:ffdb with SMTP id
 l123-20020a37a281000000b0067b3c17ffdbmr1804582qke.105.1646671559585; 
 Mon, 07 Mar 2022 08:45:59 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 bp15-20020a05620a458f00b00663835ca7f2sm6239574qkb.14.2022.03.07.08.45.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Mar 2022 08:45:59 -0800 (PST)
Date: Mon, 7 Mar 2022 11:45:53 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <YiY2wUVIz3NXIjlc@redhat.com>
References: <20220304180105.409765-1-hch@lst.de>
 <164666057398.15541.7415780807920631127.b4-ty@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <164666057398.15541.7415780807920631127.b4-ty@kernel.dk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] remove bio_devname
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
Cc: linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-block@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 07 2022 at  8:42P -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On Fri, 4 Mar 2022 19:00:55 +0100, Christoph Hellwig wrote:
> > this series removes the bio_devname helper and just switches all users
> > to use the %pg format string directly.
> > 
> > Diffstat
> >  block/bio.c               |    6 ------
> >  block/blk-core.c          |   25 +++++++------------------
> >  drivers/block/pktcdvd.c   |    9 +--------
> >  drivers/md/dm-crypt.c     |   10 ++++------
> >  drivers/md/dm-integrity.c |    5 ++---
> >  drivers/md/md-multipath.c |    9 ++++-----
> >  drivers/md/raid1.c        |    5 ++---
> >  drivers/md/raid5-ppl.c    |   13 ++++---------
> >  fs/ext4/page-io.c         |    5 ++---
> >  include/linux/bio.h       |    2 --
> >  10 files changed, 26 insertions(+), 63 deletions(-)
> > 
> > [...]
> 
> Applied, thanks!
> 
> [01/10] block: fix and cleanup bio_check_ro
>         commit: 57e95e4670d1126c103305bcf34a9442f49f6d6a
> [02/10] block: remove handle_bad_sector
>         commit: ad740780bbc2fe37856f944dbbaff07aac9db9e3
> [03/10] pktcdvd: remove a pointless debug check in pkt_submit_bio
>         commit: 47c426d5241795cfcd9be748c44d1b2e2987ce70


> [04/10] dm-crypt: stop using bio_devname
>         commit: 66671719650085f92fd460d2a356c33f9198dd35
> [05/10] dm-integrity: stop using bio_devname
>         commit: 0a806cfde82fcd1fb856864e33d17c68d1b51dee
> [06/10] md-multipath: stop using bio_devname

I had already picked these 2 up.. but happy to drop them.

>         commit: ee1925bd834418218c782c94e889f826d40b14d5
> [07/10] raid1: stop using bio_devname
>         commit: ac483eb375fa4a815a515945a5456086c197430e
> [08/10] raid5-ppl: stop using bio_devname
>         commit: c7dec4623c9cde20dad8de319d177ed6aa382aaa
> [09/10] ext4: stop using bio_devname
>         commit: 734294e47a2ec48fd25dcf2d96cdf2c6c6740c00
> [10/10] block: remove bio_devname
>         commit: 97939610b893de068c82c347d06319cd231a4602

I also picked up 2 previous patches from hch too:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=977ff73e64151d94811f4ba905419c90573f63e1
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=385411ffba0c3305491346b98ba4d2cd8063f002

Should those go through block too? Or is there no plan to remove
bdevname()?

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

