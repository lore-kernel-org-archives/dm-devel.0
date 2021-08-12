Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B73C4320A
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CF3A610CC
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6CF3A610CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-r3Y-Ng49M2yHcpMKNpHeWA-1; Fri, 13 Aug 2021 02:41:17 -0400
X-MC-Unique: r3Y-Ng49M2yHcpMKNpHeWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AB2D185302E;
	Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DEC360C9F;
	Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50C8E181A0F8;
	Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CF3gIJ011488 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 11:03:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3EB021054591; Thu, 12 Aug 2021 15:03:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3608F1054596
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF1C7800882
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:37 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-eITL0zw2MdKc5-LpDTV6mQ-1; Thu, 12 Aug 2021 11:03:34 -0400
X-MC-Unique: eITL0zw2MdKc5-LpDTV6mQ-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1M1pk0-1mGP571gUa-002HB7; Thu, 12 Aug 2021 16:58:17 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: michael.weiss@aisec.fraunhofer.de
Date: Thu, 12 Aug 2021 16:57:43 +0200
Message-Id: <20210812145748.4460-3-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:rOLBkevwnsuHTTeZxM6wyt3brTUugDPPIMca4NeT5aNr5Kik2K3
	hbgMjJU3VBouB/E3nUPL+YruThvT5ydbySJdhQQjp8WZ+i8fV4e7zNcqUaHlGg+3mWghOU6
	K6p+C/8Q3QwxaneRe71C77r9c3+iVHn6DpNPthcNFIqMrXD2v78B6HcfF7hF20FXqZFmQ/r
	XqHpyX2+hQc8xP0Czd8+A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:S4KgAIov8XM=:jjXaBNeDppYlEFwBwqqD5h
	cVTX2wU2kko4f65fsbkYHa4q00So1PFco7YG4QqQ1167rNKM+C5u+2vDl3FIlxo5o5TDN+grJ
	T+2pXAHRlUn0EjUGKZ62qrh5aODFzLpvQqQwRj0ZvtAghA3DgAv66nebNHs4Q/dE9e4bJzPdD
	4Lcs5nw9ABj9pnA+i0ZvaJsHPifwcLSt/xj0AfXPxByZH3t7ejwlqnXecTJ6Gt4hd5fxmiS2T
	89NKBvLvPcV9vMO/e5PD+Uns9WNnJ6cHCcrhWWi6rNCvomh3tSrPsHOWZgoyyGX30ImLzbBHg
	0E5gPgFHcA0MLRtaUpXT6uzRQeu8I7c8IfG4Q1wdQoU+Hbn+fx6g6kPCNJcZcP8+ySpIIe2EA
	lVc/gc9swemKWRDCQDYIRhw8TlqYwLqaI7WOYR6d0DkHPbboRi/D6O5ZLPoaXTmLT/MU3sVL3
	ImFKqKCDK+7zecy1fZcK5l5bBuK+AXJP6/SbkTmhbOBbk8NFfF549xPRukqOpNBv5n4YY4z3N
	/qLcieFJ4c69v9Wxq7FKY+K8gaskb7xzhwi6pMertvUVJ50IoLKNajmte3l1oe7wM/f5P3/1E
	wpP3IP+HnZ5S0rnYjbRWYfmQMoIqPm2Y7CYXdYoP0F7u4JcZ13KDIGjJ7K+kvmv0EXja4JYtn
	XB/fgdD17zivyvg11I1K/PATElZHeJiDwCNQh6WTbX8k7JX/h3iJwqtpXkfa8KGLFG1nreFJN
	Qux3JmsAuddC9mCurDw52GFSIRP7s4CdDDfV8fS3IoDgzpso9f40dKGHHU54Wor3RCPvk5iEg
	6ihVUCZ197f27p9GabC6aO8gSuxwpY5cXQt0p+Uo/O2q1eRqYj1dz7RH7SxY1mUhO55ridl3C
	HslFQm6OewPdNE2rf51A==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Aug 2021 02:36:56 -0400
Cc: Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 2/3] dm integrity: log audit events for
	dm-integrity target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

