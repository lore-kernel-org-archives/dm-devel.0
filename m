From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 11/23] libmultipath: add vector_convert()
Date: Tue, 6 Mar 2018 08:10:00 +0100
Message-ID: <67647cbe-e636-95c0-c24a-46f4db2c0f08@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-12-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-12-mwilck@suse.com>
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

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IFRoaXMgaXMgYSBo
YW5keSBoZWxwZXIgZm9yIGNyZWF0aW5nIG9uZSB2ZWN0b3IgZnJvbSBhbm90aGVyLAo+IG1hcHBp
bmcgZWFjaCBlbGVtZW50IG9mIHRoZSBvcmlnaW4gdmVjdG9yIHRvIGFuIGVsZW1lbnQgb2YKPiB0
aGUgdGFyZ2V0IHZlY3RvciB3aXRoIGEgZ2l2ZW4gY29udmVyc2lvbiBmdW5jdGlvbi4gSXQgY2Fu
Cj4gYWxzbyBiZSB1c2VkIHRvICJjb25jYXRlbmF0ZSIgdmVjdG9ycyBieSBwYXNzaW5nIGluIGEg
bm9uLU5VTEwgZmlyc3QKPiBhcmd1bWVudC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2ls
Y2sgPG13aWxja0BzdXNlLmNvbT4KPiBSZXZpZXdlZC1ieTogQmVuamFtaW4gTWFyemluc2tpIDxi
bWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQo+ICBsaWJtdWx0aXBhdGgvdmVjdG9yLmggfCAyOSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0
aW9ucygrKQo+CkF0IG9uZSBwb2ludCB3ZSBzaG91bGQgY29uc2lkZXIgbW92aW5nIHZlY3RvcnMg
dG8gbGlzdHMgLi4uCkFueXdheToKClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5jb20+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgIFRl
YW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAg
ICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4g
VXBtYW55dSwgRy4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
