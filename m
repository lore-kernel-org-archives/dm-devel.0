From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0/2] patches to improve cluster raid1
	performance [V2]
Date: Fri, 18 Oct 2013 16:04:18 -0500
Message-ID: <543F88D8-6326-448A-B517-B480FF72D22E@redhat.com>
References: <cover.1380191501.git.dmzhang@suse.com>
	<7396AC8F-6B91-44AE-96C1-99C9000F8B4E@redhat.com>
	<52545E0E0200007B0003F696@soto.provo.novell.com>
	<66B8343F-84A1-4F8C-B41D-3204EF16651A@redhat.com>
	<525CE19B.6040703@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <525CE19B.6040703@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dongmao Zhang <dmzhang@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Ck9uIE9jdCAxNSwgMjAxMywgYXQgMTozMiBBTSwgRG9uZ21hbyBaaGFuZyB3cm90ZToKCj4g5LqO
IDIwMTPlubQxMOaciDEx5pelIDAwOjI5LCBCcmFzc293IEpvbmF0aGFuIOWGmemBkzoKPj4gUGVy
aGFwcyBhIGJldHRlciB0aGluZyB0byBkbyBpcyB0byBpbnRlZ3JhdGUgdGhlIG1hcmtzIChhbmQg
cG9zc2libHkKPj4gY2xlYXJzKSBpbnRvIHRoZSBmbHVzaCAtIERNX0lOVEVHUkFURURfRkxVU0gu
ICBUaGUgcGF5bG9hZCBmb3IgdGhlCj4+IERNX1VMT0dfRkxVU0ggZmx1c2ggY29tbXVuaWNhdGlv
biBpcyBlbXB0eS4gIEl0IHNlZW1zIHRvIG1lIG5vdyB0aGF0Cj4+IGl0IHdvdWxkIG1ha2UgbW9y
ZSBzZW5zZSB0byBtYWtlIHVzZSBvZiB0aGF0IGVtcHR5IHNwYWNlIGFuZCBmaWxsIGl0Cj4+IHdp
dGggbWFyay9jbGVhciByZXF1ZXN0cy4gIFdoYXQgZG8geW91IHRoaW5rPwo+PiAKPiAKPiBETV9J
TlRFR1JBVEVEX0ZMVVNIIGlzIGEgZ29vZCBpZGVhLiBJdCBqdXN0IHNpbXBsaWZ5IHRoZSBjb25m
dXNpb24gb2YKPiBETV9GTFVTSF9XSVRIX01BUksgdGhpbmcuIE15IHBsYW4gaXMgdG8gYWRkICht
YXJrIGFuZCBjbGVhcikgcGF5bG9hZCB0bwo+IGZsdXNoLiBJdCBpcyBsaWtlIHRoaXM6Cj4gCj4g
J1gnIG1lYW5zIHdlIGhhdmUgdGhpcyBraW5kIG9mIHJlcXVlc3QsIHdoaWxlICcwJyBtZWFucyBu
b25lLgo+IAo+IG1hcmsgcmVxdWVzdCA6ICAgICBYICAgICAgICAgICAgICAgWCAgICAgICAgICAg
ICAgIDAKPiAKPiBjbGVhciByZXF1ZXN0OiAgICAgWCAgICAgICAgICAgICAgIDAgICAgICAgICAg
ICAgICBYCj4gCj4gZmx1c2ggbWV0aG9kOiAgICBwYXlsb2FkX2ZsdXNoICAgcGF5bG9hZF9mbHVz
aCAgIGRlbGF5ZWQgZmx1c2guCj4gCj4gSWYgdGhlcmUgaXMgb25seSBjbGVhciByZXF1ZXN0cywg
d2UgY2FuIHNlbmQgdGhlIGNsZWFyIHJlcXVlc3QgZmlyc3QsIGFuZCBzZW5kIG5vcm1hbCBmbHVz
aCBsYXRlci4gIGhvdyBkbyB5b3UgbGlrZSB0aGlzIHN0cmF0ZWd5Pwo+IAo+IEFzIGZvciB0aGUg
dGVzdGluZywgSSBvbmx5IGhhdmUgb2NmczIgYXZhaWxhYmxlLihub3QgR0ZTMikuIEkgd2lsbAo+
IHRlc3Qgb24gdGhhdDsKCkFsbCBzb3VuZHMgZ29vZC4KCiBicmFzc293CgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
