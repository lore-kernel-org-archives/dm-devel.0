Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE077C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675365098;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VSbEGgm9K6gD6GG3cWIGLXiFcxufD0mggP/dVuZdUrE=;
	b=IqvoNEIj238dSv/u3CVXjbPBtKVfix3rEjaZfuWsfTD5v03cUJkhYFRbWqsPP7xvKd3CSt
	vsL1/rkHYXEZX5jkduq1iv/xqlq+e5xhQc90REgm/dXHqHk5FYkRuKlApgFk2G2+/UvRAP
	uftqmYov3+JJA/jWJHnTWGCcjoKL6t4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-ehh4SxraN9uBXsOQSl0Mkw-1; Thu, 02 Feb 2023 14:11:35 -0500
X-MC-Unique: ehh4SxraN9uBXsOQSl0Mkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEA0488B77F;
	Thu,  2 Feb 2023 19:11:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3747140EBF6;
	Thu,  2 Feb 2023 19:11:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC132194658C;
	Thu,  2 Feb 2023 19:11:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F0D801946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 19:11:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D71D52166B35; Thu,  2 Feb 2023 19:11:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D04BF2166B33
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:11:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B12A088B77D
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 19:11:30 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-iquNVdVfOICwJecIEeXl_g-1; Thu, 02 Feb 2023 14:11:29 -0500
X-MC-Unique: iquNVdVfOICwJecIEeXl_g-1
Received: by mail-wm1-f51.google.com with SMTP id
 j29-20020a05600c1c1d00b003dc52fed235so2227485wms.1
 for <dm-devel@redhat.com>; Thu, 02 Feb 2023 11:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=cmqPx/Zy279diCwL80ZzQVZT2Mcv1030GfDHO64ZwaM=;
 b=3cr/igKlJX5hyDOH9JOvr3bGvJIYP9bmrkDxUF2BQ5mm1w3RNAOVGensxMH4mabMaW
 zrfR4JPHYkihb4O2hdwA9NQW8TDS+bkoxOYjqnpwt54WTzyhxZxOnu58NtoIA1InRbCd
 fFnj4LMq63ZtQs7/foKO8jTAIt5BnrYGSmUyz2nWSFUsLcmLduOYG+le1gNnuTjr1u74
 6e0dv7fz+WOcg2RUeiZgtG0o0MVwSO009IZzBWbS/iey+GLQetgFKepSrwomOPyeCwku
 ucwlrVktauTwkf8JoebU/xFoYnENkcrBkmSEkecBSXsAqju2ilVBoEdvQKtnHBctKUT/
 9KFg==
X-Gm-Message-State: AO0yUKWNNx9NYu9n1O8NGcam3KESjf4OqsAfcb8arUrBv2eTbWDBfXVG
 Aw/9j2E4inF9snx+DjcxnJJp1U+zYEhVJpF3mMX5qw==
X-Google-Smtp-Source: AK7set96hCXSN8RisUiNR5YsJkh6ScE8+8SR4F6BqhH6feHgPVQmnMOF+Dd5nQ7x6loD3WWBhySd5AaVOyA9RgQ/D6o=
X-Received: by 2002:a05:600c:1da3:b0:3da:b40f:c734 with SMTP id
 p35-20020a05600c1da300b003dab40fc734mr372362wms.115.1675365087907; Thu, 02
 Feb 2023 11:11:27 -0800 (PST)
MIME-Version: 1.0
References: <20230202012348.885402-1-nhuck@google.com>
 <Y9vnte1xP5T+nZ6j@redhat.com>
In-Reply-To: <Y9vnte1xP5T+nZ6j@redhat.com>
From: Nathan Huckleberry <nhuck@google.com>
Date: Thu, 2 Feb 2023 11:11:16 -0800
Message-ID: <CAJkfWY5sYxPe1ArxSe3fkwqkOFSxxz9HDdF6XoL_Wc9g070hRg@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm-verity: Remove WQ_UNBOUND.
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
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
 dm-devel@redhat.com, mpatocka@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good. Thanks.

On Thu, Feb 2, 2023 at 8:41 AM Mike Snitzer <snitzer@kernel.org> wrote:
>
> On Wed, Feb 01 2023 at  8:23P -0500,
> Nathan Huckleberry <nhuck@google.com> wrote:
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
> > --
> > 2.39.1.456.gfc5497dd1b-goog
>
> Hi,
>
> I've discussed with Mikulas, tweaked your patch slightly but accepted
> your change, please see:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=6f30cc248507ee96c22ff4c3cbc86099ff12b7a9
>
> Thanks,
> Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

