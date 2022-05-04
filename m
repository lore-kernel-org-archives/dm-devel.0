Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF9DC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 20:01:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-PWaJ8MG_NXKdK12jMtPmug-1; Wed, 04 May 2022 16:01:29 -0400
X-MC-Unique: PWaJ8MG_NXKdK12jMtPmug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9DF73C0CD5A;
	Wed,  4 May 2022 20:00:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EA2F54CE29;
	Wed,  4 May 2022 20:00:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F1A861947046;
	Wed,  4 May 2022 20:00:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 82FB01947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 20:00:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23D22C28114; Wed,  4 May 2022 20:00:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FE2BC28112
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:00:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F23012919EBC
 for <dm-devel@redhat.com>; Wed,  4 May 2022 20:00:57 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-cR2rZQR1Nri5Fp1qz5IWVg-1; Wed, 04 May 2022 16:00:56 -0400
X-MC-Unique: cR2rZQR1Nri5Fp1qz5IWVg-1
Received: by mail-lf1-f43.google.com with SMTP id bq30so4179803lfb.3
 for <dm-devel@redhat.com>; Wed, 04 May 2022 13:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=LmVnCbPzQFTKVo2J8nBuP0OejuZI/MsiEmrhFI+epZk=;
 b=CxtMtLF5PFra0c6S+PiO3xggZY5lB5noJUbI1i6GE5YsYzuxyEcsuOY30pZ/yhB7xg
 4uILb2pnuUPqVxKaGIjivOl9EcV2QRWTGaCNi97o7xQbpELqaa5It7BS6EsJMe87FA2A
 xK9MxuV6klsYVYkS8PgSrqRWLNln83efSq44okinaWlwyFaGuryanaEmhvYMDXJEBxn9
 pnoUfRopUoPU4dranTtF5E/Uhf6zncro4NW5QHL3H0XXxSdxwwVlmo13g6glIbBCw6BA
 +VWhqGBBDaN34t3qjCtVzZ8bFoY6gdFExzddHV7QSIKpAJTFx8GVNlM1OY2ckH829JhE
 1zsw==
X-Gm-Message-State: AOAM5308fnqXxJUihNUraG4SW4oEBxbeE2luyQZ5Dx+yHHxKIGXdimSl
 FLEfxHHp16gk7YQQlsB1na6yN1zy3iu2Np51/hk=
X-Google-Smtp-Source: ABdhPJwKCjXAPLFYHV8OB99dBGhIRdxH/T5eks76x8lG71eqshZ1h6y00w6GVzyzqMWBs5SPZ3EAOg==
X-Received: by 2002:a05:6512:2301:b0:44a:394e:2add with SMTP id
 o1-20020a056512230100b0044a394e2addmr14962830lfu.177.1651694454069; 
 Wed, 04 May 2022 13:00:54 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com.
 [209.85.208.177]) by smtp.gmail.com with ESMTPSA id
 r5-20020a2e8e25000000b0024f3d1dae89sm1762862ljk.17.2022.05.04.13.00.52
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 13:00:53 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id y19so3049440ljd.4
 for <dm-devel@redhat.com>; Wed, 04 May 2022 13:00:52 -0700 (PDT)
X-Received: by 2002:a2e:934b:0:b0:24f:cce:5501 with SMTP id
 m11-20020a2e934b000000b0024f0cce5501mr13625492ljh.443.1651694452466; Wed, 04
 May 2022 13:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
 <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
In-Reply-To: <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 13:00:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
Message-ID: <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Stafford Horne <shorne@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXkgNCwgMjAyMiBhdCAxMjo1MSBQTSBMaW51cyBUb3J2YWxkcwo8dG9ydmFsZHNA
bGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOgo+Cj4gQnV0IEkgZG9uJ3QgdGhpbmsgdGhhdCBp
dCdzIHRoZSBicm93c2VyLCBhY3R1YWxseS4gRXZlbiAnbnNsb29rdXAnCj4gcmVmdXNlcyB0byB0
b3VjaCBpdCB3aXRoCj4KPiAgICAqKiBzZXJ2ZXIgY2FuJ3QgZmluZCDXkC5jYzogU0VSVkZBSUwK
Pgo+IGFuZCBpdCBzZWVtcyBpdCdzIGxpdGVyYWxseSB0aGUgbG9jYWwgZG5zIGNhY2hpbmcgKGRu
c21hc3E/KQoKTG9va3MgbGlrZSBGZWRvcmEgYnVpbGRzIGRuc21hc3Egd2l0aCAnbm8taTE4bics
IGFsdGhvdWdoICJkbnNtYXNxIC12IgphbHNvIHNob3dzICJJRE4yIiwgc28gd2hvIGtub3dzLi4g
TWF5YmUgaXQncyBzb21lIGRlZmF1bHQgY29uZmlnIGlzc3VlCnJhdGhlciB0aGFuIHRoZSBidWls
ZCBjb25maWd1cmF0aW9uLgoKICAgICAgICAgICAgICAgICAgTGludXMKCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

