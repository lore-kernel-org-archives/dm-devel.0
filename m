Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCC5C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 17:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-qJh3gwreOUiQ3RXzQJrrxQ-1; Mon, 25 Apr 2022 13:54:20 -0400
X-MC-Unique: qJh3gwreOUiQ3RXzQJrrxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4D488517CF;
	Mon, 25 Apr 2022 17:54:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2002CC53BA8;
	Mon, 25 Apr 2022 17:54:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F090519451F2;
	Mon, 25 Apr 2022 17:54:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 855D119452D2
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 17:54:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 034A2552D1A; Mon, 25 Apr 2022 17:54:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3BF4552D15
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 17:54:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBF032999B22
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 17:53:51 +0000 (UTC)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-4WzDKdUCOKKO3sEzwGEAYQ-1; Mon, 25 Apr 2022 13:53:41 -0400
X-MC-Unique: 4WzDKdUCOKKO3sEzwGEAYQ-1
Received: by mail-lf1-f51.google.com with SMTP id y32so27573042lfa.6
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 10:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/LM5ApeDrM+ZiQkhPKo2nD8z3VPb3CiZfRSSBlkwszA=;
 b=tpt09E7qr91QrBcgjUfS2ABUfPfg5aIJ4lzcyxd7CA9++8IHhNfcYwADqbSf0Rx3D0
 IfjF1T1RuF04I6zOo973AzTMdt39hoOxk5n1o2I2L6WspT9HvnOCcdWtoKAITmJG9M85
 XF8dSzAj2ZaZTzoKusxcZ9RxiO70NCLY2GXEkLD3c4u0TURqBsnR4KQ+KPstMxjIdIc2
 I0Lt2xFTueqTQKV7IIzUzwu6lmSxeUksMUKvwZdDK2PKdBm7797vJKmtVGTLObAton66
 mooMicxBDfGXKog138Yak9rc4mhBAbiv+Q0LssgEz2QYSSJjZk8BzVWyWFT7P4GHxmSI
 v9Bg==
X-Gm-Message-State: AOAM532rZ8xPZe2biED5iMQjr9eo0yp3zIj0BOVR8tLjEO1LJZmHnw0y
 IIDQMp47kwnSZCwkLN9KX29qWL82ko4j0ejd4O8=
X-Google-Smtp-Source: ABdhPJzAWjwJM5/S9c8+JcMC0NYQjuV9XWzcVaIlpCQWyRRIF3xHX9cvBzXj2fu8VBqxLCv7nivkpg==
X-Received: by 2002:a05:6512:322a:b0:472:7d2:1114 with SMTP id
 f10-20020a056512322a00b0047207d21114mr4102756lfe.105.1650909220015; 
 Mon, 25 Apr 2022 10:53:40 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com.
 [209.85.167.54]) by smtp.gmail.com with ESMTPSA id
 q15-20020a196e4f000000b0047205c5409esm545780lfk.147.2022.04.25.10.53.39
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Apr 2022 10:53:39 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id p12so22022353lfs.5
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 10:53:39 -0700 (PDT)
X-Received: by 2002:a05:6512:1193:b0:471:af88:2d74 with SMTP id
 g19-20020a056512119300b00471af882d74mr13719233lfr.531.1650909219017; Mon, 25
 Apr 2022 10:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Apr 2022 10:53:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhP7EdVkj9V2aWbUtPbC=rNxvJ1R1Bs45jFz4KT3xg-Q@mail.gmail.com>
Message-ID: <CAHk-=wjhP7EdVkj9V2aWbUtPbC=rNxvJ1R1Bs45jFz4KT3xg-Q@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2] hex2bin: make the function hex_to_bin
 constant-time
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
Cc: Andy Shevchenko <andy@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 25, 2022 at 5:07 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> We are subtracting values that are in the 0 ... 255 range.

Well, except that's not what the original patch did.

It was subtracting values that were in the -128 ... 255 range (where
the exact range depended on the sign of 'char').

But yeah, I think bit8 was always safe. Probably. Particularly as the
possible ranges across different architectures is bigger than the
range within one _particular_ architecture (so you'll never see "255 -
-128" even when the sign wasn't defined ;)

> > Also, I do worry that this is *exactly* the kind of trick that a
> > compiler could easily turn back into a conditional. Usually compilers
> > tend to go the other way (ie turn conditionals into arithmetic if
> > possible), but..
>
> Some old version that I tried used "(ch - '0' + 1) * ((unsigned)(ch - '0')
> <= 9)" - it worked with gcc, but clang was too smart and turned it into a
> cmov when compiling for i686 and to a conditional branch when compiling
> for i586.
>
> Another version used "-(c - '0' + 1) * (((unsigned)(c - '0') >= 10) - 1)"
> - it almost worked, except that clang still turned it into a conditional
> jump on sparc32 and powerpc32.
>
> So, I came up with this version that avoids comparison operators at all
> and tested it with gcc and clang on all architectures that I could try.

Yeah, the thing about those compiler heuristics is that they are often
based on almost arbitrary patterns that just happen to be what
somebody has found in some benchmark.

Hopefully nobody ever uses something like this as a benchmark.

             Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

