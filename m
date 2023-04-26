Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12FDC77B60
	for <dm-devel@archiver.kernel.org>; Fri, 28 Apr 2023 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682696094;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3K47UbZE9s2doIqGsbam2SyWsy15knEjBWTnw4eTsVc=;
	b=gyrw4sPR6uw2giHxft0KKMmRkAkDmcmrXqsTzc1+qi6BsJrkGdbY51IzcgAfifnD1QbhOs
	wpIJNU+h4oytii1zDKNoJWKGlWbIKk3xa8gVaS9ttDTNSkCarQ7ObKc4viKkfSj3vuYl/K
	iP/FHCLm07/vE+g1VN7zhMCzvcDOmQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-MNh4nOV9MZCUXJmnszpLzA-1; Fri, 28 Apr 2023 11:34:52 -0400
X-MC-Unique: MNh4nOV9MZCUXJmnszpLzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37AB310B02A7;
	Fri, 28 Apr 2023 15:34:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B627240C6EC4;
	Fri, 28 Apr 2023 15:34:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 49B311946A49;
	Fri, 28 Apr 2023 15:34:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C990C19465BD
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Apr 2023 12:13:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5ED4492B0F; Wed, 26 Apr 2023 12:13:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F07C492B03
 for <dm-devel@redhat.com>; Wed, 26 Apr 2023 12:13:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 830B13C11786
 for <dm-devel@redhat.com>; Wed, 26 Apr 2023 12:13:24 +0000 (UTC)
