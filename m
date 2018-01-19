From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm rq: Avoid that request processing stalls sporadically
Date: Fri, 19 Jan 2018 00:21:43 +0000
Message-ID: <1516321302.2676.105.camel@wdc.com>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
         <20180119001136.GA4712@ming.t460p> <1516320863.2676.104.camel@wdc.com>
         <20180119001834.GB4712@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119001834.GB4712@ming.t460p>
Content-Language: en-US
Content-ID: <437F197CA50A874B99FAF638E469BB11@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAxLTE5IGF0IDA4OjE4ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
RnJpLCBKYW4gMTksIDIwMTggYXQgMTI6MTQ6MjRBTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE9uIEZyaSwgMjAxOC0wMS0xOSBhdCAwODoxMSArMDgwMCwgTWluZyBMZWkgd3Jv
dGU6DQo+ID4gPiBPbiBUaHUsIEphbiAxOCwgMjAxOCBhdCAwODozNzowN0FNIC0wODAwLCBCYXJ0
IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXJx
LmMgYi9kcml2ZXJzL21kL2RtLXJxLmMNCj4gPiA+ID4gaW5kZXggZjE2MDk2YWY4NzlhLi5jNTlj
NTljZmQyYTUgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbWQvZG0tcnEuYw0KPiA+ID4g
PiArKysgYi9kcml2ZXJzL21kL2RtLXJxLmMNCj4gPiA+ID4gQEAgLTc2MSw2ICs3NjEsNyBAQCBz
dGF0aWMgYmxrX3N0YXR1c190IGRtX21xX3F1ZXVlX3JxKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpo
Y3R4LA0KPiA+ID4gPiAgCQkvKiBVbmRvIGRtX3N0YXJ0X3JlcXVlc3QoKSBiZWZvcmUgcmVxdWV1
aW5nICovDQo+ID4gPiA+ICAJCXJxX2VuZF9zdGF0cyhtZCwgcnEpOw0KPiA+ID4gPiAgCQlycV9j
b21wbGV0ZWQobWQsIHJxX2RhdGFfZGlyKHJxKSwgZmFsc2UpOw0KPiA+ID4gPiArCQlibGtfbXFf
ZGVsYXlfcnVuX2h3X3F1ZXVlKGhjdHgsIDEwMC8qbXMqLyk7DQo+ID4gPiA+ICAJCXJldHVybiBC
TEtfU1RTX1JFU09VUkNFOw0KPiA+ID4gPiAgCX0NCj4gPiA+ID4gIA0KPiA+ID4gDQo+ID4gPiBO
YWsuDQo+ID4gDQo+ID4gVGhpcyBwYXRjaCBmaXhlcyBhIHJlZ3Jlc3Npb24gdGhhdCB3YXMgaW50
cm9kdWNlZCBieSB5b3UuIFlvdSBzaG91bGQga25vdw0KPiA+IHRoYXQgcmVncmVzc2lvbnMgYXJl
IG5vdCBhY2NlcHRhYmxlLiBJZiB5b3UgZG9uJ3QgYWdyZWUgd2l0aCB0aGlzIHBhdGNoLA0KPiA+
IHBsZWFzZSBmaXggdGhlIHJvb3QgY2F1c2UuDQo+IA0KPiBZZXN0ZXJkYXkgSSBzZW50IGEgcGF0
Y2gsIGRpZCB5b3UgdGVzdCB0aGF0Pw0KDQpZZXMsIEkgZGlkLiBJdCBjYXVzZWQgcXVldWUgc3Rh
bGxzIHRoYXQgd2VyZSBzbyBiYWQgdGhhdCBzZW5kaW5nICJraWNrIiB0byB0aGUNCmRlYnVnZnMg
InN0YXRlIiBhdHRyaWJ1dGUgd2FzIG5vdCBzdWZmaWNpZW50IHRvIHJlc29sdmUgdGhlIHF1ZXVl
IHN0YWxsLg0KDQpCYXJ0Lg==
