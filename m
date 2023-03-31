Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD31C77B62
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 05:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680240172;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=osigUgUZ7smSnr3AkMBK7EUupeTtcOA86t8hFhiYsOk=;
	b=QlSR8txsFS9qacEIO5X9gCuE2pj1N/DqGWaN5KtvmtlzMxxyHGjgd9n/3X8DAtLEbC55ee
	jxDe5AgKYirwxs2uPT8PWk3sCqVSwE57SJuLufLg1DuJh2kLvZrm17dNcepZHvQPNpLXuw
	bIYXWATM6DWKG4bbgRbhhZmmxOWihdI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-oX5vSSmnNzKsMz0H3RugcA-1; Fri, 31 Mar 2023 01:22:48 -0400
X-MC-Unique: oX5vSSmnNzKsMz0H3RugcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5BF6887411;
	Fri, 31 Mar 2023 05:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE14404DC5C;
	Fri, 31 Mar 2023 05:22:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F6361946A63;
	Fri, 31 Mar 2023 05:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 672C41946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 00:28:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DC0814171BC; Fri, 31 Mar 2023 00:28:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25CC11402C07
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 00:28:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 063FD85A5B1
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 00:28:39 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-cQozVlLlNCyVmBTmreutFQ-1; Thu, 30 Mar 2023 20:28:37 -0400
X-MC-Unique: cQozVlLlNCyVmBTmreutFQ-1
Received: by mail-ed1-f54.google.com with SMTP id w9so83476172edc.3
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 17:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680222516;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=w7dl68YTP8S4RiqY+x5/O4+CnLGy3Xe6lC7eIC5NDDg=;
 b=nXuD+8m2+WTxtRoFBLgbC+Y4FfU6H/B3GIU9uASEH7nsmsrerykshJY//g99ujBxX7
 cKksggo9ZQf5ss6TN9KaHSrA9xt45D/pHsrkm/kxkKfQvGNJJJ2Zo2bKgL5bq3uzpo0V
 rPnyaDguFwnZpo55P2+uGwzRAislGt7THIO3gdOIhMoecUUt9Y62v1vEZzRO1CHsQE95
 2l1Ywro34POxpVppElIWIDrHj7ObVSTQezSy6PFxVr3LSDRh2GWI97KbEXb6v/fGJ4P5
 0mK+tkUrgX1POp94rjksbDwxgyM5R1N3y0Sk8wQqzqJuv+9JIQvgJLhTItfa1gm9yBxx
 FcEg==
X-Gm-Message-State: AAQBX9ex8FN/AxbDHdpTczVkBzBdgiGxfVYWy+Ly9ea5kdHiarYSbGOR
 7+oHIlae/QAVe1WULfl9ivpANVqh5KAGz36bt+PEpg==
X-Google-Smtp-Source: AKy350ZIZZwE4fLa4HZv1js37+8o+PrWKNL6H2rNaVFNqrxiQJtozdJH9Zs/S2MKN7ANFXMBy3cE+ohRFiJy6VmDOrg=
X-Received: by 2002:a17:907:a0cd:b0:947:4b15:51e5 with SMTP id
 hw13-20020a170907a0cd00b009474b1551e5mr2382830ejc.2.1680222515827; Thu, 30
 Mar 2023 17:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
 <20221229081252.452240-4-sarthakkukreti@chromium.org>
 <Y7Wr2uadI+82BB6a@magnolia>
 <CAG9=OMNbeU=Xg5bWvHUSfzRf8vsk6csvcw5BGZeMD5Lo7dfKFQ@mail.gmail.com>
 <Y7biricgMfXxcQBU@bfoster>
