From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the select
 or poll function
Date: Thu, 11 May 2017 21:49:14 +0200
Message-ID: <1494532154.6093.30.camel@suse.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com> <1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com>
	<01517603-ba44-bc02-8b70-96feef8050ed@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <01517603-ba44-bc02-8b70-96feef8050ed@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Andy Grover <agrover@redhat.com>
Cc: mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

T24gVGh1LCAyMDE3LTA1LTExIGF0IDExOjEwIC0wNzAwLCBBbmR5IEdyb3ZlciB3cm90ZToKPiAK
PiBJIHRoaW5rIGdldHRpbmcgb25lIHJlYWRpbmVzcyBub3RpZmljYXRpb24gZm9yIG11bHRpcGxl
IGV2ZW50cyBzaG91bGQKPiBiZSBvay4KPiAKPiBCdXQsIHRoZSBzZW1hbnRpY3Mgb2YgcG9sbCgy
KSBhcmUgbGV2ZWwtdHJpZ2dlcmVkLCBtZWFuaW5nIGlmIGEgZmQKPiBpc8KgCj4gcmVhZHkgdGhl
biBpdCB3aWxsIHN0YXkgcmVhZHkgdGhyb3VnaCBtdWx0aXBsZSBpbnZvY2F0aW9ucyBvZiBwb2xs
KCnCoAo+IHVudGlsIHNvbWV0aGluZyBpcyBkb25lIHRvIHNhdGlzZnkgaXQgKGUuZy4gZm9yIGEg
VENQIHNvY2tldCwKPiByZWFkKClpbmfCoAo+IGFsbCB0aGUgYXZhaWxhYmxlIGRhdGEpLiBUaGVy
ZWZvcmUgd2UgY2FuJ3QgbWFrZSBpdCAiZWRnZS10cmlnZ2VyZWQiCj4gYnnCoAo+IGF1dG8tY2xl
YXJpbmcgLSBpdCBoYXMgdG8gYmUgYSBzZXBhcmF0ZSBhY3Rpb24uCgpIbSwgcGVyaGFwcy4KCkhl
cmUgaXMgYW4gaWRlYTogdGhlIGJlc3Qgd2F5IHRvIGF2b2lkIHRoZSByYWNlIG1lbnRpb25lZCBi
eSBNaWtlIG1pZ2h0CmJlIHRvIHNldCBwcml2LT5nbG9iYWxfZXZlbnRfbnIgdG8gdGhlIGhpZ2hl
c3QgZXZlbnQgbnIgcmVwb3J0ZWQgYnkgdGhlCkRNX0xJU1RfREVWSUNFUyBpb2N0bCB3aGVuIHRo
aXMgaW9jdGwgcmV0dXJucy4gRE1fTElTVF9ERVZJQ0VTIHdvdWxkCnRoZW4gcmVwcmVzZW50IHlv
dXIgInNlcGFyYXRlIGFjdGlvbiIsIHdoaWNoIHdvdWxkIGZpdCBxdWl0ZSB3ZWxsLCBhbmQKdGhl
IERNX0RFVl9BUk1fUE9MTCBpb2N0bCB3b3VsZG4ndCBiZSBuZWVkZWQuIEl0IHdvdWxkIGJlIGd1
YXJhbnRlZWQKdGhhdCBpZiBhbnkgZXZlbnQgaGFkIG9jY3VyZWQgYWZ0ZXIgdGhlIHByZXZpb3Vz
IERNX0xJU1RfREVWSUNFUywKd2hldGhlciBvciBub3QgdGhhdCBoYWQgYmVlbiBiZWZvcmUgb3Ig
YWZ0ZXIgdGhlIHBvbGwoKSBjYWxsLCB1c2Vyc3BhY2UKd291bGQgbm90aWNlLgoKQ2hlZXJzLApN
YXJ0aW4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuwqArNDkg
KDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVy
LCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
