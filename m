Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AEBC4332F
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:13:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-xEj0S1VBMhKe8lOuafG6aQ-1; Thu, 05 May 2022 03:13:18 -0400
X-MC-Unique: xEj0S1VBMhKe8lOuafG6aQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78B9C18154E6;
	Thu,  5 May 2022 07:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6066940D2976;
	Thu,  5 May 2022 07:13:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 062331947B9C;
	Thu,  5 May 2022 07:13:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3AF4A1947043
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 19:58:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E66B403373; Wed,  4 May 2022 19:58:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A78C41617E
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:58:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00F383AF42A4
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:58:05 +0000 (UTC)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com
 [209.85.221.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-zRvCteOoMOGIjG-C7MICrw-1; Wed, 04 May 2022 15:58:03 -0400
X-MC-Unique: zRvCteOoMOGIjG-C7MICrw-1
Received: by mail-vk1-f178.google.com with SMTP id n135so1122382vkn.7;
 Wed, 04 May 2022 12:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=PP0v6E0J74PSlvWpBHKPKv2X563T4tZp8Opf3sME7AY=;
 b=1Lrw7lEo9+cS+rlmT+4mxOqHtFTTo7LOw+D8MQc1s1XQtJBr/cf6DaC/qglZBbGg+2
 yZ8zSIg0EnATU3yTEVNz0VGkdUNhJHkoVuXMZC+UpfB1aNj6q8wYBY11cwcaakgAZZYl
 OnoNIxAaO1oIr0EHdgjI1Zo8ZpDjg/PvlD2/nRG2h+fCcF93s/BDQ2yUxhnORSX6NOts
 MeUgNHMb4iTsnae+eMVAPfUJQnsJdWN5OMVX9EXEQwp3IAyTvV6d4Gz9bGdHdqq/fTEx
 j/JVMiPkFEDFrVGvAuOQigkE4UEyOH/EKpHc2nGeA7vpqAby88A3op6cfnGqzTq5oGlv
 Pucg==
X-Gm-Message-State: AOAM532GJAfp0vPSu/qtoquJQz95O1mam2xoXEtwH14vrHywcecunYN/
 w/1o11hq5CbIPiFvr7sD1a20N8F+wKGvcA9G7eA=
X-Google-Smtp-Source: ABdhPJwbmiH9S1vCJd8kJ2hr5R+OzZsd7uOkoQGEEn9iSx3iQQUzAZ9TBzrKX7ZkQ6BOrCQZo5vN3Qqq1syke+EiO9c=
X-Received: by 2002:ac5:c856:0:b0:34e:d0b4:7a10 with SMTP id
 g22-20020ac5c856000000b0034ed0b47a10mr5639395vkm.39.1651694282561; Wed, 04
 May 2022 12:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com>
 <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
In-Reply-To: <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
From: Stafford Horne <shorne@gmail.com>
Date: Thu, 5 May 2022 04:57:50 +0900
Message-ID: <CAAfxs77yaLvWx9KnkDZX7E1eDm9N-NVJn5n8=mCK9BU-cSob=A@mail.gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXkgNSwgMjAyMiBhdCA0OjQzIEFNIEphc29uIEEuIERvbmVuZmVsZCA8SmFzb25A
engyYzQuY29tPiB3cm90ZToKPgo+IEhpIExpbnVzLAo+Cj4gT24gV2VkLCBNYXkgNCwgMjAyMiBh
dCA4OjAwIFBNIExpbnVzIFRvcnZhbGRzCj4gPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3Jn
PiB3cm90ZToKPiA+Cj4gPiBPbiBXZWQsIE1heSA0LCAyMDIyIGF0IDM6MTUgQU0gSmFzb24gQS4g
RG9uZW5mZWxkIDxKYXNvbkB6eDJjNC5jb20+IHdyb3RlOgo+ID4gPgo+ID4gPiA+IEFsaWdubWVu
dD8gQ29tcGlsZXIgYnVnPyBIVyBpc3N1ZT8KPiA+ID4KPiA+ID4gUHJvYmFibHkgb25lIG9mIHRo
b3NlLCB5ZWEuIFJlbW92aW5nIHRoZSBpbnN0cnVjdGlvbiBhZGRyZXNzZXMsIHRoZSBvbmx5Cj4g
PiA+IGRpZmZlcmVuY2UgYmV0d2VlbiB0aGUgdHdvIGNvbXBpbGVzIGlzOiBodHRwczovL3huLS00
ZGIuY2MvUnJuOHVzYVgvZGlmZiNsaW5lLTQ0MAo+ID4KPiA+IFdlbGwsIHRoYXQgYWRkcmVzcyBk
b2Vzbid0IHdvcmsgZm9yIG1lIGF0IGFsbC4gSXQgdHVybnMgaW50byDXkC5jYy4KPiA+Cj4gPiBJ
J2QgbG92ZSB0byBzZWUgdGhlIGNvbXBpbGVyIHByb2JsZW0sIHNpbmNlIEkgZmluZCB0aG9zZSBm
YXNjaW5hdGluZwo+ID4gKG1haW5seSBiZWNhdXNlIHRoZXkgc2NhcmUgdGhlIGhlbGwgb3V0IG9m
IG1lKSwgYnV0IHRob3NlIHdlYgo+ID4gYWRkcmVzc2VzIHlvdSB1c2UgYXJlIG5vdCB3b3JraW5n
IGZvciBtZS4KPgo+INeQLmNjIGlzIGNvcnJlY3QuIElmIHlvdSBjYW4ndCBsb2FkIGl0LCB5b3Vy
IGJyb3dzZXIgb3Igc29tZXRoaW5nIGluCj4geW91ciBzdGFjayBpcyBicm9rZW4uIENob29zaW5n
IGEgbm9uLUFTQ0lJIGRvbWFpbiBsaWtlIHRoYXQgY2xlYXJseSBhCj4gYmFkIGRlY2lzaW9uIGJl
Y2F1c2UgcGVvcGxlIHdpdGggYnJva2VuIHN0YWNrcyBjYW4ndCBsb2FkIGl0PyBZZWEsCj4gbWF5
YmUuIEJ1dCBtYXliZSBpdCdzIGxpa2UgdGhlIGFyY2gvYWxwaGEvIHJlb3JkZXJpbmcgb2YgZGVw
ZW5kZW50Cj4gbG9hZHMgYXBwbGllZCB0byB0aGUgd2ViLi4uIEEgYml0IG9mIHN0cmV0Y2guCgpJ
IGhhdmUgdXBsb2FkZWQgYSBkaWZmIEkgY3JlYXRlZCBoZXJlOgogIGh0dHBzOi8vZ2lzdC5naXRo
dWIuY29tLzU0MzM0NTU2ZjI5MDcxMDRjZDEyMzc0ODcyYTA1OTdjCgpJdCBzaG93cyB0aGUgc2Ft
ZSBvdXRwdXQuCgo+ID4gSXQgbW9zdCBkZWZpbml0ZWx5IGxvb2tzIGxpa2UgYW4gT3BlblJJU0Mg
Y29tcGlsZXIgYnVnIC0gdGhhdCBjb2RlCj4gPiBkb2Vzbid0IGxvb2sgbGlrZSBpdCBkb2VzIGFu
eXRoaW5nIHJlbW90ZWx5IHVuZGVmaW5lZCAoYW5kIHdpdGggdGhlCj4gPiAidW5zaWduZWQgY2hh
ciIsIG5vdGhpbmcgaW1wbGVtZW50YXRpb24tZGVmaW5lZCBlaXRoZXIpLgo+Cj4gSSdtIG5vdCBz
byBjZXJ0YWluIGl0J3MgaW4gdGhlIGNvbXBpbGVyIGFueW1vcmUsIGFjdHVhbGx5LiBUaGUgYnVn
Cj4gZXhoaWJpdHMgaXRzZWxmIGV2ZW4gd2hlbiB0aGF0IGNvZGUgaXNuJ3QgYWN0dWFsbHkgY2Fs
bGVkLiBBZGRpbmcgbm9wcwo+IHRvIHVucmVsYXRlZCBjb2RlIGFsc28gbWFrZXMgdGhlIHByb2Js
ZW0gZ28gYXdheS4gQW5kIHJlbW92aW5nIHRoZXNlCj4gbm9wcyBbMV0gbWFrZXMgdGhlIHByb2Js
ZW0gZ28gYXdheSB0b28uIFNvIG1heWJlIGl0J3MgbG9va2luZyBtb3JlCj4gbGlrZSBhIGxpbmtl
ciBidWcgKG9yIGxpbmtlciBzY3JpcHQgYnVnKSByZWxhdGVkIHRvIGFsaWdubWVudC4gT3IKPiB3
aGF0ZXZlciBpcyBqdW1waW5nIGJldHdlZW4gY29udGV4dHMgaW4gdGhlIHByZWVtcHRpb24gY29k
ZSBhbmQKPiByZXN0b3JpbmcgcmVnaXN0ZXJzIGFuZCBzdWNoIGlzIGFzc3VtaW5nIGNlcnRhaW4g
dGhpbmdzIGFib3V0IGNvZGUKPiBsYXlvdXQgdGhhdCBkb2Vzbid0IGFsd2F5cyBob2xkLiBNb3Jl
IGZpZGRsaW5nIGlzIG5lY2Vzc2FyeSBzdGlsbC4KCkJpc2VjdGluZyBkZWZpbml0ZWx5IGNhbWUg
dG8gdGhpcyBwYXRjaCB3aGljaCBpcyBzdHJhbmdlLiBUaGVuIHJldmVydGluZwplNWJlMTU3Njdl
N2UgKCJoZXgyYmluOiBtYWtlIHRoZSBmdW5jdGlvbiBoZXhfdG9fYmluIGNvbnN0YW50LXRpbWUi
KQpkaWQgYWxzbyBmaXggdGhlIHByb2JsZW0gZm9yIG1lLgoKQnV0IGl0IGNvdWxkIGJlIGFueSBz
bWFsbCBwYXRjaCB0aGF0IGNoYW5nZXMgbGF5b3V0IGNvdWxkIG1ha2UgdGhpcyBnbyBhd2F5LgoK
SSBoYXZlIHRoaW5ncyB0byB0cnk6CiAgLSBtb3JlIGNsb3NlIGxvb2sgYXQgdGhlIHByb2R1Y2Vk
IGFzZW1ibHkgZGlmZgogIC0gbmV3ZXIgY29tcGlsZXIgKEkgZml4ZWQgYSBmZXcgYnVncyBpbiBn
Y2MgMTIgZm9yIG9wZW5yaXNjLCBhbmQKdGhpcyB0ZXN0aW5nIGNhbWUgdXAgaW4gZ2NjIDExKQog
IC0gdHJ5aW5nIG9uIEZQR0EncwoKSSdsbCByZXBvcnQgYXMgSSBmaW5kIHRoaW5ncy4KCi1TdGFm
Zm9yZAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