In-Reply-To: <Y7biricgMfXxcQBU@bfoster>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 30 Mar 2023 17:28:25 -0700
Message-ID: <CAG9=OMNZYnd=LZSiThL9JDFHBvqSwFQLni2=+VgXdrbx7L1fJA@mail.gmail.com>
To: Brian Foster <bfoster@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Fri, 31 Mar 2023 05:22:41 +0000
Subject: Re: [dm-devel] [PATCH v2 3/7] fs: Introduce FALLOC_FL_PROVISION
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 sarthakkukreti@google.com, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 5, 2023 at 6:45 AM Brian Foster <bfoster@redhat.com> wrote:
>
> On Wed, Jan 04, 2023 at 01:22:06PM -0800, Sarthak Kukreti wrote:
> > (Resend; the text flow made the last reply unreadable)
> >
> > On Wed, Jan 4, 2023 at 8:39 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Thu, Dec 29, 2022 at 12:12:48AM -0800, Sarthak Kukreti wrote:
> > > > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > > > sends a hint to (supported) thinly provisioned block devices to
> > > > allocate space for the given range of sectors via REQ_OP_PROVISION.
> > > >
> > > > The man pages for both fallocate(2) and posix_fallocate(3) describe
> > > > the default allocation mode as:
> > > >
> > > > ```
> > > > The default operation (i.e., mode is zero) of fallocate()
> > > > allocates the disk space within the range specified by offset and len.
> > > > ...
> > > > subsequent writes to bytes in the specified range are guaranteed
> > > > not to fail because of lack of disk space.
> > > > ```
> > > >
> > > > For thinly provisioned storage constructs (dm-thin, filesystems on sparse
> > > > files), the term 'disk space' is overloaded and can either mean the apparent
> > > > disk space in the filesystem/thin logical volume or the true disk
> > > > space that will be utilized on the underlying non-sparse allocation layer.
> > > >
> > > > The use of a separate mode allows us to cleanly disambiguate whether fallocate()
> > > > causes allocation only at the current layer (default mode) or whether it propagates
> > > > allocations to underlying layers (provision mode)
> > >
> > > Why is it important to make this distinction?  The outcome of fallocate
> > > is supposed to be that subsequent writes do not fail with ENOSPC.  In my
> > > (fs developer) mind, REQ_OP_PROVISION simply an extra step to be taken
> > > after allocating file blocks.
> > >
> > Some use cases still benefit from keeping the default mode - eg.
> > virtual machines running on massive storage pools that don't expect to
> > hit the storage limit anytime soon (like most cloud storage
> > providers). Essentially, if the 'no ENOSPC' guarantee is maintained
> > via other means, then REQ_OP_PROVISION adds latency that isn't needed
> > (and cloud storage providers don't need to set aside that extra space
> > that may or may not be used).
> >
>
> What's the granularity that needs to be managed at? Do you really need
> an fallocate command for this, or would one of the filesystem level
> features you've already implemented for ext4 suffice?
>
I think I (belatedly) see the point now; the other mechanisms provide
enough flexibility that make a separate FALLOC_FL_PROVISION redundant
and confusing. I'll post the next series without the falloc() flag.

> I mostly agree with Darrick in that FALLOC_FL_PROVISION stills feels a
> bit wonky to me. I can see that there might be some legitimate use cases
> for it, but I'm not convinced that it won't just end up being confusing
> to many users. At the same time, I think the approach of unconditional
> provision on falloc could eventually lead to complaints associated with
> the performance impact or similar sorts of confusion. For example,
> should an falloc of an already allocated range in the fs send a
> provision or not?
>
It boils down to whether a) the underlying device supports
provisioning and b) whether the device is a snapshot. If either is
true, then we'd need to pass down provision requests down to the last
layers of the stack. Filesystems might be able to amortize some of the
performance drop if they maintain a bit that tracks whether the extent
has been provisioned/written to; for such extents, we'd only send a
provision request iff the underlying device is a snapshot device. Or
we could make this a policy that's configurable by a mount option
(added details below).

In the current patch series, I went through the simpler route of just
calling REQ_OP_PROVISION on the first fallocate() call. But as
everyone pointed out on the thread, that doesn't work out as well for
previously allocated ranges..

> [Reflowed] Should filesystems that don't otherwise support
> UNSHARE_RANGE need to support it in order to support an unshare request
> to COW'd blocks on an underlying block device?
>
I think it would make sense to keep the UNSHARE_RANGE handling intact
and delegate the actual provisioning to the filesystem layer. Even if
the filesystem doesn't support unsharing, we could add a separate
mount mode option that will result in the filesystem sending
REQ_OP_PROVISION to the entire file range if fallocate mode==0 is
called.

> I wonder if the smart thing to do here is separate out the question of a
> new fallocate interface from the mechanism entirely. For example,
> implement REQ_OP_PROVISION as you've already done, enable block layer
> mode = 0 fallocate support (i.e. without FL_PROVISION, so whether a
> request propagates from a loop device will be up to the backing fs),
> implement the various fs features to support REQ_OP_PROVISION (i.e.,
> mount option, file attr, etc.), then tack on FL_FALLOC + ext4 support at
> the end as an RFC/prototype.
>
> Even if we ultimately ended up with FL_PROVISION support, it might
> actually make some sense to kick that can down the road a bit regardless
> to give fs' a chance to implement basic REQ_OP_PROVISION support, get a
> better understanding of how it works in practice, and then perhaps make
> more informed decisions on things like sane defaults and/or how best to
> expose it via fallocate. Thoughts?
>
That's fair (and thanks for the thorough feedback!), I'll split the
series and send out the REQ_OP_PROVISION parts shortly. As you,
Darrick and Ted have pointed out, the filesystem patches need a bit
more work.

