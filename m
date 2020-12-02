Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A260EC6369E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:07:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D06D1221FB
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:07:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D06D1221FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-BD-4cebxOUe9drFjxIN0wA-1; Wed, 02 Dec 2020 18:06:57 -0500
X-MC-Unique: BD-4cebxOUe9drFjxIN0wA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CD8F817B9E;
	Wed,  2 Dec 2020 23:06:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C3160854;
	Wed,  2 Dec 2020 23:06:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 036B74BB7B;
	Wed,  2 Dec 2020 23:06:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2N6oCk018821 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 18:06:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 459DF2166B29; Wed,  2 Dec 2020 23:06:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40D962166B27
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 23:06:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7BA0858EEC
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 23:06:46 +0000 (UTC)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
	[209.85.219.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-409-upxhJXifPLGDMAR_T4lwIA-1; Wed, 02 Dec 2020 18:06:44 -0500
X-MC-Unique: upxhJXifPLGDMAR_T4lwIA-1
Received: by mail-qv1-f65.google.com with SMTP id y11so72346qvu.10
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 15:06:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=JiLXK8qvyvyeu2ukVHQ2JpMMFoxaPcaESyT/VbSthbA=;
	b=Yus5lux0wz0qFmil8Q+IRyavV2ocFquZeGKvbeU4yIgta/Rvj/7Htcp1wfwGQjobKy
	/scTtMFw3SrvR6ez5vmta015scVC2gMHUBMv9FxNDjnSYjNrHsZKh8WiwDD0HROyElSH
	CoxzQHabCZBUQsNSsCwsJ+48uGwMbXwibdT3Y9L0TBWKnh4aLmTRjtUFAxZLjHDjRota
	0bawoYDuKVzzyrd6TBFxVDQbgxMgzmz95LK+2WfoZYVP3lYRN3eNqo47qI6pdmMC6fSx
	iA9GBDLd4EJP/jaEhtx7sILJ2uwtCXOIjPcdZZoNQKBRJY2tHv4FQpRTElEwh/Feg6Nc
	fTZw==
X-Gm-Message-State: AOAM531YdUJnbw+hoUDl3DwUEYc9nriK5auzKzTCVFvIKvV7p46PQo5g
	iC1S7mrA5iViyOhjdrZvpug=
X-Google-Smtp-Source: ABdhPJwZn5dxPl6m3pa1aEv5h1pGuTSJHgrMy6TrZ3GcAHDdgW4RCyry1okmV8UoY42HeFjIxVXUcw==
X-Received: by 2002:a05:6214:20a1:: with SMTP id 1mr449637qvd.61.1606950404181;
	Wed, 02 Dec 2020 15:06:44 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id 97sm427113qte.34.2020.12.02.15.06.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 15:06:43 -0800 (PST)
Date: Wed, 2 Dec 2020 18:06:14 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gd5vMizq+3d5cp@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-7-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-7-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 6/9] blk-mq: use ->bi_bdev for I/O accounting
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

On Tue, Dec 01, 2020 at 05:54:21PM +0100, Christoph Hellwig wrote:
> Remove the reverse map from a sector to a partition for I/O accounting by
> simply using ->bi_bdev.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

