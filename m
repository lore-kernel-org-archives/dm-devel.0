Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24314ECAAD8
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 05:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663651083;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LOl3URLh8CrVfJTleDr5VY5bXhBsZ6s+++mOheDoLD0=;
	b=hTIuwLPd6NXXMkmKAxqYW7IEMo/MZs7neUDcBBTpm9amHQLuRjDCpDXDaXyRO5iMyZdG9m
	D5i+gQQgq/+mU/Rm9WXwap6JjZCteenI8ubkH/uhcjuQJ09zGPsNvfnPEYrzpdpBFwTUO8
	09uKUrOhFJK77oTUAl919RWRakvRLiM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-MIaMamSbMduoXDNCe1Y-Ag-1; Tue, 20 Sep 2022 01:18:00 -0400
X-MC-Unique: MIaMamSbMduoXDNCe1Y-Ag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C11A2185A7A9;
	Tue, 20 Sep 2022 05:17:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A77B91121314;
	Tue, 20 Sep 2022 05:17:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6457619465A3;
	Tue, 20 Sep 2022 05:17:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 99FAE19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 02:33:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7A89A18ECC; Tue, 20 Sep 2022 02:33:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 725CF17583
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 02:33:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5364029ABA2F
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 02:33:54 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-TAsIVfUEMGOy_fAcoRSRZw-1; Mon, 19 Sep 2022 22:33:50 -0400
X-MC-Unique: TAsIVfUEMGOy_fAcoRSRZw-1
Received: by mail-ej1-f54.google.com with SMTP id y17so2911224ejo.6
 for <dm-devel@redhat.com>; Mon, 19 Sep 2022 19:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=4WdgOQEnTGB5AD0/3SYqzq4oO226bgoIvmn6I1vr/DE=;
 b=aWHTMs3WYorbZTX3jPWUdVstGlhc75rGTTB6RsqRnryyQovoV7uJO6D0OJ6v6bOyl8
 kZckq8j+pBnpAs8bjfuhw4RyUhwPCtqLJbH6AhkED94+JzVIv9tPWARG7xHKAzVyVxfQ
 o2zvPgj+VwT5Kc0qiKFCR//NpQWQ/IJIlPEtMAbL8yQfU/qOfSBrLsqHLJOHc5BXCVdh
 dZCRWJAdTtPMoGEUZ2gE0A8SOzwIEIbBhaeK3N6rJqNwx/YMUymKV3UPp9jYedpg8402
 CGLGCwi9hjq2M8Jyrg34pXdO49vai/FTbK/I6Y4OuxUm7GVtibtjUMoaLkiB46TIC/pn
 JKYg==
X-Gm-Message-State: ACrzQf1E9wJ77nrZ9IqPzhQq5YhVCHCFq8XYgmeLMa4blh0xhOpMhOjl
 lOd7TgGN41eqdrrP6b3OcVxj4rrzbVa08guEJUrYs32OGfZ7Vg==
X-Google-Smtp-Source: AMsMyM6oA07pBoPv0NiRcgoDeKipAqKueA2dka5/YzaH22PcO7CPkT4imFruPehqxaOY1hLqLkVMvRcG/EQO9P7eK/0=
X-Received: by 2002:a17:906:9746:b0:781:913d:6cc7 with SMTP id
 o6-20020a170906974600b00781913d6cc7mr3007772ejy.386.1663641229240; Mon, 19
 Sep 2022 19:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-4-sarthakkukreti@google.com> <YyQOFTI4CWn041UM@fedora>
In-Reply-To: <YyQOFTI4CWn041UM@fedora>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Mon, 19 Sep 2022 19:33:37 -0700
Message-ID: <CAG9=OMM4uQiJuu+ChUq-hoiyKMrBOECgz=+xw+=LmcPt2FVwOQ@mail.gmail.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 20 Sep 2022 05:17:55 +0000
Subject: Re: [dm-devel] [PATCH RFC 3/8] virtio_blk: Add support for
 provision requests
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
 Daniil Lunev <dlunev@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 15, 2022 at 10:48 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Sep 15, 2022 at 09:48:21AM -0700, Sarthak Kukreti wrote:
> > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> >
> > Adds support for provision requests. Provision requests act like
> > the inverse of discards.
> >
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  drivers/block/virtio_blk.c      | 48 +++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_blk.h |  9 +++++++
> >  2 files changed, 57 insertions(+)
>
> Please send a VIRTIO spec patch too:
> https://github.com/oasis-tcs/virtio-spec#providing-feedback
>
Thanks for the suggestion! Ref:
https://lists.oasis-open.org/archives/virtio-comment/202209/msg00025.html

The patch needs to be amended a bit to account for the diff. in the
spec and the original patch. Will update in the next patch iteration.

Best
Sarthak

