From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 13/19] multipath: fix max array size in
 print_cmd_valid
Date: Mon, 01 Oct 2018 23:35:31 +0200
Message-ID: <5164846bf3163b3b74629aafa1941096466bb411.camel@suse.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-14-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-14-git-send-email-bmarzins@redhat.com>
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
dGU6Cj4gVGhlIGNvZGUgaXMgYXR0ZW1wdGluZyB0byB2ZXJpZnkgdGhhdCAwIDw9IGsgPCAzCj4g
SG93ZXZlciwgc2l6ZW9mKHZhbCkgaXMgMTIsIGFzc3VtaW5nIDQgYnl0ZSBpbnRlZ2Vycy4gVGhl
IGNoZWNrIG5lZWRzCj4gdG8KPiB0YWtlIGludGVnZXIgc2l6ZSBpbnRvIGFjY291bnQuIEZvdW5k
IGJ5IGNvdmVyaXR5Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEJlbmphbWluIE1hcnppbnNraSA8Ym1h
cnppbnNAcmVkaGF0LmNvbT4KClJldmlld2VkLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNl
LmNvbT4KCj4gLS0tCj4gIG11bHRpcGF0aC9tYWluLmMgfCAyICstCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYgLS1naXQgYS9tdWx0aXBh
dGgvbWFpbi5jIGIvbXVsdGlwYXRoL21haW4uYwo+IGluZGV4IGZjNWJmMTYuLmQ1YWFkOTUgMTAw
NjQ0Cj4gLS0tIGEvbXVsdGlwYXRoL21haW4uYwo+ICsrKyBiL211bHRpcGF0aC9tYWluLmMKPiBA
QCAtNDgyLDcgKzQ4Miw3IEBAIHN0YXRpYyBpbnQgcHJpbnRfY21kX3ZhbGlkKGludCBrLCBjb25z
dCB2ZWN0b3IKPiBwYXRodmVjLAo+ICAJc3RydWN0IHRpbWVzcGVjIHVudGlsOwo+ICAJc3RydWN0
IHBhdGggKnBwOwo+ICAKPiAtCWlmIChrIDwgMCB8fCBrID49IHNpemVvZih2YWxzKSkKPiArCWlm
IChrIDwgMCB8fCBrID49IChzaXplb2YodmFscykgLyBzaXplb2YoaW50KSkpCj4gIAkJcmV0dXJu
IDE7Cj4gIAo+ICAJaWYgKGsgPT0gMikgewoKLS0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0Bz
dXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6
IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEy
ODQgKEFHIE7DvHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
