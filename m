Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCEEC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:14:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A15066103B
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:14:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A15066103B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-MrkN8OtnM_CYFHYzu8bh9Q-1; Mon, 06 Sep 2021 04:14:51 -0400
X-MC-Unique: MrkN8OtnM_CYFHYzu8bh9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 932A0180FD91;
	Mon,  6 Sep 2021 08:14:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A2706A256;
	Mon,  6 Sep 2021 08:14:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 538D6180B44F;
	Mon,  6 Sep 2021 08:14:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 184A08Fn024049 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 4 Sep 2021 06:00:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E9C032167809; Sat,  4 Sep 2021 10:00:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3B422167805
	for <dm-devel@redhat.com>; Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36843866DF5
	for <dm-devel@redhat.com>; Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-117-iSQcCx8XOeGGDS7gLVzyFA-1; Sat, 04 Sep 2021 06:00:03 -0400
X-MC-Unique: iSQcCx8XOeGGDS7gLVzyFA-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1MPrXf-1mYmI73emh-00MsL2; Sat, 04 Sep 2021 12:00:00 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Paul Moore <paul@paul-moore.com>, Casey Schaufler <casey@schaufler-ca.com>
Date: Sat,  4 Sep 2021 11:59:30 +0200
Message-Id: <20210904095934.5033-4-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:m7H31RjTq/RWlxT0KJCzKnzsf7xGhGsSA9GOUbq9dzTVKL/B/7E
	jiH4G8fgCUfwOS9K75NuJ55TlCa9LC0plVPCbW1MrUVzDN6X94zAy6Lzu5Oq9/N4YSxFWyE
	WGCJPiibYXhNJZ1n5NlSWdjZ46F2jK/lBj3h+ijX+CdmeR4d1Y00s8aImbzta1eL1JxNatA
	7rDkahC9w0SDGMCfK5Wjw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ierr4Vfsyso=:EhRe4ISPaUlcG6i3McEf7O
	qngGcL7ENkdo2/WQ7yStDQDdzMMDQl34lGyu4YUbnrOSu53lnObo/SgijGvp5/zh0tI9PH9TE
	jJk/H10YFhOqyAiy2TcT2M8gqZtc5eYIo45eD4dHCQWIdt0bTKVu01+gTnmzKa4KfmVxfN+Xe
	SacYQ7OH9zr8+93UHOBk2eP82Lmw1ihvfdnxMDF/gBzp+ugt2SEAGHzW9nUbu7CTaWWYIXHIc
	OJyoZrpmdXJ7HaWwIyD6bRYMJmNJGh1Hpw1N5/x18yk/x+rSOAnd5rrKzRrSy4hnAaTAxAfsz
	b3TIew59B/K349tgeWrfts4VgbA/lKK5JsBXK3+Zgv/fA2NF/EMInAD5ozOxpl+9KbMb3lPqZ
	zTylnxWwmpFj3txgIP6VnduHOLjlpTtth2GrbT33RuEHAPJCbgQePTMdFxQDSyuau4/fmDEI7
	t5FxMAOei85VlXWniT/kKwOev7cIF07tVH39u6tiqrYn8tGl9YWg3ZEXtUX1K1m+D5Z1t3NbL
	ZVdslYRirn2bcZnaC9wCKbV8+ON63p8NtnBSijtsw0lFWL5F8C59quFSRIw+czmPlGCacvW52
	r/RjS6gwrhkYp1PFuSMm880r/wG8rFGJe9HKiFz+FG/uQWDElr7B4Z7oMZPsh02xcjdiBB5ek
	HAtxoiGx77qEuphxkHeSK/abudZmVjGunKe6V+yKsjBXwiVMttjD0PAhL0KU87JmEG62woU1S
	YFt91GbTHEcRUTNCUtlUC5V+JFm394orRBxe0Sq7598j7x0RexSsfqK/PIY=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 06 Sep 2021 04:14:38 -0400
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v4 3/3] dm crypt: log aead integrity violations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
Y2JkNjAwZDUuLjVlMDIwMDIzNDVmYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5j
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
Y2xpZW50c19sb2NrKTsKKworCWRtX2F1ZGl0X2xvZ19kdHIoRE1fTVNHX1BSRUZJWCwgdGksIDEp
OwogfQogCiBzdGF0aWMgaW50IGNyeXB0X2N0cl9pdm1vZGUoc3RydWN0IGRtX3RhcmdldCAqdGks
IGNvbnN0IGNoYXIgKml2bW9kZSkKQEAgLTMzNTcsOSArMzM2OSwxMSBAQCBzdGF0aWMgaW50IGNy
eXB0X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQogCXRpLT5udW1fZmx1c2hfYmlvcyA9IDE7CiAJdGktPmxpbWl0X3N3YXBfYmlvcyA9IHRy
dWU7CiAKKwlkbV9hdWRpdF9sb2dfY3RyKERNX01TR19QUkVGSVgsIHRpLCAxKTsKIAlyZXR1cm4g
MDsKIAogYmFkOgorCWRtX2F1ZGl0X2xvZ19jdHIoRE1fTVNHX1BSRUZJWCwgdGksIDApOwogCWNy
eXB0X2R0cih0aSk7CiAJcmV0dXJuIHJldDsKIH0KLS0gCjIuMjAuMQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

