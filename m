From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/4] crypto: essiv - create wrapper
	template for ESSIV generation
Date: Wed, 19 Jun 2019 17:45:13 +0200
Message-ID: <CAKv+Gu_okSc=Ep9nbdqnbB1hVRmr8O4tChDPm+m7O+jb1pBD_A@mail.gmail.com>
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
	<20190618212749.8995-2-ard.biesheuvel@linaro.org>
	<CAAUqJDsi_acZj09xiimYGfyJVPt0zo=3-2PHuGnSKSaq82-RQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAUqJDsi_acZj09xiimYGfyJVPt0zo=3-2PHuGnSKSaq82-RQA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

T24gV2VkLCAxOSBKdW4gMjAxOSBhdCAxNzoxOCwgT25kcmVqIE1vc27DocSNZWsgPG9tb3NuYWNl
a0BnbWFpbC5jb20+IHdyb3RlOgo+Cj4gSGkgQXJkLAo+Cj4gdXQgMTguIDYuIDIwMTkgbyAyMzoy
OCBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4gbmFww61zYWwoYSk6
Cj4gPiBJbXBsZW1lbnQgYSB0ZW1wbGF0ZSB0aGF0IHdyYXBzIGEgKHNrY2lwaGVyLGNpcGhlcixz
aGFzaCkgb3IKPiA+IChhZWFkLGNpcGhlcixzaGFzaCkgdHVwbGUgc28gdGhhdCB3ZSBjYW4gY29u
c29saWRhdGUgdGhlIEVTU0lWIGhhbmRsaW5nCj4gPiBpbiBmc2NyeXB0IGFuZCBkbS1jcnlwdCBh
bmQgbW92ZSBpdCBpbnRvIHRoZSBjcnlwdG8gQVBJLiBUaGlzIHdpbGwgcmVzdWx0Cj4gPiBpbiBi
ZXR0ZXIgdGVzdCBjb3ZlcmFnZSwgYW5kIHdpbGwgYWxsb3cgZnV0dXJlIGNoYW5nZXMgdG8gbWFr
ZSB0aGUgYmFyZQo+ID4gY2lwaGVyIGludGVyZmFjZSBpbnRlcm5hbCB0byB0aGUgY3J5cHRvIHN1
YnN5c3RlbSwgaW4gb3JkZXIgdG8gaW5jcmVhc2UKPiA+IHJvYnVzdG5lc3Mgb2YgdGhlIEFQSSBh
Z2FpbnN0IG1pc3VzZS4KPiA+Cj4gPiBOb3RlIHRoYXQgZXNwZWNpYWxseSB0aGUgQUVBRCBoYW5k
bGluZyBpcyBhIGJpdCBjb21wbGV4LCBhbmQgaXMgdGlnaHRseQo+ID4gY291cGxlZCB0byB0aGUg
d2F5IGRtLWNyeXB0IGNvbWJpbmVzIEFFQUQgYmFzZWQgb24gdGhlIGF1dGhlbmMoKSB0ZW1wbGF0
ZQo+ID4gd2l0aCB0aGUgRVNTSVYgaGFuZGxpbmcuCj4KPiBXb3VsZG4ndCBpdCB3b3JrIGJldHRl
ciB0byBoYXZlIGEgdGVtcGxhdGUgb25seSBmb3Igc2tjaXBoZXIgYW5kIGluCj4gZG0tY3J5cHQg
anVzdCBpbmplY3QgdGhlIGVzc2l2KCkgdGVtcGxhdGUgaW50byB0aGUgY2lwaGVyIHN0cmluZz8g
Rm9yCj4gZXhhbXBsZTogImF1dGhlbmMoaG1hYyhzaGEyNTYpLGNiYyhhZXMpKS1lc3NpdjpzaGEy
NTYiIC0+Cj4gImF1dGhlbmMoaG1hYyhzaGEyNTYpLGVzc2l2KGNiYyhhZXMpLGFlcyxzaGEyNTYp
KSIuIFRoYXQgc2VlbXMgdG8gbWUgYQo+IG11Y2ggc2ltcGxlciBoYWNrLiAoQnV0IG1heWJlIEkn
bSBtaXNzaW5nIHNvbWUgaXNzdWUgaW4gdGhhdAo+IGFwcHJvYWNoLi4uKQo+CgpVbmZvcnR1bmF0
ZWx5LCB0aGF0IGRvZXNuJ3Qgd29yay4gV2hlbiB1c2luZyBBRUFEcywgZG0tY3J5cHQgYWxzbyBw
dXRzCnRoZSBJViBpbiB0aGUgQUFEIGFyZWEuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw=
