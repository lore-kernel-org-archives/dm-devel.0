Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB24C6FA89
	for <dm-devel@archiver.kernel.org>; Thu, 15 Sep 2022 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663253721;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SxxG8zpBYQKOm6JIt4EEkUsxDcLiYKgnc0CIc5I3zw4=;
	b=RZGyfh2JAd3W0Xw4yDr7bs0ZPG0esi+lfDzp9NHesxF7qXfE/U4U092nBY1dpgdxMxGSBo
	PMbFuIlhF3ggK8nVVagSrNVIULGaYI0t6mIxu8m2zrpEySa+6HnnAZok+RHv5W+1SntEPR
	eF0JY+hMFrNJXuWlDEWfsoNZvYtwNIg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-1a7e7tJUPRSzd0iiMPUPag-1; Thu, 15 Sep 2022 10:55:17 -0400
X-MC-Unique: 1a7e7tJUPRSzd0iiMPUPag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04A97101E14D;
	Thu, 15 Sep 2022 14:55:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 767221121314;
	Thu, 15 Sep 2022 14:55:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 307041946587;
	Thu, 15 Sep 2022 14:55:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9A0161946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 14:55:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7534A140EBF5; Thu, 15 Sep 2022 14:55:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 715B3140EBF4
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 14:55:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58B0F858F17
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 14:55:10 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-U8urwMYfOnWgLTDNIDQ-VA-1; Thu, 15 Sep 2022 10:55:08 -0400
X-MC-Unique: U8urwMYfOnWgLTDNIDQ-VA-1
Received: by mail-ej1-f47.google.com with SMTP id a26so14032301ejc.4;
 Thu, 15 Sep 2022 07:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:cc:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=RY58nSqgCrzl/ggQFmaJ/U6bkGC00X7cdBzxEf4E+H8=;
 b=h2lYmSyy/bhhmqYkh9+GhTkF4zvGVypWEI6uYG5x31j8MYzatlGWhuiMZbGwJL0a5t
 UeF5psM+U4fQ9whRrKQQzGoz+9sMonqvI603kMgJ5C39xTntwLfttvNc5g758FwQfa5k
 +Jxcgc3wYZ2A2JNfybiP7u/c9/NocGkUlxMcwLjUmddTP1xUHQK/frqHbiCCvdO5Be4m
 8y/nkVWEGTzSdUCedef1K9pV6h5PxMRC9P+y3dStHOmpVO6oNE4Hk5VQ9t+0/eXN/6GA
 USjMCKmd/Sn4azlOd4M/BCefn0/o2JDfwuun5iX2I8cN+Nb+JNKKpNm7YCDrAWX96g6U
 AhMw==
X-Gm-Message-State: ACrzQf0I88BBlLWhVvB4iobyrIRMgJmBpK/TvsgHhSPeD3J7R4DBu9HM
 YkhQNAzGUuqbYCd6FMWqt6s=
X-Google-Smtp-Source: AMsMyM6tS+qxpxYF4l4fp5O7ycWwBvzoZOSxEX7dqGKRmQ2nqvMvZjxUnsZsfrwMSpNqJx283oFJlA==
X-Received: by 2002:a17:907:c1d:b0:77e:b61e:f0c5 with SMTP id
 ga29-20020a1709070c1d00b0077eb61ef0c5mr241847ejc.457.1663253706919; 
 Thu, 15 Sep 2022 07:55:06 -0700 (PDT)
Received: from [147.251.42.105] (nbbroz.fi.muni.cz. [147.251.42.105])
 by smtp.gmail.com with ESMTPSA id
 gu2-20020a170906f28200b00718e4e64b7bsm9101153ejb.79.2022.09.15.07.55.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 15 Sep 2022 07:55:06 -0700 (PDT)
