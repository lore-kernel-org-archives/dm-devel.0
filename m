Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D708C678D5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 10:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678185921;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d82WXpYLfO0YJBQod0gg/Aq3TCKVNua9L9KwtDsX5rU=;
	b=LonWtxYN+PIV0d3dyXJvSbRS/gw4TjaWeb81SwOmDcuNfISWvOqllu3DGGk4n9rlr1V4SQ
	I3+na3His31lEFHl0rQcoTGPKWybK8e6dUJOt6NCNaHEVkSW+MVjKFSkhq/Wpbbvm/M7Gu
	wRrE9/EvRavUdk+GxasDcV6GEAVQJ3M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-ziyhnr8SNpmYX2b0PdrXpg-1; Tue, 07 Mar 2023 05:45:18 -0500
X-MC-Unique: ziyhnr8SNpmYX2b0PdrXpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFB05877CA2;
	Tue,  7 Mar 2023 10:45:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9167F40C10FA;
	Tue,  7 Mar 2023 10:45:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4FBD519465A3;
	Tue,  7 Mar 2023 10:45:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3EBB81946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 10:44:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B76A492B00; Tue,  7 Mar 2023 10:44:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 13965492C3E
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 10:44:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E999F811E9C
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 10:44:58 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-yrB3IA0TOhSh02WSCFGabA-1; Tue, 07 Mar 2023 05:44:55 -0500
X-MC-Unique: yrB3IA0TOhSh02WSCFGabA-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PWBsX2VKjz4f3l78;
 Tue,  7 Mar 2023 18:44:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgCnUiChFQdkhMH6EQ--.23182S3;
 Tue, 07 Mar 2023 18:44:50 +0800 (CST)
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, guz.fnst@cn.fujitsu.com
References: <20230223091226.1135678-1-yukuai1@huaweicloud.com>
 <05bbc421-100c-c18d-4261-e5669cfdfb94@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a4d8f6b5-cc8e-204e-1039-5f2b98042bdd@huaweicloud.com>
Date: Tue, 7 Mar 2023 18:44:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <05bbc421-100c-c18d-4261-e5669cfdfb94@huaweicloud.com>
X-CM-TRANSID: _Ch0CgCnUiChFQdkhMH6EQ--.23182S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKw47KF15GF1xCFWDGr4kZwb_yoW3Jr1kpF
 1kGFy5JrWUWw1vgr1UJw1DGFyrtr1Utw17Ar47JFyUAw48Jr1vqr1UXr1qgr1UArWkJFyU
 A3W8Zr9rZr47JrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1U
 MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
 VFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wMi8yOCA5OjAxLCBZdSBLdWFpIOWGmemBkzoKPiBIaSwKPiAKPiBmcmll
