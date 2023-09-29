Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94646E728DA
	for <dm-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696015381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G6vml10aofma4gXjGj9DHz4hoNgKf6iiantePzvnWX0=;
	b=SSxsi1C6oaKcgA0PzSUY7iXqC3jyEkEqMDx3Kgp1edifUCbone0DudBCB1GbAOJ40euoZ/
	g03DDZ87NvhJCtqIxPlnj7uMmsmJEYcDohnkmAzOPOZfuElP4lEjO7PVP2Nhbd/CP9r8gZ
	Ys7G6ZzLRVLR0ym6fKu4kBtG1rAAoUo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-Vjt1y5dbOwqJDK3Tl6ZCQQ-1; Fri, 29 Sep 2023 15:22:56 -0400
X-MC-Unique: Vjt1y5dbOwqJDK3Tl6ZCQQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8ABE380391B;
	Fri, 29 Sep 2023 19:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6510492C37;
	Fri, 29 Sep 2023 19:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7ECE71946587;
	Fri, 29 Sep 2023 19:22:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F274A1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Sep 2023 19:21:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 288BE40C6EBF; Fri, 29 Sep 2023 19:21:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21BFF40C6EC0
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0310A1C07593
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:18 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-UKcSEChgN6WKLC6F2XcXyw-1; Fri, 29 Sep 2023 15:21:16 -0400
X-MC-Unique: UKcSEChgN6WKLC6F2XcXyw-1
Received: by mail-pl1-f176.google.com with SMTP id
 d9443c01a7336-1c61bde0b4bso87578565ad.3
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 12:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696015275; x=1696620075;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=FzGyz2MPegojcnBn3+M4x1lpZordUMqcBYgQWes42EI=;
 b=l3scUbgGSy8012yODWVUPw46BmGnsX1t58aSj4cVPUs0xg3RMvU+BZ8TvBulDbEiL3
 a0XolgqEInmcvDMOF5aDmVyCd5t/J0QCQp4q5XZO+ojYqesxOryxISZPCczzOjnmAHaL
 KmBq1LN7tDoUpKWvOeu+LbLaGvYn/VPN5PjJqEqenmIRjL6WIeHLMhgtqcSdV6ZoY89V
 ULADGBez7LWJfXoW5ERy3oSjZagBGKZqTjt2jVr9Zo0VYkLfCK9TCWYlCcxI1Pryqh9S
 qwiBLh2mdyUrxjBfYdMFm2DtMwjPBYHYpkaLRUp9V8c0RV88S8Kas9a7W32V5XDuUf28
 a9aQ==
X-Gm-Message-State: AOJu0YyB0yRVI6XmPhFItb5fRBigFnkr/NkbuGUHtbKTtONM3v1s3Osv
 LYhDdP3nWIxpebnXOTHE8/auVw1Bg7a+5Kphut0=
X-Google-Smtp-Source: AGHT+IFjwoljz7qSuEmgrS2IYGOuTuCN7jnbI2kAUszFu5hBRn1FsFvHLdskqcLbQYPnmal7cixZdg==
X-Received: by 2002:a17:902:d30d:b0:1c3:3b5c:1fbf with SMTP id
 b13-20020a170902d30d00b001c33b5c1fbfmr4888238plc.10.1696015274991; 
 Fri, 29 Sep 2023 12:21:14 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 e10-20020a170902744a00b001bc59cd718asm11031537plt.278.2023.09.29.12.21.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Sep 2023 12:21:13 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>
Date: Fri, 29 Sep 2023 12:21:07 -0700
Message-Id: <169601526974.3013632.14322525126930729466.b4-ty@chromium.org>
In-Reply-To: <20230915200335.never.098-kees@kernel.org>
References: <20230915200335.never.098-kees@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] dm raid: Annotate struct raid_set with
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Sep 2023 13:03:36 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct raid_set.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm raid: Annotate struct raid_set with __counted_by
      https://git.kernel.org/kees/c/588cd9b20862

Take care,

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

