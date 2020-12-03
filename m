Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91067C4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:06:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B419720769
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:06:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B419720769
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-VlX0pNHtMoOilTjrcr-sYA-1; Thu, 03 Dec 2020 15:06:07 -0500
X-MC-Unique: VlX0pNHtMoOilTjrcr-sYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04948800D53;
	Thu,  3 Dec 2020 20:06:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0C2610013C0;
	Thu,  3 Dec 2020 20:06:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 15905180954D;
	Thu,  3 Dec 2020 20:06:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3K5xWs024996 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 15:05:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFDE42166B27; Thu,  3 Dec 2020 20:05:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA82A2166B2C
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:05:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1785858EEC
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 20:05:56 +0000 (UTC)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
	[209.85.222.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-310-Epz01jZ2PbyNRCvBwAeHPA-1; Thu, 03 Dec 2020 15:05:54 -0500
X-MC-Unique: Epz01jZ2PbyNRCvBwAeHPA-1
Received: by mail-qk1-f193.google.com with SMTP id x25so3375874qkj.3
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 12:05:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=+Xwp3VhRjy4dts4CXxk8hmlpAha093L76/jTyD6EHAk=;
	b=OCXx5E6uQkImEnetaPhFolyVgeFkQ9DRjZSuXuPawwvq97W411lKsHpGmvW8bQzXf9
	t/MOT+9O0v3rPjKInyyrPHBe9KmR2Lu9XONkeNzK+Ia9g9Q5IahZ9JXo2Y8F6D26azC+
	UVKW0djczY2tabtgrzAQnR4rGpNrZz/sd9wJQCLGkFBDleioOyu+gUfOfXDRoqHCjYZT
	bbZSxMPgAxHHYVa0tFKCNva70rKGDciDhlmWHJALowRVzESwiZr29sV3rEEcDtRbEtTa
	r84MZClOoo9lxvFDvk+PGnV8qpbJlAplHknU+kZFk5Q7rGD/gjw1jDEm90nHyz6ynvUO
	+Ykg==
X-Gm-Message-State: AOAM531xsI0HrCcYFJxENZU6RhvhcIsuZ8EpHVrZrST2Lv+OAqcsJXJA
	OtII2pajnLFjhgsRzPdpS3g=
X-Google-Smtp-Source: ABdhPJyKWN8EbN+Fnpp9ND+gTwSHvi7g7TVFpx7X/cBJ+f7FEf6dro8hCIRKfyjys3wu1ToCKUnFxw==
X-Received: by 2002:a05:620a:6c7:: with SMTP id
	7mr4693278qky.411.1607025954158; 
	Thu, 03 Dec 2020 12:05:54 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
	by smtp.gmail.com with ESMTPSA id o21sm2801606qko.9.2020.12.03.12.05.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 12:05:53 -0800 (PST)
Date: Thu, 3 Dec 2020 15:05:25 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8lFBVLizDnCrteh@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-3-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 2/5] block: simplify and extend the
 block_bio_merge tracepoint class
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

On Thu, Dec 03, 2020 at 05:21:36PM +0100, Christoph Hellwig wrote:
> The block_bio_merge tracepoint class can be reused for most bio-based
> tracepoints.  For that it just needs to lose the superfluous q and rq
> parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

