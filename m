From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 09/11] libmultipath:
 retain_attached_hw_handler obsolete with 4.3+
Date: Thu, 22 Jun 2017 08:07:37 +0200
Message-ID: <8e4846e6-a27f-4cbf-f04e-a13c08a15505@suse.de>
References: <20170621150630.25773-1-mwilck@suse.com>
	<20170621150630.25773-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170621150630.25773-10-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

T24gMDYvMjEvMjAxNyAwNTowNiBQTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IEtlcm5lbHMgNC4z
IGFuZCBuZXdlciAoY29tbWl0IDFiYWIwZGUwICJkbS1tcGF0aCwgc2NzaV9kaDogZG9uJ3QKPiBs
ZXQgZG0gZGV0YWNoIGRldmljZSBoYW5kbGVycyIpIGltcGx5ICJyZXRhaW5fYXR0YWNoZWRfaHdf
aGFuZGxlciB5ZXMiLgo+IAo+IENsYXJpZnkgdGhpcyBpbiB0aGUgcHJvcHNlbCBjb2RlLCBsb2cg
bWVzc2FnZXMsIGFuZCBkb2N1bWVudGF0aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBX
aWxjayA8bXdpbGNrQHN1c2UuY29tPgo+IC0tLQo+ICBsaWJtdWx0aXBhdGgvY29uZmlndXJlLmMg
ICB8ICAzICsrLQo+ICBsaWJtdWx0aXBhdGgvZG1wYXJzZXIuYyAgICB8ICAzICsrLQo+ICBsaWJt
dWx0aXBhdGgvcHJvcHNlbC5jICAgICB8ICA3ICsrKysrKy0KPiAgbGlibXVsdGlwYXRoL3V0aWwu
YyAgICAgICAgfCAzNiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiAgbGli
bXVsdGlwYXRoL3V0aWwuaCAgICAgICAgfCAgMiArKwo+ICBtdWx0aXBhdGgvbXVsdGlwYXRoLmNv
bmYuNSB8IDE1ICsrKysrKysrKysrLS0tLQo+ICA2IGZpbGVzIGNoYW5nZWQsIDU5IGluc2VydGlv
bnMoKyksIDcgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhh
cmVAc3VzZS5jb20+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAg
IFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAg
ICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0
MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwg
RC4gVXBtYW55dSwgRy4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
