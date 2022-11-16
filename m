Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A4ABC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 21:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668635471;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OjCBhW6a4JYNDNNN4Ukc1HLB3iroXupCjqjsdGXdSYs=;
	b=XTnwgJhdkyIwkuUQKyNMTsjh2FmJ8xn5Eq3BKLMyNhD1pc8nUySmJ2xXmzgdyPFbVwaqnH
	6BVpcIMdohjjEXIg3F6tXNZCX1V4qv21TvTBsvKnEXHd5m9jERTOtMok7oMjwAKLBe3F4s
	APts0LNyWD44Z6SBqpiHQR1lgCvxrS0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-wFFtW_0TMiuBIlX0ndeTVA-1; Wed, 16 Nov 2022 16:51:07 -0500
X-MC-Unique: wFFtW_0TMiuBIlX0ndeTVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCEB5857D1C;
	Wed, 16 Nov 2022 21:51:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A759B1415114;
	Wed, 16 Nov 2022 21:51:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4B8EA19465A3;
	Wed, 16 Nov 2022 21:51:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 326E219465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 21:51:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC718492B05; Wed, 16 Nov 2022 21:51:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B53E2492B04
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:51:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 832421C0A580
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:51:01 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-205-czhHhAmXOCadpxTvONCzGw-1; Wed, 16 Nov 2022 16:51:00 -0500
X-MC-Unique: czhHhAmXOCadpxTvONCzGw-1
Received: by mail-qk1-f200.google.com with SMTP id
 u5-20020a05620a0c4500b006fb30780443so16685892qki.22
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 13:51:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=q6nojB89E1Mh3yFLSu2KzkNkZ/bHQfVswcYDYKdeZ2Q=;
 b=CWTFzFLRwEmpj0J+Bwo1pQ3FIt2xJkJIMU22vaO4F7HBpQ2E0x41JbGX2UMDcQVzJ/
 8zpXNVPA0yvO7PGnxdM+tRroPUH8I/ZBKTgYwVBMAJ7aGlsgUxhFUdgLUBWIoukfE1Za
 U/3lE/81t9f7+/p80wC3BRIjSe7iTcAupFdVJvUuo3YR0o0w6sUSCqrXyp4rRcufTiah
 jecqlBbwSmmy4fSd0NYNRWJRCr+qN+v5RnfsqOBVHDWEvuS4NY703gCf4ZBitAKb2zyd
 Gt7yEwJH3wblBPRm35ABv4S02S2QuB3FujcB66bhU4941KDwRYxPEiVj87PooQ2ZyAoS
 wvzQ==
X-Gm-Message-State: ANoB5pn/ktR+FtVRAqnnqm5hf3K5FSHtwmZNpHe/ilSrVmXPJJFGg9mE
 +5a9d7pp9UCZJWNtymnVnJJ0rp/6BED/QpJhbKTtU0fVd6ZMf9k/PfMGx++v7d2bZXb+X0rNKQM
 SevKp/NpvssryyA==
X-Received: by 2002:a05:620a:c43:b0:6fa:6423:65b6 with SMTP id
 u3-20020a05620a0c4300b006fa642365b6mr14077832qki.324.1668635459740; 
 Wed, 16 Nov 2022 13:50:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5o3UcPKD9RkRXo2oJUoXe+j1L0zcdnOEKW/X0guNcC/Xo8sAb4uEao0tfvbnLS9Ws1eXPm+Q==
X-Received: by 2002:a05:620a:c43:b0:6fa:6423:65b6 with SMTP id
 u3-20020a05620a0c4300b006fa642365b6mr14077821qki.324.1668635459547; 
 Wed, 16 Nov 2022 13:50:59 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 d7-20020a05620a240700b006fba44843a5sm3063589qkn.52.2022.11.16.13.50.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 13:50:59 -0800 (PST)
Date: Wed, 16 Nov 2022 16:50:58 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y3VbQsjmNW4GQHLs@redhat.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
 <20221115141054.1051801-3-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221115141054.1051801-3-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v3 02/10] dm: remove free_table_devices
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
Cc: axboe@kernel.dk, yi.zhang@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 yukuai3@huawei.com, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 15 2022 at  9:10P -0500,
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> free_table_devices just warns and frees all table_device structures when
> the target removal did not remove them.  This should never happen, but
> if it did, just freeing the structure without deleting them from the
> list or cleaning up the resources would not help at all.  So just WARN on
> a non-empty list instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

