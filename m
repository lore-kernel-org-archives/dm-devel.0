Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=222.66.158.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794366908;
	b=roixtL/vn7MQ5ZxFnzjCoviekUH84kT0Zk4Cbh+t4o5BxAbM0DY14GWdYWDnpgwgXkCV
	 0MRcwgrLLSk/jnqMFufSAilys/eyqeaYc8AVwIX3aveZsza0WxTuamY2UKiA5DDM2kGuR
	 Z1+ShxpehYNWLHz8yHtvuKcrDbRPjIxMpJkCAHjkUG2Kw7JF9kGWkEn7BSQ62LhIBKgd9
	 gGh7OTUE1Tf6t+URopj/F+rfjuGZLuJDCaco5+rI2EqU+c31+f/z04vU9MOUbctbkmaGU
	 YpfhjtJTHQt3NWvCTt5D6j/5DXAP9946ChrzLePOKc/NKQMjZ5HFeRe5s1vjK3ggLWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794366908;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-exchange-messagesentrepresentingtype:
	 x-ms-exchange-transport-fromentityheader:x-originating-ip:
	 Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:X-MAIL:
	 DKIM-Signature;
	bh=Yr+/+VHLw+e4MSWAfYoyPpB2Pll1rvsRg9E/L86xXJw=;
	b=IKrlURXhb32SiRs9IkEqwwigt1etTIKGuW6JBWr+emfkucnmU2QUyTygTkE3Nbw3m5Z9
	 oircEYYvNmgMIIuuNjQcmlHZyfeExmsTeUvtluNS1ThMofQ1iQMnn7G4ShfvJTlsHXJ29
	 L76Q4OKx/HzQvSLKwyfyfnj4KZB4r+Z9/cogyj3fukhwdtvLJF5OfN4ha6LA4OgxokMOq
	 B2O4T45t3YPmAhHNL0R1GVWA/j+n2mknvJOTzjgVvgnEBiUbPFdvcFkAmfSZQPNh9YqAl
	 5LYg8KNinUrFd87/FbuQFS/LnD7XP/cBlKgF6fDnk/e4aLeMDDRjJBSX854yv3tb09g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=unisoc.com;
	spf=pass smtp.mailfrom=unisoc.com;
	dkim=pass header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=OKqlbo7I;
	arc=none smtp.remote-ip=222.66.158.135
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD08606A324
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 03:15:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DD08606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unisoc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=OKqlbo7I
Received: from dlp.unisoc.com ([10.29.3.83])
	by SHSQR01.spreadtrum.com with ESMTPS id 6AB3ETsF011450
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 11 Nov 2026 11:14:29 +0800 (+08)
	(envelope-from weijiang.zhou@unisoc.com)
Received: from SHDLP.spreadtrum.com (unknown [10.29.3.65])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4jPTBg1MSGz1VVX;
	Wed, 11 Nov 2026 11:14:03 +0800 (CST)
Received: from zeshmbx08.spreadtrum.com (10.29.3.106) by
 zeshmbx11.spreadtrum.com (10.29.3.65) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 11 Nov 2026 11:14:28 +0800
Received: from zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb]) by
 zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb%17]) with mapi id
 15.00.1497.048; Wed, 11 Nov 2026 11:14:28 +0800
From: =?utf-8?B?5ZGo5Lyf5rGfIChXZWlqaWFuZyBaaG91KQ==?=
	<weijiang.zhou@unisoc.com>
To: Mikulas Patocka <mpatocka@redhat.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
        Alasdair Kergon
	<agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski
	<bmarzins@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?utf-8?B?6YeR57qi5a6HIChIb25neXUgSmluKQ==?= <hongyu.jin@unisoc.com>,
        =?utf-8?B?5ZC056Wl56aEIChYaWFuZ2x1IFd1KQ==?= <Xianglu.Wu@unisoc.com>,
        =?utf-8?B?5ZC05ZGo6ZWcIChKdXN0aW4gV3Up?= <Justin.Wu@unisoc.com>,
        "dhavale@google.com" <dhavale@google.com>,
        "ebiggers@google.com"
	<ebiggers@google.com>
Subject: Re: [RFC PATCH 2/2] dm-verity: don't restart or panic on errors
 during system shutdown
Thread-Topic: [RFC PATCH 2/2] dm-verity: don't restart or panic on errors
 during system shutdown
Thread-Index: Ad1xFEcg0r/L7A8KS1aenlaZsuMkpwAAPusAAAwyPYA=
Date: Wed, 11 Nov 2026 03:14:28 +0000
Message-ID: <179436615561.34024.4719948965871294246@unisoc.com>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
 <9cc9b5c7460d4b0db002e7954b2eb893@zeshmbx08.spreadtrum.com>
 <5587e2d9-3286-b867-254a-035543e284cd@redhat.com>
In-Reply-To: <5587e2d9-3286-b867-254a-035543e284cd@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F0FC22D08E2AB4C96D47C71DC48EA14@unisoc.com>
Content-Transfer-Encoding: base64
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MAIL:SHSQR01.spreadtrum.com 6AB3ETsF011450
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1794366886;
	bh=Yr+/+VHLw+e4MSWAfYoyPpB2Pll1rvsRg9E/L86xXJw=;
	h=From:To:CC:Subject:Date:References:In-Reply-To;
	b=OKqlbo7IQ5vHk/jAQVoTyAeXaXAjVQ7pjTsKNAN6zcbOwXvKJ0ucxKjNUxtosUlY5
	 90aNH/87ZVKmsf+OvTn8DogHWE3wvTcOur2Jl4QfaIPJQxZXPg6JWdvNTyVlgGNsR6
	 LVmpjvA9IjzCymqZGvUmTY2E5c1cU702LEJT4IYeviBl1olQjTG+ufmpkyXc0ewGFX
	 fmgF5YQVbUq56ZWeTOfoJy93cV3kk68Ik4opbuqvDkbWON4ZDNjcdhOEcLO6/aCsy2
	 M2ErLLhbFr6LHIqvxOcIygQEpJXAcVunZkpAxWs0ndb3JvzJ/K4RJjk7JlHBTWtLVW
	 HDVUgPiYa0ANA==

