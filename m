Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34287C43334
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:43:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-oA8RjC3TN0Oj9oDlPIx0AQ-1; Tue, 14 Jun 2022 12:43:54 -0400
X-MC-Unique: oA8RjC3TN0Oj9oDlPIx0AQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1169385A581;
	Tue, 14 Jun 2022 16:43:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F2C151415103;
	Tue, 14 Jun 2022 16:43:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC16B19452D2;
	Tue, 14 Jun 2022 16:43:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 15F14194706D
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:43:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0034F41638B; Tue, 14 Jun 2022 16:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CBC7F492C3B
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:43:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B331180159B
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:43:51 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-t8vcCN9ZNwuwObnn8YnQxQ-1; Tue, 14 Jun 2022 12:43:49 -0400
X-MC-Unique: t8vcCN9ZNwuwObnn8YnQxQ-1
Received: by mail-pj1-f43.google.com with SMTP id gd1so8965079pjb.2
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=uW0kqvGmwIghHETO22GYzCXx8UvgozxQRy93g86AxH4=;
 b=Hakns8MaGP/SRwdT169G0dgMEVuwhvTngT+IVWjC+jbLQEvk3br4R+tNhHwGN/zvrH
 mzKYFDWrTD5ZV2nITobY9xKnoHVEwDd5O1cwuJ7QzQIAO1Fq7xF/pYGb5BEHmMEBftOR
 WuggTSe2CGPpPaL+k6nvTXNJ1C7qB6jB1ZAQNHjnYMkMFY4y2rnT9xlzgn4cFmLAlp4G
 FNAK9SZEnJZtSfMfn/Ro34gUyyxG5scJKdn91THWsXIRRCxE/csoklP+056czJ9aj17Q
 Sgv8CpAmOY7Gpt3M8cYu2EzKDtX4RBh85vS27iXD6aCXsolA/7chuZOeelJvDFd7Zba7
 mc6Q==
X-Gm-Message-State: AJIora/lL3aPb28wB6WKXTIPzxHAjUGbchL6W5aKMp9r+343TweyIA2Q
 Mb2Pgk5sfHhvbCv4JcL/aww=
X-Google-Smtp-Source: AGRyM1vp7ypTBO/dZSaLK6pGg9ApuLVuCvu/9rEpyb8fmCDVe3fW4co2+TkczKABYMpfKR85g9F22g==
X-Received: by 2002:a17:902:ec8f:b0:167:70f6:905c with SMTP id
 x15-20020a170902ec8f00b0016770f6905cmr5380178plg.12.1655225028337; 
 Tue, 14 Jun 2022 09:43:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6?
 ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
 by smtp.gmail.com with ESMTPSA id
 w6-20020a1709029a8600b0016378bfeb90sm7443690plp.227.2022.06.14.09.43.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Jun 2022 09:43:47 -0700 (PDT)
Message-ID: <02468bd8-f2b3-1d5c-01dd-c9e9d6d5b09e@acm.org>
Date: Tue, 14 Jun 2022 09:43:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-4-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220614090934.570632-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 3/6] block: open code blk_max_size_offset in
 blk_rq_get_max_sectors
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/14/22 02:09, Christoph Hellwig wrote:
> blk_rq_get_max_sectors always uses q->limits.chunk_sectors as the
> chunk_sectors argument, and already checks for max_sectors through the
> call to blk_queue_get_max_sectors.  That means much of
> blk_max_size_offset is not needed and open coding it simplifies the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-merge.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index db2e03c8af7f4..df003ecfbd474 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -566,17 +566,18 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
>   						  sector_t offset)
>   {
>   	struct request_queue *q = rq->q;
> +	unsigned int max_sectors;
>   
>   	if (blk_rq_is_passthrough(rq))
>   		return q->limits.max_hw_sectors;
>   
> +	max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
>   	if (!q->limits.chunk_sectors ||
>   	    req_op(rq) == REQ_OP_DISCARD ||
>   	    req_op(rq) == REQ_OP_SECURE_ERASE)
> -		return blk_queue_get_max_sectors(q, req_op(rq));
> -
> -	return min(blk_max_size_offset(q, offset, 0),
> -			blk_queue_get_max_sectors(q, req_op(rq)));
> +		return max_sectors;
> +	return min(max_sectors,
> +		   blk_chunk_sectors_left(offset, q->limits.chunk_sectors));
>   }

blk_set_default_limits() initializes chunk_sectors to zero and 
blk_chunk_sectors_left() triggers a division by zero if a zero is passed 
as the second argument. What am I missing?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

