Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24682C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:57:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94552610A0
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 94552610A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-iA4Uu8G5MUKUJe3GRoh1Kg-1; Wed, 18 Aug 2021 03:57:00 -0400
X-MC-Unique: iA4Uu8G5MUKUJe3GRoh1Kg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79F56101C8B4;
	Wed, 18 Aug 2021 07:56:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54CA260C17;
	Wed, 18 Aug 2021 07:56:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5FAC181A0F8;
	Wed, 18 Aug 2021 07:56:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HEmYjf007725 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 10:48:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D0DF520296C4; Tue, 17 Aug 2021 14:48:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAB7F20296AC
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 14:48:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62681800883
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 14:48:31 +0000 (UTC)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
	[209.85.167.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-569-gKFCNAAvNXyzMoCaE3Ek8w-1; Tue, 17 Aug 2021 10:48:27 -0400
X-MC-Unique: gKFCNAAvNXyzMoCaE3Ek8w-1
Received: by mail-lf1-f47.google.com with SMTP id r9so32438295lfn.3;
	Tue, 17 Aug 2021 07:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=LkI5q0Ud7n3yU60UTm3c6JeteGC7wMUAGiEejPjFM0g=;
	b=afW3/Ef6yhsj6BE6dQYlZjm8OIVacCQ7++0Qih1eDPqFna99CPc4mAbrn44t0G/5Vm
	wqJ424oFDiW2p9h8F4XPECV637J5J9dF0JY83CfC2zwUxnPdDkFmxjoovmeFGAEcivEI
	Hb7Aqcac+k3xaaHE1aTSUmHEbpdRptlllFHYjQ7/prvebf/phfTdOMbv8MkXaz0QeOkD
	LwWvqBPvRhUFvihGzT+AVwMd8RkD7/If+TR8D3Vh0W9HS9X7W+F1eIULsmoVWik/0Id7
	2qqV4X2D8W6NFDgq2awIyJlxcwW5RA1ZbJ2Z/DBhZ7pm/gBTWyl4va3ML3Zp4SxOe/fk
	/ZVg==
X-Gm-Message-State: AOAM5321BTlav1Khoy+4rw/bmQ5LBEiWlFjDtXE6tp4b3Y/KUhiBxCEd
	sgFHRJEtugZQeHLEMtm+bj3zmxvJH3WVoUGrv9c=
X-Google-Smtp-Source: ABdhPJy78VibbpwFw9aY9bJD6KbF0FN0r9oY1sz4LqrxVQ5ggLWZJqClrS+h2E/ukIwkOys47vQF7tDbHI+OS3kdo5Q=
X-Received: by 2002:ac2:4573:: with SMTP id k19mr2666539lfm.459.1629211705214; 
	Tue, 17 Aug 2021 07:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101803epcas5p10cda1d52f8a8f1172e34b1f9cf8eef3b@epcas5p1.samsung.com>
	<20210817101423.12367-5-selvakuma.s1@samsung.com>
	<YRu1WFImFulfpk7s@kroah.com>
In-Reply-To: <YRu1WFImFulfpk7s@kroah.com>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Tue, 17 Aug 2021 20:18:13 +0530
Message-ID: <CAOSviJ2q-y8h=Pf4t7oUZoL7WHdYeFQQOnoeN6Ta07iPNjX-wg@mail.gmail.com>
To: Greg KH <greg@kroah.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 18 Aug 2021 03:56:53 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, hch@lst.de, agk@redhat.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	willy@infradead.org, nj.shetty@samsung.com, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, selvajove@gmail.com,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	javier.gonz@samsung.com, kbusch@kernel.org, axboe@kernel.dk,
	damien.lemoal@wdc.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-api@vger.kernel.org,
	johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
	joshiiitr@gmail.com, asml.silence@gmail.com
Subject: Re: [dm-devel] [PATCH 4/7] block: Introduce a new ioctl for simple
	copy
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 17, 2021 at 6:40 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Aug 17, 2021 at 03:44:20PM +0530, SelvaKumar S wrote:
> > From: Nitesh Shetty <nj.shetty@samsung.com>
> >
> > Add new BLKCOPY ioctl that offloads copying of one or more sources ranges
> > to a destination in the device. COPY ioctl accepts a 'copy_range'
> > structure that contains destination (in sectors), no of sources and
> > pointer to the array of source ranges. Each source range is represented by
> > 'range_entry' that contains start and length of source ranges (in sectors)
> >
> > MAX_COPY_NR_RANGE, limits the number of entries for the IOCTL and
> > MAX_COPY_TOTAL_LENGTH limits the total copy length, IOCTL can handle.
> >
> > Example code, to issue BLKCOPY:
> > /* Sample example to copy three source-ranges [0, 8] [16, 8] [32,8] to
> >  * [64,24], on the same device */
> >
> > int main(void)
> > {
> >       int ret, fd;
> >       struct range_entry source_range[] = {{.src = 0, .len = 8},
> >               {.src = 16, .len = 8}, {.src = 32, .len = 8},};
> >       struct copy_range cr;
> >
> >       cr.dest = 64;
> >       cr.nr_range = 3;
> >       cr.range_list = (__u64)&source_range;
> >
> >       fd = open("/dev/nvme0n1", O_RDWR);
> >       if (fd < 0) return 1;
> >
> >       ret = ioctl(fd, BLKCOPY, &cr);
> >       if (ret < 0) printf("copy failure\n");
> >
> >       close(fd);
> >
> >       return ret;
> > }
> >
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > ---
> >  block/ioctl.c           | 33 +++++++++++++++++++++++++++++++++
> >  include/uapi/linux/fs.h |  8 ++++++++
> >  2 files changed, 41 insertions(+)
> >
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index eb0491e90b9a..2af56d01e9fe 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -143,6 +143,37 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
> >                                   GFP_KERNEL, flags);
> >  }
> >
> > +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> > +             unsigned long arg)
> > +{
> > +     struct copy_range crange;
> > +     struct range_entry *rlist;
> > +     int ret;
> > +
> > +     if (!(mode & FMODE_WRITE))
> > +             return -EBADF;
> > +
> > +     if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
> > +             return -EFAULT;
> > +
> > +     rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
> > +                     GFP_KERNEL);
>
> No error checking for huge values of nr_range?  Is that wise?  You
> really want userspace to be able to allocate "all" of the kernel memory
> in the system?
>
> thanks,
>
> greg k-h

We added a kernel imposed limit MAX_COPY_NR_RANGE for that purpose,
but missed adding the check here.
Will have that fixed. Thanks for pointing this out.

Nitesh Shetty

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

