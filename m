Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89767C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 391DE20848
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 391DE20848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-RAojfltjM9KSyZuTOIOGkQ-1; Fri, 16 Oct 2020 06:20:46 -0400
X-MC-Unique: RAojfltjM9KSyZuTOIOGkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5764F1074663;
	Fri, 16 Oct 2020 10:20:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39A051002391;
	Fri, 16 Oct 2020 10:20:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 11FDC1800BB2;
	Fri, 16 Oct 2020 10:20:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09FFE0Wk014698 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Oct 2020 11:14:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 97F6116C2C4; Thu, 15 Oct 2020 15:14:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9328F16C2C1
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 15:13:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81529805C1E
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 15:13:57 +0000 (UTC)
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch
	[83.166.143.174]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-549-o12gDGAlOsW1kiWJO8u4OA-1; Thu, 15 Oct 2020 11:13:55 -0400
X-MC-Unique: o12gDGAlOsW1kiWJO8u4OA-1
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id
	4CBszX6q78zlhTrD; Thu, 15 Oct 2020 17:05:44 +0200 (CEST)
Received: from localhost (unknown [94.23.54.103])
	by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id
	4CBszX0rtzzlh8Tg; Thu, 15 Oct 2020 17:05:44 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Thu, 15 Oct 2020 17:05:04 +0200
Message-Id: <20201015150504.1319098-1-mic@digikod.net>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09FFE0Wk014698
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 16 Oct 2020 06:18:44 -0400
Cc: Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
	dm-devel@redhat.com,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	linux-integrity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Milan Broz <gmazyland@gmail.com>,
	Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: [dm-devel] [PATCH v2] dm verity: Add support for signature
	verification with 2nd keyring
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogTWlja2HDq2wgU2FsYcO8biA8bWljQGxpbnV4Lm1pY3Jvc29mdC5jb20+CgpBZGQgYSBu
ZXcgY29uZmlndXJhdGlvbiBETV9WRVJJVFlfVkVSSUZZX1JPT1RIQVNIX1NJR19TRUNPTkRBUllf
S0VZUklORwp0byBlbmFibGUgZG0tdmVyaXR5IHNpZ25hdHVyZXMgdG8gYmUgdmVyaWZpZWQgYWdh
aW5zdCB0aGUgc2Vjb25kYXJ5CnRydXN0ZWQga2V5cmluZy4gIEluc3RlYWQgb2YgcmVseWluZyBv
biB0aGUgYnVpbHRpbiB0cnVzdGVkIGtleXJpbmcKKHdpdGggaGFyZC1jb2RlZCBjZXJ0aWZpY2F0
ZXMpLCB0aGUgc2Vjb25kIHRydXN0ZWQga2V5cmluZyBjYW4gaW5jbHVkZQpjZXJ0aWZpY2F0ZSBh
dXRob3JpdGllcyBmcm9tIHRoZSBidWlsdGluIHRydXN0ZWQga2V5cmluZyBhbmQgY2hpbGQKY2Vy
dGlmaWNhdGVzIGxvYWRlZCBhdCBydW4gdGltZS4gIFVzaW5nIHRoZSBzZWNvbmRhcnkgdHJ1c3Rl
ZCBrZXlyaW5nCmVuYWJsZXMgdG8gdXNlIGRtLXZlcml0eSBkaXNrcyAoZS5nLiBsb29wIGRldmlj
ZXMpIHNpZ25lZCBieSBrZXlzIHdoaWNoCmRpZCBub3QgZXhpc3QgYXQga2VybmVsIGJ1aWxkIHRp
bWUsIGxldmVyYWdpbmcgdGhlIGNlcnRpZmljYXRlIGNoYWluIG9mCnRydXN0IG1vZGVsLiAgSW4g
cHJhY3RpY2UsIHRoaXMgbWFrZXMgaXQgcG9zc2libGUgdG8gdXBkYXRlIGNlcnRpZmljYXRlcwp3
aXRob3V0IGtlcm5lbCB1cGRhdGUgYW5kIHJlYm9vdCwgYWxpZ25pbmcgd2l0aCBtb2R1bGUgYW5k
IGtlcm5lbAooa2V4ZWMpIHNpZ25hdHVyZSB2ZXJpZmljYXRpb24gd2hpY2ggYWxyZWFkeSB1c2Ug
dGhlIHNlY29uZGFyeSB0cnVzdGVkCmtleXJpbmcuCgpDYzogQWxhc2RhaXIgS2VyZ29uIDxhZ2tA
cmVkaGF0LmNvbT4KQ2M6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+
CkNjOiBKYXJra28gU2Fra2luZW4gPGphcmtrby5zYWtraW5lbkBsaW51eC5pbnRlbC5jb20+CkNj
OiBKYXNrYXJhbiBLaHVyYW5hIDxqYXNrYXJhbmtodXJhbmFAbGludXgubWljcm9zb2Z0LmNvbT4K
Q2M6IE1pa2UgU25pdHplciA8c25pdHplckByZWRoYXQuY29tPgpDYzogTWlsYW4gQnJveiA8Z21h
enlsYW5kQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogTWlja2HDq2wgU2FsYcO8biA8bWljQGxp
bnV4Lm1pY3Jvc29mdC5jb20+Ci0tLQoKUHJldmlvdXMgdmVyc2lvbjoKaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC8yMDIwMTAwMjA3MTgwMi41MzUwMjMtMS1taWNAZGlnaWtvZC5uZXQvCgpD
aGFuZ2VzIHNpbmNlIHYxOgoqIEV4dGVuZCB0aGUgY29tbWl0IG1lc3NhZ2UgKGFza2VkIGJ5IEph
cmtrbyBTYWtraW5lbikuCiogUmVuYW1lIHRoZSBLY29uZmlnICJoZWxwIiBrZXl3b3JkIGFjY29y
ZGluZyB0byBjb21taXQgODRhZjdhNjE5NGU0CiAgKCJjaGVja3BhdGNoOiBrY29uZmlnOiBwcmVm
ZXIgJ2hlbHAnIG92ZXIgJy0tLWhlbHAtLS0nIikuCi0tLQogZHJpdmVycy9tZC9LY29uZmlnICAg
ICAgICAgICAgICAgIHwgMTMgKysrKysrKysrKysrLQogZHJpdmVycy9tZC9kbS12ZXJpdHktdmVy
aWZ5LXNpZy5jIHwgIDkgKysrKysrKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9LY29uZmlnIGIvZHJp
dmVycy9tZC9LY29uZmlnCmluZGV4IDMwYmEzNTczNjI2Yy4uMWQ2ODkzNWU0NWVmIDEwMDY0NAot
LS0gYS9kcml2ZXJzL21kL0tjb25maWcKKysrIGIvZHJpdmVycy9tZC9LY29uZmlnCkBAIC01MzAs
MTEgKzUzMCwyMiBAQCBjb25maWcgRE1fVkVSSVRZX1ZFUklGWV9ST09USEFTSF9TSUcKIAlib29s
ICJWZXJpdHkgZGF0YSBkZXZpY2Ugcm9vdCBoYXNoIHNpZ25hdHVyZSB2ZXJpZmljYXRpb24gc3Vw
cG9ydCIKIAlkZXBlbmRzIG9uIERNX1ZFUklUWQogCXNlbGVjdCBTWVNURU1fREFUQV9WRVJJRklD
QVRJT04KLQkgIGhlbHAKKwloZWxwCiAJICBBZGQgYWJpbGl0eSBmb3IgZG0tdmVyaXR5IGRldmlj
ZSB0byBiZSB2YWxpZGF0ZWQgaWYgdGhlCiAJICBwcmUtZ2VuZXJhdGVkIHRyZWUgb2YgY3J5cHRv
Z3JhcGhpYyBjaGVja3N1bXMgcGFzc2VkIGhhcyBhIHBrY3MjNwogCSAgc2lnbmF0dXJlIGZpbGUg
dGhhdCBjYW4gdmFsaWRhdGUgdGhlIHJvb3RoYXNoIG9mIHRoZSB0cmVlLgogCisJICBCeSBkZWZh
dWx0LCByZWx5IG9uIHRoZSBidWlsdGluIHRydXN0ZWQga2V5cmluZy4KKworCSAgSWYgdW5zdXJl
LCBzYXkgTi4KKworY29uZmlnIERNX1ZFUklUWV9WRVJJRllfUk9PVEhBU0hfU0lHX1NFQ09OREFS
WV9LRVlSSU5HCisJYm9vbCAiVmVyaXR5IGRhdGEgZGV2aWNlIHJvb3QgaGFzaCBzaWduYXR1cmUg
dmVyaWZpY2F0aW9uIHdpdGggc2Vjb25kYXJ5IGtleXJpbmciCisJZGVwZW5kcyBvbiBETV9WRVJJ
VFlfVkVSSUZZX1JPT1RIQVNIX1NJRworCWRlcGVuZHMgb24gU0VDT05EQVJZX1RSVVNURURfS0VZ
UklORworCWhlbHAKKwkgIFJlbHkgb24gdGhlIHNlY29uZGFyeSB0cnVzdGVkIGtleXJpbmcgdG8g
dmVyaWZ5IGRtLXZlcml0eSBzaWduYXR1cmVzLgorCiAJICBJZiB1bnN1cmUsIHNheSBOLgogCiBj
b25maWcgRE1fVkVSSVRZX0ZFQwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS12ZXJpdHktdmVy
aWZ5LXNpZy5jIGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdmVyaWZ5LXNpZy5jCmluZGV4IDYxNGU0
M2RiOTNhYS4uMjkzODVkYzQ3MGQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2RtLXZlcml0eS12
ZXJpZnktc2lnLmMKKysrIGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdmVyaWZ5LXNpZy5jCkBAIC0x
MTksOCArMTE5LDEzIEBAIGludCB2ZXJpdHlfdmVyaWZ5X3Jvb3RfaGFzaChjb25zdCB2b2lkICpy
b290X2hhc2gsIHNpemVfdCByb290X2hhc2hfbGVuLAogCX0KIAogCXJldCA9IHZlcmlmeV9wa2Nz
N19zaWduYXR1cmUocm9vdF9oYXNoLCByb290X2hhc2hfbGVuLCBzaWdfZGF0YSwKLQkJCQlzaWdf
bGVuLCBOVUxMLCBWRVJJRllJTkdfVU5TUEVDSUZJRURfU0lHTkFUVVJFLAotCQkJCU5VTEwsIE5V
TEwpOworCQkJCXNpZ19sZW4sCisjaWZkZWYgQ09ORklHX0RNX1ZFUklUWV9WRVJJRllfUk9PVEhB
U0hfU0lHX1NFQ09OREFSWV9LRVlSSU5HCisJCQkJVkVSSUZZX1VTRV9TRUNPTkRBUllfS0VZUklO
RywKKyNlbHNlCisJCQkJTlVMTCwKKyNlbmRpZgorCQkJCVZFUklGWUlOR19VTlNQRUNJRklFRF9T
SUdOQVRVUkUsIE5VTEwsIE5VTEwpOwogCiAJcmV0dXJuIHJldDsKIH0KCmJhc2UtY29tbWl0OiBi
YmY1Yzk3OTAxMWEwOTlhZjVkYzc2NDk4OTE4ZWQ3ZGY0NDU2MzViCi0tIAoyLjI4LjAKCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

