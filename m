Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6901C678D4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677783989;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W6gXd9ExUGv54tEylbS6yXtsM1qu9HVEjh9QI48gdjI=;
	b=aKPeuylkJEzoojGTD5MOKfBIYMmx/L2aoh5fcjTvBUM9wr0SJv63F4/GGf7RTrb7IZmXBb
	KqQiQlUBk0ujEgU+SiffirCzu36ENIytQIiWTgRZtbflKE+9QU/gax9qnobBnM2TXJ9HzP
	2SqLsHRFYqv+5X/SReDflitPK2Vs6KE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-yRsbIaPpMKa6peuo9Kq15w-1; Thu, 02 Mar 2023 14:06:26 -0500
X-MC-Unique: yRsbIaPpMKa6peuo9Kq15w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B3E4857A94;
	Thu,  2 Mar 2023 19:06:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F20D4440D8;
	Thu,  2 Mar 2023 19:06:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C1C7619452CE;
	Thu,  2 Mar 2023 19:06:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 697FF19452CD
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 19:06:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5AF94440DC; Thu,  2 Mar 2023 19:06:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5347F440D8
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:06:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 329643C1834D
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:06:22 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-bXF1qiAlOWy7WFHfzqjHgA-1; Thu, 02 Mar 2023 14:06:20 -0500
X-MC-Unique: bXF1qiAlOWy7WFHfzqjHgA-1
Received: by mail-pf1-f176.google.com with SMTP id bd34so104591pfb.3
 for <dm-devel@redhat.com>; Thu, 02 Mar 2023 11:06:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677783979;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=j5esfVLMIlaF9LP/rwwpmV4S1kF4WuSj7Z9THxqYwh0=;
 b=OWvAbrgmxkaErqTy0BdrbNz7dcYdKcFJ4XsWLxa/LJBsG/tZfB+RIhPA7UhOJM31CV
 ZXjo7D/mMib5WWWn93tFnfOuCzxoH6KdbsyNGQzfd4jce4sJjcLD4cnzVqOFTciXLltU
 qFepE1WQ6acmMGkDdcz8jxJUx1V3OjTs9OGlzPLvFoFpkcYmOUGzPPAnJYaYuJ1fCyle
 8y5b0izw1X1nKtqU+onFaGERduYWfBVSSfWnmADZmZafegvRzSICqOP2VD5UEWReDCvi
 eMPl7MvUkl2l0rr2WMKnrCzxk4vlN4dLtE2mvS+zRWa809BYozq7hEOtaiNibT7t+cl1
 M8DQ==
X-Gm-Message-State: AO0yUKV37lyYF8BH/U+KHdd6plmW0XyMnkUGiqGKJ/7PDDeXBx5vDv6Q
 2AcJqFDrT6GYEtwnCeZvr0jy2zKajFI2WLdFeGC7
X-Google-Smtp-Source: AK7set8PWvLY+rxaVR0TcpyjbBjhxaI/Z6/f+upjt6eV1DGDo8C8lKrfXPzkHebf+bbYeLsHccZvtjxtnFnLroRq9ZY=
X-Received: by 2002:a63:8c1d:0:b0:503:2535:44c3 with SMTP id
 m29-20020a638c1d000000b00503253544c3mr3673307pgd.4.1677783979154; Thu, 02 Mar
 2023 11:06:19 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-9-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-9-git-send-email-wufan@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 2 Mar 2023 14:06:08 -0500
