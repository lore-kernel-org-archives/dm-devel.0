Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E233C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 20 Feb 2023 07:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676877751;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UZArytk88BOm22TbRpWfVWEUOqj6o4LRl12CgNaMDvg=;
	b=Lzwb45fh1uIMw13MPXnlpEFQSCOJ+k/3okOwzS2PHj4kBsY4EaQTYk/YMnA92A4oFrC6JR
	q/pTd5aS33IBXSlC9FpcQzFA+qrQ2Ftwy3bzr8TTT0LA0qPa7RuxFYCdrHAdd6lKrQQbUk
	t+DQuL1UYYcu6jAdXZV+W7STQRO+Lqg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-IcvXKfJKMzqj6mlp3jJbCw-1; Mon, 20 Feb 2023 02:22:27 -0500
X-MC-Unique: IcvXKfJKMzqj6mlp3jJbCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 200A01C0432D;
	Mon, 20 Feb 2023 07:22:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 163FD1121314;
	Mon, 20 Feb 2023 07:22:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E54181946588;
	Mon, 20 Feb 2023 07:22:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 703361946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 21:50:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F484C15BAD; Fri, 17 Feb 2023 21:50:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57FF3C15BA0
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 21:50:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D7E82806043
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 21:50:33 +0000 (UTC)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com
 [209.85.221.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-250-N2g-skdSObWfYvEMmKbJkQ-1; Fri, 17 Feb 2023 16:50:31 -0500
X-MC-Unique: N2g-skdSObWfYvEMmKbJkQ-1
Received: by mail-vk1-f175.google.com with SMTP id by12so1270048vkb.3
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 13:50:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Jc7+X1cqzOxQsAFytQZ25BlL34wPn1vkCpcwaRRD9oc=;
 b=yknKm412J7jEra7lYJ28hCbMJTgyUBX8ldFXtHm1PTrkpO4AVs3HKlJVXHMaO/7o5r
 mHSdO0kLbOKpO5b+DvNegw8KySDphdGlVbQskOIvuqIE4tw628taPogFIjyoEMxOfcBZ
 Zfy3LKncq2N/Y+2a8m1rlifWP5ShPS1p+ZbOao1JU6Cl3EbLx5XoInbvBmVIA1Sh4KDC
 zqk5CV0BNorYI2uNOtPvaQP06i9E7503544k6T/TYdG/2ILXb4bPwPJ2+yBalPNwPGpn
 wKVKnuSinZ8DiIzMcUo4o7jW6HJz9B9tQvergTj3Rq0BBx961UKSu/QegZfEBBJNqxnQ
 500Q==
X-Gm-Message-State: AO0yUKV+yTgZAuBF0sKwiFIL9c+6TRhiiAguPQVBkTf8LttcQuFLpuKN
 3h7pWey2JWjUMfOB7n3K6ElEUX2EbAnnqB2QdMqfkQ==
X-Google-Smtp-Source: AK7set9XHUeLlPkt1gJ12stZFbCMRTkQQ9HrB3LYSIhi3/ZaG+e0VMAG8RtOJDpNATWJTqwo2mfMUsx0Pw5ZKygJeZ8=
X-Received: by 2002:a1f:2693:0:b0:401:6440:787e with SMTP id
 m141-20020a1f2693000000b004016440787emr122162vkm.32.1676670630833; Fri, 17
 Feb 2023 13:50:30 -0800 (PST)
MIME-Version: 1.0
References: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
 <CAPR809uYp6vGvCk4ugWOjbmd13WTm8fRg0f2Mdq3pxj6=d1McQ@mail.gmail.com>
 <a9cbed84-330f-472e-0cd7-90c6623bb5b5@nvidia.com>
In-Reply-To: <a9cbed84-330f-472e-0cd7-90c6623bb5b5@nvidia.com>
From: Enrico Granata <egranata@google.com>
Date: Fri, 17 Feb 2023 14:50:19 -0700
Message-ID: <CAPR809u0DLwHgV5w5QhWj_a53OcreZP1Qxxcom_Vbwzg0jgsog@mail.gmail.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 20 Feb 2023 07:22:21 +0000
Subject: Re: [dm-devel] Virtio-blk extended lifetime feature
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
 Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Jahdiel Alvarez <jahdiel@google.com>,
 Alvaro Karsz <alvaro.karsz@solid-run.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 virtualization <virtualization@lists.linux-foundation.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 18, 2023 at 12:46 PM Chaitanya Kulkarni
<chaitanyak@nvidia.com> wrote:
>
> On 1/17/23 14:30, Enrico Granata wrote:
> > Hi,
> > I am going to add +Jahdiel Alvarez who is also looking into a similar
> > issue, and also I would like to hear thoughts of people who may have
> > worked with (embedded or otherwise) storage more recently than I have
> >
> > One thought that Jahdiel and myself were pondering is whether we need
> > "type_a" and "type_b" fields at all, or if there should simply be a
> > "wear estimate" field, which for eMMC, it could be max(typ_a, typ_b)
> > but it could generalize to any number of cell or other algorithm, as
> > long as it produces one unique estimate of wear
> >
> > Thanks,
> > - Enrico
> >
> > Thanks,
> > - Enrico
> >
> >
> > On Sun, Jan 15, 2023 at 12:56 AM Alvaro Karsz
> > <alvaro.karsz@solid-run.com> wrote:
> >>
> >> Hi guys,
> >>
> >> While trying to upstream the implementation of VIRTIO_BLK_F_LIFETIME
> >> feature, many developers suggested that this feature should be
> >> extended to include more cell types, since its current implementation
> >> in virtio spec is relevant for MMC and UFS devices only.
> >>
> >> The VIRTIO_BLK_F_LIFETIME defines the following fields:
> >>
> >> - pre_eol_info:  the percentage of reserved blocks that are consumed.
> >> - device_lifetime_est_typ_a: wear of SLC cells.
> >> - device_lifetime_est_typ_b: wear of MLC cells.
>
> For immediate comments :-
>
> It needs to cover all the flash cell types.
>
> Using names like type_a/type_b in the spec and in the implementation
> adds unnecessary confusion and requires extra documentation in the
> code that needs to be changed.

What do you think about my proposal to have a single "wear estimate"
field and allow each flash type to calculate it as required by its own
internal logic?
The migration for eMMC and existing drivers would be to expose the
maximum of type_A, type_B wear, but other cell types would be able to
provide whatever logic they need as long as it meaningfully exposes
the "wear"

>
> >>
> >> (https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html)
> >>
> >> Following Michael's suggestion, I'd like to add to the virtio spec
> >> with a new, extended lifetime command.
> >> Since I'm more familiar with embedded type storage devices, I'd like
> >> to ask you guys what fields you think should be included in the
> >> extended command.
> >>
> >> Thanks,
> >>
> >> Alvaro
>
> -ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

