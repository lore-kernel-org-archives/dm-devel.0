From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 06/23] libmultipath/print: use "const"
 where appropriate
Date: Tue, 6 Mar 2018 08:07:18 +0100
Message-ID: <fa045b76-d52d-31e0-19e7-c080422785f4@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-7-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IENvbnZlcnQgdGhl
IHByaW50LmgvcHJpbnQuYyBjb2RlIHRvIHVzZSAiY29uc3QiIHF1YWxpZmllcnMKPiBwcm9wZXJs
eS4gVGhpcyBpcyBnZW5lcmFsbHkgY29uc2lkZXJlZCBnb29kIHByb2dyYW1taW5nIHByYWN0aWNl
LAo+IGFuZCB0aGUgcHJpbnRpbmcgY29kZSBzaG91bGRuJ3QgY2hhbmdlIGFueSBvYmplY3RzIGFu
eXdheS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4K
PiBSZXZpZXdlZC1ieTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+
IC0tLQo+ICBsaWJtdWx0aXBhdGgvY29uZmlndXJlLmggfCAgIDEgLQo+ICBsaWJtdWx0aXBhdGgv
ZGlzY292ZXJ5LmMgfCAgIDYgKy0tCj4gIGxpYm11bHRpcGF0aC9kaXNjb3ZlcnkuaCB8ICAgNiAr
Ky0KPiAgbGlibXVsdGlwYXRoL3ByaW50LmMgICAgIHwgMTMzICsrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gIGxpYm11bHRpcGF0aC9wcmludC5oICAgICB8
ICA0MSArKysrKysrKy0tLS0tLS0KPiAgNSBmaWxlcyBjaGFuZ2VkLCA5NSBpbnNlcnRpb25zKCsp
LCA5MiBkZWxldGlvbnMoLSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBz
dXNlLmNvbT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAgVGVh
bWxlYWQgU3RvcmFnZSAmIE5ldHdvcmtpbmcKaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBO
w7xybmJlcmcKR0Y6IEYuIEltZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEouIEd1aWxkLCBELiBV
cG1hbnl1LCBHLiBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
