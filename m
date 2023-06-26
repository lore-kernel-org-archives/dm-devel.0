Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B924EB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 09:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687770071;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=L8Lng001mtDa4P+3XO6GjUrHzdoETFRg03/98f7C4YU=;
	b=HzbS1wzjYNNGKYhbwwDti+/xyLzFhaoCdJUeNaac+vMmqcULTtKodJiaodPu4mCrNzjfB/
	4GtHb/bVKhjafenc/xG7Qpm8LpPPLZ1N5VwnlqIa9jCg/3I+OMKkcjxpsM8fSfa3CrkDpL
	Xo6oo9u23ZIG0VpG5cff1AixEZERRPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-BI1kGZB7Ng6eAuxMg0CJJg-1; Mon, 26 Jun 2023 05:01:07 -0400
X-MC-Unique: BI1kGZB7Ng6eAuxMg0CJJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5CFA8A7F42;
	Mon, 26 Jun 2023 09:01:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C87D401061;
	Mon, 26 Jun 2023 09:00:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3277B1946588;
	Mon, 26 Jun 2023 09:00:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B43AF1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 09:00:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A30EE112132D; Mon, 26 Jun 2023 09:00:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C2731121319
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 09:00:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 624928CC23B
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 09:00:57 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-N2ipKKidMSuZAr6V7NKIZw-1; Mon, 26 Jun 2023 05:00:53 -0400
X-MC-Unique: N2ipKKidMSuZAr6V7NKIZw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QqLvv5shpz4f472W;
 Mon, 26 Jun 2023 16:43:07 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP2 (Coremail) with SMTP id Syh0CgD3nOqcT5lk9Ej2MQ--.2529S3;
 Mon, 26 Jun 2023 16:43:09 +0800 (CST)
Message-ID: <7f1f7798-dd56-919f-cd59-22cfcafae342@huaweicloud.com>
Date: Mon, 26 Jun 2023 16:43:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: yangerkun <yangerkun@huaweicloud.com>, snitzer@kernel.org,
 agk@redhat.com, jefflexu@linux.alibaba.com, dm-devel@redhat.com
References: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
 <b96155f3-0f6c-273d-4e0a-24fe05bb618a@huaweicloud.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <b96155f3-0f6c-273d-4e0a-24fe05bb618a@huaweicloud.com>
