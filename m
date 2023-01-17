Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB11C32793
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 08:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674029069;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DS8Yq8RstT4j7AS/eHCRulgd4X33ilHt0wmOpbXgToE=;
	b=SshUneIuWrfZ4r4Ke9QCK2LIW8ravKRWFjaXIAtqD5oL48RYAWWVYi7eAtqZNYqQMJST0W
	rT+Ioumr44G4cDD5VpP7c8HEJ/Fc+YBuEOR0EJJNA0/Se1KFxjTDeNMn78l7MKIevCEX7q
	w6lvcDqfjvElmud0x0HlwUqNeeyKv2s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-P27Z8BubMCWEn_7-Y1n2JA-1; Wed, 18 Jan 2023 03:04:26 -0500
X-MC-Unique: P27Z8BubMCWEn_7-Y1n2JA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C9B680234E;
	Wed, 18 Jan 2023 08:04:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 970F51121318;
	Wed, 18 Jan 2023 08:04:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 980311946A74;
	Wed, 18 Jan 2023 08:04:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF15F19465B3
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 Jan 2023 22:30:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BE2C2166B26; Tue, 17 Jan 2023 22:30:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0572B2166B29
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 22:30:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBF6F8A0100
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 22:30:33 +0000 (UTC)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com
 [209.85.217.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-GakKOlFYNjGIQokpu1j86g-1; Tue, 17 Jan 2023 17:30:32 -0500
X-MC-Unique: GakKOlFYNjGIQokpu1j86g-1
Received: by mail-vs1-f43.google.com with SMTP id l125so14525761vsc.2
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 14:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ScEkSv/4ujt+FscJGahMwM/oQgqzcSsBVgCxU70QRJI=;
 b=vGYotdupNgmpBTOspfH+d96vKsB7tgRgGJ5boiM6oMTb6VrtW4d/tz2NXx3M1kMMkQ
 34TpXlyoSXBTHYw58v5Tglq1iR/MSb/E0cNUWBjCsECV3/2J+FVu5aI261MB5qrpXScH
 iCa6QSaVc24M1R72WUg33oNZrcAcww1SfvJfzYWV3k6BzJzYvHIPKbz0g6qpID9fsMQG
 ArwObhVM/1AhiL06v5A+jF8PO9NSRSh+QmurlU8xGbfs2TYTCHEtxcYcgK3mLvPQTl4Y
 BrFmh9GYXzcKaOZnIh8iJByo0V5EWHr4AP0exMounPp8rgO3BOeQyDR5l6yYw5eAJVDY
 sinw==
X-Gm-Message-State: AFqh2koBk87iFMezu9HDkH6Rb6EI2nrxRbqGZX2G4ia6Do1ICzl3dDpO
 ++GZ+y67KTXsjrI1CFvOIs4H/grrKnNEhqe7v2iy+w==
X-Google-Smtp-Source: AMrXdXsasxzFes28B36W71fU5Iue+c6SDhtfvo6j1Ld/ub9DRIvDly3xpJu8wO0cQ3K8NP967lAk53nFxEnNJD9i4tI=
X-Received: by 2002:a67:fb42:0:b0:3d0:d3fe:3d48 with SMTP id
 e2-20020a67fb42000000b003d0d3fe3d48mr557188vsr.32.1673994631663; Tue, 17 Jan
 2023 14:30:31 -0800 (PST)
MIME-Version: 1.0
References: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
In-Reply-To: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
From: Enrico Granata <egranata@google.com>
Date: Tue, 17 Jan 2023 15:30:20 -0700
Message-ID: <CAPR809uYp6vGvCk4ugWOjbmd13WTm8fRg0f2Mdq3pxj6=d1McQ@mail.gmail.com>
To: Alvaro Karsz <alvaro.karsz@solid-run.com>,
 Jahdiel Alvarez <jahdiel@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 18 Jan 2023 08:04:20 +0000
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
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, linux-nvme@lists.infradead.org,
 virtualization <virtualization@lists.linux-foundation.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,
I am going to add +Jahdiel Alvarez who is also looking into a similar
issue, and also I would like to hear thoughts of people who may have
worked with (embedded or otherwise) storage more recently than I have

One thought that Jahdiel and myself were pondering is whether we need
"type_a" and "type_b" fields at all, or if there should simply be a
"wear estimate" field, which for eMMC, it could be max(typ_a, typ_b)
but it could generalize to any number of cell or other algorithm, as
long as it produces one unique estimate of wear

Thanks,
- Enrico

Thanks,
- Enrico


On Sun, Jan 15, 2023 at 12:56 AM Alvaro Karsz
<alvaro.karsz@solid-run.com> wrote:
>
> Hi guys,
>
> While trying to upstream the implementation of VIRTIO_BLK_F_LIFETIME
> feature, many developers suggested that this feature should be
> extended to include more cell types, since its current implementation
> in virtio spec is relevant for MMC and UFS devices only.
>
> The VIRTIO_BLK_F_LIFETIME defines the following fields:
>
> - pre_eol_info:  the percentage of reserved blocks that are consumed.
> - device_lifetime_est_typ_a: wear of SLC cells.
> - device_lifetime_est_typ_b: wear of MLC cells.
>
> (https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html)
>
> Following Michael's suggestion, I'd like to add to the virtio spec
> with a new, extended lifetime command.
> Since I'm more familiar with embedded type storage devices, I'd like
> to ask you guys what fields you think should be included in the
> extended command.
>
> Thanks,
>
> Alvaro

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

