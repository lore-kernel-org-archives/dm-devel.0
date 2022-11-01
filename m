Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A7EC43219
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667378507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7rqjLi5NGc+u5AcYc22VWWGl2WSC+Ld5vaMhpFt7Za8=;
	b=KlNfaKvZ40aVx6DnIfxHxeDbEpKWfo7Y/DZY2Z9ahV4k/wnxvJfuJfWwkOI7MFvPP5L5s/
	UvZ8pDfjiunRK5llU4rGx7sCI7OOz6arSDIpcpwanEBwljQOHcdwkyw0uacwQkNVAEOGk6
	VrRi4ias6MPCsLzShgqeDgWaYNvWun8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-oZXTEi2jMEiOKMxm-WrUmQ-1; Wed, 02 Nov 2022 04:41:44 -0400
X-MC-Unique: oZXTEi2jMEiOKMxm-WrUmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB6A31C0759E;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1FC1E40C6F9F;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 895211946A5A;
	Wed,  2 Nov 2022 08:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C0411946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 11:28:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3D509E70; Tue,  1 Nov 2022 11:28:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABC2153AA
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 11:28:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CD2286F12C
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 11:28:27 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-VupXQ7U_OhiSfRBZnIm6JQ-1; Tue, 01 Nov 2022 07:28:23 -0400
X-MC-Unique: VupXQ7U_OhiSfRBZnIm6JQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4N1nkz3sDqz6PmRJ;
 Tue,  1 Nov 2022 19:25:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP1 (Coremail) with SMTP id cCh0CgB3UXrRAmFjXyOJBA--.62160S3;
 Tue, 01 Nov 2022 19:28:19 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
 <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
 <20221101104927.GA13823@lst.de>
 <d3f6ec1d-8141-19d1-ce4c-d42710f4a636@huaweicloud.com>
 <20221101112131.GA14379@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <57465370-99fe-d8a5-e150-a1057640e972@huaweicloud.com>
