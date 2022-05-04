Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C955C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:24:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-7mU_O4F4OOGM7W7nLa4GTQ-1; Wed, 04 May 2022 17:24:55 -0400
X-MC-Unique: 7mU_O4F4OOGM7W7nLa4GTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 871F0803524;
	Wed,  4 May 2022 21:24:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7313D2026D2D;
	Wed,  4 May 2022 21:24:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A4A01947046;
	Wed,  4 May 2022 21:24:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 544071947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 21:24:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2826D41373D; Wed,  4 May 2022 21:24:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 242B1415F4E
 for <dm-devel@redhat.com>; Wed,  4 May 2022 21:24:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AB68811E78
 for <dm-devel@redhat.com>; Wed,  4 May 2022 21:24:51 +0000 (UTC)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-Gv851CaLPmmtmZxchFmc6A-1; Wed, 04 May 2022 17:24:48 -0400
X-MC-Unique: Gv851CaLPmmtmZxchFmc6A-1
Received: by mail-lf1-f49.google.com with SMTP id w1so4484274lfa.4
 for <dm-devel@redhat.com>; Wed, 04 May 2022 14:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XjGyI9MSGnU0qCNLMFpaviA7GndbKZ2IDx6hLyctHX4=;
 b=sKXbFXEn0EjMJCMD2847jXmDrY+nqiXJnYyttKBldrvxgc7sEKh1otpOlgtVQ0Luav
 iARl1O5kdqEJfVV6n0AP1JR1T9Ue5tVzhA0E/1BWb9PvGmb8tUNL35N7M+xlCN4U3bqj
 GXZs6Zuxdh01eMCx4MzXsq7+c6h5nTi0RSIv1S68kTSvBQPfhuic2LqR+aoBekaa2TK9
 yeNrj3eDydhjwHl+1Y2Iv11gBAzHOWWUU8zY3uhq5XbGQkOIFuNfAKduuBFBYu+ce+A2
 ft538pCJ+8ypwtk4JDgUTR5aElOTSvYRVkoNefY25WxR+UVsSeod9bsgo5YR40HSMoWz
 sTRg==
X-Gm-Message-State: AOAM533KKk83tg1kWWVN+pDmZkJzhTB+Ng5lSkO0GHR2DTcAQ5qJiz5C
 4/RTC00wER5zhhLy2BIchhRU4C7Xd0CCadnoVe0=
X-Google-Smtp-Source: ABdhPJwgkzPIouCvDsLb5YJQgoO1HE28gM1mnvIiRehNj3HGx2zTPGYEGX1g7d2GWyg/WHklKHvNOw==
X-Received: by 2002:ac2:5f6e:0:b0:472:4922:f610 with SMTP id
 c14-20020ac25f6e000000b004724922f610mr15330368lfc.555.1651699486816; 
 Wed, 04 May 2022 14:24:46 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com.
 [209.85.208.169]) by smtp.gmail.com with ESMTPSA id
 h7-20020a2ea487000000b0024f3d1dae7csm1778797lji.4.2022.05.04.14.24.45
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 14:24:46 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id c15so3282443ljr.9
 for <dm-devel@redhat.com>; Wed, 04 May 2022 14:24:45 -0700 (PDT)
X-Received: by 2002:a2e:9d46:0:b0:24c:7f1d:73cc with SMTP id
 y6-20020a2e9d46000000b0024c7f1d73ccmr13958171ljj.358.1651699485493; Wed, 04
 May 2022 14:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
 <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
 <YnLeH7kBImX5XLNn@antec>
 <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
In-Reply-To: <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 14:24:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgKEbppgxafYchqQ6X_VFa0d_vdtVmfqGQC6kQ+Hg9cAw@mail.gmail.com>
Message-ID: <CAHk-=wgKEbppgxafYchqQ6X_VFa0d_vdtVmfqGQC6kQ+Hg9cAw@mail.gmail.com>
To: Stafford Horne <shorne@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
Cc: Andy Shevchenko <andy@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Mike Snitzer <msnitzer@redhat.com>,
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 4, 2022 at 1:26 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Could be anywhere. Xfinity, Nest WiFi, or the cable router. They all
> are doing their own dns thing.
>
> Probably my cable box, since it's likely the oldest thing in the chain.

No, it seems to be my Nest WiFi router. I told it to use google DNS to
avoid Xfinity or the cable box, and it still shows the same behavior.

Not that I care much, since I consider those IDN names to be dangerous
anyway, but I think it would have been less sad if it had been some
old cable modem.

               Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

