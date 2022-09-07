Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C8E2C54EE9
	for <dm-devel@archiver.kernel.org>; Wed,  7 Sep 2022 22:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662590080;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eJ4XcTge9Yp2uDcl9+9XTXOtKBAR3zUR07k628lVnrE=;
	b=F+/JjCYlCr7J9rjmo+XDmTpi1FvBSkEieRymhdP++ygvgYh3aSitp713mHKszofq8DRI0X
	K+6Tut6ZU7xRHSnoygEnfH2WM9aQJHEiC9/at2L2xjEO0eb/yYMZS1hdBu7s/6+oWL/ZcJ
	8fV/IsPXTIxkspoR1rDg0nGh1b7Nr3k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-CCrvBskMOSerm_Uje8tD4A-1; Wed, 07 Sep 2022 18:34:36 -0400
X-MC-Unique: CCrvBskMOSerm_Uje8tD4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0777285A58D;
	Wed,  7 Sep 2022 22:34:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B4C1C4011ABF;
	Wed,  7 Sep 2022 22:34:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7FFCD1946A48;
	Wed,  7 Sep 2022 22:34:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36BD81946A44
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Sep 2022 22:34:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1601D1410F38; Wed,  7 Sep 2022 22:34:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 123B91410F36
 for <dm-devel@redhat.com>; Wed,  7 Sep 2022 22:34:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFE561818342
 for <dm-devel@redhat.com>; Wed,  7 Sep 2022 22:34:28 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-VXgHBco3OUWo-gWTYWhu6w-1; Wed, 07 Sep 2022 18:34:27 -0400
X-MC-Unique: VXgHBco3OUWo-gWTYWhu6w-1
Received: by mail-pj1-f45.google.com with SMTP id
 m10-20020a17090a730a00b001fa986fd8eeso444397pjk.0
 for <dm-devel@redhat.com>; Wed, 07 Sep 2022 15:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=Pp4y+VXW5QuKNOfWHvi4eGa5eVSczb0JEs1BHSpJSao=;
 b=5VJLPKixwpvMBusXMnTSK6CKTOgTnYAkEcC5nDBRGlEjfaNbjPYY6j943CR2jErwaO
 rjbo3hWqJpu5sTRhVPzqwrQdMOrut+PvkVjTS6WaHx/ivoNRAZUM+B3R8Otqlf7FII8c
 BmIxXqzyPbKa+olgz/vSjyMsp+7zNK7pGipzeah0JRAb2lsqTJgvtLuXWgNAbIGGCanc
 3PONF6MIHVDHWqzfBx3x2BK4YQJhBP8Fvd2owPNTDNNltloOJr3NOvK/2/7HnMz93XL+
 qRvprY/dJA6c42YCEzN8iTmApnJztZCGjFPdXAYwgGRpRp+49YnRldxDLLAgCu5x9tqH
 SmRg==
X-Gm-Message-State: ACgBeo1E1zGLqKXW84ExM9GAYuQHcCWXX3ak2aGXGCR57+0hJIwRQnBN
 4k/gKmxVzZattTDZuVlBJ22oxhAK+8wYeQ==
X-Google-Smtp-Source: AA6agR5bxK5DKuJ4g7Wu/Tuk9tp1HvYw8sClTJInhRq1N4MSQnfDWDR2wyiSwI1H2US21Pg7QsiEnw==
X-Received: by 2002:a17:90a:9f8f:b0:200:e27:398f with SMTP id
 o15-20020a17090a9f8f00b002000e27398fmr764902pjp.116.1662590066538; 
 Wed, 07 Sep 2022 15:34:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 f6-20020a170902ce8600b001714e7608fdsm7529520plg.256.2022.09.07.15.34.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Sep 2022 15:34:25 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: snitzer@kernel.org,
	agk@redhat.com,
	mka@chromium.org
Date: Wed,  7 Sep 2022 15:34:08 -0700
Message-Id: <166259004596.4128104.7200162640366282166.b4-ty@chromium.org>
In-Reply-To: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
References: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] dm: verity-loadpin: Only trust verity
 targets with enforcement
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
Cc: Kees Cook <keescook@chromium.org>, dm-devel@redhat.com,
 dianders@chromium.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, sarthakkukreti@chromium.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 7 Sep 2022 13:30:58 -0700, Matthias Kaehlcke wrote:
> Verity targets can be configured to ignore corrupted data blocks.
> LoadPin must only trust verity targets that are configured to
> perform some kind of enforcement when data corruption is detected,
> like returning an error, restarting the system or triggering a
> panic.
> 
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm: verity-loadpin: Only trust verity targets with enforcement
      https://git.kernel.org/kees/c/2e1875c05267

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

