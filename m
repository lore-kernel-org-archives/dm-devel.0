Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4958C77B7C
	for <dm-devel@archiver.kernel.org>; Mon,  1 May 2023 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682968565;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rXIKzhtF0zc8K5/o7n6QujqGmZg6nuUYkHPF4rPl0YQ=;
	b=C/taXuYmO8lzUtzoBrGuROW9sUc7mVtBUI0UaHg8N+k/3Ab+bAF3PJuQamWM/a3crNQZk9
	Z9urlwTre1TYgBgVMq1ilYZ6cWNZouku9VgKsxMzP3ZGq/X5MMKqqkGPlXxWPIjx5ZlYYK
	PweNfaMjQD/agxYWE7K9nFoHN7FukNY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-Obmdg73QMqisz3cyyiw96Q-1; Mon, 01 May 2023 15:16:02 -0400
X-MC-Unique: Obmdg73QMqisz3cyyiw96Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49DE6102F23A;
	Mon,  1 May 2023 19:15:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96FF340C6E67;
	Mon,  1 May 2023 19:15:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F0CC1946589;
	Mon,  1 May 2023 19:15:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 590021946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 May 2023 19:15:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 485D863F2D; Mon,  1 May 2023 19:15:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41D9751E3
 for <dm-devel@redhat.com>; Mon,  1 May 2023 19:15:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23E82381D4C3
 for <dm-devel@redhat.com>; Mon,  1 May 2023 19:15:55 +0000 (UTC)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com
 [209.85.222.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-OYfXpsjmOiuHRfoM5omJfw-1; Mon, 01 May 2023 15:15:53 -0400
X-MC-Unique: OYfXpsjmOiuHRfoM5omJfw-1
Received: by mail-qk1-f176.google.com with SMTP id
 af79cd13be357-74e12e93384so120289485a.3
 for <dm-devel@redhat.com>; Mon, 01 May 2023 12:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682968553; x=1685560553;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=xta1ORIjLKUC6sudz2oVdR8ZSjIECo/NNbn+t5B7/30=;
 b=N3c5mInyy9TO+oDRzS6gG+lVuCAvrXdrsJ3oWXOagKkY2/ByB9nioFoOGIqbdXYKsM
 epMPEO//W5ZXFAcZIzMkbP5rxq1uQyCuJkpjVf1Yo85S0/L0TTr9mcvgH6qP+p945Qz7
 OFGBhm6zNp6hVMBKu58cLXivy9L39YsSEn8dA7U1jZ7Hxh/jaJVx7iAu7DELsejH9Vqz
 RyuGh7PIxSWavkwl1xva2BV9s7qhFGF73smgp8rf/RL3dbH4OSgcjnAO3GhKMok7xx8M
 IFaSttkeIB8lPXxCaVBqe1BiDixUNFcZ/qNlgzfOTdAvUVCkOw2EfBJd5L/nrO9gCFub
 80yw==
X-Gm-Message-State: AC+VfDxcn0iCI5K/0QyFcEbyTEGgTe9Vu88ZSDIxxEtqWPVD1lvpsVy3
 1fQK/OYcGNsKa0khVJruW8DkEFE=
X-Google-Smtp-Source: ACHHUZ4jmmEuczYIXEM5IlwBG9kl9JWTkff4UV1CX3KDAprVLLnMz+RC3V5MfXehBawcFMx/T2jIDA==
X-Received: by 2002:a05:6214:27e1:b0:5e3:d150:3168 with SMTP id
 jt1-20020a05621427e100b005e3d1503168mr1170309qvb.18.1682968553151; 
 Mon, 01 May 2023 12:15:53 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o14-20020a0ccb0e000000b0061b62c1534fsm69023qvk.23.2023.05.01.12.15.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 01 May 2023 12:15:52 -0700 (PDT)
Date: Mon, 1 May 2023 15:15:51 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZFAP5yQ0mwE4F6Vg@redhat.com>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-5-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230420004850.297045-5-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v5 4/5] dm-thin: Add REQ_OP_PROVISION support
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 ejt@redhat.com, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 19 2023 at  8:48P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> dm-thinpool uses the provision request to provision
> blocks for a dm-thin device. dm-thinpool currently does not
> pass through REQ_OP_PROVISION to underlying devices.
> 
> For shared blocks, provision requests will break sharing and copy the
> contents of the entire block. Additionally, if 'skip_block_zeroing'
> is not set, dm-thin will opt to zero out the entire range as a part
> of provisioning.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/md/dm-thin.c | 73 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 2b13c949bd72..58d633f5c928 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1891,7 +1893,8 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
>  
>  	if (bio_data_dir(bio) == WRITE && bio->bi_iter.bi_size) {
>  		break_sharing(tc, bio, block, &key, lookup_result, data_cell);
> -		cell_defer_no_holder(tc, virt_cell);
> +		if (bio_op(bio) != REQ_OP_PROVISION)
> +			cell_defer_no_holder(tc, virt_cell);

Can you please explain why cell_defer_no_holder() is skipped for REQ_OP_PROVISION here?

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

