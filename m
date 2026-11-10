Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=222.66.158.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316028;
	b=iSA0EnINQsv9MzCn5AL+JsV/n5ANLEYsS5TRGGT7i747VAcNZJeB+eFSXUb7EXQh2mRV
	 QtcmpchailObRytp4sPlGpD1+BIMsjwsVU9hOUBHxkCs0ERzg6K+DWozk1YVXaVHS1yca
	 qhfgDyHkAMtNUSuG7lOQulHogWJZ/rmasiqvSbiJOiTWQu2GHPgnUGpQ+5bM5eAjQUTmC
	 p/1KUKGkFS8yBEDOBtqzMJ08V6PqasHgSF0QkeYwc3uMH+bF9R7vdVneaZzokdt6KqYwx
	 PakP2+P9inppH/Gep7q5LGgfnw5ZbXcSt17gs7NMl3oBMnXGMN2/1YqaJ3npfWi6glg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316028;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-exchange-transport-fromentityheader:x-originating-ip:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:X-MAIL:
	 DKIM-Signature;
	bh=Ba40wem2kbjnlPsZCPhvCJfdJnI2qUJBJTmW1LXGook=;
	b=vVio0ZpiQgO3fmuLzuKxhhWSFWr28ywS1TyHgjpLGJPimTf0V/OPSiPjIAwJexEM0KlY
	 b34HgmIMEZPcrVlF1/BV4LnNAm68UwEO/UmaikleGoatq8Jo/vkPzXlqOX9ecqEkpIwY/
	 o/PyUd2D8BHa5Ktf3nGKJMuwxe6RKS3uNy2u47Hc1Qz5SYB4FOkRNKImL5pFHT+bjXh0y
	 5YtbUUm8J3FE+SwNP1kzARKF9992kncVY6kVhebeEE2/Fn52JoJkpjbJgAO++XhW2C75e
	 RHI39y0UfAPnJWPm2QIrq5BWKpt5WBd57YdRxGsRLEmCuoBi+Tz6uqFdypYqR/LPgSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=unisoc.com;
	spf=pass smtp.mailfrom=unisoc.com;
	dkim=pass header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=ggNXeYav;
	arc=none smtp.remote-ip=222.66.158.135
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9110A606A74C
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 13:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9110A606A74C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unisoc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=ggNXeYav
Received: from dlp.unisoc.com ([10.29.3.83])
	by SHSQR01.spreadtrum.com with ESMTPS id 6AAD6Lts027025
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 10 Nov 2026 21:06:21 +0800 (+08)
	(envelope-from weijiang.zhou@unisoc.com)
Received: from SHDLP.spreadtrum.com (unknown [10.29.3.65])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4jP6N51MSyz1VVX;
	Tue, 10 Nov 2026 21:05:57 +0800 (CST)
Received: from zeshmbx08.spreadtrum.com (10.29.3.106) by
 zeshmbx11.spreadtrum.com (10.29.3.65) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 10 Nov 2026 21:06:21 +0800
Received: from zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb]) by
 zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb%17]) with mapi id
 15.00.1497.048; Tue, 10 Nov 2026 21:06:21 +0800
From: =?gb2312?B?1tzOsL2tIChXZWlqaWFuZyBaaG91KQ==?= <weijiang.zhou@unisoc.com>
To: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski
	<bmarzins@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?gb2312?B?vfC67NPuIChIb25neXUgSmluKQ==?= <hongyu.jin@unisoc.com>,
        =?gb2312?B?zuLP6cK7IChYaWFuZ2x1IFd1KQ==?= <Xianglu.Wu@unisoc.com>,
        =?gb2312?B?zuLW3L61IChKdXN0aW4gV3Up?= <Justin.Wu@unisoc.com>
Subject: [RFC PATCH 2/2] dm-verity: don't restart or panic on errors during
 system shutdown
Thread-Topic: [RFC PATCH 2/2] dm-verity: don't restart or panic on errors
 during system shutdown
