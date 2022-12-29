Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF75C46467
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=diWf6bbqGoe5Z7KHr7VKhMwS1FLMmTACOuO4PF0XAqQ=;
	b=W5FMs4icvxz4OLQQICRnD7OuUVh/mFNaTPU0L6M9AjSYFaGHXltIVx3H9WHsbPkR5AZFro
	8wAE2K/H1MJPi+R/Y6Qzju9ikEHTRwnJAtHLa/6MYLCsu/hpeElE0g1mxcWpxtgTgfAwGQ
	F+vvX2/Xx2v+6BWEndJrs8xYtH1i0PQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-acPnSvZxPeG5xX6gj6iILw-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: acPnSvZxPeG5xX6gj6iILw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FE703811F21;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 468AB1121314;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C82651946A77;
	Mon,  2 Jan 2023 07:43:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D6A61946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:17:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4CDDD140EBF6; Thu, 29 Dec 2022 08:17:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A4C140EBF5
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:17:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27C0D811E6E
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:17:15 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-wq1CpeslOIqxX26wtave5A-1; Thu, 29 Dec 2022 03:17:13 -0500
X-MC-Unique: wq1CpeslOIqxX26wtave5A-1
Received: by mail-ed1-f48.google.com with SMTP id s5so25762941edc.12
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:17:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=w0NMCIz7aH+VtGKA1bV7VY9PC5bA85xBilVtidrBy8A=;
 b=YI7sIimLSNKufCpkewUQVV+mQ3FbRtiEtNR28Nxw3zxFUdch2wTAWR8oHnOiD6cQZg
 zjJUXsw1pbd9sNSLcso7o/rSdHC88JK3VicaB6fktcijgUcJDeNcqC4RJ9c/BcUKq3F/
 UFOgO6nFhcKSj0ri/EwwrB2J3Z0F1bsjgxfOjHRKKEjTX/d7FL/TOE0QNBmz6RwL7LkM
 Ogzvf3dOqMYBuMdeGIFRhW9WJKw6J2bU/3bFmn17pr442w8Bn/orTrp41OzJRLdisKyt
 ZV2jkRbLIzoXaNUQ7wkcDUNhRgxGJC/Y9zdwWjt4m4JdV5pkyY/Ys/yo5fQtLyfQBpnR
 jSUw==
X-Gm-Message-State: AFqh2kp+bHoKJAH25ab3NbayAjBICarZD5OoSeiCHo6T1b24X3KDlFwW
 vtJ05mRNcBaxcpLh2tzHjHLLlbjsk4jRL8oaoO4sbw==
X-Google-Smtp-Source: AMrXdXu3EKpSmLPFvCpiaXPU3Qs1Jd81kJn1isDVUcu3PP3d3QTMj7mvfgCejXWSIQqTSxpfbstvHC/uh543CNwAPrU=
X-Received: by 2002:a05:6402:f27:b0:485:8114:9779 with SMTP id
 i39-20020a0564020f2700b0048581149779mr1316677eda.41.1672301831977; Thu, 29
 Dec 2022 00:17:11 -0800 (PST)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
 <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
 <Yylvvm3zVgqpqDrm@infradead.org>
 <CAAKderPF5Z5QLxyEb80Y+90+eR0sfRmL-WfgXLp=eL=HxWSZ9g@mail.gmail.com>
 <YymkSDsFVVg1nbDP@infradead.org>
 <CAAKderNcHpbBqWqqd5-WuKLRCQQUt7a_4D4ti4gy15+fKGK0vQ@mail.gmail.com>
 <Yy1zkMH0f9ski4Sg@infradead.org> <Yy29y/jUvWM6GRZ5@redhat.com>
In-Reply-To: <Yy29y/jUvWM6GRZ5@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 29 Dec 2022 00:17:00 -0800
Message-ID: <CAG9=OMPQEoMVpXD8PeHwkymwk-zfB3mSvDO_W6h0S3Zom62JBQ@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Gwendal Grignou <gwendal@google.com>,
 virtualization@lists.linux-foundation.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 23, 2022 at 7:08 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Fri, Sep 23 2022 at  4:51P -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
>
> > On Wed, Sep 21, 2022 at 07:48:50AM +1000, Daniil Lunev wrote:
> > > > There is no such thing as WRITE UNAVAILABLE in NVMe.
> > > Apologize, that is WRITE UNCORRECTABLE. Chapter 3.2.7 of
> > > NVM Express NVM Command Set Specification 1.0b
> >
> > Write uncorrectable is a very different thing, and the equivalent of the
> > horribly misnamed SCSI WRITE LONG COMMAND.  It injects an unrecoverable
> > error, and does not provision anything.
> >
> > > * Each application is potentially allowed to consume the entirety
> > >   of the disk space - there is no strict size limit for application
> > > * Applications need to pre-allocate space sometime, for which
> > >   they use fallocate. Once the operation succeeded, the application
> > >   assumed the space is guaranteed to be there for it.
> > > * Since filesystems on the volumes are independent, filesystem
> > >   level enforcement of size constraints is impossible and the only
> > >   common level is the thin pool, thus, each fallocate has to find its
> > >   representation in thin pool one way or another - otherwise you
> > >   may end up in the situation, where FS thinks it has allocated space
> > >   but when it tries to actually write it, the thin pool is already
> > >   exhausted.
> > > * Hole-Punching fallocate will not reach the thin pool, so the only
> > >   solution presently is zero-writing pre-allocate.
> >
> > To me it sounds like you want a non-thin pool in dm-thin and/or
> > guaranted space reservations for it.
>
> What is implemented in this patchset: enablement for dm-thinp to
> actually provide guarantees which fallocate requires.
>
> Seems you're getting hung up on the finishing details in HW (details
> which are _not_ the point of this patchset).
>
> The proposed changes are in service to _Linux_ code. The patchset
> implements the primitive from top (ext4) to bottom (dm-thinp, loop).
> It stops short of implementing handling everywhere that'd need it
> (e.g. in XFS, etc). But those changes can come as follow-on work once
> the primitive is established top to bottom.
>
> But you know all this ;)
>
> > > * Thus, a provisioning block operation allows an interface specific
> > >   operation that guarantees the presence of the block in the
> > >   mapped space. LVM Thin-pool itself is the primary target for our
> > >   use case but the argument is that this operation maps well to
> > >   other interfaces which allow thinly provisioned units.
> >
> > I think where you are trying to go here is badly mistaken.  With flash
> > (or hard drive SMR) there is no such thing as provisioning LBAs.  Every
> > write is out of place, and a one time space allocation does not help
> > you at all.  So fundamentally what you try to here just goes against
> > the actual physics of modern storage media.  While there are some
> > layers that keep up a pretence, trying to that an an exposed API
> > level is a really bad idea.
>
> This doesn't need to be so feudal.  Reserving an LBA in physical HW
> really isn't the point.
>
> Fact remains: an operation that ensures space is actually reserved via
> fallocate is long overdue (just because an FS did its job doesn't mean
> underlying layers reflect that). And certainly useful, even if "only"
> benefiting dm-thinp and the loop driver. Like other block primitives,
> REQ_OP_PROVISION is filtered out by block core if the device doesn't
> support it.
>
> That said, I agree with Brian Foster that we need really solid
> documentation and justification for why fallocate mode=0 cannot be
> used (but the case has been made in this thread).
>
> Also, I do see an issue with the implementation (relative to stacked
> devices): dm_table_supports_provision() is too myopic about DM. It
> needs to go a step further and verify that some layer in the stack
> actually services REQ_OP_PROVISION. Will respond to DM patch too.
>
Thanks all for the suggestions and feedback! I just posted v2 (more
than a bit belatedly) on the various mailing lists with the relevant
fixes, documentation and some benchmarks on performance.

Best
Sarthak

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

