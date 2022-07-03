Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D41CCA47F
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eeLUVOjy5YKX9MZqnDtJT3cjsOhDtaoUCE4cKVpRxKE=;
	b=Pv1dVjyUSrcdFBP1zdtZIpMKGaZKu4Gi1Kfyq6E57L0XwkjHU+xGQpKk/4d8MI8UHNXJVz
	759BgrmbuNMucp4IHYl36TB6Ej8Y+OfOClxuG2XsyZtdGu3tLZjtjJkQL481l8uojL00Io
	YQRhwWeXZ6kW1lEXcb8uAffSAdhBC3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-TWpBLuInMiShlVN7Wis7QA-1; Wed, 06 Jul 2022 10:52:06 -0400
X-MC-Unique: TWpBLuInMiShlVN7Wis7QA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE1C2101AA69;
	Wed,  6 Jul 2022 14:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A0111121315;
	Wed,  6 Jul 2022 14:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3E10C1947067;
	Wed,  6 Jul 2022 14:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C2921947040
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Jul 2022 20:41:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E87A2492CA3; Sun,  3 Jul 2022 20:41:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4944492C3B
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 20:41:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC3C13806708
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 20:41:33 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr
 [80.12.242.125]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-237-3TbtmzavNhG3KPvdp2rRtA-1; Sun, 03 Jul 2022 16:41:32 -0400
X-MC-Unique: 3TbtmzavNhG3KPvdp2rRtA-1
Received: from [192.168.1.18] ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 86PIo6R3j5ohR86PIo6kvF; Sun, 03 Jul 2022 22:41:30 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 03 Jul 2022 22:41:30 +0200
X-ME-IP: 90.11.190.129
Message-ID: <effcd39c-7f86-5f69-0663-4b81015cfc7c@wanadoo.fr>
Date: Sun, 3 Jul 2022 22:41:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Yury Norov <yury.norov@gmail.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <98f5d3d855a9c687ccc035edf62016b02a6876b7.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsC0GpltMVaCPhkJ@yury-laptop>
 <4dc5d50a-2291-1d3a-efac-3f6378a15d69@wanadoo.fr>
 <YsGz1Xp0RDM5ZhVY@smile.fi.intel.com> <YsHqRDfCQVwyA2m1@yury-laptop>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YsHqRDfCQVwyA2m1@yury-laptop>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 3/4] bitmap: Introduce bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, gor@linux.ibm.com, linux@rasmusvillemoes.dk,
 hca@linux.ibm.com, snitzer@kernel.org, oberpar@linux.ibm.com,
 linux-kernel@vger.kernel.org, almaz.alexandrovich@paragon-software.com,
 dm-devel@redhat.com, svens@linux.ibm.com, vneethv@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

