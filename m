Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4735C19F2D
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659559786;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jlFB4dMp4rMgctGlxmtiBx/v/ywUw7iFLW8QCOhYMBM=;
	b=DhuB2uLVG8kARmoy0AlkHyAf5j4NV2csFZqBCaaBs3CR40QhFwebknO4Na+uYeAa7t10eU
	0kiZrNgQKNie3HDIs0MehuFFIGo+jrLt7qt07Amy1YpBTvGSajsQMu0zy2CPJSokmXdUhE
	V1bMJM0IOirlVuFP0YyLingVeq29EHA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-44mAJP_1OKiaQwyh1pmkrA-1; Wed, 03 Aug 2022 16:49:43 -0400
X-MC-Unique: 44mAJP_1OKiaQwyh1pmkrA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 946418115B1;
	Wed,  3 Aug 2022 20:49:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0ADC62166B26;
	Wed,  3 Aug 2022 20:49:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CCD271946A52;
	Wed,  3 Aug 2022 20:49:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 49D1F1946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 20:49:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D3D01121315; Wed,  3 Aug 2022 20:49:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C171121314
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 20:49:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EFD4811E80
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 20:49:40 +0000 (UTC)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-9i1UBEBUOAa_59oMUMbfGg-1; Wed, 03 Aug 2022 16:49:38 -0400
X-MC-Unique: 9i1UBEBUOAa_59oMUMbfGg-1
Received: by mail-yb1-f172.google.com with SMTP id z5so28354704yba.3
 for <dm-devel@redhat.com>; Wed, 03 Aug 2022 13:49:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8Gy0vda4fEjaHYG8Mhy2G1yyPlIluCCBrlRGzTB0g14=;
 b=XkHQGMsDCuMODN7JtE7mEJJlFbURK4ugezp91/vKj00B73veaAZb410ez4tJ+vyUaT
 pO5lnkxGTZJWD9FjbCLOivqQ/yJeXyIHlWNayU3SZaNsEYCeAiAbiVDs1IHzlHx39ZWo
 5Wh47CCMWvv/7zhfp7U4qe/5IW6MnFNT6ceF1gOOU9zm3zGT/KzVvDGODlbk432P1Lsa
 SDXFqd1V5yzXcRl0UQakSDZ6dG2h3IIB6sDfqfQyFr8niFZVD2zTJSfJaLJlDXZeXasi
 ogMpVzE4mqqCiW0ozc0EzgkEAlZhUxTCJOB0zx65J8G/hqjjgBwYDV9NC1rvRttC5JEA
 qj9g==
X-Gm-Message-State: ACgBeo2mRY2dxuoBr5gcoRJeRT/bvnYSjaHGo6CDN0nWH1Caxf2X4N/2
 geV3sH4tY1pRtWHshIXdDOFvBJXbHTIyJzI9izaiMg==
X-Google-Smtp-Source: AA6agR5lM3Raf5s7ohmYeE5wleyqMdPST+gQvxgTBp4oJg1xkl8CCaHr3+GkUA5ZwlYrONoFxLcnLYEfLkzWd7ASa0E=
X-Received: by 2002:a25:6908:0:b0:67a:6cf9:52e0 with SMTP id
 e8-20020a256908000000b0067a6cf952e0mr3893457ybc.62.1659559777815; Wed, 03 Aug
 2022 13:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
 <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
 <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
 <Yun4LH+StcuBXRtO@sol.localdomain>
 <CAONX=-esLr5bGUks_a8wQBky37NnCawh2eOMemYg32HcPA7pmA@mail.gmail.com>
 <YuqimBLSh/4wvoDU@redhat.com>
In-Reply-To: <YuqimBLSh/4wvoDU@redhat.com>
From: Daniil Lunev <dlunev@chromium.org>
Date: Thu, 4 Aug 2022 06:49:27 +1000
Message-ID: <CAONX=-ctGm1pLYtVTk=vtLVi9v+F+vCcd=aQ1gZH7gDMGkh-3w@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: Brian Geffon <bgeffon@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> I'm not going to take this patch. It isn't the proper way to handle
> preventing use of a DM device.
Can you suggest a better mechanism that would be acceptable
from your perspective?

> In addition, the patch's header doesn't speak to a proper
> review/audit of implications this change would have
> on all aspects of a DM device's capabilities.
I would gladly clarify the commit message, and I am sorry
for making it terse in the beginning. Can you please
clarify, what capabilities are you concerned about? The
change shouldn't change any existing semantics if the
mechanism is never used on a specific system, and only
alters "open" behaviour in the cases where the specific
message was issued, but I am happy to cover any
additional aspects you are concerned about

Thanks,
Daniil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

