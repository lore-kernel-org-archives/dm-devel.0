Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8F6ECAAD8
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663774779;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4lzbejESpK+sOuU0vc1/Wo28CL7S7/A2yvs8JSQkw6c=;
	b=Zwjd2mlZu3QP8uxGXQ5b7+qypKgcydUalWlZ3aCnxRJJfePYYXC8PbxvMMMMS7EQtIcOjH
	eu9thgcgDVH+LkJBCbYfYkaPaX/BckxB4+6NUWQE4vy2RxyKpD7yOJ3ry3Hpqtsi9238bs
	HypcksiI4iLl/Kf4c7FEa4ZgHxku63Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-Fdus6Gr2OfaxiTBF0sUr-A-1; Wed, 21 Sep 2022 11:39:35 -0400
X-MC-Unique: Fdus6Gr2OfaxiTBF0sUr-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F52C3C0D855;
	Wed, 21 Sep 2022 15:39:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E42CA49BB61;
	Wed, 21 Sep 2022 15:39:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C41A119465B1;
	Wed, 21 Sep 2022 15:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 24BBF19465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 15:39:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 15B8D40C6EC6; Wed, 21 Sep 2022 15:39:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D8A6040C6EC5
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 15:39:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B42EB1C07585
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 15:39:20 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-75-ECHfg2KCPHmJO5zKhUM4FA-1; Wed, 21 Sep 2022 11:39:19 -0400
X-MC-Unique: ECHfg2KCPHmJO5zKhUM4FA-1
Received: by mail-qv1-f72.google.com with SMTP id
 y7-20020ad45307000000b004ac7fd46495so4571059qvr.23
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 08:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=qdyn6X4um0jOmxbVbIVJ/ritfQu0YXAwmpkbuktXlco=;
 b=wPuLIFJgq5N0uoArpINyG47xnzpxQTv61IEREY3ypypLQ/CTFHmMqyy5MwEcV+LnzA
 c7x+Uqvl2lapo3nFnCLZIVm3gCw9y7jxPOYl3TBkCOC/rNG1/t9OB+VDn5vlDyD/3KAr
 Uoaxl1B16xRfKfIKLefi+sUZTn+OOKQ/MLqqkgxH8MnrPI5rTXYKgKVKhGvp87ixh2Ft
 7lqfh2z1SGg8GmbDuQGsbgldNKimfkJDlogJhkyLUXV+ZOhqqU7bHRtYDWcp2okqeQjd
 xyAlq7To1Xp9I+4BTN8xvd+SWg8xz0XD7qvhrCdapYWC43F4dP9FroJ25J/dvMUasoLP
 n7RQ==
X-Gm-Message-State: ACrzQf1umoJsrw1kTOte4Gl+5Q5PKCAeIUifBlZT3+53e7dkLGpRt83z
 kHAKzcrYKbc7wwD0rWkRWi7a8NMN7SxD5CT7sy6D1BIq1M+lh7p2UjEnX8UHWNhlnDf4st7FyIC
 qN9gVoE1Aw82WOQs=
X-Received: by 2002:ac8:5a13:0:b0:35c:e9b0:430b with SMTP id
 n19-20020ac85a13000000b0035ce9b0430bmr13368702qta.472.1663774758895; 
 Wed, 21 Sep 2022 08:39:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM594zwhYYo497Gbf01p/qkC0k5EzOtGiVtB6LsJU02syDsCgiXnnQXhpz8ER02eO+Lp+Qd8CQ==
X-Received: by 2002:ac8:5a13:0:b0:35c:e9b0:430b with SMTP id
 n19-20020ac85a13000000b0035ce9b0430bmr13368681qta.472.1663774758598; 
 Wed, 21 Sep 2022 08:39:18 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 f25-20020ac84659000000b0035ccd148026sm1791612qto.69.2022.09.21.08.39.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Sep 2022 08:39:18 -0700 (PDT)
Date: Wed, 21 Sep 2022 11:39:15 -0400
From: Brian Foster <bfoster@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <YyswI57JH7gcs9+S@bfoster>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YyRkd8YAH1lal8/N@bfoster>
 <CAG9=OMNL1Z3DiO-usdH0k90NDsDkDQ7A7CHc4Nu6MCXKNKjWdw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMNL1Z3DiO-usdH0k90NDsDkDQ7A7CHc4Nu6MCXKNKjWdw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 16, 2022 at 02:02:31PM -0700, Sarthak Kukreti wrote:
> On Fri, Sep 16, 2022 at 4:56 AM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > >
> > > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > > sends a hint to (supported) thinly provisioned block devices to
> > > allocate space for the given range of sectors via REQ_OP_PROVISION.
> > >
> > > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > ---
> > >  block/fops.c                | 7 ++++++-
> > >  include/linux/falloc.h      | 3 ++-
> > >  include/uapi/linux/falloc.h | 8 ++++++++
> > >  3 files changed, 16 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/block/fops.c b/block/fops.c
> > > index b90742595317..a436a7596508 100644
> > > --- a/block/fops.c
> > > +++ b/block/fops.c
> > ...
> > > @@ -661,6 +662,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> > >               error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
> > >                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > >               break;
> > > +     case FALLOC_FL_PROVISION:
> > > +             error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
> > > +                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > > +             break;
> > >       default:
> > >               error = -EOPNOTSUPP;
> > >       }
> >
> > Hi Sarthak,
> >
> > Neat mechanism.. I played with something very similar in the past (that
> > was much more crudely hacked up to target dm-thin) to allow filesystems
> > to request a thinly provisioned device to allocate blocks and try to do
> > a better job of avoiding inactivation when overprovisioned.
> >
> > One thing I'm a little curious about here.. what's the need for a new
> > fallocate mode? On a cursory glance, the provision mode looks fairly
> > analogous to normal (mode == 0) allocation mode with the exception of
> > sending the request down to the bdev. blkdev_fallocate() already maps
> > some of the logical falloc modes (i.e. punch hole, zero range) to
> > sending write sames or discards, etc., and it doesn't currently look
> > like it supports allocation mode, so could it not map such requests to
> > the underlying REQ_OP_PROVISION op?
> >
> > I guess the difference would be at the filesystem level where we'd
> > probably need to rely on a mount option or some such to control whether
> > traditional fallocate issues provision ops (like you've implemented for
> > ext4) vs. the specific falloc command, but that seems fairly consistent
> > with historical punch hole/discard behavior too. Hm? You might want to
> > cc linux-fsdevel in future posts in any event to get some more feedback
> > on how other filesystems might want to interact with such a thing.
> >
> Thanks for the feedback!
> Argh, I completely forgot that I should add linux-fsdevel. Let me
> re-send this with linux-fsdevel cc'd
> 
> There's a slight distinction is that the current filesystem-level
> controls are usually for default handling, but userspace can still
> call the relevant functions manually if they need to. For example, for
> ext4, the 'discard' mount option dictates whether free blocks are
> discarded, but it doesn't set the policy to allow/disallow userspace
> from manually punching holes into files even if the mount opt is
> 'nodiscard'. FALLOC_FL_PROVISION is similar in that regard; it adds a
> manual mechanism for users to provision the files' extents, that is
> separate from the filesystems' default handling of provisioning files.
> 

What I'm trying to understand is why not let blkdev_fallocate() issue a
provision based on the default mode (i.e. mode == 0) of fallocate(),
which is already defined to mean "perform allocation?" It currently
issues discards or write zeroes based on variants of
FALLOC_FL_PUNCH_HOLE without the need for a separate FALLOC_FL_DISCARD
mode, for example.

Brian

> > BTW another thing that might be useful wrt to dm-thin is to support
> > FALLOC_FL_UNSHARE. I.e., it looks like the previous dm-thin patch only
> > checks that blocks are allocated, but not whether those blocks are
> > shared (re: lookup_result.shared). It might be useful to do the COW in
> > such cases if the caller passes down a REQ_UNSHARE or some such flag.
> >
> That's an interesting idea! There's a few more things on the TODO list
> for this patch series but I think we can follow up with a patch to
> handle that as well.
> 
> Sarthak
> 
> > Brian
> >
> > > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > > index f3f0b97b1675..a0e506255b20 100644
> > > --- a/include/linux/falloc.h
> > > +++ b/include/linux/falloc.h
> > > @@ -30,7 +30,8 @@ struct space_resv {
> > >                                        FALLOC_FL_COLLAPSE_RANGE |     \
> > >                                        FALLOC_FL_ZERO_RANGE |         \
> > >                                        FALLOC_FL_INSERT_RANGE |       \
> > > -                                      FALLOC_FL_UNSHARE_RANGE)
> > > +                                      FALLOC_FL_UNSHARE_RANGE |                          \
> > > +                                      FALLOC_FL_PROVISION)
> > >
> > >  /* on ia32 l_start is on a 32-bit boundary */
> > >  #if defined(CONFIG_X86_64)
> > > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > > index 51398fa57f6c..2d323d113eed 100644
> > > --- a/include/uapi/linux/falloc.h
> > > +++ b/include/uapi/linux/falloc.h
> > > @@ -77,4 +77,12 @@
> > >   */
> > >  #define FALLOC_FL_UNSHARE_RANGE              0x40
> > >
> > > +/*
> > > + * FALLOC_FL_PROVISION acts as a hint for thinly provisioned devices to allocate
> > > + * blocks for the range/EOF.
> > > + *
> > > + * FALLOC_FL_PROVISION can only be used with allocate-mode fallocate.
> > > + */
> > > +#define FALLOC_FL_PROVISION          0x80
> > > +
> > >  #endif /* _UAPI_FALLOC_H_ */
> > > --
> > > 2.31.0
> > >
> >
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

