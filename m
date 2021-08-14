Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE1EC4320A
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0340960C3E
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0340960C3E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-uC0oFSR3O7SxtdrGKd9wcA-1; Tue, 17 Aug 2021 03:26:35 -0400
X-MC-Unique: uC0oFSR3O7SxtdrGKd9wcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0D66802B9F;
	Tue, 17 Aug 2021 07:26:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 656231036D28;
	Tue, 17 Aug 2021 07:26:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3AAA04A7CA;
	Tue, 17 Aug 2021 07:26:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17EIYmkl016580 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 14 Aug 2021 14:34:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CEF6A1102E12; Sat, 14 Aug 2021 18:34:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAE0D1000DA3
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3B1801E80
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:46 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-53-dsfSLrDpN3OgF1z1LjL38w-1; Sat, 14 Aug 2021 14:34:41 -0400
X-MC-Unique: dsfSLrDpN3OgF1z1LjL38w-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1MKsWr-1mVo140zoz-00LBjr; Sat, 14 Aug 2021 20:34:39 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Date: Sat, 14 Aug 2021 20:33:53 +0200
Message-Id: <20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:u2dVAf0ZtddTZ14NZnAn+TLJPTKr66gghVXqlc7nSaOPR30S8tm
	/vTMEXeV2herj/auuZ6GmRczRVzBiPpKjQGc3HvAWYhxvJJShSeSkPx91iykCtelfYg8lDA
	YpJXwh/MwmL51MPREQp7HSdH7LsYAoLdBKeQIJLf3xDddvO3k0YwU7TrbDp+Wi9ElfDaXZX
	HDZj9ZmzkSC4xejCor1lg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CkJ2RcV9QeA=:gppEzhMPUmegmipNa1YRZH
	ucN+CHFumHwjl2GrAJ4bbktvXHpaITvXsNn3+Ru3Fd7k+wbaIA7EAu33GLy8FCKSul5so9BFZ
	7KaKciA9+Z0NLcJ8ltXdo8xi8cY3U71h5m6AeF4hcz4KqH2ZylCdro4V8NN+wDZpsTn9vg2FA
	v8mPfECg9nzmI/79jTut7eUEXkjzHH2FaCr+il8VFhZGw9C/1ejVvVb64Y8ZyVbjQ3NtyFqG4
	/y2vJKl1uqUrSesDlLgpE/q9SkmdRYHTXbpQQttIAXTmllnoHYihgr/TJ9rz45rIohSr3GudT
	4Glg5iZh2YroYcDFnXt6m6pIbXeP2iQnSD3/tMvZdW2yVainCGunklvyp6w+bqt/aWKju5u4g
	tSdqz+ORIhguxnbSZr78n/qTRprPggyKO70wTnGxeoqfbwlDbQ1pB+odImml0l08WtBmKb3sl
	f3297NSW6G2MoNoRXmjNLFVqlhVdDlVh7KV16WIpqarmDbYowSpJJyZb++J+UTb8tZ6e2PwzF
	7v7K4nsOwpSGEjCMYkx2hOATVLo1zyAE+2JT2HhtdI9jzxaByGsvXFFwD/TEw3lfuKdXZ39Xg
	N9DRMORDqLcnDACLk/AlOM/gH3wLBuWDkBG9onMVrCnzCxCtOPgtBKCH4/H+DRiZzEDeEqoCG
	1Wzzh5BvtXf3reJI8JdN7PeQtCv/nS0a9aMUEIrqPM3wL9z0gZVPJYEZUrmlVOPR2A+61mYdX
	MFyXWf/T4mbdfqoiXuzQLLE1nCGCood5RxGh8yydd41pWOdNz9Ezun1XGbIpcvG/c9TmGb1B4
	8kimHkR7aB1huKNnbAZEsu/vKF0UCi26gmKWOspi0h3/L9/wBiOtOdupYMNxkuWZXNDIxVTl6
	eELTIsvwvXrG2kpU0qaA==
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
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Paul Moore <paul@paul-moore.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v2 1/3] dm: introduce audit event module for
	device mapper
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VG8gYmUgYWJsZSB0byBzZW5kIGF1ZGl0aW5nIGV2ZW50cyB0byB1c2VyIHNwYWNlLCB3ZSBpbnRy
b2R1Y2UKYSBnZW5lcmljIGRtLWF1ZGl0IG1vZHVsZS4gSXQgcHJvdmlkZXMgaGVscGVyIGZ1bmN0
aW9ucyB0byBlbWl0CmF1ZGl0IGV2ZW50cyB0aHJvdWdoIHRoZSBrZXJuZWwgYXVkaXQgc3Vic3lz
dGVtLiBXZSBjbGFpbSB0aGUKQVVESVRfRE0gdHlwZT0xMzM2IG91dCBvZiB0aGUgYXVkaXQgZXZl
bnQgbWVzc2FnZXMgcmFuZ2UgaW4gdGhlCmNvcnJlc3BvbmRpbmcgdXNlcnNwYWNlIGFwaSBpbiAn
aW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmgnIGZvcgp0aG9zZSBldmVudHMuCgpGb2xsb3dpbmcg
Y29tbWl0cyB0byBkZXZpY2UgbWFwcGVyIHRhcmdldHMgYWN0dWFsbHkgd2lsbCBtYWtlCnVzZSBv
ZiB0aGlzIHRvIGVtaXQgdGhvc2UgZXZlbnRzIGluIHJlbGV2YW50IGNhc2VzLgoKU2lnbmVkLW9m
Zi1ieTogTWljaGFlbCBXZWnDnyA8bWljaGFlbC53ZWlzc0BhaXNlYy5mcmF1bmhvZmVyLmRlPgot
LS0KIGRyaXZlcnMvbWQvS2NvbmZpZyAgICAgICAgIHwgMTAgKysrKysrKwogZHJpdmVycy9tZC9N
YWtlZmlsZSAgICAgICAgfCAgNCArKysKIGRyaXZlcnMvbWQvZG0tYXVkaXQuYyAgICAgIHwgNTkg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbWQvZG0tYXVk
aXQuaCAgICAgIHwgMzMgKysrKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL3VhcGkvbGludXgv
YXVkaXQuaCB8ICAxICsKIDUgZmlsZXMgY2hhbmdlZCwgMTA3IGluc2VydGlvbnMoKykKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0LmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL21kL2RtLWF1ZGl0LmgKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL0tjb25maWcgYi9k
cml2ZXJzL21kL0tjb25maWcKaW5kZXggMDYwMmU4MmE5NTE2Li40OGFkYmVjMTIxNDggMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWQvS2NvbmZpZworKysgYi9kcml2ZXJzL21kL0tjb25maWcKQEAgLTYw
OCw2ICs2MDgsNyBAQCBjb25maWcgRE1fSU5URUdSSVRZCiAJc2VsZWN0IENSWVBUTwogCXNlbGVj
dCBDUllQVE9fU0tDSVBIRVIKIAlzZWxlY3QgQVNZTkNfWE9SCisJc2VsZWN0IERNX0FVRElUIGlm
IEFVRElUCiAJaGVscAogCSAgVGhpcyBkZXZpY2UtbWFwcGVyIHRhcmdldCBlbXVsYXRlcyBhIGJs
b2NrIGRldmljZSB0aGF0IGhhcwogCSAgYWRkaXRpb25hbCBwZXItc2VjdG9yIHRhZ3MgdGhhdCBj
YW4gYmUgdXNlZCBmb3Igc3RvcmluZwpAQCAtNjQwLDQgKzY0MSwxMyBAQCBjb25maWcgRE1fWk9O
RUQKIAogCSAgSWYgdW5zdXJlLCBzYXkgTi4KIAorY29uZmlnIERNX0FVRElUCisJYm9vbCAiRE0g
YXVkaXQgZXZlbnRzIgorCWRlcGVuZHMgb24gQVVESVQKKwloZWxwCisJICBHZW5lcmF0ZSBhdWRp
dCBldmVudHMgZm9yIGRldmljZS1tYXBwZXIuCisKKwkgIEVuYWJsZXMgYXVkaXQgbG9nZ2luZyBv
ZiBzZXZlcmFsIHNlY3VyaXR5IHJlbGV2YW50IGV2ZW50cyBpbiB0aGUKKwkgIHBhcnRpY3VsYXIg
ZGV2aWNlLW1hcHBlciB0YXJnZXRzLCBlc3BlY2lhbGx5IHRoZSBpbnRlZ3JpdHkgdGFyZ2V0Lgor
CiBlbmRpZiAjIE1ECmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL01ha2VmaWxlIGIvZHJpdmVycy9t
ZC9NYWtlZmlsZQppbmRleCBhNzRhYWY4YjE0NDUuLjRjZDQ3NjIzYzc0MiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9tZC9NYWtlZmlsZQorKysgYi9kcml2ZXJzL21kL01ha2VmaWxlCkBAIC0xMDMsMyAr
MTAzLDcgQEAgZW5kaWYKIGlmZXEgKCQoQ09ORklHX0RNX1ZFUklUWV9WRVJJRllfUk9PVEhBU0hf
U0lHKSx5KQogZG0tdmVyaXR5LW9ianMJCQkrPSBkbS12ZXJpdHktdmVyaWZ5LXNpZy5vCiBlbmRp
ZgorCitpZmVxICgkKENPTkZJR19ETV9BVURJVCkseSkKK2RtLW1vZC1vYmpzCQkJCSs9IGRtLWF1
ZGl0Lm8KK2VuZGlmCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWF1ZGl0LmMgYi9kcml2ZXJz
L21kL2RtLWF1ZGl0LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5j
N2U1ODI0ODIxYmIKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL21kL2RtLWF1ZGl0LmMKQEAg
LTAsMCArMSw1OSBAQAorLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKKy8qCisg
KiBDcmVhdGluZyBhdWRpdCByZWNvcmRzIGZvciBtYXBwZWQgZGV2aWNlcy4KKyAqCisgKiBDb3B5
cmlnaHQgKEMpIDIwMjEgRnJhdW5ob2ZlciBBSVNFQy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4KKyAq
CisgKiBBdXRob3JzOiBNaWNoYWVsIFdlacOfIDxtaWNoYWVsLndlaXNzQGFpc2VjLmZyYXVuaG9m
ZXIuZGU+CisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2F1ZGl0Lmg+CisjaW5jbHVkZSA8bGludXgv
bW9kdWxlLmg+CisjaW5jbHVkZSA8bGludXgvZGV2aWNlLW1hcHBlci5oPgorI2luY2x1ZGUgPGxp
bnV4L2Jpby5oPgorI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPgorCisjaW5jbHVkZSAiZG0tYXVk
aXQuaCIKKyNpbmNsdWRlICJkbS1jb3JlLmgiCisKK3ZvaWQgZG1fYXVkaXRfbG9nX2Jpbyhjb25z
dCBjaGFyICpkbV9tc2dfcHJlZml4LCBjb25zdCBjaGFyICpvcCwKKwkJICAgICAgc3RydWN0IGJp
byAqYmlvLCBzZWN0b3JfdCBzZWN0b3IsIGludCByZXN1bHQpCit7CisJc3RydWN0IGF1ZGl0X2J1
ZmZlciAqYWI7CisKKwlpZiAoYXVkaXRfZW5hYmxlZCA9PSBBVURJVF9PRkYpCisJCXJldHVybjsK
KworCWFiID0gYXVkaXRfbG9nX3N0YXJ0KGF1ZGl0X2NvbnRleHQoKSwgR0ZQX0tFUk5FTCwgQVVE
SVRfRE0pOworCWlmICh1bmxpa2VseSghYWIpKQorCQlyZXR1cm47CisKKwlhdWRpdF9sb2dfZm9y
bWF0KGFiLCAibW9kdWxlPSVzIGRldj0lZDolZCBvcD0lcyBzZWN0b3I9JWxsdSByZXM9JWQiLAor
CQkJIGRtX21zZ19wcmVmaXgsIE1BSk9SKGJpby0+YmlfYmRldi0+YmRfZGV2KSwKKwkJCSBNSU5P
UihiaW8tPmJpX2JkZXYtPmJkX2RldiksIG9wLCBzZWN0b3IsIHJlc3VsdCk7CisJYXVkaXRfbG9n
X2VuZChhYik7Cit9CitFWFBPUlRfU1lNQk9MX0dQTChkbV9hdWRpdF9sb2dfYmlvKTsKKwordm9p
ZCBkbV9hdWRpdF9sb2dfdGFyZ2V0KGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNo
YXIgKm9wLAorCQkJIHN0cnVjdCBkbV90YXJnZXQgKnRpLCBpbnQgcmVzdWx0KQoreworCXN0cnVj
dCBhdWRpdF9idWZmZXIgKmFiOworCXN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCA9IGRtX3RhYmxl
X2dldF9tZCh0aS0+dGFibGUpOworCisJaWYgKGF1ZGl0X2VuYWJsZWQgPT0gQVVESVRfT0ZGKQor
CQlyZXR1cm47CisKKwlhYiA9IGF1ZGl0X2xvZ19zdGFydChhdWRpdF9jb250ZXh0KCksIEdGUF9L
RVJORUwsIEFVRElUX0RNKTsKKwlpZiAodW5saWtlbHkoIWFiKSkKKwkJcmV0dXJuOworCisJYXVk
aXRfbG9nX2Zvcm1hdChhYiwgIm1vZHVsZT0lcyBkZXY9JXMgb3A9JXMiLAorCQkJIGRtX21zZ19w
cmVmaXgsIGRtX2RldmljZV9uYW1lKG1kKSwgb3ApOworCisJaWYgKCFyZXN1bHQgJiYgIXN0cmNt
cCgiY3RyIiwgb3ApKQorCQlhdWRpdF9sb2dfZm9ybWF0KGFiLCAiIGVycm9yX21zZz0nJXMnIiwg
dGktPmVycm9yKTsKKwlhdWRpdF9sb2dfZm9ybWF0KGFiLCAiIHJlcz0lZCIsIHJlc3VsdCk7CisJ
YXVkaXRfbG9nX2VuZChhYik7Cit9CitFWFBPUlRfU1lNQk9MX0dQTChkbV9hdWRpdF9sb2dfdGFy
Z2V0KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tYXVkaXQuaCBiL2RyaXZlcnMvbWQvZG0t
YXVkaXQuaApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmI5ZTMxYjll
MzY4MgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMvbWQvZG0tYXVkaXQuaApAQCAtMCwwICsx
LDMzIEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLworLyoKKyAqIENy
ZWF0aW5nIGF1ZGl0IHJlY29yZHMgZm9yIG1hcHBlZCBkZXZpY2VzLgorICoKKyAqIENvcHlyaWdo
dCAoQykgMjAyMSBGcmF1bmhvZmVyIEFJU0VDLiBBbGwgcmlnaHRzIHJlc2VydmVkLgorICoKKyAq
IEF1dGhvcnM6IE1pY2hhZWwgV2Vpw58gPG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5k
ZT4KKyAqLworCisjaWZuZGVmIERNX0FVRElUX0gKKyNkZWZpbmUgRE1fQVVESVRfSAorCisjaW5j
bHVkZSA8bGludXgvZGV2aWNlLW1hcHBlci5oPgorCisjaWZkZWYgQ09ORklHX0RNX0FVRElUCit2
b2lkIGRtX2F1ZGl0X2xvZ19iaW8oY29uc3QgY2hhciAqZG1fbXNnX3ByZWZpeCwgY29uc3QgY2hh
ciAqb3AsCisJCSAgICAgIHN0cnVjdCBiaW8gKmJpbywgc2VjdG9yX3Qgc2VjdG9yLCBpbnQgcmVz
dWx0KTsKK3ZvaWQgZG1fYXVkaXRfbG9nX3RhcmdldChjb25zdCBjaGFyICpkbV9tc2dfcHJlZml4
LCBjb25zdCBjaGFyICpvcCwKKwkJCSBzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgaW50IHJlc3VsdCk7
CisjZWxzZQorc3RhdGljIGlubGluZSB2b2lkIGRtX2F1ZGl0X2xvZ19iaW8oY29uc3QgY2hhciAq
ZG1fbXNnX3ByZWZpeCwgY29uc3QgY2hhciAqb3AsCisJCQkJICAgIHN0cnVjdCBiaW8gKmJpbywg
c2VjdG9yX3Qgc2VjdG9yLAorCQkJCSAgICBpbnQgcmVzdWx0KQoreworfQorc3RhdGljIGlubGlu
ZSB2b2lkIGRtX2F1ZGl0X2xvZ190YXJnZXQoY29uc3QgY2hhciAqZG1fbXNnX3ByZWZpeCwKKwkJ
CQkgICAgICAgY29uc3QgY2hhciAqb3AsIHN0cnVjdCBkbV90YXJnZXQgKnRpLAorCQkJCSAgICAg
ICBpbnQgcmVzdWx0KQoreworfQorI2VuZGlmCisKKyNlbmRpZgpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2F1ZGl0LmggYi9pbmNsdWRlL3VhcGkvbGludXgvYXVkaXQuaAppbmRleCBk
YWE0ODE3MjllOWIuLmFlYmZlZWUxYzViMSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4
L2F1ZGl0LmgKKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmgKQEAgLTExOCw2ICsxMTgs
NyBAQAogI2RlZmluZSBBVURJVF9USU1FX0FESk5UUFZBTAkxMzMzCS8qIE5UUCB2YWx1ZSBhZGp1
c3RtZW50ICovCiAjZGVmaW5lIEFVRElUX0JQRgkJMTMzNAkvKiBCUEYgc3Vic3lzdGVtICovCiAj
ZGVmaW5lIEFVRElUX0VWRU5UX0xJU1RFTkVSCTEzMzUJLyogVGFzayBqb2luZWQgbXVsdGljYXN0
IHJlYWQgc29ja2V0ICovCisjZGVmaW5lIEFVRElUX0RNCQkxMzM2CS8qIERldmljZSBNYXBwZXIg
ZXZlbnRzICovCiAKICNkZWZpbmUgQVVESVRfQVZDCQkxNDAwCS8qIFNFIExpbnV4IGF2YyBkZW5p
YWwgb3IgZ3JhbnQgKi8KICNkZWZpbmUgQVVESVRfU0VMSU5VWF9FUlIJMTQwMQkvKiBJbnRlcm5h
bCBTRSBMaW51eCBFcnJvcnMgKi8KLS0gCjIuMjAuMQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==

