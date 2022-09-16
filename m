Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF31C6FA8B
	for <dm-devel@archiver.kernel.org>; Mon, 19 Sep 2022 05:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663565469;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zhVt+pZzL/oBwaBIHFRpAQDwjZObafGFda/8a2FEo6Y=;
	b=PQ6dT5REh3Wik4H79Cwc0xjty+OkrOzalD8iCimYaMxZhQk8ncmJMBQu0o5QBEt37x5am/
	hFV6MANunx2VmKZeZzst9Nv/7XzkwtIYJPF88EgivR+INEtjtVJmP2xzenvYmbrjyLXsH1
	vznwl0xC2y/NFYsyIquK8uiTF3vmTpg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-GdQSHSJeNQKWXKGgZNmd3Q-1; Mon, 19 Sep 2022 01:31:06 -0400
X-MC-Unique: GdQSHSJeNQKWXKGgZNmd3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5740C8001B8;
	Mon, 19 Sep 2022 05:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED68FC15BA8;
	Mon, 19 Sep 2022 05:31:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D61BA19465B3;
	Mon, 19 Sep 2022 05:30:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 310AA1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 21:02:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E0F992084837; Fri, 16 Sep 2022 21:02:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D95E22084836
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 21:02:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B54593C10256
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 21:02:46 +0000 (UTC)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-xkvrXVrQO1mz2mgM_rwP1Q-1; Fri, 16 Sep 2022 17:02:45 -0400
X-MC-Unique: xkvrXVrQO1mz2mgM_rwP1Q-1
Received: by mail-ej1-f53.google.com with SMTP id l14so52151019eja.7
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 14:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=ILArVDBbPD4DYvc4WcNH9L/Vbo3duNMUewcYiSCb3to=;
 b=QMtiQNE3rnGbocQr/apw4+ZtANAxiwH8pooWT3ZfcqWZSpa0iKmY01m76D9TTf3oD2
 jVw7WH608847EYGrdqzcUCASaqFnrjtIcXoSGwU00PdPhuPIFrBOM6YcE+QYBugMPkOP
 Xe3vJm2E4gfhJbF4NRHcZPOxiekt1HAZCdGKZBZM2uLgdAQ5wxei9gkVd5Mh7srWu2VR
 +QL7E7SK1aT5F/LhwB2UKgNlDQhlgwIndxeDxuELkpwjVSZjNLMQP84xo1fL64I7xNfU
 6XKha5vs/eJLlNQycpi8WAeiM4uZ2MWmw2Wl0eXJa7myMOAYBLtnOFpFKahEe2rzfhsI
 FKSg==
X-Gm-Message-State: ACrzQf2ickZLYfJbvHSu6kkpAwOAtiDII82xKoKUCLCtn6EcSt4DerSY
 mNUvCORguOYqxP41M5VPk/Jse0fRvrwR8tQ6cmm16A==
X-Google-Smtp-Source: AMsMyM7yjz817X2cNCMMoIWuND6ZNvSpqS/C+VnwUrinVTEaoueq6vAfAEatlaA/XE4XwC75LT10Q4V9txuf53dmXIE=
X-Received: by 2002:a17:907:7289:b0:780:2017:3898 with SMTP id
 dt9-20020a170907728900b0078020173898mr4850266ejc.276.1663362163871; Fri, 16
 Sep 2022 14:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YyRkd8YAH1lal8/N@bfoster>
In-Reply-To: <YyRkd8YAH1lal8/N@bfoster>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Fri, 16 Sep 2022 14:02:31 -0700
Message-ID: <CAG9=OMNL1Z3DiO-usdH0k90NDsDkDQ7A7CHc4Nu6MCXKNKjWdw@mail.gmail.com>
To: Brian Foster <bfoster@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 19 Sep 2022 05:30:58 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 16, 2022 at 4:56 AM Brian Foster <bfoster@redhat.com> wrote:
>
> On Thu, Sep 15, 2022 at 09:48:22AM -0700, Sarthak Kukreti wrote:
> > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> >
> > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > sends a hint to (supported) thinly provisioned block devices to
> > allocate space for the given range of sectors via REQ_OP_PROVISION.
> >
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  block/fops.c                | 7 ++++++-
> >  include/linux/falloc.h      | 3 ++-
> >  include/uapi/linux/falloc.h | 8 ++++++++
> >  3 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/fops.c b/block/fops.c
> > index b90742595317..a436a7596508 100644
> > --- a/block/fops.c
> > +++ b/block/fops.c
> ...
> > @@ -661,6 +662,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> >               error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
> >                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> >               break;
> > +     case FALLOC_FL_PROVISION:
> > +             error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
> > +                                            len >> SECTOR_SHIFT, GFP_KERNEL);
> > +             break;
> >       default:
> >               error = -EOPNOTSUPP;
> >       }
>
> Hi Sarthak,
>
> Neat mechanism.. I played with something very similar in the past (that
> was much more crudely hacked up to target dm-thin) to allow filesystems
> to request a thinly provisioned device to allocate blocks and try to do
> a better job of avoiding inactivation when overprovisioned.
>
> One thing I'm a little curious about here.. what's the need for a new
> fallocate mode? On a cursory glance, the provision mode looks fairly
> analogous to normal (mode == 0) allocation mode with the exception of
> sending the request down to the bdev. blkdev_fallocate() already maps
> some of the logical falloc modes (i.e. punch hole, zero range) to
> sending write sames or discards, etc., and it doesn't currently look
> like it supports allocation mode, so could it not map such requests to
> the underlying REQ_OP_PROVISION op?
>
> I guess the difference would be at the filesystem level where we'd
> probably need to rely on a mount option or some such to control whether
> traditional fallocate issues provision ops (like you've implemented for
> ext4) vs. the specific falloc command, but that seems fairly consistent
> with historical punch hole/discard behavior too. Hm? You might want to
> cc linux-fsdevel in future posts in any event to get some more feedback
> on how other filesystems might want to interact with such a thing.
>
Thanks for the feedback!
Argh, I completely forgot that I should add linux-fsdevel. Let me
re-send this with linux-fsdevel cc'd

There's a slight distinction is that the current filesystem-level
controls are usually for default handling, but userspace can still
call the relevant functions manually if they need to. For example, for
ext4, the 'discard' mount option dictates whether free blocks are
discarded, but it doesn't set the policy to allow/disallow userspace
from manually punching holes into files even if the mount opt is
'nodiscard'. FALLOC_FL_PROVISION is similar in that regard; it adds a
manual mechanism for users to provision the files' extents, that is
separate from the filesystems' default handling of provisioning files.

> BTW another thing that might be useful wrt to dm-thin is to support
> FALLOC_FL_UNSHARE. I.e., it looks like the previous dm-thin patch only
> checks that blocks are allocated, but not whether those blocks are
> shared (re: lookup_result.shared). It might be useful to do the COW in
> such cases if the caller passes down a REQ_UNSHARE or some such flag.
>
That's an interesting idea! There's a few more things on the TODO list
for this patch series but I think we can follow up with a patch to
handle that as well.

Sarthak

> Brian
>
> > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > index f3f0b97b1675..a0e506255b20 100644
> > --- a/include/linux/falloc.h
> > +++ b/include/linux/falloc.h
> > @@ -30,7 +30,8 @@ struct space_resv {
> >                                        FALLOC_FL_COLLAPSE_RANGE |     \
> >                                        FALLOC_FL_ZERO_RANGE |         \
> >                                        FALLOC_FL_INSERT_RANGE |       \
> > -                                      FALLOC_FL_UNSHARE_RANGE)
> > +                                      FALLOC_FL_UNSHARE_RANGE |                          \
> > +                                      FALLOC_FL_PROVISION)
> >
> >  /* on ia32 l_start is on a 32-bit boundary */
> >  #if defined(CONFIG_X86_64)
> > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > index 51398fa57f6c..2d323d113eed 100644
> > --- a/include/uapi/linux/falloc.h
> > +++ b/include/uapi/linux/falloc.h
> > @@ -77,4 +77,12 @@
> >   */
> >  #define FALLOC_FL_UNSHARE_RANGE              0x40
> >
> > +/*
> > + * FALLOC_FL_PROVISION acts as a hint for thinly provisioned devices to allocate
> > + * blocks for the range/EOF.
> > + *
> > + * FALLOC_FL_PROVISION can only be used with allocate-mode fallocate.
> > + */
> > +#define FALLOC_FL_PROVISION          0x80
> > +
> >  #endif /* _UAPI_FALLOC_H_ */
> > --
> > 2.31.0
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

