Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD28C77B7A
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 08:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686643404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=33OaedU1ukAPdrtcYCHOg3Bd9H1etmIFTtQRKiLt3/Q=;
	b=NaVRlPv01alrZlGgwxTu+5wRd8mwMKIDm9tOfxma4KrWis2ClD6AjCXPlaoTnHjl3LJnPV
	lWjhky5ge7CpOI+jHw/nSuijN3OJq+rrAdYKzcqIkpI9EL7IdRh6LKPO5ZU3mdOOTJU+AZ
	J8P9Na7l87iuV8LRzFFglKrF3Tm1buk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-F3bDbmDmPj-s8bltmLVS0g-1; Tue, 13 Jun 2023 04:03:20 -0400
X-MC-Unique: F3bDbmDmPj-s8bltmLVS0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E29458037AA;
	Tue, 13 Jun 2023 08:03:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE7451C558;
	Tue, 13 Jun 2023 08:03:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C76819465BD;
	Tue, 13 Jun 2023 08:03:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4EA87194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 08:03:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BF862166B26; Tue, 13 Jun 2023 08:03:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 239C42166B25
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 08:03:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE36D101A53B
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 08:03:15 +0000 (UTC)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-q_6o5cqFNUOoXjmHGBlDiw-1; Tue, 13 Jun 2023 04:03:04 -0400
X-MC-Unique: q_6o5cqFNUOoXjmHGBlDiw-1
Received: by mail-oi1-f199.google.com with SMTP id
 5614622812f47-39cdf9f9d10so1155437b6e.3
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 01:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686643384; x=1689235384;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=V2WAoXU2sO6i7ouZ+ltrXmzd4T/KwU8+agEZUhVJ2/A=;
 b=iM/SyKnfVytG2Bo61YJijQ8K/X5LENezvzcRHra+QpZORYFqHeVa0ZVLqOcDY3FdaD
 k4h4MFovYAEH5qYhfxpfXEWeeBdaGl901fKamR17y0JQcqutgbdrltdKHWrFfGlW6dWz
 l2i2WiEoSz46P4z1rx/NsCpL0SWMmW9AixzFAoYyKrktr1YV3RTKOUhQ1sFdAUig2Y1U
 JyBPe3j/28TTZTIeX7IqTLVquveAQwc2S2yFnia1j46g9mFWBUngQ2qGVPTLKQnAEvcg
 WJRjH+Z3grB5BDSWbALKC0Hsi6YzncIfXzrJGpzRAVkkxDrZFk/BKudoBBbwrsePiTRV
 bjKQ==
X-Gm-Message-State: AC+VfDyePS58pZHFqNX33/GCe57QMjYBE+kHKdbq+ikCJ2/FHiPLCNqV
 9rB5IBQrMiw3T0S4KQlBo8UInL+/UWqpaaymyQT5W26tAK2HNEwYKLtp70XMJcnFNJdyAMP8Vmq
 YXf6YSZFJ9VCDfyo=
X-Received: by 2002:a05:6808:221c:b0:39a:5e92:f459 with SMTP id
 bd28-20020a056808221c00b0039a5e92f459mr7996126oib.38.1686643383908; 
 Tue, 13 Jun 2023 01:03:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7xUDHntHnuiUM8nQFbipVkqgakxXsx7HwJmcyUfwoHuTXrCOl6qzVaRfoSHzNgRHa7Z0rmLw==
X-Received: by 2002:a05:6808:221c:b0:39a:5e92:f459 with SMTP id
 bd28-20020a056808221c00b0039a5e92f459mr7996106oib.38.1686643383607; 
 Tue, 13 Jun 2023 01:03:03 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
 by smtp.gmail.com with ESMTPSA id
 h13-20020a17090a3d0d00b0025954958e06sm9336256pjc.18.2023.06.13.01.02.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Jun 2023 01:03:03 -0700 (PDT)
