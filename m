Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B477C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 08:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649664972;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rrh30xhdfY+TS35bGArnpfrxnng7YFUTA0+mFCVFcRs=;
	b=RGAoVr1Q/Qwq7m9/BF7WaeE/XDsOphf9U005+X2a7oGEz2QQaNgLV22yD9+UYIoNvUz+3v
	uFr0P8W0QF6E9E8vLKWYMp/FGwTDMHou5V5mxwJASQwWWzfwvyd0vv0/x+yuN7b4VsU/bK
	upmTRTEu1yoXcqjcDUPrlxEvXQs0nGs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-A-S_us7gPUGmEVwU1bJY8w-1; Mon, 11 Apr 2022 04:16:08 -0400
X-MC-Unique: A-S_us7gPUGmEVwU1bJY8w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D30FF3841D28;
	Mon, 11 Apr 2022 08:16:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BE5F41D40E;
	Mon, 11 Apr 2022 08:16:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53E0719451F2;
	Mon, 11 Apr 2022 08:16:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AED5519451F2
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 08:16:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8CC3541D410; Mon, 11 Apr 2022 08:16:05 +0000 (UTC)
Received: from [10.40.193.76] (unknown [10.40.193.76])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 08A7841D40E;
 Mon, 11 Apr 2022 08:16:04 +0000 (UTC)
