From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 09/23] multipath-tools: Makefile.inc: use
 -Werror=cast-qual
Date: Tue, 6 Mar 2018 08:08:36 +0100
Message-ID: <dbdf17e9-8375-dbef-d8e7-f8489f720d2c@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-10-mwilck@suse.com>
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

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IENhc3RpbmcgImNv
bnN0IiBhd2F5IGlzIG9mdGVuIGFuIGluZGljYXRvciBmb3Igd3JvbmcgY29kZS4KPiBBZGQgYSBj
b21waWxlciBmbGFnIHRvIHdhcm4gYWJvdXQgc3VjaCBwb3NzaWJsZSBicmVha2FnZS4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KPiBSZXZpZXdlZC1i
eTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQo+ICBNYWtl
ZmlsZS5pbmMgfCAxICsKPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCj4gCj4gZGlm
ZiAtLWdpdCBhL01ha2VmaWxlLmluYyBiL01ha2VmaWxlLmluYwo+IGluZGV4IGViOTljMzYwMTBj
MS4uYTViOWQ0ZTNmYTc0IDEwMDY0NAo+IC0tLSBhL01ha2VmaWxlLmluYwo+ICsrKyBiL01ha2Vm
aWxlLmluYwo+IEBAIC04Nyw2ICs4Nyw3IEBAIFNUQUNLUFJPVCA6PSAkKGNhbGwgVEVTVF9DQ19P
UFRJT04sLWZzdGFjay1wcm90ZWN0b3Itc3Ryb25nLC1mc3RhY2stcHJvdGVjdG9yKQo+ICBPUFRG
TEFHUwk9IC1PMiAtZyAtcGlwZSAtV2FsbCAtV2V4dHJhIC1XZm9ybWF0PTIgLVdlcnJvcj1pbXBs
aWNpdC1pbnQgXAo+ICAJCSAgLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbiAt
V2Vycm9yPWZvcm1hdC1zZWN1cml0eSBcCj4gIAkJICAtV25vLXNpZ24tY29tcGFyZSAtV25vLXVu
dXNlZC1wYXJhbWV0ZXIgLVduby1jbG9iYmVyZWQgXAo+ICsJCSAgLVdlcnJvcj1jYXN0LXF1YWwg
LVdlcnJvcj1kaXNjYXJkZWQtcXVhbGlmaWVycyBcCj4gIAkJICAtV3AsLURfRk9SVElGWV9TT1VS
Q0U9MiAkKFNUQUNLUFJPVCkgXAo+ICAJCSAgLS1wYXJhbT1zc3AtYnVmZmVyLXNpemU9NAo+ICAK
PiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4KCkNoZWVycywK
Ckhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAgVGVhbWxlYWQgU3RvcmFnZSAmIE5l
dHdvcmtpbmcKaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgK
U1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEYuIElt
ZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEouIEd1aWxkLCBELiBVcG1hbnl1LCBHLiBOb3J0b24K
SFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=
