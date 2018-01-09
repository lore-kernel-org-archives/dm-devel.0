From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [for-4.16 PATCH 1/2] block: cope with gendisk's 'queue' being
 added later
Date: Tue, 9 Jan 2018 23:04:25 +0000
Message-ID: <1515539064.2721.34.camel@wdc.com>
References: <20180109221039.33282-1-snitzer@redhat.com>
         <20180109221039.33282-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180109221039.33282-2-snitzer@redhat.com>
Content-Language: en-US
Content-ID: <E31BA77474557841BF71C8A6B6B11D42@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE4LTAxLTA5IGF0IDE3OjEwIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IGRpZmYgLS1naXQgYS9ibG9jay9ibGstc3lzZnMuYyBiL2Jsb2NrL2Jsay1zeXNmcy5jDQo+IGlu
ZGV4IDg3MDQ4NGVhZWQxZi4uMGIwZGRhOGUyNDIwIDEwMDY0NA0KPiAtLS0gYS9ibG9jay9ibGst
c3lzZnMuYw0KPiArKysgYi9ibG9jay9ibGstc3lzZnMuYw0KPiBAQCAtOTE5LDggKzkxOSwyMCBA
QCBpbnQgYmxrX3JlZ2lzdGVyX3F1ZXVlKHN0cnVjdCBnZW5kaXNrICpkaXNrKQ0KPiAgCXJldCA9
IDA7DQo+ICB1bmxvY2s6DQo+ICAJbXV0ZXhfdW5sb2NrKCZxLT5zeXNmc19sb2NrKTsNCj4gKw0K
PiArCS8qDQo+ICsJICogVGFrZSBhbiBleHRyYSByZWYgb24gcXVldWUgd2hpY2ggd2lsbCBiZSBw
dXQgb24gZGlza19yZWxlYXNlKCkNCj4gKwkgKiBzbyB0aGF0IGl0IHN0aWNrcyBhcm91bmQgYXMg
bG9uZyBhcyBAZGlzayBpcyB0aGVyZS4NCj4gKwkgKi8NCj4gKwlXQVJOX09OX09OQ0UoIWJsa19n
ZXRfcXVldWUocSkpOw0KPiArDQo+ICsJV0FSTl9PTihzeXNmc19jcmVhdGVfbGluaygmZGV2LT5r
b2JqLA0KPiArCQkJCSAgJnEtPmJhY2tpbmdfZGV2X2luZm8tPmRldi0+a29iaiwNCj4gKwkJCQkg
ICJiZGkiKSk7DQo+ICsNCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiArRVhQT1JUX1NZTUJPTF9H
UEwoYmxrX3JlZ2lzdGVyX3F1ZXVlKTsNCg0KSGVsbG8gTWlrZSwNCg0KU28gdGhlIHN5c2ZzX2Ny
ZWF0ZV9saW5rKCkgY2FsbCBpcyBtb3ZlZCBmcm9tIHJlZ2lzdGVyX2Rpc2soKSBpbnRvDQpibGtf
cmVnaXN0ZXJfcXVldWUoKSBidXQgdGhlIHN5c2ZzX3JlbW92ZV9saW5rKCkgY2FsbCBzdGF5cyBp
biBkZWxfZ2VuZGlzaygpPw0KQXJlIHlvdSBzdXJlIHRoYXQgeW91IHdhbnQgdGhpcyBhc3ltbWV0
cnk/DQoNClRoYW5rcywNCg0KQmFydC4=
