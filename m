Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260F4C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 18:16:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-l2Dm1S_mO22GXLBT9zuqZQ-1; Wed, 08 Jun 2022 14:16:37 -0400
X-MC-Unique: l2Dm1S_mO22GXLBT9zuqZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1815329DD9AA;
	Wed,  8 Jun 2022 18:16:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5BCD9D7F;
	Wed,  8 Jun 2022 18:16:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 838F3194704A;
	Wed,  8 Jun 2022 18:16:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 469821947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 18:16:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24B881131A; Wed,  8 Jun 2022 18:16:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20BAA9D7F
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 18:16:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0536F101E165
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 18:16:35 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-qA7p7gSYPQa8K5_4-PyERw-1; Wed, 08 Jun 2022 14:16:28 -0400
X-MC-Unique: qA7p7gSYPQa8K5_4-PyERw-1
Received: by mail-qk1-f179.google.com with SMTP id 15so10913015qki.6
 for <dm-devel@redhat.com>; Wed, 08 Jun 2022 11:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hhMM47L2BUyuoiXuMFBaLENxxR94JQzFZtgdrCdFeOo=;
 b=aJNOKxoQyv1JR19i8gxTrDEBI7u1ymeaP2oOxifsjA3wEVpNl5vjhqiz0+0VLzSQ6M
 OEl1DylpBODcWIDSa44uzqQpuFFAMhveuKEKV/BWPiD2Ca1/2ETC5BwxHvb0Ry815O0e
 IjbyjumCGXZ+zS1XIY4cVUlt63/fwNdDJx6oMeUggA999clwvmN7oAZIFw5E0hDii55q
 C2mvZfwG+HTslZwkHTaX0e1VQLE7qq1GNPSbMh2P5lEVoLmzT7uOLlBVfk3lyzgyWFiE
 6iRIodjfiP+kCLy5To0/7uWN804Bo+/E4+nR/mQ4whzBtetu42nWR7gNdM/IvL7S6gsl
 G/HQ==
X-Gm-Message-State: AOAM532E0fglFshABudHeOgHGTe5N36PSHq4DmbZihLgJYami87B02UR
 ZdErlY7hu0e1BeXobGsbJDEow04=
X-Google-Smtp-Source: ABdhPJxv3g2qRGAfDYY619LqpL324bC2bj4rLn7oKWOFdWeAtRrRgbYDLLT2gspaeEQjYO7YkE2Alg==
X-Received: by 2002:a05:620a:2701:b0:6a6:c4b8:9d39 with SMTP id
 b1-20020a05620a270100b006a6c4b89d39mr10575457qkp.453.1654712187861; 
 Wed, 08 Jun 2022 11:16:27 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 m185-20020a37bcc2000000b0069c72b41b59sm16543495qkf.2.2022.06.08.11.16.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Jun 2022 11:16:27 -0700 (PDT)
Date: Wed, 8 Jun 2022 14:16:26 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YqDneqyp33PvkCLm@redhat.com>
References: <20220608063409.1280968-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220608063409.1280968-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] fix and cleanup device mapper bioset initialization
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 08 2022 at  2:34P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Hi Mike,
> 
> the first patch fixes the device mapper bioset to restore the previous
> behavior of preallocating biosets instead of allocating them at bind
> time, and to actually allocate pools for the integrity data.  The
> others are cleanups on top of that.
> 
> Diffstat:
>  block/bio.c           |   20 -------
>  drivers/md/dm-core.h  |   14 ++++-
>  drivers/md/dm-rq.c    |    3 -
>  drivers/md/dm-table.c |   66 ++++++++++++++----------
>  drivers/md/dm.c       |  136 +++++++++-----------------------------------------
>  drivers/md/dm.h       |    5 -
>  include/linux/bio.h   |    1 
>  7 files changed, 78 insertions(+), 167 deletions(-)
> 

All looks good to me.  Are you OK with me picking up the first 3 to
send to Linus for 5.19-rc2 (given the integrity bioset fix)?

And hold patch 4 until 5.20 merge?  Or would you prefer that cleanup
to land now too?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