Thread-Index: Ad1xFEcg0r/L7A8KS1aenlaZsuMkpw==
Date: Tue, 10 Nov 2026 13:06:21 +0000
Message-ID: <9cc9b5c7460d4b0db002e7954b2eb893@zeshmbx08.spreadtrum.com>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
In-Reply-To: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="gb2312"
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
X-MAIL:SHSQR01.spreadtrum.com 6AAD6Lts027025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1794316009;
	bh=Ba40wem2kbjnlPsZCPhvCJfdJnI2qUJBJTmW1LXGook=;
	h=From:To:CC:Subject:Date:References:In-Reply-To;
	b=ggNXeYavulXeYfVs9WgrEP3zmC4I5BIJbtvAw2v5fOhIqVelc6RiE0I84HbbeErIu
	 ckvrAYXfKg00C720ojZziFq6CdaNrAFacE4L9j9Qp6g8qiT4MHwGsjwJWS8nTM8pU0
	 LogF+ETd/eUqqxijN8rHs7PRKkNmPy2mdIR7RMFCDGvAABTFd7PP/Cn7FZYq55cf+z
	 A4eD5FkT8kj3iEyPe79UgaK1g/CkRGsDahosT4SgVgEpeTub2C6FVn5OsT5DrRHF8w
	 6xYrGgxTLpPI1Y7mbdXP9vyYunj1g9f/diPTwWu7NYnRTq8Ibv3sActesb5nNRfJ8X
	 CUCKDFUJ+B/7Q==