bmRseSBwaW5nIC4uLgo+IAo+IFRoYW5rcywKPiBLdWFpCj4gCj4g5ZyoIDIwMjMvMDIvMjMgMTc6
MTIsIFl1IEt1YWkg5YaZ6YGTOgo+PiBGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+
Cj4+Cj4+IFdoaWxlIHVzaW5nIGlvc3RhdCBmb3IgcmFpZCwgSSBvYnNlcnZlZCB2ZXJ5IHN0cmFu
Z2UgJ2F3YWl0Jwo+PiBvY2Nhc2lvbmFsbHksIGFuZCB0dXJucyBvdXQgaXQncyBkdWUgdG8gdGhh
dCAnaW9zJyBhbmQgJ3NlY3RvcnMnIGlzCj4+IGNvdW50ZWQgaW4gYmRldl9zdGFydF9pb19hY2N0
KCksIHdoaWxlICduc2VjcycgaXMgY291bnRlZCBpbgo+PiBiZGV2X2VuZF9pb19hY2N0KCkuIEkn
bSBub3Qgc3VyZSB3aHkgdGhleSBhcmUgY2NvdW50ZWQgbGlrZSB0aGF0Cj4+IGJ1dCBJIHRoaW5r
IHRoaXMgYmVoYXZpb3VyIGlzIG9idmlvdXNseSB3cm9uZyBiZWNhdXNlIHVzZXIgd2lsbCBnZXQK
Pj4gd3JvbmcgZGlzayBzdGF0cy4KPj4KPj4gRml4IHRoZSBwcm9ibGVtIGJ5IGNvdW50aW5nICdp
b3MnIGFuZCAnc2VjdG9ycycgd2hlbiBpbyBpcyBkb25lLCBsaWtlCj4+IHdoYXQgcnEtYmFzZWQg
ZGV2aWNlIGRvZXMuCgpDYW4gYW55b25lIGhlbHAgdG8gcmV2aWV3IHRoaXMgY2hhbmdlPyBPciBp
cyB0aGVyZSBhbnkgcmVhc29uIHRvIGNvdW50Cidpb3MnIGFuZCAnc2VjdG9ycycgd2hlbiBpbyBp
cyBzdGFydGVkPwoKVGhhbmtzLApLdWFpCj4+Cj4+IEZpeGVzOiAzOTRmZmE1MDNiYzQgKCJibGs6
IGludHJvZHVjZSBnZW5lcmljIGlvIHN0YXQgYWNjb3VudGluZyBoZWxwIAo+PiBmdW5jdGlvbiIp
Cj4+IFNpZ25lZC1vZmYtYnk6IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4gLS0tCj4+
IMKgIGJsb2NrL2Jsay1jb3JlLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDE2ICsrKysr
Ky0tLS0tLS0tLS0KPj4gwqAgZHJpdmVycy9tZC9kbS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8wqAgNiArKystLS0KPj4gwqAgZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgfMKg
IDggKysrKy0tLS0KPj4gwqAgaW5jbHVkZS9saW51eC9ibGtkZXYuaMKgwqDCoMKgwqDCoMKgIHzC
oCA1ICsrLS0tCj4+IMKgIDQgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMjAgZGVs
ZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9ibG9jay9ibGstY29yZS5jIGIvYmxvY2svYmxr
LWNvcmUuYwo+PiBpbmRleCA4MmI1YjJjNTNmMWUuLmZlMWQzMjBmNWYwNyAxMDA2NDQKPj4gLS0t
IGEvYmxvY2svYmxrLWNvcmUuYwo+PiArKysgYi9ibG9jay9ibGstY29yZS5jCj4+IEBAIC05NTMs
MTYgKzk1MywxMSBAQCB2b2lkIHVwZGF0ZV9pb190aWNrcyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpw
YXJ0LCAKPj4gdW5zaWduZWQgbG9uZyBub3csIGJvb2wgZW5kKQo+PiDCoMKgwqDCoMKgIH0KPj4g
wqAgfQo+PiAtdW5zaWduZWQgbG9uZyBiZGV2X3N0YXJ0X2lvX2FjY3Qoc3RydWN0IGJsb2NrX2Rl
dmljZSAqYmRldiwKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVk
IGludCBzZWN0b3JzLCBlbnVtIHJlcV9vcCBvcCwKPj4gK3Vuc2lnbmVkIGxvbmcgYmRldl9zdGFy
dF9pb19hY2N0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGVudW0gCj4+IHJlcV9vcCBvcCwK
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgc3Rh
cnRfdGltZSkKPj4gwqAgewo+PiAtwqDCoMKgIGNvbnN0IGludCBzZ3JwID0gb3Bfc3RhdF9ncm91
cChvcCk7Cj4+IC0KPj4gwqDCoMKgwqDCoCBwYXJ0X3N0YXRfbG9jaygpOwo+PiDCoMKgwqDCoMKg
IHVwZGF0ZV9pb190aWNrcyhiZGV2LCBzdGFydF90aW1lLCBmYWxzZSk7Cj4+IC3CoMKgwqAgcGFy
dF9zdGF0X2luYyhiZGV2LCBpb3Nbc2dycF0pOwo+PiAtwqDCoMKgIHBhcnRfc3RhdF9hZGQoYmRl
diwgc2VjdG9yc1tzZ3JwXSwgc2VjdG9ycyk7Cj4+IMKgwqDCoMKgwqAgcGFydF9zdGF0X2xvY2Fs
X2luYyhiZGV2LCBpbl9mbGlnaHRbb3BfaXNfd3JpdGUob3ApXSk7Cj4+IMKgwqDCoMKgwqAgcGFy
dF9zdGF0X3VubG9jaygpOwo+PiBAQCAtOTc4LDEzICs5NzMsMTIgQEAgRVhQT1JUX1NZTUJPTChi
ZGV2X3N0YXJ0X2lvX2FjY3QpOwo+PiDCoMKgICovCj4+IMKgIHVuc2lnbmVkIGxvbmcgYmlvX3N0
YXJ0X2lvX2FjY3Qoc3RydWN0IGJpbyAqYmlvKQo+PiDCoCB7Cj4+IC3CoMKgwqAgcmV0dXJuIGJk
ZXZfc3RhcnRfaW9fYWNjdChiaW8tPmJpX2JkZXYsIGJpb19zZWN0b3JzKGJpbyksCj4+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJpb19vcChiaW8pLCBqaWZmaWVzKTsKPj4g
K8KgwqDCoCByZXR1cm4gYmRldl9zdGFydF9pb19hY2N0KGJpby0+YmlfYmRldiwgYmlvX29wKGJp
byksIGppZmZpZXMpOwo+PiDCoCB9Cj4+IMKgIEVYUE9SVF9TWU1CT0xfR1BMKGJpb19zdGFydF9p
b19hY2N0KTsKPj4gwqAgdm9pZCBiZGV2X2VuZF9pb19hY2N0KHN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkZXYsIGVudW0gcmVxX29wIG9wLAo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5z
aWduZWQgbG9uZyBzdGFydF90aW1lKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5z
aWduZWQgaW50IHNlY3RvcnMsIHVuc2lnbmVkIGxvbmcgc3RhcnRfdGltZSkKPj4gwqAgewo+PiDC
oMKgwqDCoMKgIGNvbnN0IGludCBzZ3JwID0gb3Bfc3RhdF9ncm91cChvcCk7Cj4+IMKgwqDCoMKg
wqAgdW5zaWduZWQgbG9uZyBub3cgPSBSRUFEX09OQ0UoamlmZmllcyk7Cj4+IEBAIC05OTIsNiAr
OTg2LDggQEAgdm9pZCBiZGV2X2VuZF9pb19hY2N0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYs
IAo+PiBlbnVtIHJlcV9vcCBvcCwKPj4gwqDCoMKgwqDCoCBwYXJ0X3N0YXRfbG9jaygpOwo+PiDC
oMKgwqDCoMKgIHVwZGF0ZV9pb190aWNrcyhiZGV2LCBub3csIHRydWUpOwo+PiArwqDCoMKgIHBh
cnRfc3RhdF9pbmMoYmRldiwgaW9zW3NncnBdKTsKPj4gK8KgwqDCoCBwYXJ0X3N0YXRfYWRkKGJk
ZXYsIHNlY3RvcnNbc2dycF0sIHNlY3RvcnMpOwo+PiDCoMKgwqDCoMKgIHBhcnRfc3RhdF9hZGQo
YmRldiwgbnNlY3Nbc2dycF0sIGppZmZpZXNfdG9fbnNlY3MoZHVyYXRpb24pKTsKPj4gwqDCoMKg
wqDCoCBwYXJ0X3N0YXRfbG9jYWxfZGVjKGJkZXYsIGluX2ZsaWdodFtvcF9pc193cml0ZShvcCld
KTsKPj4gwqDCoMKgwqDCoCBwYXJ0X3N0YXRfdW5sb2NrKCk7Cj4+IEBAIC0xMDAxLDcgKzk5Nyw3
IEBAIEVYUE9SVF9TWU1CT0woYmRldl9lbmRfaW9fYWNjdCk7Cj4+IMKgIHZvaWQgYmlvX2VuZF9p
b19hY2N0X3JlbWFwcGVkKHN0cnVjdCBiaW8gKmJpbywgdW5zaWduZWQgbG9uZyAKPj4gc3RhcnRf
dGltZSwKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGJs
b2NrX2RldmljZSAqb3JpZ19iZGV2KQo+PiDCoCB7Cj4+IC3CoMKgwqAgYmRldl9lbmRfaW9fYWNj
dChvcmlnX2JkZXYsIGJpb19vcChiaW8pLCBzdGFydF90aW1lKTsKPj4gK8KgwqDCoCBiZGV2X2Vu
ZF9pb19hY2N0KG9yaWdfYmRldiwgYmlvX29wKGJpbyksIGJpb19zZWN0b3JzKGJpbyksIAo+PiBz
dGFydF90aW1lKTsKPj4gwqAgfQo+PiDCoCBFWFBPUlRfU1lNQk9MX0dQTChiaW9fZW5kX2lvX2Fj
Y3RfcmVtYXBwZWQpOwo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9t
ZC9kbS5jCj4+IGluZGV4IGVhY2U0NWExOGQ0NS4uZjVjYzMzMGJiNTQ5IDEwMDY0NAo+PiAtLS0g
YS9kcml2ZXJzL21kL2RtLmMKPj4gKysrIGIvZHJpdmVycy9tZC9kbS5jCj4+IEBAIC01MTIsMTAg
KzUxMiwxMCBAQCBzdGF0aWMgdm9pZCBkbV9pb19hY2N0KHN0cnVjdCBkbV9pbyAqaW8sIGJvb2wg
ZW5kKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgc2VjdG9ycyA9IGlvLT5zZWN0b3JzOwo+PiDCoMKg
wqDCoMKgIGlmICghZW5kKQo+PiAtwqDCoMKgwqDCoMKgwqAgYmRldl9zdGFydF9pb19hY2N0KGJp
by0+YmlfYmRldiwgc2VjdG9ycywgYmlvX29wKGJpbyksCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc3RhcnRfdGltZSk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBiZGV2X3N0
YXJ0X2lvX2FjY3QoYmlvLT5iaV9iZGV2LCBiaW9fb3AoYmlvKSwgc3RhcnRfdGltZSk7Cj4+IMKg
wqDCoMKgwqAgZWxzZQo+PiAtwqDCoMKgwqDCoMKgwqAgYmRldl9lbmRfaW9fYWNjdChiaW8tPmJp
X2JkZXYsIGJpb19vcChiaW8pLCBzdGFydF90aW1lKTsKPj4gK8KgwqDCoMKgwqDCoMKgIGJkZXZf
ZW5kX2lvX2FjY3QoYmlvLT5iaV9iZGV2LCBiaW9fb3AoYmlvKSwgc2VjdG9ycywKPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0YXJ0X3RpbWUpOwo+PiDCoMKgwqDCoMKgIGlm
IChzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZzdGF0c19lbmFibGVkKSAmJgo+PiDCoMKgwqDCoMKg
wqDCoMKgwqAgdW5saWtlbHkoZG1fc3RhdHNfdXNlZCgmbWQtPnN0YXRzKSkpIHsKPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jIAo+PiBiL2RyaXZlcnMvbnZtZS9o
b3N0L211bHRpcGF0aC5jCj4+IGluZGV4IGZjMzlkMDFlN2I2My4uOTE3MTQ1MmUyZjZkIDEwMDY0
NAo+PiAtLS0gYS9kcml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYwo+PiArKysgYi9kcml2ZXJz
L252bWUvaG9zdC9tdWx0aXBhdGguYwo+PiBAQCAtMTIzLDkgKzEyMyw4IEBAIHZvaWQgbnZtZV9t
cGF0aF9zdGFydF9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0ICpycSkKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybjsKPj4gwqDCoMKgwqDCoCBudm1lX3JlcShycSktPmZsYWdzIHw9IE5WTUVfTVBB
VEhfSU9fU1RBVFM7Cj4+IC3CoMKgwqAgbnZtZV9yZXEocnEpLT5zdGFydF90aW1lID0gYmRldl9z
dGFydF9pb19hY2N0KGRpc2stPnBhcnQwLAo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgYmxrX3JxX2J5dGVzKHJxKSA+PiBTRUNUT1JfU0hJRlQsCj4+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXFfb3AocnEpLCBqaWZmaWVzKTsKPj4g
K8KgwqDCoCBudm1lX3JlcShycSktPnN0YXJ0X3RpbWUgPSBiZGV2X3N0YXJ0X2lvX2FjY3QoZGlz
ay0+cGFydDAsIAo+PiByZXFfb3AocnEpLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBqaWZmaWVzKTsKPj4gwqAgfQo+PiDCoCBF
WFBPUlRfU1lNQk9MX0dQTChudm1lX21wYXRoX3N0YXJ0X3JlcXVlc3QpOwo+PiBAQCAtMTM2LDcg
KzEzNSw4IEBAIHZvaWQgbnZtZV9tcGF0aF9lbmRfcmVxdWVzdChzdHJ1Y3QgcmVxdWVzdCAqcnEp
Cj4+IMKgwqDCoMKgwqAgaWYgKCEobnZtZV9yZXEocnEpLT5mbGFncyAmIE5WTUVfTVBBVEhfSU9f
U1RBVFMpKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+PiDCoMKgwqDCoMKgIGJkZXZf
ZW5kX2lvX2FjY3QobnMtPmhlYWQtPmRpc2stPnBhcnQwLCByZXFfb3AocnEpLAo+PiAtwqDCoMKg
wqDCoMKgwqAgbnZtZV9yZXEocnEpLT5zdGFydF90aW1lKTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBibGtfcnFfYnl0ZXMocnEpID4+IFNFQ1RPUl9TSElGVCwKPj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBudm1lX3JlcShycSktPnN0YXJ0X3RpbWUpOwo+PiDCoCB9Cj4+IMKgIHZv
aWQgbnZtZV9raWNrX3JlcXVldWVfbGlzdHMoc3RydWN0IG52bWVfY3RybCAqY3RybCkKPj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmxrZGV2LmggYi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5o
Cj4+IGluZGV4IGQxYWVlMDhmOGMxOC4uOTQxMzA0ZjE3NDkyIDEwMDY0NAo+PiAtLS0gYS9pbmNs
dWRlL2xpbnV4L2Jsa2Rldi5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gQEAg
LTE0NDYsMTEgKzE0NDYsMTAgQEAgc3RhdGljIGlubGluZSB2b2lkIGJsa193YWtlX2lvX3Rhc2so
c3RydWN0IAo+PiB0YXNrX3N0cnVjdCAqd2FpdGVyKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgd2Fr
ZV91cF9wcm9jZXNzKHdhaXRlcik7Cj4+IMKgIH0KPj4gLXVuc2lnbmVkIGxvbmcgYmRldl9zdGFy
dF9pb19hY2N0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgc2VjdG9ycywgZW51bSByZXFfb3Agb3AsCj4+
ICt1bnNpZ25lZCBsb25nIGJkZXZfc3RhcnRfaW9fYWNjdChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpi
ZGV2LCBlbnVtIAo+PiByZXFfb3Agb3AsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWUpOwo+PiDCoCB2b2lkIGJkZXZfZW5kX2lv
X2FjY3Qoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgZW51bSByZXFfb3Agb3AsCj4+IC3CoMKg
wqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWUpOwo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IHNlY3RvcnMsIHVuc2lnbmVkIGxvbmcgc3RhcnRfdGlt
ZSk7Cj4+IMKgIHVuc2lnbmVkIGxvbmcgYmlvX3N0YXJ0X2lvX2FjY3Qoc3RydWN0IGJpbyAqYmlv
KTsKPj4gwqAgdm9pZCBiaW9fZW5kX2lvX2FjY3RfcmVtYXBwZWQoc3RydWN0IGJpbyAqYmlvLCB1
bnNpZ25lZCBsb25nIAo+PiBzdGFydF90aW1lLAo+Pgo+IAo+IC4KPiAKCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

