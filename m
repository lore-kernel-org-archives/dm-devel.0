From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Wed, 17 Aug 2016 16:44:17 +0200
Message-ID: <21bda432-784b-3cde-5de1-d81eab98aeb1@suse.de>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
	<7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gMDgvMTYvMjAxNiAxMDoxMSBQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+IE9uIDA4LzE1
LzIwMTYgMTE6MzEgUE0sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gTWFrZXMgb25lIHdvbmRl
cjogd2hhdCBoYXBwZW5zIHRvIHRoZSB3YWl0ZXZlbnQgdGhyZWFkcz8KPj4gV2Ugd29uJ3QgYmUg
d2FpdGluZyBmb3IgdGhlbSBhZnRlciBhcHBseWluZyB0aGlzIHBhdGNoLCByaWdodD8KPj4gU28g
d2h5IGRpZCB3ZSBldmVyIGhhZCB0aGlzIGJ1c3kgbG9vcCBoZXJlPwo+PiBCZW4/Cj4+Cj4+IChB
bmQgd2hpbGUgd2UncmUgYXQgdGhlIHN1YmplY3Q6IGNhbid0IHdlIGRyb3AgdGhlIHdhaXRldmVu
dCB0aHJlYWRzCj4+IGFsdG9nZXRoZXI/IFdlJ3JlIGxpc3RlbmluZyB0byB1ZXZlbnRzIG5vd2Fk
YXlzLCBzbyB3ZSBzaG91bGQgYmUKPj4gbm90aWZpZWQgaWYgc29tZXRoaW5nIGhhcHBlbmVkIHRv
IHRoZSBkZXZpY2UtbWFwcGVyIHRhYmxlcy4gV2hpY2ggc2hvdWxkCj4+IG1ha2UgdGhlIHdhaXRl
dmVudCB0aHJlYWRzIHVubmVjZXNzYXJ5LCByaWdodD8pCj4gCj4gSGVsbG8gSGFubmVzLAo+IAo+
IE1heWJlIHRoaXMgaXMgbm90IHdoYXQgeW91IGhhZCBpbiBtaW5kLCBidXQgd291bGQgeW91IGFn
cmVlIHdpdGggdGhlCj4gYXR0YWNoZWQgdHdvIHBhdGNoZXM/Cj4gCldlbGwsIHllcywgc29ydCBv
Zi4KSG93ZXZlciwgaXQgc3RpbGwgd291bGQgbWVhbiB0aGF0IHRoZSBtYWluIG11bHRpcGF0aCBk
YWVtb24gdGhyZWFkIG1pZ2h0CnRlcm1pbmF0ZSBiZWZvcmUgdGhlIGV2ZW50IHRocmVhZHMgaGF2
ZSBjb21wbGV0ZWQsIHRob3VnaC4KCk5vdCBzdXJlIGlmIGl0IG1hdHRlcnMsIGp1c3Qgd2FudGVk
IHRvIGJyaW5nIGlzIHVwLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tl
CQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2luZwpoYXJlQHN1c2UuZGUJCQkgICAgICAg
ICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJTlVYIEdtYkgsIE1heGZlbGRzdHIuIDUs
IDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBKLiBTbWl0aGFyZCwgSi4gR3Vp
bGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
