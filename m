Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B0BC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669190686;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8oqeI5xICnAjHmqP3Db/cJhp69KFhLQYBbj70d8WLqs=;
	b=EJFAfUB8RKRPiHTRNQT4qxTkqn3jHB8mOw7TjkQGcpXEUhDjmPgxAJFEVBAdweKl08iSmg
	WC/m6RiYtnXL7N1jDGGyGbh0+Smto8sDvIoDQ9Q15w1kEisRpFBqGIEhEJi27tiB7fz3fn
	nefy8m2zHurHMWg9q7fmz03V7gpjyNI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-DmubEZDyNumMrUh1WcqN_w-1; Wed, 23 Nov 2022 03:04:42 -0500
X-MC-Unique: DmubEZDyNumMrUh1WcqN_w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B68585A59D;
	Wed, 23 Nov 2022 08:04:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C99D4492B07;
	Wed, 23 Nov 2022 08:04:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 93BA61946589;
	Wed, 23 Nov 2022 08:04:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F7DB1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 08:04:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 431AB2024CC5; Wed, 23 Nov 2022 08:04:37 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F7852024CBE;
 Wed, 23 Nov 2022 08:04:23 +0000 (UTC)
Date: Wed, 23 Nov 2022 16:04:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <Y33UAp6ncSPO84XI@T590>
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061017epcas5p246a589e20eac655ac340cfda6028ff35@epcas5p2.samsung.com>
 <20221123055827.26996-3-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20221123055827.26996-3-nj.shetty@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v5 02/10] block: Add copy offload support
 infrastructure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 agk@redhat.com, naohiro.aota@wdc.com, sagi@grimberg.me, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, james.smart@broadcom.com,
 p.raghav@samsung.com, kch@nvidia.com, anuj20.g@samsung.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, viro@zeniv.linux.org.uk,
 kbusch@kernel.org, axboe@kernel.dk, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jth@kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 23, 2022 at 11:28:19AM +0530, Nitesh Shetty wrote:
> Introduce blkdev_issue_copy which supports source and destination bdevs,
> and an array of (source, destination and copy length) tuples.
> Introduce REQ_COPY copy offload operation flag. Create a read-write
> bio pair with a token as payload and submitted to the device in order.
> Read request populates token with source specific information which
> is then passed with write request.
> This design is courtesy Mikulas Patocka's token based copy

I thought this patchset is just for enabling copy command which is
supported by hardware. But turns out it isn't, because blk_copy_offload()
still submits read/write bios for doing the copy.

I am just wondering why not let copy_file_range() cover this kind of copy,
and the framework has been there.

When I was researching pipe/splice code for supporting ublk zero copy[1], I
have got idea for async copy_file_range(), such as: io uring based
direct splice, user backed intermediate buffer, still zero copy, if these
ideas are finally implemented, we could get super-fast generic offload copy,
and bdev copy is really covered too.

[1] https://lore.kernel.org/linux-block/20221103085004.1029763-1-ming.lei@redhat.com/

thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

