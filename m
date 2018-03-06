From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 08/23] libmultipath: fix compiler warnings
 for -Wcast-qual
Date: Tue, 6 Mar 2018 08:08:12 +0100
Message-ID: <34f695f6-b4cc-1efd-4fe9-f2e17d2ce9cd@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-9-mwilck@suse.com>
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

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IEZpeCB0aGUgd2Fy
bmluZ3MgdGhhdCB3ZXJlIGNhdXNlZCBieSBhZGRpbmcgdGhlIC1XY2FzdC1xdWFsIGNvbXBpbGVy
Cj4gZmxhZyBpbiB0aGUgcHJldmlvdXMgcGF0Y2guCj4gCj4gU2lnbmVkLW9mZi1ieTogTWFydGlu
IFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cj4gUmV2aWV3ZWQtYnk6IEJlbmphbWluIE1hcnppbnNr
aSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4KPiAtLS0KPiAga3BhcnR4L2Rldm1hcHBlci5jICAgICAg
ICAgIHwgIDMgKystCj4gIGxpYm1wYXRoY21kL21wYXRoX2NtZC5jICAgICB8ICAyICstCj4gIGxp
Ym11bHRpcGF0aC9jaGVja2Vycy9yYmQuYyB8ICA0ICsrLS0KPiAgbGlibXVsdGlwYXRoL2Rldm1h
cHBlci5jICAgIHwgIDMgKystCj4gIGxpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyAgICB8IDEyICsr
KysrKy0tLS0tLQo+ICBsaWJtdWx0aXBhdGgvbGlzdC5oICAgICAgICAgfCAgNCArKy0tCj4gIGxp
Ym11bHRpcGF0aC9tZW1vcnkuaCAgICAgICB8ICA4ICsrKysrKystCj4gIGxpYm11bHRpcGF0aC9z
dHJ1Y3RzLmMgICAgICB8ICAyICstCj4gIGxpYm11bHRpcGF0aC9zdHJ1Y3RzLmggICAgICB8ICAy
ICstCj4gIGxpYm11bHRpcGF0aC91ZXZlbnQuYyAgICAgICB8ICA2ICsrKy0tLQo+ICBsaWJtdWx0
aXBhdGgvdXRpbC5jICAgICAgICAgfCAgNiArKystLS0KPiAgbXVsdGlwYXRoZC9tYWluLmMgICAg
ICAgICAgIHwgMTAgKysrKystLS0tLQo+ICAxMiBmaWxlcyBjaGFuZ2VkLCAzNSBpbnNlcnRpb25z
KCspLCAyNyBkZWxldGlvbnMoLSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFy
ZUBzdXNlLmNvbT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAg
VGVhbWxlYWQgU3RvcmFnZSAmIE5ldHdvcmtpbmcKaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAg
ICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcKR0Y6IEYuIEltZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEouIEd1aWxkLCBE
LiBVcG1hbnl1LCBHLiBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
