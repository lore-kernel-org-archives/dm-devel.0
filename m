From: Sunwook Eom <speed.eom@samsung.com>
Subject: [PATCH] dm verity fec: fix hash block number in
	verity_fec_decode
Date: Fri, 10 Apr 2020 12:54:19 +0900
Message-ID: <b8de2c4b-d8cf-2bdb-f4cf-5b10faf48955@samsung.com>
References: <CGME20200410035424epcas1p2d47ca3a171af6a895af17d86e2838269@epcas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
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
To: Alasdair Kergon <agk@redhat.com>
Cc: mcneo.kang@samsung.com, device-mapper development <dm-devel@redhat.com>, sunwook5492@gmail.com, Sami Tolvanen <samitolvanen@google.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

VGhlIGVycm9yIGNvcnJlY3Rpb24gZGF0YSBpcyBjb21wdXRlZCBhcyBpZiBkYXRhIGFuZCBoYXNo
IGJsb2Nrcwp3ZXJlIGNvbmNhdGVuYXRlZC4gQnV0IGhhc2ggYmxvY2sgbnVtYmVyIGlzIHN0YXJ0
IGZyb20gdi0+aGFzaF9zdGFydC4KU28sIHdlIGhhdmUgdG8gY2FsY3VsYXRlIGhhc2ggYmxvY2sg
bnVtYmVyIGJhc2VkIG9uIHRoYXQuCgpGaXhlczogYTczOWZmM2Y1NDNhZiAoImRtIHZlcml0eTog
YWRkIHN1cHBvcnQgZm9yIGZvcndhcmQgZXJyb3IgY29ycmVjdGlvbiIpClNpZ25lZC1vZmYtYnk6
IFN1bndvb2sgRW9tIDxzcGVlZC5lb21Ac2Ftc3VuZy5jb20+Ci0tLQogwqBkcml2ZXJzL21kL2Rt
LXZlcml0eS1mZWMuYyB8IDIgKy0KIMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS12ZXJpdHktZmVjLmMgYi9k
cml2ZXJzL21kL2RtLXZlcml0eS1mZWMuYwppbmRleCA0OTE0N2U2MzQwNDYuLmZiNDFiNGYyM2M0
OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9kbS12ZXJpdHktZmVjLmMKKysrIGIvZHJpdmVycy9t
ZC9kbS12ZXJpdHktZmVjLmMKQEAgLTQzNSw3ICs0MzUsNyBAQCBpbnQgdmVyaXR5X2ZlY19kZWNv
ZGUoc3RydWN0IGRtX3Zlcml0eSAqdiwgc3RydWN0IApkbV92ZXJpdHlfaW8gKmlvLAogwqDCoMKg
wqAgZmlvLT5sZXZlbCsrOwoKIMKgwqDCoMKgIGlmICh0eXBlID09IERNX1ZFUklUWV9CTE9DS19U
WVBFX01FVEFEQVRBKQotwqDCoMKgIMKgwqDCoCBibG9jayArPSB2LT5kYXRhX2Jsb2NrczsKK8Kg
wqDCoCDCoMKgwqAgYmxvY2sgPSBibG9jayAtIHYtPmhhc2hfc3RhcnQgKyB2LT5kYXRhX2Jsb2Nr
czsKCiDCoMKgwqDCoCAvKgogwqDCoMKgwqAgwqAqIEZvciBSUyhNLCBOKSwgdGhlIGNvbnRpbnVv
dXMgRkVDIGRhdGEgaXMgZGl2aWRlZCBpbnRvIGJsb2NrcyBvZiBOCi0tIAoyLjE3LjEKCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
