From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/4] multipath: Fix a potential buffer
 overflow
Date: Tue, 13 Jun 2017 22:35:08 +0200
Message-ID: <1497386108.4654.58.camel@suse.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
	<20170613163339.23005-5-bart.vanassche@sandisk.com>
	<1497382123.4654.48.camel@suse.com>
	<5549db47-506b-f564-19ff-8d9dd1c36177@sandisk.com>
	<1497385089.4654.54.camel@suse.com>
	<5bf47087-fc60-eda8-89f4-5d756f52b45e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5bf47087-fc60-eda8-89f4-5d756f52b45e@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

SGVsbG8gQmFydCwKCk9uIFR1ZSwgMjAxNy0wNi0xMyBhdCAxMzoyMSAtMDcwMCwgQmFydCBWYW4g
QXNzY2hlIHdyb3RlOgo+IAo+ID4gPiBIZWxsbyBNYXJ0aW4sCj4gPiA+IAo+ID4gPiBFdmVyeSBz
cHJpbnRmKCkgY2FsbCByZXF1aXJlcyBjYXJlZnVsIGFuYWx5c2lzIHRvIHNlZSB3aGV0aGVyIG9y
Cj4gPiA+IG5vdAo+ID4gPiBpdAo+ID4gPiB0cmlnZ2VycyBhIGJ1ZmZlciBvdmVyZmxvdy4gSSBy
ZWFsbHkgd291bGQgbGlrZSB0byBnZXQgcmlkIG9mCj4gPiA+IHRoYXQKPiA+ID4gc3ByaW50Zigp
IGNhbGwuCj4gPiAKPiA+IFRoZW4gd2UgY291bGQgd3JpdGUKPiA+IAo+ID4gCXNucHJpbnRmKCpy
ZXBseSwgMiwgIiVkIiwgISFtcHAtPnByZmxhZyk7Cj4gPiAgIAo+ID4gd2l0aG91dCBuZWVkaW5n
IF9HTlVfU09VUkNFLgo+IAo+IEhlbGxvIE1hcnRpbiwKPiAKPiBUaGVyZSBhcmUgYWxyZWFkeSB0
aHJlZSBvdGhlciBtdWx0aXBhdGgtdG9vbHMgc291cmNlIGZpbGVzIHRoYXQKPiAjZGVmaW5lCj4g
X0dOVV9TT1VSQ0Ugc28gSSBkb24ndCBzZWUgd2hhdCdzIHdyb25nIHdpdGggdXNpbmcgX0dOVV9T
T1VSQ0UuCgpZZXMsIEkgc2F3IHRoYXQuIEkgaGF2ZW4ndCByZXZpZXdlZCB0aGUgcmVhc29uIHdo
eSBfR05VX1NPVVJDRSBpcyB1c2VkCmluIHRoZSBvdGhlciBwbGFjZXMuIEluIGdlbmVyYWwgaXQn
cyBhIHRoaW5nIEknZCByYXRoZXIgYXZvaWQgZm9yCnBvcnRhYmlsaXR5IHJlYXNvbnMuCkluIHRo
aXMgcGFydGljdWxhciBjYXNlLCBJIHRoaW5rIHRoZSBwcm9ibGVtIGF0IGhhbmQgYmUgZWFzaWx5
IHNvbHZlZAp3aXRob3V0IHJlc29ydGluZyB0byBfR05VX1NPVVJDRS4KCkJ1dCB3ZWxsLCBpdCdz
IG5vdCBhIHRoaW5nIHdvcnRoIGZpZ2h0aW5nIGFib3V0LiBNYXkgQ2hyaXN0b3BoZSBkZWNpZGUu
CgpNYXJ0aW4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0
OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZm
ZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcp
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
