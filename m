Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB404C19F29
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 23:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659569938;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aMS/fl1Np/ak1AiGZmYZZwXBWAy6MMQbioQnxjl73hY=;
	b=TVy6WxmMJhxUZoY7/RcwWwekMJvq3SIcwmGnxrP0Cpu8LX9BygXFk3HuZKioDVD8+mUdDJ
	xurPfVvX4lUtfrOx4DjSfnQ2KqJ2tWuCd5ioJmvEDVs8igTTOxasKwa9KZo7zldlWsFlb7
	UREGevW+rMCs8PphL/XTakGb/xpsSyM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-LKbclEEyOh-a-62QgtE5TA-1; Wed, 03 Aug 2022 19:38:55 -0400
X-MC-Unique: LKbclEEyOh-a-62QgtE5TA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87EE8185A79C;
	Wed,  3 Aug 2022 23:38:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 998492026D4C;
	Wed,  3 Aug 2022 23:38:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59B9D1946A52;
	Wed,  3 Aug 2022 23:38:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1CB841946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 23:38:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 091C62166B2B; Wed,  3 Aug 2022 23:38:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 052C02166B2A
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 23:38:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF45D811E76
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 23:38:49 +0000 (UTC)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
 [209.85.219.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-A8HuA_O7PG-wPT5lX2b-1A-1; Wed, 03 Aug 2022 19:38:48 -0400
X-MC-Unique: A8HuA_O7PG-wPT5lX2b-1A-1
Received: by mail-yb1-f177.google.com with SMTP id r3so30679613ybr.6
 for <dm-devel@redhat.com>; Wed, 03 Aug 2022 16:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tz/OiJMvaGAcCeuq23X8LcWOcGwQofI9LN2T94BECis=;
 b=LtPXGe0mAoB0I3F4rlhF+ZEeLAJxMug3F3EwgCL58Q3FXDHHB3ag4m6j7RTUQUAIRl
 jhlAXOssLqii2eL+11TQdiMq7V1E3xY+aiUKL5GeiJfwHiYArI9AqL312T/fKawLHFi7
 15VtHAKq1BuHceCESGpKpGcvfbOizyQXz9lGKaywRT/1ZxeRFj6iJPIIJvywrpubUIAV
 I2Id2XcjkufHU5udRh/Q8Fq2jWlmIX67PsHQKd96fktCtDCx8hwcqS0m25cLZu+PopCr
 Oc3dJzPOuq3o9EOAiaG9bmzeQIRw+tRhu5ORyz4ryA1gPqTKmGN4UNTXT7NuWvZIAJXi
 S+YA==
X-Gm-Message-State: ACgBeo2UJfbBc45G/jyHDhBkcgOnZ/StCig2fsWypbiSguTrTFSwmZDl
 uEY5TckWeAuERNn2JdjUGP24yuVotisIU9/haCJTW8+lh4zPlg==
X-Google-Smtp-Source: AA6agR7cf+R7Yn1l+n+/4LnB7dhz82lwgLpmUJ6FIaVZi1PrBPwB2UQ5t0KnOpekkCQJvdkqvGz7S8l8vu/XgVJ+ReE=
X-Received: by 2002:a25:6908:0:b0:67a:6cf9:52e0 with SMTP id
 e8-20020a256908000000b0067a6cf952e0mr4348359ybc.62.1659569927631; Wed, 03 Aug
 2022 16:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
 <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
 <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
 <Yun4LH+StcuBXRtO@sol.localdomain>
 <CAONX=-esLr5bGUks_a8wQBky37NnCawh2eOMemYg32HcPA7pmA@mail.gmail.com>
 <Yuq9jhxb+WgO55KJ@gmail.com>
 <CAONX=-dCrJabyvt2S24kEJi38Pbuzj_4kvugoF_75PWV69bNJw@mail.gmail.com>
 <YurtfvdeYh0kLd+8@gmail.com>
In-Reply-To: <YurtfvdeYh0kLd+8@gmail.com>
From: Daniil Lunev <dlunev@chromium.org>
Date: Thu, 4 Aug 2022 09:38:36 +1000
Message-ID: <CAONX=-e1NcUmJEzajkpCsOVYOfmfMmKKfOB0Bp6UTag3G77yAQ@mail.gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> I thought you were trying to defend against path traversal attacks, not
> arbitrary code execution?  If your threat model includes arbitrary code
> execution by root, you really need to be using SELinux.
Hm, this is actually a very good point which we somehow missed, hm.
Thanks for pointing that out, let me think on that

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