Q29tbWl0IDI1MmJkMTI1NjM5NiAoImRtIHZlcml0eTogc2tpcCB2ZXJpdHkgd29yayBpZiBJL08g
ZXJyb3Igd2hlbiBzeXN0ZW0NCmlzIHNodXR0aW5nIGRvd24iKSBzdG9wcGVkIEkvTyBlcnJvcnMg
ZHVyaW5nIHNodXRkb3duIGZyb20gdHJpZ2dlcmluZyBhDQpyZXN0YXJ0LCBzaW5jZSBkZXZpY2Vz
IG1heSBsZWdpdGltYXRlbHkgYmUgZ29uZSBieSB0aGVuLiBFcnJvcnMgdGhhdCByZWFjaA0KdmVy
aXR5X2hhbmRsZV9lcnIoKSwgZS5nLiB0aHJvdWdoIGEgZmFpbGVkIGhhc2ggYmxvY2sgcmVhZCBm
b2xsb3dlZCBieSBhDQpmYWlsZWQgRkVDIGF0dGVtcHQsIGFyZSBub3QgY292ZXJlZCBhbmQgc3Rp
bGwgY2FsbCBrZXJuZWxfcmVzdGFydCgpIG9yDQpwYW5pYygpLg0KDQpEdXJpbmcgYSByZWJvb3Qg
dGhhdCBpcyBib3RoIHdyb25nIChub3RoaW5nIGlzIGNvcnJ1cHQpIGFuZCBoYXJtZnVsOiBpdA0K
cmFjZXMgd2l0aCB0aGUgcmVib290IGFscmVhZHkgaW4gcHJvZ3Jlc3MgYW5kIHJlcGxhY2VzIGl0
cyByZWFzb24gd2l0aA0KImRtLXZlcml0eSBkZXZpY2UgY29ycnVwdGVkIiwgd2hpY2ggYm9vdGxv
YWRlcnMgc3VjaCBhcyBBbmRyb2lkJ3MgdHJlYXQgYXMNCmEgdmVyaXR5IGZhaWx1cmUgYW5kIHN3
aXRjaCB0aGUgZGV2aWNlIHRvIEVJTyBtb2RlLg0KDQpBcHBseSB0aGUgc2FtZSBzaHV0ZG93biBj
aGVjayBpbiB2ZXJpdHlfaGFuZGxlX2VycigpLiBDb3JydXB0aW9uIGlzIHN0aWxsDQpsb2dnZWQs
IHJlY29yZGVkIGluIGhhc2hfZmFpbGVkIGFuZCByZXBvcnRlZCB2aWEgdWV2ZW50LCBhbmQgdGhl
IEkvTyBzdGlsbA0KZmFpbHMuDQoNClNpZ25lZC1vZmYtYnk6IEhvbmd5dSBKaW4gPGhvbmd5dS5q
aW5AdW5pc29jLmNvbT4NClNpZ25lZC1vZmYtYnk6IHdlaWppYW5nLnpob3UgPHdlaWppYW5nLnpo
b3VAdW5pc29jLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jIHwgMjcg
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlv
bnMoKyksIDkgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXZlcml0
eS10YXJnZXQuYyBiL2RyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jDQppbmRleCA0MmVlMjRk
ODIzZTMuLjc1NmYxMjAyNDkwYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvZG0tdmVyaXR5LXRh
cmdldC5jDQorKysgYi9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYw0KQEAgLTE2OSw2ICsx
NjksMTUgQEAgc3RhdGljIHZvaWQgdmVyaXR5X2hhc2hfYXRfbGV2ZWwoc3RydWN0IGRtX3Zlcml0
eSAqdiwgc2VjdG9yX3QgYmxvY2ssIGludCBsZXZlbCwNCiAqb2Zmc2V0ID0gaWR4IDw8ICh2LT5o
YXNoX2Rldl9ibG9ja19iaXRzIC0gdi0+aGFzaF9wZXJfYmxvY2tfYml0cyk7DQogfQ0KDQorLyoN
CisgKiBTa2lwIHZlcml0eSB3b3JrIGluIHJlc3BvbnNlIHRvIEkvTyBlcnJvciB3aGVuIHN5c3Rl
bSBpcyBzaHV0dGluZyBkb3duLg0KKyAqLw0KK3N0YXRpYyBpbmxpbmUgYm9vbCB2ZXJpdHlfaXNf
c3lzdGVtX3NodXR0aW5nX2Rvd24odm9pZCkNCit7DQorcmV0dXJuIHN5c3RlbV9zdGF0ZSA9PSBT
WVNURU1fSEFMVCB8fCBzeXN0ZW1fc3RhdGUgPT0gU1lTVEVNX1BPV0VSX09GRg0KK3x8IHN5c3Rl
bV9zdGF0ZSA9PSBTWVNURU1fUkVTVEFSVDsNCit9DQorDQogLyoNCiAgKiBIYW5kbGUgdmVyaWZp
Y2F0aW9uIGVycm9ycy4NCiAgKi8NCkBAIC0yMTYsNiArMjI1LDE1IEBAIHN0YXRpYyBpbnQgdmVy
aXR5X2hhbmRsZV9lcnIoc3RydWN0IGRtX3Zlcml0eSAqdiwgZW51bSB2ZXJpdHlfYmxvY2tfdHlw
ZSB0eXBlLA0KIGlmICh2LT5tb2RlID09IERNX1ZFUklUWV9NT0RFX0xPR0dJTkcpDQogcmV0dXJu
IDA7DQoNCisvKg0KKyAqIERldmljZXMgbWF5IGFscmVhZHkgYmUgcXVpZXNjZWQgKGUuZy4gVUZT
IHNldCBvZmZsaW5lIGJ5IGl0cw0KKyAqIHNodXRkb3duIGhvb2spLCBzbyBhIGZhaWx1cmUgaGVy
ZSBkb2VzIG5vdCBpbXBseSBjb3JydXB0aW9uLiAgRmFpbA0KKyAqIHRoZSBJL08gYnV0IGRvIG5v
dCByZXN0YXJ0IG9yIHBhbmljLCB3aGljaCB3b3VsZCBhbHNvIG92ZXJyaWRlIHRoZQ0KKyAqIHJl
Ym9vdCByZWFzb24gb2YgdGhlIHNodXRkb3duIGFscmVhZHkgaW4gcHJvZ3Jlc3MuDQorICovDQor
aWYgKHZlcml0eV9pc19zeXN0ZW1fc2h1dHRpbmdfZG93bigpKQ0KK3JldHVybiAxOw0KKw0KIGlm
ICh2LT5tb2RlID09IERNX1ZFUklUWV9NT0RFX1JFU1RBUlQpDQoga2VybmVsX3Jlc3RhcnQoImRt
LXZlcml0eSBkZXZpY2UgY29ycnVwdGVkIik7DQoNCkBAIC01OTgsMTUgKzYxNiw2IEBAIHN0YXRp
YyBpbnQgdmVyaXR5X3ZlcmlmeV9pbyhzdHJ1Y3QgZG1fdmVyaXR5X2lvICppbykNCiByZXR1cm4g
cjsNCiB9DQoNCi0vKg0KLSAqIFNraXAgdmVyaXR5IHdvcmsgaW4gcmVzcG9uc2UgdG8gSS9PIGVy
cm9yIHdoZW4gc3lzdGVtIGlzIHNodXR0aW5nIGRvd24uDQotICovDQotc3RhdGljIGlubGluZSBi
b29sIHZlcml0eV9pc19zeXN0ZW1fc2h1dHRpbmdfZG93bih2b2lkKQ0KLXsNCi1yZXR1cm4gc3lz
dGVtX3N0YXRlID09IFNZU1RFTV9IQUxUIHx8IHN5c3RlbV9zdGF0ZSA9PSBTWVNURU1fUE9XRVJf
T0ZGDQotfHwgc3lzdGVtX3N0YXRlID09IFNZU1RFTV9SRVNUQVJUOw0KLX0NCi0NCiBzdGF0aWMg
dm9pZCByZXN0YXJ0X2lvX2Vycm9yKHN0cnVjdCB3b3JrX3N0cnVjdCAqdykNCiB7DQoga2VybmVs
X3Jlc3RhcnQoImRtLXZlcml0eSBkZXZpY2UgaGFzIEkvTyBlcnJvciIpOw0KLS0NCjIuNDMuMA0K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCiBUaGlzIGVtYWlsIChpbmNsdWRpbmcg
aXRzIGF0dGFjaG1lbnRzKSBpcyBpbnRlbmRlZCBvbmx5IGZvciB0aGUgcGVyc29uIG9yIGVudGl0
eSB0byB3aGljaCBpdCBpcyBhZGRyZXNzZWQgYW5kIG1heSBjb250YWluIGluZm9ybWF0aW9uIHRo
YXQgaXMgcHJpdmlsZWdlZCwgY29uZmlkZW50aWFsIG9yIG90aGVyd2lzZSBwcm90ZWN0ZWQgZnJv
bSBkaXNjbG9zdXJlLiBVbmF1dGhvcml6ZWQgdXNlLCBkaXNzZW1pbmF0aW9uLCBkaXN0cmlidXRp
b24gb3IgY29weWluZyBvZiB0aGlzIGVtYWlsIG9yIHRoZSBpbmZvcm1hdGlvbiBoZXJlaW4gb3Ig
dGFraW5nIGFueSBhY3Rpb24gaW4gcmVsaWFuY2Ugb24gdGhlIGNvbnRlbnRzIG9mIHRoaXMgZW1h
aWwgb3IgdGhlIGluZm9ybWF0aW9uIGhlcmVpbiwgYnkgYW55b25lIG90aGVyIHRoYW4gdGhlIGlu
dGVuZGVkIHJlY2lwaWVudCwgb3IgYW4gZW1wbG95ZWUgb3IgYWdlbnQgcmVzcG9uc2libGUgZm9y
IGRlbGl2ZXJpbmcgdGhlIG1lc3NhZ2UgdG8gdGhlIGludGVuZGVkIHJlY2lwaWVudCwgaXMgc3Ry
aWN0bHkgcHJvaGliaXRlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwg
cGxlYXNlIGRvIG5vdCByZWFkLCBjb3B5LCB1c2Ugb3IgZGlzY2xvc2UgYW55IHBhcnQgb2YgdGhp
cyBlLW1haWwgdG8gb3RoZXJzLiBQbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkg
YW5kIHBlcm1hbmVudGx5IGRlbGV0ZSB0aGlzIGUtbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGlm
IHlvdSByZWNlaXZlZCBpdCBpbiBlcnJvci4gSW50ZXJuZXQgY29tbXVuaWNhdGlvbnMgY2Fubm90
IGJlIGd1YXJhbnRlZWQgdG8gYmUgdGltZWx5LCBzZWN1cmUsIGVycm9yLWZyZWUgb3IgdmlydXMt
ZnJlZS4gVGhlIHNlbmRlciBkb2VzIG5vdCBhY2NlcHQgbGlhYmlsaXR5IGZvciBhbnkgZXJyb3Jz
IG9yIG9taXNzaW9ucy4NCrG+08q8/rywxuS4vbz+vt/T0LGjw9zQ1NbKo6zK3Leowsmxo7uksru1
w9C5wrajrL32t6LLzbj4sb7Tyrz+y/nWuMzYtqjK1bz+yMuho9HPvfu3x76tytrIqMq508OhotD7
tKuhoreisry78ri01saxvtPKvP678sbkxNrI3aGjyPS3x7jDzNi2qMrVvP7Iy6Osx+vO8NTEtsGh
ori01sahoiDKudPDu/LF+8K2sb7Tyrz+tcTIzrrOxNrI3aGjyPTO88rVsb7Tyrz+o6zH67TTz7XN
s9bQ08C+w9DUyb6z/bG+08q8/rywy/nT0Li9vP6jrLKi0tS72Li008q8/rXEt73Kvby0v8y45taq
t6K8/sjLoaPO3reosaPWpLulwarN+M2o0MW8sMqxoaKwssiroaLO3s7zu/K3wLa+oaO3orz+yMu2
1MjOus607cKpvvmyu7PQtaPU8MjOoaMNCg==
