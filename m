Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DA7C64E7B
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:40:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0AC3C221F7
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AC3C221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-rUVlgEF_OTORwrb-xAynjQ-1; Wed, 02 Dec 2020 17:40:30 -0500
X-MC-Unique: rUVlgEF_OTORwrb-xAynjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ADAD107B45F;
	Wed,  2 Dec 2020 22:40:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A8EE19C44;
	Wed,  2 Dec 2020 22:40:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 40FA2180954D;
	Wed,  2 Dec 2020 22:40:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2MeO2N015436 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 17:40:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 19DF11018E59; Wed,  2 Dec 2020 22:40:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14F6F1018CBE
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:40:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AB86858284
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:40:21 +0000 (UTC)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
	[209.85.160.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-290-ZxOOlrDWP6SiPAzJFGmuaA-1; Wed, 02 Dec 2020 17:40:19 -0500
X-MC-Unique: ZxOOlrDWP6SiPAzJFGmuaA-1
Received: by mail-qt1-f195.google.com with SMTP id 7so42161qtp.1
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 14:40:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=5VWMK8riaN21ed1mnCTXtrML+Qu3sFGPDoSWLxZbmqc=;
	b=ssTHtvUVC5Pi3q1ebGX+0xWfQ3VP+ufk3iJfNJI28wSWsByuZ0XoU+UBs7qVRL1Pex
	IOHWtRudO0NbMqiOOCEhO4TvVSU9U+2J/YAhKCkCz+uQ2wB4OIHLYC8jachUAQUV+ZSl
	0n/0300QPeu2hOOxGahaKjdm5GTiZ7/Cq/C+NVU8PwPOBhFPyC+ihJD/I/+WG26hlHua
	cDlrnLcYezaz0pTU6yUd6E+Q2ioEBYkxYUaezYKsOqhe19ksJdubAA9Z5IDvshB5wK4J
	Y/YShsJ5n6LgdG+Q3KNOaNzTRwCV4eyEZb4LY7GLgQ8LQ0W4QR9KerK3w2TVV8w3F3Oq
	Hy6Q==
X-Gm-Message-State: AOAM532SkdTS7vjztJZcvMtMPXW0NXcrJhYWeFiBt7zLnL6Wp2N3877E
	FcNYnvRsZHCCVAyPie5LFlg=
X-Google-Smtp-Source: ABdhPJyoCrR3r2+acO4knNjPoALcWJhpUyJ+Mg39+EUGpGq4eXtk9K7kIBllhBrw6AWtpTUnu8G/Fw==
X-Received: by 2002:a05:622a:208:: with SMTP id
	b8mr441919qtx.124.1606948818638; 
	Wed, 02 Dec 2020 14:40:18 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id b64sm56207qkg.19.2020.12.02.14.40.17
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 14:40:18 -0800 (PST)
Date: Wed, 2 Dec 2020 17:39:50 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gXtv4ULMBfVc2p@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/9] dcssblk: remove the end of device check
 in brd_do_bvec
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01, 2020 at 05:54:17PM +0100, Christoph Hellwig wrote:
> The block layer already checks for this conditions in bio_check_eod
> before calling the driver.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

