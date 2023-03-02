Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EE1C7EE2F
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 19:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677783673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=poOBH4V2e/5CSdbxXaZ87pKTwPwcJlRZDsNPWS5FHXc=;
	b=OlUc0jWtduUPB0+Gdzio2LxWnS+5kbEUc6H3lfONQSqs1JwDwIwOitrqx5u562RIvvlXgH
	XVaL+h/rwyCEvsTHYXQ1AzGxLDzRXQTfkZHbB4wOza1Wce20tdk4iCo2m84HS7JHVqNuMI
	q5q2I2RHjjTLdMWg8wdAmGQXwEhVCnA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-YCLnd6m6Mk-UbFqAfJVutQ-1; Thu, 02 Mar 2023 14:01:11 -0500
X-MC-Unique: YCLnd6m6Mk-UbFqAfJVutQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D7041C05AC5;
	Thu,  2 Mar 2023 19:01:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 529451121315;
	Thu,  2 Mar 2023 19:01:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1046B19452D0;
	Thu,  2 Mar 2023 19:01:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C948419452D0
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 19:01:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AB8FA492C3E; Thu,  2 Mar 2023 19:01:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4B2C492B00
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:01:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83A093C0D865
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:01:03 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-423-i1HBUH7DOISecDNNj0viAQ-1; Thu, 02 Mar 2023 14:01:01 -0500
X-MC-Unique: i1HBUH7DOISecDNNj0viAQ-1
Received: by mail-pf1-f176.google.com with SMTP id y10so76121pfi.8
 for <dm-devel@redhat.com>; Thu, 02 Mar 2023 11:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677783660;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=sbKqTB1BWmST+UKS3o/pcnOIniBYA6/WBLEtc9haQn4=;
 b=oe49J5EoapNiVV35HMOTSRQMcMu/vE7zUxX9AHemAnPJR8vzBxxP9Cy0w/Q+gMMfvo
 N9AtvkZaPW6o3OtwqAd9nhItuKaysrZEWfHReJTv5QpfIUig6zPftObgc0SZbnH2bdnV
 Lp4HrzoXHzoA7UP6txR5dGOSMvEC7t9vBeceEfZtF2wwnuFmgZeUSgRJs7y19XkrDkDy
 t0fkIvems66wErEw2msA/0N5tcEVMejhif8JPbl6yrhoAHUX66ygS+dvKFk1zbUKvItx
 YFp5mI7Wktg56/yGxvtm0rnCUThJOoiGjiKPpFea4+3Wn3xeUa8w4mx4/yO/wyBIv8p+
 zB+Q==
X-Gm-Message-State: AO0yUKUCGZHIFA+x+tinohfbX/UmojzQk0UOgquHCHYIflyFN/UUj26u
 XFcjw6+as4nGLaI1NqGdwfwJCnP0D5QCEsZJl7Bl
X-Google-Smtp-Source: AK7set/JqphcjYj9seuvS6xKNvURMu+S3V/LEScKzhxHP7SqFb0AhXhOojS1vVfFsCMHm+0xdSDtgJ0BLFb+6ahFIIw=
X-Received: by 2002:a63:2953:0:b0:503:91ff:8dd8 with SMTP id
 bu19-20020a632953000000b0050391ff8dd8mr2858904pgb.4.1677783659129; Thu, 02
 Mar 2023 11:00:59 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-2-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-2-git-send-email-wufan@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 2 Mar 2023 14:00:48 -0500
