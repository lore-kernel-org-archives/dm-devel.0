Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4073C6FA86
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 06:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663915076;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=waAQQuZ9Z85G5L9DzZhsBE5exam0VCVxxTESqaWK87Q=;
	b=MU/loMQ9SAayvOUlCF7N/YO/5D5RdiFUN/4cE/3hJ1Vka+5k3tfSDYCNe9jEEBQefOe0xF
	S/p+CXsS/bSDMC0SkOuekVtEGynq9tGOyaeC0KJwmTohocWarcaGRzRDHjI2QUeQxRDBlx
	pKXk2fF7Q4CCvhcGQTff23zbBEy9DDY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-Ton9UwkNN7uv_4fW81t2LA-1; Fri, 23 Sep 2022 02:37:53 -0400
X-MC-Unique: Ton9UwkNN7uv_4fW81t2LA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CAE4855306;
	Fri, 23 Sep 2022 06:37:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 042012022EA2;
	Fri, 23 Sep 2022 06:37:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB30719465B6;
	Fri, 23 Sep 2022 06:37:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 45A6819465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Sep 2022 08:08:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 296212166B5D; Thu, 22 Sep 2022 08:08:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21D312166B4E
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 08:08:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01C6B1C05159
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 08:08:20 +0000 (UTC)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com
 [209.85.218.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-IMdIvZoYPHuel-A5AQpnNQ-1; Thu, 22 Sep 2022 04:08:16 -0400
X-MC-Unique: IMdIvZoYPHuel-A5AQpnNQ-1
Received: by mail-ej1-f41.google.com with SMTP id 13so19253699ejn.3
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 01:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=iXb0cbDYs80FVQvp3dlURrNlpg98/EoNXEVRyzUkW50=;
 b=ZU5BDYpCcsW2UkuXOBS8P+xehd7Sqv7/SkOkc6c6WnLggpQJsz3ZFuUUfHQUwJKGwt
 p5HSlYLIIDts6xyXhgDoTuQpzqKsLV7ZPPhTddW12sSkPdJDDoEj26AJ6gFebQubc6Jl
 woX2qnUEHyTzgIXX6sTZEPRnGJqTG1Nye8qkVsM1SQX1mRHfNlaMFBAyv23yipP2PCzj
 ODpfnJ+96omqJ0SqyDxsagsz4QhNlOnj+TvD2fbjvXjgmlMO4h4MQxcqpUG3xIdWeASp
 X6nbqZxP30NfEcItltqyXKtVHBjQV2E4fVr0RfOHygQ2ll8XZTx+Nn3ygA6F3ZDvWWED
 M2zQ==
X-Gm-Message-State: ACrzQf3JhGz8eVGLp1gZgdZY2Oo37KFB7M4TvrQov5eTwAixYEVNYJtu
 3lN6tbv3ys70BeoUkjbhgTlS2J9swJxd+fE9fH8+gQ==
X-Google-Smtp-Source: AMsMyM7i6u9R9wd6F2HsmOaCSgsITPCe9fOhLfptS21SS36RpCCdvJBHZsBH+Qgv2Rg77TzYFsaXYBngYZEeV1fxkLM=
X-Received: by 2002:a17:907:968d:b0:782:66dc:4b89 with SMTP id
 hd13-20020a170907968d00b0078266dc4b89mr478912ejc.386.1663834095090; Thu, 22
 Sep 2022 01:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YylweQAZkIdb5ixo@infradead.org>
 <CAG9=OMNoG01UUStNs_Zhsv6mXZw0M0q2v54ZriJvHZ4aspvjEQ@mail.gmail.com>
 <YyssAb/zTcIG2bev@redhat.com>
In-Reply-To: <YyssAb/zTcIG2bev@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 22 Sep 2022 01:08:03 -0700
Message-ID: <CAG9=OMN6+ra3W2VcyvnnxRvxQz6uncSCNZvxZ8x9HgvV4GGB6w@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 23 Sep 2022 06:37:48 +0000
Subject: Re: [dm-devel] [PATCH RFC 4/8] fs: Introduce FALLOC_FL_PROVISION
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 21, 2022 at 8:21 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Wed, Sep 21 2022 at  1:54P -0400,
> Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:
>
> > On Tue, Sep 20, 2022 at 12:49 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > > > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > >
> > > > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > > > sends a hint to (supported) thinly provisioned block devices to
> > > > allocate space for the given range of sectors via REQ_OP_PROVISION.
> > >
> > > So, how does that "provisioning" actually work in todays world where
> > > storage is usually doing out of place writes in one or more layers,
> > > including the flash storage everyone is using.  Does it give you one
> > > write?  And unlimited number?  Some undecided number inbetween?
> >
> > Apologies, the patchset was a bit short on describing the semantics so
> > I'll expand more in the next revision; I'd say that it's the minimum
> > of regular mode fallocate() guarantees at each allocation layer. For
> > example, the guarantees from a contrived storage stack like (left to
> > right is bottom to top):
> >
> > [ mmc0blkp1 | ext4(1) | sparse file | loop | dm-thinp | dm-thin | ext4(2) ]
> >
> > would be predicated on the guarantees of fallocate() per allocation
> > layer; if ext4(1) was replaced by a filesystem that did not support
> > fallocate(), then there would be no guarantee that a write to a file
> > on ext4(2) succeeds.
> >
> > For dm-thinp, in the current implementation, the provision request
> > allocates blocks for the range specified and adds the mapping to the
> > thinpool metadata. All subsequent writes are to the same block, so
> > you'll be able to write to the same block inifinitely. Brian mentioned
> > this above, one case it doesn't cover is if provision is called on a
> > shared block, but the natural extension would be to allocate and
> > assign a new block and copy the contents of the shared block (kind of
> > like copy-on-provision).
>
> It follows that ChromiumOS isn't using dm-thinp's snapshot support?
>
Not at the moment, but we definitely have ideas to explore re:snapshot
and dm-thinp (like A-B updates with thin volume snapshots), where this
would definitely be useful!

> But please do fold in incremental dm-thinp support to properly handle
> shared blocks (dm-thinp already handles breaking sharing, etc.. so
> I'll need to see where you're hooking into that you don't get this
> "for free").
>
Will do in v2. Thanks for the feedback.

Best
Sarthak

> Mike
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

