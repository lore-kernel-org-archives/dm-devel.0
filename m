Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103E0C5517A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 06055222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06055222EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-RHyjXRKNM1-31lTan_nm1Q-1; Mon, 26 Oct 2020 03:20:33 -0400
X-MC-Unique: RHyjXRKNM1-31lTan_nm1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1D578049CF;
	Mon, 26 Oct 2020 07:20:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2EA95C1C5;
	Mon, 26 Oct 2020 07:20:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B5D11832FC6;
	Mon, 26 Oct 2020 07:20:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NHDx2p030363 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 13:13:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F293C85CB1; Fri, 23 Oct 2020 17:13:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC09C85CAD
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 17:13:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB2DF185A790
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 17:13:56 +0000 (UTC)
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch
	[83.166.143.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-475-2_-muI1mNDSQ1lQfJlAxew-1; Fri, 23 Oct 2020 13:13:54 -0400
X-MC-Unique: 2_-muI1mNDSQ1lQfJlAxew-1
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id
	4CHrFt53RpzlhypJ; Fri, 23 Oct 2020 19:05:22 +0200 (CEST)
Received: from localhost (unknown [94.23.54.103])
	by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id
	4CHrFt26Xvzlh8TG; Fri, 23 Oct 2020 19:05:22 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Fri, 23 Oct 2020 19:05:12 +0200
Message-Id: <20201023170512.201124-1-mic@digikod.net>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09NHDx2p030363
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: Deven Bowers <deven.desai@linux.microsoft.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
	dm-devel@redhat.com,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	linux-integrity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Milan Broz <gmazyland@gmail.com>,
	Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: [dm-devel] [PATCH v3] dm verity: Add support for signature
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
cm5lbC5vcmcvbGttbC8yMDIwMTAxNTE1MDUwNC4xMzE5MDk4LTEtbWljQGRpZ2lrb2QubmV0LwoK
Q2hhbmdlcyBzaW5jZSB2MjoKKiBBZGQgZG9jdW1lbnRhdGlvbiBhYm91dCB0aGUgYnVpbHRpbiBh
bmQgdGhlIHNlY29uZGFyeSB0cnVzdGVkIGtleXJpbmdzCiAgKHJlcXVlc3RlZCBieSBNaWtlIFNu
aXR6ZXIpLgoKQ2hhbmdlcyBzaW5jZSB2MToKKiBFeHRlbmQgdGhlIGNvbW1pdCBtZXNzYWdlIChh
c2tlZCBieSBKYXJra28gU2Fra2luZW4pLgoqIFJlbmFtZSB0aGUgS2NvbmZpZyAiaGVscCIga2V5
d29yZCBhY2NvcmRpbmcgdG8gY29tbWl0IDg0YWY3YTYxOTRlNAogICgiY2hlY2twYXRjaDoga2Nv
bmZpZzogcHJlZmVyICdoZWxwJyBvdmVyICctLS1oZWxwLS0tJyIpLgotLS0KIERvY3VtZW50YXRp
b24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci92ZXJpdHkucnN0IHwgIDcgKysrKysrLQogZHJp
dmVycy9tZC9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMyArKysr
KysrKysrKystCiBkcml2ZXJzL21kL2RtLXZlcml0eS12ZXJpZnktc2lnLmMgICAgICAgICAgICAg
ICAgICB8ICA5ICsrKysrKystLQogMyBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvZGV2
aWNlLW1hcHBlci92ZXJpdHkucnN0IGIvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9kZXZpY2Ut
bWFwcGVyL3Zlcml0eS5yc3QKaW5kZXggNjZmNzFmMGRhYjFiLi5iMDg4YTY0N2FjYjcgMTAwNjQ0
Ci0tLSBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci92ZXJpdHkucnN0
CisrKyBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci92ZXJpdHkucnN0
CkBAIC0xMzQsNyArMTM0LDEyIEBAIHJvb3RfaGFzaF9zaWdfa2V5X2Rlc2MgPGtleV9kZXNjcmlw
dGlvbj4KICAgICB0aGUgcGtjczcgc2lnbmF0dXJlIG9mIHRoZSByb290aGFzaC4gVGhlIHBrY3M3
IHNpZ25hdHVyZSBpcyB1c2VkIHRvIHZhbGlkYXRlCiAgICAgdGhlIHJvb3QgaGFzaCBkdXJpbmcg
dGhlIGNyZWF0aW9uIG9mIHRoZSBkZXZpY2UgbWFwcGVyIGJsb2NrIGRldmljZS4KICAgICBWZXJp
ZmljYXRpb24gb2Ygcm9vdGhhc2ggZGVwZW5kcyBvbiB0aGUgY29uZmlnIERNX1ZFUklUWV9WRVJJ
RllfUk9PVEhBU0hfU0lHCi0gICAgYmVpbmcgc2V0IGluIHRoZSBrZXJuZWwuCisgICAgYmVpbmcg
c2V0IGluIHRoZSBrZXJuZWwuICBUaGUgc2lnbmF0dXJlcyBhcmUgY2hlY2tlZCBhZ2FpbnN0IHRo
ZSBidWlsdGluCisgICAgdHJ1c3RlZCBrZXlyaW5nIGJ5IGRlZmF1bHQsIG9yIHRoZSBzZWNvbmRh
cnkgdHJ1c3RlZCBrZXlyaW5nIGlmCisgICAgRE1fVkVSSVRZX1ZFUklGWV9ST09USEFTSF9TSUdf
U0VDT05EQVJZX0tFWVJJTkcgaXMgc2V0LiAgVGhlIHNlY29uZGFyeQorICAgIHRydXN0ZWQga2V5
cmluZyBpbmNsdWRlcyBieSBkZWZhdWx0IHRoZSBidWlsdGluIHRydXN0ZWQga2V5cmluZywgYW5k
IGl0IGNhbgorICAgIGFsc28gZ2FpbiBuZXcgY2VydGlmaWNhdGVzIGF0IHJ1biB0aW1lIGlmIHRo
ZXkgYXJlIHNpZ25lZCBieSBhIGNlcnRpZmljYXRlCisgICAgYWxyZWFkeSBpbiB0aGUgc2Vjb25k
YXJ5IHRydXN0ZWQga2V5cmluZy4KIAogVGhlb3J5IG9mIG9wZXJhdGlvbgogPT09PT09PT09PT09
PT09PT09PQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9LY29uZmlnIGIvZHJpdmVycy9tZC9LY29u
ZmlnCmluZGV4IDMwYmEzNTczNjI2Yy4uMWQ2ODkzNWU0NWVmIDEwMDY0NAotLS0gYS9kcml2ZXJz
L21kL0tjb25maWcKKysrIGIvZHJpdmVycy9tZC9LY29uZmlnCkBAIC01MzAsMTEgKzUzMCwyMiBA
QCBjb25maWcgRE1fVkVSSVRZX1ZFUklGWV9ST09USEFTSF9TSUcKIAlib29sICJWZXJpdHkgZGF0
YSBkZXZpY2Ugcm9vdCBoYXNoIHNpZ25hdHVyZSB2ZXJpZmljYXRpb24gc3VwcG9ydCIKIAlkZXBl
bmRzIG9uIERNX1ZFUklUWQogCXNlbGVjdCBTWVNURU1fREFUQV9WRVJJRklDQVRJT04KLQkgIGhl
bHAKKwloZWxwCiAJICBBZGQgYWJpbGl0eSBmb3IgZG0tdmVyaXR5IGRldmljZSB0byBiZSB2YWxp
ZGF0ZWQgaWYgdGhlCiAJICBwcmUtZ2VuZXJhdGVkIHRyZWUgb2YgY3J5cHRvZ3JhcGhpYyBjaGVj
a3N1bXMgcGFzc2VkIGhhcyBhIHBrY3MjNwogCSAgc2lnbmF0dXJlIGZpbGUgdGhhdCBjYW4gdmFs
aWRhdGUgdGhlIHJvb3RoYXNoIG9mIHRoZSB0cmVlLgogCisJICBCeSBkZWZhdWx0LCByZWx5IG9u
IHRoZSBidWlsdGluIHRydXN0ZWQga2V5cmluZy4KKworCSAgSWYgdW5zdXJlLCBzYXkgTi4KKwor
Y29uZmlnIERNX1ZFUklUWV9WRVJJRllfUk9PVEhBU0hfU0lHX1NFQ09OREFSWV9LRVlSSU5HCisJ
Ym9vbCAiVmVyaXR5IGRhdGEgZGV2aWNlIHJvb3QgaGFzaCBzaWduYXR1cmUgdmVyaWZpY2F0aW9u
IHdpdGggc2Vjb25kYXJ5IGtleXJpbmciCisJZGVwZW5kcyBvbiBETV9WRVJJVFlfVkVSSUZZX1JP
T1RIQVNIX1NJRworCWRlcGVuZHMgb24gU0VDT05EQVJZX1RSVVNURURfS0VZUklORworCWhlbHAK
KwkgIFJlbHkgb24gdGhlIHNlY29uZGFyeSB0cnVzdGVkIGtleXJpbmcgdG8gdmVyaWZ5IGRtLXZl
cml0eSBzaWduYXR1cmVzLgorCiAJICBJZiB1bnN1cmUsIHNheSBOLgogCiBjb25maWcgRE1fVkVS
SVRZX0ZFQwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS12ZXJpdHktdmVyaWZ5LXNpZy5jIGIv
ZHJpdmVycy9tZC9kbS12ZXJpdHktdmVyaWZ5LXNpZy5jCmluZGV4IDYxNGU0M2RiOTNhYS4uMjkz
ODVkYzQ3MGQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2RtLXZlcml0eS12ZXJpZnktc2lnLmMK
KysrIGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdmVyaWZ5LXNpZy5jCkBAIC0xMTksOCArMTE5LDEz
IEBAIGludCB2ZXJpdHlfdmVyaWZ5X3Jvb3RfaGFzaChjb25zdCB2b2lkICpyb290X2hhc2gsIHNp
emVfdCByb290X2hhc2hfbGVuLAogCX0KIAogCXJldCA9IHZlcmlmeV9wa2NzN19zaWduYXR1cmUo
cm9vdF9oYXNoLCByb290X2hhc2hfbGVuLCBzaWdfZGF0YSwKLQkJCQlzaWdfbGVuLCBOVUxMLCBW
RVJJRllJTkdfVU5TUEVDSUZJRURfU0lHTkFUVVJFLAotCQkJCU5VTEwsIE5VTEwpOworCQkJCXNp
Z19sZW4sCisjaWZkZWYgQ09ORklHX0RNX1ZFUklUWV9WRVJJRllfUk9PVEhBU0hfU0lHX1NFQ09O
REFSWV9LRVlSSU5HCisJCQkJVkVSSUZZX1VTRV9TRUNPTkRBUllfS0VZUklORywKKyNlbHNlCisJ
CQkJTlVMTCwKKyNlbmRpZgorCQkJCVZFUklGWUlOR19VTlNQRUNJRklFRF9TSUdOQVRVUkUsIE5V
TEwsIE5VTEwpOwogCiAJcmV0dXJuIHJldDsKIH0KCmJhc2UtY29tbWl0OiBiYmY1Yzk3OTAxMWEw
OTlhZjVkYzc2NDk4OTE4ZWQ3ZGY0NDU2MzViCi0tIAoyLjI4LjAKCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

