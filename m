Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7CAC388F9
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 15:15:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3668F206F4
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 15:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ivdji5Sn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3668F206F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604848533;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RuN5cW7kMu7E+lclxAe9sqv2hSi9BXB1S6Q7iB/Keu8=;
	b=Ivdji5SnkDHmcicahVZ71s9Mse+aRXZnkkoAD/VIJpRtuGacRr+c9nKY2Fo3HGnlyvz5t1
	GHShNzuVKAtEwfMpA2MJEX/ncRg10WRA8vPH4jt6v7jb08Q083fcCXyfRJ/EH9PoZfspCu
	ntCxUP/7cVah8J0BVFvbW48lypwGNaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-XCCIk0F3OzWmC0SHxBjSXA-1; Sun, 08 Nov 2020 10:15:28 -0500
X-MC-Unique: XCCIk0F3OzWmC0SHxBjSXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 145EC185A0C3;
	Sun,  8 Nov 2020 15:15:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A0F36EF6A;
	Sun,  8 Nov 2020 15:15:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 34493180B658;
	Sun,  8 Nov 2020 15:15:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A8FFEbR013185 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 8 Nov 2020 10:15:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DD3F947CEF; Sun,  8 Nov 2020 15:15:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7C0A47CE9
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 15:15:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92AB21021F85
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 15:15:12 +0000 (UTC)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
	[209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-419-r1aWyhFpONWaOYPIknHtlQ-1; Sun, 08 Nov 2020 10:15:08 -0500
X-MC-Unique: r1aWyhFpONWaOYPIknHtlQ-1
Received: by mail-wr1-f71.google.com with SMTP id h8so3078191wrt.9
	for <dm-devel@redhat.com>; Sun, 08 Nov 2020 07:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=xCiEM7AQz5QZ2RvY5C0nr85g19BsqN3bEHGGJWjun8g=;
	b=CCpOHDgfSJGzQctVJOjJlW2uMfqqrj7BFGu5lk7lr9VpLmQi8NVGj8pB3BQGosHzRU
	+OrKgVx3Dho+GRR7REsqNzpE+rkaCPe8caD/xwwzGTli7455XFQO8F24QYhFePnxq/Ie
	AIiaDZtvJ6At+Sbf072I4/1oeiJHggIPQIqLDTERnwPa42fLaHLKfHGeUsYxZmyYjIVH
	MK7eD3r0TWPdSqIiU5/1yckNbjjk/wbiAijjn+zELT+V3/hvQydIQBXLQAtAIrVzbJwl
	AKj7I2e7BZ4KnXS0sdISyVjbZzCpmj3AvAzkBx+kNHClEvdQk3hKw9SR1FlxtCQByBm7
	ib5A==
X-Gm-Message-State: AOAM530ZbnPYNqMiS4Z5prmNcth/YOb4GFOiq98s50Jgv1QwxvZQQg5E
	TBc0pVBLutoUHdW5TtsboHxi6KL1CGk5jazQSv2RuavgoZsqqtLCWXKL1i5GXW4Egw0yJvcRGRw
	fMD8mNmzsycQzrkk=
X-Received: by 2002:a1c:80d3:: with SMTP id
	b202mr10142606wmd.139.1604848507853; 
	Sun, 08 Nov 2020 07:15:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBz6wtcRAgwxrEGiAL8ElHcOzDdD7qQjz/7QuIFGOGrDkKJazoMrCqH8844xWODBZg8NNGyg==
X-Received: by 2002:a1c:80d3:: with SMTP id
	b202mr10142589wmd.139.1604848507695; 
	Sun, 08 Nov 2020 07:15:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
	([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
	by smtp.gmail.com with ESMTPSA id
	l3sm11508325wmg.32.2020.11.08.07.15.05
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 08 Nov 2020 07:15:06 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-24-hch@lst.de>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d23bd50a-7555-438b-9e3b-131414b2d1a5@redhat.com>
Date: Sun, 8 Nov 2020 16:15:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106190337.1973127-24-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 23/24] virtio-blk: remove a spurious call to
 revalidate_disk_size
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 06/11/20 20:03, Christoph Hellwig wrote:
> revalidate_disk_size just updates the block device size from the disk 
> size. Thus calling it from revalidate_disk_size doesn't actually do 

s/revalidate_disk_size/virtblk_update_cache_mode/

> anything.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

