Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9ADC61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678129468;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A3IC1ER/sLUViD739XRYeUhjJvKyMsQ9atvCGAo+IjY=;
	b=HuBnHUcWXvierL202sSM9ufE246hCqkKQN8/SUqggFcT7uvPHpI3gVqlyywum3lvDwpsxK
	B46hp44p5kUIRfUv9Zcg96/q7YrIosU9lL/K2ujCUJF7zollh7HjTKywtSwRq6it9xMU5H
	3sz5Rb4PF/NgcseQuyQxofjfdHUGQHE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-Y0l9g4jvO0OSsnMzU5YtJA-1; Mon, 06 Mar 2023 14:04:23 -0500
X-MC-Unique: Y0l9g4jvO0OSsnMzU5YtJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7C8E101B42B;
	Mon,  6 Mar 2023 19:04:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7BFA2166B26;
	Mon,  6 Mar 2023 19:04:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7923E194658C;
	Mon,  6 Mar 2023 19:04:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F3801946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 19:04:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4FFF112132D; Mon,  6 Mar 2023 19:04:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B4C01121314;
 Mon,  6 Mar 2023 19:04:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 326J4E33010359;
 Mon, 6 Mar 2023 13:04:14 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 326J4Dwv010358;
 Mon, 6 Mar 2023 13:04:13 -0600
Date: Mon, 6 Mar 2023 13:04:13 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230306190413.GL17327@octiron.msp.redhat.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
 <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
Cc: dm-devel@redhat.com, Brian Bunker <brian@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXIgMDYsIDIwMjMgYXQgMTI6NDY6NTBQTSArMDEwMCwgTWFydGluIFdpbGNrIHdy
b3RlOgo+IEhpIEJyaWFuLAo+IAo+IE9uIFNhdCwgMjAyMy0wMy0wNCBhdCAxMjo0OSAtMDgwMCwg
QnJpYW4gQnVua2VyIHdyb3RlOgo+ID4gPiAKPiA+IFRoZSBjaGVja2luZyBmb3Igc3RhbmRieSBp
cyAxNCB5ZWFycyBvbGQsIGFuZCBzYXlzIHRoYXQgVFVSIHJldHVybnMKPiA+IGEgdW5pdCBhdHRl
bnRpb24gd2hlbiB0aGUgcGF0aCBpcyBpbiBzdGFuZGJ5LiBJIGFtIG5vdCBzdXJlIHdoeSB0aGF0
Cj4gPiB3b3VsZG7igJl0IGJlIGhhbmRsZWQgYnkgdGhpcyBjb2RlIGFib3ZlOiBJIHdvdWxkIHRo
aW5rIHRoZXJlIHNob3VsZCBiZQo+ID4ganVzdCBvbmUgdW5pdCBhdHRlbnRpb24gZm9yIGVhY2gg
SV9UX0wgd2hlbiBhbiBBTFVBIHN0YXRlIGNoYW5nZQo+ID4gaGFwcGVucy5Ob3Qgc3VyZSBob3cg
aXQgZXhjZWVkcyB0aGUgcmV0cnkgY291bnQuCj4gPiAKPiA+IGlmIChrZXkgPT0gMHg2KSB7Cj4g
PiDCoMKgwqAgLyogVW5pdCBBdHRlbnRpb24sIHJldHJ5ICovCj4gPiDCoMKgwqAgaWYgKOKAlHJl
dHJ5X3R1cikKPiA+IMKgwqDCoMKgwqDCoMKgIGdvdG8gcmV0cnk7Cj4gPiB9Cj4gPiAKPiA+IEZy
b20gbXkgcGVyc3BlY3RpdmUgZmFpbGluZyBhIHBhdGggZm9yIEFMVUEgc3RhdGUgc3RhbmRieSBp
cwo+ID4gcmVhc29uYWJsZQo+ID4gc2luY2UgaXQgaXMgbm90IGFuIGFjdGl2ZSBzdGF0ZS4KPiAK
PiBJIHRoaW5rIHRoZSBoaXN0b3JpYyByYXRpb25hbGUgZm9yIHVzaW5nIEdIT1NUIGlzIHRoYXQg
c29tZSBzdG9yYWdlCj4gYXJyYXlzLCBpbiBwYXJ0aWN1bGFyIGFjdGl2ZS1wYXNzaXZlIGNvbmZp
Z3VyYXRpb25zLCBtYXkga2VlcCBjZXJ0YWluCj4gcG9ydCBncm91cHMgaW4gU1RBTkRCWSBzdGF0
ZS4gSWYgU1RBTkRCWSB3YXMgY2xhc3NpZmllZCBhcyBGQUlMRUQsCj4gIm11bHRpcGF0aCAtbGwi
IHdvdWxkIHNob3cgYWxsIHBhdGhzIG9mIHN1Y2ggcG9ydCBncm91cHMgYXMgRkFJTEVELAo+IHdo
aWNoIHdvdWxkIGNvbmZ1c2UgdXNlcnMuCj4gCj4gVGhhdCdzIHdoYXQgSSBtZWFudCBiZWZvcmUs
IG11bHRpcGF0aCdzIEdIT1NUIGNhbiBtZWFuIG11bHRpcGxlIHRoaW5ncwo+IGRlcGVuZGluZyBv
biB0aGUgYWN0dWFsIGhhcmR3YXJlIGluIHVzZSwgZXhwbGljaXQvaW1wbGljaXQgQUxVQSwgZXRj
Lgo+IEdpdmVuIHRoYXQgdG9kYXkgYmFzaWNhbGx5IGV2ZXJ5IGhhcmR3YXJlIHN1cHBvcnRzIEFM
VUEsIHdlIGNvdWxkCj4gcHJvYmFibHkgZG8gYmV0dGVyLiBCdXQgY2hhbmdpbmcgdGhlIHNlbWFu
dGljcyBpbiB0aGUgY3VycmVudCBzaXR1YXRpb24KPiBpcyByaXNreSBhbmQgZXJyb3IgcHJvbmUu
CgpJIGFtIHN5bXBhdGhldGljIHRvIE1hcnRpbidzIHZpZXcgdGhhdCBHSE9TVCBpcyBhbiBhbWJp
Z3VvdXMgc3RhdGUsIGFuZAppdCdzIG5vdCBhdCBhbGwgY2xlYXIgdGhhdCBpbiBtZWFucyAidGVt
cG9yYXJpbHkgYmV0d2VlbiBzdGF0ZXMiLiBJbgpmYWN0LCBpdCB1c3VzYWxseSBkb2Vzbid0LiAg
T24gdGhlIG90aGVyIGhhbmQsIGlmIHdlIGNhbiBiZSBwcmV0dHkKY2VydGFpbiB0aGF0IGRldmlj
ZXMgd29uJ3Qga2VlcCBwYXRocyBpbiB0aGUgVFJBTlNJVElPTklORyBzdGF0ZSBmb3IgYW4KZXh0
ZW5kZWQgdGltZSwgYnV0IHdlIGNhbid0IGJlIGNlcnRhaW4gd2hhdCB0aGUgZW5kIHN0YXRlIHdp
bGwgYmUsIEkgZG8Kc2VlIHRoZSByYXRpb25hbGUgZm9yIG5vdCBmYWlsaW5nIHRoZW0gcHJlZW10
aXZlbHkuIAoKSSB3b25kZXIgaWYgUEFUSF9QRU5ESU5HIG1ha2VzIG1vcmUgc2Vuc2UuICBXZSB3
b3VsZCByZXRhaW4gdGhlIGV4aXN0aW5nCnN0YXRlIHVudGlsIHRoZSBwYXRoIGxlZnQgdGhlIFRS
QU5TSVRJT05JTkcgc3RhdGUuICBUaGUgcXVlc3Rpb24gaXMsIGFyZQp5b3UgdHJ5aW5nIHRvIG1h
a2UgcGF0aHMgdGhhdCBhcmUgdHJhbnNpdGlvbmluZyBvdXQgb2YgYSBmYWlsZWQgc3RhdGUKY29t
ZSBiYWNrIHNvb25lciwgb3IgYXJlIHlvdSB0cnlpbmcgdG8ga2VlcCBwYXRocyB0aGF0IHdlcmUg
aW4gYSBhY3RpdmUKc3RhdGUgZnJvbSBiZWluZyBwcmV2ZW10aXZlbHkgZmFpbGVkLiAgVXNpbmcg
UEFUSF9QRU5ESU5HIHdvbid0IGZpeCB0aGUKZmlyc3QgY2FzZSwgb25seSB0aGUgc2Vjb25kLgoK
UEFUSF9QRU5ESU5HIG1ha2VzIHN1cmUgdGhhdCBpZiBJTyB0byB0aGUgcGF0aCBkb2VzIHN0YXJ0
IGZhaWxpbmcsIHRoZQpjaGVja2VyIHdvbid0IGtlZXAgc2V0dGluZyB0aGUgcGF0aCBiYWNrIHRv
IGFuIGFjdGl2ZSBzdGF0ZSBhZ2Fpbi4gIEl0CmFsc28gYXZvaWRzIHRoZSBhbm90aGVyIEdIT1NU
IGlzc3VlLCB3aGVyZSB0aGUgcGF0aCB3b3VsZCBlbmQgdXAgYmVpbmcKZ3JvdXBlZCB3aXRoIGFu
eSBhY3R1YWxseSBwYXNzaXZlIHBhdGhzLCB3aGljaCBpc24ndCB3aGF0IHdlJ3JlIGxvb2tpbmcK
Zm9yLgoKVGhlIG9uZSBwcm9ibGVtIEkgY2FuIHRoaW5rIG9mIG9mZiB0aGUgdG9wIG9mIG15IGhl
YWQgd291bGQgYmUgdGhhdCBpZgp0aGUgZGV2aWNlIHdhcyBoZWxkIGluIHRoZSBUUkFOU0lTVElP
TklORyBzdGF0ZSBmb3IgYSBsb25nIHRpbWUsCm11bHRpcGF0aGQgd291bGQga2VlcCBjaGVja2lu
ZyBpdCBjb25zdGFudGx5LCBzaW5jZSBQQVRIX1BFTkRJTkcgaXMKcmVhbGx5IG1lYW50IGZvciBj
YXNlcyB3aGVyZSB0aGUgY2hlY2tlciBoYXNuJ3QgY29tcGxldGVkIHlldCwgYW5kIHdlCmp1c3Qg
d2FudCB0byBrZWVwIGxvb2tpbmcgZm9yIHRoZSByZXN1bHQuIEkgc3VwcG9zZSBpdCB3b3VsZCBi
ZSBwb3NzaWJsZQp0byBhZGQgYW5vdGhlciBzdGF0ZSB0aGF0IHdvcmtlZCBqdXN0IGxpa2UgcGVu
ZGluZyAoYW5kIGNvdWxkIGV2ZW4gZ2V0CmNvbnZlcnRlZCB0byBQQVRIX1BFTkRJTkcgaWYgdGhl
cmUgd2FzIG5vIG90aGVyIHN0YXRlIHRvIGJlIGNvbnZlcnRlZAp0bykgYnV0IGRpZG4ndCBjYXVz
ZSB1cyB0byByZXRpZ2dlciB0aGUgY2hlY2tlciBzbyBxdWlja2x5LiAgQnV0IGlmCmRldmljZXMg
cmVhbGx5IHdpbGwgb25seSBiZSBpbiBUUkFOU0lUSU9OSU5HIGZvciBhIHNob3J0IHRpbWUsIGl0
IG1pZ2h0Cm5vdCBldmVuIGJlIGFuIGlzc3VlIHdlIGhhdmUgdG8gd29ycnkgYWJvdXQuCgpUaG91
Z2h0cz8KCi1CZW4KCj4gCj4gUmVnYXJkcwo+IE1hcnRpbgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

