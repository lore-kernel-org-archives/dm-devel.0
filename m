From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 22:24:00 +0000
Message-ID: <1516314239.2676.79.camel@wdc.com>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
         <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
         <20180118204856.GA31679@redhat.com> <1516309128.2676.38.camel@wdc.com>
         <20180118212327.GB31679@redhat.com> <1516311554.2676.50.camel@wdc.com>
         <20180118220132.GA20860@redhat.com> <1516313920.24506.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516313920.24506.4.camel@redhat.com>
Content-Language: en-US
Content-ID: <D3A060861672684F96DBD0FCB2E5D300@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "loberman@redhat.com" <loberman@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTAxLTE4IGF0IDE3OjE4IC0wNTAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Og0KPiBPSywgSSByYW4gNSBhdCBvbmNlIG9mIDUgc2VwYXJhdGUgbW91bnQgcG9pbnRzLg0KPiBJ
IGFtIHVzaW5nIDRrIGJsb2NrIHNpemVzDQo+IEl0cyBzb2xpZCBjb25zaXN0ZW50IGZvciBtZS4g
Tm8gc3RhbGxzIG5vIGdhcHMuDQoNCkhpIExhdXJlbmNlLA0KDQpUaGF0J3MgZ3JlYXQgbmV3cyBh
bmQgdGhhbmsgeW91IGZvciBoYXZpbmcgc2hhcmVkIHRoaXMgaW5mb3JtYXRpb24gYnV0IEkgdGhp
bmsNCml0IHNob3VsZCBiZSBtZW50aW9uZWQgdGhhdCB5b3UgaGF2ZSBiZWVuIHJ1bm5pbmcgbXkg
dHJlZSBpbiB3aGljaCBzb21lIHJlY2VudA0KYmxvY2sgYW5kIGRtIHBhdGNoZXMgd2VyZSByZXZl
cnRlZA0KKGh0dHBzOi8vZ2l0aHViLmNvbS9idmFuYXNzY2hlL2xpbnV4L3RyZWUvYmxvY2stc2Nz
aS1mb3ItbmV4dCkNCg0KPiANCj4gW2dsb2JhbF0NCj4gbmFtZT0wMi1tcQ0KPiBmaWxlbmFtZT1m
aW8tb3V0cHV0LTAyLW1xLnR4dA0KPiBydz1yYW5kd3JpdGUNCj4gdmVyaWZ5PW1kNQ0KPiA7cndt
aXhyZWFkPTYwDQo+IDtyd21peHdyaXRlPTQwDQo+IGJzPTRLDQo+IDtkaXJlY3Q9MQ0KPiA7bnVt
am9icz00DQo+IDt0aW1lX2Jhc2VkPTENCj4gcnVudGltZT0xMjANCj4gDQo+IFtmaWxlMV0NCj4g
c2l6ZT0zRw0KPiBpb2VuZ2luZT1saWJhaW8NCj4gaW9kZXB0aD0xNg0KPiANCj4gSSB3YXRjaCBJ
L08gYW5kIEkgc2VlIGl0IHJhbXAgdXAgYnV0IGZpbyBzdGlsbCBydW5zIGFuZCBpdCBraW5kIG9m
DQo+IHNodXRzIGRvd24uDQoNCkluIHRlc3QgImZpbGUxIiBJIHNlZSBhbiBJL08gc2l6ZSBvZiAz
Ry4gRG9lcyB0aGF0IG1lYW4gdGhhdCB0aGUgcGF0Y2ggdGhhdA0Kc2hvdWxkIGZpeCB0aGUgc2ds
X2FsbG9jKCkgaXNzdWUgaXMgd29ya2luZz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
