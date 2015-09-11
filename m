From: James Bottomley <jbottomley@odin.com>
Subject: Re: randconfig build error with next-20150908, in
 drivers/md/dm-mpath.c
Date: Fri, 11 Sep 2015 18:54:01 +0000
Message-ID: <1441997640.7836.1.camel@Odin.com>
References: <CA+r1ZhgR=dO0ezk0Nm0JuAb1D0AU7K2Am=Pyy9aPqCMsLW9Y0w@mail.gmail.com>
	 <20150908172356.GA1584@redhat.com> <20150909160418.GB28608@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150909160418.GB28608@lst.de>
Content-Language: en-US
Content-ID: <4A0CFA1049FE10469B9DFB86E33EE6DF@sw.swsoft.com>
Sender: linux-next-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "jim.epost@gmail.com" <jim.epost@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gV2VkLCAyMDE1LTA5LTA5IGF0IDE4OjA0ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gRG9lcyB0aGlzIGZpeCB0aGUgaXNzdWUgZm9yIHlvdT8gIE15IEtjb25maWctZnUgaXNu
J3QgdGhlIGJlc3QsDQo+IGJ1dCB0aGUgaWRlYSBiZWhpbmQgdGhpcyBpcyB0aGF0IGRtLW1wYXRo
IHdpbGwgZGVwZW5kIG9uIFNDU0kNCj4gaWYgU0NTSV9ESCBpcyBzZXQuICBJZiBTQ1NJX0RIIGlz
IG5vdCBzZXQgaXQgd2lsbCB1c2UgdGhlIHN0dWJzDQo+IGFuZCBub3QgY2FyZSBhYm91dCBTQ1NJ
Lg0KDQpJIGFzc3VtZSBJJ20gT0sgdG8gYWRkDQoNClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQooSSdsbCBhc3N1bWUgc28gaWYgeW91IGRvbid0IHJlcGx5
KQ0KDQpKYW1lcw0KDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL0tjb25maWcgYi9kcml2ZXJz
L21kL0tjb25maWcNCj4gaW5kZXggYjU5NzI3My4uZTllYTY4MSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9tZC9LY29uZmlnDQo+ICsrKyBiL2RyaXZlcnMvbWQvS2NvbmZpZw0KPiBAQCAtMzkzLDcg
KzM5Myw3IEBAIGNvbmZpZyBETV9NVUxUSVBBVEgNCj4gIAkjIG9mIFNDU0lfREggaWYgdGhlIGxh
dHRlciBpc24ndCBkZWZpbmVkIGJ1dCBpZg0KPiAgCSMgaXQgaXMsIERNX01VTFRJUEFUSCBtdXN0
IGRlcGVuZCBvbiBpdC4gIFdlIGdldCBhIGJ1aWxkDQo+ICAJIyBlcnJvciBpZiBTQ1NJX0RIPW0g
YW5kIERNX01VTFRJUEFUSD15DQo+IC0JZGVwZW5kcyBvbiBTQ1NJX0RIIHx8ICFTQ1NJX0RIDQo+
ICsJZGVwZW5kcyBvbiAhU0NTSV9ESCB8fCBTQ1NJDQo+ICAJLS0taGVscC0tLQ0KPiAgCSAgQWxs
b3cgdm9sdW1lIG1hbmFnZXJzIHRvIHN1cHBvcnQgbXVsdGlwYXRoIGhhcmR3YXJlLg0KPiAgDQoN
Cg0KDQo=
