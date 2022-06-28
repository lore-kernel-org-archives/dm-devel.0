Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A192C43334
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 07:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656487871;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jdcKA9wmT0E6LeC/znvytFzx7lv6yE8rBlBGFEO1Rmo=;
	b=H8Wb1rTS9fFVjhgaVko6eu5Q4g94G729popXG9B0ZxsdVYnTTnY7HUV6xF5xYFo+Z6Eh2b
	RGIvVJ9O/ZbzPOkLKjC9KczC7+/oPcNJq+7cE5nJCaz17GGG6Sgtawr/o1QJrJAl+LxdRt
	uMz+B+T9CjinPkqptoHcYK/T/lEoroM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-c5eeGd1VMxCEZ1fDWn7R5A-1; Wed, 29 Jun 2022 03:31:07 -0400
X-MC-Unique: c5eeGd1VMxCEZ1fDWn7R5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAE5082406B;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2DCF2166B26;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 218AD194705D;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 749D819466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 16:36:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DCA6AC28118; Tue, 28 Jun 2022 16:36:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D85D0C2810D
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 16:36:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFF441019C8E
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 16:36:21 +0000 (UTC)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com
 [209.85.222.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-gvUltRaWM1KipTCvIQdecg-1; Tue, 28 Jun 2022 12:36:19 -0400
X-MC-Unique: gvUltRaWM1KipTCvIQdecg-1
Received: by mail-qk1-f177.google.com with SMTP id v6so10148434qkh.2;
 Tue, 28 Jun 2022 09:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9e+KJ1EtCj7X1qzaa/XINtZDFLFaX8Iti/jKpVWCt8A=;
 b=NR/ZCTQl7rKf2NrTJHtf1fhFD/P4Z+4gb9gqUZe/bUCKEvZSKGRw+dFJ4CuniSJwLI
 a9S7M+euHJcmgPvovnptKMqoTmmbT5j44m8rOZthIb4Kkgcl8JJOVFxq60HmEtTOclLU
 I+p5uu3OD9qk6YlgBn7R94gks49FzFyGlsvdtMhdd4wT5tqUN9tVrXWbVp1xgeG7dmv7
 dDvpRYA45CKa+rTm4TQPqA9rMef0e0yYfmTKfM6BwxHGcfkjvSPu0lsuZnHMMQXFio9k
 B1tJZQe2/RNO9undrbZNBOLSHFceinsifYqlWOhEe6uSbhhNLzzsXQz1wOX0tT5DsoxH
 owug==
X-Gm-Message-State: AJIora831sKdXEaGEHruz3PNaKESxvvgE6i3gjLPbeHSYa6nrK5lN8eg
 zNnzgwnL91SxAMQGxEcrVmFxGi6I++nnvnxy8Q==
X-Google-Smtp-Source: AGRyM1tNpAGEEdEMGkjXEOmgtNpPakBy4hStxfmQs1s9zd6Eq0cYY8rKNRqc2WW1xRC6V+T6Fp92Iw==
X-Received: by 2002:a05:620a:2845:b0:6ab:8e0c:1938 with SMTP id
 h5-20020a05620a284500b006ab8e0c1938mr11939273qkp.315.1656434178584; 
 Tue, 28 Jun 2022 09:36:18 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 bm9-20020a05620a198900b006a73ad95d40sm11164011qkb.55.2022.06.28.09.36.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 09:36:17 -0700 (PDT)
Date: Tue, 28 Jun 2022 12:36:17 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
MIME-Version: 1.0
In-Reply-To: <YrqyiCcnvPCqsn8F@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 29 Jun 2022 07:31:01 +0000
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28, 2022 at 03:49:28PM +0800, Ming Lei wrote:
> On Tue, Jun 28, 2022 at 12:26:10AM -0400, Kent Overstreet wrote:
> > On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> > > Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> > > hold in per-io data structure. With this patch, 8bytes is enough
> > > to rewind one bio if the end sector is fixed.
> > 
> > And with rewind, you're making an assumption about the state the iterator is
> > going to be in when the IO has completed.
> > 
> > What if the iterator was never advanced?
> 
> bio_rewind() works as expected if the iterator doesn't advance, since bytes
> between the recorded position and the end position isn't changed, same
> with the end position.
> 
> > 
> > So say you check for that by saving some other part of the iterator - but that
> > may have legitimately changed too, if the bio was redirected (bi_sector changes)
> > or trimmed (bi_size changes)
> > 
> > I still think this is an inherently buggy interface, the way it's being proposed
> > to be used.
> 
> The patch did mention that the interface should be for situation in which end
> sector of bio won't change.

But that's an assumption that you simply can't make!

We allow block device drivers to be stacked in _any_ combination. After a bio is
completed it may have been partially advanced, fully advanced, trimmed, not
trimmed, anything - and bi_sector and thus also bio_end_sector() may have
changed, and will have if there's partition tables involved.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

