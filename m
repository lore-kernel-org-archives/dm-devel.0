From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 15:20:13 +0000
Message-ID: <1516375212.3190.4.camel@wdc.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
         <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
         <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
         <20180119023212.GA25413@ming.t460p>
         <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
         <20180119072623.GB25369@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119072623.GB25369@ming.t460p>
Content-Language: en-US
Content-ID: <EC07D5ADB2C027459C9C88933F8C59E3@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAxLTE5IGF0IDE1OjI2ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gUGxl
YXNlIHNlZSBxdWV1ZV9kZWxheWVkX3dvcmtfb24oKSwgaGN0eC0+cnVuX3dvcmsgaXMgc2hhcmVk
IGJ5IGFsbA0KPiBzY2hlZHVsaW5nLCBvbmNlIGJsa19tcV9kZWxheV9ydW5faHdfcXVldWUoMTAw
bXMpIHJldHVybnMsIG5vIG5ldw0KPiBzY2hlZHVsaW5nIGNhbiBtYWtlIHByb2dyZXNzIGR1cmlu
ZyB0aGUgMTAwbXMuDQoNCkhvdyBhYm91dCBhZGRyZXNzaW5nIHRoYXQgYXMgZm9sbG93czoNCg0K
ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tcS5jIGIvYmxvY2svYmxrLW1xLmMNCmluZGV4IGY3NTE1
ZGQ5NWEzNi4uNTdmODM3OWE0NzZkIDEwMDY0NA0KLS0tIGEvYmxvY2svYmxrLW1xLmMNCisrKyBi
L2Jsb2NrL2Jsay1tcS5jDQpAQCAtMTQwMyw5ICsxNDAzLDkgQEAgc3RhdGljIHZvaWQgX19ibGtf
bXFfZGVsYXlfcnVuX2h3X3F1ZXVlKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LCBib29sIGFz
eW5jLA0KIAkJcHV0X2NwdSgpOw0KIAl9DQogDQotCWtibG9ja2Rfc2NoZWR1bGVfZGVsYXllZF93
b3JrX29uKGJsa19tcV9oY3R4X25leHRfY3B1KGhjdHgpLA0KLQkJCQkJICZoY3R4LT5ydW5fd29y
aywNCi0JCQkJCSBtc2Vjc190b19qaWZmaWVzKG1zZWNzKSk7DQorCWtibG9ja2RfbW9kX2RlbGF5
ZWRfd29ya19vbihibGtfbXFfaGN0eF9uZXh0X2NwdShoY3R4KSwNCisJCQkJICAgICZoY3R4LT5y
dW5fd29yaywNCisJCQkJICAgIG1zZWNzX3RvX2ppZmZpZXMobXNlY3MpKTsNCiB9DQogDQogdm9p
ZCBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LCB1
bnNpZ25lZCBsb25nIG1zZWNzKQ0KDQpCYXJ0Lg==
