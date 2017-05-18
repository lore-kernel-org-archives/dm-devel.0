From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 12/15] block: merge blk_types.h into bio.h
Date: Thu, 18 May 2017 14:25:52 +0000
Message-ID: <1495117551.2713.1.camel@sandisk.com>
References: <20170518131812.22956-1-hch@lst.de>
         <20170518131812.22956-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170518131812.22956-13-hch@lst.de>
Content-Language: en-US
Content-ID: <2E744EA24869674393B159B7D24DC6A2@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE3LTA1LTE4IGF0IDE1OjE4ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gV2UndmUgY2xlYW5lZCB1cCBvdXIgaGVhZGVycyBzdWZmaWNpZW50bHkgdGhhdCB3ZSBk
b24ndCBuZWVkIHRoaXMgc3BsaXQNCj4gYW55bW9yZS4NCg0KSGVsbG8gQ2hyaXN0b3BoLA0KDQpS
ZXF1ZXN0LWJhc2VkIGRyaXZlcnMgbmVlZCB0aGUgc3RydWN0dXJlIGRlZmluaXRpb25zIGZyb20g
PGxpbnV4L2Jsa2Rldi5oPiBhbmQNCnRoZSB0eXBlIGRlZmluaXRpb25zIGZyb20gPGxpbnV4L2Js
a190eXBlcy5oPiBidXQgZG8gbm90IG5lZWQgdGhlIGRlZmluaXRpb24gb2YNCnN0cnVjdCBiaW8u
IEhhdmUgeW91IGNvbnNpZGVyZWQgdG8gcmVtb3ZlICNpbmNsdWRlIDxsaW51eC9iaW8uaD4gZnJv
bSBmaWxlDQppbmNsdWRlL2xpbnV4L2Jsa2Rldi5oPyBEbyB5b3UgdGhpbmsgdGhhdCB3b3VsZCBo
ZWxwIHRvIHJlZHVjZSB0aGUga2VybmVsIGJ1aWxkDQp0aW1lPw0KDQpUaGFua3MsDQoNCkJhcnQu
