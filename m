Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72041EB64D0
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686667507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q3biD2LivCMqfVKkoQAAAsxbKw1G8Gf/QDRuIVdj9J4=;
	b=hrjquLP2NWz5BYoEFR1Qc5ZM2UjYvDRndzUwdOqs4NhbC9E+bMiW2HvCzeZOJ3MHWO/PXQ
	UWxgzhM3MF+XTyyI9mC4YgavSdM97spxcPk1+dZnUslrf0uzNqRvAcfKsrc+OBRNoRmpyy
	yG9GC4rZyg+uM7V4Ko6uYsWrLldQQCs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-UcCDYOrGNsycHXcQMYejVg-1; Tue, 13 Jun 2023 10:45:00 -0400
X-MC-Unique: UcCDYOrGNsycHXcQMYejVg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A1DB3C108DC;
	Tue, 13 Jun 2023 14:44:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6533A40C20F9;
	Tue, 13 Jun 2023 14:44:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CE9E1946A44;
	Tue, 13 Jun 2023 14:44:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B496E194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 14:44:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A351940C20F6; Tue, 13 Jun 2023 14:44:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1C240C20F7
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 14:44:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B91B83C108C4
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 14:44:33 +0000 (UTC)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-jxxFmW3INpu3i1EMxAAMXA-1; Tue, 13 Jun 2023 10:43:39 -0400
X-MC-Unique: jxxFmW3INpu3i1EMxAAMXA-1
Received: by mail-pj1-f72.google.com with SMTP id
 98e67ed59e1d1-25be7b66641so1718738a91.2
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 07:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686667401; x=1689259401;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=qCAk+GrfYv2LlZeL9R4DyIt9sUEULTjaibnxzpvOXzU=;
 b=YZcW+QzQIhlUBob5RDur2qEiYhl2bi42siaYwPR9laDGWylWtrjSSGWi53womeD9Ar
 shP72Okwx96EDLjqktCfh7ImwbHVb5qOyByNjDh3tIH4+yYuDljeiyKV1EWzJSIzdSWs
 sJOCUTt6mOTdFdelqvqiwiizFarJWnbuv97tMHaXges9VDJx1Bh7GDstWowkuWH8GrzL
 Svikhbu+jEnnR24B9CUPWy5UmN5cG92yMzrzhMxCn4XFZEOa9LFjFiSKq4fVBit6kg8h
 goAMDp4IU/AbLpLBfK5krSR6ysxj6Mhof1PfC4vWDAvBo2mnzZqnnVJtc/1NO4Cclgqy
 M+Qw==
X-Gm-Message-State: AC+VfDzOtZEzfvg24c15oF3r/D/qR4LJ1OjN+v9n9hrfLuu6DBAxWTWH
 o/m56A2Pk2Ea4QqjkcYB39xkhMKUpeX84aggu/CAm4d/S5SIaH/Hd7UF1TR+5WJPBe8NbrEj5If
 cJVd6haZtzeVIofM=
X-Received: by 2002:a17:90b:364c:b0:25b:e311:14b9 with SMTP id
 nh12-20020a17090b364c00b0025be31114b9mr5583544pjb.29.1686667401474; 
 Tue, 13 Jun 2023 07:43:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7pzDK/dX7LQKc/Z1gmMKhXdFjH/ZJbgm6TymQSc9JNchoVhSaDhMC+a+dsmHcntgyeQR8+DA==
X-Received: by 2002:a17:90b:364c:b0:25b:e311:14b9 with SMTP id
 nh12-20020a17090b364c00b0025be31114b9mr5583529pjb.29.1686667401155; 
 Tue, 13 Jun 2023 07:43:21 -0700 (PDT)
Received: from [10.72.13.126] ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id
 s23-20020a17090a1c1700b0025be4c602d5sm4095009pjs.38.2023.06.13.07.43.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Jun 2023 07:43:20 -0700 (PDT)
