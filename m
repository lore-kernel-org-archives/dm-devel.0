From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 18:47:59 +0000
Message-ID: <1516301278.2676.35.camel@wdc.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
         <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180118183039.GA20121@redhat.com>
Content-Language: en-US
Content-ID: <9FFA71298A9AC544B659D8EB772D06B8@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTAxLTE4IGF0IDEzOjMwIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IDElIT8gIFdoZXJlIGFyZSB5b3UgZ2V0dGluZyB0aGF0IG51bWJlcj8gIE1pbmcgaGFzIGRldGFp
bGVkIG1vcmUNCj4gc2lnbmlmaWNhbnQgcGVyZm9ybWFuY2UgZ2FpbnMgdGhhbiAxJS4uIGFuZCBu
b3QganVzdCBvbiBscGZjICh0aG91Z2ggeW91DQo+IGtlZXAgc2VpemluZyBvbiBscGZjIGJlY2F1
c2Ugb2YgdGhlIGxvdyBxdWV1ZV9kZXB0aCBvZiAzKS4NCg0KVGhhdCdzIHdoYXQgSSBkZXJpdmVk
IGZyb20gdGhlIG51bWJlcnMgeW91IHBvc3RlZCBmb3IgbnVsbF9ibGsuIElmIE1pbmcgaGFzDQpw
b3N0ZWQgcGVyZm9ybWFuY2UgcmVzdWx0cyBmb3Igb3RoZXIgZHJpdmVycyB0aGFuIGxwZmMsIHBs
ZWFzZSBsZXQgbWUga25vdw0Kd2hlcmUgSSBjYW4gZmluZCB0aGVzZS4gSSBoYXZlIG5vdCB5ZXQg
c2VlbiB0aGVzZSBudW1iZXJzLg0KDQo+IFRoaXMgaXMgYWxsIHZlcnkgdGlyZXNvbWUuDQoNClll
cywgdGhpcyBpcyB0aXJlc29tZS4gSXQgaXMgdmVyeSBhbm5veWluZyB0byBtZSB0aGF0IG90aGVy
cyBrZWVwIGludHJvZHVjaW5nDQpzbyBtYW55IHJlZ3Jlc3Npb25zIGluIHN1Y2ggaW1wb3J0YW50
IHBhcnRzIG9mIHRoZSBrZXJuZWwuIEl0IGlzIGFsc28gYW5ub3lpbmcNCnRvIG1lIHRoYXQgSSBn
ZXQgYmxhbWVkIGlmIEkgcmVwb3J0IGEgcmVncmVzc2lvbiBpbnN0ZWFkIG9mIHNlZWluZyB0aGF0
IHRoZQ0KcmVncmVzc2lvbiBnZXRzIGZpeGVkLg0KDQpCYXJ0Lg==
