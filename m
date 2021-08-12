Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD58C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05C8A610CD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05C8A610CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-kfkZefDBNnij680JDMyHQw-1; Fri, 13 Aug 2021 02:41:16 -0400
X-MC-Unique: kfkZefDBNnij680JDMyHQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C81F11008065;
	Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3CCE2B3A5;
	Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7889C4A7C9;
	Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CF3iGp011495 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 11:03:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B67902094D05; Thu, 12 Aug 2021 15:03:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B16EC2094D36
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9743118A653A
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:45 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-101-Dq4AUA8UPFu6jooFHHYDIQ-1; Thu, 12 Aug 2021 11:03:41 -0400
X-MC-Unique: Dq4AUA8UPFu6jooFHHYDIQ-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1Mwwhv-1n3GJb0gg7-00yNa2; Thu, 12 Aug 2021 16:58:20 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: michael.weiss@aisec.fraunhofer.de
Date: Thu, 12 Aug 2021 16:57:44 +0200
Message-Id: <20210812145748.4460-4-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:hi75DlmNC+gK0CXxDU0sjhTTyi1egVdFtYQsJdIqde10JuGW9jT
	TPsDrRNsncuUh69Pvfji/1XP0HPWq+lq4I/9TE5MXLvZ7i8SwSZsjqd+ROBtQVpLZ9IWRti
	0J39VfLCltB8admoIpZQFSyP3cQaFVpTaYQsnl0QKyngMYvvlRlJxzVCusRAc/4FwxzoDbO
	klNlxcmjVhKgcKpfg6j+w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OMKJiFCoaiQ=:MNg8iq5mB8F24eGYw49PmB
	Svc/aMssE1J3zFzYHJ7aWl6UPunR54ICA+kMjj4o0g5I32jNBBnAOwRCMw0JCgbcS7q9y73qO
	qOprtRAZ6nCvkTc/xuTqBEmqwflzOJ72aO4zD2MnyA8REviPV57B8wuf9ZxFZitLCD5VRUMX4
	BdEI/ZVxUDMOmTMRsCOUOTZ7673CmmflbTfnM3tcX8jlCaT1XTTMV0XoD6bYpPlDCh7mPGsNj
	5xjyVpNd6ZDqpZIpJmIwM5rHI9fgiBv9ILLOpRO4WYk/PAo8ZJ9kK5KEcN20NveLAs2dT6/f0
	Wrz23405tx4og2x8CwHCb9ac0haCdz207VCqUuElZY/MzXftOM6DDxVcLQ/ZBDufRjH4BtoDs
	YAYZp6IXaaiUdU5EzKxUyWLPEa9jQRsrG0u+j6Eo/1a4Qipy9vMsAaG7gxGcRj7xqlef7F2Zk
	wWOxcLXja5OrIi1/44jHjvv+zHxDuavXOu6q/6WAI+7aXX5SW1qjhbkx8LG0keIHTsT/sSAu9
	XTXeWWFLGwkdBjJ39T7W82+NDlyTfY08GGIqO+JNd5DjIpvA0u4Ei9eeIeUU3zHEzLjPWEl4k
	uKLfdyzo9/tbRseTxY0wWfSKwvXJasM/NP7RWwKtmCzs5b8HWFj265NCM9bRUboX6uxwKE9HO
	zV62yQ3wtS/Tct+Oy9Kq7VYDQ7RsL1I3TZTqe56EfNQW30aNAXdlLiY5yR6/uoqif12L/hBd9
	KcBOBzmqkNQT9fORmgvNBaR94rPl/PFxsIw23K6L/R7FDX7m+N48hvJLUd6sSq8CEDc8bJpEe
	iUoaJ0TwRmIFzhaNpd3VdsCRUms3cNp5UA60nGRqlMOmBm48+cOlrQgBgK6zVUyCQ4taA9Bdi
	zOtkJwM5h/FlWTXJmocA==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Aug 2021 02:36:56 -0400
Cc: Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 3/3] dm crypt: log aead integrity violations to
	audit subsystem
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
IGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDIzICsrKysrKysrKysrKysrKysrKystLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL21kL2RtLWNyeXB0LmMgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKaW5kZXggNTBm
NGNiZDYwMGQ1Li4zNDNhZWY0ZGNmNWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0tY3J5cHQu
YworKysgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKQEAgLTQxLDYgKzQxLDggQEAKIAogI2luY2x1
ZGUgPGxpbnV4L2RldmljZS1tYXBwZXIuaD4KIAorI2luY2x1ZGUgImRtLWF1ZGl0LmgiCisKICNk
ZWZpbmUgRE1fTVNHX1BSRUZJWCAiY3J5cHQiCiAKIC8qCkBAIC0xMTIyLDYgKzExMjQsNyBAQCBz
dGF0aWMgYm9vbCBjcnlwdF9pbnRlZ3JpdHlfaG1hYyhzdHJ1Y3QgY3J5cHRfY29uZmlnICpjYykK
IAlyZXR1cm4gY3J5cHRfaW50ZWdyaXR5X2FlYWQoY2MpICYmIGNjLT5rZXlfbWFjX3NpemU7CiB9
CiAKKwogLyogR2V0IHNnIGNvbnRhaW5pbmcgZGF0YSAqLwogc3RhdGljIHN0cnVjdCBzY2F0dGVy
bGlzdCAqY3J5cHRfZ2V0X3NnX2RhdGEoc3RydWN0IGNyeXB0X2NvbmZpZyAqY2MsCiAJCQkJCSAg
ICAgc3RydWN0IHNjYXR0ZXJsaXN0ICpzZykKQEAgLTEzNjIsOCArMTM2NSwxMiBAQCBzdGF0aWMg
aW50IGNyeXB0X2NvbnZlcnRfYmxvY2tfYWVhZChzdHJ1Y3QgY3J5cHRfY29uZmlnICpjYywKIAog
CWlmIChyID09IC1FQkFETVNHKSB7CiAJCWNoYXIgYltCREVWTkFNRV9TSVpFXTsKLQkJRE1FUlJf
TElNSVQoIiVzOiBJTlRFR1JJVFkgQUVBRCBFUlJPUiwgc2VjdG9yICVsbHUiLCBiaW9fZGV2bmFt
ZShjdHgtPmJpb19pbiwgYiksCi0JCQkgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylsZTY0X3RvX2Nw
dSgqc2VjdG9yKSk7CisJCXNlY3Rvcl90IHMgPSBsZTY0X3RvX2NwdSgqc2VjdG9yKTsKKworCQlE
TUVSUl9MSU1JVCgiJXM6IElOVEVHUklUWSBBRUFEIEVSUk9SLCBzZWN0b3IgJWxsdSIsCisJCQkg
ICAgYmlvX2Rldm5hbWUoY3R4LT5iaW9faW4sIGIpLCBzKTsKKwkJZG1fYXVkaXRfbG9nX2JpbyhE
TV9NU0dfUFJFRklYLCAiaW50ZWdyaXR5LWFlYWQiLAorCQkJCSBjdHgtPmJpb19pbiwgcywgMCk7
CiAJfQogCiAJaWYgKCFyICYmIGNjLT5pdl9nZW5fb3BzICYmIGNjLT5pdl9nZW5fb3BzLT5wb3N0
KQpAQCAtMjE3Myw4ICsyMTgwLDEyIEBAIHN0YXRpYyB2b2lkIGtjcnlwdGRfYXN5bmNfZG9uZShz
dHJ1Y3QgY3J5cHRvX2FzeW5jX3JlcXVlc3QgKmFzeW5jX3JlcSwKIAogCWlmIChlcnJvciA9PSAt
RUJBRE1TRykgewogCQljaGFyIGJbQkRFVk5BTUVfU0laRV07Ci0JCURNRVJSX0xJTUlUKCIlczog
SU5URUdSSVRZIEFFQUQgRVJST1IsIHNlY3RvciAlbGx1IiwgYmlvX2Rldm5hbWUoY3R4LT5iaW9f
aW4sIGIpLAotCQkJICAgICh1bnNpZ25lZCBsb25nIGxvbmcpbGU2NF90b19jcHUoKm9yZ19zZWN0
b3Jfb2ZfZG1yZXEoY2MsIGRtcmVxKSkpOworCQlzZWN0b3JfdCBzID0gbGU2NF90b19jcHUoKm9y
Z19zZWN0b3Jfb2ZfZG1yZXEoY2MsIGRtcmVxKSk7CisKKwkJRE1FUlJfTElNSVQoIiVzOiBJTlRF
R1JJVFkgQUVBRCBFUlJPUiwgc2VjdG9yICVsbHUiLAorCQkJICAgIGJpb19kZXZuYW1lKGN0eC0+
YmlvX2luLCBiKSwgcyk7CisJCWRtX2F1ZGl0X2xvZ19iaW8oRE1fTVNHX1BSRUZJWCwgImludGVn
cml0eS1hZWFkIiwKKwkJCQkgY3R4LT5iaW9faW4sIHMsIDApOwogCQlpby0+ZXJyb3IgPSBCTEtf
U1RTX1BST1RFQ1RJT047CiAJfSBlbHNlIGlmIChlcnJvciA8IDApCiAJCWlvLT5lcnJvciA9IEJM
S19TVFNfSU9FUlI7CkBAIC0yNzI5LDYgKzI3NDAsOCBAQCBzdGF0aWMgdm9pZCBjcnlwdF9kdHIo
c3RydWN0IGRtX3RhcmdldCAqdGkpCiAJZG1fY3J5cHRfY2xpZW50c19uLS07CiAJY3J5cHRfY2Fs
Y3VsYXRlX3BhZ2VzX3Blcl9jbGllbnQoKTsKIAlzcGluX3VubG9jaygmZG1fY3J5cHRfY2xpZW50
c19sb2NrKTsKKworCWRtX2F1ZGl0X2xvZ190YXJnZXQoRE1fTVNHX1BSRUZJWCwgImR0ciIsIHRp
LCAxKTsKIH0KIAogc3RhdGljIGludCBjcnlwdF9jdHJfaXZtb2RlKHN0cnVjdCBkbV90YXJnZXQg
KnRpLCBjb25zdCBjaGFyICppdm1vZGUpCkBAIC0zMzU3LDkgKzMzNzAsMTEgQEAgc3RhdGljIGlu
dCBjcnlwdF9jdHIoc3RydWN0IGRtX3RhcmdldCAqdGksIHVuc2lnbmVkIGludCBhcmdjLCBjaGFy
ICoqYXJndikKIAl0aS0+bnVtX2ZsdXNoX2Jpb3MgPSAxOwogCXRpLT5saW1pdF9zd2FwX2Jpb3Mg
PSB0cnVlOwogCisJZG1fYXVkaXRfbG9nX3RhcmdldChETV9NU0dfUFJFRklYLCAiY3RyIiwgdGks
IDEpOwogCXJldHVybiAwOwogCiBiYWQ6CisJZG1fYXVkaXRfbG9nX3RhcmdldChETV9NU0dfUFJF
RklYLCAiY3RyIiwgdGksIDApOwogCWNyeXB0X2R0cih0aSk7CiAJcmV0dXJuIHJldDsKIH0KLS0g
CjIuMjAuMQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

