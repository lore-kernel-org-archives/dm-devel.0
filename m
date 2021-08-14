Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EC3C4320E
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C94D660F5C
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C94D660F5C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-p5raOquoPe-iarO_Jm8ccQ-1; Tue, 17 Aug 2021 03:26:11 -0400
X-MC-Unique: p5raOquoPe-iarO_Jm8ccQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF7B51082932;
	Tue, 17 Aug 2021 07:26:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0277C19C46;
	Tue, 17 Aug 2021 07:26:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BA1AB181A0F8;
	Tue, 17 Aug 2021 07:26:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17EIYvkH016620 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 14 Aug 2021 14:34:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD95C63ABF; Sat, 14 Aug 2021 18:34:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8CA05F270
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B84580066D
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:53 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-106-AbBshpq2N62Q7csp6Dp6aQ-1; Sat, 14 Aug 2021 14:34:49 -0400
X-MC-Unique: AbBshpq2N62Q7csp6Dp6aQ-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1MsI4Q-1n4JvY1XQ2-00th0a; Sat, 14 Aug 2021 20:34:46 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Date: Sat, 14 Aug 2021 20:33:55 +0200
Message-Id: <20210814183359.4061-4-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:CtoNFbEPV+8vqd27K0MnUwjFtAOw4axb5mfVZuAB5lwMuU7vLD7
	LG+BqLl4mtMr28N9LOxMPgHZ4MK5i50M6Q9smlyXuQ2WsFal4LxZQBCw4T0xBSt0b4P5Sc2
	M1OskO1MB8QXSnNwbyXYLmM5yIOgRLt0q0wCOpum2mojGFMZCGWPZGzjc5jS6jTp3AbLWa8
	pqomu0QeuppvzAGyhozaQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+j3i/Gx0nXI=:lGogq2PrmQmbJOoU4JQ8Bu
	HAsUK52kNoePuQt8BO3ZSA8QRj7zItln8iyNRuHxl9s1EerAQPfRNEy3zfmfdwz+ls+o9O15W
	APi3zCwu8DV9izQv71XocknUUqtQ/Y/9c6BNRqZgSpgvEzVYFBPxzDYEuQpoUxkbIl0f65p7O
	glhJ6xZ6kMrL8I6bMtMRuEVke1BtBBmVtfP1afBTlcbsrGSA7n4U4oMuf3pbpX4AhKnT4JeV5
	k4FNlxcnoOZmPbdO7FH0I6vAGRxhB94k3xa3IBPDKqAbjmUZTn60wj2cDxcEpZC+KCyPcgnL/
	5P46+rXIzV0kTy3hy1ypzrXL4zNRRGIVl7MTEGIK/V0ApSS8y2E0gvUe9gsPPzx2FA7zaHeew
	PN9fcHBFWQgc5hZAloClyaHQcdg/YOAa9XREO0W1nf2z7Mkx/ieD4vw/dRsVR8Vlnv9uWc1WP
	CMImBlY70hAgCaB8/tszaYeeSG18mHyOfszLFaZu0BbvrZc7OqZptyPxY9wAYQ8RGUhVYqgLl
	gZgiEDxhucrioOmMv86XG7HkGrTFXKFgpeMnVGdbierKP2ZyIULtndJ2zNpw4p43ttuCL1DHW
	qtM9Dk7vS1j4jOPxn5WGVwyVd911HwvKHoVLbwwhkgoCqR6A2XeKdD4+bayar7UKr1+KImws7
	vRc1rHpXOqVeAS5lSQmfVLwlXvJfPbg1YylM0bjobAiHH0O8YMm0z5wSNPT8NWZ9t1dI3QBF0
	q+2rVCp7IVHyBuWmZKO2w6kIY81Rt6JPmth1BC0QApvN7Ryuul9D84M7DqJYEXl+BuC5r9xkd
	6O2xUCs6k0CLWTWoHDbXh/Ar9+vsHrGl7vWrwqZQD6E08Kq+Q1Ft6Irmia5MxNCMl7YrKVhsv
	5SL3t8JrhdT8pWxIJtkg==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Paul Moore <paul@paul-moore.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v2 3/3] dm crypt: log aead integrity violations
	to audit subsystem
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