Message-ID: <4058ae1f-3d8a-aecc-5d96-abf15e78c9ed@gmail.com>
Date: Thu, 15 Sep 2022 16:55:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: =?UTF-8?Q?Krist=c3=b3f_Csillag?= <csillag.kristof@gmail.com>
References: <CAEBTHXYF+90eqqOnrW7M9BjiGomBCqj43xbQ47WBNam0-krbAA@mail.gmail.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <CAEBTHXYF+90eqqOnrW7M9BjiGomBCqj43xbQ47WBNam0-krbAA@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] performance and threads
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
Cc: cryptsetup@lists.linux.dev, device-mapper development <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgpsaXR0bGUgYml0IGxhdGUgcmVwbHksIGJ1dCBhcyBJIHN0cnVnZ2xlZCB3aXRoIE5WTWUg
cGVyZm9ybWFuY2UKd2l0aCBMVUtTIG9uIG15IHJlY2VudGx5IHVwZGF0ZWQgbm90ZWJvb2ssIEkg
YWRkIHNvbWUgbm90ZXMgaGVyZS4KCkl0IGNvdWxkIGFwcGx5IGZvciB5b3VyIGNvbmZpZyB0b28s
IGJ1dCBhcyBJIHNvbWV0aW1lcyBzZWUgc2ltaWxhciByZXBvcnRzLAppdCBpcyBiZXR0ZXIgdG8g
aGF2ZSBpdCBvbiBvbmUgcGxhY2UgKGFsc28gY2MgZG0tZGV2ZWwgYXMgTWlrdWxhcwpoZWxwZWQg
bWUgdG8gZGVidWcgc29tZSB0aGluZ3MpLgoKT24gMDUvMDkvMjAyMiAwNTo1MiwgS3Jpc3TDs2Yg
Q3NpbGxhZyB3cm90ZToKPiBTaG9ydCBzdW1tYXJ5OiByZWFkaW5nIG15IGVuY3J5cHRlZCBpcyBh
IGxvdCBzbG93ZXIgdGhhbiByZWFkaW5nIGl0Cj4gcmF3LCB3aGlsZSB0aGUgQ1BVIGlzIHVuZGVy
dXRpbGl6ZWQuCj4gCj4gRGV0YWlsZWQgdmVyc2lvbjoKPiAKPiBJIGhhdmUgYSBSQUlEMSBkZXZp
Y2UsIGNvbnNpc3Rpbmcgb2YgdHdvIGlkZW50aWNhbCBOVk1lIGRldmljZXMuCj4gT24gdGhlIHRv
cCBvZiB0aGUgUkFJRCBkZXZpY2UsIEkgaGF2ZSBMVUtTIGVuY3J5cHRpb24uCj4gCj4gVGhlc2Ug
YXJlIHRoZSByZWFkIHNwZWVkczoKPiAKPiAtIFJhdyBkZXZpY2UgcmVhZDogMiwzIEdCL3MKPiAt
IFJBSUQgZGV2aWNlIHJlYWQ6IDIsMyBHQi9zCj4gLSBSZWFkaW5nIGZyb20gdGhlIGVuY3J5cHRl
ZCBkZXZpY2U6IDEsNiBHQi9zCgpJbiBnZW5lcmFsIChhcHBsaWVzIGJvdGggZm9yIHJlYWRpbmcg
YW5kIHdyaXRpbmcgcGVyZm9ybWFuY2UgaXNzdWVzKQoKLSBjaGVjayB0aGF0IGtlcm5lbCByZWFs
bHkgdXNlcyBBRVMtTkkgYWNjZWxlcmF0aW9uCiAgIGxzbW9kIHxncmVwIGFlcyBzaG91bGQgc2hv
dyB1c2VkIGFlc25pX2ludGVsCgotIGZvciBOVk1lLCBhbHdheXMgdXNlIDRrIGVuY3J5cHRpb24g
YmxvY2sgKC0tc2VjdG9yLXNpemUgNDA5NiBmb3IgbHVrc0Zvcm1hdCkuCgogICBJdCBzaG91bGQg
YmUgYXV0b2RldGVjdGVkLCBidXQgbWFueSBOVk1lIGxpZSBhbmQgc2hvdyA1MTJCIHBoeXNpY2Fs
IHNlY3RvciwKICAgc28geW91IG5lZWQgdG8gb3ZlcndyaXRlIGl0LgoKICAgSWYgeW91IGhhdmUg
ZXhpc3RpbmcgTFVLUzIgZGV2aWNlLCB5b3UgY2FuIHVzZSBvbmxpbmUgcmVlbmNyeXB0aW9uIHRv
IHN3aXRjaCBpdCBvbgogICBleGlzdGluZyBkZXZpY2UgKGV2ZW4gb25saW5lKS4KICAgSXQgbmVl
ZHMgdG8gcmVlbmNyeXB0IHRoZSB3aG9sZSBkcml2ZSwgc28gaXQgd2lsbCB0YWtlIGEgbG9uZyB0
aW1lLgoKICAgQkUgU1VSRSBubyBmcyBhYm92ZSB1c2VzIDUxMkIgYmxvY2sgc2l6ZSwgdGhvdWdo
ISAob3RoZXJ3aXNlIGl0IGNhbm5vdCBiZSBhY3RpdmF0ZWQgbGF0ZXIpLgogICBXZSB0cnkgdG8g
Y2hlY2sgaXQgYmVmb3JlIHJlZW5jcnlwdGlvbiBzdGFydHMsIGJ1dCBpZiB5b3UgdXNlIG1vcmUg
Y29tcGxleCBzZXR1cCBsaWtlIExWTQogICBhYm92ZSwgaXQgc3RpbGwgY2FuIHJ1biBpdCBhbmQg
Y2F1c2UgdW51c2FibGUgZnMuCiAgIChYRlMgc2VlbXMgdG8gc2V0IDUxMkIgYmxvY2tzOyBleHQ0
IHNlZW1zIHRvIHVzZSA0ayBibG9jayBldmVuIG92ZXIgNTEyQiBzZWN0b3IgZHJpdmUuKQoKLSBp
ZiB0aGUgcGVyZm9ybWFuY2UgaXMgc3RpbGwgaXMgbm90IG9wdGltYWwsIHlvdSBjYW4gdHJ5IHRv
IHVzZSBzb21lIHBlcmZvcm1hbmNlIGZsYWdzLgoKICAgWW91IGNhbiBzd2l0Y2ggdGhlbSBvbi9v
ZmYgdGhlbSBvdmVyIGFjdGl2ZSBkbS1jcnlwdCBkZXZpY2UgYnkgdXNpbmcgImNyeXB0c2V0dXAg
cmVmcmVzaCIgY29tbWFuZC4KICAgY3J5cHRzZXR1cCByZWZyZXNoIC1wZXJmLW5vX3JlYWRfd29y
a3F1ZXVlIC0tcGVyZi1ub193cml0ZV93b3JrcXVldWUgPGFjdGl2ZSBkZXZpY2U+CiAgIChhbmQg
c2ltaWxhciBmbGFncywgc2VlIC0tcGVyZi0qIGZsYWdzKQoKICAgSWYgaXQgaGVscHMsIHVzZSAt
LXBlcnNpc3RlbnQgb3B0aW9uIHRvIHN0b3JlIGl0IHRvIExVS1MyIG1ldGFkYXRhIHRvIGJlIHVz
ZWQgYnkgZGVmYXVsdAogICBmb3IgdGhhdCBkZXZpY2UuICAoc2VlICJtYW4gY3J5cHRzZXR1cCBv
cGVuIikKCkZvciB3cml0aW5nIGlzc3VlcywgbGlrZSByYW5kb20gZnJlZXppbmcgZXRjLCB0cnkg
YWxzbzoKCi0gZW5hYmxlIGRpc2NhcmQgKGJvdGggZm9yIExVS1MgZGV2aWNlIGFuZCBmaWxlc3lz
dGVtKQoKLSBhbmQgbWFpbmx5LCBjaGVjayB5b3VyIEhXLi4uCgpTb21lIChjaGVhcGVyKSBOVk1l
IGJlaGF2ZXMgc3RyYW5nZS4gSSBoYWQgMlRCIE5WTWUgdGhhdCBhZnRlciBjb3B5aW5nIGEgbG90
Cm9mIGRhdGEga2VlcCBzeXN0ZW1zIHJlZ3VsYXJseSBmcmVlemluZyBmb3IgYSBmZXcgc2Vjb25k
cy4KQ1BVIHdhcyBkb2luZyBhbG1vc3Qgbm90aGluZywgaXQgc3BlbnQgdGltZSB3YWl0aW5nIGZv
ciBOVk1lIElPcy4KCkkgdHJpZWQgc2V2ZXJhbCB0aGluZ3MgKGV2ZW4gcGF0Y2hpbmcgZG0vZG0t
Y3J5cHQgdG8gbGltaXQgSU9zKS4gSXQgaGVscHMgb25seSBzbGlnaHRseS4KRmluYWxseSBJIGZv
dW5kIHRoYXQgaXQgaXMganVzdCBzdHJhbmdlIE5WTWUgLSBhZnRlciByZXBsYWNpbmcgaXQgd2l0
aCBiZXR0ZXIgb25lCkkgaGF2ZSBubyBwcm9ibGVtcyBldmVuIHVuZGVyIGV4dHJlbWUgbG9hZCBh
bmQgZXZlcnl0aGluZyBydW5uaW5nIG92ZXIgb25lIGh1Z2UgZG0tY3J5cHQuCgpObyBpZGVhIHdo
eSBkbS1jcnlwdCBhbXBsaWZpZXMgc3VjaCBhIGJlaGF2aW9yIChJIGFtIHN1cmUgaXQgY2FuIGJl
IHJlcHJvZHVjZWQKd2l0aG91dCBkbS1jcnlwdCB0b28sIGp1c3Qgd2l0aCBzb21lIHNwZWNpZmlj
IElPIGxvYWQpLiBJIGV4cGVjdCB0aGVyZSBjb3VsZCBiZSBzb21lCmludGVybmFsIGNvbXByZXNz
aW9uIG9mIGRhdGEgb3Igc29tZSBvcHRpbWl6YXRpb24gdGhhdCBpcyBqdXQgbm90IGVmZmljaWVu
dAp3aXRoIGVuY3J5cHRlZCBkYXRhIHRoYXQgY2Fubm90IGJlIGNvbXByZXNzZWQuCgpTbyB0aGUg
Y29uY2x1c2lvbiBpcyB0aGF0IG9mdGVuIHRoZSBwcm9ibGVtIGlzIG5vdCBpbiBwZXJmb3JtYW5j
ZSBvcgpwYXJhbGxlbCBwcm9jZXNzaW5nIG9mIGVuY3J5cHRpb24gaW4gZG0tY3J5cHQgKHRoYXQg
YWN0dWFsbHkgd29ya3MgcXVpdGUgbmljZSkKYnV0IHdpdGggTlZNZSBkcml2ZSBpdHNlbGYuCgpN
aWxhbgoKPiAKPiBBcyB5b3UgY2FuIHNlZSwgdGhlcmUgaXMgYSBwcmV0dHkgc2VyaW91cyBwZXJm
b3JtYW5jZSBwZW5hbHR5IGZvciB0aGUKPiBkZWNyeXB0aW9uLgo+IFRoZSBjaXBoZXIgcnVubmlu
ZyBpcyB0aGUgZGVmYXVsdCBhZXMteHRzLXBsYWluNjQgY2lwaGVyLgo+IFRoaXMgaXMgYW4gQU1E
IFJ5emVuIDkgNTkwMFggMTItQ29yZSBDUFUsIHNvIEknbSBub3Qgc3VyZSB3aGF0IHRoaXMgaXMu
Cj4gV2hhdCBpcyBldmVuIG1vcmUgaW50ZXJlc3RpbmcsIGlzIHRoYXQgdGhlIENQVSBkb2Vzbid0
IHNlZW0gdG8gYmUgYWxsCj4gdGhhdCBidXN5IGR1cmluZyB0aGUgcmVhZGluZy4gYXMgZmFyIGFz
IEkgY2FuIHRlbGwsIEkgb25seSBnZXQgNAo+IHRocmVhZHMgb2Yga3dvcmtlciAvIGtjcnlwdGQs
IGFuZCB0aGVpciB0b3RhbCBzeXN0ZW0gbG9hZCBpcyBsZXNzIHRoYW4KPiAxMDAlIChvZiAxIGNv
cmUuKQo+IAo+IFNvIEknbSBnZXR0aW5nIHRoZSBpbXByZXNzaW9uIHRoYXQgZXZlbiB0aG91Z2gg
ZGVjcnlwdGlvbiBpcyBhCj4gQ1BVLWJvdW5kIHByb2Nlc3MsIG15IENQVSBpcyBzdGlsbCB1bmRl
cnV0aWxpemVkLgo+IAo+IElzIHRoaXMgaW50ZXJwcmV0YXRpb24gY29ycmVjdD8gSWYgeWVzLCBp
cyB0aGlzIHRvIGJlIGV4cGVjdGVkLCBvciBhbQo+IEkgZG9pbmcgc29tZXRoaW5nIHdyb25nPyBD
YW4gZG0tY3J5cHQgYmUgY29uZmlndXJlZCB0byBydW4gdGhlCj4gZW5jcnlwdGlvbiBvbiBtb3Jl
IENQVSBjb3Jlcywgd2l0aCBiZXR0ZXIgcGVyZm9ybWFuY2U/Cj4gCj4gVGhhbmsgeW91IGZvciB5
b3VyIGhlbHA6Cj4gCj4gICAgICBLcmlzdG9mIENzaWxsYWcKPiAKPiBwcy4gSSdtIG9uIGtlcm5l
bCA1LjE5Cj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