Message-ID: <CAHC9VhTh+z7O353Qc86kqF8URf0QfErG1qHPvzXCgH+6c-AJ4g@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC PATCH v9 08/16] ipe: add permissive toggle
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKYW4gMzAsIDIwMjMgYXQgNTo1OOKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxp
bnV4Lm1pY3Jvc29mdC5jb20+Cj4KPiBJUEUsIGxpa2UgU0VMaW51eCwgc3VwcG9ydHMgYSBwZXJt
aXNzaXZlIG1vZGUuIFRoaXMgbW9kZSBhbGxvd3MgcG9saWN5Cj4gYXV0aG9ycyB0byB0ZXN0IGFu
ZCBldmFsdWF0ZSBJUEUgcG9saWN5IHdpdGhvdXQgaXQgZWZmZWN0aW5nIHRoZWlyCj4gcHJvZ3Jh
bXMuIFdoZW4gdGhlIG1vZGUgaXMgY2hhbmdlZCwgYSAxNDA0IEFVRElUX01BQ19TVEFUVVMKPiBi
ZSByZXBvcnRlZC4KPgo+IFRoaXMgcGF0Y2ggYWRkcyB0aGUgZm9sbG93aW5nIGF1ZGl0IHJlY29y
ZHM6Cj4KPiAgIGF1ZGl0OiBNQUNfU1RBVFVTIHBlcm1pc3NpdmU9MSBhdWlkPTQyOTQ5NjcyOTUg
c2VzPTQyOTQ5NjcyOTUgbHNtPWlwZQo+ICAgICByZXM9MQo+ICAgYXVkaXQ6IE1BQ19TVEFUVVMg
cGVybWlzc2l2ZT0wIGF1aWQ9NDI5NDk2NzI5NSBzZXM9NDI5NDk2NzI5NSBsc209aXBlCj4gICAg
IHJlcz0xCj4KPiBUaGVzZSByZWNvcmRzIGFyZSBlbWl0dGVkIHdpdGhpbiB0aGUgZm9sbG93aW5n
IGV2ZW50czoKPgo+ICAgYXVkaXQ6IE1BQ19TVEFUVVMgcGVybWlzc2l2ZT0xIGF1aWQ9NDI5NDk2
NzI5NSBzZXM9NDI5NDk2NzI5NSBsc209aXBlCj4gICAgIHJlcz0xCj4gICBhdWRpdFsxODVdOiBT
WVNDQUxMIGFyY2g9YzAwMDAwM2Ugc3lzY2FsbD0xIHN1Y2Nlc3M9eWVzIGV4aXQ9MiBhMD0xCj4g
ICAgIGExPTU2MzA4YmIzZWNjMCBhMj0yIGEzPTdmMjkwZmRjNTNlMCBpdGVtcz0wIHBwaWQ9MTgz
IHBpZD0xODUKPiAgICAgYXVpZD00Mjk0OTY3Mjk1IHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTAg
ZnN1aWQ9MCBlZ2lkPTAgc2dpZD0wIGZzZ2lkPTAKPiAgICAgdHR5PXB0czAgc2VzPTQyOTQ5Njcy
OTUgY29tbT0iYmFzaCIgZXhlPSIvdXNyL2Jpbi9iYXNoIiBrZXk9KG51bGwpCj4gICBhdWRpdDog
UFJPQ1RJVExFIHByb2N0aXRsZT0iLWJhc2giCj4gICBhdWRpdDogTUFDX1NUQVRVUyBwZXJtaXNz
aXZlPTAgYXVpZD00Mjk0OTY3Mjk1IHNlcz00Mjk0OTY3Mjk1IGxzbT1pcGUKPiAgICAgcmVzPTEK
PiAgIGF1ZGl0WzE4NV06IFNZU0NBTEwgYXJjaD1jMDAwMDAzZSBzeXNjYWxsPTEgc3VjY2Vzcz15
ZXMgZXhpdD0yIGEwPTEKPiAgICAgYTE9NTYzMDhiYjNlY2MwIGEyPTIgYTM9N2YyOTBmZGM1M2Uw
IGl0ZW1zPTAgcHBpZD0xODMgcGlkPTE4NQo+ICAgICBhdWlkPTQyOTQ5NjcyOTUgdWlkPTAgZ2lk
PTAgZXVpZD0wIHN1aWQ9MCBmc3VpZD0wIGVnaWQ9MCBzZ2lkPTAgZnNnaWQ9MAo+ICAgICB0dHk9
cHRzMCBzZXM9NDI5NDk2NzI5NSBjb21tPSJiYXNoIiBleGU9Ii91c3IvYmluL2Jhc2giIGtleT0o
bnVsbCkKPiAgIGF1ZGl0OiBQUk9DVElUTEUgcHJvY3RpdGxlPSItYmFzaCIKPgo+ICAgSW1wbHlp
bmcgdXNlciB1c2VkIGJhc2ggdG8gdG9nZ2xlIHRoZSBzd2l0Y2guCj4KPiBTaWduZWQtb2ZmLWJ5
OiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4gU2lnbmVk
LW9mZi1ieTogRmFuIFd1IDx3dWZhbkBsaW51eC5taWNyb3NvZnQuY29tPgoKLi4uCgo+IC0tLQo+
ICBzZWN1cml0eS9pcGUvYXVkaXQuYyB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrCj4gIHNl
Y3VyaXR5L2lwZS9hdWRpdC5oIHwgIDEgKwo+ICBzZWN1cml0eS9pcGUvZXZhbC5jICB8ICA5ICsr
KysrKwo+ICBzZWN1cml0eS9pcGUvZXZhbC5oICB8ICAxICsKPiAgc2VjdXJpdHkvaXBlL2ZzLmMg
ICAgfCA2OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQo+ICA1
IGZpbGVzIGNoYW5nZWQsIDExNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Cj4gZGlm
ZiAtLWdpdCBhL3NlY3VyaXR5L2lwZS9hdWRpdC5jIGIvc2VjdXJpdHkvaXBlL2F1ZGl0LmMKPiBp
bmRleCAyOTVlOWY5ZjUxNDYuLmZmNzQwMjZhNTk1ZiAxMDA2NDQKPiAtLS0gYS9zZWN1cml0eS9p
cGUvYXVkaXQuYwo+ICsrKyBiL3NlY3VyaXR5L2lwZS9hdWRpdC5jCj4gQEAgLTE5NCwzICsxOTQs
MzkgQEAgdm9pZCBpcGVfYXVkaXRfcG9saWN5X2xvYWQoY29uc3Qgc3RydWN0IGlwZV9wb2xpY3kg
KmNvbnN0IHApCj4KPiAgICAgICAgIGF1ZGl0X2xvZ19lbmQoYWIpOwo+ICB9Cj4gKwo+ICsvKioK
PiArICogaXBlX2F1ZGl0X2VuZm9yY2UgLSBBdWRpdCBhIGNoYW5nZSBpbiBJUEUncyBlbmZvcmNl
bWVudCBzdGF0ZS4KPiArICovCj4gK3ZvaWQgaXBlX2F1ZGl0X2VuZm9yY2Uodm9pZCkKPiArewo+
ICsgICAgICAgc3RydWN0IGF1ZGl0X2J1ZmZlciAqYWI7Cj4gKwo+ICsgICAgICAgYWIgPSBhdWRp
dF9sb2dfc3RhcnQoYXVkaXRfY29udGV4dCgpLCBHRlBfS0VSTkVMLCBBVURJVF9NQUNfU1RBVFVT
KTsKPiArICAgICAgIGlmICghYWIpCj4gKyAgICAgICAgICAgICAgIHJldHVybjsKPiArCj4gKyAg
ICAgICBhdWRpdF9sb2dfZm9ybWF0KGFiLCAicGVybWlzc2l2ZT0lZCIsICFSRUFEX09OQ0UoZW5m
b3JjZSkpOwo+ICsgICAgICAgYXVkaXRfbG9nX2Zvcm1hdChhYiwgIiBhdWlkPSV1IHNlcz0ldSBs
c209aXBlIHJlcz0xIiwKPiArICAgICAgICAgICAgICAgICAgICAgICAgZnJvbV9rdWlkKCZpbml0
X3VzZXJfbnMsIGF1ZGl0X2dldF9sb2dpbnVpZChjdXJyZW50KSksCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgIGF1ZGl0X2dldF9zZXNzaW9uaWQoY3VycmVudCkpOwo+ICsKPiArICAgICAgIGF1
ZGl0X2xvZ19lbmQoYWIpOwo+ICt9CgpTZWUgdGhlIGVhcmxpZXIgY29tbWVudHMgaW4gdGhlIHBh
dGNoc2V0IGFib3V0IGNvbnNpc3RlbnQgZm9ybWF0dGluZwpvZiBhIGdpdmVuIHJlY29yZCB0eXBl
LiAgVG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlIG9ubHkgU0VMaW51eApjdXJyZW50bHkgdXNl
cyB0aGUgQVVESVRfTUFDX1NUQVRVUyByZWNvcmQgYW5kIGFuIGV4YW1wbGUgY2FuIGJlIGZvdW5k
CmluIGBzZWxfd3JpdGVfZW5mb3JjZSgpYC4gIFRoZSBnb29kIG5ld3MgaXMgdGhhdCBpdCBsb29r
cyBsaWtlIHRoYXQKZm9ybWF0IGNvdWxkIGJlIG1hZGUgdG8gd29yayBoZXJlIHdpdGhvdXQgdG9v
IG11Y2ggZnVzcy4KCj4gKy8qKgo+ICsgKiBlbWl0X2VuZm9yY2VtZW50IC0gRW1pdCB0aGUgZW5m
b3JjZW1lbnQgc3RhdGUgb2YgSVBFIHN0YXJ0ZWQgd2l0aC4KPiArICoKPiArICogUmV0dXJuOgo+
ICsgKiAwIC0gQWx3YXlzCj4gKyAqLwo+ICtzdGF0aWMgaW50IGVtaXRfZW5mb3JjZW1lbnQodm9p
ZCkKPiArewo+ICsgICAgICAgaWYgKCFpcGVfZW5hYmxlZCkKPiArICAgICAgICAgICAgICAgcmV0
dXJuIC1FT1BOT1RTVVBQOwo+ICsKPiArICAgICAgIGlwZV9hdWRpdF9lbmZvcmNlKCk7Cj4gKyAg
ICAgICByZXR1cm4gMDsKPiArfQo+ICsKPiArbGF0ZV9pbml0Y2FsbChlbWl0X2VuZm9yY2VtZW50
KTsKCi0tCnBhdWwtbW9vcmUuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

