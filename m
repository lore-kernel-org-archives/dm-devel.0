From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re:
 dm-crypt barrier support is effective)
Date: Fri, 10 Dec 2010 00:52:01 -0600
Message-ID: <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V__17212.3392731466$1291964060$gmane$org@mail.gmail.com>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101210023852.GB3059@thunk.org>
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

T24gVGh1LCBEZWMgOSwgMjAxMCBhdCA4OjM4IFBNLCBUZWQgVHMnbyA8dHl0c29AbWl0LmVkdT4g
d3JvdGU6Cj4gT24gRnJpLCBEZWMgMTAsIDIwMTAgYXQgMDI6NTM6MzBBTSArMDEwMCwgTWF0dCB3
cm90ZToKPj4KPj4gVHJ5IGEga2VybmVsIGJlZm9yZSA1YTg3YjdhNWRhMjUwYzliZTZkNzU3NzU4
NDI1ZGZlYWY4ZWQzMTc5Cj4+Cj4+IGZyb20gdGhlIHRlc3RzIEkndmUgZG9uZSB0aGF0IG9uZSBz
aG93ZWQgdGhlIGxlYXN0IG9yIG5vIGNvcnJ1cHRpb24gaWYKPj4geW91IGNvdW50IHRoZSBlbXB0
eSAvZXRjL2Vudi5kLzAzb3BlbmdsIGFzIGFuIGFydGVmYWN0Cj4KPiBZZXMsIHRoYXQncyBhIGdv
b2QgdGVzdC4gwqBBbHNvIHRyeSBjb21taXQgYmQyZDAyMTBjZi4gwqBUaGUgcGF0Y2gKPiBzZXJp
ZXMgdGhhdCBpcyBtb3N0IGxpa2VseSB0byBiZSBhdCBmYXVsdCBpZiB0aGVyZSBpcyBhIHJlZ3Jl
c3Npb24gaW4KPiBiZXR3ZWVuIDVhODdiN2E1ZCBhbmQgYmQyZDAyMTBjZiBpbmNsdXNpdmUuCj4K
PiBJIGRpZCBhIGxvdCBvZiB0ZXN0aW5nIGJlZm9yZSBzdWJtaXR0aW5nIGl0LCBidXQgdGhhdCB3
YSBhIHRyaWNreQo+IHJld3JpdGUuIMKgSWYgeW91IGNhbiByZXByb2R1Y2UgdGhlIHByb2JsZW0g
cmVsaWFibHksIGl0IG1pZ2h0IGJlIGdvb2QKPiB0byB0cnkgY29tbWl0IDE2ODI4MDg4ZjkgKHRo
ZSBjb21taXQgYmVmb3JlIDVhODdiN2E1ZCkgYW5kIGNvbW1pdAo+IGJkMmQwMjEwY2YuIMKgSWYg
aXQgcmVsaWFibHkgcmVwcm9kdWNlcyBvbiBiZDJkMDIxMGNmLCBidXQgaXMgY2xlYW4gb24KPiAx
NjgyODA4OGY5LCB0aGVuIGl0J3MgbXkgZXh0NCBibG9jayBpL28gc3VibWlzc2lvbiBwYXRjaGVz
LCBhbmQgd2UnbGwKPiBuZWVkIHRvIGVpdGhlciBmaWd1cmUgb3V0IHdoYXQncyBnb2luZyBvbiBv
ciBiYWNrIG91dCB0aGF0IHNldCBvZgo+IGNoYW5nZXMuCj4KPiBJZiB0aGF0J3MgdGhlIGNhc2Us
IGEgYmlzZWN0IG9mIHRob3NlIGNoYW5nZXMgKGl0J3Mgb25seSA2IGNvbW1pdHMsIHNvCj4gaXQg
c2hvdWxkbid0IHRha2UgbG9uZykgd291bGQgYmUgbW9zdCBhcHByZWNpYXRlZC4KCkkgb2JzZXJ2
ZWQgdGhlIGJlaGF2aW9yIG9uIGJkMmQwMjEwY2YgaW4gYSBxZW11LWt2bSBpbnN0YWxsIG9mCm9w
ZW5TVVNFIDExLjMgKHg4Nl82NCkgb24gKnRvdGFsbHkqIGRpZmZlcmVudCBob3N0IC0gYW4gQU1E
IHF1YWQtY29yZS4KCkkgZGlkIC9ub3QvIG9ic2VydmUgdGhlIGJlaGF2aW9yIG9uIDE2ODI4MDg4
ZjkgKHlldCkuIEknbGwgcnVuIHRoZQp0ZXN0IGEgZmV3IG1vcmUgdGltZXMgb24gMTY4Mi4uCgpB
ZGRpdGlvbmFsbHksIEkgYW0gYnVpbGRpbmcgYSBiaXNlY3RlZCBrZXJuZWwgbm93ICgKY2IyMGQ1
MTg4MzY2ZjA0ZDk2ZDJlMDdiMTI0MGNjOTIxNzBhZGU0MCApLCBidXQgd29uJ3QgYmUgYWJsZSB0
byBnZXQKYmFjayBhdCBpdCBmb3IgYSB3aGlsZS4KCkkgaG9wZSB0aGlzIGhlbHBzLgoKLS0gCkpv
bgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93
d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
