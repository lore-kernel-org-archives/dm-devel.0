Return-Path: <SRS0=e/dp=PW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C62BC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 12:28:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7EF860F58
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 12:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D7EF860F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-vxqlR87zNr-yFWncgZJmDg-1; Wed, 03 Nov 2021 08:28:33 -0400
X-MC-Unique: vxqlR87zNr-yFWncgZJmDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F33E080A5C0;
	Wed,  3 Nov 2021 12:28:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 369DC78B2A;
	Wed,  3 Nov 2021 12:28:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD7C657DC1;
	Wed,  3 Nov 2021 12:28:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A3CSE85020639 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Nov 2021 08:28:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA9831121315; Wed,  3 Nov 2021 12:28:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B555A1121314
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 12:28:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9BF418E0042
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 12:28:11 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-456-UsYQaXVVOei4HG4THtrpeQ-1; Wed, 03 Nov 2021 08:28:07 -0400
X-MC-Unique: UsYQaXVVOei4HG4THtrpeQ-1
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HkmDS5FzXz67v0C;
	Wed,  3 Nov 2021 20:24:40 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Wed, 3 Nov 2021 13:28:04 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.015; Wed, 3 Nov 2021 13:28:04 +0100
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Deven Bowers <deven.desai@linux.microsoft.com>, Eric Biggers
	<ebiggers@kernel.org>
Thread-Topic: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
	fsverity digest and signature