ZG0taW50ZWdyaXR5IHNpZ25hbHMgaW50ZWdyaXR5IHZpb2xhdGlvbnMgYnkgcmV0dXJuaW5nIEkv
TyBlcnJvcnMKdG8gdXNlciBzcGFjZS4gVG8gaWRlbnRpZnkgaW50ZWdyaXR5IHZpb2xhdGlvbnMg
YnkgYSBjb250cm9sbGluZwppbnN0YW5jZSwgdGhlIGtlcm5lbCBhdWRpdCBzdWJzeXN0ZW0gY2Fu
IGJlIHVzZWQgdG8gZW1pdCBhdWRpdApldmVudHMgdG8gdXNlciBzcGFjZS4gV2UgdXNlIHRoZSBu
ZXcgZG0tYXVkaXQgc3VibW9kdWxlIGFsbG93aW5nCnRvIGVtaXQgYXVkaXQgZXZlbnRzIG9uIHJl
bGV2YW50IEkvTyBlcnJvcnMuCgpUaGUgY29uc3RydWN0aW9uIGFuZCBkZXN0cnVjdGlvbiBvZiBp
bnRlZ3JpdHkgZGV2aWNlIG1hcHBpbmdzIGFyZQphbHNvIHJlbGV2YW50IGZvciBhdWRpdGluZyBh
IHN5c3RlbS4gVGh1cywgdGhvc2UgZXZlbnRzIGFyZSBhbHNvCmxvZ2dlZCBhcyBhdWRpdCBldmVu
dHMuCgpTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFdlacOfIDxtaWNoYWVsLndlaXNzQGFpc2VjLmZy
YXVuaG9mZXIuZGU+Ci0tLQogZHJpdmVycy9tZC9kbS1pbnRlZ3JpdHkuYyB8IDI1ICsrKysrKysr
KysrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCA0IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0taW50ZWdyaXR5LmMgYi9kcml2
ZXJzL21kL2RtLWludGVncml0eS5jCmluZGV4IDIwZjI1MTBkYjFmNi4uZmJiYjRjM2YxNmNiIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21kL2RtLWludGVncml0eS5jCisrKyBiL2RyaXZlcnMvbWQvZG0t
aW50ZWdyaXR5LmMKQEAgLTIzLDYgKzIzLDggQEAKICNpbmNsdWRlIDxsaW51eC9hc3luY190eC5o
PgogI2luY2x1ZGUgPGxpbnV4L2RtLWJ1ZmlvLmg+CiAKKyNpbmNsdWRlICJkbS1hdWRpdC5oIgor
CiAjZGVmaW5lIERNX01TR19QUkVGSVggImludGVncml0eSIKIAogI2RlZmluZSBERUZBVUxUX0lO
VEVSTEVBVkVfU0VDVE9SUwkzMjc2OApAQCAtNTM5LDYgKzU0MSw3IEBAIHN0YXRpYyBpbnQgc2Jf
bWFjKHN0cnVjdCBkbV9pbnRlZ3JpdHlfYyAqaWMsIGJvb2wgd3IpCiAJCX0KIAkJaWYgKG1lbWNt
cCgoX191OCAqKWljLT5zYiArICgxIDw8IFNFQ1RPUl9TSElGVCkgLSBzaXplLCByZXN1bHQsIHNp
emUpKSB7CiAJCQlkbV9pbnRlZ3JpdHlfaW9fZXJyb3IoaWMsICJzdXBlcmJsb2NrIG1hYyIsIC1F
SUxTRVEpOworCQkJZG1fYXVkaXRfbG9nX3RhcmdldChETV9NU0dfUFJFRklYLCAibWFjLXN1cGVy
YmxvY2siLCBpYy0+dGksIDApOwogCQkJcmV0dXJuIC1FSUxTRVE7CiAJCX0KIAl9CkBAIC04NzYs
OCArODc5LDEwIEBAIHN0YXRpYyB2b2lkIHJ3X3NlY3Rpb25fbWFjKHN0cnVjdCBkbV9pbnRlZ3Jp
dHlfYyAqaWMsIHVuc2lnbmVkIHNlY3Rpb24sIGJvb2wgd3IpCiAJCWlmIChsaWtlbHkod3IpKQog
CQkJbWVtY3B5KCZqcy0+bWFjLCByZXN1bHQgKyAoaiAqIEpPVVJOQUxfTUFDX1BFUl9TRUNUT1Ip
LCBKT1VSTkFMX01BQ19QRVJfU0VDVE9SKTsKIAkJZWxzZSB7Ci0JCQlpZiAobWVtY21wKCZqcy0+
bWFjLCByZXN1bHQgKyAoaiAqIEpPVVJOQUxfTUFDX1BFUl9TRUNUT1IpLCBKT1VSTkFMX01BQ19Q
RVJfU0VDVE9SKSkKKwkJCWlmIChtZW1jbXAoJmpzLT5tYWMsIHJlc3VsdCArIChqICogSk9VUk5B
TF9NQUNfUEVSX1NFQ1RPUiksIEpPVVJOQUxfTUFDX1BFUl9TRUNUT1IpKSB7CiAJCQkJZG1faW50
ZWdyaXR5X2lvX2Vycm9yKGljLCAiam91cm5hbCBtYWMiLCAtRUlMU0VRKTsKKwkJCQlkbV9hdWRp
dF9sb2dfdGFyZ2V0KERNX01TR19QUkVGSVgsICJtYWMtam91cm5hbCIsIGljLT50aSwgMCk7CisJ
CQl9CiAJCX0KIAl9CiB9CkBAIC0xNzgyLDEwICsxNzg3LDE1IEBAIHN0YXRpYyB2b2lkIGludGVn
cml0eV9tZXRhZGF0YShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKncpCiAJCQlpZiAodW5saWtlbHkocikp
IHsKIAkJCQlpZiAociA+IDApIHsKIAkJCQkJY2hhciBiW0JERVZOQU1FX1NJWkVdOwotCQkJCQlE
TUVSUl9MSU1JVCgiJXM6IENoZWNrc3VtIGZhaWxlZCBhdCBzZWN0b3IgMHglbGx4IiwgYmlvX2Rl
dm5hbWUoYmlvLCBiKSwKLQkJCQkJCSAgICAoc2VjdG9yIC0gKChyICsgaWMtPnRhZ19zaXplIC0g
MSkgLyBpYy0+dGFnX3NpemUpKSk7CisJCQkJCXNlY3Rvcl90IHM7CisKKwkJCQkJcyA9IHNlY3Rv
ciAtICgociArIGljLT50YWdfc2l6ZSAtIDEpIC8gaWMtPnRhZ19zaXplKTsKKwkJCQkJRE1FUlJf
TElNSVQoIiVzOiBDaGVja3N1bSBmYWlsZWQgYXQgc2VjdG9yIDB4JWxseCIsCisJCQkJCQkgICAg
YmlvX2Rldm5hbWUoYmlvLCBiKSwgcyk7CiAJCQkJCXIgPSAtRUlMU0VROwogCQkJCQlhdG9taWM2
NF9pbmMoJmljLT5udW1iZXJfb2ZfbWlzbWF0Y2hlcyk7CisJCQkJCWRtX2F1ZGl0X2xvZ19iaW8o
RE1fTVNHX1BSRUZJWCwgImludGVncml0eS1jaGVja3N1bSIsCisJCQkJCQkJIGJpbywgcywgMCk7
CiAJCQkJfQogCQkJCWlmIChsaWtlbHkoY2hlY2tzdW1zICE9IGNoZWNrc3Vtc19vbnN0YWNrKSkK
IAkJCQkJa2ZyZWUoY2hlY2tzdW1zKTsKQEAgLTE5OTEsNiArMjAwMSw4IEBAIHN0YXRpYyBib29s
IF9fam91cm5hbF9yZWFkX3dyaXRlKHN0cnVjdCBkbV9pbnRlZ3JpdHlfaW8gKmRpbywgc3RydWN0
IGJpbyAqYmlvLAogCQkJCQlpZiAodW5saWtlbHkobWVtY21wKGNoZWNrc3Vtc19vbnN0YWNrLCBq
b3VybmFsX2VudHJ5X3RhZyhpYywgamUpLCBpYy0+dGFnX3NpemUpKSkgewogCQkJCQkJRE1FUlJf
TElNSVQoIkNoZWNrc3VtIGZhaWxlZCB3aGVuIHJlYWRpbmcgZnJvbSBqb3VybmFsLCBhdCBzZWN0
b3IgMHglbGx4IiwKIAkJCQkJCQkgICAgbG9naWNhbF9zZWN0b3IpOworCQkJCQkJZG1fYXVkaXRf
bG9nX2JpbyhETV9NU0dfUFJFRklYLCAiam91cm5hbC1jaGVja3N1bSIsCisJCQkJCQkJCSBiaW8s
IGxvZ2ljYWxfc2VjdG9yLCAwKTsKIAkJCQkJfQogCQkJCX0KICNlbmRpZgpAQCAtMjUzNCw4ICsy
NTQ2LDEwIEBAIHN0YXRpYyB2b2lkIGRvX2pvdXJuYWxfd3JpdGUoc3RydWN0IGRtX2ludGVncml0
eV9jICppYywgdW5zaWduZWQgd3JpdGVfc3RhcnQsCiAKIAkJCQkJaW50ZWdyaXR5X3NlY3Rvcl9j
aGVja3N1bShpYywgc2VjICsgKChsIC0gaikgPDwgaWMtPnNiLT5sb2cyX3NlY3RvcnNfcGVyX2Js
b2NrKSwKIAkJCQkJCQkJICAoY2hhciAqKWFjY2Vzc19qb3VybmFsX2RhdGEoaWMsIGksIGwpLCB0
ZXN0X3RhZyk7Ci0JCQkJCWlmICh1bmxpa2VseShtZW1jbXAodGVzdF90YWcsIGpvdXJuYWxfZW50
cnlfdGFnKGljLCBqZTIpLCBpYy0+dGFnX3NpemUpKSkKKwkJCQkJaWYgKHVubGlrZWx5KG1lbWNt
cCh0ZXN0X3RhZywgam91cm5hbF9lbnRyeV90YWcoaWMsIGplMiksIGljLT50YWdfc2l6ZSkpKSB7
CiAJCQkJCQlkbV9pbnRlZ3JpdHlfaW9fZXJyb3IoaWMsICJ0YWcgbWlzbWF0Y2ggd2hlbiByZXBs
YXlpbmcgam91cm5hbCIsIC1FSUxTRVEpOworCQkJCQkJZG1fYXVkaXRfbG9nX3RhcmdldChETV9N
U0dfUFJFRklYLCAiaW50ZWdyaXR5LXJlcGxheS1qb3VybmFsIiwgaWMtPnRpLCAwKTsKKwkJCQkJ
fQogCQkJCX0KIAogCQkJCWpvdXJuYWxfZW50cnlfc2V0X3VudXNlZChqZTIpOwpAQCAtNDQ5MCw5
ICs0NTA0LDExIEBAIHN0YXRpYyBpbnQgZG1faW50ZWdyaXR5X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aSwgdW5zaWduZWQgYXJnYywgY2hhciAqKmFyZ3YpCiAJaWYgKGljLT5kaXNjYXJkKQogCQl0
aS0+bnVtX2Rpc2NhcmRfYmlvcyA9IDE7CiAKKwlkbV9hdWRpdF9sb2dfdGFyZ2V0KERNX01TR19Q
UkVGSVgsICJjdHIiLCB0aSwgMSk7CiAJcmV0dXJuIDA7CiAKIGJhZDoKKwlkbV9hdWRpdF9sb2df
dGFyZ2V0KERNX01TR19QUkVGSVgsICJjdHIiLCB0aSwgMCk7CiAJZG1faW50ZWdyaXR5X2R0cih0
aSk7CiAJcmV0dXJuIHI7CiB9CkBAIC00NTY2LDYgKzQ1ODIsNyBAQCBzdGF0aWMgdm9pZCBkbV9p
bnRlZ3JpdHlfZHRyKHN0cnVjdCBkbV90YXJnZXQgKnRpKQogCWZyZWVfYWxnKCZpYy0+am91cm5h
bF9tYWNfYWxnKTsKIAogCWtmcmVlKGljKTsKKwlkbV9hdWRpdF9sb2dfdGFyZ2V0KERNX01TR19Q
UkVGSVgsICJkdHIiLCB0aSwgMSk7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgdGFyZ2V0X3R5cGUgaW50
ZWdyaXR5X3RhcmdldCA9IHsKLS0gCjIuMjAuMQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbA==

