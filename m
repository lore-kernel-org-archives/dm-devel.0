From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 17:47:17 +0000
Message-ID: <1515692836.2752.42.camel@wdc.com>
References: <20180111021256.37490-1-snitzer@redhat.com>
         <20180111021256.37490-3-snitzer@redhat.com>
         <804df5df-2598-df69-757d-85df18185d4c@suse.de>
         <20180111170430.GA30621@redhat.com> <1515691112.2752.21.camel@wdc.com>
         <20180111172943.GA30762@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111172943.GA30762@redhat.com>
Content-Language: en-US
Content-ID: <89A414746210E543AE3C432121788D21@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTAxLTExIGF0IDEyOjI5IC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDExIDIwMTggYXQgMTI6MThwbSAtMDUwMCwNCj4gQmFydCBWYW4gQXNzY2hl
IDxCYXJ0LlZhbkFzc2NoZUB3ZGMuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gVGh1LCAyMDE4LTAx
LTExIGF0IDEyOjA0IC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+ID4gPiBTbyBteSB2NCwg
dGhhdCBJJ2xsIHNlbmQgb3V0IHNob3J0bHksIHdvbid0IGJlIHVzaW5nIHRlc3RfYW5kX2NsZWFy
X2JpdCgpDQo+ID4gDQo+ID4gUGxlYXNlIHVzZSBxdWV1ZV9mbGFnX3NldCgpLCBxdWV1ZV9mbGFn
X2NsZWFyKCksIHF1ZXVlX2ZsYWdfdGVzdF9hbmRfY2xlYXIoKSBhbmQvb3INCj4gPiBxdWV1ZV9m
bGFnX3Rlc3RfYW5kX3NldCgpIHRvIG1hbmlwdWxhdGUgcXVldWUgZmxhZ3MuDQo+IA0KPiBDYW4g
eW91IHBsZWFzZSBleHBhbmQgb24gdGhpcz8gIE15IHBhdGNoIGlzIG9ubHkgdXNpbmcgdGVzdF9i
aXQoKS4NCg0KSGVsbG8gTWlrZSwNCg0KSSB3YXMgcmVmZXJyaW5nIHRvIHRoZSBmb2xsb3dpbmcg
Y29kZSwgd2hpY2ggYXBwYXJlbmx5IGlzIGV4aXN0aW5nIGNvZGU6DQoNCiAgICAgICAgbXV0ZXhf
bG9jaygmcS0+c3lzZnNfbG9jayk7DQogICAgICAgIHF1ZXVlX2ZsYWdfY2xlYXJfdW5sb2NrZWQo
UVVFVUVfRkxBR19SRUdJU1RFUkVELCBxKTsNCiAgICAgICAgbXV0ZXhfdW5sb2NrKCZxLT5zeXNm
c19sb2NrKTsNCg0KVGhlIGFib3ZlIGNvZGUgaXMgd3JvbmcuIE90aGVyIGNvZGUgdGhhdCBjaGFu
Z2VzIHRoZSBxdWV1ZSBmbGFncyBwcm90ZWN0cw0KdGhlc2UgY2hhbmdlcyB3aXRoIHRoZSB0aGUg
cXVldWUgbG9jay4gVGhlIGFib3ZlIGNvZGUgc2hvdWxkIGJlIGNoYW5nZWQgaW50bw0KdGhlIGZv
bGxvd2luZzoNCg0KCXNwaW5fbG9ja19pcnEocS0+cXVldWVfbG9jayk7DQoJcXVldWVfZmxhZ19j
bGVhcihRVUVVRV9GTEFHX1JFR0lTVEVSRUQsIHEpOw0KCXNwaW5fdW5sb2NrX2lycShxLT5xdWV1
ZV9sb2NrKTsNCg0KVGhlIG9ubHkgZnVuY3Rpb25zIGZyb20gd2hpY2ggaXQgaXMgc2FmZSB0byBj
YWxsIHF1ZXVlX2ZsYWdfKHNldHxjbGVhcilfdW5sb2NrZWQoKQ0Kd2l0aG91dCBob2xkaW5nIHRo
ZSBxdWV1ZSBsb2NrIGFyZSBibGtfYWxsb2NfcXVldWVfbm9kZSgpIGFuZA0KX19ibGtfcmVsZWFz
ZV9xdWV1ZSgpIGJlY2F1c2UgZm9yIHRoZXNlIGZ1bmN0aW9ucyBpdCBpcyBndWFyYW50ZWVkIHRo
YXQgbm8gcXVldWUNCmZsYWcgY2hhbmdlcyBjYW4gaGFwcGVuIGZyb20gYW5vdGhlciBjb250ZXh0
LCBlLmcuIHRocm91Z2ggYSBibGtfc2V0X3F1ZXVlX2R5aW5nKCkNCmNhbGwuDQoNCkJhcnQu
