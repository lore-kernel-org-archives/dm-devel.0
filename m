From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/6] libmpathpersist: fix byte swapping for
 big endian systems
Date: Sat, 23 Jun 2018 01:27:04 +0200
Message-ID: <9345b1022e97ad380fc24b24fb4d5ec7bd498b6c.camel@suse.com>
References: <20180622231516.18806-1-mwilck@suse.com>
	<20180622231516.18806-4-mwilck@suse.com>
	<ea8fc535-4602-b326-73c8-7e0b18243181@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ea8fc535-4602-b326-73c8-7e0b18243181@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Eli Qiao <taget@linux.vnet.ibm.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTA2LTIyIGF0IDE2OjE5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gT24gMDYvMjIvMTggMTY6MTYsIE1hcnRpbiBXaWxjayB3cm90ZToKPiA+IC0JCQlzYV9rZXkg
PSAwOwo+ID4gLQkJCWZvciAoaSA9IDA7IGkgPCA4OyArK2kpewo+ID4gLQkJCQlpZiAoaSA+IDAp
Cj4gPiAtCQkJCQlzYV9rZXkgPDw9IDg7Cj4gPiAtCQkJCXNhX2tleSB8PSBwYXJhbXAtPnNhX2tl
eVtpXTsKPiA+IC0JCQl9Cj4gPiArCQkJc2Ffa2V5ID0gYmU2NF90b19jcHUoKih1aW50NjRfdCAq
KSZwYXJhbXAtCj4gPiA+c2Ffa2V5WzBdKTsKPiAKPiBIYXZlIHlvdSBjb25zaWRlcmVkIHRvIHVz
ZSBnZXRfdW5hbGlnbmVkX2JlNjQoKSBpbnN0ZWFkIG9mIHRoZSBhYm92ZSAKPiBjb25zdHJ1Y3Qg
d2l0aCBjYXN0cz8KClllcywgSSBkaWQuIEkgb3B0ZWQgZm9yIHRoaXMgY29uc3RydWN0IGZvciBw
YXRjaCBicmV2aXR5IChhbmQKYWRtaXR0ZWRseSwgbGF6eW5lc3MpLCBiZWNhdXNlIGdldF91bmFs
aWduZWRfYmU2NCgpIGRvZXNuJ3QgZXhpc3QgeWV0LgpJIGNhbiBjaGFuZ2UgdGhhdCBvZiBjb3Vy
c2UgaWYgeW91IGluc2lzdC4KClRoYW5rcywKTWFydGluCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8
bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBH
bWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9u
CkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs
