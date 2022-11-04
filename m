Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF47C43219
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667562407;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=idTvg8P6fXF/bRFbK3Mz19L3tm/h/HE5CIjX+n0j2oo=;
	b=D4nO0Dka8vTYOoHTT8/GyJxBlTFjvQ1loRspQvasEzkUMeGFe4zd2veDsh0BJebBYXl3OS
	mNuJJkJz5pH1oW8i3sI2ZnE17xC+ifUQ4y91uLNIR0gKQH0SFu+6nfP3INpNPIVZPj++O6
	q3ZJbc/q/LSk6UWqca+wlhtyIpubxeY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-3Cz56_P3P6-EJg8rGrqONg-1; Fri, 04 Nov 2022 07:46:44 -0400
X-MC-Unique: 3Cz56_P3P6-EJg8rGrqONg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B3D18339CE;
	Fri,  4 Nov 2022 11:46:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 424EB4EA52;
	Fri,  4 Nov 2022 11:46:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E4FB01946587;
	Fri,  4 Nov 2022 11:46:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF3811946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:46:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8BDD40C6DC7; Fri,  4 Nov 2022 11:46:30 +0000 (UTC)
Received: from [10.43.17.48] (unknown [10.43.17.48])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 43EE140C6EE9;
 Fri,  4 Nov 2022 11:46:29 +0000 (UTC)