TGUgMDMvMDcvMjAyMiDDoCAyMToxMywgWXVyeSBOb3JvdiBhIMOpY3JpdMKgOgo+IE9uIFN1biwg
SnVsIDAzLCAyMDIyIGF0IDA2OjIwOjUzUE0gKzAzMDAsIEFuZHkgU2hldmNoZW5rbyB3cm90ZToK
Pj4gT24gU3VuLCBKdWwgMDMsIDIwMjIgYXQgMDg6NTA6MTlBTSArMDIwMCwgQ2hyaXN0b3BoZSBK
QUlMTEVUIHdyb3RlOgo+Pj4gTGUgMDIvMDcvMjAyMiDDoCAyMzowOSwgWXVyeSBOb3JvdiBhIMOp
Y3JpdMKgOgo+Pj4+IE9uIFNhdCwgSnVsIDAyLCAyMDIyIGF0IDA4OjI5OjM2UE0gKzAyMDAsIENo
cmlzdG9waGUgSkFJTExFVCB3cm90ZToKPj4KPj4gLi4uCj4+Cj4+Pj4gVGhpcyBzaG91bGQgYmUg
ZHJvcHBlZCwgZm9yIHN1cmUsIGFuZCBrbWFsbG9jKCkgYXQgbGluZSAxMjggc2hvdWxkIGJlCj4+
Pj4gcmVwbGFjZWQgd2l0aCBiaXRtYXBfYWxsb2MoKS4KPj4+Cj4+PiBUaGlzIGttYWxsb2MoKSBp
cyBmb3IgYSBzdHJ1Y3R1cmUgYW5kIGEgZmxleGlibGUgYXJyYXkuCj4+Pgo+Pj4gWW91IG1lYW4g
cmUtYXJyYW5naW5nIHRoZSBjb2RlIHRvIGFsbG9jYXRlIHRoZSBzdHJ1Y3R1cmUgYWxvbmUgYXQg
Zmlyc3QsCj4+PiB0aGVuIHRoZSBiaXRtYXA/Cj4gCj4gV2UgY2FuIGNoYW5nZSBzdHJ1Y3QgcHJp
bWVzIHRvOgo+ICAgICAgICAgIHN0cnVjdCBwcmltZXMgewo+ICAgICAgICAgICAgICAgICAgc3Ry
dWN0IHJjdV9oZWFkIHJjdTsKPiAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgbGFzdCwg
c3o7Cj4gICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nICpwcmltZXM7Cj4gICAgICAgICAg
fTsKPiAKPiBBbmQgdGhlbiBlaXRoZXIgYWxsb2NhdGUgdHdpY2U6Cj4gICAgICAgICAgbmV3ID0g
a21hbGxvYyhzaXplb2Yoc3RydWN0IHByaW1lcyk7Cj4gICAgICAgICAgbmV3LT5wcmltZXMgPSBi
aXRtYXBfYWxsb2Moc3opOwo+IAo+IE9yIGtlZXAgdGhlIHNhbWUgc3RydWN0IHByaW1lcyBmb3Ig
YWxsIGV4cGFuc2lvbnMsIGFuZCBqdXN0IGFsbG9jYXRlCj4gbmV3IGJpdG1hcCBmb3IgLT5wcmlt
ZXMgd2hlbiBuZWVkZWQuIFRoaXMgaXMgd2hhdCBJIG1lYW50Lgo+IAo+IFRoaXMgYSBiaXQgZGVl
cGVyIHJld29yaywgYnV0IGl0IGFkZHJlc3NlcyBBbmR5J3MgY29uY2VybiBhYm91dCBleGNlc3Np
dmUKPiBmcmFnbWVudGF0aW9uLiAoRGlkIGFueW9uZSBiZWZvcmUgY29tcGxhaW4/IElzIGl0IG1l
YXN1cmFibGU/KQo+IAo+PiBJdCdzIG9uZSB3YXksIGJ1dCBpdCB3aWxsIGluY3JlYXNlIGZyYWdt
ZW50YXRpb24gb2YgbWVtb3J5LiBUaGUgb3RoZXIgb25lCj4+IGFzIGl0IHNlZW1zIHRvIG1lIGlz
IHRvIG5hbWUgYSBuZXcgQVBJIHByb3Blcmx5LCBpLmUuIGJpdG1hcF9zaXplX3RvX2J5dGVzKCku
Cj4+Cj4+IEluIHN1Y2ggY2FzZSB5b3Ugd29uJ3QgbmVlZCByZW5hbWVzIHRvIGJlZ2luIHdpdGgu
IEFuZCB0aGVuIHdvdWxkIGJlIGFibGUKPj4gdG8gY29udmVydCBkcml2ZXItYnktZHJpdmVyIGlu
IGNhc2VzIG9mIGR1cGxpY2F0ZWQgY29kZS4KPj4KPj4gSSB0aGluayB0aGF0J3Mgd2hhdCBjb25m
dXNlZCBZdXJpIGFuZCBJIGtpbmRhIGFncmVlIHRoYXQgYml0bWFwX3NpemUoKSBzaG91bGQKPj4g
cmV0dXJuIGJpdHMsIGFuZCBub3QgYnl0ZXMuIEFsc28gYXJndW1lbnQgZm9yIHB1cmUgYml0bWFw
X3NpemUoKSB3b3VsZCBiZQo+PiBiaXRtYXAgaXRzZWxmLCBidXQgd2UgaGF2ZSBubyB3YXkgdG8g
ZGV0ZWN0IHRoZSBsZW5ndGggb2YgYml0bWFwIGJlY2F1c2Ugd2UKPj4gYXJlIHVzaW5nIFBPRCBh
bmQgbm90IGEgc3BlY2lmaWMgZGF0YSBzdHJ1Y3R1cmUgZm9yIGl0Lgo+IAo+IGJpdG1hcF9zaXpl
X3RvX2J5dGVzKCkgc291bmRzIGJldHRlci4gSG93IG1hbnkgcGxhY2VzIGluIHRoZSBrZXJuZWwK
PiBkbyB3ZSBoYXZlIHdoZXJlIHdlIGNhbid0IHNpbXBseSB1c2UgYml0bWFwX2FsbG9jKCksIGFu
ZCBuZWVkIHRoaXMKPiBtYWNoaW5lcnk/IElmIHRoaXMgaXMgdGhlIG9ubHkgb25lLCBJJ2QgcHJl
ZmVyIHRvIHN3aXRjaCBpdCB0bwo+IGJpdG1hcF9hbGxvYygpIGluc3RlYWQuCgpJJ2xsIHNwb3Qg
c29tZSBwbGFjZXMgdGhhdCB3b3VsZCByZXF1aXJlIGEgYml0bWFwX3NpemVfdG9fYnl0ZXMoKS4K
ClRoaXMgd2F5LCB3ZSdsbCBoYXZlIHNvbWUgbW9yZSBpbmZvcm1hdGlvbiB0byBkZWNpZGUgaWY6
CiAgICAtIGJpdG1hcF9zaXplX3RvX2J5dGVzKCkgbWFrZXMgc2Vuc2Ugb3Igbm90CiAgICAtIG90
aGVyIGhlbHBlciBmdW5jdGlvbnMgYXJlIGJldHRlciBzdWl0ZWQKICAgIC0gdGhlc2UgcGxhY2Vz
IG5lZWQgc29tZSByZXdvcmsgdG8gdXNlIHRoZSBleGlzdGluZyBBUEkKCkNKCgo+IAo+IFRoYW5r
cywKPiBZdXJ5Cj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

