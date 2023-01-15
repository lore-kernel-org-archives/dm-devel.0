Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BE5C46467
	for <dm-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673857415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+OrL1eAgcWbV0ZZxC1pW++ROy3uetO9rfj/xGp5T9Ao=;
	b=EoBnlRjFqPQgOrEMCioG7GJw5CikGsDSsriIV1oUmjTETWR/Qvg8Z858G18jeytyDhlqxz
	2LXxdzQCTjM2vOdSwvbMsG3a0SahKZ/Sph/XF9ftdatzTOxTBGKTXjXOdqgvhMrhARgvKH
	peDXyaWajpf0SGf2owQ6YYDr8ZWrNNM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-dysApcb2NLGO17s5HEocpw-1; Mon, 16 Jan 2023 03:23:31 -0500
X-MC-Unique: dysApcb2NLGO17s5HEocpw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AED1100F903;
	Mon, 16 Jan 2023 08:23:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65BE1492B10;
	Mon, 16 Jan 2023 08:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFD3119465B1;
	Mon, 16 Jan 2023 08:23:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 221A21946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 15 Jan 2023 07:56:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 037FE492B01; Sun, 15 Jan 2023 07:56:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0764492B00
 for <dm-devel@redhat.com>; Sun, 15 Jan 2023 07:56:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5A0C3C0DDBA
 for <dm-devel@redhat.com>; Sun, 15 Jan 2023 07:56:10 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-HSg0AAqNNGaCBnjS_yKnZw-1; Sun, 15 Jan 2023 02:56:04 -0500
X-MC-Unique: HSg0AAqNNGaCBnjS_yKnZw-1
Received: by mail-pf1-f180.google.com with SMTP id a184so18930333pfa.9
 for <dm-devel@redhat.com>; Sat, 14 Jan 2023 23:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=7mPR+tYk06dWyheXQlcDvaKFF6VE45BY4pbiBRMyTf0=;
 b=vJOyA5CsWLDCyctGa0i/0dM3rlGKn/7W019HlGwBtVlHtCTxp1NvWyC4AKnCOsU8A4
 eyOw2J0OR5Pt9ZpbPQJx6pk+cwT4U0iezm1VDxr8QXk+UT6A3jKpvLP4JjGundWIVIN7
 JQvs2AIf64yoGJANDsru4Q9o9Z0Bpa0tVVj0n0mquPV+47wdA+IvVXi+xsbJLs5/MVf2
 3zZLrb8t6l3vMAdhxQttEYsE8khaLkpfCvzYzcv9MJxo0XSlE8SgPN67SbUkUJXzRZiA
 v1K/KqIk+n2amtF1EchN8Rk7zF484xlt7R5Fxgymp4oFG2tcJO7Zj1m5B227IrRdbxPa
 oAIQ==
X-Gm-Message-State: AFqh2kqZmrJBiEBbgRpPEDEd0LouAtzzv2oTynhYQm/Vf/FNbQKk/yaN
 yRBK9TnblSU3ZfOkC+bHkdQCpiJSAlDhaAuMr3013Q==
X-Google-Smtp-Source: AMrXdXvAiyCmTWvJ9EHpfBDvUbeHLHSy+j5Yk8c2u2aPfRmZEEnLTIdJUxpu9gEHkkwwhxqg/OcINr2IlsC0dkOvol4=
X-Received: by 2002:a65:45c8:0:b0:48c:5903:2f5b with SMTP id
 m8-20020a6545c8000000b0048c59032f5bmr4778556pgr.504.1673769363038; Sat, 14
 Jan 2023 23:56:03 -0800 (PST)
MIME-Version: 1.0
From: Alvaro Karsz <alvaro.karsz@solid-run.com>
Date: Sun, 15 Jan 2023 09:55:26 +0200
Message-ID: <CAJs=3_C+K0iumqYyKhphYLp=Qd7i6-Y6aDUgmYyY_rdnN1NAag@mail.gmail.com>
To: virtualization <virtualization@lists.linux-foundation.org>,
 linux-block@vger.kernel.org, 
 dm-devel@redhat.com, linux-nvme@lists.infradead.org, 
 linux-scsi@vger.kernel.org
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 16 Jan 2023 08:23:19 +0000
Subject: [dm-devel] Virtio-blk extended lifetime feature
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
Cc: Jens Axboe <axboe@kernel.dk>, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Bart Van Assche <bvanassche@acm.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Christoph Hellwig <hch@infradead.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 egranata@google.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi guys,

While trying to upstream the implementation of VIRTIO_BLK_F_LIFETIME
feature, many developers suggested that this feature should be
extended to include more cell types, since its current implementation
in virtio spec is relevant for MMC and UFS devices only.

The VIRTIO_BLK_F_LIFETIME defines the following fields:

- pre_eol_info:  the percentage of reserved blocks that are consumed.
- device_lifetime_est_typ_a: wear of SLC cells.
- device_lifetime_est_typ_b: wear of MLC cells.

(https://docs.oasis-open.org/virtio/virtio/v1.2/virtio-v1.2.html)

Following Michael's suggestion, I'd like to add to the virtio spec
with a new, extended lifetime command.
Since I'm more familiar with embedded type storage devices, I'd like
to ask you guys what fields you think should be included in the
extended command.

Thanks,

Alvaro

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