X-CM-TRANSID: Syh0CgD3nOqcT5lk9Ej2MQ--.2529S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur4kur4ruF17JF4fGr48JFb_yoWrWF4fpF
 n5JrW5GrW8Gr1kKr1Utr1UJFy5Jr18J3Z8Jr4xXFyUJr15XryFqr17Zr1qgr1UAF48Jr4U
 Ar4UJFnrZr1xArJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
 Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
 UUU
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: reexport sysfs of kcryptd
 workqueue
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
Cc: yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksIE1pa2UsCgpTb3JyeSBmb3IgdGhlIG5vaXNlLiBUaGlzIHBhdGNoIGhhcyBiZWVuIHByb3Bv
c2VkIGZvciBhIGxvbmcgdGltZS4gSSAKd29uZGVyIGRvZXMgdGhlcmUgYW55IHN1Z2dlc3Rpb24g
Zm9yIHRoZSBwYXRjaC4gTG9va2luZyBmb3J3YXJkIHRvIHlvdXIgCnJlcGx5IQoKVGhhbmtzLApZ
YW5nIEVya3VuLgoK5ZyoIDIwMjMvMy8yNSA5OjAxLCB5YW5nZXJrdW4g5YaZ6YGTOgo+IFBpbmcu
Li4KPiAKPiDlnKggMjAyMy8zLzEgMTE6MjksIHlhbmdlcmt1biDlhpnpgZM6Cj4+IEZyb206IHlh
bmdlcmt1biA8eWFuZ2Vya3VuQGh1YXdlaS5jb20+Cj4+Cj4+IE9uY2UgdGhlcmUgaXMgYSBoZWF2
eSBJTyBsb2FkLCBzbyBtYW55IGVuY3J5cHQvZGVjcnlwdCB3b3JrIHdpbGwgb2NjdXB5Cj4+IGFs
bCBvZiB0aGUgY3B1LCB3aGljaCBtYXkgbGVhZCB0aGUgcG9vciBwZXJmb3JtYW5jZSBmb3Igb3Ro
ZXIgc2VydmljZS4KPj4gU28gdGhlIGlkZWEgbGlrZSAnYTJiOGIyZDk3NTY3ICgiZG0gY3J5cHQ6
IGV4cG9ydCBzeXNmcyBvZiBrY3J5cHRkCj4+IHdvcmtxdWV1ZSIpJyBzYWlkIHNlZW1zIG5lY2Vz
c2FyeS4gV2UgY2FuIGV4cG9ydCAia2NyeXB0ZCIgd29ya3F1ZXVlCj4+IHN5c2ZzLCB0aGUgZW50
cnkgbGlrZSBjcHVtYXNrL21heF9hY3RpdmUgYW5kIHNvIG9uIGNhbiBoZWxwIHVzIHRvIGxpbWl0
Cj4+IHRoZSB1c2FnZSBmb3IgZW5jcnlwdC9kZWNyeXB0IHdvcmsuCj4+Cj4+IEhvd2V2ZXIsIHRo
YXQgY29tbWl0IGRvZXMgbm90IGNvbnNpZGVyIHRoZSByZWxvYWQgdGFibGUgd2lsbCBjYWxsIC5j
dHIKPj4gYmVmb3JlIC5kdHIsIHNvIHRoZSByZWxvYWQgZm9yIGRtLWNyeXB0IHdpbGwgZmFpbCBz
aW5jZSB0aGUgc2FtZSBzeXNmcwo+PiBwcm9ibGVtLCBhbmQgdGhlbiB3ZSByZXZlcnQgdGhhdCBj
b21taXQoJzQ4YjA3NzdjZDkzZCAoIlJldmVydCAiZG0KPj4gY3J5cHQ6IGV4cG9ydCBzeXNmcyBv
ZiBrY3J5cHRkIHdvcmtxdWV1ZSIiKScpLgo+Pgo+PiBBY3R1YWxseSwgd2hhdCB3ZSBzaG91bGQg
ZG8gaXMgZ2l2ZSBhIHVuaXF1ZSBuYW1lIG9uY2Ugd2UgdHJ5IHJlbG9hZAo+PiB0YWJsZSwgd2Ug
Y2FuIHVzZSBpZGEgdG8gZml4IHRoZSBwcm9ibGVtLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiB5YW5n
ZXJrdW4gPHlhbmdlcmt1bkBodWF3ZWkuY29tPgo+PiAtLS0KPj4gwqAgZHJpdmVycy9tZC9kbS1j
cnlwdC5jIHwgMjggKysrKysrKysrKysrKysrKysrKysrKystLS0tLQo+PiDCoCAxIGZpbGUgY2hh
bmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPj4KPj4gdjEtPnYyOgo+PiBy
ZXdyaXR0ZW4gdGhlIGNvbW1pdCBtc2cKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0t
Y3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+PiBpbmRleCA0MGNiMTcxOWFlNGQuLjk0
OGQxZTExZDA2NCAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4+ICsrKyBi
L2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+PiBAQCAtNDcsNiArNDcsOCBAQAo+PiDCoCAjZGVmaW5l
IERNX01TR19QUkVGSVggImNyeXB0Igo+PiArc3RhdGljIERFRklORV9JREEoY3J5cHRfcXVldWVf
aWRhKTsKPj4gKwo+PiDCoCAvKgo+PiDCoMKgICogY29udGV4dCBob2xkaW5nIHRoZSBjdXJyZW50
IHN0YXRlIG9mIGEgbXVsdGktcGFydCBjb252ZXJzaW9uCj4+IMKgwqAgKi8KPj4gQEAgLTE4MCw2
ICsxODIsNyBAQCBzdHJ1Y3QgY3J5cHRfY29uZmlnIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHN0
cnVjdCBjcnlwdG9fYWVhZCAqKnRmbXNfYWVhZDsKPj4gwqDCoMKgwqDCoCB9IGNpcGhlcl90Zm07
Cj4+IMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IHRmbXNfY291bnQ7Cj4+ICvCoMKgwqAgaW50IGNy
eXB0X3F1ZXVlX2lkOwo+PiDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgY2lwaGVyX2ZsYWdzOwo+
PiDCoMKgwqDCoMKgIC8qCj4+IEBAIC0yNzA0LDYgKzI3MDcsOSBAQCBzdGF0aWMgdm9pZCBjcnlw
dF9kdHIoc3RydWN0IGRtX3RhcmdldCAqdGkpCj4+IMKgwqDCoMKgwqAgaWYgKGNjLT5jcnlwdF9x
dWV1ZSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGRlc3Ryb3lfd29ya3F1ZXVlKGNjLT5jcnlwdF9x
dWV1ZSk7Cj4+ICvCoMKgwqAgaWYgKGNjLT5jcnlwdF9xdWV1ZV9pZCkKPj4gK8KgwqDCoMKgwqDC
oMKgIGlkYV9mcmVlKCZjcnlwdF9xdWV1ZV9pZGEsIGNjLT5jcnlwdF9xdWV1ZV9pZCk7Cj4+ICsK
Pj4gwqDCoMKgwqDCoCBjcnlwdF9mcmVlX3RmbXMoY2MpOwo+PiDCoMKgwqDCoMKgIGJpb3NldF9l
eGl0KCZjYy0+YnMpOwo+PiBAQCAtMzM0MCwxMiArMzM0NiwyNCBAQCBzdGF0aWMgaW50IGNyeXB0
X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgCj4+IHVuc2lnbmVkIGludCBhcmdjLCBjaGFyICoq
YXJndikKPj4gwqDCoMKgwqDCoCB9Cj4+IMKgwqDCoMKgwqAgaWYgKHRlc3RfYml0KERNX0NSWVBU
X1NBTUVfQ1BVLCAmY2MtPmZsYWdzKSkKPj4gLcKgwqDCoMKgwqDCoMKgIGNjLT5jcnlwdF9xdWV1
ZSA9IGFsbG9jX3dvcmtxdWV1ZSgia2NyeXB0ZC8lcyIsIAo+PiBXUV9DUFVfSU5URU5TSVZFIHwg
V1FfTUVNX1JFQ0xBSU0sCj4+ICvCoMKgwqDCoMKgwqDCoCBjYy0+Y3J5cHRfcXVldWUgPSBhbGxv
Y193b3JrcXVldWUoImtjcnlwdGQtJXMiLCAKPj4gV1FfQ1BVX0lOVEVOU0lWRSB8IFdRX01FTV9S
RUNMQUlNLAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgMSwgZGV2bmFtZSk7Cj4+IC3CoMKgwqAgZWxzZQo+PiAtwqDCoMKgwqDCoMKgwqAg
Y2MtPmNyeXB0X3F1ZXVlID0gYWxsb2Nfd29ya3F1ZXVlKCJrY3J5cHRkLyVzIiwKPj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdRX0NQVV9JTlRF
TlNJVkUgfCBXUV9NRU1fUkVDTEFJTSB8IAo+PiBXUV9VTkJPVU5ELAo+PiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbnVtX29ubGluZV9jcHVzKCks
IGRldm5hbWUpOwo+PiArwqDCoMKgIGVsc2Ugewo+PiArwqDCoMKgwqDCoMKgwqAgaW50IGlkID0g
aWRhX2FsbG9jX21pbigmY3J5cHRfcXVldWVfaWRhLCAxLCBHRlBfS0VSTkVMKTsKPj4gKwo+PiAr
wqDCoMKgwqDCoMKgwqAgaWYgKGlkIDwgMCkgewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0
aS0+ZXJyb3IgPSAiQ291bGRuJ3QgZ2V0IGtjcnlwdGQgcXVldWUgaWQiOwo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByZXQgPSBpZDsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBi
YWQ7Cj4+ICvCoMKgwqDCoMKgwqDCoCB9Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGNjLT5jcnlw
dF9xdWV1ZV9pZCA9IGlkOwo+PiArwqDCoMKgwqDCoMKgwqAgY2MtPmNyeXB0X3F1ZXVlID0gYWxs
b2Nfd29ya3F1ZXVlKCJrY3J5cHRkLSVzLSVkIiwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdRX0NQVV9JTlRFTlNJVkUgfCBXUV9NRU1fUkVD
TEFJTSB8Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBXUV9VTkJPVU5EIHwgV1FfU1lTRlMsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBudW1fb25saW5lX2NwdXMoKSwgZGV2bmFtZSwgaWQp
Owo+PiArwqDCoMKgIH0KPj4gKwo+PiDCoMKgwqDCoMKgIGlmICghY2MtPmNyeXB0X3F1ZXVlKSB7
Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB0aS0+ZXJyb3IgPSAiQ291bGRuJ3QgY3JlYXRlIGtjcnlw
dGQgcXVldWUiOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBiYWQ7Cj4gCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