Message-ID: <49334506-8515-76e8-df4e-6d06dfbdc48b@redhat.com>
Date: Fri, 4 Nov 2022 12:46:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
To: Zhiyong Ye <yezhiyong@bytedance.com>, dm-devel@redhat.com
References: <62cc8b6c-edc6-5ee6-d9fd-d1e0819db36c@bytedance.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <62cc8b6c-edc6-5ee6-d9fd-d1e0819db36c@bytedance.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] Question about how to share dm-thin on multiple hosts
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDAzLiAxMS4gMjIgdiA4OjM1IFpoaXlvbmcgWWUgbmFwc2FsKGEpOgo+IEhpIGFsbCwKPgo+
IEkgYW0gbmV3IHRvIGRtLWRldmVsLiBXaGVuIHVzaW5nIGRtLXRoaW4gdmlhIGx2bSwgSSBmb3Vu
ZCBpdCBkaWZmaWN1bHQgdG8gCj4gc2hhcmUgZG0tdGhpbiBvbiBtdWx0aXBsZSBob3N0cy4KPgo+
IFRoZSBiYWNrZ3JvdW5kIGlzIHRoYXQgSSB3YW50IHRvIGltcGxlbWVudCBsaXZlIG1pZ3JhdGlv
biBvZiBWTXMgaW4gdGhlIGx2bSAKPiArIGlTQ1NJIGVudmlyb25tZW50LCBpbiB3aGljaCBsdm1s
b2NrZCBpcyB1c2VkIHRvIGNvb3JkaW5hdGUgYWNjZXNzIHRvIAo+IHNoYXJlZCBzdG9yYWdlLiBU
aGVyZSBhcmUgbXVsdGlwbGUgaG9zdHMgaW4gdGhlIGNsdXN0ZXIgdXNpbmcgdGhlIHNhbWUgaVND
U0kgCj4gY29ubmVjdGlvbiwgYW5kIHRoZSBWTXMgcnVubmluZyBpbiB0aGlzIGVudmlyb25tZW50
IHVzZSB0aGlubHYgdm9sdW1lcy4gQnV0IAo+IGlmIHdhbnQgdG8gbGl2ZSBtaWdyYXRlIHRoZSB2
bSwgaXQgd2lsbCBiZSBkaWZmaWN1bHQgc2luY2UgdGhpbmx2IHdoaWNoIGZyb20gCj4gdGhlIHNh
bWUgdGhpbiBwb29sIGNhbiBvbmx5IGJlIGV4Y2x1c2l2ZSBhY3RpdmUgb24gb25lIGhvc3QuCj4K
PiBJJ20gY3VyaW91cyB3aHkgdGhlIGRtLXRoaW4gZG9lc24ndCBzdXBwb3J0IG11bHRpLWhvc3Qg
c2hhcmVkIGFjY2VzcywganVzdCAKPiBsaWtlIHRoZSBkbS1saW5lYXIgZG9lcy4gSWYgSSB0cnkg
dG8gd3JpdGUgYSBuZXcgZG0tdGhpbiB0YXJnZXQgb3IgbWFrZSBzb21lIAo+IG1vZGlmaWNhdGlv
bnMgYmFzZWQgb24gdGhlIGV4aXN0aW5nIGRtLXRoaW4gdGFyZ2V0IHRvIHN1cHBvcnQgdGhpcyBm
ZWF0dXJlLCAKPiBpcyBpdCB0ZWNobmljYWxseSBmZWFzaWJsZT8gCgoKZG0tdGhpbsKgwqAgaXPC
oCB0aWdodGx5IGNvbm5lY3RlZCB3aXRoIHRoaW4tcG9vbCAtwqAgaXQncyBub3Qgc3RhbmRhbG9u
ZSB1bml0IAp0aGF0IGNhbiBsaXZlICd3aXRob3V0JyB0aGluLXBvb2wuCgpUaGluLXBvb2wgY3Vy
cmVudGx5IGRvZXMgTk9UIHN1cHBvcnTCoCAnc2hhcmVkL211bHRpaG9zdCcgYWN0aXZhdGlvbiBh
bmQgbXVzdCAKYmUgYWN0aXZhdGVkIGV4Y2x1c2l2ZWx5IG9uIGEgc2luZ2xlIGhvc3QgdG9nZXRo
ZXIgd2l0aCBhbGwgaXRzIHRoaW4gdm9sdW1lcy4KClNvIGF0IHRoaXMgbW9tZW50IHRoZXJlIGlz
IG5vIHdheSB5b3UgY2FuIGFjdGl2YXRlIHRoaW4tcG9vbCBvbiBtdWx0aXBsZSBob3N0cyAKd2l0
aG91dCBjYXVzaW5nIGEgc2VyaW91cyBtZXRhZGF0YSBjb3JydXB0aW9uIHRvIHRoZSB0aGluLXBv
b2wgKGFzIHRoZXJlIHdpbGwgCmJlIDIgcGFyYWxsZWwgdW5sb2NrZWQgc3RyZWFtIHVwZGF0ZXMp
LgoKVGhlcmUgaGFzIGJlZW4gYWxzbyBpbXBsZW1lbnRlZCBzb21lIGJhc2ljIGRldGVjdGlvbiB0
byBwcmV2ZW50ICdtdWx0aWhvc3QnIAphY3RpdmF0aW9uIGFuZCBhdm9pZCBkYW1hZ2UgdG8gdGhl
IG1ldGFkYXRhIGFzIHlvdSBhcmUgbm90IHRoZSBmaXJzdCBvbmUgd2hvIAp0cmllcyB0byBhY3Rp
dmF0ZSB0aGluLXBvb2wgb24gbW9yZSB0aGVuIG9uZSBtYWNoaW5lIGF0IGEgdGltZS4KClRoZXJl
IGhhdmUgYmVlbiBzb21lIGlkZWFzIGhvdyB0byBhbGxvd8KgICdtdXRsaWhvc3QnIHRoaW4tcG9v
bCBzdXBwb3J0IC0gYnV0IAp0aGV5IGFyZSByZWxhdGl2ZWx5IHZlcnkgZGlmZmljdWx0IHRvIGlt
cGxlbWVudCB3aXRoIGxvdyBhbW91bnQgb2YgYWN0dWFsIAp1c2Vycy9jdXN0b21lcnMgLSBzbyB0
aGV5IGFyZSBzb21ld2hhdCBxdWV1ZWQgZm9yIGxhdGVyIHRpbWUuLi4uCgpNZWFud2hpbGUgcG90
ZW50aWFsIGlkZWEgaG93IHRvIGltcGxlbWVudCBzdWNoIHRoaW5nIG1pZ2h0IGJlIHRvIGxvb2sg
YXTCoCAKYmxrLWFyY2hpdmUgcHJvamVjdCAoaHR0cHM6Ly9naXRodWIuY29tL2p0aG9ybmJlci9i
bGstYXJjaGl2ZSkKCgpSZWdhcmRzCgoKWmRlbmVrCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