> Stefan
>
> >
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 30255fcaf181..eacc2bffe1d1 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -178,6 +178,39 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
> >       return 0;
> >  }
> >
> > +static int virtblk_setup_provision(struct request *req)
> > +{
> > +     unsigned short segments = blk_rq_nr_discard_segments(req);
> > +     unsigned short n = 0;
> > +
> > +     struct virtio_blk_discard_write_zeroes *range;
> > +     struct bio *bio;
> > +     u32 flags = 0;
> > +
> > +     range = kmalloc_array(segments, sizeof(*range), GFP_ATOMIC);
> > +     if (!range)
> > +             return -ENOMEM;
> > +
> > +     __rq_for_each_bio(bio, req) {
> > +             u64 sector = bio->bi_iter.bi_sector;
> > +             u32 num_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> > +
> > +             range[n].flags = cpu_to_le32(flags);
> > +             range[n].num_sectors = cpu_to_le32(num_sectors);
> > +             range[n].sector = cpu_to_le64(sector);
> > +             n++;
> > +     }
> > +
> > +     WARN_ON_ONCE(n != segments);
> > +
> > +     req->special_vec.bv_page = virt_to_page(range);
> > +     req->special_vec.bv_offset = offset_in_page(range);
> > +     req->special_vec.bv_len = sizeof(*range) * segments;
> > +     req->rq_flags |= RQF_SPECIAL_PAYLOAD;
> > +
> > +     return 0;
> > +}
> > +
> >  static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
> >  {
> >       if (blk_rq_nr_phys_segments(req))
> > @@ -243,6 +276,9 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
> >       case REQ_OP_DRV_IN:
> >               type = VIRTIO_BLK_T_GET_ID;
> >               break;
> > +     case REQ_OP_PROVISION:
> > +             type = VIRTIO_BLK_T_PROVISION;
> > +             break;
> >       default:
> >               WARN_ON_ONCE(1);
> >               return BLK_STS_IOERR;
> > @@ -256,6 +292,11 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
> >                       return BLK_STS_RESOURCE;
> >       }
> >
> > +     if (type == VIRTIO_BLK_T_PROVISION) {
> > +             if (virtblk_setup_provision(req))
> > +                     return BLK_STS_RESOURCE;
> > +     }
> > +
> >       return 0;
> >  }
> >
> > @@ -1075,6 +1116,12 @@ static int virtblk_probe(struct virtio_device *vdev)
> >               blk_queue_max_write_zeroes_sectors(q, v ? v : UINT_MAX);
> >       }
> >
> > +     if (virtio_has_feature(vdev, VIRTIO_BLK_F_PROVISION)) {
> > +             virtio_cread(vdev, struct virtio_blk_config,
> > +                          max_provision_sectors, &v);
> > +             q->limits.max_provision_sectors = v ? v : UINT_MAX;
> > +     }
> > +
> >       virtblk_update_capacity(vblk, false);
> >       virtio_device_ready(vdev);
> >
> > @@ -1177,6 +1224,7 @@ static unsigned int features[] = {
> >       VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> >       VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
> >       VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
> > +     VIRTIO_BLK_F_PROVISION,
> >  };
> >
> >  static struct virtio_driver virtio_blk = {
> > diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
> > index d888f013d9ff..184f8cf6d185 100644
> > --- a/include/uapi/linux/virtio_blk.h
> > +++ b/include/uapi/linux/virtio_blk.h
> > @@ -40,6 +40,7 @@
> >  #define VIRTIO_BLK_F_MQ              12      /* support more than one vq */
> >  #define VIRTIO_BLK_F_DISCARD 13      /* DISCARD is supported */
> >  #define VIRTIO_BLK_F_WRITE_ZEROES    14      /* WRITE ZEROES is supported */
> > +#define VIRTIO_BLK_F_PROVISION       15      /* provision is supported */
> >
> >  /* Legacy feature bits */
> >  #ifndef VIRTIO_BLK_NO_LEGACY
> > @@ -120,6 +121,11 @@ struct virtio_blk_config {
> >        */
> >       __u8 write_zeroes_may_unmap;
> >
> > +     /*
> > +      * The maximum number of sectors in a provision request.
> > +      */
> > +     __virtio32 max_provision_sectors;
> > +
> >       __u8 unused1[3];
> >  } __attribute__((packed));
> >
> > @@ -155,6 +161,9 @@ struct virtio_blk_config {
> >  /* Write zeroes command */
> >  #define VIRTIO_BLK_T_WRITE_ZEROES    13
> >
> > +/* Provision command */
> > +#define VIRTIO_BLK_T_PROVISION       14
> > +
> >  #ifndef VIRTIO_BLK_NO_LEGACY
> >  /* Barrier before this op. */
> >  #define VIRTIO_BLK_T_BARRIER 0x80000000
> > --
> > 2.31.0
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

