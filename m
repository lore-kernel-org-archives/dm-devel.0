Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=222.66.158.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794366902;
	b=dXRqYCedwbDzi4rxi3O1iz7fx2N3aZDkp+fspN2kREAE8603U8GO9W2fiS8SrLvZe584
	 L295BR4C6XkGsfnHgU3ApMiCrI5JVJCdrfWjNQ76ouis4X5TvSMLKdP5fej3OesSJ3gVT
	 cTj4WkUM6KugQpU4VENr79/r7j2eicPqqYthnuARr1SDAzsnVu3EkDVnQR+i9OeuQA+6s
	 7LK+ClIqABVlc/5VIkj8KnAhtcHg7Gn2uYLQ37+MWb/poYIGNKXKQbUOo/wBWIgcWZcJ9
	 9ckxHgn/BB/89bKjdJ+n6eamL5YvOW9Cuc9Ndsz/zwBOQd9CgxnwJXPlhDlNd49Nf4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794366902;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-exchange-messagesentrepresentingtype:
	 x-ms-exchange-transport-fromentityheader:x-originating-ip:
	 Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:X-MAIL:
	 DKIM-Signature;
	bh=LP5vSaOTjOCbQ64gqUZ0UnioyyQO+8fZYWIbHMkXc24=;
	b=mdJN3CTpLWjcgb8rmEGiiWk/SJxT9cUJoxU6UBs5rNxHr47HoItA2xhY1QSb9rois2Y5
	 FeNxxxVPoMXODlQTnEXIsAmSGA4ZaT7VvShylyan6EIvFkOvtO1Ty4PkfbibxF6Glljl9
	 e40F3yf2L6kzBfiI6U6SPaZnY7ZIWSwt2XMWTF5s21NYz9W6v3aWmEz06vlq5KT8xvUo0
	 74Xpm9/A1Kh2+xze5ZMO1fJo7GGF2yroknbGqfZ2wv6F1FbmPSqp8663tns3OpFgcjOoG
	 N/WIsAvPSLzV4FN96bnGK03tKGQwmc280ISpkoMAl7SV3JJpZxlNkZ4osjeax6irPrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=unisoc.com;
	spf=pass smtp.mailfrom=unisoc.com;
	dkim=pass header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=TCijMQEz;
	arc=none smtp.remote-ip=222.66.158.135
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097F8606A321
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 03:15:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 097F8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unisoc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=TCijMQEz
Received: from dlp.unisoc.com ([10.29.3.83])
	by SHSQR01.spreadtrum.com with ESMTPS id 6AB3ELwN010681
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 11 Nov 2026 11:14:21 +0800 (+08)
	(envelope-from weijiang.zhou@unisoc.com)
Received: from SHDLP.spreadtrum.com (unknown [10.0.1.210])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4jPTBW1vyYz1VVX;
	Wed, 11 Nov 2026 11:13:55 +0800 (CST)
Received: from zeshmbx08.spreadtrum.com (10.29.3.106) by
 zeshmbx02.spreadtrum.com (10.0.1.210) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 11 Nov 2026 11:14:20 +0800
Received: from zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb]) by
 zeshmbx08.spreadtrum.com ([fe80::e01e:2441:3a50:dadb%17]) with mapi id
 15.00.1497.048; Wed, 11 Nov 2026 11:14:20 +0800
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
Subject: Re: [RFC PATCH 1/2] dm-verity: don't decode FEC into a dm_bufio page
 that is already in the cache
Thread-Topic: [RFC PATCH 1/2] dm-verity: don't decode FEC into a dm_bufio page
 that is already in the cache
Thread-Index: Ad1xFEVvuq6WySSbT/mhXKvNiu015QAAD6gAAAxh7YA=
Date: Wed, 11 Nov 2026 03:14:20 +0000
Message-ID: <179436615557.34024.8414792860115638345@unisoc.com>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
 <27b2dc50d3bb497ea3f3f84e7e4b271c@zeshmbx08.spreadtrum.com>
 <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>
In-Reply-To: <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA7529458EA50A47B11756AD5220027A@unisoc.com>
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
X-MAIL:SHSQR01.spreadtrum.com 6AB3ELwN010681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1794366873;
	bh=LP5vSaOTjOCbQ64gqUZ0UnioyyQO+8fZYWIbHMkXc24=;
	h=From:To:CC:Subject:Date:References:In-Reply-To;
	b=TCijMQEz0Jw11GKdFG+CLW3tTbeO4g9eP7jcMIDzt7+qzFBTRj8uVzCyPdVpVkHF2
	 clZ7k4rfdcq6D5rx538NS07iQfS1HApnIOe/B36hQ5NGqQUyOdcUIF28/MGahnMeE9
	 mVJ9dKvnKrsdV5rsewa9o0fPs1fPL/0na6i2cdWCtTnhUpJALvI6cuFivzpre3unGe
	 w7Twj26WL/11XQmm+5gJit0xfwwi00IqODaktJFVkZHMbmsqDzb124GZxVhKhkEGMs
	 hemZ7cgjq2NXsikiTxY6HdmHGsoEhYe3PnfxYHnBwGepoFVL2BSq17p7UybPSFkDUc
	 MnEjJohKLIvnA==

SGkgTWlrdWxhcywNCg0KdGhhbmsgeW91IGZvciB0aGUgY2FyZWZ1bCByZXZpZXcsIGFuZCBmb3Ig
cG9pbnRpbmcgc3RyYWlnaHQgYXQgd2hhdA0KbmVlZHMgdG8gYmUgZml4ZWQuICBXZSBhZ3JlZSB3
aXRoIHlvdTogdGhlIDEvMiBzZW50IGVhcmxpZXIgb25seSBoaWRlcw0KdGhlIHN5bXB0b20sIHBs
ZWFzZSBpZ25vcmUgaXQuDQoNClRvIG1ha2Ugc3VyZSB3ZSByZWFkIHRoZSBkZWZlY3QgdGhlIHNh
bWUgd2F5OiBpbiBmZWNfcmVhZF9idWZzKCkgYSBibG9jaw0Kd2hvc2UgcmVhZCBmYWlscyBpcyBy
ZWNvcmRlZCBhcyBhbiBlcmFzdXJlIG91dHJpZ2h0OyBhIGJsb2NrIHRoYXQgcmVhZHMNCmJhY2sg
ZmluZSBhbmQgbGl2ZXMgb24gdGhlIGRhdGEgZGV2aWNlIGlzIGp1ZGdlZCBieSBmZWNfaXNfZXJh
c3VyZSgpLA0Kd2hpY2ggY29tcGFyZXMgaXQgYWdhaW5zdCB0aGUgZGlnZXN0IHZlcml0eV9oYXNo
X2Zvcl9ibG9jaygpIHByb2R1Y2VkDQpmb3IgaXQuICBHZXR0aW5nIHRoYXQgZGlnZXN0IGNhbiB3
YWxrIHRoZSBoYXNoIHRyZWUgYW5kIHJlYWQsIGxldmVsIGJ5DQpsZXZlbCwgdGhlIGhhc2ggYmxv
Y2sgY292ZXJpbmcgdGhhdCBkYXRhIGJsb2NrLiAgV2hlbiB0aGUgYmxvY2sgYmVpbmcNCnJlY292
ZXJlZCBpcyBpdHNlbGYgYSBtZXRhZGF0YSBibG9jaywgYSBkYXRhIGJsb2NrIG9mIHRoZSBzYW1l
IGNvZGV3b3JkDQpjYW4gaGF2ZSBpdHMgaGFzaCBwYXRoIHJ1biB0aHJvdWdoIGl0IC0gYXQgbGV2
ZWwgMCBvbmUgb2YgdGhlIGRhdGENCmJsb2NrcyBpdCBjb3ZlcnMsIGFib3ZlIGxldmVsIDAgb25l
IG9mIHRoZSBoYXNoIGJsb2NrcyBiZWxvdyBpdC4gIFNvDQp0aGUgd2FsayBhc2tzIGZvciBleGFj
dGx5IHRoZSBibG9jayB3ZSBhcmUgcmVidWlsZGluZzogdGhlIG9uZQ0KZG1fYnVmaW9fbmV3KCkg
cHV0IGluIHRoZSBjYWNoZSBob2xkaW5nIGFsbG9jYXRvciBsZWZ0b3ZlcnMsIHdpdGggbm8NCnJl
YWQgZXZlciBpc3N1ZWQgZm9yIGl0LiAgVGhlIGRpZ2VzdCBjYW5ub3QgbWF0Y2gsIHJlY3Vyc2lv
biBpbnRvIEZFQw0KaXMgYmxvY2tlZCBieSBmaW8tPmxldmVsLCBhbmQgdGhlIHdhbGsgZW5kcyBp
biB2ZXJpdHlfaGFuZGxlX2VycigpIC0NCnRoZSAibWV0YWRhdGEgYmxvY2sgTiBpcyBjb3JydXB0
ZWQiIGZyb20gb3VyIGRldmljZXMsIHdoaWNoIHVuZGVyDQpyZXN0YXJ0X29uX2NvcnJ1cHRpb24g
bWVhbnMgYSByZWJvb3Qgb24gYSBzaW5nbGUgdHJhbnNpZW50IHJlYWQgZXJyb3IuDQpUaGlzIGlz
IG9ubHkgcmVhY2hhYmxlIG9uIHRoZSBzZWNvbmQgdHJ5LCB0aGUgb25lIHRoYXQgYXNrcyBmb3IN
CmVyYXN1cmVzOiB0aGUgZmlyc3QgdHJ5IHJlY292ZXJzIHRoZSBibG9jayB3aXRob3V0IHNlYXJj
aGluZyBmb3IgdGhlbS4NCg0KUmF0aGVyIHRoYW4gZGVmZW5kaW5nIGEgcGF0Y2ggb2Ygb3VyIG93
biwgd2hhdCB3ZSB3b3VsZCByZWFsbHkNCmFwcHJlY2lhdGUgaXMgeW91ciBoZWxwIHdpdGggdGhl
IGNvbXBsZXRlIGZpeC4gIFRoaXMgaXMgYSBwYXRoIHdoZXJlIGENCnBhcnRpYWwgY2hhbmdlIHdv
cnJpZXMgdXM6IHRoZSBlcmFzdXJlIHNlYXJjaCwgdGhlIHJlY3Vyc2lvbiBndWFyZCBpbg0KdmVy
aXR5X2ZlY19kZWNvZGUoKSBhbmQgdGhlIGhhc2hfdmVyaWZpZWQgc3RhdGUgYXJlIGFsbCBpbnZv
bHZlZCwgYW5kDQpmcm9tIHRoZSBvdXRzaWRlIHdlIGNhbm5vdCBqdWRnZSB3aGljaCBvZiB0aGVt
IGEgY29ycmVjdCBmaXggaGFzIHRvDQp0b3VjaC4gIE91ciBjb25jZXJuIGlzIHRoYXQgd2UgY2xv
c2UgdGhlIGNhc2Ugd2UgY2FuIHNlZSBhbmQgb3Blbg0KYW5vdGhlciByaXNrIHNvbWV3aGVyZSB3
ZSBjYW5ub3QuDQoNCldvdWxkIHlvdSBkZXNjcmliZSB0aGUgZml4IHlvdSB3b3VsZCBjb25zaWRl
ciBjb3JyZWN0IC0gd2hlcmUgdGhlDQpjaGFuZ2UgYmVsb25ncywgYW5kIHdoYXQgZWxzZSBpdCBo
YXMgdG8gY292ZXI/ICBXZSB3aWxsIGltcGxlbWVudCBpdA0KZXhhY3RseSBhcyB5b3Ugc3BlY2lm
eSwgdmVyaWZ5IGl0IG9uIHRoZSBjb25maWd1cmF0aW9uIHRoYXQgcmVwcm9kdWNlcw0KdGhlIHBy
b2JsZW0sIGFuZCBzZW5kIGl0IHRvIHlvdSBmb3IgcmV2aWV3IGJlZm9yZSBpdCBnb2VzIGFueSBm
dXJ0aGVyLg0KDQpUaGFua3MgYWdhaW4gZm9yIHlvdXIgdGltZSwNCldlaWppYW5nDQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXw0KIFRoaXMgZW1haWwgKGluY2x1ZGluZyBpdHMgYXR0
YWNobWVudHMpIGlzIGludGVuZGVkIG9ubHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5IHRvIHdo
aWNoIGl0IGlzIGFkZHJlc3NlZCBhbmQgbWF5IGNvbnRhaW4gaW5mb3JtYXRpb24gdGhhdCBpcyBw
cml2aWxlZ2VkLCBjb25maWRlbnRpYWwgb3Igb3RoZXJ3aXNlIHByb3RlY3RlZCBmcm9tIGRpc2Ns
b3N1cmUuIFVuYXV0aG9yaXplZCB1c2UsIGRpc3NlbWluYXRpb24sIGRpc3RyaWJ1dGlvbiBvciBj
b3B5aW5nIG9mIHRoaXMgZW1haWwgb3IgdGhlIGluZm9ybWF0aW9uIGhlcmVpbiBvciB0YWtpbmcg
YW55IGFjdGlvbiBpbiByZWxpYW5jZSBvbiB0aGUgY29udGVudHMgb2YgdGhpcyBlbWFpbCBvciB0
aGUgaW5mb3JtYXRpb24gaGVyZWluLCBieSBhbnlvbmUgb3RoZXIgdGhhbiB0aGUgaW50ZW5kZWQg
cmVjaXBpZW50LCBvciBhbiBlbXBsb3llZSBvciBhZ2VudCByZXNwb25zaWJsZSBmb3IgZGVsaXZl
cmluZyB0aGUgbWVzc2FnZSB0byB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBpcyBzdHJpY3RseSBw
cm9oaWJpdGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2Ug
ZG8gbm90IHJlYWQsIGNvcHksIHVzZSBvciBkaXNjbG9zZSBhbnkgcGFydCBvZiB0aGlzIGUtbWFp
bCB0byBvdGhlcnMuIFBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgcGVy
bWFuZW50bHkgZGVsZXRlIHRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgaWYgeW91IHJl
Y2VpdmVkIGl0IGluIGVycm9yLiBJbnRlcm5ldCBjb21tdW5pY2F0aW9ucyBjYW5ub3QgYmUgZ3Vh
cmFudGVlZCB0byBiZSB0aW1lbHksIHNlY3VyZSwgZXJyb3ItZnJlZSBvciB2aXJ1cy1mcmVlLiBU
aGUgc2VuZGVyIGRvZXMgbm90IGFjY2VwdCBsaWFiaWxpdHkgZm9yIGFueSBlcnJvcnMgb3Igb21p
c3Npb25zLg0K5pys6YKu5Lu25Y+K5YW26ZmE5Lu25YW35pyJ5L+d5a+G5oCn6LSo77yM5Y+X5rOV
5b6L5L+d5oqk5LiN5b6X5rOE6Zyy77yM5LuF5Y+R6YCB57uZ5pys6YKu5Lu25omA5oyH54m55a6a
5pS25Lu25Lq644CC5Lil56aB6Z2e57uP5o6I5p2D5L2/55So44CB5a6j5Lyg44CB5Y+R5biD5oiW
5aSN5Yi25pys6YKu5Lu25oiW5YW25YaF5a6544CC6Iul6Z2e6K+l54m55a6a5pS25Lu25Lq677yM
6K+35Yu/6ZiF6K+744CB5aSN5Yi244CBIOS9v+eUqOaIluaKq+mcsuacrOmCruS7tueahOS7u+S9
leWGheWuueOAguiLpeivr+aUtuacrOmCruS7tu+8jOivt+S7juezu+e7n+S4reawuOS5heaAp+WI
oOmZpOacrOmCruS7tuWPiuaJgOaciemZhOS7tu+8jOW5tuS7peWbnuWkjemCruS7tueahOaWueW8
j+WNs+WIu+WRiuefpeWPkeS7tuS6uuOAguaXoOazleS/neivgeS6kuiBlOe9kemAmuS/oeWPiuaX
tuOAgeWuieWFqOOAgeaXoOivr+aIlumYsuavkuOAguWPkeS7tuS6uuWvueS7u+S9lemUmea8j+Wd
h+S4jeaJv+aLhei0o+S7u+OAgg0K
