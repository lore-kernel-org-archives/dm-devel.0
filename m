From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 5/5] dm-mpath: improve I/O schedule
Date: Fri, 15 Sep 2017 20:56:12 +0000
Message-ID: <1505508971.2417.14.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-6-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <4E8955500DBC9642BC7F3AF9D1A0CA0B@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

T24gU2F0LCAyMDE3LTA5LTE2IGF0IDAwOjQ0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgICAgICAgICB8djQuMTMr
ICAgICAgICAgfHY0LjEzKw0KPiAgICAgICAgICAgfCtzY3NpX21xX3BlcmYgIHwrc2NzaV9tcV9w
ZXJmK3BhdGNoZXMNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gIElPUFMoSykgIHxNUS1ERUFETElORSAgICB8TVEtREVBRExJTkUNCj4gLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IHJlYWQgICAgICB8ICAgICAgIDMwLjcx
ICAgfCAgICAgIDM0My45MQ0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiByYW5kcmVhZCAgfCAgICAgICAyMi45OCAgIHwgICAgICAgMTcuMTcNCj4gLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IHdyaXRlICAgICB8ICAgICAg
IDE2LjQ1ICAgfCAgICAgIDM5MC44OA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gcmFuZHdyaXRlIHwgICAgICAgMTYuMjEgICB8ICAgICAgIDE2LjA5DQo+
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpXaGF0IGlzIHRoZSBy
ZWFzb24gZm9yIHRoZSByYW5kb20gSS9PIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb25zPyBVc2VycyB3
aG9zZQ0Kd29ya2xvYWQgdHJpZ2dlcnMgYSByYW5kb20gSS9PIHBhdHRlcm4gd2lsbCBiZSByZWFs
bHkgdW5oYXBweSB3aXRoIGEgMzMlIElPUFMNCnJlZ3Jlc3Npb24gZm9yIHJhbmRvbSByZWFkcy4g
RG9lcyB0aGF0IHJlZ3Jlc3Npb24gZ2V0IHdvcnNlIGZvciBsb3dlciBsYXRlbmN5DQp0cmFuc3Bv
cnRzLCBlLmcuIFNSUD8NCg0KQmFydC4=
