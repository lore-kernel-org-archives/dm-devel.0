Return-Path: <SRS0=SKY2=EP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981A6C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:08:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E91B820678
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E91B820678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-99H-KHTWPzSaI_apbK856w-1; Mon, 09 Nov 2020 13:08:15 -0500
X-MC-Unique: 99H-KHTWPzSaI_apbK856w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F59F10B9CB9;
	Mon,  9 Nov 2020 18:08:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3C141002C1D;
	Mon,  9 Nov 2020 18:08:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FADBCF63;
	Mon,  9 Nov 2020 18:08:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A9I81px026265 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 13:08:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8ABBE1000D9A; Mon,  9 Nov 2020 18:08:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86711110F730
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 18:07:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27F538007A4
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 18:07:59 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
	[209.85.160.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-190-Imgkb958MmmWGFwjb-6nrg-1; Mon, 09 Nov 2020 13:07:56 -0500
X-MC-Unique: Imgkb958MmmWGFwjb-6nrg-1
Received: by mail-qt1-f177.google.com with SMTP id h12so6636331qtc.9
	for <dm-devel@redhat.com>; Mon, 09 Nov 2020 10:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=7NGOsjZERbiE5w2MHC1mFU2jxp4Wb+n3njEEiJYjdrs=;
	b=kwlkDqEqTkibY1aRqQ0M8UO9smolNGr+LsKHrC+XZ8YGkuGf8OoifbzBZBjeY6EV3p
	FEbXF5BXY41TwwAZTPA3kP5TXWJgsamlOmBqvyd/Rmz4GGCeYlr9UEcnaBC5OWiswloW
	97HgiAcd95z+v2dAeJNv7L9C/09+TK//eIyL2jPQp9kZBkMu49JA9P9ZanRj/uw0hkKQ
	QSfP4dg8NHeLr32d0Phlx9Z4i81gidGHZEFpZx0x+1w2x6pV7BIuP7Cj9nsY03fID7RI
	O6QORmP5ajoDjVvjMzFwsTAqU3Y4FxocW9MikMULznCwF8GO3dKULHHff9bzcCLn9s8k
	SW3w==
X-Gm-Message-State: AOAM533kQ4KcQnpGpn/3gKf7px+/DoRodQAHLmtzoKedjvhgH0c7MjYv
	yTChpSgTWPZC0wxnYrBZxoxtJg==
X-Google-Smtp-Source: ABdhPJz1XdtisV/lRv5ASDEyKBu7yVqtI15E3NOcCNcW+bkgomAeHWz+gX9FyFOWQktTiYmlqxOYiw==
X-Received: by 2002:aed:3147:: with SMTP id 65mr14719130qtg.295.1604945276157; 
	Mon, 09 Nov 2020 10:07:56 -0800 (PST)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com.
	[174.109.172.136])
	by smtp.gmail.com with ESMTPSA id z2sm6588768qkl.22.2020.11.09.10.07.54
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 09 Nov 2020 10:07:55 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201106190337.1973127-1-hch@lst.de>
From: Josef Bacik <josef@toxicpanda.com>
Message-ID: <7ddd60ce-f588-028f-7e47-2df4d52e22d5@toxicpanda.com>
Date: Mon, 9 Nov 2020 13:07:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201106190337.1973127-1-hch@lst.de>
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
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	nbd@other.debian.org, linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] cleanup updating the size of block devices
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
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/6/20 2:03 PM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series builds on top of the work that went into the last merge window,
> and make sure we have a single coherent interfac for updating the size of a
> block device.
> 

You can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

for the nbd bits, thanks,

Josef

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

