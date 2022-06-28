Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725DEC43334
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656438086;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/JNDc5Pv4nK+qm9i7ibXxITd7Y1cpYzakoccrfSZFHk=;
	b=AukEO6PQwbj3lPOpVVzCv4U2MTb47FUsCZ+Bw3+fzBpNBmZKN6GghEEXnajyW4UPRoO+Ct
	nikR2jMbVTVtqsoa/i+EUwZqkCL/CLVRqFa7tW2saJ896nxYE/EC4tkmnfaewwtfcv8yHV
	gIXKLdh2JOn74FbANYAj03+j61ddk6s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-GeRSYuzHNDSHWRZEWwq7fw-1; Tue, 28 Jun 2022 13:41:22 -0400
X-MC-Unique: GeRSYuzHNDSHWRZEWwq7fw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26AA13C0D843;
	Tue, 28 Jun 2022 17:41:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B189A40C141F;
	Tue, 28 Jun 2022 17:41:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77DA51947058;
	Tue, 28 Jun 2022 17:41:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8021C1947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 17:41:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59DD82026D2D; Tue, 28 Jun 2022 17:41:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 558DE2026D07
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 17:41:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3F129DD9A8
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 17:41:16 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-iYwZjZhgPzebwtlquRmlyg-1; Tue, 28 Jun 2022 13:41:14 -0400
X-MC-Unique: iYwZjZhgPzebwtlquRmlyg-1
Received: by mail-qk1-f198.google.com with SMTP id
 194-20020a3704cb000000b006af069d1e0aso12736402qke.15
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 10:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YEqy8AJWkJJDvettILGtUJ75qUrhxClJ6WIqJBOIecg=;
 b=psVAGMuZ/9qi8EvlESg5xbm4QVt6fLTUiOoAWLzQsCwhXKR1wtU05Hy86vY+mRIlPs
 Q9c04UJeOeg36hJkiudwPH2eLNggaquvpGVNL2Lj8G5RwdbtJh4tFAvdZtipSue6+vID
 gVPllPdS4dmccyq0tGsucsgcF8r09Eq48dnigFXtIVdStlni8pVDiY9djzf4YZGB8r4Y
 RGaiHMiO9C7yUlWTYE52FiR4UN3K8bJtov73EYHQBZekY7bqpGOjkQJY0v1fXndzUhht
 wceB8aQYtRwEhgt0HbZalLtZDloollhn0Ikvnb06IPPmuUmWvnjzZ6VkDVIYwvJNcxLM
 YifQ==
X-Gm-Message-State: AJIora/bdhbxGQLFbsAZYKRNVZGVCm0reqzBsDRw7MdAc9Jtk5Rv59VK
 jmmwTexp6TX3DU/wsOFVumFfnjYC9h+Ixn3VyL85pMeCWxrJcS9fq7luLQDcvJU+2sv1m/q0gDN
 Wh5WUcMQv6ziSQg==
X-Received: by 2002:ac8:4e87:0:b0:31b:f6ef:bdf6 with SMTP id
 7-20020ac84e87000000b0031bf6efbdf6mr1387341qtp.64.1656438074394; 
 Tue, 28 Jun 2022 10:41:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tYZSza3RsF03B25ldB7UEUb4Qecw+TQaQzfhz1NKC38rky8U47pk/edeUSb3sncuxS5QQZ1w==
X-Received: by 2002:ac8:4e87:0:b0:31b:f6ef:bdf6 with SMTP id
 7-20020ac84e87000000b0031bf6efbdf6mr1387321qtp.64.1656438074129; 
 Tue, 28 Jun 2022 10:41:14 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 g16-20020ae9e110000000b006aefa015c05sm10866149qkm.25.2022.06.28.10.41.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 10:41:13 -0700 (PDT)
Date: Tue, 28 Jun 2022 13:41:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <Yrs9OLNZ8xUs98OB@redhat.com>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
 Eric Biggers <ebiggers@google.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28 2022 at 12:36P -0400,
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Tue, Jun 28, 2022 at 03:49:28PM +0800, Ming Lei wrote:
> > On Tue, Jun 28, 2022 at 12:26:10AM -0400, Kent Overstreet wrote:
> > > On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> > > > Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> > > > hold in per-io data structure. With this patch, 8bytes is enough
> > > > to rewind one bio if the end sector is fixed.
> > > 
> > > And with rewind, you're making an assumption about the state the iterator is
> > > going to be in when the IO has completed.
> > > 
> > > What if the iterator was never advanced?
> > 
> > bio_rewind() works as expected if the iterator doesn't advance, since bytes
> > between the recorded position and the end position isn't changed, same
> > with the end position.
> > 
> > > 
> > > So say you check for that by saving some other part of the iterator - but that
> > > may have legitimately changed too, if the bio was redirected (bi_sector changes)
> > > or trimmed (bi_size changes)
> > > 
> > > I still think this is an inherently buggy interface, the way it's being proposed
> > > to be used.
> > 
> > The patch did mention that the interface should be for situation in which end
> > sector of bio won't change.
> 
> But that's an assumption that you simply can't make!

Why not?  There is clear use-case for this API, as demonstrated in the
patchset: DM can/will make use of it for the purposes of enhancing its
more unlikely bio requeuing work (that is needed to make the more
likely bio splitting scenario more efficient).

> We allow block device drivers to be stacked in _any_ combination. After a bio is
> completed it may have been partially advanced, fully advanced, trimmed, not
> trimmed, anything - and bi_sector and thus also bio_end_sector() may have
> changed, and will have if there's partition tables involved.

We don't _need_ this API to cure cancer for all hypothetical block
drivers.

If consumers of the API follow the rule that end sector of the
_original bio_ isn't changed then it is all fine.  It is that simple.

Stacked drivers will work just fine.  The lower layers will be
modifying their bios as needed. Because for DM those bios happen to
be clones, so there is isolation to the broader design flaw you are
trying to say is a major problem. As this patchset demonstrates.

I do concede that policing who can use an API is hard.  But if some
consumer of an API tries something that invalidates rules of the API
they get to keep the N pieces when it breaks.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

