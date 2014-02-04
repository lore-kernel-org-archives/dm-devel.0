From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/7] dm mpath: remove process_queued_ios()
Date: Tue, 04 Feb 2014 12:31:29 +0100
Message-ID: <52F0CF91.60302@suse.de>
References: <1391511280-29325-1-git-send-email-hare@suse.de>
	<1391511280-29325-5-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A498607840105F76A@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A498607840105F76A@BPXM12GP.gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

T24gMDIvMDQvMjAxNCAxMjoyNiBQTSwgSnVuaWNoaSBOb211cmEgd3JvdGU6Cj4gT24gMDIvMDQv
MTQgMTk6NTQsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gV2Ugb25seSBuZWVkIHRvIHRha2Ug
Y2FyZSB0byBhZGQgYSBzbWFsbCBkZWxheSB3aGVuIGNhbGxpbmcKPj4gX19wZ19pbml0X2FsbF9w
YXRocygpIHRvIG1vdmUgcHJvY2Vzc2luZyBvZmYgdG8gYSB3b3JrcXVldWU7IG90aGVyd2lzZQo+
PiBwZ19pbml0X2RvbmUoKSBtaWdodCBlbmQgdXAgY2FsbGluZyBzY3NpX2RoX2FjdGl2YXRlKCkg
ZGlyZWN0bHksIHdoaWNoCj4+IG1pZ2h0IHVzZSBub24tYXRvbWljIG1lbW9yeSBhbGxvY2F0aW9u
cyBvciBpc3N1ZSBJL08uCj4gCj4gSGkgSGFubmVzLAo+IAo+IGNvdWxkIHlvdSB0ZWxsIG1lIGhv
dyAibWlnaHQgZW5kIHVwIGNhbGxpbmcgc2NzaV9kaF9hY3RpdmUoKSIgaGFwcGVucz8KPiAKPiAg
IHF1ZXVlX2RlbGF5ZWRfd29yaygpCj4gICAgIHF1ZXVlX2RlbGF5ZWRfd29ya19vbigpCj4gICAg
ICAgX19xdWV1ZV9kZWxheWVkX3dvcmsoKQo+ICAgICAgICAgaWYgKCFkZWxheSkKPiAgICAgICAg
ICAgX19xdWV1ZV93b3JrKCkKPiAgICAgICAgICAgICBnZXRfd29ya19wb29sKCkKPiAgICAgICAg
ICAgICBpbnNlcnRfd29yaygpCj4gICAgICAgICAgICAgICBzZXRfd29ya19wd3EoKQo+ICAgICAg
ICAgICAgICAgZ2V0X3B3cSgpCj4gICAgICAgICAgICAgICBpZiAoX19uZWVkX21vcmVfd29ya2Vy
KCkpCj4gICAgICAgICAgICAgICAgIHdha2VfdXBfd29ya2VyKCkKPiAKPiBxdWV1ZV93b3JrKCkg
ZG9lc24ndCBleGVjdXRlIHRoZSB3b3JrIGl0c2VsZi4KPiAKPiBXaGF0IGFtIEkgbWlzc2luZz8K
PiAKQXMgbWVudGlvbmVkLCBJIHN0dW1ibGVkIGFjcm9zcyB0aGUgc2FtZSBpc3N1ZSB3aGVuIGRl
dmVsb3BpbmcgdGhlCmFzeW5jaHJvbm91cyBTQ1NJIGFib3J0cy4gSSdsbCBzZWUgdG8gaGF2ZSBp
dCByZWNyZWF0ZWQgd2l0aCB0aGlzCnBhdGNoc2V0LgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4g
SGFubmVzIFJlaW5lY2tlCQkgICAgICB6U2VyaWVzICYgU3RvcmFnZQpoYXJlQHN1c2UuZGUJCQkg
ICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJTlVYIFByb2R1Y3RzIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogSi4gSGF3biwgSi4gR3VpbGQsIEYuIEltZW5kw7Zy
ZmZlciwgSFJCIDE2NzQ2IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=
