From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/23] libmultipath: use "const" in
	devmapper code
Date: Tue, 6 Mar 2018 08:07:40 +0100
Message-ID: <d8f41667-4f0d-2e75-c22f-f3140eb2c069@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-8-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-8-mwilck@suse.com>
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

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IEltcHJvdmUgdXNl
IG9mICJjb25zdCIgcXVhbGlmaWVycyBpbiBsaWJtdWx0aXBhdGgncyBkZXZtYXBwZXIgY29kZS4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KPiBSZXZp
ZXdlZC1ieTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQo+
ICBsaWJtdWx0aXBhdGgvZGV2bWFwcGVyLmMgfCAzMiArKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tLQo+ICBsaWJtdWx0aXBhdGgvZGV2bWFwcGVyLmggfCAxNiArKysrKysrKy0tLS0tLS0t
Cj4gIDIgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pCj4g
ClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+CgpDaGVlcnMsCgpI
YW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3
b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNV
U0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVu
ZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwgRy4gTm9ydG9uCkhS
QiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs
