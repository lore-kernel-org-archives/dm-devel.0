Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE03C4742C
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:40:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D3B12076E
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:40:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D3B12076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-uuPqmZoeMDeV55GaW_erag-1; Mon, 16 Nov 2020 10:40:25 -0500
X-MC-Unique: uuPqmZoeMDeV55GaW_erag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDECE8797E1;
	Mon, 16 Nov 2020 15:40:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A7FC6EF55;
	Mon, 16 Nov 2020 15:40:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6707183D024;
	Mon, 16 Nov 2020 15:40:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGFeIpH022988 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 10:40:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 59CB3200E1E0; Mon, 16 Nov 2020 15:40:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54C862023598
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:40:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC52811E78
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:40:15 +0000 (UTC)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
	[209.85.166.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-494-cSLYsr1FPFekmXxa6PQEwg-1; Mon, 16 Nov 2020 10:40:13 -0500
X-MC-Unique: cSLYsr1FPFekmXxa6PQEwg-1
Received: by mail-io1-f42.google.com with SMTP id o11so17822186ioo.11
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 07:40:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=tp0p5PHbr2FkOYp8vx6enMy9SJ7npMGO8ToOlTZAVD0=;
	b=QYCcmW10iy0qcf19svS3h6oEV/I6Rc9SvStP0DgOFoPL52LX7GlB4HwzI4qcB5UXqb
	+j6tVTceqFPTQEdi+k63V2uMO/VdCFtcG+iTELSz5pr2EX+P0RA+3WpkjYUQGPDdl9Sz
	utmc4Z+guiY+tOJ59F/6ISUSkgx3lG7IERq0BcCkWOM/JC3BJPKp/50Urg5b4h7OHemN
	EIinjp5RSiFyU0GviOUJDjdcPI8jUjkjzavw7+VEqF0K0CPDMiROtbCCnqQOF5rrzKVC
	DOfxbstJ4Mc1ZQN7z3oEkAjmjFK4H8j2xLLnxSW6wscswV4g4wW+Nh5Wi5Ij+ezv17pX
	p5/g==
X-Gm-Message-State: AOAM532p0mmi3aMYYfAB0axykLmTeetdDpvYaq8Iwnyme1bDLaHuby5a
	YjOsPQLfYOF6iSC0JyC9flVNDg==
X-Google-Smtp-Source: ABdhPJzORiPywjBgXN2NzytHbmvXHQyepXDfzUWSZfRzXJXzcmliMaw8xrhzAaFsEhdxvHHHShuK7g==
X-Received: by 2002:a5e:9e0b:: with SMTP id i11mr3534187ioq.33.1605541212314; 
	Mon, 16 Nov 2020 07:40:12 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id
	i82sm10491839ill.84.2020.11.16.07.40.10
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 16 Nov 2020 07:40:11 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <506876ff-65b0-7610-6f9e-8228fcd201c8@kernel.dk>
Date: Mon, 16 Nov 2020 08:40:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
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
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] cleanup updating the size of block devices v3
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/16/20 7:56 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series builds on top of the work that went into the last merge window,
> and make sure we have a single coherent interfac for updating the size of a
> block device.
> 
> Changes since v2:
>  - rebased to the set_capacity_revalidate_and_notify in mainline
>  - keep the loop_set_size function
>  - fix two mixed up acks

Applied 1-23 for 5.11, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

