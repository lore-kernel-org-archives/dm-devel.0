From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 7/8] dm ioctl: Fix compilation warning
Date: Wed, 15 Jul 2020 18:52:16 +0900
Message-ID: <20200715095217.441885-8-damien.lemoal@wdc.com>
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

SW4gcmV0cmlldmVfc3RhdHVzKCksIHdoZW4gY29weWluZyB0aGUgdGFyZ2V0IHR5cGUgbmFtZSBp
biB0aGUKdGFyZ2V0X3R5cGUgc3RyaW5nIGZpZWxkIG9mIHN0cnVjdCBkbV90YXJnZXRfc3BlYywg
Y29weSBhdCBtb3N0CkRNX01BWF9UWVBFX05BTUUgLSAxIGNoYXJhY3RlciB0byBhdm9pZCB0aGUg
Y29tcGlsYXRpb24gd2FybmluZzoKCndhcm5pbmc6IOKAmF9fYnVpbHRpbl9zdHJuY3B54oCZIHNw
ZWNpZmllZCBib3VuZCAxNiBlcXVhbHMgZGVzdGluYXRpb24Kc2l6ZSBbLVdzdHJpbmdvcC10cnVu
Y2F0aW9uXQoKd2hlbiBjb21waWxpbmcgd2l0aCBXLTEuCgpTaWduZWQtb2ZmLWJ5OiBEYW1pZW4g
TGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPgotLS0KIGRyaXZlcnMvbWQvZG0taW9jdGwu
YyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0taW9jdGwuYyBiL2RyaXZlcnMvbWQvZG0taW9jdGwu
YwppbmRleCA0ODk5MzVkNWYyMmQuLjU3OTI4NzhkYmZmNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZC9kbS1pb2N0bC5jCisrKyBiL2RyaXZlcnMvbWQvZG0taW9jdGwuYwpAQCAtMTE2OCw3ICsxMTY4
LDcgQEAgc3RhdGljIHZvaWQgcmV0cmlldmVfc3RhdHVzKHN0cnVjdCBkbV90YWJsZSAqdGFibGUs
CiAJCXNwZWMtPnNlY3Rvcl9zdGFydCA9IHRpLT5iZWdpbjsKIAkJc3BlYy0+bGVuZ3RoID0gdGkt
PmxlbjsKIAkJc3RybmNweShzcGVjLT50YXJnZXRfdHlwZSwgdGktPnR5cGUtPm5hbWUsCi0JCQlz
aXplb2Yoc3BlYy0+dGFyZ2V0X3R5cGUpKTsKKwkJCXNpemVvZihzcGVjLT50YXJnZXRfdHlwZSkg
LSAxKTsKIAogCQlvdXRwdHIgKz0gc2l6ZW9mKHN0cnVjdCBkbV90YXJnZXRfc3BlYyk7CiAJCXJl
bWFpbmluZyA9IGxlbiAtIChvdXRwdHIgLSBvdXRidWYpOwotLSAKMi4yNi4yCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
