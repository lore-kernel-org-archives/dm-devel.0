From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: add <sys/types.h> to
	libmultipath/util.h
Date: Thu,  4 Aug 2016 20:24:31 +0200
Message-ID: <1470335072-13867-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

UmVxdWlyZSBieSBtdXNsIGxpYmM6CkluIGZpbGUgaW5jbHVkZWQgZnJvbSBwZ3BvbGljaWVzLmM6
OTowOgp1dGlsLmg6MTE6MTogZXJyb3I6IHVua25vd24gdHlwZSBuYW1lIOKAmGRldl904oCZCiBk
ZXZfdCBwYXJzZV9kZXZ0KGNvbnN0IGNoYXIgKmRldl90KTsKCkNjOiBDaHJpc3RvcGhlIFZhcm9x
dWkgPGNocmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNvbT4KQ2M6IGRldmljZS1tYXBwZXIgZGV2
ZWxvcG1lbnQgPGRtLWRldmVsQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVl
eiBQZXJleiA8eG9zZS52YXpxdWV6QGdtYWlsLmNvbT4KLS0tCiBsaWJtdWx0aXBhdGgvdXRpbC5o
IHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2xp
Ym11bHRpcGF0aC91dGlsLmggYi9saWJtdWx0aXBhdGgvdXRpbC5oCmluZGV4IDI1NzkxMmMuLjg4
NjEwODUgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC91dGlsLmgKKysrIGIvbGlibXVsdGlwYXRo
L3V0aWwuaApAQCAtMSw2ICsxLDggQEAKICNpZm5kZWYgX1VUSUxfSAogI2RlZmluZSBfVVRJTF9I
CiAKKyNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KKwogc2l6ZV90IHN0cmNob3AoY2hhciAqKTsKIGlu
dCBiYXNlbmFtZWNweSAoY29uc3QgY2hhciAqIHNyYywgY2hhciAqIGRzdCwgaW50KTsKIGludCBm
aWxlcHJlc2VudCAoY2hhciAqIHJ1bik7Ci0tIAoyLjcuNAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs
