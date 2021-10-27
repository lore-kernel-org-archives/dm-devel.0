Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE75BC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 20:58:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84E9D610A3
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 20:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 84E9D610A3
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635368286;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VSzb8p859GYPxn6KyRq+oD9V7R+IKi9zj0psCPDzLE0=;
	b=GIaxFpruo4GY8zgG7UOxekyZpiqIALTDoddFEtY4H88b5HWibTIjZJkvC1cFP7pN/cGdLr
	DInJ4PA8HprG/fRKeaUvwiEjjvw/oB0b/fOmUQ8oHDCosSFFA/1SZVPlyX2wQOx7DIl/LB
	T26xqfBFdAQnFkPzcdoKrqFCAZrOPMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-p9sIgOCyODOhZDBl1b3rQA-1; Wed, 27 Oct 2021 16:58:01 -0400
X-MC-Unique: p9sIgOCyODOhZDBl1b3rQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACA168066F7;
	Wed, 27 Oct 2021 20:57:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 657385C1B4;
	Wed, 27 Oct 2021 20:57:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 168D84A704;
	Wed, 27 Oct 2021 20:57:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19RKvsTv004708 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 16:57:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9F37240CFD0C; Wed, 27 Oct 2021 20:57:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A8B040CFD11
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 20:57:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 801F3899EC1
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 20:57:54 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-463-_1UHlMCmNcWJwmnoyAJiNw-1; Wed, 27 Oct 2021 16:57:51 -0400
X-MC-Unique: _1UHlMCmNcWJwmnoyAJiNw-1
Received: by mail-qt1-f200.google.com with SMTP id
	c19-20020ac81e93000000b002a71180fd3dso2869200qtm.1
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 13:57:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=PLTKdjEV6mIWG7iQpJNbtxk8ntTk7LiBv1Ju/UbE2nw=;
	b=1nhXvsHtZoDN6lYtcy8RNwVGNeFAOvXGvl2zrOzieGcaetfaV0yqs0l542hFK6v3d3
	FKe8Wf3XNOoGpwVasKy+m4Yc/UsS7AguCGhIlZJ1KIgbcB8C09ufUgUS+0DPCOJjHr8L
	rnV2Qy5itbV29S8xh3bP0px4rc9vnEfCRvDIvq9MAKGLbCiH1/VzqJwuiiTtLLHsQe9K
	vTX2Ji2X2ixYfvcING/sXCzymGZstPrYQZJvz2K/vbNIj+o7BRFI/T8PlA3SzKYpfguh
	QiXzWiGq6VJ5884V0MJB543YN/Fh1f5lnVKMHU1c3FEwBWRxg0JOyxfL6aotFYvr/NwL
	5+rQ==
X-Gm-Message-State: AOAM532WprHdlHf7BW1+4dVvgs7VQTW3VGn83gQoWUixMPrib/JWcNoL
	gqDRJGg6mO+nNBhkBa6Qa6zZ8SQLqILMc1FX+vOWFgPVWjnLKgWXRElx8rVrTQy61cXulqp1bVy
	UA9glryhm9UHoyg==
X-Received: by 2002:ac8:42d9:: with SMTP id g25mr145008qtm.224.1635368270467; 
	Wed, 27 Oct 2021 13:57:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxj2/b//CzKJD17p/fdvP4wST4eyXw3ThwXRkUyQ+vMYI8qscGjcwWxN3XIq1UYIJ8djSjjCQ==
X-Received: by 2002:ac8:42d9:: with SMTP id g25mr144993qtm.224.1635368270283; 
	Wed, 27 Oct 2021 13:57:50 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id y9sm780354qko.74.2021.10.27.13.57.49
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 27 Oct 2021 13:57:49 -0700 (PDT)
Date: Wed, 27 Oct 2021 16:57:49 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <YXm9Td5kTuMChvH3@redhat.com>
References: <163469252421.3058604.4246950335082826987.stgit@olly>
	<CAHC9VhRg=2yPdVMcCmP9=++jHtHWP7t3S9dhKj9QFjpFyKvCjw@mail.gmail.com>
	<CAHC9VhRFwSL99a3DNr5-6vKgD4w1YCvoVXZr9X=oAhhA6Zb5FQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRFwSL99a3DNr5-6vKgD4w1YCvoVXZr9X=oAhhA6Zb5FQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] audit: correct the AUDIT_DM_CTRL and AUDIT_DM_EVENT
	numbering
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 26 2021 at 10:22P -0400,
Paul Moore <paul@paul-moore.com> wrote:

> On Tue, Oct 19, 2021 at 9:17 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Tue, Oct 19, 2021 at 9:15 PM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > Due to conflict with the audit and SELinux trees the device mapper
> > > audit record types need to be renumbered before landing in Linus'
> > > tree.
> > >
> > > Link: https://lore.kernel.org/lkml/CAHC9VhTLmzDQPqsj+vyBNua1X13UK_tTcixKZ7WWYEqMXVOXdQ@mail.gmail.com/
> > > Fixes: c1d7fa96e74b ("dm: introduce audit event module for device mapper")
> > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > ---
> > >  include/uapi/linux/audit.h |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Alasdair or Mike, please merge this into the device-mapper tree before
> > you send it to Linus during the upcoming merge window.
> 
> Please merge this fix into the device-mapper tree to fix a patch in
> the for-next branch, otherwise there is a chance for breakage due to
> potentially botched merges during the upcoming merge window.

I fixed it up.. via rebase, so we should be all set.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

