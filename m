Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBB2EE021A
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 02:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694660045;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jBUy17nr3bPW9syB+VMiwBDVs7IuAjOcI8u/rpZRHsI=;
	b=Td5se6yGIMgVk6kWyCi0cPZETKMR7XJjk3/tK0yFdU395gjXc++wMtQ+xE6XJnVbkT1hA8
	W/E1hH/Se6xo/rNm1J+nQGKlxM+oU+WaMZDc/8sNS6rzSZc7glcAs0yB7Ep3zRup9iclKY
	jmxoPdmByjrGY5yTQ6OU9mmmvhcglwE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-k8qkj92wMPWU9-rTJ8UHkg-1; Wed, 13 Sep 2023 22:54:02 -0400
X-MC-Unique: k8qkj92wMPWU9-rTJ8UHkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D52085570E;
	Thu, 14 Sep 2023 02:54:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A04922156721;
	Thu, 14 Sep 2023 02:53:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EFCE19465B5;
	Thu, 14 Sep 2023 02:53:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4D77919465B1
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 02:53:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08EB82156722; Thu, 14 Sep 2023 02:53:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01A7E2156721
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 02:53:56 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D490C805B29
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 02:53:56 +0000 (UTC)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-W6KIgW7AMqWnD_0aSx0ceQ-1; Wed, 13 Sep 2023 22:53:55 -0400
X-MC-Unique: W6KIgW7AMqWnD_0aSx0ceQ-1
Received: by mail-pj1-f69.google.com with SMTP id
 98e67ed59e1d1-26b752bc74fso412786a91.2
 for <dm-devel@redhat.com>; Wed, 13 Sep 2023 19:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694660034; x=1695264834;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=79Pt1h07snqQgLqURn+X2LUbFiUGOvFlgIEpyAPEPwA=;
 b=OXXuHAtF5woLp1pqpnCYK8Mf09LeMnkfL4q/1Ya8u0Xx58RKcvNjOxR0zRUG9OGpl3
 L/pRoJYGO6yOvykKkWiiKIOiE8jeiF78FIUkwJqq0tbnjRnQgiBfj589wKteulukfXWH
 5ByE90lUNdApwz7aDeJe19cYx60CiiIfzqmj4BTiNDmPJAZgIYWcMdeqi4tRHSnBYcTZ
 rHA0AHB1JT8spXukO06hvGmoLjR0BQHtAay8LcGAuEe3pfG+kRBloRHke7p8L6/OP8AZ
 qZ4snqcTL5H6D8IF9iGR5+4JMIGow4aJ8obE8iHEshFTIuMRBB78f/pk3R72+74/liz0
 IGZA==
X-Gm-Message-State: AOJu0YxWdgRA1Y8qWceRQjqnESOJ8VkHAvm1NwYAbs7ElOYVmk1EzXiN
 c6RX8pB1vQ/LyaGCR1fgwfkQayY3oyqt3GDsW9VEAOKAMKnVM+Y9qUIJzLxfc30KCq1lAZUA++J
 BXsO4GXQv0OqVzaiAp4g/TwOv1eSBpjI=
X-Received: by 2002:a17:90b:e91:b0:268:f987:305d with SMTP id
 fv17-20020a17090b0e9100b00268f987305dmr4020246pjb.5.1694660034367; 
 Wed, 13 Sep 2023 19:53:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi2VFjCUSN7OBpxQVIme3+SE2HYZ6exMH5klV6ao7jQvDUKQlgbnRiJ1efcAAWy6Z8PoxjrXE7/8b1wykrEIQ=
X-Received: by 2002:a17:90b:e91:b0:268:f987:305d with SMTP id
 fv17-20020a17090b0e9100b00268f987305dmr4020231pjb.5.1694660034080; Wed, 13
 Sep 2023 19:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
 <20230828020021.2489641-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 14 Sep 2023 10:53:41 +0800
