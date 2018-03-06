From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 03/23] libmultipath: get rid of selector
 "hack" in print.c
Date: Tue, 6 Mar 2018 08:05:28 +0100
Message-ID: <66b1b843-d029-fc01-1bef-b17ad6ed6a21@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-4-mwilck@suse.com>
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

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IEJ5IHByb3Blcmx5
IGxpbmtpbmcgdGhlIHBhdGggZ3JvdXBzIHdpdGggdGhlaXIgcGFyZW50IG11bHRpcGF0aCwKPiB3
ZSBkb24ndCBuZWVkIHRoaXMgImhhY2siIGFueSBtb3JlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1h
cnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+IFJldmlld2VkLWJ5OiBCZW5qYW1pbiBNYXJ6
aW5za2kgPGJtYXJ6aW5zQHJlZGhhdC5jb20+Cj4gLS0tCj4gIGxpYm11bHRpcGF0aC9kbXBhcnNl
ci5jICAgfCAgMiArLQo+ICBsaWJtdWx0aXBhdGgvcGdwb2xpY2llcy5jIHwgMTEgKysrKysrLS0t
LS0KPiAgbGlibXVsdGlwYXRoL3ByaW50LmMgICAgICB8ICA2ICsrKy0tLQo+ICBsaWJtdWx0aXBh
dGgvc3RydWN0cy5jICAgIHwgMTAgKysrKysrKysrKwo+ICBsaWJtdWx0aXBhdGgvc3RydWN0cy5o
ICAgIHwgIDMgKystCj4gIDUgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFkIFN0
b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEg
NzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJn
CkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwg
Ry4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs
