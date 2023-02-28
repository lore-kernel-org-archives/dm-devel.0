Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D90C7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 28 Feb 2023 01:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677546107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/OEY1jOFX+7PK9A7aVYr6gviAiW0Zn1u4T0tcgoX2dc=;
	b=Vk0f7pU80i2QNG/tQZ5eNDIWDqozY+CQMZhG59X5D2P2VOoPk7xukllrxWQUFTKHWz+eEN
	dZF0dolxF8xswuGA3NOJ1PLtjHsQo8wqagXlNJcWcQTqVvojtlSk7j9bm6ZRNlxIuDIwiV
	J40zL2dno+GYc90rpUVr0Wiq+3qCMsE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-7CTlBcAJMR-Bg0Uwb2nizw-1; Mon, 27 Feb 2023 20:01:44 -0500
X-MC-Unique: 7CTlBcAJMR-Bg0Uwb2nizw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0CE3858F0E;
	Tue, 28 Feb 2023 01:01:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 355D0492B12;
	Tue, 28 Feb 2023 01:01:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 093CA1946587;
	Tue, 28 Feb 2023 01:01:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D30A1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Feb 2023 01:01:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E599404BEC8; Tue, 28 Feb 2023 01:01:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47317404BEC6
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:01:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CB6F2810C05
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:01:39 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-pPtoNwX8OUO1hyF7_NBZQQ-1; Mon, 27 Feb 2023 20:01:34 -0500
X-MC-Unique: pPtoNwX8OUO1hyF7_NBZQQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PQfFg1h6Zz4f3lx5;
 Tue, 28 Feb 2023 09:01:27 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgDn4R9nUv1j3JdHEA--.17465S3;
 Tue, 28 Feb 2023 09:01:29 +0800 (CST)
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, guz.fnst@cn.fujitsu.com
References: <20230223091226.1135678-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <05bbc421-100c-c18d-4261-e5669cfdfb94@huaweicloud.com>
Date: Tue, 28 Feb 2023 09:01:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230223091226.1135678-1-yukuai1@huaweicloud.com>
X-CM-TRANSID: _Ch0CgDn4R9nUv1j3JdHEA--.17465S3
X-Coremail-Antispam: 1UD129KBjvJXoW3AFW8ury5KrWrWr4DKF15urg_yoW7ZF1UpF
 40g3WrCrZIqwn0gw4UJayDCF1rKa10qry7CrW7Jry5Aw4ktryvvF10y3Z0yr1rCa97uFZr
 Aa4rZF9ruw42k37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
 3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH -next RFC] block: count 'ios' and 'sectors'
 when io is done for bio-based device
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgpmcmllbmRseSBwaW5nIC4uLgoKVGhhbmtzLApLdWFpCgrU2iAyMDIzLzAyLzIzIDE3OjEy
LCBZdSBLdWFpINC0tcA6Cj4gRnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+IAo+
IFdoaWxlIHVzaW5nIGlvc3RhdCBmb3IgcmFpZCwgSSBvYnNlcnZlZCB2ZXJ5IHN0cmFuZ2UgJ2F3
YWl0Jwo+IG9jY2FzaW9uYWxseSwgYW5kIHR1cm5zIG91dCBpdCdzIGR1ZSB0byB0aGF0ICdpb3Mn
IGFuZCAnc2VjdG9ycycgaXMKPiBjb3VudGVkIGluIGJkZXZfc3RhcnRfaW9fYWNjdCgpLCB3aGls
ZSAnbnNlY3MnIGlzIGNvdW50ZWQgaW4KPiBiZGV2X2VuZF9pb19hY2N0KCkuIEknbSBub3Qgc3Vy
ZSB3aHkgdGhleSBhcmUgY2NvdW50ZWQgbGlrZSB0aGF0Cj4gYnV0IEkgdGhpbmsgdGhpcyBiZWhh
dmlvdXIgaXMgb2J2aW91c2x5IHdyb25nIGJlY2F1c2UgdXNlciB3aWxsIGdldAo+IHdyb25nIGRp
c2sgc3RhdHMuCj4gCj4gRml4IHRoZSBwcm9ibGVtIGJ5IGNvdW50aW5nICdpb3MnIGFuZCAnc2Vj
dG9ycycgd2hlbiBpbyBpcyBkb25lLCBsaWtlCj4gd2hhdCBycS1iYXNlZCBkZXZpY2UgZG9lcy4K
PiAKPiBGaXhlczogMzk0ZmZhNTAzYmM0ICgiYmxrOiBpbnRyb2R1Y2UgZ2VuZXJpYyBpbyBzdGF0
IGFjY291bnRpbmcgaGVscCBmdW5jdGlvbiIpCj4gU2lnbmVkLW9mZi1ieTogWXUgS3VhaSA8eXVr
dWFpM0BodWF3ZWkuY29tPgo+IC0tLQo+ICAgYmxvY2svYmxrLWNvcmUuYyAgICAgICAgICAgICAg
fCAxNiArKysrKystLS0tLS0tLS0tCj4gICBkcml2ZXJzL21kL2RtLmMgICAgICAgICAgICAgICB8
ICA2ICsrKy0tLQo+ICAgZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgfCAgOCArKysrLS0t
LQo+ICAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAgICAgICAgfCAgNSArKy0tLQo+ICAgNCBmaWxl
cyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvYmxvY2svYmxrLWNvcmUuYyBiL2Jsb2NrL2Jsay1jb3JlLmMKPiBpbmRleCA4MmI1YjJj
NTNmMWUuLmZlMWQzMjBmNWYwNyAxMDA2NDQKPiAtLS0gYS9ibG9jay9ibGstY29yZS5jCj4gKysr
IGIvYmxvY2svYmxrLWNvcmUuYwo+IEBAIC05NTMsMTYgKzk1MywxMSBAQCB2b2lkIHVwZGF0ZV9p
b190aWNrcyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpwYXJ0LCB1bnNpZ25lZCBsb25nIG5vdywgYm9v
bCBlbmQpCj4gICAJfQo+ICAgfQo+ICAgCj4gLXVuc2lnbmVkIGxvbmcgYmRldl9zdGFydF9pb19h
Y2N0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4gLQkJCQkgdW5zaWduZWQgaW50IHNlY3Rv
cnMsIGVudW0gcmVxX29wIG9wLAo+ICt1bnNpZ25lZCBsb25nIGJkZXZfc3RhcnRfaW9fYWNjdChz
dHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBlbnVtIHJlcV9vcCBvcCwKPiAgIAkJCQkgdW5zaWdu
ZWQgbG9uZyBzdGFydF90aW1lKQo+ICAgewo+IC0JY29uc3QgaW50IHNncnAgPSBvcF9zdGF0X2dy
b3VwKG9wKTsKPiAtCj4gICAJcGFydF9zdGF0X2xvY2soKTsKPiAgIAl1cGRhdGVfaW9fdGlja3Mo
YmRldiwgc3RhcnRfdGltZSwgZmFsc2UpOwo+IC0JcGFydF9zdGF0X2luYyhiZGV2LCBpb3Nbc2dy
cF0pOwo+IC0JcGFydF9zdGF0X2FkZChiZGV2LCBzZWN0b3JzW3NncnBdLCBzZWN0b3JzKTsKPiAg
IAlwYXJ0X3N0YXRfbG9jYWxfaW5jKGJkZXYsIGluX2ZsaWdodFtvcF9pc193cml0ZShvcCldKTsK
PiAgIAlwYXJ0X3N0YXRfdW5sb2NrKCk7Cj4gICAKPiBAQCAtOTc4LDEzICs5NzMsMTIgQEAgRVhQ
T1JUX1NZTUJPTChiZGV2X3N0YXJ0X2lvX2FjY3QpOwo+ICAgICovCj4gICB1bnNpZ25lZCBsb25n
IGJpb19zdGFydF9pb19hY2N0KHN0cnVjdCBiaW8gKmJpbykKPiAgIHsKPiAtCXJldHVybiBiZGV2
X3N0YXJ0X2lvX2FjY3QoYmlvLT5iaV9iZGV2LCBiaW9fc2VjdG9ycyhiaW8pLAo+IC0JCQkJICBi
aW9fb3AoYmlvKSwgamlmZmllcyk7Cj4gKwlyZXR1cm4gYmRldl9zdGFydF9pb19hY2N0KGJpby0+
YmlfYmRldiwgYmlvX29wKGJpbyksIGppZmZpZXMpOwo+ICAgfQo+ICAgRVhQT1JUX1NZTUJPTF9H
UEwoYmlvX3N0YXJ0X2lvX2FjY3QpOwo+ICAgCj4gICB2b2lkIGJkZXZfZW5kX2lvX2FjY3Qoc3Ry
dWN0IGJsb2NrX2RldmljZSAqYmRldiwgZW51bSByZXFfb3Agb3AsCj4gLQkJICAgICAgdW5zaWdu
ZWQgbG9uZyBzdGFydF90aW1lKQo+ICsJCSAgICAgIHVuc2lnbmVkIGludCBzZWN0b3JzLCB1bnNp
Z25lZCBsb25nIHN0YXJ0X3RpbWUpCj4gICB7Cj4gICAJY29uc3QgaW50IHNncnAgPSBvcF9zdGF0
X2dyb3VwKG9wKTsKPiAgIAl1bnNpZ25lZCBsb25nIG5vdyA9IFJFQURfT05DRShqaWZmaWVzKTsK
PiBAQCAtOTkyLDYgKzk4Niw4IEBAIHZvaWQgYmRldl9lbmRfaW9fYWNjdChzdHJ1Y3QgYmxvY2tf
ZGV2aWNlICpiZGV2LCBlbnVtIHJlcV9vcCBvcCwKPiAgIAo+ICAgCXBhcnRfc3RhdF9sb2NrKCk7
Cj4gICAJdXBkYXRlX2lvX3RpY2tzKGJkZXYsIG5vdywgdHJ1ZSk7Cj4gKwlwYXJ0X3N0YXRfaW5j
KGJkZXYsIGlvc1tzZ3JwXSk7Cj4gKwlwYXJ0X3N0YXRfYWRkKGJkZXYsIHNlY3RvcnNbc2dycF0s
IHNlY3RvcnMpOwo+ICAgCXBhcnRfc3RhdF9hZGQoYmRldiwgbnNlY3Nbc2dycF0sIGppZmZpZXNf
dG9fbnNlY3MoZHVyYXRpb24pKTsKPiAgIAlwYXJ0X3N0YXRfbG9jYWxfZGVjKGJkZXYsIGluX2Zs
aWdodFtvcF9pc193cml0ZShvcCldKTsKPiAgIAlwYXJ0X3N0YXRfdW5sb2NrKCk7Cj4gQEAgLTEw
MDEsNyArOTk3LDcgQEAgRVhQT1JUX1NZTUJPTChiZGV2X2VuZF9pb19hY2N0KTsKPiAgIHZvaWQg
YmlvX2VuZF9pb19hY2N0X3JlbWFwcGVkKHN0cnVjdCBiaW8gKmJpbywgdW5zaWduZWQgbG9uZyBz
dGFydF90aW1lLAo+ICAgCQkJICAgICAgc3RydWN0IGJsb2NrX2RldmljZSAqb3JpZ19iZGV2KQo+
ICAgewo+IC0JYmRldl9lbmRfaW9fYWNjdChvcmlnX2JkZXYsIGJpb19vcChiaW8pLCBzdGFydF90
aW1lKTsKPiArCWJkZXZfZW5kX2lvX2FjY3Qob3JpZ19iZGV2LCBiaW9fb3AoYmlvKSwgYmlvX3Nl
Y3RvcnMoYmlvKSwgc3RhcnRfdGltZSk7Cj4gICB9Cj4gICBFWFBPUlRfU1lNQk9MX0dQTChiaW9f
ZW5kX2lvX2FjY3RfcmVtYXBwZWQpOwo+ICAgCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0u
YyBiL2RyaXZlcnMvbWQvZG0uYwo+IGluZGV4IGVhY2U0NWExOGQ0NS4uZjVjYzMzMGJiNTQ5IDEw
MDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvZG0uYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0uYwo+IEBA
IC01MTIsMTAgKzUxMiwxMCBAQCBzdGF0aWMgdm9pZCBkbV9pb19hY2N0KHN0cnVjdCBkbV9pbyAq
aW8sIGJvb2wgZW5kKQo+ICAgCQlzZWN0b3JzID0gaW8tPnNlY3RvcnM7Cj4gICAKPiAgIAlpZiAo
IWVuZCkKPiAtCQliZGV2X3N0YXJ0X2lvX2FjY3QoYmlvLT5iaV9iZGV2LCBzZWN0b3JzLCBiaW9f
b3AoYmlvKSwKPiAtCQkJCSAgIHN0YXJ0X3RpbWUpOwo+ICsJCWJkZXZfc3RhcnRfaW9fYWNjdChi
aW8tPmJpX2JkZXYsIGJpb19vcChiaW8pLCBzdGFydF90aW1lKTsKPiAgIAllbHNlCj4gLQkJYmRl
dl9lbmRfaW9fYWNjdChiaW8tPmJpX2JkZXYsIGJpb19vcChiaW8pLCBzdGFydF90aW1lKTsKPiAr
CQliZGV2X2VuZF9pb19hY2N0KGJpby0+YmlfYmRldiwgYmlvX29wKGJpbyksIHNlY3RvcnMsCj4g
KwkJCQkgc3RhcnRfdGltZSk7Cj4gICAKPiAgIAlpZiAoc3RhdGljX2JyYW5jaF91bmxpa2VseSgm
c3RhdHNfZW5hYmxlZCkgJiYKPiAgIAkgICAgdW5saWtlbHkoZG1fc3RhdHNfdXNlZCgmbWQtPnN0
YXRzKSkpIHsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgYi9k
cml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYwo+IGluZGV4IGZjMzlkMDFlN2I2My4uOTE3MTQ1
MmUyZjZkIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jCj4gKysr
IGIvZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMKPiBAQCAtMTIzLDkgKzEyMyw4IEBAIHZv
aWQgbnZtZV9tcGF0aF9zdGFydF9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0ICpycSkKPiAgIAkJcmV0
dXJuOwo+ICAgCj4gICAJbnZtZV9yZXEocnEpLT5mbGFncyB8PSBOVk1FX01QQVRIX0lPX1NUQVRT
Owo+IC0JbnZtZV9yZXEocnEpLT5zdGFydF90aW1lID0gYmRldl9zdGFydF9pb19hY2N0KGRpc2st
PnBhcnQwLAo+IC0JCQkJCWJsa19ycV9ieXRlcyhycSkgPj4gU0VDVE9SX1NISUZULAo+IC0JCQkJ
CXJlcV9vcChycSksIGppZmZpZXMpOwo+ICsJbnZtZV9yZXEocnEpLT5zdGFydF90aW1lID0gYmRl
dl9zdGFydF9pb19hY2N0KGRpc2stPnBhcnQwLCByZXFfb3AocnEpLAo+ICsJCQkJCQkgICAgICBq
aWZmaWVzKTsKPiAgIH0KPiAgIEVYUE9SVF9TWU1CT0xfR1BMKG52bWVfbXBhdGhfc3RhcnRfcmVx
dWVzdCk7Cj4gICAKPiBAQCAtMTM2LDcgKzEzNSw4IEBAIHZvaWQgbnZtZV9tcGF0aF9lbmRfcmVx
dWVzdChzdHJ1Y3QgcmVxdWVzdCAqcnEpCj4gICAJaWYgKCEobnZtZV9yZXEocnEpLT5mbGFncyAm
IE5WTUVfTVBBVEhfSU9fU1RBVFMpKQo+ICAgCQlyZXR1cm47Cj4gICAJYmRldl9lbmRfaW9fYWNj
dChucy0+aGVhZC0+ZGlzay0+cGFydDAsIHJlcV9vcChycSksCj4gLQkJbnZtZV9yZXEocnEpLT5z
dGFydF90aW1lKTsKPiArCQkJIGJsa19ycV9ieXRlcyhycSkgPj4gU0VDVE9SX1NISUZULAo+ICsJ
CQkgbnZtZV9yZXEocnEpLT5zdGFydF90aW1lKTsKPiAgIH0KPiAgIAo+ICAgdm9pZCBudm1lX2tp
Y2tfcmVxdWV1ZV9saXN0cyhzdHJ1Y3QgbnZtZV9jdHJsICpjdHJsKQo+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2Jsa2Rldi5oIGIvaW5jbHVkZS9saW51eC9ibGtkZXYuaAo+IGluZGV4IGQx
YWVlMDhmOGMxOC4uOTQxMzA0ZjE3NDkyIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvYmxr
ZGV2LmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oCj4gQEAgLTE0NDYsMTEgKzE0NDYs
MTAgQEAgc3RhdGljIGlubGluZSB2b2lkIGJsa193YWtlX2lvX3Rhc2soc3RydWN0IHRhc2tfc3Ry
dWN0ICp3YWl0ZXIpCj4gICAJCXdha2VfdXBfcHJvY2Vzcyh3YWl0ZXIpOwo+ICAgfQo+ICAgCj4g
LXVuc2lnbmVkIGxvbmcgYmRldl9zdGFydF9pb19hY2N0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJk
ZXYsCj4gLQkJCQkgdW5zaWduZWQgaW50IHNlY3RvcnMsIGVudW0gcmVxX29wIG9wLAo+ICt1bnNp
Z25lZCBsb25nIGJkZXZfc3RhcnRfaW9fYWNjdChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBl
bnVtIHJlcV9vcCBvcCwKPiAgIAkJCQkgdW5zaWduZWQgbG9uZyBzdGFydF90aW1lKTsKPiAgIHZv
aWQgYmRldl9lbmRfaW9fYWNjdChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBlbnVtIHJlcV9v
cCBvcCwKPiAtCQl1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWUpOwo+ICsJCSAgICAgIHVuc2lnbmVk
IGludCBzZWN0b3JzLCB1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWUpOwo+ICAgCj4gICB1bnNpZ25l
ZCBsb25nIGJpb19zdGFydF9pb19hY2N0KHN0cnVjdCBiaW8gKmJpbyk7Cj4gICB2b2lkIGJpb19l
bmRfaW9fYWNjdF9yZW1hcHBlZChzdHJ1Y3QgYmlvICpiaW8sIHVuc2lnbmVkIGxvbmcgc3RhcnRf
dGltZSwKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

