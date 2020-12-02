Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF39C6369E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:40:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA4F6221F7
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA4F6221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-Izd3ihSeMwauRDPOFE4FFA-1; Wed, 02 Dec 2020 17:40:12 -0500
X-MC-Unique: Izd3ihSeMwauRDPOFE4FFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BED833E747;
	Wed,  2 Dec 2020 22:40:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B60C19C44;
	Wed,  2 Dec 2020 22:40:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 457A94BB7B;
	Wed,  2 Dec 2020 22:40:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2Me6Gc015406 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 17:40:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 94E38D7B02; Wed,  2 Dec 2020 22:40:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D7B3D7B0B
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:40:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 091D7858EEC
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:40:04 +0000 (UTC)
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com
	[209.85.222.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-506-bEHk9m5FMseSq-KM_foC_g-1; Wed, 02 Dec 2020 17:40:01 -0500
X-MC-Unique: bEHk9m5FMseSq-KM_foC_g-1
Received: by mail-qk1-f194.google.com with SMTP id b144so332992qkc.13
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 14:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=lcXYuHAwEN3bFhp+hU4mksRhemmvNH25lzSQUI1hows=;
	b=F2oOyYl7UtUGcTLWs18hIIf3eFtFy9FBkq0dueWwLDr6ohmHcd3lyNRzGb8oxjQwZH
	zvbT6NmnildT/B2S5UXM2RZ8Qr7bveCrMjUw8bevlW7qTXmdE5QRm6eQBQv4eM15V+Jn
	H+R4UKeN5AhjZrG80b4bSXe3WMTWWuQr3M4traNzzXPrnqJBsuijp8wSpRGN+tCp+BxD
	QLN37i2e2xmlWecWzsO0XcKfyc6zFl2AysYJv+D+p2yJo/9MloC0XeUqNiJpssnsI6QQ
	EFNgowEnRJm/VZTkSKt4b++SBF6ZrEd9nKsImt24fQ4HvzWqLRpn0+an/xfjOasxMtCI
	h3wQ==
X-Gm-Message-State: AOAM532rVS4FSbzPZ7AZ9og2YS0keDpCEDqxpSoLAfImU5KrPFqMmsM4
	GdKqroBt0V7B6Mql0XprrYg=
X-Google-Smtp-Source: ABdhPJzlGJwRriEEpzrUJVGgCffXwM6L1NA2hwaKhO2rHq7h+FQnF+3tfM3qdL7QbQn44WCGvJfk/g==
X-Received: by 2002:a37:4854:: with SMTP id v81mr42262qka.20.1606948801332;
	Wed, 02 Dec 2020 14:40:01 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id y192sm67899qkb.12.2020.12.02.14.40.00
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 14:40:00 -0800 (PST)
Date: Wed, 2 Dec 2020 17:39:32 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gXpGs34mQTeSJ6@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/9] brd: remove the end of device check in
	brd_do_bvec
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

On Tue, Dec 01, 2020 at 05:54:16PM +0100, Christoph Hellwig wrote:
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

