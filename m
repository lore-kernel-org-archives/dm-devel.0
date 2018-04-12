From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v4 10/20] libmultipath: indicate wwid failure
 in dm_addmap_create()
Date: Thu, 12 Apr 2018 22:16:42 +0200
Message-ID: <1523564202.4346.29.camel@suse.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-11-mwilck@suse.com>
	<20180412183343.GM3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180412183343.GM3103@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTA0LTEyIGF0IDEzOjMzIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gT24gV2VkLCBBcHIgMDQsIDIwMTggYXQgMDY6MTY6MTdQTSArMDIwMCwgTWFydGluIFdp
bGNrIHdyb3RlOgo+ID4gZG1fYWRkbWFwX2NyZWF0ZSgpIGlzIHdoZXJlIHdlIGFjdHVhbGx5IHRy
eSB0byBzZXQgdXAgYSBuZXcKPiA+IG11bHRpcGF0aCBtYXAuIERlcGVuZGluZyBvbiB0aGUgcmVz
dWx0LCBtYXJrIHRoZSB3d2lkIGFzCj4gPiBmYWlsZWQgKG9yIG5vdCksIGFuZCByZS10cmlnZ2Vy
IGFuIHVldmVudCBpZiBuZWNlc3NhcnkuCj4gPiBJZiBhIHBhdGggY2hhbmdlcyBmcm9tIG11bHRp
cGF0aCB0byBub24tbXVsdGlwYXRoLCB1c2UgYW4gImFkZCIKPiA+IGV2ZW50IHRvIG1ha2Ugc3Vy
ZSBMVk0yIHJ1bGVzIHBpY2sgaXQgdXAuIEluY3JlYXNlIGxvZyBsZXZlbAo+ID4gb2YgdGhpcyBl
dmVudCB0byAzLgo+ID4gCj4gCj4gQnkgb25seSBsb29raW5nIGF0IGRvbWFwLCB3ZSB3aWxsIG1p
c3MgaW5zdGFuY2VzIG9mIG11bHRpcGF0aGQKPiBmYWlsaW5nCj4gdG8gY3JlYXRlIG1hcHMgZWFy
bGllciBpbiB0aGUgcHJvY2Vzcy4gVGhpcyBpc24ndCBuZWNlc3NhcmlseSB3cm9uZy4KPiBJdAo+
IGp1c3QgbWVhbnMgdGhhdCB3ZSBjYW4ndCByZWx5IG9uIGNoZWNraW5nCj4gL2Rldi9zaG0vbXVs
dGlwYXRoL2ZhaWxlZF93d2lkcyB0byBkZWZpbml0aXZlbHkgdGVsbCB1cyB3aGV0aGVyCj4gbXVs
dGlwYXRoZCBoYXMgdHJpZWQgYW5kIGZhaWxlZCB0byBjcmVhdGUgdGhlIGRldmljZS4KClNvcnJ5
LCBJIGNhbid0IGZvbGxvdyB5b3UuIFdoZXJlIGVsc2UgZXhjZXB0IGluIHRoZSAKZG9tYXAtPmRt
X2FkZG1hcF9jcmVhdGUtPmRtX2FkZG1hcCgpIGNvZGUgcGF0aCBkbyB3ZSBjcmVhdGUgbWFwcz8K
SSdtIGZlZWxpbmcgc3R1cGlkLCBJIHJlYWxseSBjYW4ndCBzZWUgaXQuCgpNYXJ0aW4KCi0tIApE
ci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMg
MjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhh
cmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
