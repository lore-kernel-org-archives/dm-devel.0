From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] dm-multipath: reduce memory pressure
 during requeuing
Date: Mon, 20 Jan 2014 13:15:09 +0100
Message-ID: <52DD134D.10202@suse.de>
References: <1389955328-107148-1-git-send-email-hare@suse.de>
	<1389955328-107148-3-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A4986078401024EEB@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A4986078401024EEB@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

T24gMDEvMjAvMjAxNCAxMjo1OSBQTSwgSnVuaWNoaSBOb211cmEgd3JvdGU6Cj4gT24gMDEvMTcv
MTQgMTk6NDIsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gQEAgLTkwOCwxOSArOTEwLDkgQEAg
c3RhdGljIHZvaWQgbXVsdGlwYXRoX2R0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSkKPj4gIHN0YXRp
YyBpbnQgbXVsdGlwYXRoX21hcChzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IHJlcXVlc3Qg
KmNsb25lLAo+PiAgCQkJIHVuaW9uIG1hcF9pbmZvICptYXBfY29udGV4dCkKPj4gIHsKPj4gLQlp
bnQgcjsKPj4gIAlzdHJ1Y3QgbXVsdGlwYXRoICptID0gKHN0cnVjdCBtdWx0aXBhdGggKikgdGkt
PnByaXZhdGU7Cj4+ICAKPj4gLQlpZiAoc2V0X21hcGluZm8obSwgbWFwX2NvbnRleHQpIDwgMCkK
Pj4gLQkJLyogRU5PTUVNLCByZXF1ZXVlICovCj4+IC0JCXJldHVybiBETV9NQVBJT19SRVFVRVVF
Owo+PiAtCj4+IC0JY2xvbmUtPmNtZF9mbGFncyB8PSBSRVFfRkFJTEZBU1RfVFJBTlNQT1JUOwo+
PiAtCXIgPSBtYXBfaW8obSwgY2xvbmUsIG1hcF9jb250ZXh0KTsKPj4gLQlpZiAociA8IDAgfHwg
ciA9PSBETV9NQVBJT19SRVFVRVVFKQo+PiAtCQljbGVhcl9tYXBpbmZvKG0sIG1hcF9jb250ZXh0
KTsKPj4gLQo+PiAtCXJldHVybiByOwo+PiArCXJldHVybiBtYXBfaW8obSwgY2xvbmUsIG1hcF9j
b250ZXh0KTsKPj4gIH0KPiAKPiBOb3cgbXVsdGlwYXRoX21hcCgpIGlzIHRoZSBvbmx5IGNhbGxl
ciBvZiBtYXBfaW8oKSBhbmQKPiBtb3N0IHBhcnQgb2YgbXVsdGlwYXRoX21hcCgpIGlzIG1vdmVk
IHRvIG1hcF9pbygpLAo+IHRoZXJlIGlzIG5vIHJlYXNvbiB0byBzZXBhcmF0ZSB0aG9zZSBmdW5j
dGlvbnMuCj4gWW91IGNvdWxkIGZvbGQgbWFwX2lvKCkgaW50byBtdWx0aXBhdGhfbWFwKCkuCj4g
ClllcywgSSBjb3VsZC4KCkhvd2V2ZXIsIEkgZGlkbid0IGRvIHNvIChmb3IgdGhpcyBwYXRjaHNl
dCkKYXMgdGhpcyB3b3VsZCBtYWtlIHJldmlld2luZyBoYXJkZXIuCgpCdXQgeWVhaCwgaXQgc2hv
dWxkIGJlIG1lcmdlZC4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJ
ICAgICAgelNlcmllcyAmIFN0b3JhZ2UKaGFyZUBzdXNlLmRlCQkJICAgICAgKzQ5IDkxMSA3NDA1
MyA2ODgKU1VTRSBMSU5VWCBQcm9kdWN0cyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xy
bmJlcmcKR0Y6IEouIEhhd24sIEouIEd1aWxkLCBGLiBJbWVuZMO2cmZmZXIsIEhSQiAxNjc0NiAo
QUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
