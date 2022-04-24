Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6663FC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:38:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-XjO1QECFP0aRXMmQBQo7oA-1; Sun, 24 Apr 2022 17:38:30 -0400
X-MC-Unique: XjO1QECFP0aRXMmQBQo7oA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7161F811E78;
	Sun, 24 Apr 2022 21:38:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 600A5145BEEE;
	Sun, 24 Apr 2022 21:38:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 06A6A1947BBE;
	Sun, 24 Apr 2022 21:38:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 605181947BBD
 for <dm-devel@listman.corp.redhat.com>; Sun, 24 Apr 2022 21:38:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45785111E3FD; Sun, 24 Apr 2022 21:38:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41308111E3E9
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 21:38:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 105891C04B55
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 21:38:20 +0000 (UTC)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-vxHbMJzYPFGRU1xmg-z-tQ-1; Sun, 24 Apr 2022 17:38:18 -0400
X-MC-Unique: vxHbMJzYPFGRU1xmg-z-tQ-1
Received: by mail-lf1-f53.google.com with SMTP id p10so23101338lfa.12
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 14:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8Lj+8I0FO8qrcoAXKsUQ/7bkIYJ5OSyWim41oZ7eGAE=;
 b=qn7KqsmTj6WLh1z9kywodqDdcVJtWHlFyvkmU12PLx28MWTlFbTUV6fP+3Hk30iD8L
 VK5QbmytJrDy6sPEIcLklOBJsmkyucn3xMu9WputXggb4BdRK4hnetBGGwWm/ybqIerf
 5COwej4/+dk6VBPvQ0vup7To+OeeNpFYItp2ptodK/TJGeZmXXb+fVNzwxSZN+g1m31q
 16oUKjhk64Ajw+nW1g/INMF6TnJcz6OrtHW+EtuafGV6ObidEujQqHgK4+rYrRDIfO8t
 8u2wu7e+VDWIjespJTLSYnn8s0S+vfd7eerj7NrfVqIB57C7B3EGjifF7MZgeEKmwWai
 t7ig==
X-Gm-Message-State: AOAM533u8jnoe4UngG/jpZjkawyevVGpW5CLel4ca/uopods3BvrDU8Q
 A4YQoh+0wYrBBglrcS+HH6DC9X4CRR/R/RXK4wc=
X-Google-Smtp-Source: ABdhPJwIsQdomCdhkOyIh95PPQ5s5QE3SifcjiK9XPHRkKW615Fylfss+spWnasBC6QwiLgpQ4tuQw==
X-Received: by 2002:a05:6512:151c:b0:45c:6b70:c892 with SMTP id
 bq28-20020a056512151c00b0045c6b70c892mr10495369lfb.124.1650836296463; 
 Sun, 24 Apr 2022 14:38:16 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com.
 [209.85.167.49]) by smtp.gmail.com with ESMTPSA id
 m19-20020a194353000000b00471fd6ba63asm547838lfj.203.2022.04.24.14.38.15
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 24 Apr 2022 14:38:15 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id n14so2386626lfu.13
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 14:38:15 -0700 (PDT)
X-Received: by 2002:ac2:5084:0:b0:471:ccb3:8c99 with SMTP id
 f4-20020ac25084000000b00471ccb38c99mr10965514lfm.435.1650836294999; Sun, 24
 Apr 2022 14:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Apr 2022 14:37:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
Message-ID: <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] hex2bin: make the function hex_to_bin
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Apr 24, 2022 at 1:54 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> + *
> + * Explanation of the logic:
> + * (ch - '9' - 1) is negative if ch <= '9'
> + * ('0' - 1 - ch) is negative if ch >= '0'

True, but...

Please, just to make me happier, make the sign of 'ch' be something
very explicit. Right now that code uses 'char ch', which could be
signed or unsigned.

It doesn't really matter in this case, since the arithmetic will be
done in 'int', and as long as 'int' is larger than 'char' as a type
(to be really nit-picky), it all ends up working ok regardless.

But just to make me happier, and to make the algorithm actually do the
_same_ thing on every architecture, please use an explicit signedness
for that 'ch' type.

Because then that 'ch >= X' is well-defined.

Again - your code _works_. That's not what I worry about. But when
playing these kinds of tricks, please make it have the same behavior
across architectures, not just "the end result will be the same
regardless".

Yes, a 'ch' with the high bit set will always be either >= '0' or <=
'9', but note how *which* one it is depends on the exact type, and
'char' is simply not well-defined.

Finally, for the same reason - please don't use ">> 8".  Because I do
not believe that bit 8 is well-defined in your arithmetic. The *sign*
bit will be, but I'm not convinced bit 8 is.

So use ">> 31" or similar.

Also, I do worry that this is *exactly* the kind of trick that a
compiler could easily turn back into a conditional. Usually compilers
tend to go the other way (ie turn conditionals into arithmetic if
possible), but..

                    Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

