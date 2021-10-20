Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4F6C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 02:20:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 910FD611CC
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 02:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 910FD611CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-GEHYhSmZOkGNTqdVc1vMTQ-1; Wed, 20 Oct 2021 22:20:09 -0400
X-MC-Unique: GEHYhSmZOkGNTqdVc1vMTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98076806688;
	Thu, 21 Oct 2021 02:20:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29D9E60CA0;
	Thu, 21 Oct 2021 02:20:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD32818199EE;
	Thu, 21 Oct 2021 02:20:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19KFQjrp005634 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 11:26:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3EC2540CFD01; Wed, 20 Oct 2021 15:26:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A0C540CFD11
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 15:26:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1688E8027E1
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 15:26:45 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-247-VvHXA7CFPLG_Fyweo7Giyg-1; Wed, 20 Oct 2021 11:26:14 -0400
X-MC-Unique: VvHXA7CFPLG_Fyweo7Giyg-1
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HZDRj3tffz67Xsj;
	Wed, 20 Oct 2021 23:04:49 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Wed, 20 Oct 2021 17:08:39 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.015; Wed, 20 Oct 2021 17:08:39 +0200
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Eric Biggers <ebiggers@kernel.org>, Deven Bowers
	<deven.desai@linux.microsoft.com>
Thread-Topic: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
	fsverity digest and signature
Thread-Index: AQHXwGWUN6BqcPCg3Uma5jdt5usPz6vRLYAAgAMlHYCAAAy0gIAHoD6w
Date: Wed, 20 Oct 2021 15:08:39 +0000
Message-ID: <5c1f800ba554485cb3659da689d2079a@huawei.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<YWngaVdvMyWBlITZ@gmail.com>
In-Reply-To: <YWngaVdvMyWBlITZ@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19KFQjrp005634
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 20 Oct 2021 22:18:52 -0400
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
	"paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jmorris@namei.org" <jmorris@namei.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>, "serge@hallyn.com" <serge@hallyn.com>
