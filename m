From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 14/23] libmultipath: print: use generic
 API for get_x_layout()
Date: Tue, 6 Mar 2018 08:12:01 +0100
Message-ID: <7a060b3a-ca6f-56db-f95c-76a09f370f56@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-15-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-15-mwilck@suse.com>
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

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IEludHJvZHVjZSBu
ZXcgZnVuY3Rpb25zIF9nZXRfcGF0aF9sYXlvdXQgYW5kIF9nZXRfbXVsdGlwYXRoX2xheW91dAo+
IHVzaW5nIHRoZSBuZXcgImdlbmVyaWMiIEFQSSB0byBkZXRlcm1pbmUgZmllbGQgd2lkdGhzLCBh
bmQgbWFwIHRoZQo+IG9sZCBBUEkgdG8gdGhlbS4KPiAKPiBGdXJ0aGVybW9yZSwgcmVwbGFjZSB0
aGUgYm9vbGVhbiAiaGVhZGVyIiBieSBhbiBlbnVtIHdpdGggMyBwb3NzaWJsZQo+IHZhbHVlcy4g
VGhlIG5ldyB2YWx1ZSBMQVlPVVRfUkVTRVRfTk9UIGFsbG93cyBjYWxsaW5nIHRoZSBnZXRfeF9s
YXlvdXQKPiBmdW5jdGlvbiBzZXZlcmFsIHRpbWVzIGFuZCBkZXRlcm1pbmUgdGhlIG92ZXJhbGwg
ZmllbGQgd2lkdGguCj4gCj4gU2lnbmVkLW9mZi1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3Vz
ZS5jb20+Cj4gUmV2aWV3ZWQtYnk6IEJlbmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0
LmNvbT4KPiAtLS0KPiAgbGlibXVsdGlwYXRoL3ByaW50LmMgfCA3MyArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tCj4gIGxpYm11bHRpcGF0aC9wcmlu
dC5oIHwgIDggKysrKysrCj4gIDIgZmlsZXMgY2hhbmdlZCwgNjUgaW5zZXJ0aW9ucygrKSwgMTYg
ZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5j
b20+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFk
IFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5
MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5i
ZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55
dSwgRy4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs
