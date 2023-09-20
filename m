Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C16CE79AC
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 08:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695199983;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xbEyqNQ5+dgciOkl3n+pq9DOo8rTIZIxCoMQCOrk8EM=;
	b=WtLXFHD6iwluXPmkBodlOk9DY6pezb51R9OQ4xrPzUHK3b8zA62o2bMkH6yDkJf4AT6Qz3
	qWebfIVnvUDm0ZrvdQ9hSYe7HpE1H2ILc4R6JYueg8G3nyxFAHSCtHv+ixjlSirCUC42gR
	pF9q9iWt04m3CzrlVMpoLH7Hfox3MK4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-6dZPqgcLPmesgf71SE7mPg-1; Wed, 20 Sep 2023 04:52:59 -0400
X-MC-Unique: 6dZPqgcLPmesgf71SE7mPg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07039101B047;
	Wed, 20 Sep 2023 08:52:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA766492B16;
	Wed, 20 Sep 2023 08:52:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 814FB194658D;
	Wed, 20 Sep 2023 08:52:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBC59194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:46:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A54E492B05; Wed, 20 Sep 2023 08:46:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82FAB492C37
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:46:41 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E75A185A79B
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:46:57 +0000 (UTC)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-bAp-_i-SOv2AaDuVW96LJQ-1; Wed, 20 Sep 2023 04:46:55 -0400
X-MC-Unique: bAp-_i-SOv2AaDuVW96LJQ-1
Received: by mail-pf1-f199.google.com with SMTP id
 d2e1a72fcca58-690a0eedb24so2260904b3a.1
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 01:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695199615; x=1695804415;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=14VM4X1q7LDh2tjcesU2z1sSQLPjnF+BKTQYi/I+DZ8=;
 b=Hkkwfdmb2FUu/zT7XlklJt9asWC2/PHEZ9AlGlbqgCzOl8sYtxf3aT3JDosaAsdmd5
 6DdRRYiiLTS/b9b3+WuyUqwibE0u4LZZwp3xY0fJmnLkuyUF8kqDDevMCGiDMaDs3zFa
 jt2tuiOWfBRJfMJAdIqEUCV88t9iONBM2iX9JQ7MMF/i5Afio8L7UJe6fIiEjSta8ji/
 kfPxgr9gxHynOPaDYaW7MqR2FBaLX2lTXxIPGZoopF41rqD710UsTwe8VyvmOd6dgB6J
 AVZ7yUgDFL7N5uN5mLTMRmtsIqyTmmnMmmOf/6O3YCEIvDVoN4/MQMUa6UdXpM/z+N9R
 NUeA==
X-Gm-Message-State: AOJu0YyQjdYPuTcPjyYDAF8Pj/H9n+d7HET+oz1No79xddnh1kC/reJK
 mEUAvFyIyceru80w/g2IEnsKJ4lTUwun6aCiWsVSZUHOL6RsRlBv9IOl0htusiUKbA/QkAKdkvG
 z0ZBlQvI9pl1TKe5W3tRcTwGIfWj0Wzc=
X-Received: by 2002:a05:6a20:7f9d:b0:13d:df16:cf29 with SMTP id
 d29-20020a056a207f9d00b0013ddf16cf29mr2570683pzj.15.1695199614995; 
 Wed, 20 Sep 2023 01:46:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQli6HeenG+HwcwmKNeEDbJ29I1E4luWIpovCpMd3Ahw3uOsfer9qoclzc94KX8UwaBMSafHxbTeav+Z1H7aY=
X-Received: by 2002:a05:6a20:7f9d:b0:13d:df16:cf29 with SMTP id
 d29-20020a056a207f9d00b0013ddf16cf29mr2570673pzj.15.1695199614768; Wed, 20
 Sep 2023 01:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
 <20230828020021.2489641-3-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 20 Sep 2023 16:46:42 +0800
Message-ID: <CALTww29iHX_GHogGFEfzdaDjohBr8ycfiz2=E_ru4JYvmrTYdA@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH -next v2 02/28] md: use 'mddev->suspended'
 for is_md_suspended()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgMjgsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdl
aWNsb3VkLmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+
Cj4KPiAncGVycy0+cHJlcGFyZV9zdXNwZW5kJyBpcyBpbnRyb2R1Y2VkIHRvIHByZXZlbnQgYSBk
ZWFkbG9jayBmb3IgcmFpZDQ1NiwKPiB0aGlzIGNoYW5nZSBwcmVwYXJlcyB0byBjbGVhbiB0aGlz
IHVwIGluIGxhdGVyIHBhdGNoZXMgd2hpbGUgcmVmYWN0b3JpbmcKPiBtZGRldl9zdXNwZW5kKCku
IFNwZWNpZmljYWxseSBhbGxvdyByZXNoYXBlIHRvIG1ha2UgcHJvZ3Jlc3Mgd2hpbGUKPiB3YWl0
aW5nIGZvciAnYWN0aXZlX2lvJyB0byBiZSAwLgoKSGkgS3VhaQoKRnJvbSBteSBzaWRlLCBJIGNh
bid0IHVuZGVyc3RhbmQgdGhlIGNvbW1lbnRzLiBUaGUgY2hhbmdlIGhhcwpyZWxhdGlvbnNoaXAg
d2l0aCBwZXJzLT5wcmVwYXJlX3N1c3BlbmQ/IEFuZCB3aHkgdGhpcyBjaGFuZ2UgY2FuCmFmZmVj
dCByZXNoYXBlPyBJZiB0aGlzIGNoYW5nZSBpbmRlZWQgY2FuIGFmZmVjdCB0aGVzZSB0d28gdGhp
bmdzLCBjYW4KeW91IGV4cGxhaW4gbW9yZT8KCj4KPiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5
dWt1YWkzQGh1YXdlaS5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvbWQvbWQuYyB8IDIgKy0KPiAgZHJp
dmVycy9tZC9tZC5oIHwgMiArLQo+ICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJz
L21kL21kLmMKPiBpbmRleCA5ZDhkZmY5ZDkyM2MuLjdmYTMxMWExNDMxNyAxMDA2NDQKPiAtLS0g
YS9kcml2ZXJzL21kL21kLmMKPiArKysgYi9kcml2ZXJzL21kL21kLmMKPiBAQCAtMzU1LDcgKzM1
NSw3IEBAIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0soYWxsX21kZGV2c19sb2NrKTsKPiAgICovCj4g
IHN0YXRpYyBib29sIGlzX3N1c3BlbmRlZChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlv
ICpiaW8pCj4gIHsKPiAtICAgICAgIGlmIChpc19tZF9zdXNwZW5kZWQobWRkZXYpKQo+ICsgICAg
ICAgaWYgKGlzX21kX3N1c3BlbmRlZChtZGRldikgfHwgcGVyY3B1X3JlZl9pc19keWluZygmbWRk
ZXYtPmFjdGl2ZV9pbykpCgpJZiB3ZSB1c2UgbWRkZXYtPnN1c3BlbmRlZCB0byBqdWRnZSBpZiB0
aGUgcmFpZCBpcyBzdXNwZW5kZWQsIGl0CnNob3VsZCBiZSBlbm91Z2g/IEJlY2F1c2UgbWRkZXYt
PnN1c3BlbmRlZCBtdXN0IGJlIHRydWUgd2hlbiBhY3RpdmVfaW8KaXMgZHlpbmcuCgpCZXN0IFJl
Z2FyZHMKWGlhbwo+ICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsKPiAgICAgICAgIGlmIChi
aW9fZGF0YV9kaXIoYmlvKSAhPSBXUklURSkKPiAgICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNl
Owo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmggYi9kcml2ZXJzL21kL21kLmgKPiBpbmRl
eCBiNjI4YzI5MjUwNmUuLmZiM2IxMjNmMTZkZCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL21k
LmgKPiArKysgYi9kcml2ZXJzL21kL21kLmgKPiBAQCAtNTg0LDcgKzU4NCw3IEBAIHN0YXRpYyBp
bmxpbmUgYm9vbCBtZF9pc19yZHdyKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4KPiAgc3RhdGljIGlu
bGluZSBib29sIGlzX21kX3N1c3BlbmRlZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+ICB7Cj4gLSAg
ICAgICByZXR1cm4gcGVyY3B1X3JlZl9pc19keWluZygmbWRkZXYtPmFjdGl2ZV9pbyk7Cj4gKyAg
ICAgICByZXR1cm4gUkVBRF9PTkNFKG1kZGV2LT5zdXNwZW5kZWQpOwo+ICB9Cj4KPiAgc3RhdGlj
IGlubGluZSBpbnQgX19tdXN0X2NoZWNrIG1kZGV2X2xvY2soc3RydWN0IG1kZGV2ICptZGRldikK
PiAtLQo+IDIuMzkuMgo+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

