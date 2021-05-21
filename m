Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DBEC04FF3
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98BE46109E
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98BE46109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-wJKTByQpNDSVPUl6IGjDVA-1; Mon, 24 May 2021 02:47:50 -0400
X-MC-Unique: wJKTByQpNDSVPUl6IGjDVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A42D8107ACF5;
	Mon, 24 May 2021 06:47:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A5B56F135;
	Mon, 24 May 2021 06:47:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FC6155356;
	Mon, 24 May 2021 06:47:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14LHIHIr023210 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 13:18:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6393320951BD; Fri, 21 May 2021 17:18:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F63320951B0
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:18:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3C4780D0E0
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:18:13 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
	[209.85.214.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-22-GzcVKkqnO6yf3f6GxwS3eg-1; Fri, 21 May 2021 13:18:11 -0400
X-MC-Unique: GzcVKkqnO6yf3f6GxwS3eg-1
Received: by mail-pl1-f181.google.com with SMTP id t21so11344639plo.2;
	Fri, 21 May 2021 10:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=PKUzbY5iIGLiRwydllRSQJCscB+6IrSLbJrzulbqCPE=;
	b=QCBLsSbWydXK05A+S+/dnrtsd8q6iGtp9DVn9UXABdp6GvooAPz1UtRnFHfN/f912T
	uJhyupudWIuJUBvFe9tu7FSj4o35tObmPQYgwzYicLBOKKH+Pv8Ofv89BWVIef4om+Wk
	yprH+62Y6cZxPF79whBjj0gy6H6oEopjZDa7yVF0xFN1Bter7eTjmo+xK6GVP9I4qOOb
	mtOuwYwarRq5IRteeTYytwmUq+w9tnmHX9jMpDWs/I8Ua/mOESW+DgFPrD3cvAz41GVM
	Q1W/PsMvvvtXU6kXzOP/cseKCnuBy+JM2KzE/z8sXdXcTUKD1ESbA9XOKqm7qD7WdgXZ
	t19g==
X-Gm-Message-State: AOAM533Zy3Qps2CzD6Gxn18sAbvYOCPUC/88Q9D8fw0WpFbScDhfi26H
	4PZ22BZg/gGNil0J387kEBQ=
X-Google-Smtp-Source: ABdhPJwK8NtIAa5B5/oxZS0IR7nB67qYtN97nOKjvFJRfkRjUCvWO1h3QwEBBuBpXaKTLAx6Ca3tYw==
X-Received: by 2002:a17:903:30c4:b029:f0:ad43:4ca with SMTP id
	s4-20020a17090330c4b02900f0ad4304camr12902892plc.70.1621617489433;
	Fri, 21 May 2021 10:18:09 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
	by smtp.gmail.com with ESMTPSA id f5sm9178273pjp.37.2021.05.21.10.18.07
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 21 May 2021 10:18:08 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id 29A6B423A3; Fri, 21 May 2021 17:18:07 +0000 (UTC)
Date: Fri, 21 May 2021 17:18:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210521171807.GA25090@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-3-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 02/26] block: move the DISK_MAX_PARTS sanity
 check into __device_add_disk
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 21, 2021 at 07:50:52AM +0200, Christoph Hellwig wrote:
> Keep this together with the first place that actually looks at
> ->minors and prepare for not passing a minors argument to
> alloc_disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

