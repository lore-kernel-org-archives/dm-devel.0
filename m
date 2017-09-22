From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm-mpath: return DM_MAPIO_REQUEUE in case of rq
 allocation failure
Date: Fri, 22 Sep 2017 15:06:16 +0000
Message-ID: <1506092775.2512.5.camel@wdc.com>
References: <20170922013506.22510-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170922013506.22510-1-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <4982E78E07632245849EDF7FD419D796@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE3LTA5LTIyIGF0IDA5OjM1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gKwkJ
LyoNCj4gKwkJICogYmxrLW1xJ3MgU0NIRURfUkVTVEFSVCBjYW4gY292ZXIgdGhpcyByZXF1ZXVl
LCBzbw0KPiArCQkgKiB3ZSBuZWVkbid0IHRvIGRlYWwgd2l0aCBpdCBieSBERUxBWV9SRVFVRVVF
LiBNb3JlDQo+ICsJCSAqIGltcG9ydGFudGx5LCB3ZSBoYXZlIHRvIHJldHVybiBETV9NQVBJT19S
RVFVRVVFDQo+ICsJCSAqIHNvIHRoYXQgYmxrLW1xIGNhbiBnZXQgdGhlIHF1ZXVlIGJ1c3kgZmVl
ZGJhY2ssDQo+ICsJCSAqIG90aGVyd2lzZSBJL08gbWVyZ2UgY2FuIGJlIGh1cnQuDQo+ICsJCSAq
Lw0KPiArCQlpZiAocS0+bXFfb3BzKQ0KPiArCQkJcmV0dXJuIERNX01BUElPX1JFUVVFVUU7DQo+
ICsJCWVsc2UNCj4gKwkJCXJldHVybiBETV9NQVBJT19ERUxBWV9SRVFVRVVFOw0KPiAgCX0NCg0K
VGhpcyBwYXRjaCBpcyBpbmZlcmlvciB0byB3aGF0IEkgcG9zdGVkIGJlY2F1c2UgdGhpcyBwYXRj
aCBkb2VzIG5vdCBhdm9pZA0KdGhlIGRlbGF5IGlmIG11bHRpcGxlIExVTnMgYXJlIGFzc29jaWF0
ZWQgd2l0aCB0aGUgc2FtZSBTQ1NJIGhvc3QuIENvbnNpZGVyDQplLmcuIHRoZSBmb2xsb3dpbmcg
Y29uZmlndXJhdGlvbjoNCiogQSBzaW5nbGUgU0NTSSBob3N0IHdpdGggdHdvIFNDU0kgTFVOcyBh
c3NvY2lhdGVkIHRvIHRoYXQgaG9zdCwgZS5nLiAvZGV2L3NkYQ0KICBhbmQgL2Rldi9zZGIuDQoq
IEEgZG0tbXBhdGggaW5zdGFuY2UgaGFzIGJlZW4gY3JlYXRlZCBvbiB0b3Agb2YgL2Rldi9zZGEu
DQpJZiBhbGwgdGFncyBhcmUgaW4gdXNlIGJ5IHJlcXVlc3RzIHF1ZXVlZCB0byAvZGV2L3NkYiwg
bm8gZG0gcmVxdWVzdHMgYXJlIGluDQpwcm9ncmVzcyBhbmQgYSByZXF1ZXN0IGlzIHN1Ym1pdHRl
ZCBhZ2FpbnN0IHRoZSBkbS1tcGF0aCBkZXZpY2UgdGhlbiB0aGUNCmJsa19nZXRfcmVxdWVzdChx
LCBHRlBfQVRPTUlDKSBjYWxsIHdpbGwgZmFpbC4gVGhlIHJlcXVlc3Qgd2lsbCBiZSByZXF1ZXVl
ZA0KYW5kIHRoZSBxdWV1ZSB3aWxsIGJlIHJlcnVuIGFmdGVyIGEgZGVsYXkuDQoNCk15IHBhdGNo
IGRvZXMgbm90IGludHJvZHVjZSBhIGRlbGF5IGluIHRoaXMgY2FzZS4NCg0KQmFydC4=
