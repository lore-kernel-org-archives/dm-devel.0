Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9A1ECAAD3
	for <dm-devel@archiver.kernel.org>; Mon, 19 Sep 2022 05:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663565469;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FtFoihiHnvixkrKGdtzhHsStSSLlyE7pnY0YTdSBn5k=;
	b=ZhiQEfvXs24E/nUl+C5khKhaCij8WdpdeZ9E4ZCVKWvui9y7559/b0gRwK6Q/F5mCjENcK
	LQj/eQBvLGPNum1xjBfK3C8hiuVeqA4pAHkiPEu1qU6LHhezRsAzYJ3g/PXIM7eX148D3r
	YRR5ylZ8L4dBBFdJwQj5sCYL7hXHOK4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-1KqTg1neOkufyfSFxxYoEA-1; Mon, 19 Sep 2022 01:31:06 -0400
X-MC-Unique: 1KqTg1neOkufyfSFxxYoEA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5516A1C09C83;
	Mon, 19 Sep 2022 05:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A549492B05;
	Mon, 19 Sep 2022 05:31:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10D3B1946A48;
	Mon, 19 Sep 2022 05:31:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 955871946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 21:59:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D956492B05; Fri, 16 Sep 2022 21:59:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 451AA492B04
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 21:59:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29ED2811E67
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 21:59:37 +0000 (UTC)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
 [209.85.208.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-eH281uz1MpGIQlxQ85ib9g-1; Fri, 16 Sep 2022 17:59:35 -0400
X-MC-Unique: eH281uz1MpGIQlxQ85ib9g-1
Received: by mail-ed1-f46.google.com with SMTP id m3so13572827eda.12
 for <dm-devel@redhat.com>; Fri, 16 Sep 2022 14:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=tXp8Qm0HOu9b4+ry3VO9lluub8ul1uWHsnihCuufP3w=;
 b=F6vXGMiQK9pyYf5etTnZy5kJeqmtSCtoFxLVcvsQ96fxGwB5Kv41Z68Ry4hVcN0wdO
 qfRlimZA6Q/mcorYHPAfHgGBtCP7Y8X//hBGMcNRJ5YO/bTerTP+Py5ugysm0SK3Gc43
 5fVQo6RVYd072xOHUDa6NR+Vl1clHyse75Nn7xD5fsBGfdvvnnPsdJTz0foB9Ie/MsNP
 LGBerofxZsxUEnCJl/gg3oS3mmcPJVWF1dsfooAOMpYvMneAsu+QsTUPFS+TjXUcEXXz
 EvjabKUVhpSgvNrxLkg3tmaOOSgP1gtyYazJTXKinkMK6c9qh4LBpzZ4/E4qsVOBHEwj
 Vc9A==
X-Gm-Message-State: ACrzQf3JmQNCdNhPcgCIk50crZufn2rZd6lZyF+xnU/NteUil8QcRSXj
 OgXq4xDjgVSGqU0V+N7VTKX9/zcLyTNk5SwXdZtHhQ==
X-Google-Smtp-Source: AMsMyM57U86vqx070tvFh9n6rb5P+QpCeQvsVAXwmkT/JivZJxEBgvPEObSHPiDtHBStbOgCq0EOZ0nQ8Xzj88PWlsQ=
X-Received: by 2002:a05:6402:161a:b0:451:ea13:572e with SMTP id
 f26-20020a056402161a00b00451ea13572emr5613477edv.41.1663365574516; Fri, 16
 Sep 2022 14:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <YyQTM5PRT2o/GDwy@fedora>
 <CAG9=OMPHZqdDhX=M+ovdg5fa3x4-Q_1r5SWPa8pMTQw0mr5fPg@mail.gmail.com>
 <0be0e378-1601-678c-247a-ba24d111b934@acm.org>
In-Reply-To: <0be0e378-1601-678c-247a-ba24d111b934@acm.org>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Fri, 16 Sep 2022 14:59:22 -0700
Message-ID: <CAG9=OMMS8gPFvGGH87bU2oBNk4WEBM5tG-z2Z5oaW4hUoKV8Jw@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 19 Sep 2022 05:30:58 +0000
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 16, 2022 at 1:01 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 9/16/22 11:48, Sarthak Kukreti wrote:
> > Yes. On ChromiumOS, we regularly deal with storage devices that don't
> > support WRITE_ZEROES or that need to have it disabled, via a quirk,
> > due to a bug in the vendor's implementation. Using WRITE_ZEROES for
> > allocation makes the allocation path quite slow for such devices (not
> > to mention the effect on storage lifetime), so having a separate
> > provisioning construct is very appealing. Even for devices that do
> > support an efficient WRITE_ZEROES implementation but don't support
> > logical provisioning per-se, I suppose that the allocation path might
> > be a bit faster (the device driver's request queue would report
> > 'max_provision_sectors'=0 and the request would be short circuited
> > there) although I haven't benchmarked the difference.
>
> Some background information about why ChromiumOS uses thin provisioning
> instead of a single filesystem across the entire storage device would be
> welcome. Although UFS devices support thin provisioning I am not aware
> of any use cases in Android that would benefit from UFS thin
> provisioning support.
>
Sure (and I'd be happy to put this in the cover letter, if you prefer;
I didn't include it initially, since it seemed orthogonal to the
discussion of the patchset)!

On ChromiumOS, the primary driving force for using thin provisioning
is to have flexible, segmented block storage, both per-user and for
applications/virtual machines with several useful properties, for
example: block-level encrypted user storage, snapshot based A-B
updates for verified content, on-demand partitioning for short-lived
use cases. Several of the other planned use-cases (like verified
content retention over powerwash) require flexible on-demand block
storage that is decoupled from the primary filesystem(s) so that we
can have cryptographic erase for the user partitions and keep the
on-demand, dm-verity backed executables intact.

Best
Sarthak

> Thanks,
>
> Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

