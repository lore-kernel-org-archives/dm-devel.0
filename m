From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 16:06:01 +0000
Message-ID: <1516377960.2646.4.camel@wdc.com>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
         <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
         <20180119023212.GA25413@ming.t460p>
         <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
         <20180119072623.GB25369@ming.t460p> <1516375212.3190.4.camel@wdc.com>
         <20180119153333.GA14827@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119153333.GA14827@ming.t460p>
Content-Language: en-US
Content-ID: <14F7CA88D8DA77499DEB1FF018078665@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAxLTE5IGF0IDIzOjMzICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
RnJpLCBKYW4gMTksIDIwMTggYXQgMDM6MjA6MTNQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIEZyaSwgMjAxOC0wMS0xOSBhdCAxNToyNiArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBQbGVhc2Ugc2VlIHF1ZXVlX2RlbGF5ZWRfd29ya19vbigpLCBoY3R4LT5ydW5f
d29yayBpcyBzaGFyZWQgYnkgYWxsDQo+ID4gPiBzY2hlZHVsaW5nLCBvbmNlIGJsa19tcV9kZWxh
eV9ydW5faHdfcXVldWUoMTAwbXMpIHJldHVybnMsIG5vIG5ldw0KPiA+ID4gc2NoZWR1bGluZyBj
YW4gbWFrZSBwcm9ncmVzcyBkdXJpbmcgdGhlIDEwMG1zLg0KPiA+IA0KPiA+IEhvdyBhYm91dCBh
ZGRyZXNzaW5nIHRoYXQgYXMgZm9sbG93czoNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYmxvY2sv
YmxrLW1xLmMgYi9ibG9jay9ibGstbXEuYw0KPiA+IGluZGV4IGY3NTE1ZGQ5NWEzNi4uNTdmODM3
OWE0NzZkIDEwMDY0NA0KPiA+IC0tLSBhL2Jsb2NrL2Jsay1tcS5jDQo+ID4gKysrIGIvYmxvY2sv
YmxrLW1xLmMNCj4gPiBAQCAtMTQwMyw5ICsxNDAzLDkgQEAgc3RhdGljIHZvaWQgX19ibGtfbXFf
ZGVsYXlfcnVuX2h3X3F1ZXVlKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LCBib29sIGFzeW5j
LA0KPiA+ICAJCXB1dF9jcHUoKTsNCj4gPiAgCX0NCj4gPiAgDQo+ID4gLQlrYmxvY2tkX3NjaGVk
dWxlX2RlbGF5ZWRfd29ya19vbihibGtfbXFfaGN0eF9uZXh0X2NwdShoY3R4KSwNCj4gPiAtCQkJ
CQkgJmhjdHgtPnJ1bl93b3JrLA0KPiA+IC0JCQkJCSBtc2Vjc190b19qaWZmaWVzKG1zZWNzKSk7
DQo+ID4gKwlrYmxvY2tkX21vZF9kZWxheWVkX3dvcmtfb24oYmxrX21xX2hjdHhfbmV4dF9jcHUo
aGN0eCksDQo+ID4gKwkJCQkgICAgJmhjdHgtPnJ1bl93b3JrLA0KPiA+ICsJCQkJICAgIG1zZWNz
X3RvX2ppZmZpZXMobXNlY3MpKTsNCj4gPiAgfQ0KPiA+ICANCj4gPiAgdm9pZCBibGtfbXFfZGVs
YXlfcnVuX2h3X3F1ZXVlKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LCB1bnNpZ25lZCBsb25n
IG1zZWNzKQ0KPiA+IA0KPiA+IEJhcnQuDQo+IA0KPiBZZXMsIHRoaXMgb25lIHRvZ2V0aGVyIHdp
dGggSmVuJ3Mgc3VnZ2VzdGlvbiB3aXRoIHJldHVybmluZw0KPiBCTEtfU1RTX05PX0RFVl9SRVNP
VVJDRSBzaG91bGQgZml4IHRoaXMgaXNzdWUuDQo+IA0KPiBDb3VsZCB5b3UgY29vayBhIGZpeCBm
b3IgdGhpcyBpc3N1ZT8gT3RoZXJ3aXNlIEkgYW0gaGFwcHkgdG8gZG8NCj4gdGhhdC4NCg0KSGVs
bG8gTWluZywNCg0KSSB3aWxsIGxvb2sgZnVydGhlciBpbnRvIHRoaXMuDQoNCkJhcnQu
