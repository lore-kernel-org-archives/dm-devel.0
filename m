From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/8] dm mpath: remove process_queued_ios()
Date: Wed, 05 Mar 2014 09:59:32 +0100
Message-ID: <5316E774.8060600@suse.de>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
	<1393598029-67995-5-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784010DC73B@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A49860784010DC73B@BPXM12GP.gisp.nec.co.jp>
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

T24gMDMvMDMvMjAxNCAxMjoxMiBBTSwgSnVuaWNoaSBOb211cmEgd3JvdGU6Cj4gT24gMDIvMjgv
MTQgMjM6MzMsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gQEAgLTEyMTQsOSArMTE4OSwxMiBA
QCBzdGF0aWMgdm9pZCBwZ19pbml0X2RvbmUodm9pZCAqZGF0YSwgaW50IGVycm9ycykKPj4gIAo+
PiAgCWlmICghbS0+cGdfaW5pdF9yZXF1aXJlZCkKPj4gIAkJbS0+cXVldWVfaW8gPSAwOwo+PiAt
Cj4+IC0JbS0+cGdfaW5pdF9kZWxheV9yZXRyeSA9IGRlbGF5X3JldHJ5Owo+PiAtCXF1ZXVlX3dv
cmsoa211bHRpcGF0aGQsICZtLT5wcm9jZXNzX3F1ZXVlZF9pb3MpOwo+PiArCWVsc2UgaWYgKG0t
PmN1cnJlbnRfcGcpIHsKPj4gKwkJbS0+cGdfaW5pdF9kZWxheV9yZXRyeSA9IGRlbGF5X3JldHJ5
Owo+PiArCQlpZiAoX19wZ19pbml0X2FsbF9wYXRocyhtKSkKPj4gKwkJCWdvdG8gb3V0Owo+PiAr
CQltLT5xdWV1ZV9pbyA9IDA7Cj4+ICsJfQo+IAo+IEhpIEhhbm5lcywKPiAKPiBJZiBtLT5wZ19p
bml0X3JlcXVpcmVkICYmICFtLT5jdXJyZW50X3BnLAo+IGRvZXNuJ3QgbS0+cXVldWVfaW8gcmVt
YWluIDEgd2hpbGUgbm9ib2R5IGtpY2tzIHBnX2luaXQ/Cj4gCj4gVGhhdCdzIHdoeSBJIHN1Z2dl
c3RlZCB0aGlzOgo+IAo+IAlpZiAobS0+cGdfaW5pdF9yZXF1aXJlZCkgewo+IAkJbS0+cGdfaW5p
dF9kZWxheV9yZXRyeSA9IGRlbGF5X3JldHJ5Owo+IAkJaWYgKF9fcGdfaW5pdF9hbGxfcGF0aHMo
bSkpCj4gCQkJZ290byBvdXQ7Cj4gCX0KPiAJbS0+cXVldWVfaW8gPSAwOwo+IApZZWFoLCBzb3Jy
eS4gWW91IGFyZSByaWdodC4KCk1pa2UsIGNhbiB5b3UgZml4IGl0IHVwIG9yIGRvIHlvdSBuZWVk
IGFuIGFkZGl0aW9uYWwgcm91bmQgb2YgcGF0Y2hlcz8KCkNoZWVycywKCkhhbm5lcwoKLS0gCkRy
LiBIYW5uZXMgUmVpbmVja2UJCSAgICAgIHpTZXJpZXMgJiBTdG9yYWdlCmhhcmVAc3VzZS5kZQkJ
CSAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggUHJvZHVjdHMgR21iSCwgTWF4ZmVs
ZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBKLiBIYXduLCBKLiBHdWlsZCwgRi4gSW1lbmTD
tnJmZmVyLCBIUkIgMTY3NDYgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbA==
