Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371EAE728D7
	for <dm-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696015350;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UPFuuNNIXhRUgXH31Ot7l/LzeZM1sZ8At0kRsKnsFGc=;
	b=cs5ae6rEkBG7VLXZClfD/7on6Rl68mPugnVHDyLRyYolaEXOUm2qkuxPYHCSL+/swLbLHM
	xoAWbR2yYy/NbL8l8RDPzKs3lQyJ7eLktNczcslwNeQaKPuNuSxEm8W5MEFepaQXQKS7Uf
	HOOE7WYALGKXjvHDYIt2OPRHj/TYLQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-PVgP0EWeOtumz1At4uqs3g-1; Fri, 29 Sep 2023 15:22:26 -0400
X-MC-Unique: PVgP0EWeOtumz1At4uqs3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D130B811E86;
	Fri, 29 Sep 2023 19:22:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98E1040C2064;
	Fri, 29 Sep 2023 19:22:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D9791946587;
	Fri, 29 Sep 2023 19:22:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 010C41946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Sep 2023 19:21:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1DFBC158BA; Fri, 29 Sep 2023 19:21:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9ED1C15BB8
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:17 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADBD5802D35
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:17 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-a0ZNg6PJNVSZrxaQJD0I1Q-1; Fri, 29 Sep 2023 15:21:15 -0400
X-MC-Unique: a0ZNg6PJNVSZrxaQJD0I1Q-1
Received: by mail-pl1-f170.google.com with SMTP id
 d9443c01a7336-1c4194f769fso109690115ad.3
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 12:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696015274; x=1696620074;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=LW49HjAeDdFUYVHrqpmiXGwUFKL5qDwVnlMaVHIvZgA=;
 b=HxCkC95k3T3zg48I6ES4ukAKJhvvqfMGqO7A8v+7tqx+v4uOUcwpig99VvUQdho71H
 yMYHZrroS/nTgVwtWZB3gwaJy0ExtblZzO2fqcb+xwQpdMmN66X8HVIQiTAguRCbKR5E
 OBnEpU818rmCsyk1G7tzfgIhAkbtGhtGX6QipBXGdmLpJq4GcqcunAc4Xf+wUuAKoHN2
 g2qXI3ROQrmPF3sp2sUhNk+AC28j4cxg9h1PMFuG4zkB3izCZ8qSlEF+7IzPLNm3NJtq
 avoWzl82egsmF7JforLYJbo2rEMK+k0Dte5N+eMntntEvKGP/j7wLOzI344/jNY9HqkG
 AaPg==
X-Gm-Message-State: AOJu0YwSQrCgbaHvr2oe7T4rdchPcVfiEZY5nDWeKBlsKWmfckPnzLoT
 s8rig/E8eRntaWm3ll91x7KakQ==
X-Google-Smtp-Source: AGHT+IFqgSzjVU11V7YtNG7pPQTxvIcXDaDxaRn0PMHt1RkZSRJN+29nXd8ze3Jn9LTDaBVCzPc1CQ==
X-Received: by 2002:a17:903:22c7:b0:1c4:5e9e:7865 with SMTP id
 y7-20020a17090322c700b001c45e9e7865mr5825424plg.0.1696015274656; 
 Fri, 29 Sep 2023 12:21:14 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 u6-20020a170902b28600b001c61acd5bd2sm10606776plr.112.2023.09.29.12.21.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Sep 2023 12:21:13 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>
Date: Fri, 29 Sep 2023 12:21:05 -0700
Message-Id: <169601526975.3013632.9191876969851693974.b4-ty@chromium.org>
In-Reply-To: <20230915200352.never.118-kees@kernel.org>
References: <20230915200352.never.118-kees@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] dm: Annotate struct stripe_c with
 __counted_by
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
Cc: Mike Snitzer <snitzer@kernel.org>, llvm@lists.linux.dev,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, dm-devel@redhat.com,
 linux-hardening@vger.kernel.org, Tom Rix <trix@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Sep 2023 13:03:53 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct stripe_c.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm: Annotate struct stripe_c with __counted_by
      https://git.kernel.org/kees/c/052b7cba53b4

Take care,

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

