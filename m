Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE30C636CD
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 22:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675810486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MlP6aMbZqEeujl4uEbjyUi3YLkkTO/vKMvwu5xisibc=;
	b=RLJYtwBN/Mdw6uN4/7XpQBiag84lpLx04LBHtVibrHlkV6xKHmxnzKYGybmQ+IrXjcqzKN
	dAZTnkd95DV8Q2pwspexeL0+dLPXJl4spjN7P0Xh1/3vVsEG7ofaTYC4RVTjxX7sh1cT7f
	dXj4t7a3MKk85mLdRZ/Re2ouJrIhX68=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-JCKMZeLLNUO-5g7gZ9kh3w-1; Tue, 07 Feb 2023 17:54:43 -0500
X-MC-Unique: JCKMZeLLNUO-5g7gZ9kh3w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C997C1C270A5;
	Tue,  7 Feb 2023 22:54:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CF7A492B21;
	Tue,  7 Feb 2023 22:54:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48EE4194658D;
	Tue,  7 Feb 2023 22:54:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C04131946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 22:54:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E364C15BAD; Tue,  7 Feb 2023 22:54:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 971B0C15BA0
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 22:54:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7989918A6461
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 22:54:35 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-AkAciy-oPFyrX4ArW3qedQ-1; Tue, 07 Feb 2023 17:54:34 -0500
X-MC-Unique: AkAciy-oPFyrX4ArW3qedQ-1
Received: by mail-wm1-f50.google.com with SMTP id bg26so12131140wmb.0
 for <dm-devel@redhat.com>; Tue, 07 Feb 2023 14:54:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=/GpMHLadhKBQ6+m2UPO236KZ/4fJUKcv4tl+ZjXMWOg=;
 b=AQE0Ta6yqgiu6ALx3LmXYwgF6fpqhYnLjuDtWBEXoRHaJEuRRr/pDTnEn3tV/HKYU3
 BVvSfmNu5Jja3uBzyWUda7xYOqYvQ90JjbLOPOvQYRwn3GDDky6mdBhQ/qkS6YiSsHkV
 OoLEGivZwwHA6QChi0O2iaWUx2jHJbugAwFFKF8CbLndqXLV5W8/kP42Rg4E4salp5lS
 guzmUqCwxUZxoCwWFSI/ao2AZL7uI1y5kQ0ps43ZYdhrVWk/o01Hlb7skV8zp7MkiSpD
 cXxqa+TsaSi4T8AKpfGvyHW/Kcu0+bN3ivya1aK3i7VHf6AES2/dcYMbeFBGZj7+YcXd
 OgyA==
X-Gm-Message-State: AO0yUKV30e3YOL/Odt+BI/zLwrygVS0lEy+HT3QX4DJ0FgLas+oYrx1z
 dPRpLvVgZS40mr1XD5atZev1GladAVzeXBwS6Ebw9g==
X-Google-Smtp-Source: AK7set+enYQAT6EptDabqZUbDV3esLdckJONxaTZ47keMG7iGdk0lZlEyJHzl1jWSuwBCj1kot2g4OCCuRxyvO0pSs4=
X-Received: by 2002:a05:600c:220f:b0:3e0:15c:860f with SMTP id
 z15-20020a05600c220f00b003e0015c860fmr64175wml.115.1675810472693; Tue, 07 Feb
 2023 14:54:32 -0800 (PST)
MIME-Version: 1.0
References: <20230202012348.885402-1-nhuck@google.com>
 <alpine.LRH.2.21.2302021052580.21238@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.21.2302021052580.21238@file01.intranet.prod.int.rdu2.redhat.com>
From: Nathan Huckleberry <nhuck@google.com>
Date: Tue, 7 Feb 2023 14:54:21 -0800
Message-ID: <CAJkfWY5d+FqGb_3PMZbMWYdNW4ED4CqiuJzMQFog_GLLEtZiBg@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] dm-verity: Remove WQ_UNBOUND.
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 7, 2023 at 12:16 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Wed, 1 Feb 2023, Nathan Huckleberry wrote:
>
> > Setting WQ_UNBOUND increases scheduler latency on ARM64.  This is likely
> > due to the asymmetric architecture of ARM64 processors.
> >
> > I've been unable to reproduce the results that claim WQ_UNBOUND gives a
> > performance boost on x86-64.
> >
> > This flag is causing performance issues for multiple subsystems within
> > Android.  Notably, the same slowdown exists for decompression with
> > EROFS.
> >
> > | open-prebuilt-camera  | WQ_UNBOUND | ~WQ_UNBOUND   |
> > |-----------------------|------------|---------------|
> > | verity wait time (us) | 11746      | 119 (-98%)    |
> > | erofs wait time (us)  | 357805     | 174205 (-51%) |
> >
> > | sha256 ramdisk random read | WQ_UNBOUND    | ~WQ_UNBOUND |
> > |----------------------------|-----------=---|-------------|
> > | arm64 (accelerated)        | bw=42.4MiB/s  | bw=212MiB/s |
> > | arm64 (generic)            | bw=16.5MiB/s  | bw=48MiB/s  |
> > | x86_64 (generic)           | bw=233MiB/s   | bw=230MiB/s |
> >
> > Cc: Sami Tolvanen <samitolvanen@google.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > ---
> >  drivers/md/dm-verity-target.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> > index ccf5b852fbf7..020fd2341025 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -1399,8 +1399,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >               goto bad;
> >       }
> >
> > -     /* WQ_UNBOUND greatly improves performance when running on ramdisk */
> > -     wq_flags = WQ_MEM_RECLAIM | WQ_UNBOUND;
> > +     wq_flags = WQ_MEM_RECLAIM;
> > +
> >       /*
> >        * Using WQ_HIGHPRI improves throughput and completion latency by
> >        * reducing wait times when reading from a dm-verity device.
>
> Hi
>
> If you remove WQ_UNBOUND, you should also change the last argument of
> alloc_workqueue from num_online_cpus() to either 0 or 1. Try both 0 and 1
> and tell us which performs better.

They look roughly the same on ARM64. There's a slight advantage for
using 1, but they're too close to conclusively say one is better.

Thanks,
Huck

>
> Mikulas
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

