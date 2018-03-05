From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/6] libmultipath,
 alloc_path_with_pathinfo(): Ensure that pp->wwid is '\0'-terminated
Date: Mon, 05 Mar 2018 17:11:07 +0100
Message-ID: <1520266267.7660.6.camel@suse.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
	<20180301192935.14643-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301192935.14643-3-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTAzLTAxIGF0IDExOjI5IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gRGlzY292ZXJlZCBieSBDb3Zlcml0eSAoQ0lEIDE3MzI1NykuCj4gCj4gU2lnbmVkLW9mZi1i
eTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29tPgoKUmV2aWV3ZWQtYnk6
IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgoKPiAtLS0KPiAgbGlibXVsdGlwYXRoL2Rp
c2NvdmVyeS5jIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyBi
L2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwo+IGluZGV4IDRiMzFkZGVmMjNmMC4uZmU1MGNlNTA2
MmVhIDEwMDY0NAo+IC0tLSBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwo+ICsrKyBiL2xpYm11
bHRpcGF0aC9kaXNjb3ZlcnkuYwo+IEBAIC01Miw4ICs1Miw4IEBAIGFsbG9jX3BhdGhfd2l0aF9w
YXRoaW5mbyAoc3RydWN0IGNvbmZpZyAqY29uZiwKPiBzdHJ1Y3QgdWRldl9kZXZpY2UgKnVkZXZp
Y2UsCj4gIAlpZiAoIXBwKQo+ICAJCXJldHVybiBQQVRISU5GT19GQUlMRUQ7Cj4gIAo+IC0JaWYo
d3dpZCkKPiAtCQlzdHJuY3B5KHBwLT53d2lkLCB3d2lkLCBzaXplb2YocHAtPnd3aWQpKTsKPiAr
CWlmICh3d2lkKQo+ICsJCXN0cmxjcHkocHAtPnd3aWQsIHd3aWQsIHNpemVvZihwcC0+d3dpZCkp
Owo+ICAKPiAgCWlmIChzYWZlX3NwcmludGYocHAtPmRldiwgIiVzIiwgZGV2bmFtZSkpIHsKPiAg
CQljb25kbG9nKDAsICJwcC0+ZGV2IHRvbyBzbWFsbCIpOwoKCgotLSAKRHIuIE1hcnRpbiBXaWxj
ayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51
eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9y
dG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs
