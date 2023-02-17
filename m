Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C7FC636CC
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 00:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676592849;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M/WHUR7vrWuLrfIQtBX1dxk6nPlQM6i8X4bUfXzO5dM=;
	b=QSKBlB+KjqIDm1dy7AvJmv7ZSxXfLV2IU/ZS00wneGJfggn5eaqgIeo9btoduPqypl38Xw
	F/3XBUUK0odwKM0NvEWkqlPGI+nYtmwq/0l6YAO7Z6YvyHrMQ20h9Hnq5EY4nxH9ECTTBX
	D93Eft/r1HT3b6Iu9kGZKKAJXlO6zu0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-PwBD1vh2PtuuWRxLB8Y1Zw-1; Thu, 16 Feb 2023 19:14:06 -0500
X-MC-Unique: PwBD1vh2PtuuWRxLB8Y1Zw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 179C21869B6C;
	Fri, 17 Feb 2023 00:14:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E033140EBF6;
	Fri, 17 Feb 2023 00:14:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 527CA1946589;
	Fri, 17 Feb 2023 00:14:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 318F01946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 00:13:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5EF44C15BAD; Fri, 17 Feb 2023 00:13:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5785EC15BA0
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 00:13:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DD2D101A521
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 00:13:55 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-KA6n5rcJPayzUCxzoPbvDQ-1; Thu, 16 Feb 2023 19:13:53 -0500
X-MC-Unique: KA6n5rcJPayzUCxzoPbvDQ-1
Received: by mail-qt1-f171.google.com with SMTP id cr22so3990379qtb.10
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 16:13:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6kImKyTnUFlrsbZ3cxw052u3lsceBXaXeoQEmfLR09Q=;
 b=SXmu1+/r84B/EOlE+FQqcd0oer8jVWeoapE2TuFHZa7PbvBNN5lUEtKW0ENYdtnTmb
 X0gj2+/V7NKiJB7lLbjcVXxee2zdZVP4PbEMH+rnA3bvwJW3ILNWrtaw1aSJ9OkecGo2
 asoo6vUAWIQmQNygHpG6V4XYqqPxBmwGpnnid1f7vxz3BiAToS/cN+yVFnAsLbtWmuRw
 zcJ+maSF9S3ean3GYUQSx7H4Lu1sDiqAki2QUjDxcbg4O/8z+0AHGKTDLly5L3I0Tksk
 Mh5e9q2Y/1m85MKsbHpRW7T/XqR6iFxr3B5tDl7I/v0/ddrckncyy0W9R76U2kFrJ7yx
 fCoA==
X-Gm-Message-State: AO0yUKVmOk68ipxjD8xmwkAp4lLdForUi8jx1DYx7M0b4jCFS4d1pPoP
 xD6huLrPv7rg6C6pC6xlXtLikjk=
X-Google-Smtp-Source: AK7set8j9cfHfcZl/vzGU/yVM8ih72maPo/h2Vl1C+ebpdpF9rGGVgryO/199T+35W3ZyOZr6LNmWA==
X-Received: by 2002:ac8:5f4a:0:b0:3b9:bc8c:c1f8 with SMTP id
 y10-20020ac85f4a000000b003b9bc8cc1f8mr8029510qta.3.1676592833020; 
 Thu, 16 Feb 2023 16:13:53 -0800 (PST)
Received: from localhost ([87.249.138.162]) by smtp.gmail.com with ESMTPSA id
 18-20020a370312000000b0071b1fe18746sm2260140qkd.63.2023.02.16.16.13.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Feb 2023 16:13:52 -0800 (PST)
Date: Thu, 16 Feb 2023 19:13:51 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Uday Shankar <ushankar@purestorage.com>
Message-ID: <Y+7Gv84lxIR0OsWc@redhat.com>
References: <20230215201507.494152-1-ushankar@purestorage.com>
 <Y+3IoOd02iFGNLnC@infradead.org>
 <20230216192702.GA801590@dev-ushankar.dev.purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20230216192702.GA801590@dev-ushankar.dev.purestorage.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] blk-mq: enforce op-specific segment limits in
 blk_insert_cloned_request
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
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 16 2023 at  2:27P -0500,
Uday Shankar <ushankar@purestorage.com> wrote:

> On Wed, Feb 15, 2023 at 10:09:36PM -0800, Christoph Hellwig wrote:
> > I'd just remove the debug check entirely
> 
> Older kernels have these checks in a separate function called
> blk_cloned_rq_check_limits, which carries the following comment:
> 
> /**
>  * blk_cloned_rq_check_limits - Helper function to check a cloned request
>  *                              for the new queue limits
>  * @q:  the queue
>  * @rq: the request being checked
>  *
>  * Description:
>  *    @rq may have been made based on weaker limitations of upper-level queues
>  *    in request stacking drivers, and it may violate the limitation of @q.
>  *    Since the block layer and the underlying device driver trust @rq
>  *    after it is inserted to @q, it should be checked against @q before
>  *    the insertion using this generic function.
>  *
>  *    Request stacking drivers like request-based dm may change the queue
>  *    limits when retrying requests on other queues. Those requests need
>  *    to be checked against the new queue limits again during dispatch.
>  */.
> 
> Is this concern no longer relevant?

Still relevant.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

