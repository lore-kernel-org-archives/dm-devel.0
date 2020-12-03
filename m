Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25F5C4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:10:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECE8A221F2
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECE8A221F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-zAnNCRcoMxOndWNqXt3LEw-1; Thu, 03 Dec 2020 15:10:45 -0500
X-MC-Unique: zAnNCRcoMxOndWNqXt3LEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 016F4800D55;
	Thu,  3 Dec 2020 20:10:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D426E6086F;
	Thu,  3 Dec 2020 20:10:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A013F4BB7B;
	Thu,  3 Dec 2020 20:10:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3KAcsH026726 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 15:10:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B4FF72166B2B; Thu,  3 Dec 2020 20:10:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF7F62166B27
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:10:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83522186E121
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:10:36 +0000 (UTC)
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com
	[209.85.160.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-152-ipUKuWznN3u2mBV9pPbFqQ-1; Thu, 03 Dec 2020 15:10:34 -0500
X-MC-Unique: ipUKuWznN3u2mBV9pPbFqQ-1
Received: by mail-qt1-f194.google.com with SMTP id d5so2345958qtn.0
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 12:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=a8LN6ZMh1M/sLnx8l9ItuSsvA2D1+o6tHt6Iazu8FfA=;
	b=CoRmGdYtUBDMqYvUn7lUWhjdNN01y8gYMgbvO3lgmggqXrbJqNdyt+J96KEnhypM0g
	l2X6dOEziDeWAQTOKa8Cdw/ysnBKGYXWInzXy973BjcXUEDfdKRl3B1HBdj6WcFHQqHw
	waF8sTzcm+5Eu8ni52/9LOWCUqP/bMslesHtTX3bk0anLC4uTNdezRQnY05+Xxk46whv
	Jv5dphoxhW667P+ldLc5lkHXa9cj829oGuc3QwbkQDdpZz4xtPSRe9cbLoH3VasRRDoH
	/aCXIkD0ET4L+IYQ1RyjlWe7xptXbptFP7rqvKLetQ2gcX0Xxr2b/OjLuffD+X3k7ceI
	Zc1Q==
X-Gm-Message-State: AOAM533zgHLEzxOlNlDVo1B9r7b9KTRecGRbBV5gNoTPhCLLysvP5MDF
	Eh6H8NSP9KcVqxw2cnDct/Y=
X-Google-Smtp-Source: ABdhPJzqV5axT2LpRD7VrsKOBiSHz4rEGBYx02OU7G8vHf12Od6N8kKCv6sRz1NJS75gA4WM1kHwOw==
X-Received: by 2002:ac8:5741:: with SMTP id 1mr5012184qtx.294.1607026233859;
	Thu, 03 Dec 2020 12:10:33 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
	by smtp.gmail.com with ESMTPSA id
	z20sm2507477qtb.31.2020.12.03.12.10.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 12:10:33 -0800 (PST)
Date: Thu, 3 Dec 2020 15:10:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8lGHsA/qnypPrTN@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-6-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 5/5] block: remove the request_queue to
 argument request based tracepoints
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 05:21:39PM +0100, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the request.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