Best
Sarthak



> Brian
>
> > > If you *don't* add this API flag and simply bake the REQ_OP_PROVISION
> > > call into mode 0 fallocate, then the new functionality can be added (or
> > > even backported) to existing kernels and customers can use it
> > > immediately.  If you *do*, then you get to wait a few years for
> > > developers to add it to their codebases only after enough enterprise
> > > distros pick up a new kernel to make it worth their while.
> > >
> > > > for thinly provisioned filesystems/
> > > > block devices. For devices that do not support REQ_OP_PROVISION, both these
> > > > allocation modes will be equivalent. Given the performance cost of sending provision
> > > > requests to the underlying layers, keeping the default mode as-is allows users to
> > > > preserve existing behavior.
> > >
> > > How expensive is this expected to be?  Is this why you wanted a separate
> > > mode flag?
> > >
> > Yes, the exact latency will depend on the stacked block devices and
> > the fragmentation at the allocation layers.
> >
> > I did a quick test for benchmarking fallocate() with an:
> > A) ext4 filesystem mounted with 'noprovision'
> > B) ext4 filesystem mounted with 'provision' on a dm-thin device.
> > C) ext4 filesystem mounted with 'provision' on a loop device with a
> > sparse backing file on the filesystem in (B).
> >
> > I tested file sizes from 512M to 8G, time taken for fallocate() in (A)
> > remains expectedly flat at ~0.01-0.02s, but for (B), it scales from
> > 0.03-0.4s and for (C) it scales from 0.04s-0.52s (I captured the exact
> > time distribution in the cover letter
> > https://marc.info/?l=linux-ext4&m=167230113520636&w=2)
> >
> > +0.5s for a 8G fallocate doesn't sound a lot but I think fragmentation
> > and how the block device is layered can make this worse...
> >
> > > --D
> > >
> > > > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > > ---
> > > >  block/fops.c                | 15 +++++++++++----
> > > >  include/linux/falloc.h      |  3 ++-
> > > >  include/uapi/linux/falloc.h |  8 ++++++++
> > > >  3 files changed, 21 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/block/fops.c b/block/fops.c
> > > > index 50d245e8c913..01bde561e1e2 100644
> > > > --- a/block/fops.c
> > > > +++ b/block/fops.c
> > > > @@ -598,7 +598,8 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > > >
> > > >  #define      BLKDEV_FALLOC_FL_SUPPORTED                                      \
> > > >               (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |           \
> > > > -              FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
> > > > +              FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE |       \
> > > > +              FALLOC_FL_PROVISION)
> > > >
> > > >  static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> > > >                            loff_t len)
> > > > @@ -634,9 +635,11 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> > > >       filemap_invalidate_lock(inode->i_mapping);
> > > >
> > > >       /* Invalidate the page cache, including dirty pages. */
> > > > -     error = truncate_bdev_range(bdev, file->f_mode, start, end);
> > > > -     if (error)
> > > > -             goto fail;
> > > > +     if (mode != FALLOC_FL_PROVISION) {
> > > > +             error = truncate_bdev_range(bdev, file->f_mode, start, end);
> > > > +             if (error)
> > > > +                     goto fail;
> > > > +     }
> > > >
> > > >       switch (mode) {
> > > >       case FALLOC_FL_ZERO_RANGE:
> > > > @@ -654,6 +657,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
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
> > > > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > > > index f3f0b97b1675..b9a40a61a59b 100644
> > > > --- a/include/linux/falloc.h
> > > > +++ b/include/linux/falloc.h
> > > > @@ -30,7 +30,8 @@ struct space_resv {
> > > >                                        FALLOC_FL_COLLAPSE_RANGE |     \
> > > >                                        FALLOC_FL_ZERO_RANGE |         \
> > > >                                        FALLOC_FL_INSERT_RANGE |       \
> > > > -                                      FALLOC_FL_UNSHARE_RANGE)
> > > > +                                      FALLOC_FL_UNSHARE_RANGE |      \
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
> > > > 2.37.3
> > > >
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

