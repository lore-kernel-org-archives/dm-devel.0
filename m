From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [for-4.16 PATCH v4 3/4] block: allow gendisk's request_queue
 registration to be deferred
Date: Fri, 12 Jan 2018 00:37:37 +0000
Message-ID: <1515717455.2752.82.camel@wdc.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
         <20180111201417.2042-4-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111201417.2042-4-snitzer@redhat.com>
Content-Language: en-US
Content-ID: <09E8DA5D9394AB409BF2A33B55340C9C@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTAxLTExIGF0IDE1OjE0IC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IC12b2lkIGRldmljZV9hZGRfZGlzayhzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsIHN0cnVjdCBnZW5k
aXNrICpkaXNrKQ0KPiArdm9pZCBkZXZpY2VfYWRkX2Rpc2tfbm9fcXVldWVfcmVnKHN0cnVjdCBk
ZXZpY2UgKnBhcmVudCwgc3RydWN0IGdlbmRpc2sgKmRpc2spDQo+ICB7DQo+ICAJZGV2X3QgZGV2
dDsNCj4gIAlpbnQgcmV0dmFsOw0KPiBAQCAtNjgyLDcgKzY4Miw2IEBAIHZvaWQgZGV2aWNlX2Fk
ZF9kaXNrKHN0cnVjdCBkZXZpY2UgKnBhcmVudCwgc3RydWN0IGdlbmRpc2sgKmRpc2spDQo+ICAJ
CQkJICAgIGV4YWN0X21hdGNoLCBleGFjdF9sb2NrLCBkaXNrKTsNCj4gIAl9DQo+ICAJcmVnaXN0
ZXJfZGlzayhwYXJlbnQsIGRpc2spOw0KPiAtCWJsa19yZWdpc3Rlcl9xdWV1ZShkaXNrKTsNCj4g
IA0KPiAgCS8qDQo+ICAJICogVGFrZSBhbiBleHRyYSByZWYgb24gcXVldWUgd2hpY2ggd2lsbCBi
ZSBwdXQgb24gZGlza19yZWxlYXNlKCkNCj4gQEAgLTY5Myw2ICs2OTIsMjEgQEAgdm9pZCBkZXZp
Y2VfYWRkX2Rpc2soc3RydWN0IGRldmljZSAqcGFyZW50LCBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykN
Cj4gIAlkaXNrX2FkZF9ldmVudHMoZGlzayk7DQo+ICAJYmxrX2ludGVncml0eV9hZGQoZGlzayk7
DQo+ICB9DQo+ICtFWFBPUlRfU1lNQk9MKGRldmljZV9hZGRfZGlza19ub19xdWV1ZV9yZWcpOw0K
DQpIZWxsbyBNaWtlLA0KDQpUaGlzIGNoYW5nZSBjYW4gaW5jcmVhc2UgdGhlIHRpbWUgYmV0d2Vl
biB0aGUgZ2VuZXJhdGlvbiBvZiB0aGUgZGlzayB1ZXZlbnQNCmFuZCB0aGUgcmVnaXN0cmF0aW9u
IG9mIHRoZSByZXF1ZXN0IHF1ZXVlIHN5c2ZzIGF0dHJpYnV0ZXMuIENhbiB0aGlzIGNhdXNlDQph
bnkgdWRldiBydWxlcyB0byBmYWlsPw0KDQpUaGFua3MsDQoNCkJhcnQu
