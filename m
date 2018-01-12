From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 23:42:25 +0000
Message-ID: <1515800544.2396.89.camel@wdc.com>
References: <1515710256.2752.72.camel@sandisk.com>
         <20180112014232.GB25090@ming.t460p> <20180112015721.GB32298@redhat.com>
         <20180112033308.GC25090@ming.t460p> <20180112171840.GA4541@redhat.com>
         <1515778013.2396.3.camel@wdc.com> <20180112174000.GB5134@redhat.com>
         <1515779211.2396.11.camel@wdc.com> <20180112180635.GD5134@redhat.com>
         <1515783288.2396.37.camel@wdc.com> <20180112231708.GA6722@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180112231708.GA6722@redhat.com>
Content-Language: en-US
Content-ID: <012C175E64E37A45B45B71E059AB1B3C@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "axboe@fb.com" <axboe@fb.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAxLTEyIGF0IDE4OjE3IC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IEBAIC0xNTcwLDcgKzE1NzAsMTAgQEAgc3RhdGljIGludCBtdWx0aXBhdGhfZW5kX2lvKHN0cnVj
dCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgcmVxdWVzdCAqY2xvbmUsDQo+ICAJaWYgKGVycm9yICYm
IGJsa19wYXRoX2Vycm9yKGVycm9yKSkgew0KPiAgCQlzdHJ1Y3QgbXVsdGlwYXRoICptID0gdGkt
PnByaXZhdGU7DQo+ICANCj4gLQkJciA9IERNX0VORElPX1JFUVVFVUU7DQo+ICsJCWlmIChyID09
IEJMS19TVFNfUkVTT1VSQ0UpDQo+ICsJCQlyID0gRE1fRU5ESU9fREVMQVlfUkVRVUVVRTsNCj4g
KwkJZWxzZQ0KPiArCQkJciA9IERNX0VORElPX1JFUVVFVUU7DQoNCkRpZCB5b3UgcGVyaGFwcyBp
bnRlbmQgImVycm9yID09IEJMS19TVFNfUkVTT1VSQ0UiPw0KDQo+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaCBiL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5o
DQo+IGluZGV4IDliYTg0NTMuLmRhODNmNjQgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgv
ZGV2aWNlLW1hcHBlci5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oDQo+
IEBAIC01NTAsNiArNTUwLDcgQEAgc3RydWN0IGRtX3RhYmxlICpkbV9zd2FwX3RhYmxlKHN0cnVj
dCBtYXBwZWRfZGV2aWNlICptZCwNCj4gICNkZWZpbmUgRE1fRU5ESU9fRE9ORQkJMA0KPiAgI2Rl
ZmluZSBETV9FTkRJT19JTkNPTVBMRVRFCTENCj4gICNkZWZpbmUgRE1fRU5ESU9fUkVRVUVVRQky
DQo+ICsjZGVmaW5lIERNX0VORElPX0RFTEFZX1JFUVVFVUUJMw0KPiAgDQo+ICAvKg0KPiAgICog
RGVmaW5pdGlvbnMgb2YgcmV0dXJuIHZhbHVlcyBmcm9tIHRhcmdldCBtYXAgZnVuY3Rpb24uDQo+
IEBAIC01NTcsNyArNTU4LDcgQEAgc3RydWN0IGRtX3RhYmxlICpkbV9zd2FwX3RhYmxlKHN0cnVj
dCBtYXBwZWRfZGV2aWNlICptZCwNCj4gICNkZWZpbmUgRE1fTUFQSU9fU1VCTUlUVEVECTANCj4g
ICNkZWZpbmUgRE1fTUFQSU9fUkVNQVBQRUQJMQ0KPiAgI2RlZmluZSBETV9NQVBJT19SRVFVRVVF
CURNX0VORElPX1JFUVVFVUUNCj4gLSNkZWZpbmUgRE1fTUFQSU9fREVMQVlfUkVRVUVVRQkzDQo+
ICsjZGVmaW5lIERNX01BUElPX0RFTEFZX1JFUVVFVUUJRE1fRU5ESU9fREVMQVlfUkVRVUVVRQ0K
PiAgI2RlZmluZSBETV9NQVBJT19LSUxMCQk0DQo+ICANCj4gICNkZWZpbmUgZG1fc2VjdG9yX2Rp
djY0KHgsIHkpKCBcDQoNClBsZWFzZSBjb25zaWRlciB0byBpbnRyb2R1Y2UgZW51bWVyYXRpb24g
dHlwZXMgZm9yIHRoZSBETV9FTkRJT18qIGFuZCB0aGUNCkRNX01BUElPXyogY29uc3RhbnRzIHN1
Y2ggdGhhdCB0aGUgY29tcGlsZXIgY2FuIGNhdGNoIHdoYXQgSSByZXBvcnRlZCBhYm92ZS4NCk90
aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGZpbmUgdG8gbWUuDQoNClRoYW5rcywNCg0KQmFydC4=