Thread-Index: AQHXwGWUN6BqcPCg3Uma5jdt5usPz6vRLYAAgAMlHYCAHWTKcA==
Date: Wed, 3 Nov 2021 12:28:04 +0000
Message-ID: <0b4c9a91afb441b085ec914118617ee7@huawei.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
In-Reply-To: <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A3CSE85020639
X-loop: dm-devel@redhat.com
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
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBGcm9tOiBEZXZlbiBCb3dlcnMgW21haWx0bzpkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQu
Y29tXQo+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAxNSwgMjAyMSA5OjI2IFBNCj4gT24gMTAvMTMv
MjAyMSAxMjoyNCBQTSwgRXJpYyBCaWdnZXJzIHdyb3RlOgo+ID4gT24gV2VkLCBPY3QgMTMsIDIw
MjEgYXQgMTI6MDY6MzFQTSAtMDcwMCwKPiBkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29t
IHdyb3RlOgo+ID4+IEZyb206IEZhbiBXdSA8d3VmYW5AbGludXgubWljcm9zb2Z0LmNvbT4KPiA+
Pgo+ID4+IEFkZCBzZWN1cml0eV9pbm9kZV9zZXRzZWN1cml0eSB0byBmc3Zlcml0eSBzaWduYXR1
cmUgdmVyaWZpY2F0aW9uLgo+ID4+IFRoaXMgY2FuIGxldCBMU01zIHNhdmUgdGhlIHNpZ25hdHVy
ZSBkYXRhIGFuZCBkaWdlc3QgaGFzaGVzIHByb3ZpZGVkCj4gPj4gYnkgZnN2ZXJpdHkuCj4gPiBD
YW4geW91IGVsYWJvcmF0ZSBvbiB3aHkgTFNNcyBuZWVkIHRoaXMgaW5mb3JtYXRpb24/Cj4gCj4g
VGhlIHByb3Bvc2VkIExTTSAoSVBFKSBvZiB0aGlzIHNlcmllcyB3aWxsIGJlIHRoZSBvbmx5IG9u
ZSB0byBuZWVkCj4gdGhpcyBpbmZvcm1hdGlvbiBhdCB0aGXCoCBtb21lbnQuIElQReKAmXMgZ29h
bCBpcyB0byBoYXZlIHByb3ZpZGUKPiB0cnVzdC1iYXNlZCBhY2Nlc3MgY29udHJvbC4gVHJ1c3Qg
YW5kIEludGVncml0eSBhcmUgdGllZCB0b2dldGhlciwKPiBhcyB5b3UgY2Fubm90IHByb3ZlIHRy
dXN0IHdpdGhvdXQgcHJvdmluZyBpbnRlZ3JpdHkuCgpJIHdhbnRlZCB0byBnbyBiYWNrIG9uIHRo
aXMgcXVlc3Rpb24uCgpJdCBzZWVtcywgYXQgbGVhc3QgZm9yIGZzdmVyaXR5LCB0aGF0IHlvdSBj
b3VsZCBvYnRhaW4gdGhlCnJvb3QgZGlnZXN0IGF0IHJ1bi10aW1lLCB3aXRob3V0IHN0b3Jpbmcg
aXQgaW4gYSBzZWN1cml0eSBibG9iLgoKSSB0aG91Z2h0IEkgc2hvdWxkIHVzZSBmc3Zlcml0eV9n
ZXRfaW5mbygpIGJ1dCB0aGUgZnN2ZXJpdHlfaW5mbwpzdHJ1Y3R1cmUgaXMgbm90IGV4cG9ydGVk
IChpdCBpcyBkZWZpbmVkIGluIGZzL3Zlcml0eS9mc3Zlcml0eV9wcml2YXRlLmgpLgoKVGhlbiwg
SSBkZWZpbmVkIGEgbmV3IGZ1bmN0aW9uLCBmc3Zlcml0eV9nZXRfZmlsZV9kaWdlc3QoKSB0byBj
b3B5CnRoZSBmaWxlX2RpZ2VzdCBtZW1iZXIgb2YgZnN2ZXJpdHlfaW5mbyB0byBhIGJ1ZmZlciBh
bmQgdG8gcGFzcwp0aGUgYXNzb2NpYXRlZCBoYXNoIGFsZ29yaXRobS4KCldpdGggdGhhdCwgdGhl
IGNvZGUgb2YgZXZhbHVhdGUoKSBmb3IgRElHTElNIGJlY29tZXM6CgogICAgICAgIGluZm8gPSBm
c3Zlcml0eV9nZXRfaW5mbyhmaWxlX2lub2RlKGN0eC0+ZmlsZSkpOwogICAgICAgIGlmIChpbmZv
KQogICAgICAgICAgICAgICAgcmV0ID0gZnN2ZXJpdHlfZ2V0X2ZpbGVfZGlnZXN0KGluZm8sIGJ1
ZmZlciwgc2l6ZW9mKGJ1ZmZlciksICZhbGdvKTsKCiAgICAgICAgaWYgKCFzdHJjbXAoZXhwZWN0
LT5kYXRhLCAiZGlnbGltIikgJiYgcmV0ID4gMCkgewogICAgICAgICAgICAgICAgcmV0ID0gZGln
bGltX2RpZ2VzdF9nZXRfaW5mbyhidWZmZXIsIGFsZ28sIENPTVBBQ1RfRklMRSwgJm1vZGlmaWVy
cywgJmFjdGlvbnMpOwogICAgICAgICAgICAgICAgaWYgKCFyZXQpCiAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiB0cnVlOwogICAgICAgIH0KClJvYmVydG8KCkhVQVdFSSBURUNITk9MT0dJ
RVMgRHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzCk1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5n
LCBaaG9uZyBSb25naHVhCgo+IElQRSBuZWVkcyB0aGUgZGlnZXN0IGluZm9ybWF0aW9uIHRvIGJl
IGFibGUgdG8gY29tcGFyZSBhIGRpZ2VzdAo+IHByb3ZpZGVkIGJ5IHRoZSBwb2xpY3kgYXV0aG9y
LCBhZ2FpbnN0IHRoZSBkaWdlc3QgY2FsY3VsYXRlZCBieQo+IGZzdmVyaXR5IHRvIG1ha2UgYSBk
ZWNpc2lvbiBvbiB3aGV0aGVyIHRoYXQgc3BlY2lmaWMgZmlsZSwgcmVwcmVzZW50ZWQKPiBieSB0
aGUgZGlnZXN0IGlzIGF1dGhvcml6ZWQgZm9yIHRoZSBhY3Rpb25zIHNwZWNpZmllZCBpbiB0aGUg
cG9saWN5Lgo+IAo+IEEgbW9yZSBjb25jcmV0ZSBleGFtcGxlLCBpZiBhbiBJUEUgcG9saWN5IGF1
dGhvciB3cml0ZXM6Cj4gCj4gIMKgwqDCoCBvcD1FWEVDVVRFIGZzdmVyaXR5X2RpZ2VzdD08SGV4
RGlnZXN0ID4gYWN0aW9uPURFTlkKPiAKPiBJUEUgdGFrZXMgdGhlIGRpZ2VzdCBwcm92aWRlZCBi
eSB0aGlzIHNlY3VyaXR5IGhvb2ssIHN0b3JlcyBpdAo+IGluIElQRSdzIHNlY3VyaXR5IGJsb2Ig
b24gdGhlIGlub2RlLiBJZiB0aGlzIGZpbGUgaXMgbGF0ZXIKPiBleGVjdXRlZCwgSVBFIGNvbXBh
cmVzIHRoZSBkaWdlc3Qgc3RvcmVkIGluIHRoZSBMU00gYmxvYiwKPiBwcm92aWRlZCBieSB0aGlz
IGhvb2ssIGFnYWluc3QgPEhleERpZ2VzdD4gaW4gdGhlIHBvbGljeSwgaWYKPiBpdCBtYXRjaGVz
LCBpdCBkZW5pZXMgdGhlIGFjY2VzcywgcGVyZm9ybWluZyBhIHJldm9jYXRpb24KPiBvZiB0aGF0
IGZpbGUuCj4gCj4gVGhpcyBicmluZ3MgbWUgdG8geW91ciBuZXh0IGNvbW1lbnQ6Cj4gCj4gID4g
VGhlIGRpZ2VzdCBpc24ndCBtZWFuaW5nZnVsIHdpdGhvdXQga25vd2luZyB0aGUgaGFzaCBhbGdv
cml0aG0gaXQgdXNlcy4KPiBJdCdzIGF2YWlsYWJsZSBoZXJlLCBidXQgeW91IGFyZW4ndCBwYXNz
aW5nIGl0IHRvIHRoaXMgZnVuY3Rpb24uCj4gCj4gVGhlIGRpZ2VzdCBpcyBtZWFuaW5nZnVsIHdp
dGhvdXQgdGhlIGFsZ29yaXRobSBpbiB0aGlzIGNhc2UuCj4gSVBFIGRvZXMgbm90IHdhbnQgdG8g
cmVjYWxjdWxhdGUgYSBkaWdlc3QsIHRoYXTigJlzIGV4cGVuc2l2ZSBhbmQKPiBkb2VzbuKAmXQg
cHJvdmlkZSBhbnkgdmFsdWUuIElQRSwgaW4gdGhpcyBjYXNlLCB0cmVhdHMgdGhpcyBhcyBhCj4g
YnVmZmVyIHRvIGNvbXBhcmUgdGhlIHBvbGljeS1wcm92aWRlZCBvbmUgYWJvdmUgdG8gbWFrZSBh
Cj4gcG9saWN5IGRlY2lzaW9uIGFib3V0IGFjY2VzcyB0byB0aGUgcmVzb3VyY2UuCj4gCj4gPj4g
QWxzbyBjaGFuZ2VzIHRoZSBpbXBsZW1lbnRhaW9uIGluc2lkZSB0aGUgaG9vayBmdW5jdGlvbiB0
byBsZXQKPiA+PiBtdWx0aXBsZSBMU01zIGNhbiBhZGQgaG9va3MuCj4gPiBQbGVhc2Ugc3BsaXQg
ZnMvdmVyaXR5LyBjaGFuZ2VzIGFuZCBzZWN1cml0eS8gY2hhbmdlcyBpbnRvIHNlcGFyYXRlIHBh
dGNoZXMsIGlmCj4gPiBwb3NzaWJsZS4KPiAKPiBTb3JyeSwgd2lsbCBkbywgbm90IGEgcHJvYmxl
bS4KPiAKPiA+PiBAQCAtMTc3LDYgKzE3OCwxNyBAQCBzdHJ1Y3QgZnN2ZXJpdHlfaW5mbyAqZnN2
ZXJpdHlfY3JlYXRlX2luZm8oY29uc3QKPiBzdHJ1Y3QgaW5vZGUgKmlub2RlLAo+ID4+ICAgCQlm
c3Zlcml0eV9lcnIoaW5vZGUsICJFcnJvciAlZCBjb21wdXRpbmcgZmlsZSBkaWdlc3QiLCBlcnIp
Owo+ID4+ICAgCQlnb3RvIG91dDsKPiA+PiAgIAl9Cj4gPj4gKwo+ID4+ICsJZXJyID0gc2VjdXJp
dHlfaW5vZGVfc2V0c2VjdXJpdHkoKHN0cnVjdCBpbm9kZSAqKWlub2RlLAo+ID4gSWYgYSBub24t
Y29uc3QgaW5vZGUgaXMgbmVlZGVkLCBwbGVhc2UgcHJvcGFnYXRlIHRoYXQgaW50byB0aGUgY2Fs
bGVycyByYXRoZXIKPiA+IHRoYW4gcmFuZG9tbHkgY2FzdGluZyBhd2F5IHRoZSBjb25zdC4KPiA+
Cj4gPj4gKwkJCQkJIEZTX1ZFUklUWV9ESUdFU1RfU0VDX05BTUUsCj4gPj4gKwkJCQkJIHZpLT5m
aWxlX2RpZ2VzdCwKPiA+PiArCQkJCQkgdmktPnRyZWVfcGFyYW1zLmhhc2hfYWxnLQo+ID5kaWdl
c3Rfc2l6ZSwKPiA+PiArCQkJCQkgMCk7Cj4gPj4gQEAgLTg0LDcgKzg1LDkgQEAgaW50IGZzdmVy
aXR5X3ZlcmlmeV9zaWduYXR1cmUoY29uc3Qgc3RydWN0IGZzdmVyaXR5X2luZm8KPiAqdmksCj4g
Pj4KPiA+PiAgIAlwcl9kZWJ1ZygiVmFsaWQgc2lnbmF0dXJlIGZvciBmaWxlIGRpZ2VzdCAlczol
KnBoTlxuIiwKPiA+PiAgIAkJIGhhc2hfYWxnLT5uYW1lLCBoYXNoX2FsZy0+ZGlnZXN0X3NpemUs
IHZpLT5maWxlX2RpZ2VzdCk7Cj4gPj4gLQlyZXR1cm4gMDsKPiA+PiArCXJldHVybiBzZWN1cml0
eV9pbm9kZV9zZXRzZWN1cml0eSgoc3RydWN0IGlub2RlICopaW5vZGUsCj4gPj4KPiA+IExpa2V3
aXNlLCBwbGVhc2UgZG9uJ3QgY2FzdCBhd2F5IGNvbnN0Lgo+IAo+IFNvcnJ5LCBJIHNob3VsZCd2
ZSBjYXVnaHQgdGhlc2UgbXlzZWxmLiBJJ2xsIGNoYW5nZQo+IGZzdmVyaXR5X2NyZWF0ZV9pbmZv
IHRvIGFjY2VwdCB0aGUgbm9uLWNvbnN0IGlub2RlLCBhbmQKPiBjaGFuZ2UgZnN2ZXJpdHlfdmVy
aWZ5X3NpZ25hdHVyZSB0byBhY2NlcHQgYW4gYWRkaXRpb25hbCBpbm9kZQo+IHN0cnVjdCBhcyB0
aGUgZmlyc3QgYXJnIGluc3RlYWQgb2YgY2hhbmdpbmcgdGhlIGZzdmVyaXR5X2luZm8KPiBzdHJ1
Y3R1cmUgdG8gaGF2ZSBhIG5vbi1jb25zdCBpbm9kZSBmaWVsZC4KPiAKPiA+PiArCQkJCQlGU19W
RVJJVFlfU0lHTkFUVVJFX1NFQ19OQU1FLAo+ID4+ICsJCQkJCXNpZ25hdHVyZSwgc2lnX3NpemUs
IDApOwo+ID4gVGhpcyBpcyBvbmx5IGZvciBmcy12ZXJpdHkgYnVpbHQtaW4gc2lnbmF0dXJlcyB3
aGljaCBhcmVuJ3QgdGhlIG9ubHkgd2F5IHRvIGRvCj4gPiBzaWduYXR1cmVzIHdpdGggZnMtdmVy
aXR5LiAgQXJlIHlvdSBzdXJlIHRoaXMgaXMgd2hhdCB5b3UncmUgbG9va2luZyBmb3I/Cj4gCj4g
Q291bGQgeW91IGVsYWJvcmF0ZSBvbiB0aGUgb3RoZXIgc2lnbmF0dXJlIHR5cGVzIHRoYXQgY2Fu
IGJlIHVzZWQKPiB3aXRoIGZzLXZlcml0eT8gSeKAmW0gOTklIHN1cmUgdGhpcyBpcyB3aGF0IEni
gJltIGxvb2tpbmcgZm9yIGFzIHRoaXMKPiBpcyBhIHNpZ25hdHVyZSB2YWxpZGF0ZWQgaW4gdGhl
IGtlcm5lbCBhZ2FpbnN0IHRoZSBmcy12ZXJpdHkga2V5cmluZwo+IGFzIHBhcnQgb2YgdGhlIOKA
nGZzdmVyaXR5IGVuYWJsZeKAnSB1dGlsaXR5Lgo+IAo+IEl0J3MgaW1wb3J0YW50IHRoYXQgdGhl
IHNpZ25hdHVyZSBpcyB2YWxpZGF0ZWQgaW4gdGhlIGtlcm5lbCwgYXMKPiB1c2Vyc3BhY2UgaXMg
Y29uc2lkZXJlZCB1bnRydXN0ZWQgdW50aWwgdGhlIHNpZ25hdHVyZSBpcyB2YWxpZGF0ZWQKPiBm
b3IgdGhpcyBjYXNlLgo+IAo+ID4gQ2FuIHlvdSBlbGFib3JhdGUgb24geW91ciB1c2UgY2FzZSBm
b3IgZnMtdmVyaXR5IGJ1aWx0LWluIHNpZ25hdHVyZXMsCj4gU3VyZSwgc2lnbmF0dXJlcywgbGlr
ZSBkaWdlc3RzLCBhbHNvIHByb3ZpZGUgYSB3YXkgdG8gcHJvdmUgaW50ZWdyaXR5LAo+IGFuZCB0
aGUgdHJ1c3QgY29tcG9uZW50IGNvbWVzIGZyb20gdGhlIHZhbGlkYXRpb24gYWdhaW5zdCB0aGUg
a2V5cmluZywKPiBhcyBvcHBvc2VkIHRvIGEgZml4ZWQgdmFsdWUgaW4gSVBF4oCZcyBwb2xpY3ku
IFRoZSB1c2UgY2FzZSBmb3IgZnMtdmVyaXR5Cj4gYnVpbHQtaW4gc2lnbmF0dXJlcyBpcyB0aGF0
IHdlIGhhdmUgYSBydyBleHQ0IGZpbGVzeXN0ZW0gdGhhdCBoYXMgc29tZQo+IGV4ZWN1dGFibGUg
ZmlsZXMsIGFuZCB3ZSB3YW50IHRvIGhhdmUgYSBleGVjdXRpb24gcG9saWN5ICh0aHJvdWdoIElQ
RSkKPiB0aGF0IG9ubHkgX3RydXN0ZWRfIGV4ZWN1dGFibGVzIGNhbiBydW4uIFBlcmYgaXMgaW1w
b3J0YW50IGhlcmUsIGhlbmNlCj4gZnMtdmVyaXR5Lgo+IAo+ID4gYW5kIHdoYXQgdGhlIExTTSBo
b29rIHdpbGwgZG8gd2l0aCB0aGVtPwo+IAo+IEF0IHRoZSBtb21lbnQsIHRoaXMgd2lsbCBqdXN0
IHNpZ25hbCB0byBJUEUgdGhhdCB0aGVzZSBmcy12ZXJpdHkgZmlsZXMgd2VyZQo+IGVuYWJsZWQg
d2l0aCBhIGJ1aWx0LWluIHNpZ25hdHVyZSBhcyBvcHBvc2VkIHRvIGVuYWJsZWQgd2l0aG91dCBh
IHNpZ25hdHVyZS4KPiBJbiB2NywgaXQgY29waWVzIHRoZSBzaWduYXR1cmUgZGF0YSBpbnRvIElQ
RSdzIExTTSBibG9iIGF0dGFjaGVkIHRvIHRoZQo+IGlub2RlLgo+IEluIHY4KywgSSdtIGNoYW5n
aW5nIHRoaXMgdG8gc3RvcmUg4oCcdHJ1ZeKAnSBpbiBJUEUncyBMU00gYmxvYiBpbnN0ZWFkLCBh
cwo+IGNvcHlpbmcKPiB0aGUgc2lnbmF0dXJlIGRhdGEgaXMgYW4gdW5uZWNlc3Nhcnkgd2FzdGUg
b2Ygc3BhY2UgYW5kIHBvaW50IG9mCj4gZmFpbHVyZS4gVGhpcwo+IGhhcyBhIF9zbGlnaHRseV8g
ZGlmZmVyZW50IGZ1bmN0aW9uYWxpdHkgdGhlbiBmcy52ZXJpdHkucmVxdWlyZV9zaWduYXR1cmVz
LAo+IGJlY2F1c2UgZXZlbiBpZiBzb21lb25lIHdlcmUgdG8gZGlzYWJsZSB0aGUgcmVxdWlyZSBz
aWduYXR1cmVzIG9wdGlvbiwgSVBFCj4gd291bGQgc3RpbGwga25vdyBpZiB0aGVzZSBmaWxlcyB3
ZXJlIHNpZ25lZCBvciBub3QgYW5kIGJlIGFibGUgdG8gbWFrZSB0aGUKPiBhY2Nlc3MgY29udHJv
bCBkZWNpc2lvbiBiYXNlZCBJUEUncyBwb2xpY3kuCj4gCj4gVmVyeSBjb25jcmV0ZWx5LCB0aGlz
IHBvd2VycyB0aGlzIGtpbmQgb2YgcnVsZSBpbiBJUEU6Cj4gCj4gIMKgIG9wPUVYRUNVVEUgZnN2
ZXJpdHlfc2lnbmF0dXJlPVRSVUUgYWN0aW9uPUFMTE9XCj4gCj4gaWYgdGhhdCBmc3Zlcml0eV9z
aWduYXR1cmUgdmFsdWUgaW4gSVBF4oCZcyBMU00gYmxvYiBhdHRhY2hlZCB0byB0aGUgaW5vZGUg
aXMKPiB0cnVlLCB0aGVuIGZzdmVyaXR5X3NpZ25hdHVyZSBpbiBJUEXigJlzIHBvbGljeSB3aWxs
IGV2YWx1YXRlIHRvIHRydWUgYW5kCj4gbWF0Y2gKPiB0aGlzIHJ1bGUuIFRoZSBpbnZlcnNlIGlz
IGFsc28gYXBwbGljYWJsZS4KCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs

