Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E4BC6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663774081;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=26W41q9D01iF4RPjEkP2S5gNdp4p45ArrfRI2ijJMbo=;
	b=TW3kY/k6wmTAPCh8iO1Dq/hdCJEEXiRANWRTtUxTWhZ3ZfGvVip4b8jMbyX2ERRQCxwJnY
	ZWB1ul1YopBTpsdpItJcCZqYjKtp/6lMYtup1w05Rw+6tcvOb1i4oO1l2R+sC3q8KJcgK6
	hzBKYDyi4mCq4jzcASfJ77rPaQZjPx4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530--uBKgeRXMI2yOStxjNSp_Q-1; Wed, 21 Sep 2022 11:27:59 -0400
X-MC-Unique: -uBKgeRXMI2yOStxjNSp_Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A89BF3C1172F;
	Wed, 21 Sep 2022 15:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 542F8492B05;
	Wed, 21 Sep 2022 15:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C01D19465B1;
	Wed, 21 Sep 2022 15:27:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 281A519465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 15:21:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D62D49BB62; Wed, 21 Sep 2022 15:21:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2668449BB60
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 15:21:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3EE31C05AAE
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 15:21:41 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-2vRo4ompNE-fQHIdvtnZHQ-1; Wed, 21 Sep 2022 11:21:40 -0400
X-MC-Unique: 2vRo4ompNE-fQHIdvtnZHQ-1
Received: by mail-qt1-f200.google.com with SMTP id
 e8-20020ac85988000000b0035c39dd5eb9so4392603qte.16
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 08:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=YKklums/Err7Bepni4gts8csmAXQyEMPG5WxwPmhH+I=;
 b=LllKyni0Gxa/HUm18xvwtoASM82NsGNgZ4vFJa//EiiFZcil8w8v5WpdOeLGU9hEcA
 usuFAtB1D+EGRjZsgUnAVV+oADNMbz0OorS7WIpd6EcJ72MuiWRoVDbmdmxd6nsIUVfd
 HOx5l7zg2f2u/ym12+ErTvk3Kcwmt4GknwjH1nvn+250LJMykZUU3pR3fK8YJM55rEoz
 wHTb4EAaB/DEOYobio1kKwogZEBmchYUslcNZciInBM+OCqNb4qKvF7pvlD/vKqOq0lW
 3zWjdQvt5bvfUYfOn8bR0D+CfATJJxbZBXCBYCALFt1FV4HokCmzfakwnifpdh3+bD9M
 gXvw==
X-Gm-Message-State: ACrzQf22lePzbKdEbPo78oxsx8qQEtdUSR/Imif4dPT0oVCiU6oiGin+
 5cSQx++FVGdVhveZgV5f/QpDQMZ5R/cEr+z78Fu7bI4dH9p8/YwEYE4aamao5eigW6s1ar48s9V
 INCHFKGhlXP7aqA==
X-Received: by 2002:a05:622a:613:b0:342:f81f:4f7e with SMTP id
 z19-20020a05622a061300b00342f81f4f7emr23848802qta.198.1663773699667; 
 Wed, 21 Sep 2022 08:21:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7OzWfjG2GRtTFHT6VQqKwenYDGxd0vRx6UOENP8cSn03FrcY2GR/YED/OGOmZJunHnK1JMlw==
X-Received: by 2002:a05:622a:613:b0:342:f81f:4f7e with SMTP id
 z19-20020a05622a061300b00342f81f4f7emr23848782qta.198.1663773699383; 
 Wed, 21 Sep 2022 08:21:39 -0700 (PDT)
Received: from localhost ([217.138.198.196]) by smtp.gmail.com with ESMTPSA id
 cf14-20020a05622a400e00b0031f41ea94easm1815844qtb.28.2022.09.21.08.21.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Sep 2022 08:21:39 -0700 (PDT)
Date: Wed, 21 Sep 2022 11:21:37 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <YyssAb/zTcIG2bev@redhat.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YylweQAZkIdb5ixo@infradead.org>
 <CAG9=OMNoG01UUStNs_Zhsv6mXZw0M0q2v54ZriJvHZ4aspvjEQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMNoG01UUStNs_Zhsv6mXZw0M0q2v54ZriJvHZ4aspvjEQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 21 2022 at  1:54P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> On Tue, Sep 20, 2022 at 12:49 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > >
> > > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > > sends a hint to (supported) thinly provisioned block devices to
> > > allocate space for the given range of sectors via REQ_OP_PROVISION.
> >
> > So, how does that "provisioning" actually work in todays world where
> > storage is usually doing out of place writes in one or more layers,
> > including the flash storage everyone is using.  Does it give you one
> > write?  And unlimited number?  Some undecided number inbetween?
> 
> Apologies, the patchset was a bit short on describing the semantics so
> I'll expand more in the next revision; I'd say that it's the minimum
> of regular mode fallocate() guarantees at each allocation layer. For
> example, the guarantees from a contrived storage stack like (left to
> right is bottom to top):
> 
> [ mmc0blkp1 | ext4(1) | sparse file | loop | dm-thinp | dm-thin | ext4(2) ]
> 
> would be predicated on the guarantees of fallocate() per allocation
> layer; if ext4(1) was replaced by a filesystem that did not support
> fallocate(), then there would be no guarantee that a write to a file
> on ext4(2) succeeds.
> 
> For dm-thinp, in the current implementation, the provision request
> allocates blocks for the range specified and adds the mapping to the
> thinpool metadata. All subsequent writes are to the same block, so
> you'll be able to write to the same block inifinitely. Brian mentioned
> this above, one case it doesn't cover is if provision is called on a
> shared block, but the natural extension would be to allocate and
> assign a new block and copy the contents of the shared block (kind of
> like copy-on-provision).

It follows that ChromiumOS isn't using dm-thinp's snapshot support?

But please do fold in incremental dm-thinp support to properly handle
shared blocks (dm-thinp already handles breaking sharing, etc.. so
I'll need to see where you're hooking into that you don't get this
"for free").

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

