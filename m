Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507CCC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643303478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xc60YqqJvVwHR1CLrLxkttcuDaMoe4SSeB0tgGpTF48=;
	b=UZ440mnfz5NhYBa2+ovQflnUrflQvmnIUXozLCViPVIG8SCHwvkZJc7Oze+9IRK6qaJWCe
	3nQAyPo3YTh88nXGPjLBk2itRH6PQ1QHTxnOshjCxePvTniGcUJzVN+455QrBbNusE8iKR
	gxNdznzArJACNbuW8aCyoY7YellJJ/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-K-nHQibmNxS8m_cdEwSw5w-1; Thu, 27 Jan 2022 12:11:16 -0500
X-MC-Unique: K-nHQibmNxS8m_cdEwSw5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94FB48519E4;
	Thu, 27 Jan 2022 17:11:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A082753E3;
	Thu, 27 Jan 2022 17:11:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0DAAE1806D1C;
	Thu, 27 Jan 2022 17:11:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RHB9ax020142 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 12:11:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 833A3C27FA3; Thu, 27 Jan 2022 17:11:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F91EC27FA0
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 17:11:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 649C180B716
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 17:11:09 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-277-sRmsXwn6Nl-75hN28tJVCw-1; Thu, 27 Jan 2022 12:11:08 -0500
X-MC-Unique: sRmsXwn6Nl-75hN28tJVCw-1
Received: by mail-qv1-f70.google.com with SMTP id
	u15-20020a0cec8f000000b00425d89d8be0so1248168qvo.20
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 09:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=hISkPgWXBvxaPJR1A6cjvL239jVaZB/M99kE10NpdT4=;
	b=L2ShbuabA6kwT01j/JHIYdUH0xAtWLt3+s4+FlBp6PVpDIRbLBitn4CsdGvQjymejA
	363XTVKKk7oXmFbknyfQ/WbxZQrhYttbN7WIsvzCRbYpllztrg8O8TsUWDkzSTGdvqkc
	ApaUhO8BUlkCIsKWVbwilYMd3xQqQscoto9Cdiy3FboQq1FWR+lQALSrQFfHOY/sIvGT
	5YRjVruHJ2o67HDmmPOC5HmcjdPhbis1YQKvV4Qu4UiLhu3qbdTHu3tdNV5Jyy3R0Pqf
	1LXU1pEn7rxeeg8BSHHY5Zjb9rHMFe0PRdjUorglxOZec0SAWlx5zIsPNCDbURNScwY5
	98NQ==
X-Gm-Message-State: AOAM531ApfvIS0f7NTrORg5XCzHIQ5tjrhWACby2Q9rZOEYpRhurw2M3
	mzEVPT+KpR5NPk4E6NIKspnHqrxux8BGIU0N8CsaQn4awQY2pt1ZUHAtP50ilzP71XMJFluDYXy
	Nx4Yrqk6tyaYffw==
X-Received: by 2002:a05:6214:c2a:: with SMTP id
	a10mr4419663qvd.42.1643303467585; 
	Thu, 27 Jan 2022 09:11:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQanMj7Y00ur/yzuLmY8gwfKPDXJeoixdwOU4KzNAVApl7lAtazZ8/rD9LIFjZrTulwd1nlg==
X-Received: by 2002:a05:6214:c2a:: with SMTP id
	a10mr4419637qvd.42.1643303467335; 
	Thu, 27 Jan 2022 09:11:07 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id h6sm1661870qtx.43.2022.01.27.09.11.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 09:11:06 -0800 (PST)
Date: Thu, 27 Jan 2022 12:11:06 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YfLSKlF89y3Cbf+S@redhat.com>
References: <20220124091107.642561-1-hch@lst.de>
	<20220124091107.642561-8-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220124091107.642561-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 07/19] dm-snap: use blkdev_issue_flush
 instead of open coding it
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

On Mon, Jan 24 2022 at  4:10P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Use blkdev_issue_flush, which uses an on-stack bio instead of an
> opencoded version with a bio embedded into struct dm_snapshot.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

