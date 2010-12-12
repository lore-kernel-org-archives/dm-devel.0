From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re:
 dm-crypt barrier support is effective)
Date: Sun, 12 Dec 2010 07:11:28 -0600
Message-ID: <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=__17214.7245299586$1292159617$gmane$org@mail.gmail.com>
References: <1291945065-sup-1838@think>
	<AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
	<20101210023852.GB3059@thunk.org>
	<AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
	<AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
	<AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
	<AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
	<20101212023415.GG3059@thunk.org>
	<AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
	<AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
	<20101212124354.GA4513@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101212124354.GA4513@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>, Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>, Andi Kleen <andi@firstfloor.org>, Mike
List-Id: dm-devel.ids

T24gU3VuLCBEZWMgMTIsIDIwMTAgYXQgNjo0MyBBTSwgVGVkIFRzJ28gPHR5dHNvQG1pdC5lZHU+
IHdyb3RlOgo+IE9uIFN1biwgRGVjIDEyLCAyMDEwIGF0IDA0OjE4OjI5QU0gLTA2MDAsIEpvbiBO
ZWxzb24gd3JvdGU6Cj4+ID4gSSBoYXZlIG9uZSBDUFUgY29uZmlndXJlZCBpbiB0aGUgZW52aXJv
bm1lbnQsIDUxMk1CIG9mIG1lbW9yeS4KPj4gPiBJIGhhdmUgbm90IGRvbmUgYW55IG1lbW9yeS1j
b25zdHJpY3Rpb24gdGVzdHMgd2hhdHNvZXZlci4KPgo+IEkndmUgZmluYWxseSBiZWVuIGFibGUg
dG8gcmVwcm9kdWNlIGl0IG15c2VsZiwgb24gcmVhbCBoYXJkd2FyZS4gwqBTTVAKPiBpcyBub3Qg
bmVjZXNzYXJ5IHRvIHJlcHJvZHVjZSBpdCwgYWx0aG91Z2ggaGF2aW5nIG1vcmUgdGhhbiBvbmUg
Q1BVCj4gZG9lc24ndCBodXJ0LiDCoFdoYXQgSSBkaWQgbmVlZCB0byBkbyAob24gcmVhbCBoYXJk
d2FyZSB3aXRoIDQgZ2lncyBvZgo+IG1lbW9yeSkgd2FzIHRvIHR1cm4gb2ZmIHN3YXAgYW5kIHBp
biBlbm91Z2ggbWVtb3J5IHNvIHRoYXQgZnJlZSBtZW1vcnkKPiB3YXMgYXJvdW5kIDIwMG1lZ3Mg
b3Igc28gYmVmb3JlIHRoZSBzdGFydCBvZiB0aGUgdGVzdC4gwqAoVGhpcyBpcyB0aGUKPiBuYXR1
cmFsIGFtb3VudCBvZiBmcmVlIG1lbW9yeSB0aGF0IHRoZSBzeXN0ZW0gd291bGQgdHJ5IHRvIHJl
YWNoLAo+IHNpbmNlIDIwMCBtZWdzIGlzIGFib3V0IDUlIG9mIDQgZ2lncy4pCj4KPiBUaGVuLCBk
dXJpbmcgdGhlIHRlc3QsIGZyZWUgbWVtb3J5IHdvdWxkIGRyb3AgdG8gNTAtNzAgbWVnYWJ5dGVz
LAo+IGZvcmNpbmcgd3JpdGViYWNrIHRvIHJ1biwgYW5kIHRoZW4gSSBjb3VsZCB0cmlnZ2VyIGl0
IGFib3V0IDEtMiB0aW1lcwo+IG91dCBvZiB0aHJlZS4KPgo+IEknbSBndWVzc2luZyB0aGF0IHdo
ZW4geW91IHVzZWQgNTEybWIgb2YgbWVtb3J5LCB0aGF0IHdhcyBpbiBlZmZlY3QgYQo+IG1lbW9y
eS1jb25zdHJpY3Rpb24gdGVzdCwgYW5kIGlmIHlvdSB3ZXJlIHRvIHB1c2ggdGhlIG1lbW9yeSBk
b3duIGEKPiBsaXR0bGUgZnVydGhlciwgaXQgbWlnaHQgcmVwcm9kdWNlIGV2ZW4gbW9yZSBxdWlj
a2x5LiDCoE15IG5leHQgc3RlcCBpcwo+IHRvIHRyeSB0byByZXByb2R1Y2UgdGhpcyBpbiBhIFZN
LCBhbmQgdGhlbiBJIGNhbiBzdGFydCBwcm9iaW5nIHRvIHNlZQo+IHdoYXQgbWlnaHQgYmUgZ29p
bmcgb24uCgpJJ20gZ2xhZCB5b3UndmUgYmVlbiBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgcHJvYmxl
bSEgSWYgeW91IHNob3VsZCBuZWVkCmFueSBmdXJ0aGVyIGFzc2lzdGFuY2UsIHBsZWFzZSBkbyBu
b3QgaGVzaXRhdGUgdG8gYXNrLgoKCi0tIApKb24KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbA==
