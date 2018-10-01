From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 11/19] libmultipath: fix null dereference
 int alloc_path_group
Date: Mon, 01 Oct 2018 23:33:21 +0200
Message-ID: <df1df2c77e869580ddd5e662a2b6cb5a282d2bc7.camel@suse.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-12-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-12-git-send-email-bmarzins@redhat.com>
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
dGU6Cj4gSWYgYWxsX3BhdGhncm91cCBmYWlsZWQgdG8gYWxsb2NhdGUgYSB2ZWN0b3IgZm9yIHBn
cC0+cGF0aHMsIGluc3RlYWQKPiBvZgo+IGZhaWxpbmcgYWZ0ZXIgaXQgZnJlZWQgcGdwLCBpdCB3
b3VsZCBzZXQgcGdwIHRvIE5VTEwgYW5kIHRoZW4KPiBkZXJlZmVyZW5jZSBpdC4gVGhpcyBwYXRj
aCBmaXhlcyB0aGF0LiBGb3VuZCBieSBjb3Zlcml0eS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCZW5q
YW1pbiBNYXJ6aW5za2kgPGJtYXJ6aW5zQHJlZGhhdC5jb20+CgpSZXZpZXdlZC1ieTogTWFydGlu
IFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cgo+IC0tLQo+ICBsaWJtdWx0aXBhdGgvc3RydWN0cy5j
IHwgMiArLQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkK
PiAKPiBkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3N0cnVjdHMuYyBiL2xpYm11bHRpcGF0aC9z
dHJ1Y3RzLmMKPiBpbmRleCBhZTg0N2Q2Li5jYWExNzhhIDEwMDY0NAo+IC0tLSBhL2xpYm11bHRp
cGF0aC9zdHJ1Y3RzLmMKPiArKysgYi9saWJtdWx0aXBhdGgvc3RydWN0cy5jCj4gQEAgLTE2NSw3
ICsxNjUsNyBAQCBhbGxvY19wYXRoZ3JvdXAgKHZvaWQpCj4gIAo+ICAJaWYgKCFwZ3AtPnBhdGhz
KSB7Cj4gIAkJRlJFRShwZ3ApOwo+IC0JCXBncCA9IE5VTEw7Cj4gKwkJcmV0dXJuIE5VTEw7Cj4g
IAl9Cj4gIAo+ICAJZG1fcGF0aGdyb3VwX3RvX2dlbihwZ3ApLT5vcHMgPSAmZG1fZ2VuX3BhdGhn
cm91cF9vcHM7CgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiAr
NDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJm
ZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJn
KQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
