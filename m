From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re:
 dm-crypt barrier support is effective)
Date: Thu, 9 Dec 2010 12:10:58 -0600
Message-ID: <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8__49830.7590642527$1291918380$gmane$org@mail.gmail.com>
References: <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
	<AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
	<20101207142145.GA27861@think>
	<AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
	<20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
	<AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
	<20101209180111.GF2921@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101209180111.GF2921@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>, Mike Snitzer <snitzer@redhat.com>, Chris Mason <chris.mason@oracle.com>, Matt <jackdachef@gmail.com>
List-Id: dm-devel.ids

T24gVGh1LCBEZWMgOSwgMjAxMCBhdCAxMjowMSBQTSwgVGVkIFRzJ28gPHR5dHNvQG1pdC5lZHU+
IHdyb3RlOgo+IE9uIFR1ZSwgRGVjIDA3LCAyMDEwIGF0IDA5OjM3OjIwUE0gLTA2MDAsIEpvbiBO
ZWxzb24gd3JvdGU6Cj4+IE9uZSBkaWZmZXJlbmNlIGlzIHRoZSBsb2NhdGlvbiBvZiB0aGUgdHJh
bnNhY3Rpb24gbG9ncyAocGdfeGxvZykuIEluCj4+IG15IGNhc2UsIC92YXIvbGliL3Bnc3FsL2Rh
dGEgKmlzKiBtb3VudHBvaW50IGZvciB0aGUgdGVzdCB2b2x1bWUKPj4gKGFjdHVhbGx5LCBpdCdz
IGEgc3ltbGluayB0byB0aGUgbW91bnQgcG9pbnQpLiBJbiB5b3VyIGNhc2UsIHRoYXQgaXMKPj4g
bm90IHNvLiBQZXJoYXBzIHRoYXQgbWFrZXMgYSBkaWZmZXJlbmNlPyDCoHBnc3FsX3RtcCBtaWdo
dCBhbHNvIGJlIG9uCj4+IHR3byBkaWZmZXJlbnQgdm9sdW1lcyBpbiB5b3VyIGNhc2UgKEkgY2Fu
J3QgYmUgc3VyZSkuCj4KPiBJIGp1c3QgdHJpZWQgdHJpZWQgdG8gcnVuIHQuc3FsIGZpdmUgdGlt
ZXMgd2l0aCAvdmFyL2xpYi9wb3N0Z3JlcyBhcyBhCj4gbW91bnRwb2ludCBmb3IgYSA1NDAwIHJw
bSBkaXNrLCBhbmQgSSBzdGlsbCBoYXZlbid0IGJlZW4gYWJsZSB0bwo+IHJlcGxpY2F0ZSBpdC4K
CllvdSBzaG91bGQgYmUgT0ssIHRoZXJlLiBBcmUgeW91IHVzaW5nIGVuY3J5cHRpb24gb3Igbm8/
CkkgaGFkIGRpZmZpY3VsdHkgcmVwbGljYXRpbmcgdGhlIGlzc3VlIHdpdGhvdXQgZW5jcnlwdGlv
bi4KCj4gSWYgeW91IGNhbiBwb2ludCBvdXQgaG93IHRvIHF1ZXJ5IHBnc3FsX3RtcCAoSSdtIHVz
aW5nIGEgY29tcGxldGVseQo+IGRlZmF1bHQgcG9zdGdyZXMgaW5zdGFsbCksIHRoYXQgd291bGQg
YmUgaGVscGZ1bCwgYnV0IEkgZG9uJ3QgdGhpbmsgaXQKPiB3b3VsZCBiZSBnb2luZyBhbnl3aGVy
ZSBlbHNlLgoKTm9ybWFsbHkgaXQncyAvdmFyL2xpYi9wZ3NxbC9kYXRhL3Bnc3FsX3RtcCAob3IK
L3Zhci9saWIvcG9zdGdyZXMvZGF0YS9wZ3NxbF90bXAgaW4geW91ciBjYXNlKS4gQnkgcGxhY2lu
ZwovdmFyL2xpYi97cG9zdGdyZXNxbCxwZ3NxbH0vZGF0YSBvbiB0aGUgTFVLUyArIGV4dDQgdm9s
dW1lLCBvbiBib3RoCm9wZW5TVVNFIDExLjMgYW5kIEt1YnVudHUsIEkgd2FzIGFibGUgdG8gcmVw
bGljYXRlIHRoZSBwcm9ibGVtIGVhc2lseSwKaW4gVmlydHVhbEJveC4gSSBjYW4gZ2l2ZSBxZW11
IGEgdHJ5LiBJbiBib3RoIGNhc2VzIEkgd2FzIHVzaW5nIGEKMi42LjM3eCBrZXJuZWwuCgotLSAK
Sm9uCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
