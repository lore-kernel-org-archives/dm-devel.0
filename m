From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 1/3] explicitly include posix_types.h
Date: Wed,  9 Jan 2013 14:02:46 +0530
Message-ID: <1357720368-17664-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: christophe.varoqui@opensvc.com
Cc: Ritesh Raj Sarraf <rrs@debian.org>, dm-devel@redhat.com, =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
List-Id: dm-devel.ids

RnJvbTogR3VpZG8gR8O8bnRoZXIgPGFneEBzaWd4Y3B1Lm9yZz4KCnRvIGdldCB0aGUgY29ycmVj
dCB0eXBlIGZvciBfX2tlcm5lbF9vbGRfZGV2X3QKCkNsb3NlczogIzU1ODk5MAoKU2lnbmVkLW9m
Zi1ieTogUml0ZXNoIFJhaiBTYXJyYWYgPHJyc0BkZWJpYW4ub3JnPgpTaWduZWQtb2ZmLWJ5OiBH
dWlkbyBHdW50aGVyIDxhZ3hAc2lneGNwdS5vcmc+Ci0tLQoga3BhcnR4L2xvcGFydC5jIHwgICAx
MyArLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2twYXJ0eC9sb3BhcnQuYyBiL2twYXJ0eC9sb3BhcnQuYwpp
bmRleCA3OWQ4MzI4Li41NzBjOGFkIDEwMDY0NAotLS0gYS9rcGFydHgvbG9wYXJ0LmMKKysrIGIv
a3BhcnR4L2xvcGFydC5jCkBAIC0yNiwxOCArMjYsNyBAQAogI2luY2x1ZGUgPHN5cy9zdGF0Lmg+
CiAjaW5jbHVkZSA8c3lzL21tYW4uaD4KICNpbmNsdWRlIDxzeXNtYWNyb3MuaD4KLQotI2lmIGRl
ZmluZWQoX19ocHBhX18pIHx8IGRlZmluZWQoX19wb3dlcnBjNjRfXykgfHwgZGVmaW5lZCAoX19h
bHBoYV9fKSBcCi0gfHwgZGVmaW5lZCAoX194ODZfNjRfXykKLXR5cGVkZWYgdW5zaWduZWQgbG9u
ZyBfX2tlcm5lbF9vbGRfZGV2X3Q7Ci0jZWxpZiBkZWZpbmVkKF9fcG93ZXJwY19fKSB8fCBkZWZp
bmVkKF9faWE2NF9fKSB8fCAoZGVmaW5lZChfX3NwYXJjX18pICYmIGRlZmluZWQgKF9fYXJjaDY0
X18pKQotdHlwZWRlZiB1bnNpZ25lZCBpbnQgX19rZXJuZWxfb2xkX2Rldl90OwotI2Vsc2UKLXR5
cGVkZWYgdW5zaWduZWQgc2hvcnQgX19rZXJuZWxfb2xkX2Rldl90OwotI2VuZGlmCi0KLSNkZWZp
bmUgZGV2X3QgX19rZXJuZWxfb2xkX2Rldl90Ci0KKyNpbmNsdWRlIDxhc20vcG9zaXhfdHlwZXMu
aD4KICNpbmNsdWRlIDxsaW51eC9sb29wLmg+CiAKICNpbmNsdWRlICJsb3BhcnQuaCIKLS0gCjEu
Ny4xMC40CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