Date: Tue, 1 Nov 2022 19:28:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221101112131.GA14379@lst.de>
X-CM-TRANSID: cCh0CgB3UXrRAmFjXyOJBA--.62160S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KryfXF15Cw1xAFykCr4kWFg_yoW8trW3pa
 98WF4rtrykGFWDXa1DKw17WFWj9r1UJ3W8CrySkrs2grZxJr92yr17Ary7XF13Crs2yr4q
 qF45X3yFvFWvkFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
 6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
 DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 02 Nov 2022 08:41:39 +0000
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIyLzExLzAxIDE5OjIxLCBDaHJpc3RvcGggSGVsbHdpZyDQtLXAOgo+IE9uIFR1
ZSwgTm92IDAxLCAyMDIyIGF0IDA3OjEyOjUxUE0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6Cj4+PiBC
dXQgaG93IGNvdWxkIHRoZSByZWZlcmVuY2UgYmUgMCBoZXJlPyAgVGhlIGRyaXZlciB0aGF0IGNh
bGxzCj4+PiBiZF9saW5rX2Rpc2tfaG9sZGVyIG11c3QgaGF2ZSB0aGUgYmxvY2sgZGV2aWNlIG9w
ZW4gYW5kIHRodXMgaG9sZCBhCj4+PiByZWZlcmVuY2UgdG8gaXQuCj4+Cj4+IExpa2UgSSBzYWlk
IGJlZm9yZSwgdGhlIGNhbGxlciBvZiBiZF9saW5rX2Rpc2tfaG9sZGVyKCkgZ2V0IGJkZXYgYnkK
Pj4gYmxrZGV2X2dldF9ieV9kZXYoKSwgd2hpY2ggZG8gbm90IGdyYWIgcmVmZXJlbmNlIG9mIGhv
bGRlcl9kaXIsIGFuZAo+PiBncmFiIGRpc2sgcmVmZXJlbmNlIGNhbiBvbmx5IHByZXZlbnQgZGlz
a19yZWxlYXNlKCkgdG8gYmUgY2FsbGVkLCBub3QKPj4gZGVsX2dlbmRpc2soKSB3aGlsZSBob2xk
ZXJfZGlyIHJlZmVyZW5jZSBpcyBkcm9wcGVkIGluIGRlbF9nZW5kaXNrKCkKPj4gYW5kIGNhbiBi
ZSBkZWNyZWFzZWQgdG8gMC4KPiAKPiBPaCwgdGhlIGJkX2hvbGRlcl9kaXIgcmVmZXJlbmNlLCBu
b3QgdGhlIGJsb2NrX2RldmljZSBvbmUuICBTbyB5ZXMsCj4gSSBhZ3JlZS4KPiAKPj4gSWYgeW91
IGFncmVlIHdpdGggYWJvdmUgZXhwbGFuYXRpb24sIEkgdHJpZWQgdG8gZml4IHRoaXM6Cj4+Cj4+
IDEpIG1vdmUga29iamVjdF9wdXQoYmRfaG9sZGVyX2RpcikgZnJvbSBkZWxfZ2VuZGlzayB0byBk
aXNrX3JlbGVhc2UsCj4+IHRoZXJlIHNlZW1zIHRvIGJlIGEgbG90IG9mIG90aGVyIGRlcGVuZGVu
Y2llcy4KPj4KPj4gMikgcHJvdGVjdCBiZF9ob2xkZXJfZGlyIHJlZmVyZW5jZSBieSBvcGVuX211
dGV4Lgo+IAo+IEkgdGhpbmsgc2ltcGx5IHN3aXRjaGluZyB0aGUga29iamVjdF9nZXQgaW4gYmRf
bGlua19kaXNrX2hvbGRlcgo+IGludG8gYSBrb2JqZWN0X2dldF91bmxlc3NfemVybyBhbmQgdW53
aW5kaW5nIGlmIHRoZXJlIGlzIG5vIHJlZmVyZW5jZQo+IHNob3VsZCBiZSBlbm91Z2g6Cj4gCj4g
ZGlmZiAtLWdpdCBhL2Jsb2NrL2hvbGRlci5jIGIvYmxvY2svaG9sZGVyLmMKPiBpbmRleCBhOGMz
NTViOWQwODA2Li5jZDE4MDY0ZjZmZjgwIDEwMDY0NAo+IC0tLSBhL2Jsb2NrL2hvbGRlci5jCj4g
KysrIGIvYmxvY2svaG9sZGVyLmMKPiBAQCAtODMsNyArODMsMTEgQEAgaW50IGJkX2xpbmtfZGlz
a19ob2xkZXIoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2sp
Cj4gICAKPiAgIAlJTklUX0xJU1RfSEVBRCgmaG9sZGVyLT5saXN0KTsKPiAgIAlob2xkZXItPnJl
ZmNudCA9IDE7Cj4gLQlob2xkZXItPmhvbGRlcl9kaXIgPSBrb2JqZWN0X2dldChiZGV2LT5iZF9o
b2xkZXJfZGlyKTsKPiArCWlmICgha29iamVjdF9nZXRfdW5sZXNzX3plcm8oYmRldi0+YmRfaG9s
ZGVyX2RpcikpIHsKPiArCQlyZXQgPSAtRUJVU1k7Cj4gKwkJZ290byBvdXRfZnJlZV9ob2xkZXI7
Cj4gKwl9Cj4gKwlob2xkZXItPmhvbGRlcl9kaXIgPSBiZGV2LT5iZF9ob2xkZXJfZGlyOwoKV2hh
dCBpZiBiZF9ob2xkZXJfZGlyIGlzIGFscmVhZHkgZnJlZWQgaGVyZSwgdGhlbiB1YWYgY2FuIGJl
IHRyaWdnZXJlZC4KVGh1cyBiZF9ob2xkZXJfZGlyIG5lZWQgdG8gYmUgcmVzZWQgaW4gZGVsX2dl
bmRpc2soKSBpZiBpdCdzIHJlZmVyZW5jZQppcyBkcm9wcGVkIHRvIDAsIGhvd2V2ZXIsIGtvYmpl
Y3QgYXBpcyBjYW4ndCBkbyB0aGF0Li4uCgpUaGFua3MsCkt1YWkKPiAgIAo+ICAgCXJldCA9IGFk
ZF9zeW1saW5rKGRpc2stPnNsYXZlX2RpciwgYmRldl9rb2JqKGJkZXYpKTsKPiAgIAlpZiAocmV0
KQo+IEBAIC0xMDAsNiArMTA0LDcgQEAgaW50IGJkX2xpbmtfZGlza19ob2xkZXIoc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4gICAJZGVsX3N5bWxpbmso
ZGlzay0+c2xhdmVfZGlyLCBiZGV2X2tvYmooYmRldikpOwo+ICAgb3V0X3B1dF9ob2xkZXJfZGly
Ogo+ICAgCWtvYmplY3RfcHV0KGhvbGRlci0+aG9sZGVyX2Rpcik7Cj4gK291dF9mcmVlX2hvbGRl
cjoKPiAgIAlrZnJlZShob2xkZXIpOwo+ICAgb3V0X3VubG9jazoKPiAgIAltdXRleF91bmxvY2so
JmRpc2stPm9wZW5fbXV0ZXgpOwo+IAo+IC4KPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwK

