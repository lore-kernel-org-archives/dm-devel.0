Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EA2C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:15:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FDCE60F56
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:15:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0FDCE60F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-8RN90zpyP7mgV1eOJcFJjg-1; Thu, 04 Nov 2021 13:15:45 -0400
X-MC-Unique: 8RN90zpyP7mgV1eOJcFJjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 030B018125C2;
	Thu,  4 Nov 2021 17:15:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3588C18A8F;
	Thu,  4 Nov 2021 17:15:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B49C61801241;
	Thu,  4 Nov 2021 17:15:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4HCGQQ003109 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 13:12:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9299F51E1; Thu,  4 Nov 2021 17:12:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB1A51DC
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:12:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B52738007B1
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:12:13 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-320-XM6jgzauPUypRKrtov2z4g-1;
	Thu, 04 Nov 2021 13:12:12 -0400
X-MC-Unique: XM6jgzauPUypRKrtov2z4g-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5ED1720ABA94;
	Thu,  4 Nov 2021 10:12:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5ED1720ABA94
Message-ID: <8d12dcf4-165d-9db6-5a42-591bc8b97c00@linux.microsoft.com>
Date: Thu, 4 Nov 2021 10:12:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
To: Roberto Sassu <roberto.sassu@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<0b4c9a91afb441b085ec914118617ee7@huawei.com>
From: Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <0b4c9a91afb441b085ec914118617ee7@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4HCGQQ003109
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzMvMjAyMSA1OjI4IEFNLCBSb2JlcnRvIFNhc3N1IHdyb3RlOgo+PiBGcm9tOiBEZXZl
biBCb3dlcnMgW21haWx0bzpkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tXQo+PiBTZW50
OiBGcmlkYXksIE9jdG9iZXIgMTUsIDIwMjEgOToyNiBQTQo+PiBPbiAxMC8xMy8yMDIxIDEyOjI0
IFBNLCBFcmljIEJpZ2dlcnMgd3JvdGU6Cj4+PiBPbiBXZWQsIE9jdCAxMywgMjAyMSBhdCAxMjow
NjozMVBNIC0wNzAwLAo+PiBkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tIHdyb3RlOgo+
Pj4+IEZyb206IEZhbiBXdSA8d3VmYW5AbGludXgubWljcm9zb2Z0LmNvbT4KPj4+Pgo+Pj4+IEFk
ZCBzZWN1cml0eV9pbm9kZV9zZXRzZWN1cml0eSB0byBmc3Zlcml0eSBzaWduYXR1cmUgdmVyaWZp
Y2F0aW9uLgo+Pj4+IFRoaXMgY2FuIGxldCBMU01zIHNhdmUgdGhlIHNpZ25hdHVyZSBkYXRhIGFu
ZCBkaWdlc3QgaGFzaGVzIHByb3ZpZGVkCj4+Pj4gYnkgZnN2ZXJpdHkuCj4+PiBDYW4geW91IGVs
YWJvcmF0ZSBvbiB3aHkgTFNNcyBuZWVkIHRoaXMgaW5mb3JtYXRpb24/Cj4+IFRoZSBwcm9wb3Nl
ZCBMU00gKElQRSkgb2YgdGhpcyBzZXJpZXMgd2lsbCBiZSB0aGUgb25seSBvbmUgdG8gbmVlZAo+
PiB0aGlzIGluZm9ybWF0aW9uIGF0IHRoZcKgIG1vbWVudC4gSVBF4oCZcyBnb2FsIGlzIHRvIGhh
dmUgcHJvdmlkZQo+PiB0cnVzdC1iYXNlZCBhY2Nlc3MgY29udHJvbC4gVHJ1c3QgYW5kIEludGVn
cml0eSBhcmUgdGllZCB0b2dldGhlciwKPj4gYXMgeW91IGNhbm5vdCBwcm92ZSB0cnVzdCB3aXRo
b3V0IHByb3ZpbmcgaW50ZWdyaXR5Lgo+IEkgd2FudGVkIHRvIGdvIGJhY2sgb24gdGhpcyBxdWVz
dGlvbi4KPgo+IEl0IHNlZW1zLCBhdCBsZWFzdCBmb3IgZnN2ZXJpdHksIHRoYXQgeW91IGNvdWxk
IG9idGFpbiB0aGUKPiByb290IGRpZ2VzdCBhdCBydW4tdGltZSwgd2l0aG91dCBzdG9yaW5nIGl0
IGluIGEgc2VjdXJpdHkgYmxvYi4KPgo+IEkgdGhvdWdodCBJIHNob3VsZCB1c2UgZnN2ZXJpdHlf
Z2V0X2luZm8oKSBidXQgdGhlIGZzdmVyaXR5X2luZm8KPiBzdHJ1Y3R1cmUgaXMgbm90IGV4cG9y
dGVkIChpdCBpcyBkZWZpbmVkIGluIGZzL3Zlcml0eS9mc3Zlcml0eV9wcml2YXRlLmgpLgo+Cj4g
VGhlbiwgSSBkZWZpbmVkIGEgbmV3IGZ1bmN0aW9uLCBmc3Zlcml0eV9nZXRfZmlsZV9kaWdlc3Qo
KSB0byBjb3B5Cj4gdGhlIGZpbGVfZGlnZXN0IG1lbWJlciBvZiBmc3Zlcml0eV9pbmZvIHRvIGEg
YnVmZmVyIGFuZCB0byBwYXNzCj4gdGhlIGFzc29jaWF0ZWQgaGFzaCBhbGdvcml0aG0uCj4KPiBX
aXRoIHRoYXQsIHRoZSBjb2RlIG9mIGV2YWx1YXRlKCkgZm9yIERJR0xJTSBiZWNvbWVzOgo+Cj4g
ICAgICAgICAgaW5mbyA9IGZzdmVyaXR5X2dldF9pbmZvKGZpbGVfaW5vZGUoY3R4LT5maWxlKSk7
Cj4gICAgICAgICAgaWYgKGluZm8pCj4gICAgICAgICAgICAgICAgICByZXQgPSBmc3Zlcml0eV9n
ZXRfZmlsZV9kaWdlc3QoaW5mbywgYnVmZmVyLCBzaXplb2YoYnVmZmVyKSwgJmFsZ28pOwo+Cj4g
ICAgICAgICAgaWYgKCFzdHJjbXAoZXhwZWN0LT5kYXRhLCAiZGlnbGltIikgJiYgcmV0ID4gMCkg
ewo+ICAgICAgICAgICAgICAgICAgcmV0ID0gZGlnbGltX2RpZ2VzdF9nZXRfaW5mbyhidWZmZXIs
IGFsZ28sIENPTVBBQ1RfRklMRSwgJm1vZGlmaWVycywgJmFjdGlvbnMpOwo+ICAgICAgICAgICAg
ICAgICAgaWYgKCFyZXQpCj4gICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOwo+
ICAgICAgICAgIH0KVGhpcyB3b3VsZCB3b3JrIHdpdGggdGhlIGRpZ2VzdCB3aXRoIGEgYml0IG1v
cmUgY29kZSBpbiBmcy12ZXJpdHkuIEl0CmFsc28gaGFzIGJlbmVmaXRzIGlmIHRoZXJlIGFyZSBv
dGhlciBjYWxsZXJzIHdobyB3YW50IHRoaXMgaW5mb3JtYXRpb24uCgpJIHdhcyBwbGFubmluZyBv
biBncm91cGluZyB0aGUgZGlnZXN0IGFuZCBzaWduYXR1cmUgaW50byAKYXB1YmxpY19rZXlfc2ln
bmF0dXJlCnN0cnVjdHVyZSBpbiB2OCB0byBwYXNzIHRoZSBkaWdlc3QsIGRpZ2VzdCBhbGdvcml0
aG0sZGlnZXN0IHNpemUsIHNpZ25hdHVyZQphbmQgc2lnbmF0dXJlIHNpemUgKGFzIG9wcG9zZWQg
dG8gZGVmaW5pbmcgYSBuZXcgc3RydWN0Zm9yIHRoaXMgcHVycG9zZSksCnJlZHVjaW5nIHRoZSBu
dW1iZXIgb2YgTFNNIGhvb2sgY2FsbHMgZG93biB0byBvbmUgZnVuY3Rpb25pbiBmc3Zlcml0eS4K
CkkgdGhpbmsgYm90aCBhcHByb2FjaGVzIGhhdmUgbWVyaXQuIGZzdmVyaXR5X2dldF9maWxlX2Rp
Z2VzdCBpcyBtb3JlIHVzZWZ1bAppZiB0aGVyZSBhcmUgY2FsbGVycyBvdXRzaWRlIG9mIExTTXMg
dGhhdCB3YW50IHRoaXMgaW5mb3JtYXRpb24uIFRoZSBMU00gCmhvb2sKaXMgY2xlYW5lciBpZiBv
bmx5IExTTXMgd2FudCB0aGlzIGluZm9ybWF0aW9uLgoKQXQgbGVhc3QsIGF0IHRoZSBtb21lbnQs
IGl0IHNlZW1zIGxpa2UgaXQncyBvbmx5IElQRSB3aG8gd2FudHMgdGhpcyAKaW5mb3JtYXRpb24s
CmFuZCBpdCdzIG5vdCBsaWtlIGl0IHdvbid0IGJlIGFibGUgdG8gY2hhbmdlIGxhdGVyIGlmIHRo
ZSBuZWVkIGFyaXNlcywgCmFzIHRoaXMKaXMgYWxsIGltcGxlbWVudGF0aW9uIGRldGFpbHMgdGhh
dCB3b3VsZG4ndCBlZmZlY3QgdGhlIGVuZC11c2VyLgoKSSdsbCBkZWZlciB0byBFcmljIC0gaGlz
IG9waW5pb24gaG9sZHMgdGhlIG1vc3Qgd2VpZ2h0LCBhcyBmc3Zlcml0eSB3b3VsZCBiZQp0aGUg
bWFpbiBjb2RlIGFmZmVjdGVkIGluIGVpdGhlciBjYXNlLgoKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