U2luY2UgZG0tY3J5cHQgdGFyZ2V0IGNhbiBiZSBzdGFja2VkIG9uIGRtLWludGVncml0eSB0YXJn
ZXRzIHRvCnByb3ZpZGUgYXV0aGVudGljYXRlZCBlbmNyeXB0aW9uLCBpbnRlZ3JpdHkgdmlvbGF0
aW9ucyBhcmUgcmVjb2duaXplZApoZXJlIGR1cmluZyBhZWFkIGNvbXB1dGF0aW9uLiBXZSB1c2Ug
dGhlIGRtLWF1ZGl0IHN1Ym1vZHVsZSB0bwpzaWduYWwgdGhvc2UgZXZlbnRzIHRvIHVzZXIgc3Bh
Y2UsIHRvby4KClRoZSBjb25zdHJ1Y3Rpb24gYW5kIGRlc3RydWN0aW9uIG9mIGNyeXB0IGRldmlj
ZSBtYXBwaW5ncyBhcmUgYWxzbwpsb2dnZWQgYXMgYXVkaXQgZXZlbnRzLgoKU2lnbmVkLW9mZi1i
eTogTWljaGFlbCBXZWnDnyA8bWljaGFlbC53ZWlzc0BhaXNlYy5mcmF1bmhvZmVyLmRlPgotLS0K
IGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDIyICsrKysrKysrKysrKysrKysrKy0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWQvZG0tY3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwppbmRleCA1MGY0
Y2JkNjAwZDUuLjJhMzM2ZWFjYjUwYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5j
CisrKyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwpAQCAtNDEsNiArNDEsOCBAQAogCiAjaW5jbHVk
ZSA8bGludXgvZGV2aWNlLW1hcHBlci5oPgogCisjaW5jbHVkZSAiZG0tYXVkaXQuaCIKKwogI2Rl
ZmluZSBETV9NU0dfUFJFRklYICJjcnlwdCIKIAogLyoKQEAgLTEzNjIsOCArMTM2NCwxMiBAQCBz
dGF0aWMgaW50IGNyeXB0X2NvbnZlcnRfYmxvY2tfYWVhZChzdHJ1Y3QgY3J5cHRfY29uZmlnICpj
YywKIAogCWlmIChyID09IC1FQkFETVNHKSB7CiAJCWNoYXIgYltCREVWTkFNRV9TSVpFXTsKLQkJ
RE1FUlJfTElNSVQoIiVzOiBJTlRFR1JJVFkgQUVBRCBFUlJPUiwgc2VjdG9yICVsbHUiLCBiaW9f
ZGV2bmFtZShjdHgtPmJpb19pbiwgYiksCi0JCQkgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylsZTY0
X3RvX2NwdSgqc2VjdG9yKSk7CisJCXNlY3Rvcl90IHMgPSBsZTY0X3RvX2NwdSgqc2VjdG9yKTsK
KworCQlETUVSUl9MSU1JVCgiJXM6IElOVEVHUklUWSBBRUFEIEVSUk9SLCBzZWN0b3IgJWxsdSIs
CisJCQkgICAgYmlvX2Rldm5hbWUoY3R4LT5iaW9faW4sIGIpLCBzKTsKKwkJZG1fYXVkaXRfbG9n
X2JpbyhETV9NU0dfUFJFRklYLCAiaW50ZWdyaXR5LWFlYWQiLAorCQkJCSBjdHgtPmJpb19pbiwg
cywgMCk7CiAJfQogCiAJaWYgKCFyICYmIGNjLT5pdl9nZW5fb3BzICYmIGNjLT5pdl9nZW5fb3Bz
LT5wb3N0KQpAQCAtMjE3Myw4ICsyMTc5LDEyIEBAIHN0YXRpYyB2b2lkIGtjcnlwdGRfYXN5bmNf
ZG9uZShzdHJ1Y3QgY3J5cHRvX2FzeW5jX3JlcXVlc3QgKmFzeW5jX3JlcSwKIAogCWlmIChlcnJv
ciA9PSAtRUJBRE1TRykgewogCQljaGFyIGJbQkRFVk5BTUVfU0laRV07Ci0JCURNRVJSX0xJTUlU
KCIlczogSU5URUdSSVRZIEFFQUQgRVJST1IsIHNlY3RvciAlbGx1IiwgYmlvX2Rldm5hbWUoY3R4
LT5iaW9faW4sIGIpLAotCQkJICAgICh1bnNpZ25lZCBsb25nIGxvbmcpbGU2NF90b19jcHUoKm9y
Z19zZWN0b3Jfb2ZfZG1yZXEoY2MsIGRtcmVxKSkpOworCQlzZWN0b3JfdCBzID0gbGU2NF90b19j
cHUoKm9yZ19zZWN0b3Jfb2ZfZG1yZXEoY2MsIGRtcmVxKSk7CisKKwkJRE1FUlJfTElNSVQoIiVz
OiBJTlRFR1JJVFkgQUVBRCBFUlJPUiwgc2VjdG9yICVsbHUiLAorCQkJICAgIGJpb19kZXZuYW1l
KGN0eC0+YmlvX2luLCBiKSwgcyk7CisJCWRtX2F1ZGl0X2xvZ19iaW8oRE1fTVNHX1BSRUZJWCwg
ImludGVncml0eS1hZWFkIiwKKwkJCQkgY3R4LT5iaW9faW4sIHMsIDApOwogCQlpby0+ZXJyb3Ig
PSBCTEtfU1RTX1BST1RFQ1RJT047CiAJfSBlbHNlIGlmIChlcnJvciA8IDApCiAJCWlvLT5lcnJv
ciA9IEJMS19TVFNfSU9FUlI7CkBAIC0yNzI5LDYgKzI3MzksOCBAQCBzdGF0aWMgdm9pZCBjcnlw
dF9kdHIoc3RydWN0IGRtX3RhcmdldCAqdGkpCiAJZG1fY3J5cHRfY2xpZW50c19uLS07CiAJY3J5
cHRfY2FsY3VsYXRlX3BhZ2VzX3Blcl9jbGllbnQoKTsKIAlzcGluX3VubG9jaygmZG1fY3J5cHRf
Y2xpZW50c19sb2NrKTsKKworCWRtX2F1ZGl0X2xvZ190YXJnZXQoRE1fTVNHX1BSRUZJWCwgImR0
ciIsIHRpLCAxKTsKIH0KIAogc3RhdGljIGludCBjcnlwdF9jdHJfaXZtb2RlKHN0cnVjdCBkbV90
YXJnZXQgKnRpLCBjb25zdCBjaGFyICppdm1vZGUpCkBAIC0zMzU3LDkgKzMzNjksMTEgQEAgc3Rh
dGljIGludCBjcnlwdF9jdHIoc3RydWN0IGRtX3RhcmdldCAqdGksIHVuc2lnbmVkIGludCBhcmdj
LCBjaGFyICoqYXJndikKIAl0aS0+bnVtX2ZsdXNoX2Jpb3MgPSAxOwogCXRpLT5saW1pdF9zd2Fw
X2Jpb3MgPSB0cnVlOwogCisJZG1fYXVkaXRfbG9nX3RhcmdldChETV9NU0dfUFJFRklYLCAiY3Ry
IiwgdGksIDEpOwogCXJldHVybiAwOwogCiBiYWQ6CisJZG1fYXVkaXRfbG9nX3RhcmdldChETV9N
U0dfUFJFRklYLCAiY3RyIiwgdGksIDApOwogCWNyeXB0X2R0cih0aSk7CiAJcmV0dXJuIHJldDsK
IH0KLS0gCjIuMjAuMQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

