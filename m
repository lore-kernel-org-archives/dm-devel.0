Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006EAEB64DB
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686727482;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IGLhbnJ5PGiBeziYweiw9bVlrd7FlsK6QKO9UdzuLTE=;
	b=fZbDn/87PZ3CwRvMnWTvYRJKc6Dljy0aIwTNrspKro5DjcKY25xu70B9BYeOspsrPA8fec
	ZYRZFmCjakp8d0cvf+J3jTKHZsNPK830+AP6SX/LwRmOXQVSBWXN/gUghpPjsMMBNegneM
	/1oU895G4/48NnsBCS+rh1UDJvleJCI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-BuGCHzT1OtCN3ArV4ibTrQ-1; Wed, 14 Jun 2023 03:24:40 -0400
X-MC-Unique: BuGCHzT1OtCN3ArV4ibTrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97D133C108CF;
	Wed, 14 Jun 2023 07:24:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6507C2956;
	Wed, 14 Jun 2023 07:24:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4734419459F1;
	Wed, 14 Jun 2023 07:24:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA13D194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:24:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BCC09E93; Wed, 14 Jun 2023 07:24:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D1F2956
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:24:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76E0F811E9E
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:24:36 +0000 (UTC)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-IolN6ZGBMWWNtIuUEltIIQ-1; Wed, 14 Jun 2023 03:24:34 -0400
X-MC-Unique: IolN6ZGBMWWNtIuUEltIIQ-1
Received: by mail-pj1-f69.google.com with SMTP id
 98e67ed59e1d1-259a3c7fe26so2851698a91.1
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 00:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686727473; x=1689319473;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=pCVjUpCiaki4fcM43NzRGyadlOcYPcJBZy9bfHP7iJM=;
 b=YxmpI39SU3lflNAIDYvrYZ4AXSiIFHv+QyZM2AkQLbu6Uxtmdxt8TWbnV2TEAj1esl
 uIx68pEUF+tzlhZ1ouqIyJMco95V8+lmiUFFvrPCSeF7gCjHq3AvFjBVHM7n1DY2b7Qy
 BaLnmAH68rjephPrMGcUsUeAAz2774xzmngajpDH0ogUNS0EfYV8NCBLz/GyFM5BTCgB
 gTMvN1KltXSFljYZm8BlMSrvPXvvCLOkDAdAOxmUMX7pkElsHkv8rHwCeurHiJVz7cBF
 ZkvaxAcUAnufrfwXgvOjvk4UOU28hQATeNw9ouVaLaQfauY3RzU+lmmEZpTvk+Y/OzHR
 dBrw==
X-Gm-Message-State: AC+VfDzyTqOX3+QhN7lVsNFdPnYskNehYR42kvs4RMqk/XTyzF/EFWB8
 dtO6gogwVAjd19shPQs8mvFE6Ine/aKRn00pVNjKS5QhoWMix9Z/4Gw9+SNXMqFJTgIvQxSSksz
 eYilXTVb1l4iWCPU=
X-Received: by 2002:a17:90a:668f:b0:256:5637:2b30 with SMTP id
 m15-20020a17090a668f00b0025656372b30mr566755pjj.40.1686727473320; 
 Wed, 14 Jun 2023 00:24:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7EPJjztLMyL9Tzcno6Zl5Y5jx5gQ+t9tCC5omV1ac4iYoqRpze/H9csdp7PFs0QWTEfbOY0w==
X-Received: by 2002:a17:90a:668f:b0:256:5637:2b30 with SMTP id
 m15-20020a17090a668f00b0025656372b30mr566748pjj.40.1686727472996; 
 Wed, 14 Jun 2023 00:24:32 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
 by smtp.gmail.com with ESMTPSA id
 k65-20020a17090a4cc700b0025bf64ac0besm4465972pjh.55.2023.06.14.00.24.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 14 Jun 2023 00:24:32 -0700 (PDT)