Message-ID: <CALTww28MiiWTOyLYHErAZWTzn8iGif5=adY7yohxmn1OxrpK=w@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 01/28] md: use READ_ONCE/WRITE_ONCE
 for 'suspend_lo' and 'suspend_hi'
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgMjgsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdl
aWNsb3VkLmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+
Cj4KPiBCZWNhdXNlIHJlYWRpbmcgJ3N1c3BlbmRfbG8nIGFuZCAnc3VzcGVuZF9oaScgZnJvbSBt
ZF9oYW5kbGVfcmVxdWVzdCgpCj4gaXMgbm90IHByb3RlY3RlZCwgdXNlIFJFQURfT05DRS9XUklU
RV9PTkNFIHRvIHByZXZlbnQgcmVhZGluZyBhYm5vcm1hbAo+IHZhbHVlLgoKSGkgS3VhaQoKSWYg
d2UgZG9uJ3QgdXNlIFJFQURfT05DRS9XUklURV9PTkNFLCBXaGF0J3MgdGhlIHJpc2sgaGVyZT8g
Q291bGQgeW91CmV4cGxhaW4gaW4gZGV0YWlsIG9yIGdpdmUgYW4gZXhhbXBsZT8KClJlZ2FyZHMK
WGlhbwo+Cj4gU2lnbmVkLW9mZi1ieTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+IC0t
LQo+ICBkcml2ZXJzL21kL21kLmMgfCAxNiArKysrKysrKystLS0tLS0tCj4gIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZC9tZC5jIGIvZHJpdmVycy9tZC9tZC5jCj4gaW5kZXggNDZiYWRkMTNhNjg3Li45ZDhk
ZmY5ZDkyM2MgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9tZC5jCj4gKysrIGIvZHJpdmVycy9t
ZC9tZC5jCj4gQEAgLTM1OSwxMSArMzU5LDExIEBAIHN0YXRpYyBib29sIGlzX3N1c3BlbmRlZChz
dHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlvICpiaW8pCj4gICAgICAgICAgICAgICAgIHJl
dHVybiB0cnVlOwo+ICAgICAgICAgaWYgKGJpb19kYXRhX2RpcihiaW8pICE9IFdSSVRFKQo+ICAg
ICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7Cj4gLSAgICAgICBpZiAobWRkZXYtPnN1c3BlbmRf
bG8gPj0gbWRkZXYtPnN1c3BlbmRfaGkpCj4gKyAgICAgICBpZiAoUkVBRF9PTkNFKG1kZGV2LT5z
dXNwZW5kX2xvKSA+PSBSRUFEX09OQ0UobWRkZXYtPnN1c3BlbmRfaGkpKQo+ICAgICAgICAgICAg
ICAgICByZXR1cm4gZmFsc2U7Cj4gLSAgICAgICBpZiAoYmlvLT5iaV9pdGVyLmJpX3NlY3RvciA+
PSBtZGRldi0+c3VzcGVuZF9oaSkKPiArICAgICAgIGlmIChiaW8tPmJpX2l0ZXIuYmlfc2VjdG9y
ID49IFJFQURfT05DRShtZGRldi0+c3VzcGVuZF9oaSkpCj4gICAgICAgICAgICAgICAgIHJldHVy
biBmYWxzZTsKPiAtICAgICAgIGlmIChiaW9fZW5kX3NlY3RvcihiaW8pIDwgbWRkZXYtPnN1c3Bl
bmRfbG8pCj4gKyAgICAgICBpZiAoYmlvX2VuZF9zZWN0b3IoYmlvKSA8IFJFQURfT05DRShtZGRl
di0+c3VzcGVuZF9sbykpCj4gICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsKPiAgICAgICAg
IHJldHVybiB0cnVlOwo+ICB9Cj4gQEAgLTUxNzEsNyArNTE3MSw4IEBAIF9fQVRUUihzeW5jX21h
eCwgU19JUlVHT3xTX0lXVVNSLCBtYXhfc3luY19zaG93LCBtYXhfc3luY19zdG9yZSk7Cj4gIHN0
YXRpYyBzc2l6ZV90Cj4gIHN1c3BlbmRfbG9fc2hvdyhzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjaGFy
ICpwYWdlKQo+ICB7Cj4gLSAgICAgICByZXR1cm4gc3ByaW50ZihwYWdlLCAiJWxsdVxuIiwgKHVu
c2lnbmVkIGxvbmcgbG9uZyltZGRldi0+c3VzcGVuZF9sbyk7Cj4gKyAgICAgICByZXR1cm4gc3By
aW50ZihwYWdlLCAiJWxsdVxuIiwKPiArICAgICAgICAgICAgICAgICAgICAgICh1bnNpZ25lZCBs
b25nIGxvbmcpUkVBRF9PTkNFKG1kZGV2LT5zdXNwZW5kX2xvKSk7Cj4gIH0KPgo+ICBzdGF0aWMg
c3NpemVfdAo+IEBAIC01MTkxLDcgKzUxOTIsNyBAQCBzdXNwZW5kX2xvX3N0b3JlKHN0cnVjdCBt
ZGRldiAqbWRkZXYsIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGxlbikKPiAgICAgICAgICAgICAg
ICAgcmV0dXJuIGVycjsKPgo+ICAgICAgICAgbWRkZXZfc3VzcGVuZChtZGRldik7Cj4gLSAgICAg
ICBtZGRldi0+c3VzcGVuZF9sbyA9IG5ldzsKPiArICAgICAgIFdSSVRFX09OQ0UobWRkZXYtPnN1
c3BlbmRfbG8sIG5ldyk7Cj4gICAgICAgICBtZGRldl9yZXN1bWUobWRkZXYpOwo+Cj4gICAgICAg
ICBtZGRldl91bmxvY2sobWRkZXYpOwo+IEBAIC01MjAzLDcgKzUyMDQsOCBAQCBfX0FUVFIoc3Vz
cGVuZF9sbywgU19JUlVHT3xTX0lXVVNSLCBzdXNwZW5kX2xvX3Nob3csIHN1c3BlbmRfbG9fc3Rv
cmUpOwo+ICBzdGF0aWMgc3NpemVfdAo+ICBzdXNwZW5kX2hpX3Nob3coc3RydWN0IG1kZGV2ICpt
ZGRldiwgY2hhciAqcGFnZSkKPiAgewo+IC0gICAgICAgcmV0dXJuIHNwcmludGYocGFnZSwgIiVs
bHVcbiIsICh1bnNpZ25lZCBsb25nIGxvbmcpbWRkZXYtPnN1c3BlbmRfaGkpOwo+ICsgICAgICAg
cmV0dXJuIHNwcmludGYocGFnZSwgIiVsbHVcbiIsCj4gKyAgICAgICAgICAgICAgICAgICAgICAo
dW5zaWduZWQgbG9uZyBsb25nKVJFQURfT05DRShtZGRldi0+c3VzcGVuZF9oaSkpOwo+ICB9Cj4K
PiAgc3RhdGljIHNzaXplX3QKPiBAQCAtNTIyMyw3ICs1MjI1LDcgQEAgc3VzcGVuZF9oaV9zdG9y
ZShzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjb25zdCBjaGFyICpidWYsIHNpemVfdCBsZW4pCj4gICAg
ICAgICAgICAgICAgIHJldHVybiBlcnI7Cj4KPiAgICAgICAgIG1kZGV2X3N1c3BlbmQobWRkZXYp
Owo+IC0gICAgICAgbWRkZXYtPnN1c3BlbmRfaGkgPSBuZXc7Cj4gKyAgICAgICBXUklURV9PTkNF
KG1kZGV2LT5zdXNwZW5kX2hpLCBuZXcpOwo+ICAgICAgICAgbWRkZXZfcmVzdW1lKG1kZGV2KTsK
Pgo+ICAgICAgICAgbWRkZXZfdW5sb2NrKG1kZGV2KTsKPiAtLQo+IDIuMzkuMgo+CgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

