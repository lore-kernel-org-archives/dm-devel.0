Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B2BC43217
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-pZJZ48jVPxytY7i5pGUwrg-1; Thu, 05 May 2022 03:13:16 -0400
X-MC-Unique: pZJZ48jVPxytY7i5pGUwrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D20B80159B;
	Thu,  5 May 2022 07:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF26B400F729;
	Thu,  5 May 2022 07:13:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9D511947B8F;
	Thu,  5 May 2022 07:13:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED4641947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 19:43:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D58A640CF8EF; Wed,  4 May 2022 19:43:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D0C9A40CF8EA
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:43:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B788A80418E
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:43:15 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-ajnsa9n8PQWTHnuAGaNCAA-1; Wed, 04 May 2022 15:43:12 -0400
X-MC-Unique: ajnsa9n8PQWTHnuAGaNCAA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1665461CC5;
 Wed,  4 May 2022 19:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC16C385B0;
 Wed,  4 May 2022 19:43:09 +0000 (UTC)
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aea5ea61
 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO); 
 Wed, 4 May 2022 19:43:06 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id
 00721157ae682-2f7c424c66cso27413407b3.1; 
 Wed, 04 May 2022 12:43:06 -0700 (PDT)
X-Gm-Message-State: AOAM533BeATCwLIaoAODv88i5X9H5KkPmFqdlfTk1fNsCM5vPP3E3Eym
 9ANAbBu5/cRH7opENA+w+QrVfQPe2ZFzJNGwkQU=
X-Google-Smtp-Source: ABdhPJx/LLlf9uU3BgMKrDlesdbIqJ0CMZ2ujuXNSd91VO0CROyM9dP7lS+9effRUl7IhGh/0TkAsL77MotuiIOKYfI=
X-Received: by 2002:a0d:ef03:0:b0:2fa:245:adf3 with SMTP id
 y3-20020a0def03000000b002fa0245adf3mr11176034ywe.100.1651693384800; Wed, 04
 May 2022 12:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
