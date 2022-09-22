Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93F7ECAAD8
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 06:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663915077;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cz4UQH77zs9QY7OUiYtk1w7hKJl48llJ0lMOheUGNe0=;
	b=X3BXpFVZbH2WV4O09TzOZMUiJrjauuQT93EobWoCMq4DU3CGICFDjjAqoDxkkINBk2EbIb
	S5LgdETkGKssIJ8Gg/gav+ejbGJEscrMaxiCKmqTcXSNZOQ21rsLHfQC7fweP5/8/qDq6u
	efSuzcEzVFsEczFlT5Xjs8FDAjFNVHQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-uz5JsVyLNgSD6DYBN-ewNA-1; Fri, 23 Sep 2022 02:37:53 -0400
X-MC-Unique: uz5JsVyLNgSD6DYBN-ewNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F53D85530D;
	Fri, 23 Sep 2022 06:37:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAE7540C94AA;
	Fri, 23 Sep 2022 06:37:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4053F1946A71;
	Fri, 23 Sep 2022 06:37:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9304E19465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Sep 2022 08:04:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7727E17595; Thu, 22 Sep 2022 08:04:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F6BC53AA
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 08:04:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 498BC86E922
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 08:04:48 +0000 (UTC)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-307-LdTtctU2NzmBe4Jxzw7T9Q-1; Thu, 22 Sep 2022 04:04:46 -0400
X-MC-Unique: LdTtctU2NzmBe4Jxzw7T9Q-1
Received: by mail-ej1-f53.google.com with SMTP id lc7so19369342ejb.0
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 01:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=bQFLgTcLz9TuLH0amhPimE3+FHgwiRo1jLNErCwcRKI=;
 b=fZAjtxZTbvxhJhiAmO8Sr5rZNmQV3rPfOVtz1hwn+gt2oGFiCZ2DzAKDG7OE4PerG5
 DI3ey0wL0dr/6k7rKytXMTjUAxmNwTwWZPKFwlqX6rQYzyF96nJvtKEQk2PBQftpfg9/
 K7RZIl2fxxXHqqe1Qv0i7wytqMFzpWOf5oAnapB8F0VVibAtB0YM/DVZ89SdKtX6HgaZ
 1YX4TUCh1AjVpEOh8QbTALcSnZgvmWHUC/F67U82+dfTNZMUMNOpx15PHWSyq3wWDqVA
 lbhUp03T3X5UCqz1Oj3ojEVlnyoULWdCnq6mAtqXzPr4p+KjkiYMtgdfgx3PI6Uc+T0k
 6j3A==
X-Gm-Message-State: ACrzQf3GF7MidtI1nVDO6MRP4u2WaCWds+ONujjFqHL5Y7kTm4s33NLl
 ayCPP1WAgiKn2HrITasdxK/gav/Kj1uPnCTT5aKtNw==
X-Google-Smtp-Source: AMsMyM65W61199SNxMqK09DcJ8Cd+xiA/j5JaId5SNxyXyYW8/axB0uzEetY87KS6GvcJQCtWboffhiIXBtl4fzF85I=
X-Received: by 2002:a17:907:968d:b0:782:66dc:4b89 with SMTP id
 hd13-20020a170907968d00b0078266dc4b89mr466943ejc.386.1663833885268; Thu, 22
 Sep 2022 01:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YyRkd8YAH1lal8/N@bfoster>
 <CAG9=OMNL1Z3DiO-usdH0k90NDsDkDQ7A7CHc4Nu6MCXKNKjWdw@mail.gmail.com>
 <YyswI57JH7gcs9+S@bfoster>
In-Reply-To: <YyswI57JH7gcs9+S@bfoster>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 22 Sep 2022 01:04:33 -0700
Message-ID: <CAG9=OMPEoShYMx6A+p97-tw4MuLpgOEpy7aFs5CH6wTedptALQ@mail.gmail.com>
To: Brian Foster <bfoster@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 21, 2022 at 8:39 AM Brian Foster <bfoster@redhat.com> wrote:
>
> On Fri, Sep 16, 2022 at 02:02:31PM -0700, Sarthak Kukreti wrote:
> > On Fri, Sep 16, 2022 at 4:56 AM Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > > > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > >
> > > > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > > > sends a hint to (supported) thinly provisioned block devices to
> > > > allocate space for the given range of sectors via REQ_OP_PROVISION.
> > > >
> > > > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > > ---
> > > >  block/fops.c                | 7 ++++++-
> > > >  include/linux/falloc.h      | 3 ++-
> > > >  include/uapi/linux/falloc.h | 8 ++++++++
> > > >  3 files changed, 16 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/block/fops.c b/block/fops.c
> > > > index b90742595317..a436a7596508 100644
> > > > --- a/block/fops.c
> > > > +++ b/block/fops.c
> > > ...
> > > > @@ -661,6 +662,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> > > >               error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
> > > >                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > > >               break;
> > > > +     case FALLOC_FL_PROVISION:
> > > > +             error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
> > > > +                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > > > +             break;
> > > >       default:
> > > >               error = -EOPNOTSUPP;
> > > >       }
> > >
> > > Hi Sarthak,
> > >
> > > Neat mechanism.. I played with something very similar in the past (that
> > > was much more crudely hacked up to target dm-thin) to allow filesystems
> > > to request a thinly provisioned device to allocate blocks and try to do
> > > a better job of avoiding inactivation when overprovisioned.
> > >
> > > One thing I'm a little curious about here.. what's the need for a new
> > > fallocate mode? On a cursory glance, the provision mode looks fairly
> > > analogous to normal (mode == 0) allocation mode with the exception of
> > > sending the request down to the bdev. blkdev_fallocate() already maps
> > > some of the logical falloc modes (i.e. punch hole, zero range) to
> > > sending write sames or discards, etc., and it doesn't currently look
> > > like it supports allocation mode, so could it not map such requests to
> > > the underlying REQ_OP_PROVISION op?
> > >
> > > I guess the difference would be at the filesystem level where we'd
> > > probably need to rely on a mount option or some such to control whether
> > > traditional fallocate issues provision ops (like you've implemented for
> > > ext4) vs. the specific falloc command, but that seems fairly consistent
> > > with historical punch hole/discard behavior too. Hm? You might want to
> > > cc linux-fsdevel in future posts in any event to get some more feedback
> > > on how other filesystems might want to interact with such a thing.
> > >
> > Thanks for the feedback!
> > Argh, I completely forgot that I should add linux-fsdevel. Let me
> > re-send this with linux-fsdevel cc'd
> >
> > There's a slight distinction is that the current filesystem-level
> > controls are usually for default handling, but userspace can still
> > call the relevant functions manually if they need to. For example, for
> > ext4, the 'discard' mount option dictates whether free blocks are
> > discarded, but it doesn't set the policy to allow/disallow userspace
> > from manually punching holes into files even if the mount opt is
> > 'nodiscard'. FALLOC_FL_PROVISION is similar in that regard; it adds a
> > manual mechanism for users to provision the files' extents, that is
> > separate from the filesystems' default handling of provisioning files.
> >
>
> What I'm trying to understand is why not let blkdev_fallocate() issue a
> provision based on the default mode (i.e. mode == 0) of fallocate(),
> which is already defined to mean "perform allocation?" It currently
> issues discards or write zeroes based on variants of
> FALLOC_FL_PUNCH_HOLE without the need for a separate FALLOC_FL_DISCARD
> mode, for example.
>
It's mostly to keep the block device fallocate() semantics in-line and
consistent with the file-specific modes: I added the separate
filesystem fallocate() mode under the assumption that we'd want to
keep the traditional handling for filesystems intact with (mode == 0).
And for block devices, I didn't map the requests to mode == 0 so that
it's less confusing to describe (eg. mode == 0 on block devices will
issue provision; mode == 0 on files will not). It would complicate
loopback devices, for instance; if the loop device is backed by a
file, it would need to use (mode == FALLOC_FL_PROVISION) but if the
loop device is backed by another block device, then the fallocate()
call would need to switch to (mode == 0).

With the separate mode, we can describe the semantics of falllcate()
modes a bit more cleanly, and it is common for both files and block
devices:

1. mode == 0: allocation at the same layer, will not provision on the
underlying device/filesystem (unsupported for block devices).
2. mode == FALLOC_FL_PROVISION, allocation at the layer, will
provision on the underlying device/filesystem.

Block devices don't technically need to use a separate mode, but it
makes it much less confusing if filesystems are already using a
separate mode for provision.

Best
Sarthak

> Brian
>
> > > BTW another thing that might be useful wrt to dm-thin is to support
> > > FALLOC_FL_UNSHARE. I.e., it looks like the previous dm-thin patch only
> > > checks that blocks are allocated, but not whether those blocks are
> > > shared (re: lookup_result.shared). It might be useful to do the COW in
> > > such cases if the caller passes down a REQ_UNSHARE or some such flag.
> > >
> > That's an interesting idea! There's a few more things on the TODO list
> > for this patch series but I think we can follow up with a patch to
> > handle that as well.
> >
> > Sarthak
> >
> > > Brian
> > >
> > > > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > > > index f3f0b97b1675..a0e506255b20 100644
> > > > --- a/include/linux/falloc.h
> > > > +++ b/include/linux/falloc.h
> > > > @@ -30,7 +30,8 @@ struct space_resv {
> > > >                                        FALLOC_FL_COLLAPSE_RANGE |     \
> > > >                                        FALLOC_FL_ZERO_RANGE |         \
> > > >                                        FALLOC_FL_INSERT_RANGE |       \
> > > > -                                      FALLOC_FL_UNSHARE_RANGE)
> > > > +                                      FALLOC_FL_UNSHARE_RANGE |                          \
> > > > +                                      FALLOC_FL_PROVISION)
> > > >
> > > >  /* on ia32 l_start is on a 32-bit boundary */
> > > >  #if defined(CONFIG_X86_64)
> > > > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > > > index 51398fa57f6c..2d323d113eed 100644
> > > > --- a/include/uapi/linux/falloc.h
> > > > +++ b/include/uapi/linux/falloc.h
> > > > @@ -77,4 +77,12 @@
> > > >   */
> > > >  #define FALLOC_FL_UNSHARE_RANGE              0x40
> > > >
> > > > +/*
> > > > + * FALLOC_FL_PROVISION acts as a hint for thinly provisioned devices to allocate
> > > > + * blocks for the range/EOF.
> > > > + *
> > > > + * FALLOC_FL_PROVISION can only be used with allocate-mode fallocate.
> > > > + */
> > > > +#define FALLOC_FL_PROVISION          0x80
> > > > +
> > > >  #endif /* _UAPI_FALLOC_H_ */
> > > > --
> > > > 2.31.0
> > > >
> > >
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

