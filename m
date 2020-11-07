Return-Path: <SRS0=MC9w=EN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D98C2D0A3
	for <dm-devel@archiver.kernel.org>; Sat,  7 Nov 2020 01:50:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA9D22078B
	for <dm-devel@archiver.kernel.org>; Sat,  7 Nov 2020 01:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA9D22078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=purestorage.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-PUOJSy5LOv2Zm5vL9OJuyw-1; Fri, 06 Nov 2020 20:50:06 -0500
X-MC-Unique: PUOJSy5LOv2Zm5vL9OJuyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E07FB801FC6;
	Sat,  7 Nov 2020 01:50:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 496C85129E;
	Sat,  7 Nov 2020 01:50:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1522A922FB;
	Sat,  7 Nov 2020 01:49:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A71ns7N008345 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 20:49:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2B386207A80F; Sat,  7 Nov 2020 01:49:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2696A201155B
	for <dm-devel@redhat.com>; Sat,  7 Nov 2020 01:49:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA97C800883
	for <dm-devel@redhat.com>; Sat,  7 Nov 2020 01:49:51 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
	[209.85.210.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-134-CKI7fgx6MwqwTK6Qp1kH6Q-1; Fri, 06 Nov 2020 20:49:49 -0500
X-MC-Unique: CKI7fgx6MwqwTK6Qp1kH6Q-1
Received: by mail-pf1-f172.google.com with SMTP id 13so3186576pfy.4
	for <dm-devel@redhat.com>; Fri, 06 Nov 2020 17:49:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
	:content-transfer-encoding:message-id:references:to;
	bh=2uAk53EyLus4PqKAMYK87MSIHSehm0NuNQskmmWwcl4=;
	b=Ptgf3Ow4uXEki4z7MCJmudkLYG0EspUy4JrAwS7j+tjOpsqWgyzV/hVy7z2XzMBJZI
	MGjawAcACRaAECTszjLLEBIC4iaANA8QBQMtpBj1CsvtnqorC5K3spcz/7g+5XuA3SNS
	8aL9Vln/MHV7Xcu8WjZ48gSQuodhzIUGFbpFNW1wgTdCCZ0crc+4s2aATJuIH0Ggthu6
	bHniqhkHeJkbUaaLKNmAXVA4hR4FSsfUddSMpwmhVMxTF/MN7CKNb0tqY/6NKMgEq6Qw
	HvRCEKQBRcGVjJmsnQRXCv0zZn0WN4l9g/Te4oinM5GTfGgzw9SWZ1KHbTkf4HD0WDOA
	+1yQ==
X-Gm-Message-State: AOAM533sPE4ETvAg3xSGU/g+wxsDs66omGnO7dgVnBZ/cYFh0f0rAR7C
	qJmei6vJDs2cJx04V1CV3R3r0A==
X-Google-Smtp-Source: ABdhPJxowHI2sJtQsnLio8svWJzo6vxo7UFhqRqDGyWKuFmxE1yuyd8fDgVru25k2CwtQKdRBD/v6A==
X-Received: by 2002:a17:90b:150c:: with SMTP id
	le12mr2471857pjb.139.1604713788172; 
	Fri, 06 Nov 2020 17:49:48 -0800 (PST)
Received: from [10.231.222.197] ([192.30.189.3])
	by smtp.gmail.com with ESMTPSA id
	g14sm3543688pfk.90.2020.11.06.17.49.47
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 06 Nov 2020 17:49:47 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <CAAMCDeckiKm0ed8dQGy84vaa-sWmYsyLdFJ5_Qf1xUEeVv+ZYw@mail.gmail.com>
Date: Fri, 6 Nov 2020 17:49:46 -0800
Message-Id: <E896AD8C-6F72-4200-B214-188BF378D4CB@purestorage.com>
References: <83E54997-B7F0-4A47-94B0-54BA6EE7FE37@purestorage.com>
	<CAAMCDeckiKm0ed8dQGy84vaa-sWmYsyLdFJ5_Qf1xUEeVv+ZYw@mail.gmail.com>
To: Roger Heflin <rogerheflin@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A71ns7N008345
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] A device existing in two different multpath devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhhbmtzIFJvZ2VyLiBJIHdpbGwgbG9vayBpbnRvIHRoYXQuIEkgaGF2ZSB3aGF0IGxvb2tzIHRv
IGJlIGEgdGVtcG9yYXJ5Cndvcmthcm91bmQgYnkgdXNpbmcgdGhlIHVkZXYgZW52aXJvbm1lbnQg
dmFyaWFibGUgSURfU0NTSV9TRVJJQUwKaW5zdGVhZCBvZiBJRF9TRVJJQUwgYXMgdGhlIG11bHRp
cGF0aCB1aWQuIFRoYXQgd2F5IHdoaWNoZXZlciBJTlFVSVJZClZQRCBwYWdlIHN1Y2NlZWRzLCAw
eDgzIG9yIDB4ODAsIHRoZSB2YWx1ZSBvZiBJRF9TQ1NJX1NFUklBTCBpcyAKdGhlIHNhbWUuCgp1
aWRfYXR0cmlidXRlICAgICAgICAgIElEX1NDU0lfU0VSSUFMCgpUaGFua3MsCkJyaWFuCgpCcmlh
biBCdW5rZXIKU1cgRW5nCmJyaWFuQHB1cmVzdG9yYWdlLmNvbQoKCgo+IE9uIE5vdiA1LCAyMDIw
LCBhdCA1OjA1IFBNLCBSb2dlciBIZWZsaW4gPHJvZ2VyaGVmbGluQGdtYWlsLmNvbT4gd3JvdGU6
Cj4gCj4gWW91IG1pZ2h0IHRyeSBsaW1pdGVkIHVkZXYncyBjaGlsZHJlbiB0byBzYXkgNCByYXRo
ZXIgdGhhbiB0aGUKPiBkZWZhdWx0LCB0aGUgZGVmYXVsdCBzZWVtcyB0byBiZSBiYXNlZCBvbiBz
b21lICUgb2YgdG90YWwgY3B1cyAoaXQKPiBzZWVtcyB0byBjaGFuZ2UgYmFzZWQgb24gdGhlIHVk
ZXYgdmVyc2lvbiksIHNvIGlmIHRoZSBjcHUgY291bnRzIGFyZQo+IGxhcmdlIHRoZW4gdGhlcmUg
Y2FuIGJlIGEgbGFyZ2UgbnVtYmVyIG9mIGNoaWxkcmVuIHF1aWNrbHkgY3JlYXRlZC4gIEkKPiBo
YXZlIHNlZW4gdGhlIHVkZXYgY2hpbGRyZW4gaXNzdWUgb24gbWFjaGluZXMgdGhhdCBoYXZlIGFy
b3VuZCA3MC0xMDAKPiBjcHVzIG9yIG1vcmUgYW5kIGh1Z2UgbnVtYmVycyBvZiBsdW5zICgxMDAt
MTAwMCdzKSwgYnV0IGl0IGFsc28gc2VlbXMKPiB0byBnZXQgbXVjaCB3b3JzZSBhdCBhIHNwZWNp
ZmljIE9TIHVwZGF0ZSAobm8gaWRlYSB3aGljaCBvbmUgdGhhdAo+IHdhcykuICAgIEl0IHNwYXdu
cyB0aGUgcHJvY2Vzc2VzIHNvIGZhc3QgdGhhdCB0aGUgbWFjaGluZSB1c2VzCj4gZXhjZXNzaXZl
IGNwdSBib3RoIHVzZXIgYW5kIHN5c3RlbSB0aW1lLCBhbmQgZGVwZW5kaW5nIG9uIHlvdXIgc2Nz
aQo+IGxheWVyIHRpbWVvdXRzIHRoZSByZXN1bHRpbmcgc3lzdGVtIHRpbWUgbWF5IGJlIHNpZ25p
ZmljYW50IGVub3VnaCB0bwo+IGNhdXNlIHNjc2kgbGF5ZXIgY29tbWFuZHMgdG8gdGltZW91dC4K
PiAKPiBJIGhhdmUgc2VlbiBsYXJnZXIgbWFjaGluZXMgd2l0aCBhIGxvdCBvZiBsdW5zIGNyZWF0
ZSBzbyBtYW55IGNoaWxkcmVuCj4gdGhhdCB0aGUgbWFjaGluZSB0YWtlcyBleGNlc3NpdmUgdGlt
ZSAoc3l0ZW1kIHRpbWVzIG91dCBhbmQgZmFpbHMgdG8KPiBmaW5kIFZHL0xWJ3MgaW4gOTAgc2Vj
b25kcyBhbmQgZ29lcyB0byBlbWVyZ2VuY3kgbW9kZSwgYW5kIGJ5IHRoZSB0aW1lCj4gd2UgZ2V0
IHRvIHRoZSBwcm9tcHQgZXZlcnl0aGluZyBpcyBmaW5lKS4gIFdlIGZpbmQgd2hlbiB0aGlzIGhh
cHBlbnMKPiB0aGF0IHVkZXYgY29sbGVjdGVkIGxpa2UgODArIG1pbnV0ZXMgb2YgY3B1IHRpbWUg
aW4gOTAgc2Vjb25kcyBpdAo+IHRha2VzIHRvIGJvb3QuICAgVHVybmluZyB0aGUgY2hpbGRyZW4g
ZG93biBhY3R1YWxseSByZXN1bHRlZCBpbiBtdWNoCj4gZmFzdGVyIGFuZCBjb25zaXN0ZW50IGJv
b3RzLiAgIEkgaGF2ZSBub3Qgbm90aWNlZCBhIHVkZXYgcHJvY2Vzcwo+IGdldHRpbmcgYW4gZXJy
b3Igb3IgY2F1c2luZyBzb21ldGhpbmcgbGlrZSB5b3UgYXJlIHNlZWluZywgYnV0IGlmCj4gZW5v
dWdoIHByb2Nlc3MgZ2V0cyBzcGF3bmVkIGNhdXNpbmcgZXhjZXNzaXZlIHN5c3RlbSB0aW1lIGl0
IGNvdWxkCj4gY2F1c2UgdGltZW91dHMgaW4gdGhlIGtlcm5lbCBzdWJzeXN0ZW1zIHRoYXQgaGF2
ZSB0aW1lb3V0cy4KPiAKPiBwcyBheHV3d1MgfCBncmVwIC1pIHVkZXYKPiB3aWxsIHNob3cgeW91
IHRoZSB0b3RhbCB0aW1lIHVkZXYgYW5kIGFsbCBvZiBpdHMgZXhpdGVkIGNoaWxkcmVuCj4gY29s
bGVjdGVkIGR1cmluZyBib290LiAgSWYgdGhlIG51bWJlciBpcyBsYXJnZSBpbiB0aGUgc2hvcnQg
dGltZSBpdAo+IHRha2UgdG8gYm9vdCB0aGVyZSBpcyBtYXNzaXZlIGNvbnRlbnRpb24uCj4gCj4g
T24gV2VkLCBOb3YgNCwgMjAyMCBhdCA4OjMzIFBNIEJyaWFuIEJ1bmtlciA8YnJpYW5AcHVyZXN0
b3JhZ2UuY29tPiB3cm90ZToKPj4gCj4+IEhlbGxvIGFsbCwKPj4gCj4+IFdlIGhhdmUgcnVuIGlu
dG8gc2l0dWF0aW9ucyBpbnRlcm5hbGx5IHdoZXJlIHdlIGVuZCB1cCB3aXRoIFNDU0kgZGV2aWNl
cyBlbmRpbmcgdXAgaW4gdHdvIG11bHRpcGF0aCBkZXZpY2VzOgo+PiAKPj4gMzYyNGE5MzcwYzA3
ODc3MTAyYjE0MzY5OTAwMDExZmQxIGRtLTkgUFVSRSAgICAsRmxhc2hBcnJheQo+PiBzaXplPTUw
MEcgZmVhdHVyZXM9JzAnIGh3aGFuZGxlcj0nMSBhbHVhJyB3cD1ydwo+PiBgLSstIHBvbGljeT0n
c2VydmljZS10aW1lIDAnIHByaW89NTAgc3RhdHVzPWFjdGl2ZQo+PiAgfC0gMDowOjA6NiAgc2Rl
ZyAxMjg6MTI4IGFjdGl2ZSByZWFkeSBydW5uaW5nCj4+ICB8LSAwOjA6MTo2ICBzZGVxIDEyOToz
MiAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPj4gIHwtIDA6MDoyOjYgIHNkZmEgMTI5OjE5MiBhY3Rp
dmUgcmVhZHkgcnVubmluZwo+PiAgfC0gNzowOjA6NiAgc2R4ICA2NToxMTIgIGFjdGl2ZSByZWFk
eSBydW5uaW5nCj4+ICB8LSA3OjA6MTo2ICBzZGFoIDY2OjE2ICAgYWN0aXZlIHJlYWR5IHJ1bm5p
bmcKPj4gIHwtIDc6MDoyOjYgIHNkY2kgNjk6OTYgICBhY3RpdmUgcmVhZHkgcnVubmluZwo+PiAg
fC0gNzowOjM6NiAgc2RuICA4OjIwOCAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4+ICB8LSA4OjA6
MDo2ICBzZGJiIDY3OjgwICAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPj4gIHwtIDg6MDoxOjYgIHNk
YnQgNjg6MTEyICBhY3RpdmUgcmVhZHkgcnVubmluZwo+PiAgfC0gODowOjI6NiAgc2RjeCA3MDo4
MCAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4+ICB8LSA4OjA6Mzo2ICBzZGFyIDY2OjE3NiAgYWN0
aXZlIHJlYWR5IHJ1bm5pbmcKPj4gIHwtIDk6MDowOjYgIHNkZGogNzE6MTYgICBhY3RpdmUgcmVh
ZHkgcnVubmluZwo+PiAgfC0gOTowOjE6NiAgc2RjcSA2OToyMjQgIGFjdGl2ZSByZWFkeSBydW5u
aW5nCj4+ICB8LSA5OjA6Mjo2ICBzZGR0IDcxOjE3NiAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPj4g
IHwtIDk6MDozOjYgIHNkYm8gNjg6MzIgICBhY3RpdmUgcmVhZHkgcnVubmluZwo+PiAgYC0gMDow
OjM6NiAgc2RnICA4Ojk2ICAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4+IAo+PiBBbmQgdGhpcyBv
bmU6Cj4+IFNQVVJFX0ZsYXNoQXJyYXlfQzA3ODc3MTAyQjE0MzY5OTAwMDExRkQxIGRtLTEzIFBV
UkUgICAgLEZsYXNoQXJyYXkKPj4gc2l6ZT01MDBHIGZlYXR1cmVzPScwJyBod2hhbmRsZXI9JzEg
YWx1YScgd3A9cncKPj4gYC0rLSBwb2xpY3k9J3NlcnZpY2UtdGltZSAwJyBwcmlvPTUwIHN0YXR1
cz1hY3RpdmUKPj4gIGAtIDA6MDozOjYgIHNkZyAgODo5NiAgICBhY3RpdmUgcmVhZHkgcnVubmlu
Zwo+PiAKPj4gV2hhdCB0aGlzIGNvbWVzIGRvd24gdG8gc2VlbXMgdG8gbGllIHdpdGggdGhlIHNj
c2lfaWQgYXBwbGljYXRpb24gaW5jbHVkZWQgaW5jbHVkZWQgd2l0aCB1ZGV2LiBUaGlzIHJ1bnMg
b3V0IG9mIGEgdWRldiBydWxlIHdoZW4gU0NTSSBkZXZpY2VzIGFyZSBkaXNjb3ZlcmVkLiBXaGF0
IGhhcHBlbnMgc2VlbXMgdG8gYmUgYSBmYWlsdXJlIGluIHBhZ2UgMHg4MyBJTlFVSVJZIGluIGdl
dHRpbmcgdGhlIHNlcmlhbCBudW1iZXIgb2YgdGhlIGRldmljZSB0byB1c2UgaW4gbXVsdGlwYXRo
Lgo+PiAKPj4gV2hlbiBwYWdlIDB4ODMgSU5RVUlSWSBmYWlscywgaW5zdGVhZCBvZiBnZXR0aW5n
IHRoZSBleHBlY3RlZCAzNjI0YTkzNzBjMDc4NzcxMDJiMTQzNjk5MDAwMTFmZDEgaXQgZmFsbHMg
YmFjayB0byBhIHBhZ2UgMHg4MCBJTlFVSVJZIHdoZXJlIGl0IHN0aXRjaGVzIHRvZ2V0aGVyIOKA
mVPigJkgKyB2ZW5kb3IgbmFtZSArIG1vZGVsIG5hbWUgKyBMVU4gc2VyaWFsIG51bWJlciBhbmQg
d2UgZW5kIHVwIHdpdGggdGhpcyBTUFVSRV9GbGFzaEFycmF5X0MwNzg3NzEwMkIxNDM2OTkwMDAx
MUZEMS4KPj4gCj4+IEEgcXVpY2sgbG9vayBzaG93cyB0aGF0IHRoZSBMVU4gc2VyaWFsIG51bWJl
ciBpbiBib3RoIGNhc2VzIGlzIHRoZSBzYW1lLCBDMDc4NzcxMDJCMTQzNjk5MDAwMTFGRDEuIFdl
IGVuZCB1cCB3aXRoIHR3byBtdWx0aXBhdGggZGV2aWNlcyBzaW5jZSB0aGUgbmFtZSBtdWx0aXBh
dGggdXNlcyBpcyBub3QgdGhlIHNhbWUuIEkgY2FuIGNyZWF0ZSB0aGUgc2l0dWF0aW9uIG1hbnVh
bGx5IGJ5IHJlc2Nhbm5pbmcgYXQganVzdCB0aGUgcmlnaHQgdGltZSBmb3JjaW5nIHRoZSBwYWdl
IDB4ODMgSU5RVUlSWSB0byBmYWlsIHdoZW4gbWFudWFsbHkgcnVubmluZyBzY3NpX2lkLiBJIGFz
c3VtZSB0aGF0IHRoaXMgaXMgd2hhdCBoYXBwZW5zIGFzIHRoZSBkZXZpY2VzIGFycml2ZSBhbmQg
dGhlIHVkZXYgcnVsZSBydW5zIGJhc2VkIG9uIHRoZSBuYW1lLiBJIGFtIG5vdCBleGFjdGx5IHN1
cmUgd2hlcmUgaW4gdGhlIGNoYWluIHRvIGJsYW1lIGZvciB0aGUgY3JlYXRpb24gb2YgdGhlIHR3
byBtdWx0aXBhdGggZGV2aWNlcy4gSSBhbSBub3Qgc3VyZSB0aGF0IG11bHRpcGF0aCBpcyBub3Qg
anVzdCB0aGUgdmljdGltIG9mIHVkZXYsIGJ1dCBJIGV4cGVjdCB0aGF0IHRoaXMgYmVoYXZpb3Ig
aXMgbm90IHdoYXQgbXVsdGlwYXRoIHdvdWxkIGV2ZXIgd2FudCB0byBkbyBzaW5jZSBpdCBpcyBh
IGNlcnRhaW4gY29ycnVwdGlvbiB3aGVuIGl0IGhhcHBlbnMuCj4+IAo+PiBBbnkgaWRlYXMgb3Ig
aW5zaWdodCBvbiB3aGF0IGNvdWxkIGtlZXAgdXMgb3V0IG9mIHRoaXMgc2l0dWF0aW9uIHdvdWxk
IGJlIGFwcHJlY2lhdGVkLgo+PiAKPj4gVGhhbmtzLAo+PiBCcmlhbgo+PiAKPj4gQnJpYW4gQnVu
a2VyCj4+IFNXIEVuZwo+PiBicmlhbkBwdXJlc3RvcmFnZS5jb20KPj4gCj4+IAo+PiAKPj4gCj4+
IC0tCj4+IGRtLWRldmVsIG1haWxpbmcgbGlzdAo+PiBkbS1kZXZlbEByZWRoYXQuY29tCj4+IGh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAoKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