SGkgTWlrdWxhcywNCg0KdGhhbmtzIGZvciB0aGUgcmV2aWV3LCBhbmQgc29ycnkgYWJvdXQgdGhl
IFRBQnMuICBUaGV5IHdlcmUgbm90IGxvc3Qgd2hpbGUNCmNvbXBvc2luZzogdGhlIG1lc3NhZ2Ug
bGVmdCBteSBjbGllbnQgaW50YWN0LCBhbmQgdGhlIHJpY2gtdGV4dCBwYXRoIG9mIG91cg0KY29y
cG9yYXRlIG1haWwgc2V0dXAgcmUtZW5jb2RlZCB0aGUgdGV4dCBwYXJ0IG9uIHRoZSB3YXkgb3V0
LCBkcm9wcGVkIGV2ZXJ5DQpUQUIgYW5kIHJlZmxvd2VkIHRoZSBsb25nIGxpbmVzLg0KDQpJIGhh
dmUgbW92ZWQgdG8gYSBzdWJtaXNzaW9uIHBhdGggdGhhdCBoYW5kcyB0aGUgTUlNRSB0byB0aGUg
c2VydmVyIGJ5dGUgZm9yDQpieXRlLCBhbmQgY2hlY2tlZCB0aGUgcm91bmQgdHJpcCB0aHJvdWdo
IGEgbWFpbGJveCBmaXJzdC4gIFRoZSBwYXRjaCBiZWxvdyBpcw0KdGhlIHNhbWUgcGF0Y2gsIHVu
Y2hhbmdlZCAtIG5vIGNvZGUgd2FzIHRvdWNoZWQgc2luY2UgeW91ciByZXZpZXcsIG9ubHkgdGhl
DQp3aGl0ZXNwYWNlIGlzIGJhY2suDQoNClRoYW5rcywNCldlaWppYW5nDQoNCkNvbW1pdCAyNTJi
ZDEyNTYzOTYgKCJkbSB2ZXJpdHk6IHNraXAgdmVyaXR5IHdvcmsgaWYgSS9PIGVycm9yIHdoZW4g
c3lzdGVtDQppcyBzaHV0dGluZyBkb3duIikgc3RvcHBlZCBJL08gZXJyb3JzIGR1cmluZyBzaHV0
ZG93biBmcm9tIHRyaWdnZXJpbmcgYQ0KcmVzdGFydCwgc2luY2UgZGV2aWNlcyBtYXkgbGVnaXRp
bWF0ZWx5IGJlIGdvbmUgYnkgdGhlbi4gRXJyb3JzIHRoYXQgcmVhY2gNCnZlcml0eV9oYW5kbGVf
ZXJyKCksIGUuZy4gdGhyb3VnaCBhIGZhaWxlZCBoYXNoIGJsb2NrIHJlYWQgZm9sbG93ZWQgYnkg
YQ0KZmFpbGVkIEZFQyBhdHRlbXB0LCBhcmUgbm90IGNvdmVyZWQgYW5kIHN0aWxsIGNhbGwga2Vy
bmVsX3Jlc3RhcnQoKSBvcg0KcGFuaWMoKS4NCg0KRHVyaW5nIGEgcmVib290IHRoYXQgaXMgYm90
aCB3cm9uZyAobm90aGluZyBpcyBjb3JydXB0KSBhbmQgaGFybWZ1bDogaXQNCnJhY2VzIHdpdGgg
dGhlIHJlYm9vdCBhbHJlYWR5IGluIHByb2dyZXNzIGFuZCByZXBsYWNlcyBpdHMgcmVhc29uIHdp
dGgNCiJkbS12ZXJpdHkgZGV2aWNlIGNvcnJ1cHRlZCIsIHdoaWNoIGJvb3Rsb2FkZXJzIHN1Y2gg
YXMgQW5kcm9pZCdzIHRyZWF0IGFzDQphIHZlcml0eSBmYWlsdXJlIGFuZCBzd2l0Y2ggdGhlIGRl
dmljZSB0byBFSU8gbW9kZS4NCg0KQXBwbHkgdGhlIHNhbWUgc2h1dGRvd24gY2hlY2sgaW4gdmVy
aXR5X2hhbmRsZV9lcnIoKS4gQ29ycnVwdGlvbiBpcyBzdGlsbA0KbG9nZ2VkLCByZWNvcmRlZCBp
biBoYXNoX2ZhaWxlZCBhbmQgcmVwb3J0ZWQgdmlhIHVldmVudCwgYW5kIHRoZSBJL08gc3RpbGwN
CmZhaWxzLg0KDQpTaWduZWQtb2ZmLWJ5OiBIb25neXUgSmluIDxob25neXUuamluQHVuaXNvYy5j
b20+DQpTaWduZWQtb2ZmLWJ5OiB3ZWlqaWFuZy56aG91IDx3ZWlqaWFuZy56aG91QHVuaXNvYy5j
b20+DQotLS0NCiBkcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYyB8IDI3ICsrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA5IGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS12ZXJpdHktdGFyZ2V0LmMg
Yi9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYw0KaW5kZXggNDJlZTI0ZDgyM2UzLi43NTZm
MTIwMjQ5MGIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYw0KKysr
IGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdGFyZ2V0LmMNCkBAIC0xNjksNiArMTY5LDE1IEBAIHN0
YXRpYyB2b2lkIHZlcml0eV9oYXNoX2F0X2xldmVsKHN0cnVjdCBkbV92ZXJpdHkgKnYsIHNlY3Rv
cl90IGJsb2NrLCBpbnQgbGV2ZWwsDQogKm9mZnNldCA9IGlkeCA8PCAodi0+aGFzaF9kZXZfYmxv
Y2tfYml0cyAtIHYtPmhhc2hfcGVyX2Jsb2NrX2JpdHMpOw0KIH0NCg0KKy8qDQorICogU2tpcCB2
ZXJpdHkgd29yayBpbiByZXNwb25zZSB0byBJL08gZXJyb3Igd2hlbiBzeXN0ZW0gaXMgc2h1dHRp
bmcgZG93bi4NCisgKi8NCitzdGF0aWMgaW5saW5lIGJvb2wgdmVyaXR5X2lzX3N5c3RlbV9zaHV0
dGluZ19kb3duKHZvaWQpDQorew0KK3JldHVybiBzeXN0ZW1fc3RhdGUgPT0gU1lTVEVNX0hBTFQg
fHwgc3lzdGVtX3N0YXRlID09IFNZU1RFTV9QT1dFUl9PRkYNCit8fCBzeXN0ZW1fc3RhdGUgPT0g
U1lTVEVNX1JFU1RBUlQ7DQorfQ0KKw0KIC8qDQogICogSGFuZGxlIHZlcmlmaWNhdGlvbiBlcnJv
cnMuDQogICovDQpAQCAtMjE2LDYgKzIyNSwxNSBAQCBzdGF0aWMgaW50IHZlcml0eV9oYW5kbGVf
ZXJyKHN0cnVjdCBkbV92ZXJpdHkgKnYsIGVudW0gdmVyaXR5X2Jsb2NrX3R5cGUgdHlwZSwNCiBp
ZiAodi0+bW9kZSA9PSBETV9WRVJJVFlfTU9ERV9MT0dHSU5HKQ0KIHJldHVybiAwOw0KDQorLyoN
CisgKiBEZXZpY2VzIG1heSBhbHJlYWR5IGJlIHF1aWVzY2VkIChlLmcuIFVGUyBzZXQgb2ZmbGlu
ZSBieSBpdHMNCisgKiBzaHV0ZG93biBob29rKSwgc28gYSBmYWlsdXJlIGhlcmUgZG9lcyBub3Qg
aW1wbHkgY29ycnVwdGlvbi4gIEZhaWwNCisgKiB0aGUgSS9PIGJ1dCBkbyBub3QgcmVzdGFydCBv
ciBwYW5pYywgd2hpY2ggd291bGQgYWxzbyBvdmVycmlkZSB0aGUNCisgKiByZWJvb3QgcmVhc29u
IG9mIHRoZSBzaHV0ZG93biBhbHJlYWR5IGluIHByb2dyZXNzLg0KKyAqLw0KK2lmICh2ZXJpdHlf
aXNfc3lzdGVtX3NodXR0aW5nX2Rvd24oKSkNCityZXR1cm4gMTsNCisNCiBpZiAodi0+bW9kZSA9
PSBETV9WRVJJVFlfTU9ERV9SRVNUQVJUKQ0KIGtlcm5lbF9yZXN0YXJ0KCJkbS12ZXJpdHkgZGV2
aWNlIGNvcnJ1cHRlZCIpOw0KDQpAQCAtNTk4LDE1ICs2MTYsNiBAQCBzdGF0aWMgaW50IHZlcml0
eV92ZXJpZnlfaW8oc3RydWN0IGRtX3Zlcml0eV9pbyAqaW8pDQogcmV0dXJuIHI7DQogfQ0KDQot
LyoNCi0gKiBTa2lwIHZlcml0eSB3b3JrIGluIHJlc3BvbnNlIHRvIEkvTyBlcnJvciB3aGVuIHN5
c3RlbSBpcyBzaHV0dGluZyBkb3duLg0KLSAqLw0KLXN0YXRpYyBpbmxpbmUgYm9vbCB2ZXJpdHlf
aXNfc3lzdGVtX3NodXR0aW5nX2Rvd24odm9pZCkNCi17DQotcmV0dXJuIHN5c3RlbV9zdGF0ZSA9
PSBTWVNURU1fSEFMVCB8fCBzeXN0ZW1fc3RhdGUgPT0gU1lTVEVNX1BPV0VSX09GRg0KLXx8IHN5
c3RlbV9zdGF0ZSA9PSBTWVNURU1fUkVTVEFSVDsNCi19DQotDQogc3RhdGljIHZvaWQgcmVzdGFy
dF9pb19lcnJvcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKncpDQogew0KIGtlcm5lbF9yZXN0YXJ0KCJk
bS12ZXJpdHkgZGV2aWNlIGhhcyBJL08gZXJyb3IiKTsNCi0tDQoyLjQzLjANCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fDQogVGhpcyBlbWFpbCAoaW5jbHVkaW5nIGl0cyBhdHRhY2ht
ZW50cykgaXMgaW50ZW5kZWQgb25seSBmb3IgdGhlIHBlcnNvbiBvciBlbnRpdHkgdG8gd2hpY2gg
aXQgaXMgYWRkcmVzc2VkIGFuZCBtYXkgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzIHByaXZp
bGVnZWQsIGNvbmZpZGVudGlhbCBvciBvdGhlcndpc2UgcHJvdGVjdGVkIGZyb20gZGlzY2xvc3Vy
ZS4gVW5hdXRob3JpemVkIHVzZSwgZGlzc2VtaW5hdGlvbiwgZGlzdHJpYnV0aW9uIG9yIGNvcHlp
bmcgb2YgdGhpcyBlbWFpbCBvciB0aGUgaW5mb3JtYXRpb24gaGVyZWluIG9yIHRha2luZyBhbnkg
YWN0aW9uIGluIHJlbGlhbmNlIG9uIHRoZSBjb250ZW50cyBvZiB0aGlzIGVtYWlsIG9yIHRoZSBp
bmZvcm1hdGlvbiBoZXJlaW4sIGJ5IGFueW9uZSBvdGhlciB0aGFuIHRoZSBpbnRlbmRlZCByZWNp
cGllbnQsIG9yIGFuIGVtcGxveWVlIG9yIGFnZW50IHJlc3BvbnNpYmxlIGZvciBkZWxpdmVyaW5n
IHRoZSBtZXNzYWdlIHRvIHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIGlzIHN0cmljdGx5IHByb2hp
Yml0ZWQuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBkbyBu
b3QgcmVhZCwgY29weSwgdXNlIG9yIGRpc2Nsb3NlIGFueSBwYXJ0IG9mIHRoaXMgZS1tYWlsIHRv
IG90aGVycy4gUGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBwZXJtYW5l
bnRseSBkZWxldGUgdGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBpZiB5b3UgcmVjZWl2
ZWQgaXQgaW4gZXJyb3IuIEludGVybmV0IGNvbW11bmljYXRpb25zIGNhbm5vdCBiZSBndWFyYW50
ZWVkIHRvIGJlIHRpbWVseSwgc2VjdXJlLCBlcnJvci1mcmVlIG9yIHZpcnVzLWZyZWUuIFRoZSBz
ZW5kZXIgZG9lcyBub3QgYWNjZXB0IGxpYWJpbGl0eSBmb3IgYW55IGVycm9ycyBvciBvbWlzc2lv
bnMuDQrmnKzpgq7ku7blj4rlhbbpmYTku7blhbfmnInkv53lr4bmgKfotKjvvIzlj5fms5Xlvovk
v53miqTkuI3lvpfms4TpnLLvvIzku4Xlj5HpgIHnu5nmnKzpgq7ku7bmiYDmjIfnibnlrprmlLbk
u7bkurrjgILkuKXnpoHpnZ7nu4/mjojmnYPkvb/nlKjjgIHlrqPkvKDjgIHlj5HluIPmiJblpI3l
iLbmnKzpgq7ku7bmiJblhbblhoXlrrnjgILoi6XpnZ7or6XnibnlrprmlLbku7bkurrvvIzor7fl
i7/pmIXor7vjgIHlpI3liLbjgIEg5L2/55So5oiW5oqr6Zyy5pys6YKu5Lu255qE5Lu75L2V5YaF
5a6544CC6Iul6K+v5pS25pys6YKu5Lu277yM6K+35LuO57O757uf5Lit5rC45LmF5oCn5Yig6Zmk
5pys6YKu5Lu25Y+K5omA5pyJ6ZmE5Lu277yM5bm25Lul5Zue5aSN6YKu5Lu255qE5pa55byP5Y2z
5Yi75ZGK55+l5Y+R5Lu25Lq644CC5peg5rOV5L+d6K+B5LqS6IGU572R6YCa5L+h5Y+K5pe244CB
5a6J5YWo44CB5peg6K+v5oiW6Ziy5q+S44CC5Y+R5Lu25Lq65a+55Lu75L2V6ZSZ5ryP5Z2H5LiN
5om/5ouF6LSj5Lu744CCDQo=
