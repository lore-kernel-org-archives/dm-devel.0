Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFB8C54EBD
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8OWHiS16VycNqMaBpQKJJIV/2X6UKjNcpVVfXVnFy80=;
	b=esr77NrfT+M0KZK588WfL/RQP10m4VQWxMvvjjDPQJTlsewiCWWu6jQoKVPACoY3lH4SnR
	XqyeMdE0aNhfYIauPFQ1lcnaBN7+ZilS2mEnfhjEQc6v472Sq6EMaHEueEgPR6F4mXD91O
	L7j/To/H4zMC34o9l/XFpX+ebES5Huk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-Re64VhnLNKikH5C2IYj3-g-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: Re64VhnLNKikH5C2IYj3-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 223F41C05EAA;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4702B14171B6;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C8D6119465A3;
	Mon,  2 Jan 2023 07:43:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8493A1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:13:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 661AFC15E7F; Thu, 29 Dec 2022 08:13:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EFF1C159BB
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 274BB3C02555
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:54 +0000 (UTC)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com
 [209.85.218.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-orlGjwWxMp6BNOgWB7KEyg-1; Thu, 29 Dec 2022 03:13:52 -0500
X-MC-Unique: orlGjwWxMp6BNOgWB7KEyg-1
Received: by mail-ej1-f48.google.com with SMTP id bj12so43361187ejb.13
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:13:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=NARw7AM8RPJfstkTCRPS/K1vPXKbzp2JAGZWB+homt4=;
 b=5iXy4+13ddanjgo9h4sF6KAiPn7z3wrCicCS52ORLaaF74bHtQ8pgI1wbc4v4knqQi
 pRxGLqatvV7wC5ujx1sB1R7epreLc3bVGiuwbT5VbNY1YFP9d+Blq7baL88OZmO6fY53
 ednEHE+ccSx3IR2IrXrjxSEoJHcM5NYYiHFgsOKI16jyYGPkgCWOGIOTlgDon4XzaYqo
 cXv5oEjCxVq4hx+u9Ag0Wli6whXXZ+h0QbVcYAhrCWZYZEBUEZHLApdKjpfAuRp2/xSG
 G8X+ca+OWE2uSVVJLvUZgM2cDWEeg/o/qo5KpB0szZY+Lf0+8C9kWn8i8wjoPVybvDbx
 zjDg==
X-Gm-Message-State: AFqh2kqy4k0aieP9YwaPIw6QcILWfcJb1FaDS6MU0Le3VN2m1sgOlGGd
 dMLtrSVtqf76jTWE/oBA7sRyQmOi7PJvbbkIlM53qQ==
X-Google-Smtp-Source: AMrXdXvrsAZeIr8bI/CcDHqXN/iTbAF6YPM2m5utRhbjCGA0F70X8tTswgMt8T9xicwIjzXECVhNdbq1F2naLbuvKAs=
X-Received: by 2002:a17:906:195a:b0:78d:b371:16e5 with SMTP id
 b26-20020a170906195a00b0078db37116e5mr1574790eje.456.1672301631125; Thu, 29
 Dec 2022 00:13:51 -0800 (PST)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YyRkd8YAH1lal8/N@bfoster>
 <CAG9=OMNL1Z3DiO-usdH0k90NDsDkDQ7A7CHc4Nu6MCXKNKjWdw@mail.gmail.com>
 <YyswI57JH7gcs9+S@bfoster>
 <CAG9=OMPEoShYMx6A+p97-tw4MuLpgOEpy7aFs5CH6wTedptALQ@mail.gmail.com>
 <YyypkOr3l2lx4Odi@bfoster>
In-Reply-To: <YyypkOr3l2lx4Odi@bfoster>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 29 Dec 2022 00:13:40 -0800
Message-ID: <CAG9=OMO4u5vTH+wzq0DuTo+0ti+DEFmP=NKfa2hJGUez+XgsCQ@mail.gmail.com>
To: Brian Foster <bfoster@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 22, 2022 at 11:29 AM Brian Foster <bfoster@redhat.com> wrote:
>
> On Thu, Sep 22, 2022 at 01:04:33AM -0700, Sarthak Kukreti wrote:
> > On Wed, Sep 21, 2022 at 8:39 AM Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > On Fri, Sep 16, 2022 at 02:02:31PM -0700, Sarthak Kukreti wrote:
> > > > On Fri, Sep 16, 2022 at 4:56 AM Brian Foster <bfoster@redhat.com> wrote:
> > > > >
> > > > > On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > > > > > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > > > >
> > > > > > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > > > > > sends a hint to (supported) thinly provisioned block devices to
> > > > > > allocate space for the given range of sectors via REQ_OP_PROVISION.
> > > > > >
> > > > > > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > > > > ---
> > > > > >  block/fops.c                | 7 ++++++-
> > > > > >  include/linux/falloc.h      | 3 ++-
> > > > > >  include/uapi/linux/falloc.h | 8 ++++++++
> > > > > >  3 files changed, 16 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/block/fops.c b/block/fops.c
> > > > > > index b90742595317..a436a7596508 100644
> > > > > > --- a/block/fops.c
> > > > > > +++ b/block/fops.c
> > > > > ...
> > > > > > @@ -661,6 +662,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> > > > > >               error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
> > > > > >                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > > > > >               break;
> > > > > > +     case FALLOC_FL_PROVISION:
> > > > > > +             error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
> > > > > > +                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > > > > > +             break;
> > > > > >       default:
> > > > > >               error = -EOPNOTSUPP;
> > > > > >       }
> > > > >
> > > > > Hi Sarthak,
> > > > >
> > > > > Neat mechanism.. I played with something very similar in the past (that
> > > > > was much more crudely hacked up to target dm-thin) to allow filesystems
> > > > > to request a thinly provisioned device to allocate blocks and try to do
> > > > > a better job of avoiding inactivation when overprovisioned.
> > > > >
> > > > > One thing I'm a little curious about here.. what's the need for a new
> > > > > fallocate mode? On a cursory glance, the provision mode looks fairly
> > > > > analogous to normal (mode == 0) allocation mode with the exception of
> > > > > sending the request down to the bdev. blkdev_fallocate() already maps
> > > > > some of the logical falloc modes (i.e. punch hole, zero range) to
> > > > > sending write sames or discards, etc., and it doesn't currently look
> > > > > like it supports allocation mode, so could it not map such requests to
> > > > > the underlying REQ_OP_PROVISION op?
> > > > >
> > > > > I guess the difference would be at the filesystem level where we'd
> > > > > probably need to rely on a mount option or some such to control whether
> > > > > traditional fallocate issues provision ops (like you've implemented for
> > > > > ext4) vs. the specific falloc command, but that seems fairly consistent
> > > > > with historical punch hole/discard behavior too. Hm? You might want to
> > > > > cc linux-fsdevel in future posts in any event to get some more feedback
> > > > > on how other filesystems might want to interact with such a thing.
> > > > >
> > > > Thanks for the feedback!
> > > > Argh, I completely forgot that I should add linux-fsdevel. Let me
> > > > re-send this with linux-fsdevel cc'd
> > > >
> > > > There's a slight distinction is that the current filesystem-level
> > > > controls are usually for default handling, but userspace can still
> > > > call the relevant functions manually if they need to. For example, for
> > > > ext4, the 'discard' mount option dictates whether free blocks are
> > > > discarded, but it doesn't set the policy to allow/disallow userspace
> > > > from manually punching holes into files even if the mount opt is
> > > > 'nodiscard'. FALLOC_FL_PROVISION is similar in that regard; it adds a
> > > > manual mechanism for users to provision the files' extents, that is
> > > > separate from the filesystems' default handling of provisioning files.
> > > >
> > >
> > > What I'm trying to understand is why not let blkdev_fallocate() issue a
> > > provision based on the default mode (i.e. mode == 0) of fallocate(),
> > > which is already defined to mean "perform allocation?" It currently
> > > issues discards or write zeroes based on variants of
> > > FALLOC_FL_PUNCH_HOLE without the need for a separate FALLOC_FL_DISCARD
> > > mode, for example.
> > >
> > It's mostly to keep the block device fallocate() semantics in-line and
> > consistent with the file-specific modes: I added the separate
> > filesystem fallocate() mode under the assumption that we'd want to
> > keep the traditional handling for filesystems intact with (mode == 0).
> > And for block devices, I didn't map the requests to mode == 0 so that
> > it's less confusing to describe (eg. mode == 0 on block devices will
> > issue provision; mode == 0 on files will not). It would complicate
> > loopback devices, for instance; if the loop device is backed by a
> > file, it would need to use (mode == FALLOC_FL_PROVISION) but if the
> > loop device is backed by another block device, then the fallocate()
> > call would need to switch to (mode == 0).
> >
>
> I would expect the loopback scenario for provision to behave similar to
> how discards are handled. I.e., loopback receives a provision request
> and translates that to fallocate(mode = 0). If the backing device is
> block, blkdev_fallocate(mode = 0) translates that to another provision
> request.  If the backing device is a file, the associated fallocate
> handler allocs/maps, if necessary, and then issues a provision on
> allocation, if enabled by the fs.
>
> AFAICT there's no need for FL_PROVISION at all in that scenario. Is
> there a functional purpose to FL_PROVISION? Is the intent to try and
> guarantee that a provision request propagates down the I/O stack? If so,
> what happens if blocks were already preallocated in the backing file (in
> the loopback file example)?
>
> BTW, an unrelated thing I noticed is that blkdev_fallocate()
> unconditionally calls truncate_bdev_range(), which probably doesn't make
> sense for any sort of alloc mode.
>
Thanks for pointing that out, fixed in v2.

> > With the separate mode, we can describe the semantics of falllcate()
> > modes a bit more cleanly, and it is common for both files and block
> > devices:
> >
> > 1. mode == 0: allocation at the same layer, will not provision on the
> > underlying device/filesystem (unsupported for block devices).
> > 2. mode == FALLOC_FL_PROVISION, allocation at the layer, will
> > provision on the underlying device/filesystem.
> >
>
> I think I see why you make the distinction, since the block layer
> doesn't have a "this layer only" mode, but IMO it's also quite confusing
> to say that mode == FL_PROVISION can allocate at the current and
> underlying layer(s) but mode == 0 to that underlying layer cannot.
>
> Either way, if you want to propose a new falloc mode/modifier, it
> probably warrants a more detailed commit log with more explanation of
> the purpose, examples of behavior, perhaps some details on how the mode
> might be documented in man pages, etc.
>
That's fair. Added more details to the patch commit log in v2.

Thanks
Sarthak

> Brian
>
> > Block devices don't technically need to use a separate mode, but it
> > makes it much less confusing if filesystems are already using a
> > separate mode for provision.
> >
> > Best
> > Sarthak
> >
> > > Brian
> > >
> > > > > BTW another thing that might be useful wrt to dm-thin is to support
> > > > > FALLOC_FL_UNSHARE. I.e., it looks like the previous dm-thin patch only
> > > > > checks that blocks are allocated, but not whether those blocks are
> > > > > shared (re: lookup_result.shared). It might be useful to do the COW in
> > > > > such cases if the caller passes down a REQ_UNSHARE or some such flag.
> > > > >
> > > > That's an interesting idea! There's a few more things on the TODO list
> > > > for this patch series but I think we can follow up with a patch to
> > > > handle that as well.
> > > >
> > > > Sarthak
> > > >
> > > > > Brian
> > > > >
> > > > > > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > > > > > index f3f0b97b1675..a0e506255b20 100644
> > > > > > --- a/include/linux/falloc.h
> > > > > > +++ b/include/linux/falloc.h
> > > > > > @@ -30,7 +30,8 @@ struct space_resv {
> > > > > >                                        FALLOC_FL_COLLAPSE_RANGE |     \
> > > > > >                                        FALLOC_FL_ZERO_RANGE |         \
> > > > > >                                        FALLOC_FL_INSERT_RANGE |       \
> > > > > > -                                      FALLOC_FL_UNSHARE_RANGE)
> > > > > > +                                      FALLOC_FL_UNSHARE_RANGE |                          \
> > > > > > +                                      FALLOC_FL_PROVISION)
> > > > > >
> > > > > >  /* on ia32 l_start is on a 32-bit boundary */
> > > > > >  #if defined(CONFIG_X86_64)
> > > > > > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > > > > > index 51398fa57f6c..2d323d113eed 100644
> > > > > > --- a/include/uapi/linux/falloc.h
> > > > > > +++ b/include/uapi/linux/falloc.h
> > > > > > @@ -77,4 +77,12 @@
> > > > > >   */
> > > > > >  #define FALLOC_FL_UNSHARE_RANGE              0x40
> > > > > >
> > > > > > +/*
> > > > > > + * FALLOC_FL_PROVISION acts as a hint for thinly provisioned devices to allocate
> > > > > > + * blocks for the range/EOF.
> > > > > > + *
> > > > > > + * FALLOC_FL_PROVISION can only be used with allocate-mode fallocate.
> > > > > > + */
> > > > > > +#define FALLOC_FL_PROVISION          0x80
> > > > > > +
> > > > > >  #endif /* _UAPI_FALLOC_H_ */
> > > > > > --
> > > > > > 2.31.0
> > > > > >
> > > > >
> > > >
> > >
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

