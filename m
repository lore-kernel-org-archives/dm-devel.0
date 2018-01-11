From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/3] Makefile.inc: Allow additional CFLAGS to
 be specified on the command line
Date: Thu, 11 Jan 2018 23:26:25 +0100
Message-ID: <1515709585.18410.8.camel@suse.com>
References: <20171212004503.12823-1-bart.vanassche@wdc.com>
	<20171212004503.12823-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171212004503.12823-2-bart.vanassche@wdc.com>
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

SGkgQmFydCwKCk9uIE1vbiwgMjAxNy0xMi0xMSBhdCAxNjo0NSAtMDgwMCwgQmFydCBWYW4gQXNz
Y2hlIHdyb3RlOgo+IENvbXBpbGluZyB0aGUgbXVsdGlwYXRoLXRvb2xzIHNvdXJjZSBjb2RlIHdp
dGggZS5nLiBzcGFyc2UgcmVxdWlyZXMKPiB0byBzcGVjaWZ5IGFkZGl0aW9uYWwgY29tcGlsZXIg
ZmxhZ3Mgb24gdGhlIGNvbW1hbmQgbGluZS4gTW9kaWZ5IHRoZQo+IE1ha2VmaWxlIHN1Y2ggdGhh
dCB0aGlzIGJlY29tZXMgcG9zc2libGUuCj4gCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNz
Y2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29tPgo+IC0tLQo+ICBNYWtlZmlsZS5pbmMgfCAzICsr
LQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL01ha2VmaWxlLmluYyBiL01ha2VmaWxlLmluYwo+IGluZGV4IDI5YzI5MGEy
MmU4Zi4uZDk1M2Y1ZWYzNGU2IDEwMDY0NAo+IC0tLSBhL01ha2VmaWxlLmluYwo+ICsrKyBiL01h
a2VmaWxlLmluYwo+IEBAIC05MCw3ICs5MCw4IEBAIE9QVEZMQUdTCT0gLU8yIC1nIC1waXBlIC1X
YWxsIC1XZXh0cmEKPiAtV2Zvcm1hdD0yIC1XZXJyb3I9aW1wbGljaXQtaW50IFwKPiAgCQkgIC1X
cCwtRF9GT1JUSUZZX1NPVVJDRT0yICQoU1RBQ0tQUk9UKSBcCj4gIAkJICAtLXBhcmFtPXNzcC1i
dWZmZXItc2l6ZT00Cj4gIAo+IC1DRkxBR1MJCT0gJChPUFRGTEFHUykgLURMSUJfU1RSSU5HPVwi
JHtMSUJ9XCIKPiAtRFJVTl9ESVI9XCIke1JVTn1cIgo+ICtDRkxBR1MJCTo9ICQoT1BURkxBR1Mp
IC1ETElCX1NUUklORz1cIiR7TElCfVwiCj4gLURSVU5fRElSPVwiJHtSVU59XCIgXAo+ICsJCSAg
ICQoQ0ZMQUdTKQoKSSdkIHByZWZlciB0aGUgdmFyaWFibGUgcGFzc2VkIGZyb20gdXNlciBzcGFj
ZSBub3QgdG8gYmUgY2FsbGVkIENGTEFHUwpidXQgZS5nLiBFWFRSQV9DRkxBR1MuIE90aGVyd2lz
ZSwgYWNrLgoKTWFydGluCgo+ICBCSU5fQ0ZMQUdTCT0gLWZQSUUgLURQSUUKPiAgTElCX0NGTEFH
Uwk9IC1mUElDCj4gIFNIQVJFRF9GTEFHUwk9IC1zaGFyZWQKCi0tIApEci4gTWFydGluIFdpbGNr
IDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4
IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0
b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw=
