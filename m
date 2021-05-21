Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9464C04FF3
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 581056109E
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 581056109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-gKrmrkU2NDGCrDeu2GBeuw-1; Mon, 24 May 2021 02:47:40 -0400
X-MC-Unique: gKrmrkU2NDGCrDeu2GBeuw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A59C5501E0;
	Mon, 24 May 2021 06:47:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 871D45FC17;
	Mon, 24 May 2021 06:47:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CF9155345;
	Mon, 24 May 2021 06:47:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14LHMnsA023569 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 13:22:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1D3542177A02; Fri, 21 May 2021 17:22:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18BAE2172F1F
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:22:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAB9A85828E
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:22:45 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
	[209.85.210.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-463-GcEk9cSoMtelsps4tbZpCw-1; Fri, 21 May 2021 13:22:41 -0400
X-MC-Unique: GcEk9cSoMtelsps4tbZpCw-1
Received: by mail-pf1-f169.google.com with SMTP id f22so7026434pfn.0;
	Fri, 21 May 2021 10:22:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=4xwt7H3ydSynAZjOEHISSkaEhx58URrfefqnsYajrYo=;
	b=DmSoVEQZV2Ti1/y3rZS0TtDN0E3YP8q/zJyZXVDRFoi6Y/f/jDZ/rZcsYi1rwzHodq
	hFMbXVX5mb3lh/X9Nd8FmWPHhUmSawn7m9BWN4pDUskq+Pcv51qeHvHZRo/yyMVVaqA+
	Pe6U938CvVOfidLpAPTeRsrQ55ZwPPgpOOIAwhdze4mqcNW8ULJTBqywDvx2xXdRn3jb
	RiGzxqJgF193XCN30/s8B4GYMdWwTqNuBOksMsPCiJFQ1Me3covBYPNkroWBqpS/g4NG
	wuWZPeHOTN+m+ypCzNDSIEFOvHL1jrHBMd5aemszlsMiLk5DcZAGN6JTHEQ1APGwNE1i
	5xAg==
X-Gm-Message-State: AOAM5306xgfROVlM6jR+J8OKjNHoZFKGSHjw+aUA4w0h/fuhWDqHIfRT
	i/j0nbWclZR+mFdFtnZAcCc=
X-Google-Smtp-Source: ABdhPJwN/SKOVHqzTq8eMNvLlpfI5p0TUMMcGqBBBfFtPi25TxwCtdfeNJoGCkAE3FkaxK6OlRwjhQ==
X-Received: by 2002:a63:bc19:: with SMTP id q25mr11009138pge.211.1621617760179;
	Fri, 21 May 2021 10:22:40 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
	by smtp.gmail.com with ESMTPSA id
	o10sm4951196pgv.28.2021.05.21.10.22.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 21 May 2021 10:22:38 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id F13FE423A3; Fri, 21 May 2021 17:22:37 +0000 (UTC)
Date: Fri, 21 May 2021 17:22:37 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210521172237.GA25156@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-4-hch@lst.de>
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
X-Mailman-Approved-At: Mon, 24 May 2021 02:47:09 -0400
Cc: nvdimm@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
	Mike Snitzer <snitzer@redhat.com>, linux-m68k@vger.kernel.org,
	linux-nvme@lists.infradead.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Joshua Morris <josh.h.morris@us.ibm.com>,
	linux-s390@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Matias Bjorling <mb@lightnvm.io>, Nitin Gupta <ngupta@vflare.org>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-xtensa@linux-xtensa.org,
	Alex Dubov <oakad@yahoo.com>, Heiko Carstens <hca@linux.ibm.com>,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
	drbd-dev@tron.linbit.com, Philip Kelleher <pjk1939@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>, linux-mmc@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 03/26] block: automatically enable
 GENHD_FL_EXT_DEVT
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 21, 2021 at 07:50:53AM +0200, Christoph Hellwig wrote:
> Automatically set the GENHD_FL_EXT_DEVT flag for all disks allocated
> without an explicit number of minors.  This is what all new block
> drivers should do, so make sure it is the default without boilerplate
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

