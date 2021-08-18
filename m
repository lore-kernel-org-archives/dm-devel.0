Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10256C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 16:18:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 797B060231
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 16:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 797B060231
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ngg7NhJ2NOOzD5TPIOMaOg-1; Wed, 18 Aug 2021 12:18:06 -0400
X-MC-Unique: ngg7NhJ2NOOzD5TPIOMaOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C2D21082925;
	Wed, 18 Aug 2021 16:18:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 651595DAA5;
	Wed, 18 Aug 2021 16:18:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F39DF4BB7C;
	Wed, 18 Aug 2021 16:18:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17IGHwOJ020444 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 12:17:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D016A2077FDF; Wed, 18 Aug 2021 16:17:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA6E2204471A
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 16:17:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B36218A01A0
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 16:17:56 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-485-HdORhql6Oc6dOW-0J34rVw-1;
	Wed, 18 Aug 2021 12:17:52 -0400
X-MC-Unique: HdORhql6Oc6dOW-0J34rVw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EDA6610A5;
	Wed, 18 Aug 2021 16:17:50 +0000 (UTC)
Date: Wed, 18 Aug 2021 09:17:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Nitesh Shetty <nitheshshetty@gmail.com>
Message-ID: <20210818161750.GF12664@magnolia>
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101803epcas5p10cda1d52f8a8f1172e34b1f9cf8eef3b@epcas5p1.samsung.com>
	<20210817101423.12367-5-selvakuma.s1@samsung.com>
	<20210817233613.GA12597@magnolia>
	<CAOSviJ2+deUdDXTWbWXaSxNX2t6cnhPg7KCDA4C2qm74KD9vdQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOSviJ2+deUdDXTWbWXaSxNX2t6cnhPg7KCDA4C2qm74KD9vdQ@mail.gmail.com>
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
Cc: snitzer@redhat.com, linux-nvme@lists.infradead.org, dm-devel@redhat.com,
	hch@lst.de, agk@redhat.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 18, 2021 at 09:07:54PM +0530, Nitesh Shetty wrote:
> On Wed, Aug 18, 2021 at 5:06 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Aug 17, 2021 at 03:44:20PM +0530, SelvaKumar S wrote:
> > > From: Nitesh Shetty <nj.shetty@samsung.com>
> > >
> > > Add new BLKCOPY ioctl that offloads copying of one or more sources ranges
> > > to a destination in the device. COPY ioctl accepts a 'copy_range'
> > > structure that contains destination (in sectors), no of sources and
> > > pointer to the array of source ranges. Each source range is represented by
> > > 'range_entry' that contains start and length of source ranges (in sectors)
> > >
> > > MAX_COPY_NR_RANGE, limits the number of entries for the IOCTL and
> > > MAX_COPY_TOTAL_LENGTH limits the total copy length, IOCTL can handle.
> > >
> > > Example code, to issue BLKCOPY:
> > > /* Sample example to copy three source-ranges [0, 8] [16, 8] [32,8] to
> > >  * [64,24], on the same device */
> > >
> > > int main(void)
> > > {
> > >       int ret, fd;
> > >       struct range_entry source_range[] = {{.src = 0, .len = 8},
> > >               {.src = 16, .len = 8}, {.src = 32, .len = 8},};
> > >       struct copy_range cr;
> > >
> > >       cr.dest = 64;
> > >       cr.nr_range = 3;
> > >       cr.range_list = (__u64)&source_range;
> > >
> > >       fd = open("/dev/nvme0n1", O_RDWR);
> > >       if (fd < 0) return 1;
> > >
> > >       ret = ioctl(fd, BLKCOPY, &cr);
> > >       if (ret < 0) printf("copy failure\n");
> > >
> > >       close(fd);
> > >
> > >       return ret;
> > > }
> > >
> > > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > > ---
> > >  block/ioctl.c           | 33 +++++++++++++++++++++++++++++++++
> > >  include/uapi/linux/fs.h |  8 ++++++++
> > >  2 files changed, 41 insertions(+)
> > >
> > > diff --git a/block/ioctl.c b/block/ioctl.c
> > > index eb0491e90b9a..2af56d01e9fe 100644
> > > --- a/block/ioctl.c
> > > +++ b/block/ioctl.c
> > > @@ -143,6 +143,37 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
> > >                                   GFP_KERNEL, flags);
> > >  }
> > >
> > > +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> > > +             unsigned long arg)
> > > +{
> > > +     struct copy_range crange;
> > > +     struct range_entry *rlist;
> > > +     int ret;
> > > +
> > > +     if (!(mode & FMODE_WRITE))
> > > +             return -EBADF;
> > > +
> > > +     if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
> > > +             return -EFAULT;
> > > +
> > > +     rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
> > > +                     GFP_KERNEL);
> > > +     if (!rlist)
> > > +             return -ENOMEM;
> > > +
> > > +     if (copy_from_user(rlist, (void __user *)crange.range_list,
> > > +                             sizeof(*rlist) * crange.nr_range)) {
> > > +             ret = -EFAULT;
> > > +             goto out;
> > > +     }
> > > +
> > > +     ret = blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, crange.dest,
> > > +                     GFP_KERNEL, 0);
> > > +out:
> > > +     kfree(rlist);
> > > +     return ret;
> > > +}
> > > +
> > >  static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
> > >               unsigned long arg)
> > >  {
> > > @@ -468,6 +499,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
> > >       case BLKSECDISCARD:
> > >               return blk_ioctl_discard(bdev, mode, arg,
> > >                               BLKDEV_DISCARD_SECURE);
> > > +     case BLKCOPY:
> > > +             return blk_ioctl_copy(bdev, mode, arg);
> > >       case BLKZEROOUT:
> > >               return blk_ioctl_zeroout(bdev, mode, arg);
> > >       case BLKGETDISKSEQ:
> > > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > > index 7a97b588d892..4183688ff398 100644
> > > --- a/include/uapi/linux/fs.h
> > > +++ b/include/uapi/linux/fs.h
> > > @@ -76,6 +76,13 @@ struct range_entry {
> > >       __u64 len;
> > >  };
> > >
> > > +struct copy_range {
> > > +     __u64 dest;
> > > +     __u64 nr_range;
> >
> > If the maximum number of elements in the range list is 1<<12, there's no
> > need for this to be larger than a u16, right?
> >
> > > +     __u64 range_list;
> >
> > Pointers embedded in a structure are /not/ a good idea, because this
> > will create a lot of compatibility headaches for 32-bit binaries running
> > on 64-bit kernels.  Please just make the size of this header structure
> > a multiple of 8 bytes and put the range_entry list immediately after it.
> >
> > struct copy_range {
> >         __s64 dest_offset;
> >         __u32 nr_range_entries;
> >         __u32 flags;
> >         __u64 reserved[2];
> > };
> >
> > struct __user range_entry *re = ((struct range_entry *)(copyhead + 1));
> >
> > copy_from_user(&urk, re...);
> >
> > --D
> >
> Thanks, this is better. 'Reserved' field was there to be used for
> future extension of the interface.
> Now that you mentioned 'flags', it seems we can do away with
> 'reserved' fields altogether?

We still want the reserved-must-be-zero fields so that adding the first
field or two doesn't require changes to the pointer arithmetic.

Also, I suppose you could make the relationship between copy_range and
range_entry more explicit:

struct copy_range {
        __s64 dest_offset;
        __u32 nr_range_entries;
        __u32 flags;
        __u64 reserved[2];

	/* must come last */
	struct range_entry entries[];
};

struct __user range_entry *re = &copyhead->entries[0];

--D

> 
> Regards,
> Nitesh Shetty

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

