Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 670AEC19F2D
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659559511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8agpBAtjUF9AAoowjKdy98bKJffubiJKxeD6denoEKk=;
	b=Kkrq5p4tQO1c6lXhz3Gw2j2wW++w0S7GjBRJ0GIYPHzXWhMCDhXfI69jxdxSgqcHuDsJDq
	oZmDk6f6amu5H0NUKvMBoZ30yaOXS7ACKKvHlMGGNSkHGakfzf07oRi92mpM0S97ziIx0T
	KGlJ7PU4UyMJz4xV0gvo7uJDwktFhJ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-aOEMgO5ROuuin-MUntKrHA-1; Wed, 03 Aug 2022 16:45:10 -0400
X-MC-Unique: aOEMgO5ROuuin-MUntKrHA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7ECB185A79C;
	Wed,  3 Aug 2022 20:45:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4EA140CFD0A;
	Wed,  3 Aug 2022 20:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 807E41946A52;
	Wed,  3 Aug 2022 20:45:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 38BC91946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 20:45:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20FF91415122; Wed,  3 Aug 2022 20:45:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D20E1415116
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 20:45:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06797101A586
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 20:45:06 +0000 (UTC)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com
 [209.85.128.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-SYI_ZnisPLSfwxkmoNnt8w-1; Wed, 03 Aug 2022 16:45:04 -0400
X-MC-Unique: SYI_ZnisPLSfwxkmoNnt8w-1
Received: by mail-yw1-f176.google.com with SMTP id
 00721157ae682-32269d60830so182983357b3.2
 for <dm-devel@redhat.com>; Wed, 03 Aug 2022 13:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nbc6TTtXlc6VfBsVBN6Hr/kOw1BsZ/pBPw82z6wXqKA=;
 b=EdaglYnktcX3y5GB7z76BchsiDLtbbxldHOrtNfRYZAYKAdzSEKCC8tuQ5SRYcKUaI
 PUWDkEkHj3kxn9GBucGufBNwwlrYNI4KLDh8LicnmVUygQ+bSUrp6k0AMyV/wnWHcrJl
 3NOwev/wM/fuRfm/vXghTjOXFgQ9OX57l2cA3a9YoBol0NLMRioM2bNdDbLG5d+dL+5w
 0lC1Xa3IG4cGxcUvlqqZR7wVDXNjHcTNbFaAwG1JIAhLKLrf3IFM/5TPa8pcCExko0C7
 A2VOjl5O6DwRKRcQDdfIoZ8YWBG7yL9+055lv5URbRG2FfxvLoMCBhcs38refmicZJ5W
 CUKg==
X-Gm-Message-State: ACgBeo0XRBtz7Y9qor7QQRDg5eVnh6M93a4X6X60Pb1ZwoB/gpnEH+t0
 qUx5e7akucmfGZX33WATCml1gIzUE+ir2Ic5p9PPEA==
X-Google-Smtp-Source: AA6agR4DWBxQCeBDkeUkSNrGwu0R53bNTNqwoEG4P8nAjMgXO1ikzLAwVFJaxgNYWFjZYGyySNaKuIdRFLzaZE5j1oo=
X-Received: by 2002:a81:55c2:0:b0:31f:645b:9858 with SMTP id
 j185-20020a8155c2000000b0031f645b9858mr26357883ywb.296.1659559503829; Wed, 03
 Aug 2022 13:45:03 -0700 (PDT)
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
 <Yuq9jhxb+WgO55KJ@gmail.com>
In-Reply-To: <Yuq9jhxb+WgO55KJ@gmail.com>
From: Daniil Lunev <dlunev@chromium.org>
Date: Thu, 4 Aug 2022 06:44:53 +1000
Message-ID: <CAONX=-dCrJabyvt2S24kEJi38Pbuzj_4kvugoF_75PWV69bNJw@mail.gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Have you also considered unlinking the device node (/dev/dm-$idx) from the
> filesystem after it has been set up for swap?
Yes, the node can be re-linked with mknod, thus is not a suitable solution.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

