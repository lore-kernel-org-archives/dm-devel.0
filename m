From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Sat, 10 Feb 2018 20:42:31 +0100
Message-ID: <1518291751.2937.41.camel@suse.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518208256.2937.16.camel@suse.com>
	<20180209230449.GW14513@octiron.msp.redhat.com>
	<1518218931.2937.20.camel@suse.com> <1518219365.2937.22.camel@suse.com>
	<20180210003638.GY14513@octiron.msp.redhat.com>
	<1518279095.2937.25.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518279095.2937.25.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gU2F0LCAyMDE4LTAyLTEwIGF0IDE3OjExICswMTAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4g
T24gRnJpLCAyMDE4LTAyLTA5IGF0IDE4OjM2IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gPiBPbiBTYXQsIEZlYiAxMCwgMjAxOCBhdCAxMjozNjowNUFNICswMTAwLCBNYXJ0aW4g
V2lsY2sgd3JvdGU6Cj4gPiA+IE9uIFNhdCwgMjAxOC0wMi0xMCBhdCAwMDoyOCArMDEwMCwgTWFy
dGluIFdpbGNrIHdyb3RlOgo+ID4gPiA+IE1heWJlIGl0J3MgZWFzaWVyIHRoYW4gd2UgdGhvdWdo
dC4gQXR0YWNoZWQgaXMgYSBwYXRjaCBvbiB0b3AKPiA+ID4gPiBvZgo+ID4gPiA+IHlvdXJzIHRo
YXQgSSB0aGluayBtaWdodCB3b3JrLCBwbGVhc2UgaGF2ZSBhIGxvb2suIAo+ID4gPiA+IAo+ID4g
PiAKPiA+ID4gVGhhdCBvbmUgZGlkbid0IGV2ZW4gY29tcGlsZS4gVGhpcyBvbmUgaXMgYmV0dGVy
Lgo+ID4gPiAKPiA+ID4gTWFydGluCj4gPiAKPiA+IEhvdyBhYm91dCB0aGlzIG9uZSBpbnN0ZWFk
LiBUaGUgaWRlYSBpcyB0aGF0IG9uY2Ugd2UgYXJlIGluIHRoZQo+ID4gY2xlYW51cAo+ID4gaGFu
ZGxlciwgd2UganVzdCBjbGVhbnVwIGFuZCBleGl0LiBCdXQgYmVmb3JlIHdlIGVudGVyIGl0LCB3
ZQo+ID4gYXRvbWljYWxseQo+ID4gZXhjaGFuZ2UgcnVubmluZywgYW5kIGlmIHJ1bm5pbmcgd2Fz
IDAsIHdlIHBhdXNlKCksIHNpbmNlIHRoZQo+ID4gY2hlY2tlcgo+ID4gaXMKPiA+IGVpdGhlciBh
Ym91dCB0byBjYW5jZWwgdXMsIG9yIGFscmVhZHkgaGFzLgo+ID4gCj4gCj4gWWVzLCB0aGF0IHNo
b3VsZCB3b3JrLiBOaWNlLgoKLi4uIGJ1dCBJIGp1c3QgcmVhbGl6ZWQgdGhhdCB3ZSBkb24ndCBy
Y3VfcmVnaXN0ZXJfdGhyZWFkKCkgdGhlIFRVUgp0aHJlYWQuIE1heWJlIHdlIHNob3VsZCBpZiB3
ZSB1c2UgUkNVIHByaW1pdGl2ZXM/CgpNYXJ0aW4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2ls
Y2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgs
IEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJC
IDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw=