In-Reply-To: <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 4 May 2022 21:42:54 +0200
X-Gmail-Original-Message-ID: <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
Message-ID: <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 05 May 2022 07:13:10 +0000
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgTGludXMsCgpPbiBXZWQsIE1heSA0LCAyMDIyIGF0IDg6MDAgUE0gTGludXMgVG9ydmFsZHMK
PHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToKPgo+IE9uIFdlZCwgTWF5IDQs
IDIwMjIgYXQgMzoxNSBBTSBKYXNvbiBBLiBEb25lbmZlbGQgPEphc29uQHp4MmM0LmNvbT4gd3Jv
dGU6Cj4gPgo+ID4gPiBBbGlnbm1lbnQ/IENvbXBpbGVyIGJ1Zz8gSFcgaXNzdWU/Cj4gPgo+ID4g
UHJvYmFibHkgb25lIG9mIHRob3NlLCB5ZWEuIFJlbW92aW5nIHRoZSBpbnN0cnVjdGlvbiBhZGRy
ZXNzZXMsIHRoZSBvbmx5Cj4gPiBkaWZmZXJlbmNlIGJldHdlZW4gdGhlIHR3byBjb21waWxlcyBp
czogaHR0cHM6Ly94bi0tNGRiLmNjL1Jybjh1c2FYL2RpZmYjbGluZS00NDAKPgo+IFdlbGwsIHRo
YXQgYWRkcmVzcyBkb2Vzbid0IHdvcmsgZm9yIG1lIGF0IGFsbC4gSXQgdHVybnMgaW50byDXkC5j
Yy4KPgo+IEknZCBsb3ZlIHRvIHNlZSB0aGUgY29tcGlsZXIgcHJvYmxlbSwgc2luY2UgSSBmaW5k
IHRob3NlIGZhc2NpbmF0aW5nCj4gKG1haW5seSBiZWNhdXNlIHRoZXkgc2NhcmUgdGhlIGhlbGwg
b3V0IG9mIG1lKSwgYnV0IHRob3NlIHdlYgo+IGFkZHJlc3NlcyB5b3UgdXNlIGFyZSBub3Qgd29y
a2luZyBmb3IgbWUuCgrXkC5jYyBpcyBjb3JyZWN0LiBJZiB5b3UgY2FuJ3QgbG9hZCBpdCwgeW91
ciBicm93c2VyIG9yIHNvbWV0aGluZyBpbgp5b3VyIHN0YWNrIGlzIGJyb2tlbi4gQ2hvb3Npbmcg
YSBub24tQVNDSUkgZG9tYWluIGxpa2UgdGhhdCBjbGVhcmx5IGEKYmFkIGRlY2lzaW9uIGJlY2F1
c2UgcGVvcGxlIHdpdGggYnJva2VuIHN0YWNrcyBjYW4ndCBsb2FkIGl0PyBZZWEsCm1heWJlLiBC
dXQgbWF5YmUgaXQncyBsaWtlIHRoZSBhcmNoL2FscGhhLyByZW9yZGVyaW5nIG9mIGRlcGVuZGVu
dApsb2FkcyBhcHBsaWVkIHRvIHRoZSB3ZWIuLi4gQSBiaXQgb2Ygc3RyZXRjaC4KCj4gSXQgbW9z
dCBkZWZpbml0ZWx5IGxvb2tzIGxpa2UgYW4gT3BlblJJU0MgY29tcGlsZXIgYnVnIC0gdGhhdCBj
b2RlCj4gZG9lc24ndCBsb29rIGxpa2UgaXQgZG9lcyBhbnl0aGluZyByZW1vdGVseSB1bmRlZmlu
ZWQgKGFuZCB3aXRoIHRoZQo+ICJ1bnNpZ25lZCBjaGFyIiwgbm90aGluZyBpbXBsZW1lbnRhdGlv
bi1kZWZpbmVkIGVpdGhlcikuCgpJJ20gbm90IHNvIGNlcnRhaW4gaXQncyBpbiB0aGUgY29tcGls
ZXIgYW55bW9yZSwgYWN0dWFsbHkuIFRoZSBidWcKZXhoaWJpdHMgaXRzZWxmIGV2ZW4gd2hlbiB0
aGF0IGNvZGUgaXNuJ3QgYWN0dWFsbHkgY2FsbGVkLiBBZGRpbmcgbm9wcwp0byB1bnJlbGF0ZWQg
Y29kZSBhbHNvIG1ha2VzIHRoZSBwcm9ibGVtIGdvIGF3YXkuIEFuZCByZW1vdmluZyB0aGVzZQpu
b3BzIFsxXSBtYWtlcyB0aGUgcHJvYmxlbSBnbyBhd2F5IHRvby4gU28gbWF5YmUgaXQncyBsb29r
aW5nIG1vcmUKbGlrZSBhIGxpbmtlciBidWcgKG9yIGxpbmtlciBzY3JpcHQgYnVnKSByZWxhdGVk
IHRvIGFsaWdubWVudC4gT3IKd2hhdGV2ZXIgaXMganVtcGluZyBiZXR3ZWVuIGNvbnRleHRzIGlu
IHRoZSBwcmVlbXB0aW9uIGNvZGUgYW5kCnJlc3RvcmluZyByZWdpc3RlcnMgYW5kIHN1Y2ggaXMg
YXNzdW1pbmcgY2VydGFpbiB0aGluZ3MgYWJvdXQgY29kZQpsYXlvdXQgdGhhdCBkb2Vzbid0IGFs
d2F5cyBob2xkLiBNb3JlIGZpZGRsaW5nIGlzIG5lY2Vzc2FyeSBzdGlsbC4KCkphc29uCgpbMV0g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIyMDUwNDExMDkxMS4yODM1MjUtMS1KYXNv
bkB6eDJjNC5jb20vCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

