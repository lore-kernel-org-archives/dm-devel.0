From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/8] dm raid10: Fix compilation warning
Date: Wed, 15 Jul 2020 18:52:13 +0900
Message-ID: <20200715095217.441885-5-damien.lemoal@wdc.com>
References: <20200715095217.441885-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200715095217.441885-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

UmVtb3ZlIHRoZSBpZiBzdGF0ZW1lbnQgYXJvdW5kIHRoZSBjYWxsIHRvIHN5c2ZzX2xpbmtfcmRl
digpIGluCnJhaWQxMF9zdGFydF9yZXNoYXBlKCkgdG8gYXZvaWQgdGhlIGNvbXBpbGF0aW9uIHdh
cm5pbmc6Cgp3YXJuaW5nOiBzdWdnZXN0IGJyYWNlcyBhcm91bmQgZW1wdHkgYm9keSBpbiBhbiDi
gJhpZuKAmSBzdGF0ZW1lbnQKCndoZW4gY29tcGlsaW5nIHdpdGggVz0xLgoKU2lnbmVkLW9mZi1i
eTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4KLS0tCiBkcml2ZXJzL21k
L3JhaWQxMC5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEwLmMgYi9kcml2ZXJzL21k
L3JhaWQxMC5jCmluZGV4IGVjMTM2ZTQ0YWVmNy4uMDhmNjk3ZjNkZGM4IDEwMDY0NAotLS0gYS9k
cml2ZXJzL21kL3JhaWQxMC5jCisrKyBiL2RyaXZlcnMvbWQvcmFpZDEwLmMKQEAgLTQzMDcsOCAr
NDMwNyw4IEBAIHN0YXRpYyBpbnQgcmFpZDEwX3N0YXJ0X3Jlc2hhcGUoc3RydWN0IG1kZGV2ICpt
ZGRldikKIAkJCQkJZWxzZQogCQkJCQkJcmRldi0+cmVjb3Zlcnlfb2Zmc2V0ID0gMDsKIAotCQkJ
CQlpZiAoc3lzZnNfbGlua19yZGV2KG1kZGV2LCByZGV2KSkKLQkJCQkJCS8qIEZhaWx1cmUgaGVy
ZSAgaXMgT0sgKi87CisJCQkJCS8qIEZhaWx1cmUgaGVyZSBpcyBPSyAqLworCQkJCQlzeXNmc19s
aW5rX3JkZXYobWRkZXYsIHJkZXYpOwogCQkJCX0KIAkJCX0gZWxzZSBpZiAocmRldi0+cmFpZF9k
aXNrID49IGNvbmYtPnByZXYucmFpZF9kaXNrcwogCQkJCSAgICYmICF0ZXN0X2JpdChGYXVsdHks
ICZyZGV2LT5mbGFncykpIHsKLS0gCjIuMjYuMgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs
