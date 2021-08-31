Return-Path: <SRS0=gIOA=NX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C69C4320E
	for <dm-devel@archiver.kernel.org>; Wed,  1 Sep 2021 06:59:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC2AF61058
	for <dm-devel@archiver.kernel.org>; Wed,  1 Sep 2021 06:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CC2AF61058
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-7sOet9Q7N4CWnMMQNbYdMg-1; Wed, 01 Sep 2021 02:59:37 -0400
X-MC-Unique: 7sOet9Q7N4CWnMMQNbYdMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7148687D542;
	Wed,  1 Sep 2021 06:59:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FED35D6D5;
	Wed,  1 Sep 2021 06:59:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 26D04180B44F;
	Wed,  1 Sep 2021 06:59:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17VJPCUw008690 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 31 Aug 2021 15:25:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0EFA02138CF9; Tue, 31 Aug 2021 19:25:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 095F22138CF6
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 19:25:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E690E1066680
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 19:25:11 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-28-0oRncwVmNneAUlj74ZBgtg-1; Tue, 31 Aug 2021 15:25:08 -0400
X-MC-Unique: 0oRncwVmNneAUlj74ZBgtg-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA
	(Nemesis)
	id 1MDQqe-1mAjyU11LK-00AWVx; Tue, 31 Aug 2021 21:19:40 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Paul Moore <paul@paul-moore.com>, Casey Schaufler <casey@schaufler-ca.com>
Date: Tue, 31 Aug 2021 21:18:40 +0200
Message-Id: <20210831191845.7928-4-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
References: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:IrWO8hNKbUyJGbXkVzHd+rTfxnWDoZDtfPQ4TxlfEze/ruCXXJr
	/D15kCdQ3XnRZyT89l2wgZjhnoLP1M7LGpXR6f8TOEkx6SOc1MMHDa//EcvKMPvgFEeVWiP
	WP5L3h8DnDFkF8lfM/QLvkd43Ado7xyGNgBni4D+aOin0kiBbAuxnWuOuvK3KpUj5yGenw9
	2D8HiY7EzjytAcFhlzasw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CTuBvTw9YVw=:gCznCSJS83VW1fOCHE6xEj
	xkm8EuEfuoFIWTIMyTHFcHBrt4h2KOZh2nrJvGtlfIy0l05IpeWpfvtV/CiMak1dzEIg9ugDX
	GHfWOEXMP4cjC9dTU6+1F77/us4dS61gLCNn2hSwmvreDveUZ1NUNGqifEfHSB1K9mUXco3cW
	qiLwz6qEFKVSdCPquo0D3iMETwso4kPerVlk6q+6do1a0mPAfQd9Ek1GRdpiF/my/fjuZAkas
	pmYa9WnjY+DfXafvSW3ehBfRcngIHvfrS5oWu5Vj+KMdez0xVAKMmedVG/ZNPBus/s2dwaWCi
	xODpzkoTt8gD82vUQXOCx/jr3Nqn6gNTJwBGVoVx9Qw6+sYxg+2nF6GjXx6nzBj7hWB2PIv57
	WHn4w1DJG4bqI1b8r7evyKLAAEgQ0muiqdyp/IJQlrqnHqJ302WE/Svsq0Mxc6Pebjj50ZYfv
	zq2Y8U1CliFzAZb4KaEdfk1eIJt8sdErEum/AEcQa0oT1oLgZa6z7R01WFR9OvAexC/fQU+hz
	DW+rDU2sHm8e9cLkxb+db7T8lXxsKehHOeP3EgOheVuYClIpJ86nDZ1ssdVQkqy09MUXVVUv0
	qzbNkh5yAGsPQvvmfQpQFUMVfJnvA0XqZw/L/ZteIdhZMoj7JyqSftM58zxURa9E85W5Kq9/p
	8KhxJAmZsyJMDXmlAOiuPA8/XY6bsYExdYvh21SHgnl6F/DPJ0TE3ro78+ZNkfrdEOLnystZD
	L8mdF1Mp0q0WM/FTAciBfRB2I2KcrtPkuB8Vhz3aDmzJX4XbkPbnTYX5vts=
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
X-Mailman-Approved-At: Wed, 01 Sep 2021 02:57:42 -0400
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v3 3/3] dm crypt: log aead integrity violations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

