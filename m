Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B61DEC43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 07:33:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-u53opJiFOZmc3UiT3lxO-w-1; Thu, 16 Jun 2022 03:33:32 -0400
X-MC-Unique: u53opJiFOZmc3UiT3lxO-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E1CA3802B95;
	Thu, 16 Jun 2022 07:33:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21C1740EC003;
	Thu, 16 Jun 2022 07:33:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77AEF1947063;
	Thu, 16 Jun 2022 07:33:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50F7019466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:48:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E0FD2026D07; Wed, 15 Jun 2022 10:48:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 19DA22026D64
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:48:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F255685A580
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:48:27 +0000 (UTC)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
 [209.85.215.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-mfq5XfLKOn2VdNOdR_NIxA-1; Wed, 15 Jun 2022 06:48:26 -0400
X-MC-Unique: mfq5XfLKOn2VdNOdR_NIxA-1
Received: by mail-pg1-f179.google.com with SMTP id g186so11045264pgc.1
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 03:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HrPrkJE8jizmZIqhjR7LQQh1Vy5Akz1+QA5vz7RPuSk=;
 b=nQfTq5Ay7aiIVtnPFL7OfSem77b8ldJXPFxuHZQktTzgagWb6fZEeqGD8gXJInOGWA
 IF4uawvUhIoDi/VOjxQxULHmYNn9DXAW+b1lg1d3CecID4mzNBPkzuNa3oKb0lFY+yh4
 Ig1pLGto+JU1Y9b84jCH4IaCa13UtlqBO+76FqDrIFzuYpDX4gv6MkIdd7Vp8Q4kdgZd
 YcGwWsgXd8+2h0ikVICDnYbc0C0Wx7A+JqeE1aM2QRT7opfBvgGDR22YGFU6sBa2PL6v
 tP3SAKoNeXpeRq08AYWW0VV4tg9MNHxwlCalEdfpLELUTXOpfhVKESgrRKdVCQbAOfg3
 k6AQ==
X-Gm-Message-State: AOAM530U3BXi22ZgUerrbposI/TnJ47g4SmsuR/vrbqh69bY89bTUfKK
 4mR9xZB9oCZkmyVyuEJQZUEYNw1ufDCxAMQW
X-Google-Smtp-Source: ABdhPJz7ZbBbl7wxI6LXLgjMNlNPP9/7Hlq97hsR7lvjDGmbeuo+s60Er61Z7FjbgGtaYintJm1hJg==
X-Received: by 2002:aa7:9493:0:b0:522:8317:b675 with SMTP id
 z19-20020aa79493000000b005228317b675mr9242373pfk.61.1655290105134; 
 Wed, 15 Jun 2022 03:48:25 -0700 (PDT)
Received: from localhost ([122.183.153.161]) by smtp.gmail.com with ESMTPSA id
 a15-20020a62d40f000000b0051f2b9f9b05sm9572348pfh.76.2022.06.15.03.48.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Jun 2022 03:48:23 -0700 (PDT)
Date: Wed, 15 Jun 2022 12:48:21 +0200
From: Pankaj Raghav <pankydev8@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20220615104821.oyuz7x3a2c4klcd5@quentin>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220614090934.570632-6-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Thu, 16 Jun 2022 07:33:27 +0000
Subject: Re: [dm-devel] [PATCH 5/6] block: fold blk_max_size_offset into
 get_max_io_size
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
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pankaj Raghav <p.raghav@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 14, 2022 at 11:09:33AM +0200, Christoph Hellwig wrote:
> Now that blk_max_size_offset has a single caller left, fold it into that
> and clean up the naming convention for the local variables there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-merge.c      |  9 +++++++--
>  include/linux/blkdev.h | 19 -------------------
>  2 files changed, 7 insertions(+), 21 deletions(-)

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

