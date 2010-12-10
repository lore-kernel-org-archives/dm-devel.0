From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re:
 dm-crypt barrier support is effective)
Date: Fri, 10 Dec 2010 08:58:25 -0600
Message-ID: <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m__25507.9889357605$1291993241$gmane$org@mail.gmail.com>
References: <20101207182243.GB21112@redhat.com>
	<20101207193514.GA2921@thunk.org>
	<AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
	<20101209180111.GF2921@thunk.org>
	<AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
	<20101209201359.GG2921@thunk.org>
	<AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
	<20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think>
	<AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
	<20101210023852.GB3059@thunk.org>
	<AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>, Andi Kleen <andi@firstfloor.org>, Jon Nelson <jnelson@jamponi.net>, Mike
List-Id: dm-devel.ids

T24gRnJpLCBEZWMgMTAsIDIwMTAgYXQgMTI6NTIgQU0sIEpvbiBOZWxzb24gPGpuZWxzb25AamFt
cG9uaS5uZXQ+IHdyb3RlOgo+IE9uIFRodSwgRGVjIDksIDIwMTAgYXQgODozOCBQTSwgVGVkIFRz
J28gPHR5dHNvQG1pdC5lZHU+IHdyb3RlOgo+PiBPbiBGcmksIERlYyAxMCwgMjAxMCBhdCAwMjo1
MzozMEFNICswMTAwLCBNYXR0IHdyb3RlOgo+Pj4KPj4+IFRyeSBhIGtlcm5lbCBiZWZvcmUgNWE4
N2I3YTVkYTI1MGM5YmU2ZDc1Nzc1ODQyNWRmZWFmOGVkMzE3OQo+Pj4KPj4+IGZyb20gdGhlIHRl
c3RzIEkndmUgZG9uZSB0aGF0IG9uZSBzaG93ZWQgdGhlIGxlYXN0IG9yIG5vIGNvcnJ1cHRpb24g
aWYKPj4+IHlvdSBjb3VudCB0aGUgZW1wdHkgL2V0Yy9lbnYuZC8wM29wZW5nbCBhcyBhbiBhcnRl
ZmFjdAo+Pgo+PiBZZXMsIHRoYXQncyBhIGdvb2QgdGVzdC4gwqBBbHNvIHRyeSBjb21taXQgYmQy
ZDAyMTBjZi4gwqBUaGUgcGF0Y2gKPj4gc2VyaWVzIHRoYXQgaXMgbW9zdCBsaWtlbHkgdG8gYmUg
YXQgZmF1bHQgaWYgdGhlcmUgaXMgYSByZWdyZXNzaW9uIGluCj4+IGJldHdlZW4gNWE4N2I3YTVk
IGFuZCBiZDJkMDIxMGNmIGluY2x1c2l2ZS4KPj4KPj4gSSBkaWQgYSBsb3Qgb2YgdGVzdGluZyBi
ZWZvcmUgc3VibWl0dGluZyBpdCwgYnV0IHRoYXQgd2EgYSB0cmlja3kKPj4gcmV3cml0ZS4gwqBJ
ZiB5b3UgY2FuIHJlcHJvZHVjZSB0aGUgcHJvYmxlbSByZWxpYWJseSwgaXQgbWlnaHQgYmUgZ29v
ZAo+PiB0byB0cnkgY29tbWl0IDE2ODI4MDg4ZjkgKHRoZSBjb21taXQgYmVmb3JlIDVhODdiN2E1
ZCkgYW5kIGNvbW1pdAo+PiBiZDJkMDIxMGNmLiDCoElmIGl0IHJlbGlhYmx5IHJlcHJvZHVjZXMg
b24gYmQyZDAyMTBjZiwgYnV0IGlzIGNsZWFuIG9uCj4+IDE2ODI4MDg4ZjksIHRoZW4gaXQncyBt
eSBleHQ0IGJsb2NrIGkvbyBzdWJtaXNzaW9uIHBhdGNoZXMsIGFuZCB3ZSdsbAo+PiBuZWVkIHRv
IGVpdGhlciBmaWd1cmUgb3V0IHdoYXQncyBnb2luZyBvbiBvciBiYWNrIG91dCB0aGF0IHNldCBv
Zgo+PiBjaGFuZ2VzLgo+Pgo+PiBJZiB0aGF0J3MgdGhlIGNhc2UsIGEgYmlzZWN0IG9mIHRob3Nl
IGNoYW5nZXMgKGl0J3Mgb25seSA2IGNvbW1pdHMsIHNvCj4+IGl0IHNob3VsZG4ndCB0YWtlIGxv
bmcpIHdvdWxkIGJlIG1vc3QgYXBwcmVjaWF0ZWQuCj4KPiBJIG9ic2VydmVkIHRoZSBiZWhhdmlv
ciBvbiBiZDJkMDIxMGNmIGluIGEgcWVtdS1rdm0gaW5zdGFsbCBvZgo+IG9wZW5TVVNFIDExLjMg
KHg4Nl82NCkgb24gKnRvdGFsbHkqIGRpZmZlcmVudCBob3N0IC0gYW4gQU1EIHF1YWQtY29yZS4K
Pgo+IEkgZGlkIC9ub3QvIG9ic2VydmUgdGhlIGJlaGF2aW9yIG9uIDE2ODI4MDg4ZjkgKHlldCku
IEknbGwgcnVuIHRoZQo+IHRlc3QgYSBmZXcgbW9yZSB0aW1lcyBvbiAxNjgyLi4KPgo+IEFkZGl0
aW9uYWxseSwgSSBhbSBidWlsZGluZyBhIGJpc2VjdGVkIGtlcm5lbCBub3cgKAo+IGNiMjBkNTE4
ODM2NmYwNGQ5NmQyZTA3YjEyNDBjYzkyMTcwYWRlNDAgKSwgYnV0IHdvbid0IGJlIGFibGUgdG8g
Z2V0Cj4gYmFjayBhdCBpdCBmb3IgYSB3aGlsZS4KCmNiMjBkNTE4ODM2NmYwNGQ5NmQyZTA3YjEy
NDBjYzkyMTcwYWRlNDAgc2VlbXMgT0sgc28gZmFyLiBJJ20gZ29pbmcgdG8KdHJ5IDFkZTNlM2Rm
OTE3NDU5NDIyY2IyYWVjYWM0NDBmZWJjODg3OWQ0MTAgc29vbi4KCgotLSAKSm9uCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
