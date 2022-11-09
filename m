Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC7CC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 06:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667976201;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LIY7cetolplSDnyKysFAYfLzzJFkw3EWXoU/ldtrRNo=;
	b=DxRtglQ24h3PNTtdYr+VruFRF3SNkAq7jbXl8cXX9C66sLGL4YjVYhjrOE0BTArtgFf55x
	JDXDbk2SoHuJxxoyce8Bgi3Bb0e2HMmKOTxVJI+yrQTgJ/gyddC+LBHeXKoBUzkhdx+Egp
	xWvQAyVvDEtzHi+b010XfTouQf5/Qyo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-O-pbXOppNsKUlMAsk9V-_Q-1; Wed, 09 Nov 2022 01:43:18 -0500
X-MC-Unique: O-pbXOppNsKUlMAsk9V-_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31CC588646B;
	Wed,  9 Nov 2022 06:43:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 590B54EA49;
	Wed,  9 Nov 2022 06:43:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EB001946594;
	Wed,  9 Nov 2022 06:43:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F7021946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 02:08:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6F0A1415102; Wed,  9 Nov 2022 02:08:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE388140EBF3
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 02:08:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3473101AA46
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 02:08:23 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-tEqXPmaoNueiIkenEgxRDw-1; Tue, 08 Nov 2022 21:08:20 -0500
X-MC-Unique: tEqXPmaoNueiIkenEgxRDw-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N6Szx3H3pz4f3kq9;
 Wed,  9 Nov 2022 10:08:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP1 (Coremail) with SMTP id cCh0CgC3YK+OC2tjAinPAA--.44026S3;
 Wed, 09 Nov 2022 10:08:16 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-6-hch@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9b5b4c2a-6566-2fb4-d3ae-4904f0889ea0@huaweicloud.com>
Date: Wed, 9 Nov 2022 10:08:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221030153120.1045101-6-hch@lst.de>
X-CM-TRANSID: cCh0CgC3YK+OC2tjAinPAA--.44026S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGFy7Jry7Cr4xKw48GF1fCrg_yoWrGFyfpF
 Z8WasIqrW8JFsF9w47Xw4j9Fy5Krs5ta4F9r1xC34I9wnYyr909FWfGFy3XFyDJ397GF45
 XFWUtrs8ua18KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
 Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
 UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 09 Nov 2022 06:43:14 +0000
Subject: Re: [dm-devel] [PATCH 5/7] dm: track per-add_disk holder relations
 in DM
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
Cc: linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIyLzEwLzMwIDIzOjMxLCBDaHJpc3RvcGggSGVsbHdpZyDQtLXAOgo+IGRtIGlz
IGEgYml0IHNwZWNpYWwgaW4gdGhhdCBpdCBvcGVucyB0aGUgdW5kZXJseWluZyBkZXZpY2VzLiAg
Q29tbWl0Cj4gODlmODcxYWYxYjI2ICgiZG06IGRlbGF5IHJlZ2lzdGVyaW5nIHRoZSBnZW5kaXNr
IikgdHJpZWQgdG8gYWNjb21vZGF0ZQo+IHRoYXQgYnkgYWxsb3dpbmcgdG8gYWRkIHRoZSBob2xk
ZXIgdG8gdGhlIGxpc3QgYmVmb3JlIGFkZF9nZW5kaXNrIGFuZAo+IHRoZW4ganVzdCBhZGQgdGhl
bSB0byBzeXNmcyBvbmNlIGFkZF9kaXNrIGlzIGNhbGxlZC4gIEJ1dCB0aGF0IGxlYWRzIHRvCj4g
cmVhbGx5IG9kZCBsaWZldGltZSBwcm9ibGVtcyBhbmQgZXJyb3IgaGFuZGxpbmcgcHJvYmxlbXMg
YXMgd2UgY2FuJ3QKPiBrbm93IHRoZSBzdGF0ZSBvZiB0aGUga29iamVjdHMgYW5kIGRvbid0IHVu
d2luZCBwcm9wZXJseS4gIFRvIGZpeCB0aGlzCj4gc3dpdGNoIHRvIGp1c3QgcmVnaXN0ZXJpbmcg
YWxsIGV4aXN0aW5nIHRhYmxlX2RldmljZXMgd2l0aCB0aGUgaG9sZGVyCj4gY29kZSByaWdodCBh
ZnRlciBhZGRfZGlzaywgYW5kIHJlbW92ZSB0aGVtIGJlZm9yZSBjYWxsaW5nIGRlbF9nZW5kaXNr
Lgo+IAo+IEZpeGVzOiA4OWY4NzFhZjFiMjYgKCJkbTogZGVsYXkgcmVnaXN0ZXJpbmcgdGhlIGdl
bmRpc2siKQo+IFJlcG9ydGVkLWJ5OiBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4K
PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiAtLS0KPiAg
IGRyaXZlcnMvbWQvZG0uYyB8IDQ1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDM3IGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0uYyBiL2RyaXZlcnMvbWQvZG0u
Ywo+IGluZGV4IDI5MTc3MDBiMWUxNWMuLjdiMGQ2ZGM5NTc1NDkgMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9tZC9kbS5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS5jCj4gQEAgLTc1MSw5ICs3NTEsMTYg
QEAgc3RhdGljIHN0cnVjdCB0YWJsZV9kZXZpY2UgKm9wZW5fdGFibGVfZGV2aWNlKHN0cnVjdCBt
YXBwZWRfZGV2aWNlICptZCwKPiAgIAkJZ290byBvdXRfZnJlZV90ZDsKPiAgIAl9Cj4gICAKPiAt
CXIgPSBiZF9saW5rX2Rpc2tfaG9sZGVyKGJkZXYsIGRtX2Rpc2sobWQpKTsKPiAtCWlmIChyKQo+
IC0JCWdvdG8gb3V0X2Jsa2Rldl9wdXQ7Cj4gKwkvKgo+ICsJICogV2UgY2FuIGJlIGNhbGxlZCBi
ZWZvcmUgdGhlIGRtIGRpc2sgaXMgYWRkZWQuICBJbiB0aGF0IGNhc2Ugd2UgY2FuJ3QKPiArCSAq
IHJlZ2lzdGVyIHRoZSBob2xkZXIgcmVsYXRpb24gaGVyZS4gIEl0IHdpbGwgYmUgZG9uZSBvbmNl
IGFkZF9kaXNrIHdhcwo+ICsJICogY2FsbGVkLgo+ICsJICovCj4gKwlpZiAobWQtPmRpc2stPnNs
YXZlX2RpcikgewpJZiBkZXZpY2VfYWRkX2Rpc2soKSBvciBkZWxfZ2VuZGlzaygpIGNhbiBjb25j
dXJyZW50IHdpdGggdGhpcywgSXQgc2VlbXMKdG8gbWUgdGhhdCB1c2luZyAnc2xhdmVfZGlyJyBp
cyBub3Qgc2FmZS4KCkknbSBub3QgcXVpdGUgZmFtaWxpYXIgd2l0aCBkbSwgY2FuIHdlIGd1YXJh
bnRlZSB0aGF0IHRoZXkgY2FuJ3QKY29uY3VycmVudD8KClRoYW5rcywKS3VhaQo+ICsJCXIgPSBi
ZF9saW5rX2Rpc2tfaG9sZGVyKGJkZXYsIG1kLT5kaXNrKTsKPiArCQlpZiAocikKPiArCQkJZ290
byBvdXRfYmxrZGV2X3B1dDsKPiArCX0KPiAgIAo+ICAgCXRkLT5kbV9kZXYubW9kZSA9IG1vZGU7
Cj4gICAJdGQtPmRtX2Rldi5iZGV2ID0gYmRldjsKPiBAQCAtNzc0LDcgKzc4MSw4IEBAIHN0YXRp
YyBzdHJ1Y3QgdGFibGVfZGV2aWNlICpvcGVuX3RhYmxlX2RldmljZShzdHJ1Y3QgbWFwcGVkX2Rl
dmljZSAqbWQsCj4gICAgKi8KPiAgIHN0YXRpYyB2b2lkIGNsb3NlX3RhYmxlX2RldmljZShzdHJ1
Y3QgdGFibGVfZGV2aWNlICp0ZCwgc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kKQo+ICAgewo+IC0J
YmRfdW5saW5rX2Rpc2tfaG9sZGVyKHRkLT5kbV9kZXYuYmRldiwgZG1fZGlzayhtZCkpOwo+ICsJ
aWYgKG1kLT5kaXNrLT5zbGF2ZV9kaXIpCj4gKwkJYmRfdW5saW5rX2Rpc2tfaG9sZGVyKHRkLT5k
bV9kZXYuYmRldiwgbWQtPmRpc2spOwo+ICAgCWJsa2Rldl9wdXQodGQtPmRtX2Rldi5iZGV2LCB0
ZC0+ZG1fZGV2Lm1vZGUgfCBGTU9ERV9FWENMKTsKPiAgIAlwdXRfZGF4KHRkLT5kbV9kZXYuZGF4
X2Rldik7Cj4gICAJbGlzdF9kZWwoJnRkLT5saXN0KTsKPiBAQCAtMTk1MSw3ICsxOTU5LDEzIEBA
IHN0YXRpYyB2b2lkIGNsZWFudXBfbWFwcGVkX2RldmljZShzdHJ1Y3QgbWFwcGVkX2RldmljZSAq
bWQpCj4gICAJCW1kLT5kaXNrLT5wcml2YXRlX2RhdGEgPSBOVUxMOwo+ICAgCQlzcGluX3VubG9j
aygmX21pbm9yX2xvY2spOwo+ICAgCQlpZiAoZG1fZ2V0X21kX3R5cGUobWQpICE9IERNX1RZUEVf
Tk9ORSkgewo+ICsJCQlzdHJ1Y3QgdGFibGVfZGV2aWNlICp0ZDsKPiArCj4gICAJCQlkbV9zeXNm
c19leGl0KG1kKTsKPiArCQkJbGlzdF9mb3JfZWFjaF9lbnRyeSh0ZCwgJm1kLT50YWJsZV9kZXZp
Y2VzLCBsaXN0KSB7Cj4gKwkJCQliZF91bmxpbmtfZGlza19ob2xkZXIodGQtPmRtX2Rldi5iZGV2
LAo+ICsJCQkJCQkgICAgICBtZC0+ZGlzayk7Cj4gKwkJCX0KPiAgIAkJCWRlbF9nZW5kaXNrKG1k
LT5kaXNrKTsKPiAgIAkJfQo+ICAgCQlkbV9xdWV1ZV9kZXN0cm95X2NyeXB0b19wcm9maWxlKG1k
LT5xdWV1ZSk7Cj4gQEAgLTIyODQsNiArMjI5OCw3IEBAIGludCBkbV9zZXR1cF9tZF9xdWV1ZShz
dHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQsIHN0cnVjdCBkbV90YWJsZSAqdCkKPiAgIHsKPiAgIAll
bnVtIGRtX3F1ZXVlX21vZGUgdHlwZSA9IGRtX3RhYmxlX2dldF90eXBlKHQpOwo+ICAgCXN0cnVj
dCBxdWV1ZV9saW1pdHMgbGltaXRzOwo+ICsJc3RydWN0IHRhYmxlX2RldmljZSAqdGQ7Cj4gICAJ
aW50IHI7Cj4gICAKPiAgIAlzd2l0Y2ggKHR5cGUpIHsKPiBAQCAtMjMxNiwxMyArMjMzMSwyNyBA
QCBpbnQgZG1fc2V0dXBfbWRfcXVldWUoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kLCBzdHJ1Y3Qg
ZG1fdGFibGUgKnQpCj4gICAJaWYgKHIpCj4gICAJCXJldHVybiByOwo+ICAgCj4gLQlyID0gZG1f
c3lzZnNfaW5pdChtZCk7Cj4gLQlpZiAocikgewo+IC0JCWRlbF9nZW5kaXNrKG1kLT5kaXNrKTsK
PiAtCQlyZXR1cm4gcjsKPiArCS8qCj4gKwkgKiBSZWdpc3RlciB0aGUgaG9sZGVyIHJlbGF0aW9u
c2hpcCBmb3IgZGV2aWNlcyBhZGRlZCBiZWZvcmUgdGhlIGRpc2sKPiArCSAqIHdhcyBsaXZlLgo+
ICsJICovCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHRkLCAmbWQtPnRhYmxlX2RldmljZXMsIGxp
c3QpIHsKPiArCQlyID0gYmRfbGlua19kaXNrX2hvbGRlcih0ZC0+ZG1fZGV2LmJkZXYsIG1kLT5k
aXNrKTsKPiArCQlpZiAocikKPiArCQkJZ290byBvdXRfdW5kb19ob2xkZXJzOwo+ICAgCX0KPiAr
Cj4gKwlyID0gZG1fc3lzZnNfaW5pdChtZCk7Cj4gKwlpZiAocikKPiArCQlnb3RvIG91dF91bmRv
X2hvbGRlcnM7Cj4gICAJbWQtPnR5cGUgPSB0eXBlOwo+ICAgCXJldHVybiAwOwo+ICsKPiArb3V0
X3VuZG9faG9sZGVyczoKPiArCWxpc3RfZm9yX2VhY2hfZW50cnlfY29udGludWVfcmV2ZXJzZSh0
ZCwgJm1kLT50YWJsZV9kZXZpY2VzLCBsaXN0KQo+ICsJCWJkX3VubGlua19kaXNrX2hvbGRlcih0
ZC0+ZG1fZGV2LmJkZXYsIG1kLT5kaXNrKTsKPiArCWRlbF9nZW5kaXNrKG1kLT5kaXNrKTsKPiAr
CXJldHVybiByOwo+ICAgfQo+ICAgCj4gICBzdHJ1Y3QgbWFwcGVkX2RldmljZSAqZG1fZ2V0X21k
KGRldl90IGRldikKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

