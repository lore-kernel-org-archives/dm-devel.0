Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB635C636D6
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676652228;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vtSfFjvziuTiCIA5enpCe+4eLKvdN3KBFm0c/h5vwhc=;
	b=DjkBvDU4hmxqmhutT6fVShk1TcGnDp21Lz9L9XRW1XvgQGNqJMRUMpzKsU/yZyJNI7uJ6W
	jmM4ivcbvsloqg04t1YiG/8uGqz61bUDR7qJ3pCmVmFdHmr/MDZBBd5aUEb6722F1ZtGSM
	jQum8U/G7YHbQ2pjqCoD5B1VQFBk+tI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134--X8k51zhOOGECiQGwZ3oIg-1; Fri, 17 Feb 2023 11:43:45 -0500
X-MC-Unique: -X8k51zhOOGECiQGwZ3oIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1FFB811E9C;
	Fri, 17 Feb 2023 16:43:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B4BD140EBF4;
	Fri, 17 Feb 2023 16:43:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6379F1946589;
	Fri, 17 Feb 2023 16:43:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 375831946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 16:43:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1615D4010E83; Fri, 17 Feb 2023 16:43:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6F340B40C9
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 16:43:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E691585A5A3
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 16:43:38 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-569-X-t7Srb8N02NvEs00Dabfw-1; Fri, 17 Feb 2023 11:43:37 -0500
X-MC-Unique: X-t7Srb8N02NvEs00Dabfw-1
Received: by mail-qt1-f177.google.com with SMTP id c11so213013qth.3
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 08:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=h3uS6l7R4NN6xpTILsvB1VqvWC13/kbkjpwhQ4oxzsc=;
 b=6S4wS4EGIpM4p8jAPASVOjmJKsCKRyt75RXMX6a9VUSObv0P/gAJCSx884TsUsS5gG
 upe5AgrGsycK8lyrH+a6Jp8kwvbesHCSa11xxT6O5aCZhBfYKAPDGabWNFVd5AQ0p3FG
 Hx2T4CRJcH/ucg+RBeHNLNoVgd9gKcYjLHPGTc8AwKJ43hJEH4STLsf9ydWi5gyjGSQ7
 9N6feqWDrUDLvZIj6w4r6xdAAOHcY/AhB9Q7MoSpqootlGQevUogl9bFMPfQyQSUT1W4
 c4IHA0r6hUa2leRfsDj1tOGaqCU8nhZkF1FFIKsr3kgvqNyzY2r2lq+c1gHUCj3W9Fod
 7OuA==
X-Gm-Message-State: AO0yUKXxJ7RhgNBD22rpTu+qXosduNgxYEMm0Z2AUxU2wOF7TSj1YJRS
 +xt+bwFD4m9+Q+Ady9ttKzLUkOlO+T1sT1i2GA==
X-Google-Smtp-Source: AK7set9gWGn6W9xaTLmOYlMZhybnyp39F0bJY6EI6xONfoBZQJ+IZm4+inBu0UdqBkTMUHpdf4x7bw==
X-Received: by 2002:a05:622a:81:b0:3b9:bc8c:c20c with SMTP id
 o1-20020a05622a008100b003b9bc8cc20cmr9573603qtw.23.1676652216569; 
 Fri, 17 Feb 2023 08:43:36 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 i129-20020a37b887000000b007068b49b8absm3482600qkf.62.2023.02.17.08.43.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 08:43:36 -0800 (PST)
Date: Fri, 17 Feb 2023 11:43:34 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <Y++utrkJXuUsD0K4@redhat.com>
References: <20230215201507.494152-1-ushankar@purestorage.com>
 <Y+3IoOd02iFGNLnC@infradead.org>
 <20230216192702.GA801590@dev-ushankar.dev.purestorage.com>
 <Y++oTz0ck9OGE4Se@infradead.org>
MIME-Version: 1.0
In-Reply-To: <Y++oTz0ck9OGE4Se@infradead.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Uday Shankar <ushankar@purestorage.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 17 2023 at 11:16P -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Feb 16, 2023 at 12:27:02PM -0700, Uday Shankar wrote:
> >  * Description:
> >  *    @rq may have been made based on weaker limitations of upper-level queues
> >  *    in request stacking drivers, and it may violate the limitation of @q.
> >  *    Since the block layer and the underlying device driver trust @rq
> >  *    after it is inserted to @q, it should be checked against @q before
> >  *    the insertion using this generic function.
> >  *
> >  *    Request stacking drivers like request-based dm may change the queue
> >  *    limits when retrying requests on other queues. Those requests need
> >  *    to be checked against the new queue limits again during dispatch.
> >  */.
> > 
> > Is this concern no longer relevant?
> 
> The concern is still valid, but it does not refer to the debug check.
> It refers to recalculating nr_phys_segments using
> blk_recalc_rq_segments, and the fact that any driver using this
> interface needs to stack its limits properly.

It is a negative check that you're calling a debug check.

Much easier to address a bug in a driver when seeing this message than
figuring it out after more elaborate hunting. Not seeing the downside
of preserving/fixing given it is a quick limit check. *shrug*

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