Received: from new1-smtp.messagingengine.com (new1-smtp.messagingengine.com
 [66.111.4.221]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-8hG7LPQSMieOV6pztnxElQ-1; Wed, 26 Apr 2023 08:13:22 -0400
X-MC-Unique: 8hG7LPQSMieOV6pztnxElQ-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailnew.nyi.internal (Postfix) with ESMTP id 5C12D58233B;
 Wed, 26 Apr 2023 08:13:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute4.internal (MEProxy); Wed, 26 Apr 2023 08:13:21 -0400
X-ME-Sender: <xms:YBVJZBZmym39ZaHxDbi03oR7kW33DOgftCjtn333_xgZRIa888VtSA>
 <xme:YBVJZIZXIw9dhLo0QHGG44HNIi4k3_4rV4z-eWhqPqKkruCcP8Tx4cnSmDWbMC8jW
 UUPzj3zr-KzSIkqJyU>
X-ME-Received: <xmr:YBVJZD8Alw3i6vp4YMKYdtaM4wF3CNVtiBfbBaWVnjJZk5XM7NiaqB9gp1Y2mVK0NgZdn_cs4b_QWm0K-ixcnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedugedggeekucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvfevuffkfhggtggugfgjsehtkefstddttdejnecuhfhrohhmpefuhhhi
 nhdkihgthhhirhhoucfmrgifrghsrghkihcuoehshhhinhhitghhihhrohesfhgrshhtmh
 grihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeeutefhheeulefgleegjefgiedthfef
 keffgfdvvedufeekheejueejtdfhteetudenucffohhmrghinhepghhithhhuhgsrdgtoh
 hmpdhgihhtlhgrsgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
 mhgrihhlfhhrohhmpehshhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:YBVJZPoge5T2BQrc15xhbT_J0WXzfKzQu7wQ_dePm1YXwZa2t7qLLg>
 <xmx:YBVJZMpqyUaxxgJZe-68lQYAr9iAsRbnik0DY31X5PFjzdica2zffQ>
 <xmx:YBVJZFSQ0jj4eHUPQCk2sjjOXKPybkXV5dWCUA5uPiY8R8Os1wjudg>
 <xmx:YRVJZJhD6D9RJISmFEnc-d2mtIxSbPUj_JhgH0XHqXa-OC8KTkckNg>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Apr 2023 08:13:17 -0400 (EDT)
Date: Wed, 26 Apr 2023 21:13:14 +0900
From: Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <s4h5gehehwrto4h4vzs3cgfbeibtvrusgo5u5zus7afs3qzaio@nyy4xmikwyyo>
References: <20221230065424.19998-1-yukuai1@huaweicloud.com>
 <20230112010554.qmjuqtjoai3qqaj7@shindev>
 <6ccff2ec-b4bd-a1a6-5340-b9380adc1fff@huaweicloud.com>
 <oklvotdaxnncrugr2v7yqadzyfa5vvzrumrfv46vrzowjw3njo@tlvhd4eo5spl>
 <ZEgMuvNCud3fNdl4@redhat.com>
 <a8f2ca5c-0ae8-47af-d6c8-f9430c19ff64@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <a8f2ca5c-0ae8-47af-d6c8-f9430c19ff64@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 28 Apr 2023 15:34:03 +0000
Subject: Re: [dm-devel] [PATCH blktests] dm: add a regression test
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
Cc: "hch@infradead.org" <hch@infradead.org>,
 "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 Mike Snitzer <snitzer@kernel.org>, Joe Thornber <ejt@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Yu Kuai <yukuai1@huaweicloud.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
 "yukuai \(C\)" <yukuai3@huawei.com>, Li Lingfeng <lilingfeng3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fastmail.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gQXByIDI2LCAyMDIzIC8gMDg6NDIsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiBPbiA0
LzI1LzIzIDEwOjI0LCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gPiBPbiBUdWUsIEFwciAyNSAyMDIz
IGF0ICA4OjE1UCAtMDQwMCwKPiA+IFNoaW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvQGZh
c3RtYWlsLmNvbT4gd3JvdGU6Cj4gPgo+ID4+IE9uIEFwciAyNSwgMjAyMyAvIDE2OjIyLCBZdSBL
dWFpIHdyb3RlOgo+ID4+PiBIaSwKPiA+Pj4KPiA+Pj4g5ZyoIDIwMjMvMDEvMTIgOTowNSwgU2hp
bmljaGlybyBLYXdhc2FraSDlhpnpgZM6Cj4gPj4+PiBIZWxsbyBZdSwgdGhhbmtzIGZvciB0aGUg
cGF0Y2guIEkgdGhpbmsgaXQgaXMgZ29vZCB0byBoYXZlIHRoaXMgdGVzdCBjYXNlIHRvCj4gPj4+
PiBhdm9pZCByZXBlYXRpbmcgdGhlIHNhbWUgcmVncmVzc2lvbi4gUGxlYXNlIGZpbmQgbXkgY29t
bWVudHMgaW4gbGluZS4KPiA+Pj4+Cj4gPj4+PiBDQys6IE1pa2UsIGRtLWRldmVsLAo+ID4+Pj4K
PiA+Pj4+IE1pa2UsIGNvdWxkIHlvdSB0YWtlIGEgbG9vayBpbiB0aGlzIG5ldyB0ZXN0IGNhc2U/
IEl0IGFkZHMgImRtIiB0ZXN0IGdyb3VwIHRvCj4gPj4+PiBibGt0ZXN0cy4gSWYgeW91IGhhdmUg
dGhvdWdodHMgb24gaG93IHRvIGFkZCBkZXZpY2UtbWFwcGVyIHJlbGF0ZWQgdGVzdCBjYXNlcwo+
ID4+Pj4gdG8gYmxrdGVzdHMsIHBsZWFzZSBzaGFyZSAoT3Igd2UgbWF5IGJlIGFibGUgdG8gZGlz
Y3VzcyBsYXRlciBhdCBMU0YgMjAyMykuCj4gPj4+IENhbiB3ZSBhZGQgImRtIiB0ZXN0IGdyb3Vw
IHRvIGJsa3Rlc3RzPyBJJ2xsIHNlbmQgYSBuZXcgdmVyc2lvbiBpZiB3ZQo+ID4+PiBjYW4uCj4g
Pj4gSSBzdWdnZXN0IHRvIHdhaXQgZm9yIExTRiBkaXNjdXNzaW9uIGluIE1heSwgd2hpY2ggY291
bGQgYmUgYSBnb29kIGNoYW5jZSB0bwo+ID4+IGhlYXIgb3BpbmlvbnMgb2YgZG0gZXhwZXJ0cy4g
SSB0aGluayB5b3VyIG5ldyB0ZXN0IGNhc2UgaXMgdmFsdWFibGUsIHNvIElNTyBpdAo+ID4+IHNo
b3VsZCBiZSBhZGRlZCB0byB0aGUgbmV3ICJkbSIgZ3JvdXAsIG9yIGF0IGxlYXN0IHRvIHRoZSBl
eGlzdGluZyAiYmxvY2siCj4gPj4gZ3JvdXAuIExldCdzIGRlY2lkZSB0aGUgdGFyZ2V0IGdyb3Vw
IGFmdGVyIExTRi4KPiA+Pgo+ID4gSXQncyBvYnZpb3VzbHkgZmluZSB0byBhZGQgYSBuZXcgImRt
IiB0ZXN0IGdyb3VwIHRvIGJsa3Rlc3RzLgoKTWlrZSwgdGhhbmtzIGZvciB0aGUgcG9zaXRpdmUg
Y29tbWVudC4gTm93IEkga25vdyB0aGF0IHRoZXJlIGFyZSB2YXJpb3VzCnRlc3RzdWl0ZXMgcmVs
YXRlZCB0byBkbSBhcyB5b3Ugbm90ZWQgYmVsb3cuIEkgdGhpbmsgdGhlIG5ldyBkbSB0ZXN0IGdy
b3VwIGluCmJsa3Rlc3RzIGNhbiBoYXZlIGRpZmZlcmVudCBjb3ZlcmFnZSBmcm9tIG90aGVyIGRt
IHJlbGF0ZWQgdGVzdHN1aXRlczogdGVzdHMgdG8KY29uZmlybSBmaXhlcyBmb3IgZmFpbHVyZXMg
cmVsYXRlZCB0byBibG9jayBsYXllciBhbmQgZGV2aWNlLW1hcHBlci4gVGhlIG5ldwp0ZXN0IFl1
IEt1YWkgc3VnZ2VzdHMgd2lsbCBmaXQgaW50byBpdC4KCll1LCBjb3VsZCB5b3UgcG9zdCB0aGUg
bmV3IHZlcnNpb24gb2YgeW91ciBwYXRjaD8gTGV0J3MgYWRkIHRoZSBkbSBncm91cCBhbmQgdGhl
CmZpcnN0IHRlc3QgY2FzZS4KCj4gPgo+ID4gQnV0IGp1c3Qgc28gb3RoZXJzIGFyZSBhd2FyZTog
bW9yZSBlbGFib3JhdGUgZG0gdGVzdGluZyBpcyBjdXJyZW50bHkKPiA+IHNwcmVhZCBhY3Jvc3Mg
bXVsdGlwbGUgdGVzdHN1aXRlcyAoZS5nLiBsdm0yLCBjcnlwdHNldHVwLCBtcHRlc3QsCj4gPiBk
ZXZpY2UtbWFwcGVyLXRlc3Qtc3VpdGUsIGV0YykuCgpUaGFua3MuIEdvb2QgdG8ga25vdyB0aGF0
IGRtIHRlc3QgaGFzIHdpZGUgdmFyaWV0aWVzLiBJIGZvdW5kIHRoZSB0ZXN0c3VpdGVzIG9uCnRo
ZSBuZXQuIFdpbGwgdHJ5IHRvIGxvb2sgaW50byB0aGVtLgoKWzFdIGx2bTI6IGh0dHBzOi8vZ2l0
aHViLmNvbS9sdm10ZWFtL2x2bTIvdHJlZS9tYXN0ZXIvdGVzdApbMl0gY3J5cHRzZXR1cDogaHR0
cHM6Ly9naXRsYWIuY29tL2NyeXB0c2V0dXAvY3J5cHRzZXR1cC8tL3RyZWUvbWFpbi90ZXN0cwpb
M10gbXB0ZXN0OiBodHRwczovL2dpdGh1Yi5jb20vc25pdG0vbXB0ZXN0Cls0XSBkZXZpY2UtbWFw
cGVyLXRlc3Qtc3VpdGU6IGh0dHBzOi8vZ2l0aHViLmNvbS9qdGhvcm5iZXIvZGV2aWNlLW1hcHBl
ci10ZXN0LXN1aXRlCgo+ID4KPiA+IFRoZXJlIGlzIG5ldyBlZmZvcnQgdG8gcG9ydCBkZXZpY2Ut
bWFwcGVyLXRlc3Qtc3VpdGUgdGVzdHMgKHdoaWNoIHVzZQo+ID4gcnVieSkgdG8gYSBuZXcgcHl0
aG9uIGhhcm5lc3MgY3VycmVudGx5IG5hbWVkICJkbXRlc3QtcHl0aG9uIiwgSm9lCj4gPiBUaG9y
bmJlciBpcyBsZWFkaW5nIHRoaXMgZWZmb3J0ICh3aXRoIHRoZSBhc3Npc3RhbmNlIG9mCj4gPiBD
aGF0R1BULi4gYXBwYXJlbnRseSBpdCBoYXMgYmVlbiB3b25kZXJmdWwgaW4gaGVscGluZyBKb2Ug
Z2x1ZSBweXRob24KPiA+IGNvZGUgdG9nZXRoZXIgdG8gYWNjb21wbGlzaCBhbnl0aGluZyBoZSdz
IG5lZWRlZCk6Cj4gPiBodHRwczovL2dpdGh1Yi5jb20vanRob3JuYmVyL2RtdGVzdC1weXRob24K
PiA+Cj4gPiAod2UndmUgZGlzY3Vzc2VkIHJlbmFtaW5nICJkbXRlc3QtcHl0aG9uIiB0byAiZG10
ZXN0cyIpCj4gPgo+ID4gSSd2ZSBhbHNvIGRpc2N1c3NlZCB3aXRoIEpvZSB0aGUgcGxhbiB0byB3
cmFwIHRoZSBvdGhlciBkaXNwYXJhdGUKPiA+IHRlc3RzdWl0ZXMgd2l0aCBETSBjb3ZlcmFnZSBp
biB0ZXJtcyBvZiB0aGUgbmV3IGRtdGVzdC1weXRob24uCgpJdCBzb3VuZHMgYSB2YWx1YWJsZSBh
Y3Rpb24gdG8gZ2F0aGVyIHRoZSB2YXJpb3VzIHRlc3RzdWl0ZXMgc28gdGhhdCB0aGUgZG0KbWFp
bnRhaW5lciBvciBkbSBkZXZlbG9wZXJzIGNhbiBydW4gdGhlbSBhbGwgZWFzaWx5LgoKSSBhbHNv
IHRoaW5rIHRoYXQgdGhlIGxpc3Qgb2YgdGVzdHN1aXRlcyB3aWxsIGhlbHAgZGV2ZWxvcGVycyB0
byB0ZWxsIHdoYXQga2luZApvZiB0ZXN0IGdvZXMgdG8gd2hpY2ggdGVzdHN1aXRlLiBXaGVuIGFu
IGRldmVsb3BlciBhZGRzIGEgdGVzdCBjYXNlIHJlbGF0ZWQgdG8KZG0sIHRoZSBkZXZlbG9wZXIg
bmVlZHMgdG8gY2hvb3NlIHdoaWNoIHRlc3RzdWl0ZSB0byBhZGQgaXQuIEFzIGFuIGV4YW1wbGUs
IEkKd29uZGVyIGFib3V0IGRtLXpvbmVkLiBJbiBjYXNlIHdlIHdvdWxkIGFkZCB0ZXN0IGNhc2Vz
IHRvIGV4ZXJjaXNlIGRtLXpvbmVkLCBpcwp0aGVyZSBhbnkgZ29vZCB0ZXN0c3VpdGUgdG8gYWRk
IHRoZW0/IChDYW4gd2Ugc2V0IHVwIGRtLXpvbmVkIHdpdGggZG10ZXN0LQpweXRob24/KQoKPiA+
IGJsa3Rlc3RzIGNhbiBiZSBtYWRlIHRvIGJlIG9uZSBvZiB0aGUgdGVzdHN1aXRlcyB3ZSBhZGQg
c3VwcG9ydCBmb3IKPiA+IChzbyB0aGF0IGFsbCBibGt0ZXN0cyBydW4gb24gdmFyaW91cyB0eXBl
cyBvZiBETSB0YXJnZXRzKS4KPiA+Cj4gPiBSZWFsbHkgYWxsIHdlIG5lZWQgaXMgYSBtZWFucyB0
bzoKPiA+IDEpIGxpc3QgYWxsIHRlc3RzIGluIGEgdGVzdHN1aXRlCj4gPiAyKSBpbml0aWF0ZSBy
dW5uaW5nIGVhY2ggdGVzdCBpbmRpdmlkdWFsbHkKCklJVUMsIHRoZSBkbXRlc3QtcHl0aG9uIHRh
a2VzIHRoZSByb2xlIHRvIHByZXBhcmUgdGhlIHZhcmlvdXMgRE0gdGFyZ2V0cyBmb3IKdGVzdCwg
YW5kIGVhY2ggdGVzdHN1aXRlIHJ1bnMgdGVzdCBjYXNlcyBvbiB0aGUgdGFyZ2V0cywgcmlnaHQ/
IEZyb20gYmxrdGVzdHMKcG9pbnQgb2YgdmlldywgdGhlICJibG9jayIgZ3JvdXAgb2YgYmxrdGVz
dHMgY2FuIGJlIHJ1biB3aXRoIHRoZSB2YXJpb3VzIERNCnRhcmdldHMuIEFsc28gdGhlICJ6YmQi
IGdyb3VwIG9mIGJsa3Rlc3RzIGNhbiBiZSBydW4gd2l0aCBETSB0YXJnZXRzIHdpdGgKRE1fVEFS
R0VUX1pPTkVEX0hNIGZlYXR1cmUuIE90aGVyIHRlc3QgZ3JvdXBzIHN1Y2ggYXMgIm52bWUiIG9y
ICJzY3NpIiB3b24ndApydW4gd2l0aCBETSB0YXJnZXRzLiBJIHRoaW5rIGl0IGlzIG5vdCBkaWZm
aWN1bHQgZm9yIGRtdGVzdC1weXRob24gdG8gcHJlcGFyZQpibGt0ZXN0cyBjb25maWcgZmlsZXMg
dG8gc3BlY2lmeSBETSB0YXJnZXRzIGFuZCB0aGUgYmxvY2svemJkIHRlc3QgZ3JvdXAuIElmCmJs
a3Rlc3RzIHNpZGUgY2hhbmdlIGlzIGRlc2lyZWQsIHdlIGNhbiBkaXNjdXNzLgoKPiA+Cj4gPiBN
aWtlCj4gCj4gVGhhbmtzIE1pa2UgZm9yIHRoZSBkZXRhaWxlZCBpbmZvcm1hdGlvbiwgd2UgZGlk
IHRhbGsgYWJvdXQgRE0gdGVzdGNhc2VzCj4gaW4gbGFzdCBMU0ZNTSwgdGhpcyBpcyByZWFsbHkg
aW1wb3J0YW50IHBpZWNlIG9mIGJsa3Rlc3QgdGhhdCBpcyBtaXNzaW5nCj4gYW5kIG5lZWQgdG8g
YmUgZGlzY3Vzc2VkIHRoaXMgeWVhcidzIExTRk1NIHNvIHdlIGNhbiBpbnRlZ3JhdGUgYWJvdmUK
PiB3b3JrIGluIGJsa3Rlc3RzIGFzIHJpZ2h0IG5vdyB3ZSBhcmUgbm90IGFibGUgdG8gZXN0YWJs
aXNoIGNvbXBsZXRlCj4gc3RhYmlsaXR5IGR1ZSB0byBsYWNrIG9mIG9mIHRoZSBkbSB0ZXN0cyBh
cyB3ZSBhcmUgZG9pbmcgaXQgZm9yIGJsb2NrCj4gbGF5ZXIgY29kZSBvciBudm1lIGZvciBleGFt
cGxlLgo+IAo+IC1jawo+IAo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