Message-ID: <CAHC9VhTtXC=HMUF8uak-29E__xLN2Kh_znn0xdRbm-GkgqBNiA@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [RFC PATCH v9 01/16] security: add ipe lsm
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKYW4gMzAsIDIwMjMgYXQgNTo1OOKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxp
bnV4Lm1pY3Jvc29mdC5jb20+Cj4KPiBJbnRlZ3JpdHkgUG9saWN5IEVuZm9yY2VtZW50IChJUEUp
IGlzIGFuIExTTSB0aGF0IHByb3ZpZGVzIGFuCj4gY29tcGxpbWVudGFyeSBhcHByb2FjaCB0byBN
YW5kYXRvcnkgQWNjZXNzIENvbnRyb2wgdGhhbiBleGlzdGluZyBMU01zCj4gdG9kYXkuCj4KPiBF
eGlzdGluZyBMU01zIGhhdmUgY2VudGVyZWQgYXJvdW5kIHRoZSBjb25jZXB0IG9mIGFjY2VzcyB0
byBhIHJlc291cmNlCj4gc2hvdWxkIGJlIGNvbnRyb2xsZWQgYnkgdGhlIGN1cnJlbnQgdXNlcidz
IGNyZWRlbnRpYWxzLiBJUEUncyBhcHByb2FjaCwKPiBpcyB0aGF0IGFjY2VzcyB0byBhIHJlc291
cmNlIHNob3VsZCBiZSBjb250cm9sbGVkIGJ5IHRoZSBzeXN0ZW0ncyB0cnVzdAo+IG9mIGEgY3Vy
cmVudCByZXNvdXJjZS4KPgo+IFRoZSBiYXNpcyBvZiB0aGlzIGFwcHJvYWNoIGlzIGRlZmluaW5n
IGEgZ2xvYmFsIHBvbGljeSB0byBzcGVjaWZ5IHdoaWNoCj4gcmVzb3VyY2UgY2FuIGJlIHRydXN0
ZWQuCj4KPiBTaWduZWQtb2ZmLWJ5OiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxpbnV4Lm1p
Y3Jvc29mdC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogRmFuIFd1IDx3dWZhbkBsaW51eC5taWNyb3Nv
ZnQuY29tPgoKLi4uCgo+IC0tLQo+ICBNQUlOVEFJTkVSUyAgICAgICAgICAgfCAgNSArKysrKwo+
ICBzZWN1cml0eS9LY29uZmlnICAgICAgfCAxMSArKysrKystLS0tLQo+ICBzZWN1cml0eS9NYWtl
ZmlsZSAgICAgfCAgMSArCj4gIHNlY3VyaXR5L2lwZS9LY29uZmlnICB8IDE3ICsrKysrKysrKysr
KysrKysrCj4gIHNlY3VyaXR5L2lwZS9NYWtlZmlsZSB8IDEwICsrKysrKysrKysKPiAgc2VjdXJp
dHkvaXBlL2lwZS5jICAgIHwgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKwo+ICBzZWN1cml0eS9pcGUvaXBlLmggICAgfCAxMyArKysrKysrKysrKysrCj4gIDcgZmls
ZXMgY2hhbmdlZCwgOTIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9LY29uZmlnCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBzZWN1
cml0eS9pcGUvTWFrZWZpbGUKPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9pcGUu
Ywo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgc2VjdXJpdHkvaXBlL2lwZS5oCj4KPiBkaWZmIC0tZ2l0
IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwo+IGluZGV4IDhhNWMyNWMyMGQwMC4uNWUyN2U4
NDc2M2NjIDEwMDY0NAo+IC0tLSBhL01BSU5UQUlORVJTCj4gKysrIGIvTUFJTlRBSU5FUlMKPiBA
QCAtMTAyNzMsNiArMTAyNzMsMTEgQEAgVDogICAgIGdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvem9oYXIvbGludXgtaW50ZWdyaXR5LmdpdAo+ICBGOiAg
ICAgc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS8KPiAgRjogICAgIHNlY3VyaXR5L2ludGVncml0eS8K
Pgo+ICtJTlRFR1JJVFkgUE9MSUNZIEVORk9SQ0VNRU5UIChJUEUpCj4gK006ICAgICBGYW4gV3Ug
PHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4gK1M6ICAgICBTdXBwb3J0ZWQKPiArRjogICAg
IHNlY3VyaXR5L2lwZS8KCllvdSBzaG91bGQgcHJvYmFibHkgYWRkIGEgbWFpbGluZyBsaXN0IChM
OikgYW5kIHNvdXJjZSB0cmVlIFVSTCAoVDopCnRvIHRoZSBJUEUgZW50cnkuICBZb3UgY2FuIHVz
ZSB0aGUgTFNNIG1haWxpbmcgbGlzdCB0byBzdGFydCBpZiB5b3UKbGlrZSwgdGhlcmUgYXJlIHNl
dmVyYWwgTFNNcyB0aGF0IGRvIHRoYXQgdG9kYXksIGUuZy4gU21hY2ssIExhbmRsb2NrLApldGMu
ICBBcyBmYXIgYXMgdGhlIHNvdXJjZSB0cmVlIGlzIGNvbmNlcm5lZCwgcHJvYmFibHkgdGhlIGVh
c2llc3QKb3B0aW9uIGlzIGEgc2ltcGxlIEdpdEh1YiByZXBvLCBidXQgdGhlcmUgYXJlIHBsZW50
eSBvZiBvdGhlciBjaG9pY2VzCnRvby4KCkJvdGggdGhlIG1haWxpbmcgbGlzdCBhbmQgdGhlIHNv
dXJjZSBVUkxzIGNhbiBhbHdheXMgYmUgdXBkYXRlZCBpbiB0aGUKZnV0dXJlIHNvIGRvbid0IHdv
cnJ5IHRvbyBtdWNoIGFib3V0IGJlaW5nIHN0dWNrIHdpdGggZWl0aGVyIGxvbmcKdGVybS4KCi0t
CnBhdWwtbW9vcmUuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

