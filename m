From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/2] libmultipath: don't update path queueing
	on reload
Date: Mon, 18 Dec 2017 14:49:10 +0100
Message-ID: <1513604950.22953.24.camel@suse.com>
References: <1513188487-31852-1-git-send-email-bmarzins@redhat.com>
	<1513188487-31852-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1513188487-31852-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gV2VkLCAyMDE3LTEyLTEzIGF0IDEyOjA4IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gV2l0aCB0aGUgZml4IHRvIHRoZSBmZWF0dXJlcyBoYW5kbGluZyBjb2RlLCB0aGUgbXVs
dGlwYXRoIGRldmljZQo+IHNob3VsZAo+IGFscmVhZHkgYmUgcmVsb2FkZWQgd2l0aCB0aGUgY29y
cmVjdCB2YWx1ZSBmb3IgcXVldWVfaWZfbm9fcGF0aCwgc28KPiB0aGVyZSdzIG5vIG5lZWQgdG8g
Z28gcmVzZXQgaXQgaW1tZWRpYXRlbHkgYWZ0ZXJ3YXJkcy4KPiAKPiBDYzogTWFydGluIFdpbGNr
IDxtd2lsY2tAc3VzZS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogQmVuamFtaW4gTWFyemluc2tpIDxi
bWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQo+ICBsaWJtdWx0aXBhdGgvY29uZmlndXJlLmMgfCA2
IC0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0
IGEvbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5jIGIvbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5jCj4g
aW5kZXggYmZhNTA0OC4uNmYyOGY0NSAxMDA2NDQKPiAtLS0gYS9saWJtdWx0aXBhdGgvY29uZmln
dXJlLmMKPiArKysgYi9saWJtdWx0aXBhdGgvY29uZmlndXJlLmMKPiBAQCAtMTM1MSwxMiArMTM1
MSw2IEBAIGludCByZWxvYWRfbWFwKHN0cnVjdCB2ZWN0b3JzICp2ZWNzLCBzdHJ1Y3QKPiBtdWx0
aXBhdGggKm1wcCwgaW50IHJlZnJlc2gsCj4gIAkJCSJmb3IgcmVsb2FkIG1hcCIsIG1wcC0+YWxp
YXMsIHIpOwo+ICAJCXJldHVybiAxOwo+ICAJfQo+IC0JaWYgKG1wcC0+bm9fcGF0aF9yZXRyeSAh
PSBOT19QQVRIX1JFVFJZX1VOREVGKSB7Cj4gLQkJaWYgKG1wcC0+bm9fcGF0aF9yZXRyeSA9PSBO
T19QQVRIX1JFVFJZX0ZBSUwpCj4gLQkJCWRtX3F1ZXVlX2lmX25vX3BhdGgobXBwLT5hbGlhcywg
MCk7Cj4gLQkJZWxzZQo+IC0JCQlkbV9xdWV1ZV9pZl9ub19wYXRoKG1wcC0+YWxpYXMsIDEpOwo+
IC0JfQo+ICAKPiAgCXJldHVybiAwOwo+ICB9CkFDSwoKLS0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13
aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21i
SCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpI
UkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==
