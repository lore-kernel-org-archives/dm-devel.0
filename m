Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A97C3DA7C
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645388;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xJVTskkcvrMqNn2WJUPvls8m7zQw2iAsc418zVtzQWs=;
	b=hBu9bSHot7wiihnIkgipnCQZCNwF0zfyo7n9APc8mE4bb8C6qmEYg1bdy8F/RRf85sGOaG
	uV9HaM1S/Q/nA3zZyEk0+Ex2AnUgry726kbOijgH2mGTQUtoqSAspX37hlN4qAnKgL5An5
	W1CjAAnNCG4rSoHuTowkDG27dYaG2ZI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-clo8-Qs8MbSjyoRJ1kc5tQ-1; Mon, 02 Jan 2023 02:43:06 -0500
X-MC-Unique: clo8-Qs8MbSjyoRJ1kc5tQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 211018F6E8C;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86EDF492D8B;
	Mon,  2 Jan 2023 07:43:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A1D11946589;
	Mon,  2 Jan 2023 07:43:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ABC9C1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:17:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D1F040C2005; Thu, 29 Dec 2022 08:17:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A8E40C2004
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:17:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2835E811E6E
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:17:39 +0000 (UTC)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
 [209.85.208.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-209-1hdQ1WvSPgWgpXfntIiGYg-2; Thu, 29 Dec 2022 03:17:35 -0500
X-MC-Unique: 1hdQ1WvSPgWgpXfntIiGYg-2
Received: by mail-ed1-f42.google.com with SMTP id m21so25781930edc.3
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:17:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=7n+B+X0KvL5FYpt4R5yWJ/ag0L0NLxa0tbY9qucKwuI=;
 b=tT8nyU2GUfNTn7/pOBLpCW6vhzx64jc8LOaNYwCjtzBIUgOH/vhrT5yimxjPkj2+hm
 BYJpZA4T67NyqTgwls8StfFFbn2B68rGIPD6YOw8nigD5oYIOU3BOgnGavDaJYXP/y0L
 XPPQoFbGkmUlPv8QNYWcvrMqvcXTtHe2Vi59xZuYyhBmfe36U87XNQU6ji1Kv0QTLCOI
 6qcvhMz79nMgUXh9ynsMoQ8TxqQ8N+ULCEfiE/APdt25vjrPPk9EHfBvS5dXCGTXCusD
 ucojQlEvlMP4K02vpB3MTj0PTQbgsBbPTCqygVsXzZW8AIdrDAIpFZfG9zVd9D/TngzE
 aV/Q==
X-Gm-Message-State: AFqh2koTzWa81GQEHNU1i7FDytE0bVGv+K63HSg6HavxIzK0au4GjZo5
 R5JDa9/t9AT04GA1BJLNlbpn2gsoPqAIRoucPcD+7w==
X-Google-Smtp-Source: AMrXdXulwl3zEgOGWwmMivflDb4UfyGNGI7lU4m/aeAvt/3L5Hf+inrJtG+WSFp0FPQl5mpy0l5FjfKOF5TBfRVSOU8=
X-Received: by 2002:a50:fe17:0:b0:487:e554:31e8 with SMTP id
 f23-20020a50fe17000000b00487e55431e8mr670416edt.353.1672301854647; Thu, 29
 Dec 2022 00:17:34 -0800 (PST)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-2-sarthakkukreti@google.com>
 <Yy3NeY02zEMLTdsa@redhat.com>
In-Reply-To: <Yy3NeY02zEMLTdsa@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 29 Dec 2022 00:17:23 -0800
Message-ID: <CAG9=OMO=j=kOGX4hnYSt490wURF_a8ZM5MctKpeV2TaiKS8RhQ@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: Re: [dm-devel] [PATCH RFC 1/8] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org,
 Evan Green <evgreen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 23, 2022 at 8:15 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Thu, Sep 15 2022 at 12:48P -0400,
> Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:
>
> > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> >
> > Introduce block request REQ_OP_PROVISION. The intent of this request
> > is to request underlying storage to preallocate disk space for the given
> > block range. Block device that support this capability will export
> > a provision limit within their request queues.
> >
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  block/blk-core.c          |  5 ++++
> >  block/blk-lib.c           | 55 +++++++++++++++++++++++++++++++++++++++
> >  block/blk-merge.c         | 17 ++++++++++++
> >  block/blk-settings.c      | 19 ++++++++++++++
> >  block/blk-sysfs.c         |  8 ++++++
> >  block/bounce.c            |  1 +
> >  include/linux/bio.h       |  6 +++--
> >  include/linux/blk_types.h |  5 +++-
> >  include/linux/blkdev.h    | 16 ++++++++++++
> >  9 files changed, 129 insertions(+), 3 deletions(-)
> >
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index 8bb9eef5310e..be79ad68b330 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -57,6 +57,7 @@ void blk_set_default_limits(struct queue_limits *lim)
> >       lim->misaligned = 0;
> >       lim->zoned = BLK_ZONED_NONE;
> >       lim->zone_write_granularity = 0;
> > +     lim->max_provision_sectors = 0;
> >  }
> >  EXPORT_SYMBOL(blk_set_default_limits);
> >
> > @@ -81,6 +82,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
> >       lim->max_dev_sectors = UINT_MAX;
> >       lim->max_write_zeroes_sectors = UINT_MAX;
> >       lim->max_zone_append_sectors = UINT_MAX;
> > +     lim->max_provision_sectors = UINT_MAX;
> >  }
> >  EXPORT_SYMBOL(blk_set_stacking_limits);
> >
>
> Please work through the blk_stack_limits() implementation too (simple
> min_not_zero?).
>
(Sorry, I might have misunderstood what you meant) Doesn't the chunk
at L572 handle this:


@@ -572,6 +588,9 @@ int blk_stack_limits(struct queue_limits *t,
struct queue_limits *b,
        t->max_segment_size = min_not_zero(t->max_segment_size,
                                           b->max_segment_size);

+       t->max_provision_sectors = min_not_zero(t->max_provision_sectors,
+                                               b->max_provision_sectors);
+
        t->misaligned |= b->misaligned;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