Message-ID: <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
Date: Mon, 11 Apr 2022 10:16:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Joe Thornber <ejt@redhat.com>
References: <YlNUhtXltj8vgvcZ@itl-email>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <YlNUhtXltj8vgvcZ@itl-email>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDExLiAwNC4gMjIgdiAwOjAzIERlbWkgTWFyaWUgT2Jlbm91ciBuYXBzYWwoYSk6Cj4gRm9y
IHF1aXRlIGEgd2hpbGUsIEkgaGF2ZSB3YW50ZWQgdG8gd3JpdGUgYSB0b29sIHRvIG1hbmFnZSB0
aGluIHZvbHVtZXMKPiB0aGF0IGlzIG5vdCBiYXNlZCBvbiBMVk0uICBUaGUgbWFpbiB0aGluZyBo
b2xkaW5nIG1lIGJhY2sgaXMgdGhhdCB0aGUKPiBjdXJyZW50IGRtLXRoaW4gaW50ZXJmYWNlIGlz
IGV4dHJlbWVseSBlcnJvci1wcm9uZS4gIFRoZSBvbmx5IHBlci10aGluCj4gbWV0YWRhdGEgc3Rv
cmVkIGJ5IHRoZSBrZXJuZWwgaXMgYSAyNC1iaXQgdGhpbiBJRCwgYW5kIHVzZXJzcGFjZSBtdXN0
Cj4gdGFrZSBncmVhdCBjYXJlIHRvIGtlZXAgdGhhdCBJRCBpbiBzeW5jIHdpdGggaXRzIG93biBt
ZXRhZGF0YS4gIEZhaWx1cmUKPiB0byBkbyBzbyByZXN1bHRzIGluIGRhdGEgbG9zcywgZGF0YSBj
b3JydXB0aW9uLCBvciBldmVuIHNlY3VyaXR5Cj4gdnVsbmVyYWJpbGl0aWVzLiAgRnVydGhlcm1v
cmUsIGhhdmluZyB0byBzdXNwZW5kIGEgdGhpbiB2b2x1bWUgYmVmb3JlCj4gb25lIGNhbiB0YWtl
IGEgc25hcHNob3Qgb2YgaXQgY3JlYXRlcyBhIGNyaXRpY2FsIHNlY3Rpb24gZHVyaW5nIHdoaWNo
Cj4gdXNlcnNwYWNlIG11c3QgYmUgdmVyeSBjYXJlZnVsLCBhcyBJL08gb3IgYSBjcmFzaCBjYW4g
bGVhZCB0byBkZWFkbG9jay4KPiBJIGJlbGlldmUgYm90aCBvZiB0aGVzZSBwcm9ibGVtcyBjYW4g
YmUgc29sdmVkIHdpdGhvdXQgb3Zlcmx5Cj4gY29tcGxpY2F0aW5nIHRoZSBrZXJuZWwgaW1wbGVt
ZW50YXRpb24uCgoKSGkKClRoZXNlIHRoaW5ncyBhcmUgY29taW5nIHdpdGggaW5pdGlhbCBkZXNp
Z24gb2Ygd2hvbGUgRE0gd29ybGQgLSB3aGVyZSB0aGVyZSBpcyAKYSBzcGxpdCBvZiBjb21wbGV4
aXR5IGJldHdlZW4ga2VybmVsICYgdXNlci1zcGFjZS4gU28gcHJvamVjdHMgbGlrZSBidHJmcywg
ClpGUywgZGVjaWRlZCB0byBnbyB0aGUgb3RoZXIgd2F5IGFuZCBjcmVhdGUgYSBtb25vbGl0aGlj
ICdhbGwtaW4tb25lJyAKc29sdXRpb24sIHdoZXJlIHRoZXkgYXZvaWQgc29tZSBwcm9ibGVtcyBy
ZWxhdGVkIHdpdGggY29tbXVuaWNhdGlvbiBiZXR3ZWVuIAprZXJuZWwgJiB1c2VyLXNwYWNlIC0g
YnV0IGF0IHRoZSBwcmljZSBvZiBoYXZpbmcgYSBwcmV0dHkgY29tcGxpY2F0ZWQgYW5kIHZlcnkg
CmhhcmQgdG8gZGV2ZWwgJiBkZWJ1Z8KgIGtlcm5lbCBjb2RlLgoKU28gbGV0IG1lIGV4cGxhaW4g
b25lIG9mIHRoZSByZWFzb25zLCB3ZSBoYXZlIHRoaXMgbG9naWMgd2l0aCBzdXNwZW5kIGlzIHRo
aXMgCmJhc2ljIHByaW5jaXBsZToKCndyaXRlIG5ldyBsdm0gbWV0YWRhdGEgLT7CoCBzdXNwZW5k
ICh3aXRoIGFsbCB0YWJsZSBwcmVsb2FkcykgLT7CoCBjb21taXTCoCBuZXcgCmx2bTIgbWV0YWRh
dGEgLT4gcmVzdW1lCgp3aXRoIHRoaXMgd2UgZW5zdXJlIHRoZSB1c2VyIHNwYWNlIG1haW50YWlu
IHRoZSBvbmx5IHZhbGlkICd2aWV3JyBvZiBtZXRhZGF0YS4KCllvdXIgcHJvcG9zYWwgYWN0dWFs
bHkgYnJlYWtzIHRoaXMgc2VxdWVuY2UgYW5kIHdvdWxkIG1vdmUgdGhpbmdzIHRvIHRoZSBzdGF0
ZSAKb2bCoCAnZ3Vlc3MgYXQgd2hpY2ggc3RhdGVzIHdlIGFyZSBub3cnLiAoYW5kIElNSE8gcHJl
c2VudHMgbXVjaCBtb3JlIHJpc2sgdGhhbiAKdmlydHVhbCBwcm9ibGVtIHdpdGggc3VzcGVuZCBm
cm9tIHVzZXItc3BhY2UgLSB3aGljaCBpcyBvbmx5IGEgcHJvYmxlbSBpZiB5b3UgCmFyZSB1c2lu
ZyBzdXNwZW5kZWQgZGV2aWNlIGFzICdzd2FwJyBhbmQgJ3Jvb3RmcycgLSBzbyB0aGVyZSBhcmUg
dmVyeSBlYXN5IAp3YXlzIGhvdyB0byBvcmNoZXN0cmF0ZSB5b3VyIExWcyB0byBhdm9pZCBzdWNo
IHByb2JsZW1zKS4KCkJhc2ljYWxseSB5b3UgYXJlIGVzc2VudGlhbGx5IHdhbnRpbmcgdG8gbW92
ZSB3aG9sZSBtYW5hZ2VtZW50IGludG8ga2VybmVsIGZvciAKc29tZSBub3Qgc28gZ3JlYXQgc3Bl
ZWQgZ2FpbnMgKHJlbGF0ZWQgdG8gdGhlIHJlc3Qgb2YgdGhlIHJ1bm5pbmcgc3lzdGVtIChhbmQg
CnlvdSBjYW4gY2VydGFpbmx5IGRvIHRoYXQgYnkgd3JpdGluZyB5b3VyIG93biBrZXJuZWwgbW9k
dWxlIHRvIG1hbmFnZSB5b3VyIApyYXRlaHIgdW5pcXVlIHNvZnR3YXJlIHByb2JsZW0pCgpCdXQg
SU1ITyBjcmVhdGlvbiBhbmQgcmVtb3ZhbCBvZiB0aG91c2FuZHMgb2YgZGV2aWNlcyBpbiB2ZXJ5
IHNob3J0IHBlcmlvZCBvZiAKdGltZSByYXRoZXIgc3VnZ2VzdCB0aGVyZSBpcyBzb21ldGhpbmcg
c3ViLW9wdGltYWwgaW4geW91ciBvcmlnaW5hbCBzb2Z0d2FyZSAKZGVzaWduIGFzIEknbSByZWFs
bHkgaGF2aW5nIGhhcmQgdGltZSBpbWFnaW5pbmcgd2h5IHdvdWxkIHlvdSBuZWVkIHRoaXMgPwoK
SWYgeW91IHdpc2ggdG8gb3BlcmF0ZSBsb3RzIG9mIGRldmljZXMgLSBrZWVwIHRoZW0gc2ltcGx5
IGNyZWF0ZWQgYW5kIHJlYWR5IC0gCmFuZCBldmVudHVhbGx5IGJsa2Rpc2NhcmQgdGhlbSBmb3Ig
bmV4dCBkZXZpY2UgcmV1c2UuCgpJJ20gYWxzbyB1bnN1cmUgZnJvbSB3aGVyZSB3b3VsZCBhcmlz
ZSBhbnkgc3BlY2lhbCBuZWVkIHRvIGluc3RhbnRpYXRlwqAgdGhhdCAKbWFueSBzbmFwc2hvdHMg
LcKgIGlmIHRoZXJlIGlzIHNvbWUgdmFsaWQgJiBsb2dpY2FsIHB1cnBvc2UgLcKgwqAgbHZtMiBj
YW4gaGF2ZSAKZXh0ZW5kZWQgdXNlciBzcGFjZSBBUEkgdG8gY3JlYXRlIG11bHRpcGxlIHNuYXBz
aG90cyBhdCBvbmNlIG1heWJlIChzbyBpLmUuwqDCoMKgIApjcmVhdGXCoCAxMCBzbmFwc2hvdHPC
oMKgIHdpdGjCoMKgwqDCoMKgIG5hbWUtJWTCoCBvZiBhIHNpbmdsZSB0aGluTFYpCgpOb3QgdG8g
bWVudGlvbmluZyBvcGVyYXRpbmcgdGhhdCBtYW55IHRoaW4gdm9sdW1lcyBmcm9tIGEgc2luZ2xl
IHRoaW4tcG9vbCBpcyAKYWxzbyBub3RoaW5nIGNsb3NlIHRvIGhpZ2ggcGVyZm9ybWFuY2UgZ29h
bCB5b3UgdHJ5IHRvIHJlYWNoLi4uCgpSZWdhcmRzCgpaZGVuZWsKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