Message-ID: <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
Date: Tue, 13 Jun 2023 16:02:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-3-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnpgZM6Cj4gRnJvbTogWXUgS3Vh
aSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Cj4gUHJlcGFyZSB0byBoYW5kbGUgJ2lkbGUnIGFuZCAn
ZnJvemVuJyBkaWZmZXJlbnRseSB0byBmaXggYSBkZWFkbG9jaywgdGhlcmUKPiBhcmUgbm8gZnVu
Y3Rpb25hbCBjaGFuZ2VzIGV4Y2VwdCB0aGF0IE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgY2hlY2tl
ZAo+IGFnYWluIGFmdGVyICdyZWNvbmZpZ19tdXRleCcgaXMgaGVsZC4KCgpDYW4geW91IGV4cGxh
aW4gbW9yZSBhYm91dCB3aHkgaXQgbmVlZHMgdG8gY2hlY2sgTURfUkVDT1ZFUllfUlVOTklORyAK
YWdhaW4gaGVyZT8KCj4KPiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5j
b20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL21kLmMgfCA2MSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgNDUgaW5zZXJ0
aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5j
IGIvZHJpdmVycy9tZC9tZC5jCj4gaW5kZXggOWI5NzczMWUxZmU0Li4yM2U4ZTdlYWUwNjIgMTAw
NjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9tZC5jCj4gKysrIGIvZHJpdmVycy9tZC9tZC5jCj4gQEAg
LTQ3NTUsNiArNDc1NSw0NiBAQCBhY3Rpb25fc2hvdyhzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjaGFy
ICpwYWdlKQo+ICAgCXJldHVybiBzcHJpbnRmKHBhZ2UsICIlc1xuIiwgdHlwZSk7Cj4gICB9Cj4g
ICAKPiArc3RhdGljIHZvaWQgc3RvcF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+
ICt7Cj4gKwlpZiAoIXRlc3RfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3Zl
cnkpKQo+ICsJCXJldHVybjsKPiArCj4gKwlpZiAobWRkZXZfbG9jayhtZGRldikpCj4gKwkJcmV0
dXJuOwo+ICsKPiArCS8qCj4gKwkgKiBDaGVjayBhZ2FpbiBpbiBjYXNlIE1EX1JFQ09WRVJZX1JV
Tk5JTkcgaXMgY2xlYXJlZCBiZWZvcmUgbG9jayBpcwo+ICsJICogaGVsZC4KPiArCSAqLwo+ICsJ
aWYgKCF0ZXN0X2JpdChNRF9SRUNPVkVSWV9SVU5OSU5HLCAmbWRkZXYtPnJlY292ZXJ5KSkgewo+
ICsJCW1kZGV2X3VubG9jayhtZGRldik7Cj4gKwkJcmV0dXJuOwo+ICsJfQo+ICsKPiArCWlmICh3
b3JrX3BlbmRpbmcoJm1kZGV2LT5kZWxfd29yaykpCj4gKwkJZmx1c2hfd29ya3F1ZXVlKG1kX21p
c2Nfd3EpOwo+ICsKPiArCWlmIChtZGRldi0+c3luY190aHJlYWQpIHsKPiArCQlzZXRfYml0KE1E
X1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpOwo+ICsJCW1kX3JlYXBfc3luY190aHJl
YWQobWRkZXYpOwo+ICsJfQo+ICsKPiArCW1kZGV2X3VubG9jayhtZGRldik7Cj4gK30KPiArCj4g
K3N0YXRpYyB2b2lkIGlkbGVfc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPiArewo+
ICsJY2xlYXJfYml0KE1EX1JFQ09WRVJZX0ZST1pFTiwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4gKwlz
dG9wX3N5bmNfdGhyZWFkKG1kZGV2KTsKPiArfQo+ICsKPiArc3RhdGljIHZvaWQgZnJvemVuX3N5
bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gK3sKPiArCXNldF9iaXQoTURfUkVDT1ZF
UllfRlJPWkVOLCAmbWRkZXYtPnJlY292ZXJ5KTsKPiArCXN0b3Bfc3luY190aHJlYWQobWRkZXYp
Owo+ICt9Cj4gKwo+ICAgc3RhdGljIHNzaXplX3QKPiAgIGFjdGlvbl9zdG9yZShzdHJ1Y3QgbWRk
ZXYgKm1kZGV2LCBjb25zdCBjaGFyICpwYWdlLCBzaXplX3QgbGVuKQo+ICAgewo+IEBAIC00NzYy
LDIyICs0ODAyLDExIEBAIGFjdGlvbl9zdG9yZShzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjb25zdCBj
aGFyICpwYWdlLCBzaXplX3QgbGVuKQo+ICAgCQlyZXR1cm4gLUVJTlZBTDsKPiAgIAo+ICAgCj4g
LQlpZiAoY21kX21hdGNoKHBhZ2UsICJpZGxlIikgfHwgY21kX21hdGNoKHBhZ2UsICJmcm96ZW4i
KSkgewo+IC0JCWlmIChjbWRfbWF0Y2gocGFnZSwgImZyb3plbiIpKQo+IC0JCQlzZXRfYml0KE1E
X1JFQ09WRVJZX0ZST1pFTiwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4gLQkJZWxzZQo+IC0JCQljbGVh
cl9iaXQoTURfUkVDT1ZFUllfRlJPWkVOLCAmbWRkZXYtPnJlY292ZXJ5KTsKPiAtCQlpZiAodGVz
dF9iaXQoTURfUkVDT1ZFUllfUlVOTklORywgJm1kZGV2LT5yZWNvdmVyeSkgJiYKPiAtCQkgICAg
bWRkZXZfbG9jayhtZGRldikgPT0gMCkgewo+IC0JCQlpZiAod29ya19wZW5kaW5nKCZtZGRldi0+
ZGVsX3dvcmspKQo+IC0JCQkJZmx1c2hfd29ya3F1ZXVlKG1kX21pc2Nfd3EpOwo+IC0JCQlpZiAo
bWRkZXYtPnN5bmNfdGhyZWFkKSB7Cj4gLQkJCQlzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZt
ZGRldi0+cmVjb3ZlcnkpOwo+IC0JCQkJbWRfcmVhcF9zeW5jX3RocmVhZChtZGRldik7Cj4gLQkJ
CX0KPiAtCQkJbWRkZXZfdW5sb2NrKG1kZGV2KTsKPiAtCQl9Cj4gLQl9IGVsc2UgaWYgKHRlc3Rf
Yml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpKQo+ICsJaWYgKGNtZF9t
YXRjaChwYWdlLCAiaWRsZSIpKQo+ICsJCWlkbGVfc3luY190aHJlYWQobWRkZXYpOwo+ICsJZWxz
ZSBpZiAoY21kX21hdGNoKHBhZ2UsICJmcm96ZW4iKSkKPiArCQlmcm96ZW5fc3luY190aHJlYWQo
bWRkZXYpOwo+ICsJZWxzZSBpZiAodGVzdF9iaXQoTURfUkVDT1ZFUllfUlVOTklORywgJm1kZGV2
LT5yZWNvdmVyeSkpCj4gICAJCXJldHVybiAtRUJVU1k7Cj4gICAJZWxzZSBpZiAoY21kX21hdGNo
KHBhZ2UsICJyZXN5bmMiKSkKPiAgIAkJY2xlYXJfYml0KE1EX1JFQ09WRVJZX0ZST1pFTiwgJm1k
ZGV2LT5yZWNvdmVyeSk7CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

