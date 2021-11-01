Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A56C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 19:59:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C1CA610D2
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 19:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C1CA610D2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-36yrXrwnPQSwVdBNBvbC6Q-1; Mon, 01 Nov 2021 15:59:30 -0400
X-MC-Unique: 36yrXrwnPQSwVdBNBvbC6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0897410B394D;
	Mon,  1 Nov 2021 19:59:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74BD45B826;
	Mon,  1 Nov 2021 19:59:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 599B24A703;
	Mon,  1 Nov 2021 19:59:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A1JsM05023212 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 15:54:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CE6852026D64; Mon,  1 Nov 2021 19:54:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C964E2026D67
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 19:54:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 396F7899EDA
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 19:54:16 +0000 (UTC)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
	[209.85.166.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-586-7ku2F_wkNcq3O2k8f1KccQ-1; Mon, 01 Nov 2021 15:54:13 -0400
X-MC-Unique: 7ku2F_wkNcq3O2k8f1KccQ-1
Received: by mail-il1-f180.google.com with SMTP id s3so19747874ild.0
	for <dm-devel@redhat.com>; Mon, 01 Nov 2021 12:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=koQbBQ21p1fsQdBlT5oLumJMTocgWXeZsx4RpVzAmQY=;
	b=UQMKjy+afL+j9B/aJepNLVPUWLutgto+YdoT7Eyaqd3DlgHhIOSN0HmEI8A4wN+jHI
	cFgg6bVc++iXxmcN/FWQChKc3QWBYApQ5uGJ7jM3m2QRFC28z2SsygGly2snEme5QQCQ
	MWONdL2AoIEJT/fAobECZZ23LcdRvMRVHeJqRNbNeYa4eLZt7GmQmtgzgHAg3+eRErSX
	PeEATegnDCKUN+OY0RAcecoUEzAxR0X5ndT6KVi+26Sz6ojDuxkK2eAc4gwJV3rg3rh4
	aBptVElk0rr3XJhoSVhycy+lgvh4yogc73vcXZrG38+IMLuUXSyDW0M6oYaN0zM4ENbv
	bfQw==
X-Gm-Message-State: AOAM531F5lAWdFdEqd5IZgjzNPz4IjTM/+DH1wBFF/Ilf6wAgzC9/Zvi
	z6qY/SL35MCc0H1M/78Dohe4yA==
X-Google-Smtp-Source: ABdhPJy/9YCvWsy4CcYhHnrFyE0rT2z+RApGafmCg/y4Tz/3v9B8FSsOihEyIPkQmLe0tOe8OerETw==
X-Received: by 2002:a05:6e02:1e02:: with SMTP id
	g2mr21957731ila.67.1635796452720; 
	Mon, 01 Nov 2021 12:54:12 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
	by smtp.gmail.com with ESMTPSA id
	h14sm8440390ils.75.2021.11.01.12.54.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 01 Nov 2021 12:54:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>
In-Reply-To: <20211021145918.2691762-1-ming.lei@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
Message-Id: <163579645206.169811.345176407474716806.b4-ty@kernel.dk>
Date: Mon, 01 Nov 2021 13:54:12 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Yi Zhang <yi.zhang@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: keep quiesce & unquiesce balanced
	for scsi/dm
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 21 Oct 2021 22:59:15 +0800, Ming Lei wrote:
> Recently we merge the patch of e70feb8b3e68 ("blk-mq: support concurrent queue
> quiesce/unquiesce") for fixing race between driver and block layer wrt.
> queue quiesce.
> 
> Yi reported that srp/002 is broken with this patch, turns out scsi and
> dm don't keep the two balanced actually.
> 
> [...]

Applied, thanks!

[1/3] scsi: avoid to quiesce sdev->request_queue two times
      commit: 256117fb3b4f8832d6b29485d49d37ccc4c314d5
[2/3] scsi: make sure that request queue queiesce and unquiesce balanced
      commit: fba9539fc2109740e70e77c303dec50d1411e11f
[3/3] dm: don't stop request queue after the dm device is suspended
      commit: e719593760c34fbf346fc6e348113e042feb5f63

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

