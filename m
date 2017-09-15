From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/5] dm-mpath: return DM_MAPIO_REQUEUE in case of rq
 allocation failure
Date: Fri, 15 Sep 2017 20:48:56 +0000
Message-ID: <1505508534.2417.9.camel@wdc.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
         <20170915164456.9803-3-ming.lei@redhat.com>
         <1505496592.3420.10.camel@wdc.com> <20170915200655.GA28136@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915200655.GA28136@redhat.com>
Content-Language: en-US
Content-ID: <E6BD8414F4F2C34E9B0C960E2E227021@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE2OjA2IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IFRoZSBwcm9ibGVtIGlzIHRoYXQgbXVsdGlwYXRoX2Nsb25lX2FuZF9tYXAoKSBpcyBub3cgdHJl
YXRlZCBhcyBjb21tb24NCj4gY29kZSAodGhhbmtzIHRvIGJvdGggYmxrLW1xIGFuZCBvbGQgLnJl
cXVlc3RfZm4gbm93IGVuam95aW5nIHRoZSB1c2Ugb2YNCj4gYmxrX2dldF9yZXF1ZXN0KSBCVVQ6
IE1pbmcgcGxlYXNlIHVuZGVyc3RhbmQgdGhhdCB0aGlzIGNvZGUgaXMgdXNlZCBieQ0KPiBvbGQg
LnJlcXVlc3RfZm4gdG9vLiAgU28gaXQgd291bGQgc2VlbSB0aGF0IHRoZSB1c2Ugb2YNCj4gRE1f
TUFQSU9fREVMQVlfUkVRVUVVRSB2cyBETV9NQVBJT19SRVFVRVVFIG5lZWRzIHRvIGJlIGJhc2Vk
IG9uIGRtLXNxIHZzDQo+IGRtLW1xLg0KDQpIZWxsbyBNaWtlLA0KDQpNeSBwcm9wb3NhbCBpcyB0
byBsZWF2ZSBvdXQgcGF0Y2hlcyAxIGFuZCAyIGVudGlyZWx5LiBTaW5jZSB0aGUgU0NTSSBjb3Jl
DQpjYWxscyBibGtfbXFfcnVuX2h3X3F1ZXVlcygpIGFueXdheSBhZnRlciBhIHJlcXVlc3QgaGFz
IGZpbmlzaGVkIGl0IGlzIG5vdA0KY2xlYXIgdG8gbWUgd2hhdCB0aGUgbW90aXZhdGlvbiB3YXMg
YmVoaW5kIHRoZSBkZXZlbG9wbWVudCBvZiBwYXRjaGVzIDEgYW5kDQoyIGluIHRoaXMgc2VyaWVz
LiBJZiB0aGUgZ29hbCB3YXMgdG8gcmVydW4gYSBxdWV1ZSBhZnRlciBhIHJlcXVlc3QgaGFzDQpm
aW5pc2hlZCBJIHRoaW5rIHRoZSBzYW1lIGFwcHJvYWNoIHNob3VsZCBiZSB0YWtlbiBmb3IgZG0g
YXMgZm9yIHRoZSBTQ1NJDQpjb3JlLCBuYW1lbHkgdG8gcnVuIHRoZSBxdWV1ZSBmcm9tIGluc2lk
ZSB0aGUgZW5kX2lvIGNhbGxiYWNrLg0KDQpCYXJ0Lg==
