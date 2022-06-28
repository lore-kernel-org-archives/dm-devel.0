Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079D6CCA481
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:38:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-OeK31jmiNwOA-PN5OFc3EA-1; Tue, 28 Jun 2022 02:38:06 -0400
X-MC-Unique: OeK31jmiNwOA-PN5OFc3EA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C7B9805F71;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C0A240CFD0A;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ACC51194707C;
	Tue, 28 Jun 2022 06:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D7E919466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 04:26:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D5E49D7F; Tue, 28 Jun 2022 04:26:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 292A5815B
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 04:26:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D50C1019DE0
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 04:26:17 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-3XHkbn3bMy-NrdWKjT20GA-1; Tue, 28 Jun 2022 00:26:14 -0400
X-MC-Unique: 3XHkbn3bMy-NrdWKjT20GA-1
Received: by mail-qv1-f47.google.com with SMTP id cu16so18415257qvb.7;
 Mon, 27 Jun 2022 21:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pQioXScPR1ZrU0GmMPpYnQPltx0fgcH9pN3N7WOA3/w=;
 b=WYv3/XA5t9mu1i1wwpcz9KLlNT2uzzcuvrtMIDvS9I8UdBQdpc8x3pvNDmPPfIA/BY
 W2njndHIoa5WA9VCplgr000UbBD6OYWr2nD9snogrbVu8JzX/Du6qgFxuwxXy6Iq4KSn
 nXPMTYkYoClcxApF0r2xKlPD04SX/bIOuC/pZZIVMLJ4/6gWYoVySH3SAY6Bt5K4cyQy
 gb5VV+as6BgXBXtQkLXYC0L9PqS/gCWXQtuTlm740vIOFxlWOj+zt6J0r3ZUlDl/KWMw
 aHU9Sdcc4KYYaBXsuUi3i0jYIoaewgr87TlIVQd790DGdnRmuEu2B922TjBBMtsF627j
 QGNw==
X-Gm-Message-State: AJIora80mDqUFZSbdrBIGh5hcsUl252r7Rf23WtzUPkorBt9mU9Wj7uY
 Ec0H2EF7T4l3DWPYzzU971fxSgUqp+sgAC4Ptw==
X-Google-Smtp-Source: AGRyM1vDjsHpl51I84tTed9uZ6LSakOPcKzqDgn+NfarFKny0QuOmxJctUHQxVvcIjE2mPS3cTutXQ==
X-Received: by 2002:a05:622a:1ba3:b0:305:15b5:8758 with SMTP id
 bp35-20020a05622a1ba300b0030515b58758mr12018492qtb.10.1656390372668; 
 Mon, 27 Jun 2022 21:26:12 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 n8-20020a05620a222800b006ab935c1563sm9558005qkh.8.2022.06.27.21.26.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 21:26:11 -0700 (PDT)
Date: Tue, 28 Jun 2022 00:26:10 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220628042610.wuittagsycyl4uwa@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
MIME-Version: 1.0
In-Reply-To: <Yrld9rLPY6L3MhlZ@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Tue, 28 Jun 2022 06:38:00 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> hold in per-io data structure. With this patch, 8bytes is enough
> to rewind one bio if the end sector is fixed.

And with rewind, you're making an assumption about the state the iterator is
going to be in when the IO has completed.

What if the iterator was never advanced?

So say you check for that by saving some other part of the iterator - but that
may have legitimately changed too, if the bio was redirected (bi_sector changes)
or trimmed (bi_size changes)

I still think this is an inherently buggy interface, the way it's being proposed
to be used.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