Message-ID: <c96f2604-e1ef-c3ad-9d15-5e0efa5f222b@redhat.com>
Date: Tue, 13 Jun 2023 22:43:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-4-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH -next v2 3/6] md: add a mutex to synchronize
 idle and frozen in action_store()
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
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnpgZM6Cj4gRnJvbTogWXUgS3Vh
aSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Cj4gQ3VycmVudGx5LCBmb3IgaWRsZSBhbmQgZnJvemVu
LCBhY3Rpb25fc3RvcmUgd2lsbCBob2xkICdyZWNvbmZpZ19tdXRleCcKPiBhbmQgY2FsbCBtZF9y
ZWFwX3N5bmNfdGhyZWFkKCkgdG8gc3RvcCBzeW5jIHRocmVhZCwgaG93ZXZlciwgdGhpcyB3aWxs
Cj4gY2F1c2UgZGVhZGxvY2sgKGV4cGxhaW5lZCBpbiB0aGUgbmV4dCBwYXRjaCkuIEluIG9yZGVy
IHRvIGZpeCB0aGUKPiBwcm9ibGVtLCBmb2xsb3dpbmcgcGF0Y2ggd2lsbCByZWxlYXNlICdyZWNv
bmZpZ19tdXRleCcgYW5kIHdhaXQgb24KPiAncmVzeW5jX3dhaXQnLCBsaWtlIG1kX3NldF9yZWFk
b25seSgpIGFuZCBkb19tZF9zdG9wKCkgZG9lcy4KPgo+IENvbnNpZGVyIHRoYXQgYWN0aW9uX3N0
b3JlKCkgd2lsbCBzZXQvY2xlYXIgJ01EX1JFQ09WRVJZX0ZST1pFTicKPiB1bmNvbmRpdGlvbmFs
bHksIHdoaWNoIG1pZ2h0IGNhdXNlIHVuZXhwZWN0ZWQgcHJvYmxlbXMsIGZvciBleGFtcGxlLAo+
IGZyb3plbiBqdXN0IHNldCAnTURfUkVDT1ZFUllfRlJPWkVOJyBhbmQgaXMgc3RpbGwgaW4gcHJv
Z3Jlc3MsIHdoaWxlCj4gJ2lkbGUnIGNsZWFyICdNRF9SRUNPVkVSWV9GUk9aRU4nIGFuZCBuZXcg
c3luYyB0aHJlYWQgaXMgc3RhcnRlZCwgd2hpY2gKPiBtaWdodCBzdGFydmUgaW4gcHJvZ3Jlc3Mg
ZnJvemVuLiBBIG11dGV4IGlzIGFkZGVkIHRvIHN5bmNocm9uaXplIGlkbGUKPiBhbmQgZnJvemVu
IGZyb20gYWN0aW9uX3N0b3JlKCkuCj4KPiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkz
QGh1YXdlaS5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL21kLmMgfCA1ICsrKysrCj4gICBkcml2
ZXJzL21kL21kLmggfCAzICsrKwo+ICAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykK
Pgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPiBpbmRl
eCAyM2U4ZTdlYWUwNjIuLjYzYTk5M2I1MmNkNyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL21k
LmMKPiArKysgYi9kcml2ZXJzL21kL21kLmMKPiBAQCAtNjQ0LDYgKzY0NCw3IEBAIHZvaWQgbWRk
ZXZfaW5pdChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+ICAgCW11dGV4X2luaXQoJm1kZGV2LT5vcGVu
X211dGV4KTsKPiAgIAltdXRleF9pbml0KCZtZGRldi0+cmVjb25maWdfbXV0ZXgpOwo+ICAgCW11
dGV4X2luaXQoJm1kZGV2LT5kZWxldGVfbXV0ZXgpOwo+ICsJbXV0ZXhfaW5pdCgmbWRkZXYtPnN5
bmNfbXV0ZXgpOwo+ICAgCW11dGV4X2luaXQoJm1kZGV2LT5iaXRtYXBfaW5mby5tdXRleCk7Cj4g
ICAJSU5JVF9MSVNUX0hFQUQoJm1kZGV2LT5kaXNrcyk7Cj4gICAJSU5JVF9MSVNUX0hFQUQoJm1k
ZGV2LT5hbGxfbWRkZXZzKTsKPiBAQCAtNDc4NSwxNCArNDc4NiwxOCBAQCBzdGF0aWMgdm9pZCBz
dG9wX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gICAKPiAgIHN0YXRpYyB2b2lk
IGlkbGVfc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPiAgIHsKPiArCW11dGV4X2xv
Y2soJm1kZGV2LT5zeW5jX211dGV4KTsKPiAgIAljbGVhcl9iaXQoTURfUkVDT1ZFUllfRlJPWkVO
LCAmbWRkZXYtPnJlY292ZXJ5KTsKPiAgIAlzdG9wX3N5bmNfdGhyZWFkKG1kZGV2KTsKPiArCW11
dGV4X3VubG9jaygmbWRkZXYtPnN5bmNfbXV0ZXgpOwo+ICAgfQo+ICAgCj4gICBzdGF0aWMgdm9p
ZCBmcm96ZW5fc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPiAgIHsKPiArCW11dGV4
X2luaXQoJm1kZGV2LT5kZWxldGVfbXV0ZXgpOwoKCnR5cG8gZXJyb3I/IEl0IHNob3VsZCBiZSBt
dXRleF9sb2NrKCZtZGRldi0+c3luY19tdXRleCk7ID8KClJlZ2FyZHMKClhpYW8KCj4gICAJc2V0
X2JpdChNRF9SRUNPVkVSWV9GUk9aRU4sICZtZGRldi0+cmVjb3ZlcnkpOwo+ICAgCXN0b3Bfc3lu
Y190aHJlYWQobWRkZXYpOwo+ICsJbXV0ZXhfdW5sb2NrKCZtZGRldi0+c3luY19tdXRleCk7Cj4g
ICB9Cj4gICAKPiAgIHN0YXRpYyBzc2l6ZV90Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQu
aCBiL2RyaXZlcnMvbWQvbWQuaAo+IGluZGV4IGJmZDIzMDZiYzc1MC4uMmZhOTAzZGU1YmQwIDEw
MDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvbWQuaAo+ICsrKyBiL2RyaXZlcnMvbWQvbWQuaAo+IEBA
IC01MzcsNiArNTM3LDkgQEAgc3RydWN0IG1kZGV2IHsKPiAgIAkvKiBQcm90ZWN0IHRoZSBkZWxl
dGluZyBsaXN0ICovCj4gICAJc3RydWN0IG11dGV4CQkJZGVsZXRlX211dGV4Owo+ICAgCj4gKwkv
KiBVc2VkIHRvIHN5bmNocm9uaXplIGlkbGUgYW5kIGZyb3plbiBmb3IgYWN0aW9uX3N0b3JlKCkg
Ki8KPiArCXN0cnVjdCBtdXRleAkJCXN5bmNfbXV0ZXg7Cj4gKwo+ICAgCWJvb2wJaGFzX3N1cGVy
YmxvY2tzOjE7Cj4gICAJYm9vbAlmYWlsX2xhc3RfZGV2OjE7Cj4gICAJYm9vbAlzZXJpYWxpemVf
cG9saWN5OjE7CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