Message-ID: <d5407a0d-f97b-ce31-9319-911695f2e5e8@redhat.com>
Date: Wed, 14 Jun 2023 15:24:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-7-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-7-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH -next v2 6/6] md: enhance checking in
 md_check_recovery()
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
aSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Cj4gRm9yIG1kX2NoZWNrX3JlY292ZXJ5KCk6Cj4KPiAx
KSBpZiAnTURfUkVDT1ZFUllfUlVOSU5HJyBpcyBub3Qgc2V0LCByZWdpc3RlciBuZXcgc3luY190
aHJlYWQuCj4gMikgaWYgJ01EX1JFQ09WRVJZX1JVTklORycgaXMgc2V0Ogo+ICAgYSkgaWYgJ01E
X1JFQ09WRVJZX0RPTkUnIGlzIG5vdCBzZXQsIGRvbid0IGRvIGFueXRoaW5nLCB3YWl0IGZvcgo+
ICAgICBtZF9kb19zeW5jKCkgdG8gYmUgZG9uZS4KPiAgIGIpIGlmICdNRF9SRUNPVkVSWV9ET05F
JyBpcyBzZXQsIHVucmVnaXN0ZXIgc3luY190aHJlYWQuIEN1cnJlbnQgY29kZQo+ICAgICBleHBl
Y3RzIHRoYXQgc3luY190aHJlYWQgaXMgbm90IE5VTEwsIG90aGVyd2lzZSBuZXcgc3luY190aHJl
YWQgd2lsbAo+ICAgICBiZSByZWdpc3RlcmVkLCB3aGljaCB3aWxsIGNvcnJ1cHQgdGhlIGFycmF5
Lgo+Cj4gTWFrZSBzdXJlIG1kX2NoZWNrX3JlY292ZXJ5KCkgd29uJ3QgcmVnaXN0ZXIgbmV3IHN5
bmNfdGhyZWFkIGlmCj4gJ01EX1JFQ09WRVJZX1JVTklORycgaXMgc3RpbGwgc2V0LCBhbmQgYSBu
ZXcgV0FSTl9PTl9PTkNFKCkgaXMgYWRkZWQgZm9yCj4gdGhlIGFib3ZlIGNvcnJ1cHRpb24sCj4K
PiBTaWduZWQtb2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4gLS0tCj4gICBk
cml2ZXJzL21kL21kLmMgfCAyMiArKysrKysrKysrKysrKystLS0tLS0tCj4gICAxIGZpbGUgY2hh
bmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPiBpbmRleCBmOTAyMjZlNmRkZjguLjlk
YTBmYzkwNmJiZCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL21kLmMKPiArKysgYi9kcml2ZXJz
L21kL21kLmMKPiBAQCAtOTM5NywxNiArOTM5NywyNCBAQCB2b2lkIG1kX2NoZWNrX3JlY292ZXJ5
KHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gICAJCWlmIChtZGRldi0+c2JfZmxhZ3MpCj4gICAJCQlt
ZF91cGRhdGVfc2IobWRkZXYsIDApOwo+ICAgCj4gLQkJaWYgKHRlc3RfYml0KE1EX1JFQ09WRVJZ
X1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpICYmCj4gLQkJICAgICF0ZXN0X2JpdChNRF9SRUNP
VkVSWV9ET05FLCAmbWRkZXYtPnJlY292ZXJ5KSkgewo+IC0JCQkvKiByZXN5bmMvcmVjb3Zlcnkg
c3RpbGwgaGFwcGVuaW5nICovCj4gLQkJCWNsZWFyX2JpdChNRF9SRUNPVkVSWV9ORUVERUQsICZt
ZGRldi0+cmVjb3ZlcnkpOwo+IC0JCQlnb3RvIHVubG9jazsKPiAtCQl9Cj4gLQkJaWYgKG1kZGV2
LT5zeW5jX3RocmVhZCkgewo+ICsJCS8qCj4gKwkJICogTmV2ZXIgc3RhcnQgYSBuZXcgc3luYyB0
aHJlYWQgaWYgTURfUkVDT1ZFUllfUlVOTklORyBpcwo+ICsJCSAqIHN0aWxsIHNldC4KPiArCQkg
Ki8KPiArCQlpZiAodGVzdF9iaXQoTURfUkVDT1ZFUllfUlVOTklORywgJm1kZGV2LT5yZWNvdmVy
eSkpIHsKPiArCQkJaWYgKCF0ZXN0X2JpdChNRF9SRUNPVkVSWV9ET05FLCAmbWRkZXYtPnJlY292
ZXJ5KSkgewo+ICsJCQkJLyogcmVzeW5jL3JlY292ZXJ5IHN0aWxsIGhhcHBlbmluZyAqLwo+ICsJ
CQkJY2xlYXJfYml0KE1EX1JFQ09WRVJZX05FRURFRCwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4gKwkJ
CQlnb3RvIHVubG9jazsKPiArCQkJfQo+ICsKPiArCQkJaWYgKFdBUk5fT05fT05DRSghbWRkZXYt
PnN5bmNfdGhyZWFkKSkKPiArCQkJCWdvdG8gdW5sb2NrOwo+ICsKPiAgIAkJCW1kX3JlYXBfc3lu
Y190aHJlYWQobWRkZXYpOwo+ICAgCQkJZ290byB1bmxvY2s7Cj4gICAJCX0KPiArCj4gICAJCS8q
IFNldCBSVU5OSU5HIGJlZm9yZSBjbGVhcmluZyBORUVERUQgdG8gYXZvaWQKPiAgIAkJICogYW55
IHRyYW5zaWVudHMgaW4gdGhlIHZhbHVlIG9mICJzeW5jX2FjdGlvbiIuCj4gICAJCSAqLwoKSXQg
bWFrZXMgdGhlIGxvZ2ljYWwgbW9yZSBjbGVhci4KClJldmlld2VkLWJ5OiBYaWFvIE5pIDx4bmlA
cmVkaGF0LmNvbT4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

