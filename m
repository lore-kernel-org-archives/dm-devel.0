From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 1/3] explicitly include posix_types.h
Date: Wed,  9 Jan 2013 15:35:54 +0530
Message-ID: <1357725956-24346-2-git-send-email-rrs@debian.org>
References: <1357725956-24346-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357725956-24346-1-git-send-email-rrs@debian.org>
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
Zi1ieTogUml0ZXNoIFJhaiBTYXJyYWYgPHJyc0BkZWJpYW4ub3JnPgotLS0KIGtwYXJ0eC9sb3Bh
cnQuYyB8ICAgMTMgKy0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rcGFydHgvbG9wYXJ0LmMgYi9rcGFydHgv
bG9wYXJ0LmMKaW5kZXggNzlkODMyOC4uNTcwYzhhZCAxMDA2NDQKLS0tIGEva3BhcnR4L2xvcGFy
dC5jCisrKyBiL2twYXJ0eC9sb3BhcnQuYwpAQCAtMjYsMTggKzI2LDcgQEAKICNpbmNsdWRlIDxz
eXMvc3RhdC5oPgogI2luY2x1ZGUgPHN5cy9tbWFuLmg+CiAjaW5jbHVkZSA8c3lzbWFjcm9zLmg+
Ci0KLSNpZiBkZWZpbmVkKF9faHBwYV9fKSB8fCBkZWZpbmVkKF9fcG93ZXJwYzY0X18pIHx8IGRl
ZmluZWQgKF9fYWxwaGFfXykgXAotIHx8IGRlZmluZWQgKF9feDg2XzY0X18pCi10eXBlZGVmIHVu
c2lnbmVkIGxvbmcgX19rZXJuZWxfb2xkX2Rldl90OwotI2VsaWYgZGVmaW5lZChfX3Bvd2VycGNf
XykgfHwgZGVmaW5lZChfX2lhNjRfXykgfHwgKGRlZmluZWQoX19zcGFyY19fKSAmJiBkZWZpbmVk
IChfX2FyY2g2NF9fKSkKLXR5cGVkZWYgdW5zaWduZWQgaW50IF9fa2VybmVsX29sZF9kZXZfdDsK
LSNlbHNlCi10eXBlZGVmIHVuc2lnbmVkIHNob3J0IF9fa2VybmVsX29sZF9kZXZfdDsKLSNlbmRp
ZgotCi0jZGVmaW5lIGRldl90IF9fa2VybmVsX29sZF9kZXZfdAotCisjaW5jbHVkZSA8YXNtL3Bv
c2l4X3R5cGVzLmg+CiAjaW5jbHVkZSA8bGludXgvbG9vcC5oPgogCiAjaW5jbHVkZSAibG9wYXJ0
LmgiCi0tIAoxLjcuMTAuNAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
