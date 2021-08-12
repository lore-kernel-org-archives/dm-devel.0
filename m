Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77959C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3FA560E93
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E3FA560E93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-6kPgpzuWMwuaV4WqLv2DMA-1; Fri, 13 Aug 2021 02:41:09 -0400
X-MC-Unique: 6kPgpzuWMwuaV4WqLv2DMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10E311082922;
	Fri, 13 Aug 2021 06:41:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E67360C9D;
	Fri, 13 Aug 2021 06:41:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F29E5181A0F2;
	Fri, 13 Aug 2021 06:41:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CF3e2i011480 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 11:03:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 55B7420AE82B; Thu, 12 Aug 2021 15:03:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50B6520AE835
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF80118A6534
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:38 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-113-84hih3YZM-28Hvm1kGbGVA-1; Thu, 12 Aug 2021 11:03:35 -0400
X-MC-Unique: 84hih3YZM-28Hvm1kGbGVA-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1M3lgJ-1mET0X338V-000uGk; Thu, 12 Aug 2021 16:58:14 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: michael.weiss@aisec.fraunhofer.de
Date: Thu, 12 Aug 2021 16:57:42 +0200
Message-Id: <20210812145748.4460-2-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:VRlAlfDB5Lnf+BVBMonU0Eg2eot1RoGDcs0IiBT5nDnqj9aaHft
	dcSLO6WONK888uP9aJqK6Aqb7ZQiPNlpUJu7M7xc4+bfDDsm3kxMGF1syUIKvVExAOAS0zo
	nwfgdVRl4NvB4ox9dfl4dEhENW7JEr4Vv4lV6bu39wfwADLoMcUIPK0LFtBy2DC9O/Mppvk
	/3X0q9IUYsRk56eLtLtbA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DnlpQKNvJJQ=:KffVPKphi5VzcyJXqM25G7
	w78eYYosa3qJNrzWTt6CA7LDELC4HrQRaZPJNNkVAMLQXRBfXMFPgOneB78KaD3tNYWHRjZ5J
	tGjJlq95R5T9Apkkaw9wWK4neeaJLzCCG1pvWUcROb0ysQdljZIx8nm6AjBbCcWELTQHy0exV
	32lD7nDWDdSKsafgqJiw9u28OpsLszm3ObJpDLu5XKjaS6Co2PWDdvgzZYeMUdHdz6ag0LqX6
	MK0WoqHrOmGE5UIuWUPV0m9I0DS8UZOLcEOUJWeVb1abpV25TWICO4TTVhweiUEjVjC5qDN1/
	w3WMxy2skgKR5+XREXSG+pybsDIkYhTTJZJ/FmmwAqkeJ+aObL+fZz1SxMHcG+hHTElhcUfyk
	1MtSnbzkV7PiVh2vr2WLAnksb/almelqdjipa1CkEkr967qjS17+atHbLkGbKvAkLC8Og58MW
	VGmLlx4P24uaWw45P988VPjYrAPFyiaxdMiV5u06RxUPS5WqwzDPhFgNkXi4vcx878UDZX7Tn
	PTJ9zaYg/k9FXZrwKJM+49kqUQZk11DNUglKDvdkMsesOnz2G9sHoyBV4oiqNjHTQf3+4xWpZ
	L/fQWGS74Hc+vsgNdOYHpl78wpCu3tOwis5N7KQ1xxeKGOlKeE60ZpTlp6FrAx6/SD3BfU6R3
	CfUDAkNAI7EC1DW6g8HzfEaudCHcj3VlONH22BBf9mVnEjt8y+pQHxcbitCn0Xl7fY6KTlt0Y
	9Ptu+JqYaH2/hqyXNORxQzpehGLmAPIRNL/wtwK3HNRQsdbRQanTYv49AtkAFSyNrDLScXZgK
	lL+IJtOMq9w86AOT85ZYJTRYFhQ8fKbIc+PysZOYZVT8shZP6fuSenAjXZoLfQ0kZTqfODvmB
	3/rSnJWUdhY5t/INAgIQ==
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
X-Mailman-Approved-At: Fri, 13 Aug 2021 02:36:56 -0400
Cc: Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 1/3] dm: introduce audit event module for device
	mapper
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
YXVkaXQuaCB8ICAyICsrCiA1IGZpbGVzIGNoYW5nZWQsIDEwOCBpbnNlcnRpb25zKCspCiBjcmVh
dGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRpdC5jCiBjcmVhdGUgbW9kZSAxMDA2NDQg
ZHJpdmVycy9tZC9kbS1hdWRpdC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9LY29uZmlnIGIv
ZHJpdmVycy9tZC9LY29uZmlnCmluZGV4IDA2MDJlODJhOTUxNi4uZmQ1NGM3MTNhMDNlIDEwMDY0
NAotLS0gYS9kcml2ZXJzL21kL0tjb25maWcKKysrIGIvZHJpdmVycy9tZC9LY29uZmlnCkBAIC02
MDgsNiArNjA4LDcgQEAgY29uZmlnIERNX0lOVEVHUklUWQogCXNlbGVjdCBDUllQVE8KIAlzZWxl
Y3QgQ1JZUFRPX1NLQ0lQSEVSCiAJc2VsZWN0IEFTWU5DX1hPUgorCXNlbGVjdCBETV9BVURJVCBp
ZiBBVURJVAogCWhlbHAKIAkgIFRoaXMgZGV2aWNlLW1hcHBlciB0YXJnZXQgZW11bGF0ZXMgYSBi
bG9jayBkZXZpY2UgdGhhdCBoYXMKIAkgIGFkZGl0aW9uYWwgcGVyLXNlY3RvciB0YWdzIHRoYXQg
Y2FuIGJlIHVzZWQgZm9yIHN0b3JpbmcKQEAgLTY0MCw0ICs2NDEsMTMgQEAgY29uZmlnIERNX1pP
TkVECiAKIAkgIElmIHVuc3VyZSwgc2F5IE4uCiAKK2NvbmZpZyBETV9BVURJVAorCWJvb2wgIkRN
IGF1ZGl0IGV2ZW50cyIKKwlkZXBlbmRzIG9uIEFVRElUCisJaGVscAorCSAgR2VuZXJhdGUgYXVk
aXQgZXZlbnRzIGZvciBkZXZpY2UtbWFwcGVyLgorCisJICBFbmFibGVzIGF1ZGl0IGxvZ2luZyBv
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
YXVkaXQuaApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjlkYjQ5NTVk
MzJlMQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMvbWQvZG0tYXVkaXQuaApAQCAtMCwwICsx
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
c2VjdG9yX3Qgc2VjdG9yLAorCQkJCSAgICBpbnQgcmVzdWx0KTsKK3sKK30KK3N0YXRpYyBpbmxp
bmUgdm9pZCBkbV9hdWRpdF9sb2dfdGFyZ2V0KGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsCisJ
CQkJICAgICAgIGNvbnN0IGNoYXIgKm9wLCBzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwKKwkJCQkgICAg
ICAgaW50IHJlc3VsdCk7Cit7Cit9CisjZW5kaWYKKworI2VuZGlmCmRpZmYgLS1naXQgYS9pbmNs
dWRlL3VhcGkvbGludXgvYXVkaXQuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9hdWRpdC5oCmluZGV4
IGRhYTQ4MTcyOWU5Yi4uOWQ3NjZmY2JjZjYyIDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGlu
dXgvYXVkaXQuaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYXVkaXQuaApAQCAtMTE4LDYgKzEx
OCw3IEBACiAjZGVmaW5lIEFVRElUX1RJTUVfQURKTlRQVkFMCTEzMzMJLyogTlRQIHZhbHVlIGFk
anVzdG1lbnQgKi8KICNkZWZpbmUgQVVESVRfQlBGCQkxMzM0CS8qIEJQRiBzdWJzeXN0ZW0gKi8K
ICNkZWZpbmUgQVVESVRfRVZFTlRfTElTVEVORVIJMTMzNQkvKiBUYXNrIGpvaW5lZCBtdWx0aWNh
c3QgcmVhZCBzb2NrZXQgKi8KKyNkZWZpbmUgQVVESVRfRE0JCTEzMzYJLyogRGV2aWNlIE1hcHBl
ciBldmVudHMgKi8KIAogI2RlZmluZSBBVURJVF9BVkMJCTE0MDAJLyogU0UgTGludXggYXZjIGRl
bmlhbCBvciBncmFudCAqLwogI2RlZmluZSBBVURJVF9TRUxJTlVYX0VSUgkxNDAxCS8qIEludGVy
bmFsIFNFIExpbnV4IEVycm9ycyAqLwpAQCAtMTQwLDYgKzE0MSw3IEBACiAjZGVmaW5lIEFVRElU
X01BQ19DQUxJUFNPX0FERAkxNDE4CS8qIE5ldExhYmVsOiBhZGQgQ0FMSVBTTyBET0kgZW50cnkg
Ki8KICNkZWZpbmUgQVVESVRfTUFDX0NBTElQU09fREVMCTE0MTkJLyogTmV0TGFiZWw6IGRlbCBD
QUxJUFNPIERPSSBlbnRyeSAqLwogCisKICNkZWZpbmUgQVVESVRfRklSU1RfS0VSTl9BTk9NX01T
RyAgIDE3MDAKICNkZWZpbmUgQVVESVRfTEFTVF9LRVJOX0FOT01fTVNHICAgIDE3OTkKICNkZWZp
bmUgQVVESVRfQU5PTV9QUk9NSVNDVU9VUyAgICAgIDE3MDAgLyogRGV2aWNlIGNoYW5nZWQgcHJv
bWlzY3VvdXMgbW9kZSAqLwotLSAKMi4yMC4xCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

