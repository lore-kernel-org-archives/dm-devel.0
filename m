Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88528C3DA7D
	for <dm-devel@archiver.kernel.org>; Thu,  5 Jan 2023 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672904796;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wVMkaPv3t2u13vWsHSBYc69xdr2l2v3bRxb77SwaFN4=;
	b=cZKRkiajSP7DVx9hnYqnA8So0FkDmxqYrK4165RzpPk8LigmRDUtih8C6kkcDISkpxWcTW
	dLiQraM/jVdPAZBPBKhW7f0rLh3hyuncFuY3TrwgBEZdneMv0Dhdk2noXvilimo9MjD7ik
	dT+PqhicNTVKVu0Nd4yX3NlEYDT9xpw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-X-s9p9RIM0i-41100k0nrg-1; Thu, 05 Jan 2023 02:46:33 -0500
X-MC-Unique: X-s9p9RIM0i-41100k0nrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4374811E9C;
	Thu,  5 Jan 2023 07:46:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45A7340C200C;
	Thu,  5 Jan 2023 07:46:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ACA491946A6D;
	Thu,  5 Jan 2023 07:46:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E7BF1946589
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 Jan 2023 21:22:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2F5F0C15BA0; Wed,  4 Jan 2023 21:22:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D9AC15BAD
 for <dm-devel@redhat.com>; Wed,  4 Jan 2023 21:22:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CACB80D0E4
 for <dm-devel@redhat.com>; Wed,  4 Jan 2023 21:22:20 +0000 (UTC)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
 [209.85.208.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-414-mrStkpRtOIO9CivlbQcnuQ-1; Wed, 04 Jan 2023 16:22:18 -0500
X-MC-Unique: mrStkpRtOIO9CivlbQcnuQ-1
Received: by mail-ed1-f46.google.com with SMTP id j16so17854283edw.11
 for <dm-devel@redhat.com>; Wed, 04 Jan 2023 13:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=5r/V3HPXwjpuD7IphcjrrB8OiZUQp0rchrkxxQGzaWI=;
 b=unpz+D88v7kw2/t1ET414Z/LcrCK6Nc+k+7TndcBePMZEvglSzhVKwbTsm2PklmwbS
 FqWv7xz4jH32dpY7OcOzealCDKjsPjmb8Cc5HIGCz4RptgTbH0bQrMI3AmDcjlW4sTC8
 sDLP4YHGYh8vArO3qxhUwrLaaUZb3kApYsa1V8raZbiSNUc9uyUDnLPOTd6O98UUuyTU
 kEdg/Rq/aK4N/ajtpa5tALcikKifM5t1g0JznqtqGEUPimP4PtwkaBapOoBzxIaK5TqA
 9XTVZqWk2BEKRVKIFZp9EafKWvhxHkLsS4mRnB2cjoHDrv2b8xd1Mcn7G49EXAixZsib
 CCFA==
X-Gm-Message-State: AFqh2kpqN++hS56OXmytOqo6y6rnBzp0V4v56XLNsIr+UcAIoEYIcseM
 GrPVYRYTu77Nc8L8Z0dJfoMgAr/0LLNg/j7eagQLaw==
X-Google-Smtp-Source: AMrXdXvyL02g5V8vC60eMixSySeuV+cmNwoRkD+KYiZL+r9p1DmuiHRjgR21Y+li8eMYghzwdId8ULZTKPgGOnDzC2M=
X-Received: by 2002:a05:6402:f27:b0:485:8114:9779 with SMTP id
 i39-20020a0564020f2700b0048581149779mr3674496eda.41.1672867336970; Wed, 04
 Jan 2023 13:22:16 -0800 (PST)
MIME-Version: 1.0
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
 <20221229081252.452240-4-sarthakkukreti@chromium.org>
 <Y7Wr2uadI+82BB6a@magnolia>
In-Reply-To: <Y7Wr2uadI+82BB6a@magnolia>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Wed, 4 Jan 2023 13:22:06 -0800
Message-ID: <CAG9=OMNbeU=Xg5bWvHUSfzRf8vsk6csvcw5BGZeMD5Lo7dfKFQ@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 05 Jan 2023 07:46:22 +0000
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
 sarthakkukreti@google.com, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

(Resend; the text flow made the last reply unreadable)

On Wed, Jan 4, 2023 at 8:39 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Dec 29, 2022 at 12:12:48AM -0800, Sarthak Kukreti wrote:
> > FALLOC_FL_PROVISION is a new fallocate() allocation mode that
> > sends a hint to (supported) thinly provisioned block devices to
> > allocate space for the given range of sectors via REQ_OP_PROVISION.
> >
> > The man pages for both fallocate(2) and posix_fallocate(3) describe
> > the default allocation mode as:
> >
> > ```
> > The default operation (i.e., mode is zero) of fallocate()
> > allocates the disk space within the range specified by offset and len.
> > ...
> > subsequent writes to bytes in the specified range are guaranteed
> > not to fail because of lack of disk space.
> > ```
> >
> > For thinly provisioned storage constructs (dm-thin, filesystems on sparse
> > files), the term 'disk space' is overloaded and can either mean the apparent
> > disk space in the filesystem/thin logical volume or the true disk
> > space that will be utilized on the underlying non-sparse allocation layer.
> >
> > The use of a separate mode allows us to cleanly disambiguate whether fallocate()
> > causes allocation only at the current layer (default mode) or whether it propagates
> > allocations to underlying layers (provision mode)
>
> Why is it important to make this distinction?  The outcome of fallocate
> is supposed to be that subsequent writes do not fail with ENOSPC.  In my
> (fs developer) mind, REQ_OP_PROVISION simply an extra step to be taken
> after allocating file blocks.
>
Some use cases still benefit from keeping the default mode - eg.
virtual machines running on massive storage pools that don't expect to
hit the storage limit anytime soon (like most cloud storage
providers). Essentially, if the 'no ENOSPC' guarantee is maintained
via other means, then REQ_OP_PROVISION adds latency that isn't needed
(and cloud storage providers don't need to set aside that extra space
that may or may not be used).

> If you *don't* add this API flag and simply bake the REQ_OP_PROVISION
> call into mode 0 fallocate, then the new functionality can be added (or
> even backported) to existing kernels and customers can use it
> immediately.  If you *do*, then you get to wait a few years for
> developers to add it to their codebases only after enough enterprise
> distros pick up a new kernel to make it worth their while.
>
> > for thinly provisioned filesystems/
> > block devices. For devices that do not support REQ_OP_PROVISION, both these
> > allocation modes will be equivalent. Given the performance cost of sending provision
> > requests to the underlying layers, keeping the default mode as-is allows users to
> > preserve existing behavior.
>
> How expensive is this expected to be?  Is this why you wanted a separate
> mode flag?
>
Yes, the exact latency will depend on the stacked block devices and
the fragmentation at the allocation layers.

I did a quick test for benchmarking fallocate() with an:
A) ext4 filesystem mounted with 'noprovision'
B) ext4 filesystem mounted with 'provision' on a dm-thin device.
C) ext4 filesystem mounted with 'provision' on a loop device with a
sparse backing file on the filesystem in (B).

