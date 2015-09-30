From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Queuing of dm-raid1 resyncs to the same underlying
	block devices
Date: Wed, 30 Sep 2015 08:22:59 -0500
Message-ID: <64020C6E-98B1-4139-A88C-0EC65493CCF9@redhat.com>
References: <20150926154902.GA2964@alpha.arachsys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150926154902.GA2964@alpha.arachsys.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

SSBkb27igJl0IGJlbGlldmUgaXQgZG9lcy4gIGRtLXJhaWQgZG9lcyB1c2UgdGhlIHNhbWUgUkFJ
RCBrZXJuZWwgcGVyc29uYWxpdGllcyBhcyBNRCB0aG91Z2gsIHNvIEkgd291bGQgdGhpbmsgdGhh
dCBpdCBjb3VsZCBiZSBhZGRlZC4gIEnigJlsbCBjaGVjayB3aXRoIEhlaW56IGFuZCBzZWUgaWYg
aGUga25vd3MuCgogYnJhc3NvdwoKPiBPbiBTZXAgMjYsIDIwMTUsIGF0IDEwOjQ5IEFNLCBSaWNo
YXJkIERhdmllcyA8cmljaGFyZEBhcmFjaHN5cy5jb20+IHdyb3RlOgo+IAo+IEhpLAo+IAo+IERv
ZXMgZG0tcmFpZCBxdWV1ZSByZXN5bmNzIG9mIG11bHRpcGxlIGRtLXJhaWQxIGFycmF5cywgaWYg
dGhlIHVuZGVybHlpbmcKPiBibG9jayBkZXZpY2VzIGFyZSB0aGUgc2FtZT8KPiAKPiBMaW51eCBt
ZCBoYXMgdGhpcyBmZWF0dXJlLCBlLmcuOgo+IAo+ICMgY2F0IC9wcm9jL21kc3RhdAo+IFBlcnNv
bmFsaXRpZXMgOiBbbGluZWFyXSBbcmFpZDBdIFtyYWlkMV0gW3JhaWQxMF0gW3JhaWQ2XSBbcmFp
ZDVdIFtyYWlkNF0gW211bHRpcGF0aF0KPiBtZDEgOiBhY3RpdmUgcmFpZDEgc2RhMlsyXSBzZGIy
WzFdCj4gICAgICA5NDMyMDIyNDAgYmxvY2tzIFsyLzFdIFtfVV0KPiAgICAgIFs9PT09Pi4uLi4u
Li4uLi4uLi4uLi5dICByZWNvdmVyeSA9IDIxLjklICgyMDcxNjc3NDQvOTQzMjAyMjQwKQo+ICAg
ICAgZmluaXNoPTIwMjkwLjhtaW4gc3BlZWQ9NjAzSy9zZWMKPiAgICAgIGJpdG1hcDogMS84IHBh
Z2VzIFs0S0JdLCA2NTUzNktCIGNodW5rCj4gCj4gbWQwIDogYWN0aXZlIHJhaWQxIHNkYTFbMl0g
c2RiMVsxXQo+ICAgICAgNjcxMDg3MzYgYmxvY2tzIFsyLzFdIFtfVV0KPiAgICAgICAgcmVzeW5j
PURFTEFZRUQKPiAgICAgIGJpdG1hcDogMS8xIHBhZ2VzIFs0S0JdLCA2NTUzNktCIGNodW5rCj4g
Cj4gCj4gQWZ0ZXIgc29tZSB0aW1lIGludmVzdGlnYXRpbmcsIEkgY2FuJ3QgZmluZCBpdCBpbiBk
bS1yYWlkLgo+IAo+IFBsZWFzZSBjYW4gc29tZW9uZSB0ZWxsIG1lIGlmIHRoaXMgaXMgaW1wbGVt
ZW50ZWQgb3Igbm90Pwo+IAo+IElmIGl0IGlzIGltcGxlbWVudGVkLCB3aGVyZSBzaG91bGQgSSBs
b29rIHRvIHNlZSBpdCBoYXBwZW5pbmc/Cj4gCj4gVGhhbmtzLAo+IAo+IFJpY2hhcmQuCj4gCj4g
LS0KPiBkbS1kZXZlbCBtYWlsaW5nIGxpc3QKPiBkbS1kZXZlbEByZWRoYXQuY29tCj4gaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
