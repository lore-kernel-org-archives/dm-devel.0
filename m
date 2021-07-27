Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8D1C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 16:18:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27EBD61B93
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 16:18:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 27EBD61B93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627402716;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LWmSn9zuMd3TTSfLjw2cxqFWq5fDuSpPeD5S3J+cnwk=;
	b=aFhoL+cmJwoXl96GXBy5P4eMPxUL6e+jZ5PqR/r/h6CMT79rpq4kBU0zM/aQayzWCeOSWM
	gXe8cdLO0lb7+4cT6SP3Yqyy84zKiSx9H5updh+Tc/TPx4SLBw3Hp+h48YjB6X0FLqJVJF
	QgotthKMX68vmZW2ZjwgQeCIG8E7e74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-xOEKd8fSOCi0BPdtoxuQAg-1; Tue, 27 Jul 2021 12:18:34 -0400
X-MC-Unique: xOEKd8fSOCi0BPdtoxuQAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9638B801592;
	Tue, 27 Jul 2021 16:18:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 729E160862;
	Tue, 27 Jul 2021 16:18:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B66F7180BAB0;
	Tue, 27 Jul 2021 16:18:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16RGIPqC012449 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 12:18:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9EE7910F8E32; Tue, 27 Jul 2021 16:18:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B06C100BFD4
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 16:18:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44FD28007B1
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 16:18:22 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-36-vZtqX37ROAycH2fs8o_bSQ-1; Tue, 27 Jul 2021 12:18:20 -0400
X-MC-Unique: vZtqX37ROAycH2fs8o_bSQ-1
Received: by mail-qt1-f199.google.com with SMTP id
	m2-20020ac807c20000b0290269bd8044e1so6616619qth.10
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 09:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=cM9tfLQOTWB4GCopgnP+9Qx/IyO9Pq6B7ebTSKwOWBY=;
	b=GAqSs38jLxAo9jXjvnYWmXpDysx8+woeC1KSxsxWUwE7ZBbpof7hvMLhjw2hlBZ8k/
	0nH8kGSY3NBUpvoOMP4him2NfMvwMbq11oTT0p06IOm7QjHhPQw21Wut8l7Pxr7ysxWe
	p1SYIUr65skXtIh6ONs+KZrNQBvB7mSDkDeiML4kMkLkttV26LA84ZR0fa9qO8IyWhyY
	PLANJvaqWWWM+3i5KQHI1z83i/UA/uzcjMakNB65vL7IMa0lAEL8V/5GkRKT824kSkaT
	6gZvgW+fUi7ArdTf16ZToDjVtrAtGJ9BMnt9IxXeolXUDNX677JpBx/37xG7hIeUBjrS
	Fkgg==
X-Gm-Message-State: AOAM530AlkAyUSWwUdv026X8M6wIy5QMSamXqVYTkbUp58MhtAunIAa/
	L02wFVQf4KRbBEXVcK3pm+4/9cFXuBjAWXqx5n8bHGsZsbOIpgWckgzPFUydEr9itQEYY+pDnMk
	gEg0Ybndow7xzdQ==
X-Received: by 2002:ac8:65da:: with SMTP id t26mr20558900qto.145.1627402700223;
	Tue, 27 Jul 2021 09:18:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcE/DRxSGmin8HOdxgpUGEuj7cvwjyi0toYmkFRns5e91de0cpGjH7LdY+CMdfWbVROh+tUA==
X-Received: by 2002:ac8:65da:: with SMTP id t26mr20558889qto.145.1627402700053;
	Tue, 27 Jul 2021 09:18:20 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id s19sm1609729qtx.5.2021.07.27.09.18.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 27 Jul 2021 09:18:19 -0700 (PDT)
Date: Tue, 27 Jul 2021 12:18:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQAxyjrGJpl7UkNG@redhat.com>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210727160226.GA17989@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 27 2021 at 12:02P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Jul 27, 2021 at 11:58:46AM -0400, Mike Snitzer wrote:
> > > This did not make a different to my testing
> > > using dmsetup and the lvm2 tools.
> > 
> > I'll try these changes running through the lvm2 testsuite.
> 
> Btw, is ther documentation on how to run it somewhere?  I noticed
> tests, old-tests and unit-tests directories, but no obvious way
> to run them.

I haven't tracked how it has changed in a while, but I always run:
make check_local

(but to do that you first need to ./configure how your distro does
it... so that all targets are enabled, etc. Then: make).

Will revisit this shortly and let you know if my process needed to
change at all due to lvm2 changes.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