I tested file sizes from 512M to 8G, time taken for fallocate() in (A)
remains expectedly flat at ~0.01-0.02s, but for (B), it scales from
0.03-0.4s and for (C) it scales from 0.04s-0.52s (I captured the exact
time distribution in the cover letter
https://marc.info/?l=linux-ext4&m=167230113520636&w=2)

+0.5s for a 8G fallocate doesn't sound a lot but I think fragmentation
and how the block device is layered can make this worse...

> --D
>
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  block/fops.c                | 15 +++++++++++----
> >  include/linux/falloc.h      |  3 ++-
> >  include/uapi/linux/falloc.h |  8 ++++++++
> >  3 files changed, 21 insertions(+), 5 deletions(-)
> >
> > diff --git a/block/fops.c b/block/fops.c
> > index 50d245e8c913..01bde561e1e2 100644
> > --- a/block/fops.c
> > +++ b/block/fops.c
> > @@ -598,7 +598,8 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >
> >  #define      BLKDEV_FALLOC_FL_SUPPORTED                                      \
> >               (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |           \
> > -              FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
> > +              FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE |       \
> > +              FALLOC_FL_PROVISION)
> >
> >  static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> >                            loff_t len)
> > @@ -634,9 +635,11 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
> >       filemap_invalidate_lock(inode->i_mapping);
> >
> >       /* Invalidate the page cache, including dirty pages. */
> > -     error = truncate_bdev_range(bdev, file->f_mode, start, end);
> > -     if (error)
> > -             goto fail;
> > +     if (mode != FALLOC_FL_PROVISION) {
> > +             error = truncate_bdev_range(bdev, file->f_mode, start, end);
> > +             if (error)
> > +                     goto fail;
> > +     }
> >
> >       switch (mode) {
> >       case FALLOC_FL_ZERO_RANGE:
> > @@ -654,6 +657,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
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
> > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > index f3f0b97b1675..b9a40a61a59b 100644
> > --- a/include/linux/falloc.h
> > +++ b/include/linux/falloc.h
> > @@ -30,7 +30,8 @@ struct space_resv {
> >                                        FALLOC_FL_COLLAPSE_RANGE |     \
> >                                        FALLOC_FL_ZERO_RANGE |         \
> >                                        FALLOC_FL_INSERT_RANGE |       \
> > -                                      FALLOC_FL_UNSHARE_RANGE)
> > +                                      FALLOC_FL_UNSHARE_RANGE |      \
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
> > 2.37.3
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