Subject: Re: [dm-devel] [RFC PATCH v7 12/16] fsverity|security: add security
 hooks to fsverity digest and signature
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBGcm9tOiBFcmljIEJpZ2dlcnMgW21haWx0bzplYmlnZ2Vyc0BrZXJuZWwub3JnXQo+IFNlbnQ6
IEZyaWRheSwgT2N0b2JlciAxNSwgMjAyMSAxMDoxMSBQTQo+IE9uIEZyaSwgT2N0IDE1LCAyMDIx
IGF0IDEyOjI1OjUzUE0gLTA3MDAsIERldmVuIEJvd2VycyB3cm90ZToKPiA+Cj4gPiBPbiAxMC8x
My8yMDIxIDEyOjI0IFBNLCBFcmljIEJpZ2dlcnMgd3JvdGU6Cj4gPiA+IE9uIFdlZCwgT2N0IDEz
LCAyMDIxIGF0IDEyOjA2OjMxUE0gLTA3MDAsCj4gZGV2ZW4uZGVzYWlAbGludXgubWljcm9zb2Z0
LmNvbSB3cm90ZToKPiA+ID4gPiBGcm9tOiBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5j
b20+Cj4gPiA+ID4KPiA+ID4gPiBBZGQgc2VjdXJpdHlfaW5vZGVfc2V0c2VjdXJpdHkgdG8gZnN2
ZXJpdHkgc2lnbmF0dXJlIHZlcmlmaWNhdGlvbi4KPiA+ID4gPiBUaGlzIGNhbiBsZXQgTFNNcyBz
YXZlIHRoZSBzaWduYXR1cmUgZGF0YSBhbmQgZGlnZXN0IGhhc2hlcyBwcm92aWRlZAo+ID4gPiA+
IGJ5IGZzdmVyaXR5Lgo+ID4gPiBDYW4geW91IGVsYWJvcmF0ZSBvbiB3aHkgTFNNcyBuZWVkIHRo
aXMgaW5mb3JtYXRpb24/Cj4gPgo+ID4gVGhlIHByb3Bvc2VkIExTTSAoSVBFKSBvZiB0aGlzIHNl
cmllcyB3aWxsIGJlIHRoZSBvbmx5IG9uZSB0byBuZWVkCj4gPiB0aGlzIGluZm9ybWF0aW9uIGF0
IHRoZcKgIG1vbWVudC4gSVBF4oCZcyBnb2FsIGlzIHRvIGhhdmUgcHJvdmlkZQo+ID4gdHJ1c3Qt
YmFzZWQgYWNjZXNzIGNvbnRyb2wuIFRydXN0IGFuZCBJbnRlZ3JpdHkgYXJlIHRpZWQgdG9nZXRo
ZXIsCj4gPiBhcyB5b3UgY2Fubm90IHByb3ZlIHRydXN0IHdpdGhvdXQgcHJvdmluZyBpbnRlZ3Jp
dHkuCj4gCj4gSSB0aGluayB5b3UgbWVhbiBhdXRoZW50aWNpdHksIG5vdCBpbnRlZ3JpdHk/Cj4g
Cj4gQWxzbyBob3cgZG9lcyB0aGlzIGRpZmZlciBmcm9tIElNQT8gIEkga25vdyB0aGF0IElNQSBk
b2Vzbid0IHN1cHBvcnQgZnMtdmVyaXR5Cj4gZmlsZSBoYXNoZXMsIGJ1dCB0aGF0IGNvdWxkIGJl
IGNoYW5nZWQuICBXaHkgbm90IGV4dGVuZCBJTUEgdG8gY292ZXIgeW91ciB1c2UKPiBjYXNlKHMp
Pwo+IAo+ID4gSVBFIG5lZWRzIHRoZSBkaWdlc3QgaW5mb3JtYXRpb24gdG8gYmUgYWJsZSB0byBj
b21wYXJlIGEgZGlnZXN0Cj4gPiBwcm92aWRlZCBieSB0aGUgcG9saWN5IGF1dGhvciwgYWdhaW5z
dCB0aGUgZGlnZXN0IGNhbGN1bGF0ZWQgYnkKPiA+IGZzdmVyaXR5IHRvIG1ha2UgYSBkZWNpc2lv
biBvbiB3aGV0aGVyIHRoYXQgc3BlY2lmaWMgZmlsZSwgcmVwcmVzZW50ZWQKPiA+IGJ5IHRoZSBk
aWdlc3QgaXMgYXV0aG9yaXplZCBmb3IgdGhlIGFjdGlvbnMgc3BlY2lmaWVkIGluIHRoZSBwb2xp
Y3kuCj4gPgo+ID4gQSBtb3JlIGNvbmNyZXRlIGV4YW1wbGUsIGlmIGFuIElQRSBwb2xpY3kgYXV0
aG9yIHdyaXRlczoKPiA+Cj4gPiDCoMKgwqAgb3A9RVhFQ1VURSBmc3Zlcml0eV9kaWdlc3Q9PEhl
eERpZ2VzdCA+IGFjdGlvbj1ERU5ZCj4gPgo+ID4gSVBFIHRha2VzIHRoZSBkaWdlc3QgcHJvdmlk
ZWQgYnkgdGhpcyBzZWN1cml0eSBob29rLCBzdG9yZXMgaXQKPiA+IGluIElQRSdzIHNlY3VyaXR5
IGJsb2Igb24gdGhlIGlub2RlLiBJZiB0aGlzIGZpbGUgaXMgbGF0ZXIKPiA+IGV4ZWN1dGVkLCBJ
UEUgY29tcGFyZXMgdGhlIGRpZ2VzdCBzdG9yZWQgaW4gdGhlIExTTSBibG9iLAo+ID4gcHJvdmlk
ZWQgYnkgdGhpcyBob29rLCBhZ2FpbnN0IDxIZXhEaWdlc3Q+IGluIHRoZSBwb2xpY3ksIGlmCj4g
PiBpdCBtYXRjaGVzLCBpdCBkZW5pZXMgdGhlIGFjY2VzcywgcGVyZm9ybWluZyBhIHJldm9jYXRp
b24KPiA+IG9mIHRoYXQgZmlsZS4KPiAKPiBEbyB5b3UgaGF2ZSBhIGJldHRlciBleGFtcGxlPyAg
VGhpcyBvbmUgaXMgcHJldHR5IHVzZWxlc3Mgc2luY2Ugb25lIGNhbiBnZXQKPiBhcm91bmQgaXQg
anVzdCBieSBleGVjdXRpbmcgYSBmaWxlIHRoYXQgZG9lc24ndCBoYXZlIGZzLXZlcml0eSBlbmFi
bGVkLgoKSSB3YXMgd29uZGVyaW5nIGlmIHRoZSBmb2xsb3dpbmcgdXNlIGNhc2UgY2FuIGJlIHN1
cHBvcnRlZDoKYWxsb3cgdGhlIGV4ZWN1dGlvbiBvZiBmaWxlcyBwcm90ZWN0ZWQgd2l0aCBmc3Zl
cml0eSBpZiB0aGUgcm9vdApkaWdlc3QgaXMgZm91bmQgYW1vbmcgcmVmZXJlbmNlIHZhbHVlcyAo
aW5zdGVhZCBvZiBwcm92aWRpbmcKdGhlbSBvbmUgYnkgb25lIGluIHRoZSBwb2xpY3kpLgoKU29t
ZXRoaW5nIGxpa2U6CgpvcD1FWEVDVVRFIGZzdmVyaXR5X2RpZ2VzdD1kaWdsaW0gYWN0aW9uPUFM
TE9XCgpESUdMSU0gaXMgYSBjb21wb25lbnQgSSdtIHdvcmtpbmcgb24gdGhhdCBnZW5lcmljYWxs
eQpzdG9yZXMgZGlnZXN0cy4gVGhlIGN1cnJlbnQgdXNlIGNhc2UgaXMgdG8gc3RvcmUgZmlsZSBk
aWdlc3RzCmZyb20gUlBNVEFHX0ZJTEVESUdFU1RTIGFuZCB1c2UgdGhlbSB3aXRoIElNQSwgYnV0
CnRoZSBmc3Zlcml0eSB1c2UgY2FzZSBjb3VsZCBiZSBlYXNpbHkgc3VwcG9ydGVkIChpZiB0aGUg
cm9vdApkaWdlc3QgaXMgc3RvcmVkIGluIHRoZSBSUE0gaGVhZGVyKS4KCkRJR0xJTSBhbHNvIHRl
bGxzIHdoZXRoZXIgb3Igbm90IHRoZSBzaWduYXR1cmUgb2YgdGhlIHNvdXJjZQpjb250YWluaW5n
IGZpbGUgZGlnZXN0cyAob3IgZnN2ZXJpdHkgZGlnZXN0cykgaXMgdmFsaWQgKHRoZSBzaWduYXR1
cmUKb2YgdGhlIFJQTSBoZWFkZXIgaXMgdGFrZW4gZnJvbSBSUE1UQUdfUlNBSEVBREVSKS4KClRo
ZSBtZW1vcnkgb2NjdXBhdGlvbiBpcyByZWxhdGl2ZWx5IHNtYWxsIGZvciBleGVjdXRhYmxlcwph
bmQgc2hhcmVkIGxpYnJhcmllcy4gSSBwdWJsaXNoZWQgYSBkZW1vIGZvciBGZWRvcmEgYW5kCm9w
ZW5TVVNFIHNvbWUgdGltZSBhZ286CgpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pbnRl
Z3JpdHkvNDhjZDczN2M1MDRkNDUyMDgzNzdkYWEyN2Q2MjU1MzFAaHVhd2VpLmNvbS8KClRoYW5r
cwoKUm9iZXJ0bwoKSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYw
NjMKTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWEKCj4gPiBUaGlzIGJy
aW5ncyBtZSB0byB5b3VyIG5leHQgY29tbWVudDoKPiA+Cj4gPiA+IFRoZSBkaWdlc3QgaXNuJ3Qg
bWVhbmluZ2Z1bCB3aXRob3V0IGtub3dpbmcgdGhlIGhhc2ggYWxnb3JpdGhtIGl0IHVzZXMuCj4g
PiBJdCdzIGF2YWlsYWJsZSBoZXJlLCBidXQgeW91IGFyZW4ndCBwYXNzaW5nIGl0IHRvIHRoaXMg
ZnVuY3Rpb24uCj4gPgo+ID4gVGhlIGRpZ2VzdCBpcyBtZWFuaW5nZnVsIHdpdGhvdXQgdGhlIGFs
Z29yaXRobSBpbiB0aGlzIGNhc2UuCj4gCj4gTm8sIGl0J3Mgbm90Lgo+IAo+IERpZ2VzdHMgYXJl
IG1lYW5pbmdsZXNzIHdpdGhvdXQga25vd2luZyB3aGF0IGFsZ29yaXRobSB0aGV5IHdlcmUgY3Jl
YXRlZAo+IHdpdGguCj4gCj4gSWYgeW91ciBzZWN1cml0eSBwb2xpY3kgaXMgc29tZXRoaW5nIGxp
a2UgIlRydXN0IHRoZSBmaWxlIHdpdGggZGlnZXN0ICRmb28iIGFuZAo+IG11bHRpcGxlIGhhc2gg
YWxnb3JpdGhtcyBhcmUgcG9zc2libGUsIHRoZW4gdGhlIGFsb3JpdGhtIGludGVuZGVkIHRvIGJl
IHVzZWQKPiBuZWVkcyB0byBiZSBleHBsaWNpdGx5IHNwZWNpZmllZC4gIE90aGVyd2lzZSBhbnkg
YWxnb3JpdGhtIHdpdGggdGhlIHNhbWUgbGVuZ3RoCj4gZGlnZXN0IHdpbGwgYmUgYWNjZXB0ZWQu
ICBUaGF0J3MgYSBmYXRhbCBmbGF3IGlmIGFueSBvZiB0aGVzZSBhbGdvcml0aG1zIGlzCj4gY3J5
cHRvZ3JhcGhpY2FsbHkgYnJva2VuIG9yIHdhcyBuZXZlciBpbnRlbmRlZCB0byBiZSBhIGNyeXB0
b2dyYXBoaWMgYWxnb3JpdGhtCj4gaW4gdGhlIGZpcnN0IHBsYWNlIChlLmcuLCBhIG5vbi1jcnlw
dG9ncmFwaGljIGNoZWNrc3VtKS4KPiAKPiBDcnlwdG9zeXN0ZW1zIGFsd2F5cyBuZWVkIHRvIHNw
ZWNpZnkgdGhlIGNyeXB0byBhbGdvcml0aG0ocykgdXNlZDsgdGhlCj4gYWR2ZXJzYXJ5Cj4gbXVz
dCBub3QgYmUgYWxsb3dlZCB0byBjaG9vc2UgdGhlIGFsZ29yaXRobXMuCj4gCj4gSSdtIG5vdCBz
dXJlIGhvdyB0aGVzZSBwYXRjaGVzIGNhbiBiZSB0YWtlbiBzZXJpb3VzbHkgd2hlbiB0aGV5J3Jl
IGdldHRpbmcgdGhpcwo+IHNvcnQgb2YgdGhpbmcgd3JvbmcuCj4gCj4gPiA+ID4gKwkJCQkJRlNf
VkVSSVRZX1NJR05BVFVSRV9TRUNfTkFNRSwKPiA+ID4gPiArCQkJCQlzaWduYXR1cmUsIHNpZ19z
aXplLCAwKTsKPiA+ID4gVGhpcyBpcyBvbmx5IGZvciBmcy12ZXJpdHkgYnVpbHQtaW4gc2lnbmF0
dXJlcyB3aGljaCBhcmVuJ3QgdGhlIG9ubHkgd2F5IHRvIGRvCj4gPiA+IHNpZ25hdHVyZXMgd2l0
aCBmcy12ZXJpdHkuICBBcmUgeW91IHN1cmUgdGhpcyBpcyB3aGF0IHlvdSdyZSBsb29raW5nIGZv
cj8KPiA+Cj4gPiBDb3VsZCB5b3UgZWxhYm9yYXRlIG9uIHRoZSBvdGhlciBzaWduYXR1cmUgdHlw
ZXMgdGhhdCBjYW4gYmUgdXNlZAo+ID4gd2l0aCBmcy12ZXJpdHk/IEnigJltIDk5JSBzdXJlIHRo
aXMgaXMgd2hhdCBJ4oCZbSBsb29raW5nIGZvciBhcyB0aGlzCj4gPiBpcyBhIHNpZ25hdHVyZSB2
YWxpZGF0ZWQgaW4gdGhlIGtlcm5lbCBhZ2FpbnN0IHRoZSBmcy12ZXJpdHkga2V5cmluZwo+ID4g
YXMgcGFydCBvZiB0aGUg4oCcZnN2ZXJpdHkgZW5hYmxl4oCdIHV0aWxpdHkuCj4gPgo+ID4gSXQn
cyBpbXBvcnRhbnQgdGhhdCB0aGUgc2lnbmF0dXJlIGlzIHZhbGlkYXRlZCBpbiB0aGUga2VybmVs
LCBhcwo+ID4gdXNlcnNwYWNlIGlzIGNvbnNpZGVyZWQgdW50cnVzdGVkIHVudGlsIHRoZSBzaWdu
YXR1cmUgaXMgdmFsaWRhdGVkCj4gPiBmb3IgdGhpcyBjYXNlLgo+ID4KPiA+ID4gQ2FuIHlvdSBl
bGFib3JhdGUgb24geW91ciB1c2UgY2FzZSBmb3IgZnMtdmVyaXR5IGJ1aWx0LWluIHNpZ25hdHVy
ZXMsCj4gPiBTdXJlLCBzaWduYXR1cmVzLCBsaWtlIGRpZ2VzdHMsIGFsc28gcHJvdmlkZSBhIHdh
eSB0byBwcm92ZSBpbnRlZ3JpdHksCj4gPiBhbmQgdGhlIHRydXN0IGNvbXBvbmVudCBjb21lcyBm
cm9tIHRoZSB2YWxpZGF0aW9uIGFnYWluc3QgdGhlIGtleXJpbmcsCj4gPiBhcyBvcHBvc2VkIHRv
IGEgZml4ZWQgdmFsdWUgaW4gSVBF4oCZcyBwb2xpY3kuIFRoZSB1c2UgY2FzZSBmb3IgZnMtdmVy
aXR5Cj4gPiBidWlsdC1pbiBzaWduYXR1cmVzIGlzIHRoYXQgd2UgaGF2ZSBhIHJ3IGV4dDQgZmls
ZXN5c3RlbSB0aGF0IGhhcyBzb21lCj4gPiBleGVjdXRhYmxlIGZpbGVzLCBhbmQgd2Ugd2FudCB0
byBoYXZlIGEgZXhlY3V0aW9uIHBvbGljeSAodGhyb3VnaCBJUEUpCj4gPiB0aGF0IG9ubHkgX3Ry
dXN0ZWRfIGV4ZWN1dGFibGVzIGNhbiBydW4uIFBlcmYgaXMgaW1wb3J0YW50IGhlcmUsIGhlbmNl
Cj4gPiBmcy12ZXJpdHkuCj4gCj4gTW9zdCB1c2VycyBvZiBmcy12ZXJpdHkgYnVpbHQtaW4gc2ln
bmF0dXJlcyBoYXZlIGFjdHVhbGx5IGJlZW4gZW5mb3JjaW5nIHRoZWlyCj4gc2VjdXJpdHkgcG9s
aWN5IGluIHVzZXJzcGFjZSwgYnkgY2hlY2tpbmcgd2hldGhlciBzcGVjaWZpYyBmaWxlcyBoYXZl
IHRoZQo+IGZzLXZlcml0eSBiaXQgc2V0IG9yIG5vdC4gIFN1Y2ggdXNlcnMgY291bGQganVzdCBz
dG9yZSBhbmQgdmVyaWZ5IHNpZ25hdHVyZXMgaW4KPiB1c2Vyc3BhY2UgaW5zdGVhZCwgd2l0aG91
dCBhbnkga2VybmVsIGludm9sdmVtZW50LiAgU28gdGhhdCdzIHdoYXQgSSd2ZSBiZWVuCj4gcmVj
b21tZW5kaW5nICh3aXRoIGxpbWl0ZWQgc3VjY2VzcywgdW5mb3J0dW5hdGVseSkuCj4gCj4gSWYg
eW91IHJlYWxseSBkbyBuZWVkIGluLWtlcm5lbCBzaWduYXR1cmUgdmVyaWZpY2F0aW9uLCB0aGVu
IHRoYXQgbWF5IGJlIGEKPiBsZWdpdGltYXRlIHVzZSBjYXNlIGZvciB0aGUgZnMtdmVyaXR5IGJ1
aWx0LWluIHNpZ25hdHVyZXMsIGFsdGhvdWdoIEkgZG8gd29uZGVyCj4gd2h5IHlvdSBhcmVuJ3Qg
dXNpbmcgSU1BIGFuZCBpdHMgc2lnbmF0dXJlIG1lY2hhbmlzbSBpbnN0ZWFkLgo+IAo+IC0gRXJp
YwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

