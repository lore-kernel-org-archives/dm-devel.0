From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/8] dm mpath: remove process_queued_ios()
Date: Fri, 28 Feb 2014 10:37:05 +0100
Message-ID: <531058C1.30402@suse.de>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
	<1393486229-72034-5-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784010D7D51@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A49860784010D7D51@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

T24gMDIvMjgvMjAxNCAxMDowNSBBTSwgSnVuaWNoaSBOb211cmEgd3JvdGU6Cj4gT24gMDIvMjcv
MTQgMTY6MzAsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gQEAgLTEyMTQsOSArMTE4OSwxMSBA
QCBzdGF0aWMgdm9pZCBwZ19pbml0X2RvbmUodm9pZCAqZGF0YSwgaW50IGVycm9ycykKPj4gIAo+
PiAgCWlmICghbS0+cGdfaW5pdF9yZXF1aXJlZCkKPj4gIAkJbS0+cXVldWVfaW8gPSAwOwo+PiAt
Cj4+IC0JbS0+cGdfaW5pdF9kZWxheV9yZXRyeSA9IGRlbGF5X3JldHJ5Owo+PiAtCXF1ZXVlX3dv
cmsoa211bHRpcGF0aGQsICZtLT5wcm9jZXNzX3F1ZXVlZF9pb3MpOwo+PiArCWVsc2UgaWYgKG0t
PmN1cnJlbnRfcGcpIHsKPj4gKwkJbS0+cGdfaW5pdF9kZWxheV9yZXRyeSA9IGRlbGF5X3JldHJ5
Owo+PiArCQlpZiAoX19wZ19pbml0X2FsbF9wYXRocyhtKSkKPj4gKwkJCWdvdG8gb3V0Owo+PiAr
CX0KPiAKPiBBcyBJIGNvbW1lbnRlZCBiZWZvcmU6Cj4gaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9h
cmNoaXZlcy9kbS1kZXZlbC8yMDE0LUZlYnJ1YXJ5L21zZzAwMDEzLmh0bWwKPiAKPiBJIHRoaW5r
IHRoZSBjb2RlIGhlcmUgc2hvdWxkIGNsZWFyIHF1ZXVlX2lvIGxpa2UgdGhpcwo+IHdoZW4gcmV0
cnkgd2FzIHJlcXVlc3RlZCBidXQgd2Fzbid0IGRvbmU6Cj4gCj4gCWlmIChtLT5wZ19pbml0X3Jl
cXVpcmVkKSB7Cj4gCQltLT5wZ19pbml0X2RlbGF5X3JldHJ5ID0gZGVsYXlfcmV0cnk7Cj4gCQlp
ZiAoX19wZ19pbml0X2FsbF9wYXRocyhtKSkKPiAJCQlnb3RvIG91dDsKPiAJfQo+IAltLT5xdWV1
ZV9pbyA9IDA7Cj4gCj4gT3RoZXJ3aXNlLCBpZiBfX3BnX2luaXRfYWxsX3BhdGhzKCkgcmV0dXJu
cyAwLCBtLT5xdWV1ZV9pbyB3aWxsIHJlbWFpbgo+IGFzICIxIiBhbmQgbm9ib2R5IHdpbGwgY2xl
YXIgaXQuCj4gCllvdSBhcmUgcmlnaHQuIFdpbGwgYmUgZml4aW5nIGl0IHVwLgoKVGhhbmtzIGZv
ciB0aGUgcmV2aWV3LgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkg
ICAgICB6U2VyaWVzICYgU3RvcmFnZQpoYXJlQHN1c2UuZGUJCQkgICAgICArNDkgOTExIDc0MDUz
IDY4OApTVVNFIExJTlVYIFByb2R1Y3RzIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJu
YmVyZwpHRjogSi4gSGF3biwgSi4gR3VpbGQsIEYuIEltZW5kw7ZyZmZlciwgSFJCIDE2NzQ2IChB
RyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
