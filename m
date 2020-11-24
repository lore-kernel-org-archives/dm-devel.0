Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D022C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 18:04:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A19CF208FE
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 18:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A19CF208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-ZOxdMCLoPHKONyZx9xrLLQ-1; Tue, 24 Nov 2020 13:04:19 -0500
X-MC-Unique: ZOxdMCLoPHKONyZx9xrLLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DF02107ACE8;
	Tue, 24 Nov 2020 18:04:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B51C1001B2C;
	Tue, 24 Nov 2020 18:04:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54CD7180954D;
	Tue, 24 Nov 2020 18:04:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOI48WI025363 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 13:04:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 78E582166B27; Tue, 24 Nov 2020 18:04:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 707A32166B2B
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 18:04:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E2B0103B80C
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 18:04:06 +0000 (UTC)
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com
	[209.85.222.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-545-UbqEaHzZNKaKdpBpx0S_gA-1; Tue, 24 Nov 2020 13:04:00 -0500
X-MC-Unique: UbqEaHzZNKaKdpBpx0S_gA-1
Received: by mail-qk1-f196.google.com with SMTP id b144so7144161qkc.13;
	Tue, 24 Nov 2020 10:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=8qZ2mbF42a4EoCPjpueBEzfe9XOwF2IptTReGgUwObs=;
	b=t3qe2nsUCVuTgFYWUsd31lE7i9wdxVmirDc0jAmcJqpIbE6yKfufL4+hyvdpZrhnhS
	FpKEyBEQ1NKUDAi5OE+Ktuiei4dj++UAq2Iwa03k78hE+koWl/nLIsApoeq5eBXS1ZGy
	OQYLWH6Ekq1svGkEGSwg3u+Rowsrzxwcjmqr8XXUJYkmTLmDksL2ekIHsF3qpAnjv0mw
	pxBn2P+YBdDGIStFzwi+4wCFSvYvKFhzgTfjh6SlUJM+f3uMMcTctgubhliIq/u4Y7uC
	EvkD8eeLd83CZF/Y3zVs3g98iQ5q2nu1eyYKagtADi3+TM84rMdXSNQ3j6/tec57FEZL
	ELUw==
X-Gm-Message-State: AOAM533IJbaYQPNufLZUsxGp7y3pYUG75xAZOIidg9+W4trJT1WVSk4W
	/+Keg5Blg+G/H8mZ8aartRA=
X-Google-Smtp-Source: ABdhPJypHMVf10j8dqLbG3/kMc2wzxScN+9Rw3Fm44OZCed30V+ovAuzBFJQGc76NiRl6CUPNsyaww==
X-Received: by 2002:ae9:e007:: with SMTP id m7mr5836885qkk.416.1606241040110; 
	Tue, 24 Nov 2020 10:04:00 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	c14sm13621716qko.29.2020.11.24.10.03.58
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 10:03:59 -0800 (PST)
Date: Tue, 24 Nov 2020 13:03:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71K+JS+xnGs+EPF@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-22-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-22-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 21/45] block: refactor blkdev_get
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:27PM +0100, Christoph Hellwig wrote:
> Move more code that is only run on the outer open but not the open of
> the underlying whole device when opening a partition into blkdev_get,
> which leads to a much easier to follow structure.
> 
> This allows to simplify the disk and module refcounting so that one
> reference is held for each open, similar to what we do with normal
> file operations.
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

