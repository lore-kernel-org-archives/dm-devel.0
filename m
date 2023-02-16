Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B312C636CC
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676575643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n+SqvWVuL4yWfa8uEycSAY4BocK8FGTLRFlRCzjzbVU=;
	b=GL5e72nJUDZAwlLABLgKfRvSSrPlA9GH6Ps9aTSpGjLGQiWbAmCqojO0nmXc+BqGrKONRn
	bh9cqgJjdgdVenfex+id8/zqtxv8kvyAnFs1Yso9Hxsdl6op852bpbWVBNm0E/YO5ryqI5
	dXzRxzrnLUD67b//nO6mB5hoU8imr4g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-36-YxSF4NPGdTsMJ604b6Q-1; Thu, 16 Feb 2023 14:27:22 -0500
X-MC-Unique: 36-YxSF4NPGdTsMJ604b6Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DC2B185A7A4;
	Thu, 16 Feb 2023 19:27:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 690DE492B15;
	Thu, 16 Feb 2023 19:27:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 214CA194658C;
	Thu, 16 Feb 2023 19:27:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4052A1946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 19:27:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 857D01121318; Thu, 16 Feb 2023 19:27:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DBB71121314
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 19:27:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DA5A88B7A8
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 19:27:06 +0000 (UTC)
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com
 [209.85.216.98]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-316-07xFhwdUMI6JVOffhu_B_Q-1; Thu, 16 Feb 2023 14:27:04 -0500
X-MC-Unique: 07xFhwdUMI6JVOffhu_B_Q-1
Received: by mail-pj1-f98.google.com with SMTP id
 oa11-20020a17090b1bcb00b002341a2656e5so3174456pjb.1
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 11:27:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ghxJBe9F/gi1ztZfAp08sB8NNLqrampvOT1lwb1dYDw=;
 b=yATFiWcVqKjwW/nbjX9wKRzdRSeYm8i2XiNlyGhsB/l7mWPnk6xnGoNgAaNdrdeVlM
 SgJTpxzUV5JdmN1AXIsX2xkjgRt4HQKWu6VIJ+0L9KzBsQ1aKyjoQXcwW+y9cqqUBKGh
 5AEHQmo1bQa+JDxS8hw73hSU8PzVgWbKgJZNbCKpg4FRqXL9kJLl6bq89uuNcqgLimBM
 wHy16LEwIxWypPd5poA7lIg8B/zpta9NB0+8yOFABFyc8khGXP0R4gPI7pRxYW884jZu
 27g3QRD7Vmhbn0mTKEZuK3IpHcOdaW8zfBm5jEUgQRb+kPeJpK2PRIMYPbW6B4V75g/g
 G8ow==
X-Gm-Message-State: AO0yUKWBY5wuHhAX/0gHzSJkX2LjVQTsp2zZyYLS/9Yz7A3q9BzV/TCh
 4SubMWRlERkO/FonOttoK+IQRjd3dmNLT81y0Xl6I533LCrcWh+b3atWBITg2G+/hw==
X-Google-Smtp-Source: AK7set/tXZ+EgPepRguZedA3khzI9tJlpcxsA1zsmkTgODhTRA/fB376DbygzXK1LBiY2RLtW5OmcNuoVz5S
X-Received: by 2002:a17:90b:1e49:b0:233:f7a5:9942 with SMTP id
 pi9-20020a17090b1e4900b00233f7a59942mr7965483pjb.30.1676575623337; 
 Thu, 16 Feb 2023 11:27:03 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
 by smtp-relay.gmail.com with ESMTPS id
 l4-20020a17090aaa8400b0023413f68b7esm123360pjq.7.2023.02.16.11.27.03
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 16 Feb 2023 11:27:03 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com
 (dev-ushankar.dev.purestorage.com [10.7.70.36])
 by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 7857C220FA;
 Thu, 16 Feb 2023 12:27:02 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
 id 734D2E4068D; Thu, 16 Feb 2023 12:27:02 -0700 (MST)
Date: Thu, 16 Feb 2023 12:27:02 -0700
From: Uday Shankar <ushankar@purestorage.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20230216192702.GA801590@dev-ushankar.dev.purestorage.com>
References: <20230215201507.494152-1-ushankar@purestorage.com>
 <Y+3IoOd02iFGNLnC@infradead.org>
MIME-Version: 1.0
In-Reply-To: <Y+3IoOd02iFGNLnC@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] blk-mq: enforce op-specific segment limits
 in blk_insert_cloned_request
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 15, 2023 at 10:09:36PM -0800, Christoph Hellwig wrote:
> I'd just remove the debug check entirely

Older kernels have these checks in a separate function called
blk_cloned_rq_check_limits, which carries the following comment:

/**
 * blk_cloned_rq_check_limits - Helper function to check a cloned request
 *                              for the new queue limits
 * @q:  the queue
 * @rq: the request being checked
 *
 * Description:
 *    @rq may have been made based on weaker limitations of upper-level queues
 *    in request stacking drivers, and it may violate the limitation of @q.
 *    Since the block layer and the underlying device driver trust @rq
 *    after it is inserted to @q, it should be checked against @q before
 *    the insertion using this generic function.
 *
 *    Request stacking drivers like request-based dm may change the queue
 *    limits when retrying requests on other queues. Those requests need
 *    to be checked against the new queue limits again during dispatch.
 */.

Is this concern no longer relevant?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

