Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A926C6370A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g/akusooTMw/JBp7MaM/NLc31vFYjENWioqNL4tgM58=;
	b=ZIbEbPYYU5GLrsTNdkz9Y8IOWmqzoDeizu+9x6AQz1k5/PuPYgHB+54arce0LmrbWHhjsj
	Tqw6adxWvTgazaNRARG9rA3rAWqxl9uKOSBorvCtBPRIzxcX94Hi6SeAz/yVTGyIrARY01
	33Tf0qye8QlMUJFBhvgO+cuhTVI+cgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-NqZOiX9yN2yH5OAMIdkJOw-1; Wed, 07 Dec 2022 08:37:23 -0500
X-MC-Unique: NqZOiX9yN2yH5OAMIdkJOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8DD086F144;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9716A40C2064;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 462D71946A6B;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 085861946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 18:37:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E993740C6EC6; Mon,  5 Dec 2022 18:37:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1DFC40C6EC3
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 18:37:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6F72800186
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 18:37:11 +0000 (UTC)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-_N63MbWaOBeJEuDA6ynmSw-1; Mon, 05 Dec 2022 13:37:10 -0500
X-MC-Unique: _N63MbWaOBeJEuDA6ynmSw-1
Received: by mail-io1-f49.google.com with SMTP id z144so3863084iof.3
 for <dm-devel@redhat.com>; Mon, 05 Dec 2022 10:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=bKqfMwQzWVOYOX0yr/2heukDSWlHU0sCLL6O1tBRc7A=;
 b=tV7GXwy2GBCvDqmP9VcjlwLiinhC2r1MbYBur9idkeOaBW/n+fa/MiStinpRZb/WZ5
 yLkW/acmfGVc8NwAwyYFzQZV+CNYJy/lIHt5iJ640VdvBfKm8G3qIttojEDe+AvlXlMr
 0g/eS8r6qSrU43zFWZhVViSDf3Ry0R4rR+ZELRg8TSJROk2Ebz7XxA+QVSX3GQRbC7Ld
 kZ9855061pRLasVaYFVhyv4Lroz7EcgHmrkSwL57mIKtzXeGRaRFlhzIEf0XPUIE77GH
 T2fzjROwJ8ENX0hKB8Jr1ZjRB4OkceUGzLnUxeGW5XSHJDEawDu1KNfPXU2C6F1GaXks
 Ax0w==
X-Gm-Message-State: ANoB5pkbWeHS17/NiaIxyzhz+uOFcAFQ0fk6SofjP/GUct94AIg7qdid
 g1kQqhtdPUeiZsRI5crtnaq84Xv8NDyuKGl+Rksohw==
X-Google-Smtp-Source: AA0mqf7iS69oYWO13rn/6u9i2SOCARyk4OODHe8uFql4/VPC3ttbr8u6HDq0kZnXhGPO5q+l052KxdhC7ngmMQnNADM=
X-Received: by 2002:a02:6603:0:b0:375:9e02:b459 with SMTP id
 k3-20020a026603000000b003759e02b459mr38421363jac.30.1670265429512; Mon, 05
 Dec 2022 10:37:09 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
In-Reply-To: <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
From: Alvaro Karsz <alvaro.karsz@solid-run.com>
Date: Mon, 5 Dec 2022 20:36:33 +0200
Message-ID: <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
To: Jens Axboe <axboe@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

> Is this based on some spec? Because it looks pretty odd to me. There
> can be a pretty wide range of two/three/etc level cells with wildly
> different ranges of durability. And there's really not a lot of slc
> for generic devices these days, if any.

Yes, this is based on the virtio spec
https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html
section  5.2.6

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

