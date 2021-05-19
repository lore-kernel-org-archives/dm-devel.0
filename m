Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520C1C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 15:06:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB82A61042
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 15:06:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB82A61042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-CUEIzUVdP0ODGbivn8-Njw-1; Wed, 19 May 2021 11:06:42 -0400
X-MC-Unique: CUEIzUVdP0ODGbivn8-Njw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91C6A8015DB;
	Wed, 19 May 2021 15:06:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F63B60C04;
	Wed, 19 May 2021 15:06:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1815A1800FFC;
	Wed, 19 May 2021 15:06:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14JF6V3a017505 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 11:06:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C7D1510545F5; Wed, 19 May 2021 15:06:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C356010545AD
	for <dm-devel@redhat.com>; Wed, 19 May 2021 15:06:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 973BA80D0E0
	for <dm-devel@redhat.com>; Wed, 19 May 2021 15:06:28 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-275-SNqMsPnfNQyIEiwtI4WOFw-1;
	Wed, 19 May 2021 11:06:26 -0400
X-MC-Unique: SNqMsPnfNQyIEiwtI4WOFw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC1561059;
	Wed, 19 May 2021 15:06:24 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id
	r26-20020a056830121ab02902a5ff1c9b81so12016116otp.11; 
	Wed, 19 May 2021 08:06:24 -0700 (PDT)
X-Gm-Message-State: AOAM532KofgHPchhmSormExFANBS5oxJwZJ3A+lrmbLI+S5+Ow3k1oJX
	ml0EHHpSkRBF2Mu+kd98tZzcth9CJYxOKDN7W2M=
X-Google-Smtp-Source: ABdhPJz7YjwLlgP6XDI/AIAJhBP9bxQFyyxjatMuY+lC1KTHOkBwbOjEn1xXEDHgqxmWuGRturRWH4/HgYsgbs5DAkc=
X-Received: by 2002:a05:6830:4da:: with SMTP id
	s26mr9240884otd.77.1621436784158; 
	Wed, 19 May 2021 08:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210519074124.49890-1-ardb@kernel.org>
	<YKUnOBqGgfHPXX5F@sashalap>
In-Reply-To: <YKUnOBqGgfHPXX5F@sashalap>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 19 May 2021 17:06:12 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG2Wt25Uv_NnrKohuq3cGG3diZp=VmCEyPEj8PVG+trTw@mail.gmail.com>
Message-ID: <CAMj1kXG2Wt25Uv_NnrKohuq3cGG3diZp=VmCEyPEj8PVG+trTw@mail.gmail.com>
To: Sasha Levin <sashal@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, "# 3.4.x" <stable@vger.kernel.org>,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	agk@redhat.com, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [dm-devel] [PATCH stable] dm ioctl: fix out of bounds array
	access when no devices
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

On Wed, 19 May 2021 at 16:56, Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, May 19, 2021 at 09:41:24AM +0200, Ard Biesheuvel wrote:
> >From: Mikulas Patocka <mpatocka@redhat.com>
> >
> >commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a upstream.
> >
> >If there are not any dm devices, we need to zero the "dev" argument in
> >the first structure dm_name_list. However, this can cause out of
> >bounds write, because the "needed" variable is zero and len may be
> >less than eight.
> >
> >Fix this bug by reporting DM_BUFFER_FULL_FLAG if the result buffer is
> >too small to hold the "nl->dev" value.
> >
> >Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >---
> >Please apply to 4.4.y and 4.9.y
>
> We already carry this patch via the backport provided in
> https://lore.kernel.org/stable/20210513094552.266451-1-nobuhiro1.iwamatsu@toshiba.co.jp/
>

Excellent, thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

