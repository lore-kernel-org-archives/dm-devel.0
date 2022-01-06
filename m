Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7694C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641480169;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=htAIp9sQX0S1la5lPN43rKoJXZjlwh0j+Trki+BIyEk=;
	b=Jmw9GdJiH/QPS9jDUeDD0C1DMXGgCaYSCARBkK5MHoZSuC/7q6WQZ4dRQtAtL0VyF0xF2H
	mQErDLxA8fZO4dByKUyMLQY75wwflGGxcTPxPQhekZqEH16p+iXa3Wt71bUYHpJEnf5NAs
	0yk1higkijPWapuomay7LBvyQUUE1Vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-ITlRrp3hMryknpSr8MiW7Q-1; Thu, 06 Jan 2022 09:42:48 -0500
X-MC-Unique: ITlRrp3hMryknpSr8MiW7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 244C9801AAB;
	Thu,  6 Jan 2022 14:42:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF0552B45E;
	Thu,  6 Jan 2022 14:42:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5BE74BB7C;
	Thu,  6 Jan 2022 14:42:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206Egdmu027990 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 09:42:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AEA80492D4A; Thu,  6 Jan 2022 14:42:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA325492D1F
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 14:42:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8582C1064FAE
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 14:42:39 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-133-R23M3D7vMHq3A_4ZoIxPag-1; Thu, 06 Jan 2022 09:42:38 -0500
X-MC-Unique: R23M3D7vMHq3A_4ZoIxPag-1
Received: by mail-qv1-f69.google.com with SMTP id
	10-20020a05621420aa00b00413d3d66bbfso1924920qvd.17
	for <dm-devel@redhat.com>; Thu, 06 Jan 2022 06:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=ziI0c5zpDrfARzHWSXczYyQXV4rhV2uF5H/yu3MCuIA=;
	b=s4SXMzBK1TgMwpqh4HYkSq4cpxk5zfpgUBZ4TtS83J24Xb/zFL2R4aPKJsNfVlpROz
	2xeJ44Xhh2ugJ6TGxGVCtVMCeqsZzfWGnerp7+Fs3Og1oYwfKdBMKBCRBpxtGRi/R0nG
	gygkume8mL1frhh7BSoEka2q34RK2Q5aKSvz8F5KZDETgn5cz73Z3Mn0Q9WudZ/9SgvN
	ZwnkrT0ItqPrTjF9Exd5jcZ53zl5pJlVWYbRZoG3Wj64tx/2keetKfPXMdNAhXxsPwXN
	dsPInKi9R5ianAfpWZ7O8SSm1Rug68uWYBgMncY4p5OVoMhas3/UXBcX1o+V4bQfAvis
	Pqqw==
X-Gm-Message-State: AOAM5327RdeNJjzNu8g9YOsILse9hwmCqhL26XCUfwKL+Xn3ebJ4qkeG
	rt1nMksbOlWP3vXYHSku+a97/58I7WELfdKo3AYSCprVBoivsHHmm3Tyv8IdpYBu+YBwnaHoN17
	zMraTK63GrwNyDw==
X-Received: by 2002:a05:620a:bcc:: with SMTP id
	s12mr40958060qki.440.1641480157683; 
	Thu, 06 Jan 2022 06:42:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3FRhHacqx3hvXCbD5dR5jpsBPvBE8m7URZnWLXDzc/nf2wfv2oNDbZeyhxFZfEJhygNyDig==
X-Received: by 2002:a05:620a:bcc:: with SMTP id
	s12mr40958035qki.440.1641480157454; 
	Thu, 06 Jan 2022 06:42:37 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id t3sm2038461qtc.7.2022.01.06.06.42.36
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 06 Jan 2022 06:42:37 -0800 (PST)
Date: Thu, 6 Jan 2022 09:42:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Ydb/3P+8nvjCjYfO@redhat.com>
References: <20211215084508.435401-1-hch@lst.de>
	<20211215084508.435401-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211215084508.435401-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/4] dax: remove the copy_from_iter and
 copy_to_iter methods
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 15 2021 at  3:45P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> These methods indirect the actual DAX read/write path.  In the end pmem
> uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> while device mapper picks redirects to the underlying device.
> 
> Add set_dax_nocache() and set_dax_nomc() APIs to control which copy
> routines are used to remove indirect call from the read/write fast path
> as well as a lot of boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com> [virtiofs]

Late to the game here, but quite a lot of dax DM code removed, thanks!

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

