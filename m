From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 5/5] dm-mpath: improve I/O schedule
Date: Fri, 15 Sep 2017 21:42:55 +0000
Message-ID: <1505511774.2705.3.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-6-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <5C85303B8F25EE488202FCB7587824D8@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

T24gU2F0LCAyMDE3LTA5LTE2IGF0IDAwOjQ0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gK3N0
YXRpYyB2b2lkIHNhdmVfcGF0aF9xdWV1ZV9kZXB0aChzdHJ1Y3QgcGdwYXRoICpwKQ0KPiArew0K
PiArCXN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxID0gYmRldl9nZXRfcXVldWUocC0+cGF0aC5kZXYt
PmJkZXYpOw0KPiArDQo+ICsJcC0+b2xkX25yX3JlcXVlc3RzID0gcS0+bnJfcmVxdWVzdHM7DQo+
ICsJcC0+cXVldWVfZGVwdGggPSBxLT5xdWV1ZV9kZXB0aDsNCj4gKw0KPiArCS8qIG9uZSBleHRy
YSByZXF1ZXN0IGZvciBtYWtpbmcgdGhlIHBpcGVsaW5lIGZ1bGwgKi8NCj4gKwlpZiAocC0+cXVl
dWVfZGVwdGgpDQo+ICsJCWJsa191cGRhdGVfbnJfcmVxdWVzdHMocSwgcC0+cXVldWVfZGVwdGgg
KyAxKTsNCj4gK30NCg0KYmxrX21xX2luaXRfYWxsb2NhdGVkX3F1ZXVlKCkgaW5pdGlhbGl6ZXMg
bnJfcmVxdWVzdHMgdG8gdGhlIHRhZyBzZXQgcXVldWUgZGVwdGguDQpEb2VzIHRoYXQgbWVhbiB0
aGF0IHRoZSBhYm92ZSBjb2RlIGluY3JlYXNlcyBucl9yZXF1ZXN0cyBieSBvbmU/IElmIHNvLCBk
b2VzDQp0aGF0IGNoYW5nZSBvbmx5IHJlc3VsdCBpbiBhIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50
IGZvciB0aGUgcXVldWUgZGVwdGgNCm1lbnRpb25lZCBpbiB0aGUgcGF0aCBkZXNjcmlwdGlvbiAo
Myk/IFNvcnJ5IGJ1dCBJIGRvdWJ0IHRoYXQgdGhpcyBjaGFuZ2Ugd2lsbA0KeWllbGQgYSBzaWdu
aWZpY2FudCBpbXByb3ZlbWVudCBmb3IgaGlnaGVyIHF1ZXVlIGRlcHRocy4gRG9lcyB0aGF0IG1l
YW4gdGhhdA0KdGhpcyBwYXRjaCBjYW4gYmUgbGVmdCBvdXQ/DQoNClRoYW5rcywNCg0KQmFydC4=
