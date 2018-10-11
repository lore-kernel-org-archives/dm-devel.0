From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/2] kpartx: fix new memory leak in
 dm_find_part
Date: Thu, 11 Oct 2018 23:51:30 +0200
Message-ID: <10b5dbe546f0c223954161b04d8b8835b31670ab.camel@suse.com>
References: <1539290628-16948-1-git-send-email-bmarzins@redhat.com>
	<1539290628-16948-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539290628-16948-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTEwLTExIGF0IDE1OjQzIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gV2hpbGUgY29tbWl0IDk2MGJiMjM4IGZpeGVkIG9uZSBtZW1vcnkgbGVhaywgaXQgY3Jl
YXRlZCBhbm90aGVyLgo+IAo+IEZpeGVzOiA5NjBiYjIzOCAoImtwYXJ0eDogRml4IG1lbW9yeSBs
ZWFrIG9mIHV1aWQgZm91bmQgYnkgY292ZXJpdHkiKQo+IFNpZ25lZC1vZmYtYnk6IEJlbmphbWlu
IE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4KClJldmlld2VkLWJ5OiBNYXJ0aW4gV2ls
Y2sgPG13aWxja0BzdXNlLmNvbT4KCj4gLS0tCj4gIGtwYXJ0eC9kZXZtYXBwZXIuYyB8IDEgKwo+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKPiAKPiBkaWZmIC0tZ2l0IGEva3BhcnR4
L2Rldm1hcHBlci5jIGIva3BhcnR4L2Rldm1hcHBlci5jCj4gaW5kZXggOGRiMWViNS4uM2FhNDk4
OCAxMDA2NDQKPiAtLS0gYS9rcGFydHgvZGV2bWFwcGVyLmMKPiArKysgYi9rcGFydHgvZGV2bWFw
cGVyLmMKPiBAQCAtNjkwLDYgKzY5MCw3IEBAIGludCBkbV9maW5kX3BhcnQoY29uc3QgY2hhciAq
cGFyZW50LCBjb25zdCBjaGFyCj4gKmRlbGltLCBpbnQgcGFydCwKPiAgCj4gIAlyID0gZG1fcmVu
YW1lKHRtcCwgbmFtZSk7Cj4gIAlpZiAociA9PSAxKSB7Cj4gKwkJZnJlZSh0bXApOwo+ICAJCSpw
YXJ0X3V1aWQgPSB1dWlkOwo+ICAJCXJldHVybiAxOwo+ICAJfQoKLS0gCkRyLiBNYXJ0aW4gV2ls
Y2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGlu
dXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5v
cnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=
