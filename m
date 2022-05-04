Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7974C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 20:26:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-hFiwQIoyPmWmZZPRNESPFQ-1; Wed, 04 May 2022 16:26:33 -0400
X-MC-Unique: hFiwQIoyPmWmZZPRNESPFQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3D421C06903;
	Wed,  4 May 2022 20:26:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5014C28101;
	Wed,  4 May 2022 20:26:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 913621947046;
	Wed,  4 May 2022 20:26:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 485DD1947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 20:26:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0D1354ED0F; Wed,  4 May 2022 20:26:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED0D354ECFF
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:26:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0A3B3810D20
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:26:28 +0000 (UTC)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
 [209.85.167.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-OwxpWsWHPwK8_-JweppWag-1; Wed, 04 May 2022 16:26:26 -0400
X-MC-Unique: OwxpWsWHPwK8_-JweppWag-1
Received: by mail-lf1-f42.google.com with SMTP id w1so4278103lfa.4
 for <dm-devel@redhat.com>; Wed, 04 May 2022 13:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mmrVv14fPgXxwEi6qY3BXXY+CxBqDRKooA9FDuaSqV8=;
 b=euMApSK+cM0A311rfKKqLh4Li38//QKlankejmRTIGxuSya/AYfl2vA6Ecf/HHwBM7
 fkm4tgrqO7LwcY22OjRaE6n39zrJbJ/Rg/t8zc5QPQKDoMw3ydos5aWVTV+fZQ3l+DjH
 Z2tVV9Ne7t06Tmx78h3EAb6+IGYSix6Pla8wrBnO4IUkMiP0nE0fxyFb34//EMjpe8AA
 0XmGodYWi1tntIbEKVDdKFJ3/HDwvm+A5jTGhAIKSezsc2qTRLRxL5BWyoyC1z2/YUJ7
 eUbeN/934TwJe+KD/E3SmL2XQIKzoiJPFo5hTtQJZAC4kRMpvrqVgWCiIy2UvtNm6R+u
 68rA==
X-Gm-Message-State: AOAM532raHupI7pIuloDoSIcgJN0YUFp0H+jmiKNjlafh2N+56Yqxtxd
 vCKMTVQ8pyg2HS9QKQW9lb6tAXMZnaZ+A6r5P5U=
X-Google-Smtp-Source: ABdhPJy880qHaboZQmHLrL/t+DRYO2YB1TDvu+ZDALPI0ZaHis0d6cGhjNPzKrZB7AqTayi0jIdKfw==
X-Received: by 2002:ac2:4a85:0:b0:472:1f8a:ae24 with SMTP id
 l5-20020ac24a85000000b004721f8aae24mr15085038lfp.370.1651695984670; 
 Wed, 04 May 2022 13:26:24 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com.
 [209.85.167.47]) by smtp.gmail.com with ESMTPSA id
 y17-20020ac24211000000b0047255d211bcsm291415lfh.235.2022.05.04.13.26.22
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 13:26:23 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id y32so4269272lfa.6
 for <dm-devel@redhat.com>; Wed, 04 May 2022 13:26:22 -0700 (PDT)
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id
 h19-20020a0565123c9300b0044b04bac334mr15722106lfv.27.1651695982340; Wed, 04
 May 2022 13:26:22 -0700 (PDT)
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
In-Reply-To: <YnLeH7kBImX5XLNn@antec>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 13:26:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
Message-ID: <CAHk-=wj5UXrsLz3GzYWLaU1b=_dRQWqj1ZC-buf6MHmLrJF_Og@mail.gmail.com>
To: Stafford Horne <shorne@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 4, 2022 at 1:12 PM Stafford Horne <shorne@gmail.com> wrote:
>
> Which version of Fedora?

F35 here.

But looking further, it's not dnsmasq either. Yes, dnsmasq is built
with no-i18n, but as mentioned IDN2 does seem to be enabled, so I
think it's just "no i18n messages".

It seems to be the upstream dns server.

Using 8.8.8.8 explicitly makes it work for me, and that obviously
bypasses not just the local dns cache, but also the next dns server
hop.

Could be anywhere. Xfinity, Nest WiFi, or the cable router. They all
are doing their own dns thing.

Probably my cable box, since it's likely the oldest thing in the chain.

                Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

