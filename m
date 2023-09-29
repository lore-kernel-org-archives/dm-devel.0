Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D19E728DC
	for <dm-devel@archiver.kernel.org>; Fri, 29 Sep 2023 19:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696015477;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cFZaPsnckJTO3fBsN4zRdCJyRNX7uswM1p5LfijcSfY=;
	b=Efj5FESGPy2naHD1xodlVadHw2/kBNO/TlSgD/69BBXJMGqTGIlSEuhmCBynjFuX6fsvAN
	LVwCkogJCtjlpaLZcsst++gjKyuRzz8cudOsZo6RVXF0iYJWygW3hMiAHj5hTbgS8vcnIK
	Y993j+tQKLcwPmLFH3jlCc6OyIg1cPk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-U4-Pz18JMyurA9M8Pk95eA-1; Fri, 29 Sep 2023 15:24:34 -0400
X-MC-Unique: U4-Pz18JMyurA9M8Pk95eA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E413A38149A6;
	Fri, 29 Sep 2023 19:24:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D17EA40C6EBF;
	Fri, 29 Sep 2023 19:24:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96D7D1946588;
	Fri, 29 Sep 2023 19:24:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 202241946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Sep 2023 19:21:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 006861004145; Fri, 29 Sep 2023 19:21:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC1461005E29
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B00B382134E
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 19:21:19 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-GNr-TXLkNqiYtskyxuPRfg-1; Fri, 29 Sep 2023 15:21:17 -0400
X-MC-Unique: GNr-TXLkNqiYtskyxuPRfg-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-69335ddbe16so4031924b3a.1
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 12:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696015276; x=1696620076;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4dtIBcP4y5aTwl3+nqmFPHxKsnqtE7UwX9ZEYMXGnyg=;
 b=YGDij4+56FoA+egUxuWr2h4wk4xK5/lfKuT7H76EnLdH0DlXpCwoXqsPW1gBmbYCF6
 Cuz+/EjIDdEWQ4JqFDLf3KRyYhQXlVrDQVoodSmpcybGJTfmUgSeuNTcLFANtroIf03q
 1lO//A+CM1w59uN3Wazlye4U4gAPCGkrw2ZZh3HfsVs+T+hj88zd/U+MW786fmEz4rTi
 aJH0umXYcYm3bafgQwYW8OyhI+42ISRuUEkJUPI+VNMD3T/tTkv82xstB/WRp6hN8u8k
 8h1JVdfD+SIQnx0e3FzpZjyvS52wD8B7V1dNZxmeC2sd2hp7p0L948P1rSRKl7t9Uf/n
 IA3g==
X-Gm-Message-State: AOJu0YwJzXKSA1JcD0SLwN44fraNfu6Q+isfxfdyWMEDgbmSptGsfSpw
 gCPE3+U3SZ/rbKKS4DlSeMcTjQ==
X-Google-Smtp-Source: AGHT+IGUGV/4POMYK1/va54VqFpcD4baV6lyhqjawMMWWCnzsphh24Cw/Lf7ot61TO/bBKwMRN8+vg==
X-Received: by 2002:a05:6a20:3247:b0:154:c959:f157 with SMTP id
 hm7-20020a056a20324700b00154c959f157mr4646963pzc.30.1696015276309; 
 Fri, 29 Sep 2023 12:21:16 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 a16-20020aa78650000000b006862b2a6b0dsm15959308pfo.15.2023.09.29.12.21.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 Sep 2023 12:21:13 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>
Date: Fri, 29 Sep 2023 12:21:06 -0700
Message-Id: <169601526974.3013632.10898812764774808611.b4-ty@chromium.org>
In-Reply-To: <20230915200344.never.272-kees@kernel.org>
References: <20230915200344.never.272-kees@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] dm crypt: Annotate struct crypt_config with
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Sep 2023 13:03:45 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct crypt_config.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] dm crypt: Annotate struct crypt_config with __counted_by
      https://git.kernel.org/kees/c/6797f1750c3c

Take care,

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

