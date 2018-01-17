From: Laurence Oberman <loberman@redhat.com>
Subject: Re: dm-rq queue stalls
Date: Wed, 17 Jan 2018 14:46:31 -0500
Message-ID: <1516218391.3805.0.camel@redhat.com>
References: <1516212342.2820.26.camel@wdc.com>
	<20180117181852.GA5798@redhat.com>
	<1516213796.31083.2.camel@redhat.com>
	<1516217368.2820.39.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1516217368.2820.39.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

T24gV2VkLCAyMDE4LTAxLTE3IGF0IDE5OjI5ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gT24gV2VkLCAyMDE4LTAxLTE3IGF0IDEzOjI5IC0wNTAwLCBMYXVyZW5jZSBPYmVybWFuIHdy
b3RlOgo+ID4gSWYgeW91IGNhbiBzaGFyZSB5b3VyIGV4YWN0IGZpbyBydW4gc2NyaXB0cGFyYW1l
dGVycyBJIGNhbiB0cnkgdGhpcwo+ID4gb24KPiA+IG15IG1seDUgdGVzdCBiZWQgdXNpbmcgdGhl
IHNhbWUga2VybmVsIHlvdSBhcmUgdXNpbmcuCj4gPiBNaW5nIGhhcyBhY2Nlc3MgdG8gdGhlIHNh
bWUgdGVzdCBiZWQgYXMgd2VsbC4KPiA+IElzIHRoaXMgZGlyZWN0IHRvIGRldmljZXMsIG9yIG9u
IGEgZmlsZSBzeXN0ZW0gZXRjLiBldGMuCj4gPiAKPiA+IEFyZSB0aGVzZSBmcm9tIHRoZSB0ZXN0
cyBkaXJlY3RvcnkgaW4gdGhlIHNycCB0ZXN0IGtpdCBvZiB5b3Vycy4KPiAKPiBIZWxsbyBMYXVy
ZW5jZSwKPiAKPiBUaGlzIGlzc3VlIGNhbiBiZSByZXByb2R1Y2VkIGFzIGZvbGxvd3M6Cj4gKiBD
bG9uZSB0aGUgYmxvY2stc2NzaS1mb3ItbmV4dCBicmFuY2ggZnJvbSBodHRwczovL2dpdGh1Yi5j
b20vYnZhbmFzCj4gc2NoZS9saW51eAo+IMKgIChjb21taXQgY2QwYjZiOWY4Nzc5KS4KPiAqIENs
b25lIHRoZSBzcnAtdGVzdCBwcm9qZWN0IGZyb20gaHR0cHM6Ly9naXRodWIuY29tL2J2YW5hc3Nj
aGUvc3JwLXQKPiBlc3QuCj4gKiBNb2RpZnkgL2V0Yy9tdWx0aXBhdGguY29uZiBhcyBpbmRpY2F0
ZWQgaW4gdGhlIFJFQURNRS5tZCBmaWxlIG9mCj4gdGhlIHNycC10ZXN0Cj4gwqAgcHJvamVjdCBh
bmQgcmVzdGFydCBtdWx0aXBhdGhkLgo+IAo+IElmIHlvdSBwcmVmZXIgdGhlIHJkbWFfcnhlIGRy
aXZlciwgcnVuIHRoZSBmb2xsb3dpbmcgY29tbWFuZDoKPiAKPiBzcnAtdGVzdC9ydW5fdGVzdHMg
LWMgLWQgLXIgMTAgLXEgMSAtdCAwMi1tcSAtZSBreWJlcgo+IAo+IE9yIGlmIHlvdSBwcmVmZXIg
dG8gcnVuIHRoZSB0ZXN0IGFnYWluc3QgYW4gSUIgZHJpdmVyIChtbHg0LCBtbHg1LAo+IC4uKSBv
biBhbiBJQgo+IHN5c3RlbSwgcnVuIHRoZSBmb2xsb3dpbmcgY29tbWFuZDoKPiAKPiBzcnAtdGVz
dC9ydW5fdGVzdHMgLWQgLXIgMTAgLXEgMSAtdCAwMi1tcQo+IAo+IElmIHJ1bm5pbmcgb25lIG9m
IHRoZSBhYm92ZSBjb21tYW5kcyBvbmNlIHdvdWxkIG5vdCBiZSBzdWZmaWNpZW50IHRvCj4gdHJp
Z2dlciB0aGUKPiBsb2NrdXAsIHJlcnVuIHRoZSBjb21tYW5kIGEgZmV3IHRpbWVzLgo+IAo+IEJh
cnQuCgpUaGFua3MKQmFydApJIHdpbGwgdGFrZSBjYXJlIG9mIHRoaXMgdGVzdCBhbmQgY29tZSBi
YWNrIHRvIHlvdS4KRmlyc3QgZ29pbmcgdG8gdGVzdCB0aGUgc2NhdHRlci9nYXRoZXIgZml4LgpS
ZWdhcmRzCkxhdXJlbmNlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
