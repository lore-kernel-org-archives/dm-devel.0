From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm rq: Avoid that request processing stalls sporadically
Date: Fri, 19 Jan 2018 00:14:24 +0000
Message-ID: <1516320863.2676.104.camel@wdc.com>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
         <20180119001136.GA4712@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119001136.GA4712@ming.t460p>
Content-Language: en-US
Content-ID: <20C6D2FB2F604445BEDE6D06D31BA93F@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAxLTE5IGF0IDA4OjExICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VGh1LCBKYW4gMTgsIDIwMTggYXQgMDg6Mzc6MDdBTSAtMDgwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXJxLmMgYi9kcml2ZXJzL21kL2Rt
LXJxLmMNCj4gPiBpbmRleCBmMTYwOTZhZjg3OWEuLmM1OWM1OWNmZDJhNSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL21kL2RtLXJxLmMNCj4gPiArKysgYi9kcml2ZXJzL21kL2RtLXJxLmMNCj4g
PiBAQCAtNzYxLDYgKzc2MSw3IEBAIHN0YXRpYyBibGtfc3RhdHVzX3QgZG1fbXFfcXVldWVfcnEo
c3RydWN0IGJsa19tcV9od19jdHggKmhjdHgsDQo+ID4gIAkJLyogVW5kbyBkbV9zdGFydF9yZXF1
ZXN0KCkgYmVmb3JlIHJlcXVldWluZyAqLw0KPiA+ICAJCXJxX2VuZF9zdGF0cyhtZCwgcnEpOw0K
PiA+ICAJCXJxX2NvbXBsZXRlZChtZCwgcnFfZGF0YV9kaXIocnEpLCBmYWxzZSk7DQo+ID4gKwkJ
YmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZShoY3R4LCAxMDAvKm1zKi8pOw0KPiA+ICAJCXJldHVy
biBCTEtfU1RTX1JFU09VUkNFOw0KPiA+ICAJfQ0KPiA+ICANCj4gDQo+IE5hay4NCg0KVGhpcyBw
YXRjaCBmaXhlcyBhIHJlZ3Jlc3Npb24gdGhhdCB3YXMgaW50cm9kdWNlZCBieSB5b3UuIFlvdSBz
aG91bGQga25vdw0KdGhhdCByZWdyZXNzaW9ucyBhcmUgbm90IGFjY2VwdGFibGUuIElmIHlvdSBk
b24ndCBhZ3JlZSB3aXRoIHRoaXMgcGF0Y2gsDQpwbGVhc2UgZml4IHRoZSByb290IGNhdXNlLg0K
DQpCYXJ0Lg==
