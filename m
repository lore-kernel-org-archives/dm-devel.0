From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/14] dm-zoned: add 'status' and 'message'
	callbacks
Date: Fri, 8 May 2020 20:25:07 +0200
Message-ID: <9dee23c7-76ed-d80b-bfe2-9d2930488316@suse.de>
References: <20200508090332.40716-1-hare@suse.de>
	<20200508090332.40716-2-hare@suse.de>
	<20200508162955.GA18662@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200508162955.GA18662@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

T24gNS84LzIwIDY6MjkgUE0sIE1pa2UgU25pdHplciB3cm90ZToKPiBPbiBGcmksIE1heSAwOCAy
MDIwIGF0ICA1OjAzYW0gLTA0MDAsCj4gSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+IHdy
b3RlOgo+IAo+PiBBZGQgY2FsbGJhY2tzIHRvIHN1cHBseSBpbmZvcm1hdGlvbiBmb3IgJ2Rtc2V0
dXAgc3RhdHVzJwo+PiBhbmQgJ2Rtc2V0dXAgaW5mbycsIGFuZCBpbXBsZW1lbnQgdGhlIG1lc3Nh
Z2UgJ3JlY2xhaW0nCj4+IHRvIHN0YXJ0IHRoZSByZWNsYWltIHdvcmtlci4KPiAKPiBTYW1lIGZl
ZWRiYWNrIGZyb20gYmVmb3JlOgo+IGh0dHBzOi8vd3d3LnJlZGhhdC5jb20vYXJjaGl2ZXMvZG0t
ZGV2ZWwvMjAyMC1NYXJjaC9tc2cwMDE4OS5odG1sCj4gCj4gV2hvL1doYXQgd2lsbCB1c2UgdGhl
ICdyZWNsYWltJyBtZXNzYWdlPyAgU2hvdWxkbid0IGl0IGJlIGRvY3VtZW50ZWQ/Cj4gVGhpbmsg
dGhlIGRtel9zdGF0dXMgY2hhbmdlcyBzaG91bGQgYmUgc3BsaXQgb3V0IGZyb20gdGhpcyByZWNs
YWltCj4gbWVzc2FnZT8KPiAKJ3JlY2xhaW0nIG1lYW5zIHRoYXQgZG0tem9uZWQgc2hvdWxkIHN0
YXJ0IG1vdmluZyB6b25lcyBmcm9tIHRoZSByYW5kb20gCnpvbmVzIHRvIHRoZSBzZXF1ZW50aWFs
IHpvbmVzIHRvIGZyZWUgdXAgbW9yZSByYW5kb20gem9uZXMuClRoZXJlJ3MgYSB0aHJlc2hvbGQg
YWZ0ZXIgd2hpY2ggaXQnbGwgc3RhcnQgYXV0b21hdGljYWxseSwgYnV0IHRoaXMgCmFsbG93cyB5
b3UgdG8gc3RhcnQgcmVjbGFpbSBldmVuIGlmIHRoZSB0aHJlc2hvbGQgaXNuJ3QgcmVhY2hlZC4K
WW91IG1pZ2h0IGJlIHJpZ2h0LCBpdCBzaG91bGQgYmUgZG9jdW1lbnRlZC4KKFdoZXJlPyBJbiB0
aGUgY29kZT8pCgpBcyBmb3Igc3BsaXR0aW5nIHRoaW5ncyBvZmY7IHllYWgsIEkgY291bGQ7IG1h
eWJlIEkgc2hvdWxkIGlmIHRoZSAKJ3JlY2xhaW0nIG1lc3NhZ2UgdHVybnMgb3V0IHRvIGJlIGNv
bnRyb3ZlcnNpYWwuLi4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAg
ICAgICAgICAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJl
IFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5
IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
