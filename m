Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D9BC432BE
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 32D0160F5C
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 32D0160F5C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380--FZt9JxjNP2VqMJ4n1-JTQ-1; Tue, 17 Aug 2021 03:26:33 -0400
X-MC-Unique: -FZt9JxjNP2VqMJ4n1-JTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9E29802935;
	Tue, 17 Aug 2021 07:26:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98FA11036D20;
	Tue, 17 Aug 2021 07:26:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5DC70181A2A6;
	Tue, 17 Aug 2021 07:26:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17EIYlwv016574 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 14 Aug 2021 14:34:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 29C492166B14; Sat, 14 Aug 2021 18:34:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24BAA2167804
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBDD80066D
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:47 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-233-y2hVs1P_MeOPr5BgF4frdw-1; Sat, 14 Aug 2021 14:34:44 -0400
X-MC-Unique: y2hVs1P_MeOPr5BgF4frdw-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1M2w0K-1mDrUz3jQa-003NuA; Sat, 14 Aug 2021 20:34:42 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Date: Sat, 14 Aug 2021 20:33:54 +0200
Message-Id: <20210814183359.4061-3-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:JRxIIEYVu7W68Mlh/36bVLtSpKe0BNTk++rItoE71sb3OJE4Ufu
	BpFoHbvkB//iZsXEAsC2Co76DE0Q+kNrHge4hduygWjDobaWfbxmwELVaBgfF55PCMHu/Xu
	Z2OYf1U6JRGFHRZOU/rJiuc5AddQyTU4f1hIFKYnj4x7Dg5vIu0fUd+T5g22lzULGoNN7OA
	TvyYEd4h2JRHtb+o8C7fQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:X5q4v+IdAAc=:GLSSLqkM8rMdNut5VEXjSC
	EFCqp3ZyUSfNhniV4bY8Ae5uH2LLKaIQqb96xiOyF4bRBgUx1T47x1J6v7ra/5+6AVleC66Wj
	HxVpofC48uR+6RHe2fh9V9HMTbwFZ/tuP8puKHiyF1Oz9kbD7wNKkl9PVpfjKLX/bMmcwRv1Z
	qFqtygxA+TRuhxpq6b41INGjIPU5VFbN0g1DYAyzbLcpPIUHZjjcSN0ftJOMLmwsoAwYvYgKB
	fyd7o8avsSSWg/cxUJ/u5y20CMkhCGBKY3bG8MJgvXetkPdbBrZwLLz1dgsrQWxEnm52lR6VI
	bzoZb9cY7Yq8xLn+F13bSXf4SsB9RbvXXXGr2lEN+gutdvcBt8zMoPQgC97kLCdgbDmWzFtgJ
	c5S7gVrA+yU9hnWNnvUU9Mugi6Xue+qJbUeTI2wMWWRybi+FkcYWYodjNeiq6sLxafPARoIQZ
	LWFiALVNgFudDkpWZrq/m3MZXpaayZ9aSXcH6QtwCbntmC0SMZvzuMRQ+z8KgYLOMVz6ut1Q4
	sAw4t+gsg1Sxf9rZAlPI8zwICiipi6YJKCSwMp1lzH+ZylqIEMpcd9S5tXPgdXBEBjNbQIGVG
	28o8e7dtfmzBWcXFsGvrAnHhVee7XBt+SU0FXrIa294UyOsl/trrQszxmFe9SoCsmrz0qPn1y
	L+POP9fV0dpz9VOH0SydmKDvenhv/NH1aO/te70Ygc6WoS92tE+fP2LzJMRACszxINZ6WKC5x
	VZc6uJ+4G+TMmU8amePPBj1kCpok3Ede4EnYdqFHc062ngqdQ7Gz3VFrTi6Ty3S9TVXmHZ5DJ
	A6zRiFN0VD1VmmmwZSK/S1CD/tS3AvfJpdPmAy8I/FxiofYqUMc73FJtEgi0ksWRSYSAzHTh0
	EhXKyUWaD29BEFm7XU3A==
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
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Paul Moore <paul@paul-moore.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v2 2/3] dm integrity: log audit events for
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

