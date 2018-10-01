From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 12/19] libmutipath: don't use malformed
	uevents
Date: Mon, 01 Oct 2018 23:31:51 +0200
Message-ID: <ca838355a4bc1e95de80021c1b4658cef1769a41.camel@suse.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-13-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-13-git-send-email-bmarzins@redhat.com>
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

T24gRnJpLCAyMDE4LTA5LTIxIGF0IDE4OjA1IC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gQSB1ZXZlbnQgdGhhdCBkb2Vzbid0IGluY2x1ZGUgdGhlIEFDVElPTiBhbmQgREVWUEFU
SCBmaWVsZHMgaXMKPiBtYWxmb3JtZWQuIEl0IHNob3VsZCBiZSBpZ25vcmVkLCBpbnN0ZWFkIG9m
IHVzZWQgd2l0aCB0aG9zZSBmaWVsZHMKPiBiZWluZwo+IE5VTEwuCj4gCj4gU2lnbmVkLW9mZi1i
eTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgoKUmV2aWV3ZWQtYnk6
IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgoKPiAtLS0KPiAgbGlibXVsdGlwYXRoL3Vl
dmVudC5jIHwgNiArKysrKysKPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQo+IAo+
IGRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvdWV2ZW50LmMgYi9saWJtdWx0aXBhdGgvdWV2ZW50
LmMKPiBpbmRleCBmZDhjYTM1Li41ZjkxMGU2IDEwMDY0NAo+IC0tLSBhL2xpYm11bHRpcGF0aC91
ZXZlbnQuYwo+ICsrKyBiL2xpYm11bHRpcGF0aC91ZXZlbnQuYwo+IEBAIC03MjksNiArNzI5LDEy
IEBAIHN0cnVjdCB1ZXZlbnQgKnVldmVudF9mcm9tX3VkZXZfZGV2aWNlKHN0cnVjdAo+IHVkZXZf
ZGV2aWNlICpkZXYpCj4gIAkJaWYgKGkgPT0gSE9UUExVR19OVU1fRU5WUCAtIDEpCj4gIAkJCWJy
ZWFrOwo+ICAJfQo+ICsJaWYgKCF1ZXYtPmRldnBhdGggfHwgISB1ZXYtPmFjdGlvbikgewo+ICsJ
CXVkZXZfZGV2aWNlX3VucmVmKGRldik7Cj4gKwkJY29uZGxvZygxLCAidWV2ZW50IG1pc3Npbmcg
bmVjZXNzYXJ5IGZpZWxkcyIpOwo+ICsJCUZSRUUodWV2KTsKPiArCQlyZXR1cm4gTlVMTDsKPiAr
CX0KPiAgCXVldi0+dWRldiA9IGRldjsKPiAgCXVldi0+ZW52cFtpXSA9IE5VTEw7Cj4gIAoKLS0g
CkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3NDA1
MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0
aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
