From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: push back requests instead of
	queueing
Date: Tue, 12 Nov 2013 11:17:43 +0100
Message-ID: <52820047.9090103@suse.de>
References: <1383901339-81536-1-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784F0A5F4@BPXM12GP.gisp.nec.co.jp>
	<5281E403.5020005@suse.de>
	<11AF7C027C4C02408624617A49860784F0A9D8@BPXM12GP.gisp.nec.co.jp>
	<5281EF56.8030808@suse.de>
	<11AF7C027C4C02408624617A49860784F0AE9C@BPXM12GP.gisp.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11AF7C027C4C02408624617A49860784F0AE9C@BPXM12GP.gisp.nec.co.jp>
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
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

T24gMTEvMTIvMjAxMyAxMTowMCBBTSwgSnVuaWNoaSBOb211cmEgd3JvdGU6Cj4gT24gMTEvMTIv
MTMgMTg6MDUsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKWyAuLiBdCj4+IFdlIF9jb3VsZF8gb3B0
aW1pemUgdGhpcyBpbiBfX3N3aXRjaF9wZygpLCB0byBjYWxsIHBncGF0aF9idXN5KCkKPj4gd2hl
biBzZWxlY3RpbmcgdGhlIHBhdGhzLiBCdXQgdGhhdCBzaG91bGQgYmUgZG9uZSBieSB0aGUgcGF0
aCBzZWxlY3Rvci4KPj4gU28gZm9yIHRoYXQgd2Ugd291bGQgbmVlZCB0byBzZXBhcmF0ZSB0aGUg
ZnVuY3Rpb25hbGl0eSBvZiB0aGUKPj4gcGF0aCBzZWxlY3RvciBhbmQgX19zd2l0Y2hfcGc7IGN1
cnJlbnRseSBpdCdzIHVuY2xlYXIgd2hldGhlcgo+PiB3ZSBuZWVkIHRvIGNhbGwgcGdwYXRoX2J1
c3koKSBpbiBfX3N3aXRjaF9wZyBvciBub3QuCj4gCj4gVGhlcmUgaXMgbm8gbmVlZCB0byBjYWxs
IHBncGF0aF9idXN5IGluIF9fc3dpdGNoX3BnLgo+IAo+IElmIHdlIGNhbGwgX19wZ3BhdGhfYnVz
eSgpIGluIG1hcCBmdW5jdGlvbiwgSSB0aGluayBpdCdzIGhlcmU6Cj4gCj4gCWlmIChwZ3BhdGgp
IHsKPiArIAkJaWYgKF9fcGdwYXRoX2J1c3kocGdwYXRoKSkKPiArIAkJCXIgPSBETV9NQVBJT19S
RVFVRVVFOwo+IAkJZWxzZSBpZiAocGdfcmVhZHkobSkpIHsKPiAJCQkuLi4gLy8gcmVtYXAKPiAJ
CQlyID0gRE1fTUFQSU9fUkVNQVBQRUQ7Cj4gCQl9IGVsc2Ugewo+IAkJCV9fcGdfaW5pdF9hbGxf
cGF0aHMobSk7Cj4gCQkJciA9IERNX01BUElPX1JFUVVFVUU7Cj4gCQl9Cj4gCS4uLgo+IApXaGlj
aCBpcyB3aGF0IEkgaGFkIGluIG1pbmQuCgo+IG9yIGluIGEgcGF0aCBzZWxlY3Rvci4KPiAKSG1t
LiBUaGUgcGF0aCBzZWxlY3RvciBtaWdodCBoYXZlIGEgcmVhc29uIGZvciBzZWxlY3RpbmcgdGhp
cwpwYXJ0aWN1bGFyIHBhdGguIFNvIEknZCBwcmVmZXIgbm90IHRvIGhhdmUgaXQgaW4gdGhlcmUu
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgIHpTZXJpZXMg
JiBTdG9yYWdlCmhhcmVAc3VzZS5kZQkJCSAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElO
VVggUHJvZHVjdHMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBKLiBI
YXduLCBKLiBHdWlsZCwgRi4gSW1lbmTDtnJmZmVyLCBIUkIgMTY3NDYgKEFHIE7DvHJuYmVyZykK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
