From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 07/17] multipathd: ignore failed wwid
	recheck
Date: Mon, 01 Apr 2019 16:32:00 +0200
Message-ID: <8479599ccaba1da17a1361a4866c860d91b43c84.camel@suse.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
	<1553925966-20958-8-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-8-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gU2F0LCAyMDE5LTAzLTMwIGF0IDAxOjA1IC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gSWYgZGlzYWJsZV9jaGFuZ2VkX3d3aWRzIGlzIHNldCwgd2hlbiBtdWx0aXBhdGhkIGdl
dHMgYSBjaGFuZ2UgZXZlbnQKPiBvbgo+IGEgcGF0aCwgaXQgdmVyaWZpZXMgdGhhdCB0aGUgd3dp
ZCBoYXNuJ3QgY2hhbmdlZCBpbgo+IHVldl91cGRhdGVfcGF0aCgpLgo+IElmIGdldF91aWQoKSBm
YWlsZWQsIHVldl91cGRhdGVfcGF0aCB0cmVhdGVkIHRoaXMgYXMgYSB3d2lkIGNoYW5nZSB0bwo+
IDAuCj4gVGhpcyBjb3VsZCBjYXVzZSBwYXRocyB0byBzdWRkZW5seSBiZSBkcm9wcGVkIGR1ZSB0
byBhbiBpc3N1ZSB3aXRoCj4gZ2V0dGluZyB0aGUgd3dpZC4gIEV2ZW4gaWYgZ2V0X3VpZCgpIGZh
aWxlZCBiZWNhdXNlIHRoZSBwYXRoIHdhcwo+IGRvd24sCj4gaXQgbm8gY2hhbmdlIHVldmVudCBo
YXBwZW5kIHdoZW4gaXQgbGF0ZXIgYmVjYW1lIGFjdGl2ZSwgbXVsdGlwYXRoZAo+IHdvdWxkIGNv
bnRpbnVlIHRvIGlnbm9yZSB0aGUgcGF0aC4gQWxzbywgc2NzaV91aWRfZmFsbGJhY2soKSBjbGVh
cnMKPiB0aGUKPiBmYWlsdXJlIHJldHVybiBpZiBpdCBkb2Vzbid0IGF0dGVtcHQgdG8gZmFsbGJh
Y2ssIGNhdXNpbmcgZ2V0X3VpZCgpCj4gdG8gcmV0dXJuIHN1Y2Nlc3MsIHdoZW4gaXQgYWN0dWFs
bHkgZmFpbGVkLgo+IAo+IE11bHRpcGF0aGQgc2hvdWxkIG5laXRoZXIgc2V0IG5vciBjbGVhciB3
d2lkX2NoYW5nZWQgaWYgZ2V0X3VpZCgpCj4gcmV0dXJuZWQgZmFpbHVyZS4gQWxzbywgc2NzaV91
aWRfZmFsbGJhY2soKSBzaG91bGQgcmV0YWluIHRoZSBvbGQKPiByZXR1cm4KPiB2YWx1ZSBpZiBp
dCBkb2Vzbid0IGF0dGVtcHQgdG8gZmFsbGJhY2suCj4gCj4gU2lnbmVkLW9mZi1ieTogQmVuamFt
aW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgoKUmV2aWV3ZWQtYnk6IE1hcnRpbiBX
aWxjayA8bXdpbGNrQHN1c2UuY29tPgoKCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3Vz
ZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBG
ZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0
IChBRyBOw7xybmJlcmcpCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
