Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE412C76195
	for <dm-devel@archiver.kernel.org>; Sat, 25 Mar 2023 01:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679706121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=os9xAGZXy5EX0x29Z5S1lmfSY9uFpfChFZI9TqB2s8A=;
	b=AhdIdAXfHrRDNuj3WieSWHz+orwx6AnGl9HmiiJ+dbF4ttH0kS2kNJ+F27HW0UTcwdCvbF
	KU0CKvpOw6XurEJvpjTDSzhSLtQqa1b9RI6LXujAFfYUeVTvMyS/oyJ24uEXhJwVghU5in
	Q/FjQ5JK9pxR4aaFLeTFpnfeyMhESko=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-HzfFG4tZP-yKps7F5veprw-1; Fri, 24 Mar 2023 21:01:57 -0400
X-MC-Unique: HzfFG4tZP-yKps7F5veprw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45D2688B7AB;
	Sat, 25 Mar 2023 01:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4740D40BC797;
	Sat, 25 Mar 2023 01:01:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCC691946A5E;
	Sat, 25 Mar 2023 01:01:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 592DF1946A5A
 for <dm-devel@listman.corp.redhat.com>; Sat, 25 Mar 2023 01:01:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1598E40BC798; Sat, 25 Mar 2023 01:01:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EB5A40BC797
 for <dm-devel@redhat.com>; Sat, 25 Mar 2023 01:01:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3E3D88B7A0
 for <dm-devel@redhat.com>; Sat, 25 Mar 2023 01:01:52 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-HGIbfd6jOyKSOQsEfvR4lA-1; Fri, 24 Mar 2023 21:01:49 -0400
X-MC-Unique: HGIbfd6jOyKSOQsEfvR4lA-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Pk14R17ZPz4f3mJX;
 Sat, 25 Mar 2023 09:01:43 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP4 (Coremail) with SMTP id gCh0CgBnHbH3Rx5ksTAOGA--.22844S3;
 Sat, 25 Mar 2023 09:01:44 +0800 (CST)
Message-ID: <b96155f3-0f6c-273d-4e0a-24fe05bb618a@huaweicloud.com>
Date: Sat, 25 Mar 2023 09:01:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: snitzer@kernel.org, agk@redhat.com, jefflexu@linux.alibaba.com,
 dm-devel@redhat.com
References: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
X-CM-TRANSID: gCh0CgBnHbH3Rx5ksTAOGA--.22844S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur4DKF13Ww45AF1fZF13urg_yoW5WFWDpF
 s8Jr13G395Kr47K3sIyr1kGF9xJr18Gr9xCr4xZa4xCw15Wr9YgF12kF4rWrWkAFn5Ga18
 ZF4kKF4qkFZ2yrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Cc: yukuai3@huawei.com, yangerkun@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

UGluZy4uLgoK5ZyoIDIwMjMvMy8xIDExOjI5LCB5YW5nZXJrdW4g5YaZ6YGTOgo+IEZyb206IHlh
bmdlcmt1biA8eWFuZ2Vya3VuQGh1YXdlaS5jb20+Cj4gCj4gT25jZSB0aGVyZSBpcyBhIGhlYXZ5
IElPIGxvYWQsIHNvIG1hbnkgZW5jcnlwdC9kZWNyeXB0IHdvcmsgd2lsbCBvY2N1cHkKPiBhbGwg
b2YgdGhlIGNwdSwgd2hpY2ggbWF5IGxlYWQgdGhlIHBvb3IgcGVyZm9ybWFuY2UgZm9yIG90aGVy
IHNlcnZpY2UuCj4gU28gdGhlIGlkZWEgbGlrZSAnYTJiOGIyZDk3NTY3ICgiZG0gY3J5cHQ6IGV4
cG9ydCBzeXNmcyBvZiBrY3J5cHRkCj4gd29ya3F1ZXVlIiknIHNhaWQgc2VlbXMgbmVjZXNzYXJ5
LiBXZSBjYW4gZXhwb3J0ICJrY3J5cHRkIiB3b3JrcXVldWUKPiBzeXNmcywgdGhlIGVudHJ5IGxp
a2UgY3B1bWFzay9tYXhfYWN0aXZlIGFuZCBzbyBvbiBjYW4gaGVscCB1cyB0byBsaW1pdAo+IHRo
ZSB1c2FnZSBmb3IgZW5jcnlwdC9kZWNyeXB0IHdvcmsuCj4gCj4gSG93ZXZlciwgdGhhdCBjb21t
aXQgZG9lcyBub3QgY29uc2lkZXIgdGhlIHJlbG9hZCB0YWJsZSB3aWxsIGNhbGwgLmN0cgo+IGJl
Zm9yZSAuZHRyLCBzbyB0aGUgcmVsb2FkIGZvciBkbS1jcnlwdCB3aWxsIGZhaWwgc2luY2UgdGhl
IHNhbWUgc3lzZnMKPiBwcm9ibGVtLCBhbmQgdGhlbiB3ZSByZXZlcnQgdGhhdCBjb21taXQoJzQ4
YjA3NzdjZDkzZCAoIlJldmVydCAiZG0KPiBjcnlwdDogZXhwb3J0IHN5c2ZzIG9mIGtjcnlwdGQg
d29ya3F1ZXVlIiIpJykuCj4gCj4gQWN0dWFsbHksIHdoYXQgd2Ugc2hvdWxkIGRvIGlzIGdpdmUg
YSB1bmlxdWUgbmFtZSBvbmNlIHdlIHRyeSByZWxvYWQKPiB0YWJsZSwgd2UgY2FuIHVzZSBpZGEg
dG8gZml4IHRoZSBwcm9ibGVtLgo+IAo+IFNpZ25lZC1vZmYtYnk6IHlhbmdlcmt1biA8eWFuZ2Vy
a3VuQGh1YXdlaS5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL2RtLWNyeXB0LmMgfCAyOCArKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0aW9u
cygrKSwgNSBkZWxldGlvbnMoLSkKPiAKPiB2MS0+djI6Cj4gcmV3cml0dGVuIHRoZSBjb21taXQg
bXNnCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYyBiL2RyaXZlcnMvbWQv
ZG0tY3J5cHQuYwo+IGluZGV4IDQwY2IxNzE5YWU0ZC4uOTQ4ZDFlMTFkMDY0IDEwMDY0NAo+IC0t
LSBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+
IEBAIC00Nyw2ICs0Nyw4IEBACj4gICAKPiAgICNkZWZpbmUgRE1fTVNHX1BSRUZJWCAiY3J5cHQi
Cj4gICAKPiArc3RhdGljIERFRklORV9JREEoY3J5cHRfcXVldWVfaWRhKTsKPiArCj4gICAvKgo+
ICAgICogY29udGV4dCBob2xkaW5nIHRoZSBjdXJyZW50IHN0YXRlIG9mIGEgbXVsdGktcGFydCBj
b252ZXJzaW9uCj4gICAgKi8KPiBAQCAtMTgwLDYgKzE4Miw3IEBAIHN0cnVjdCBjcnlwdF9jb25m
aWcgewo+ICAgCQlzdHJ1Y3QgY3J5cHRvX2FlYWQgKip0Zm1zX2FlYWQ7Cj4gICAJfSBjaXBoZXJf
dGZtOwo+ICAgCXVuc2lnbmVkIGludCB0Zm1zX2NvdW50Owo+ICsJaW50IGNyeXB0X3F1ZXVlX2lk
Owo+ICAgCXVuc2lnbmVkIGxvbmcgY2lwaGVyX2ZsYWdzOwo+ICAgCj4gICAJLyoKPiBAQCAtMjcw
NCw2ICsyNzA3LDkgQEAgc3RhdGljIHZvaWQgY3J5cHRfZHRyKHN0cnVjdCBkbV90YXJnZXQgKnRp
KQo+ICAgCWlmIChjYy0+Y3J5cHRfcXVldWUpCj4gICAJCWRlc3Ryb3lfd29ya3F1ZXVlKGNjLT5j
cnlwdF9xdWV1ZSk7Cj4gICAKPiArCWlmIChjYy0+Y3J5cHRfcXVldWVfaWQpCj4gKwkJaWRhX2Zy
ZWUoJmNyeXB0X3F1ZXVlX2lkYSwgY2MtPmNyeXB0X3F1ZXVlX2lkKTsKPiArCj4gICAJY3J5cHRf
ZnJlZV90Zm1zKGNjKTsKPiAgIAo+ICAgCWJpb3NldF9leGl0KCZjYy0+YnMpOwo+IEBAIC0zMzQw
LDEyICszMzQ2LDI0IEBAIHN0YXRpYyBpbnQgY3J5cHRfY3RyKHN0cnVjdCBkbV90YXJnZXQgKnRp
LCB1bnNpZ25lZCBpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4gICAJfQo+ICAgCj4gICAJaWYgKHRl
c3RfYml0KERNX0NSWVBUX1NBTUVfQ1BVLCAmY2MtPmZsYWdzKSkKPiAtCQljYy0+Y3J5cHRfcXVl
dWUgPSBhbGxvY193b3JrcXVldWUoImtjcnlwdGQvJXMiLCBXUV9DUFVfSU5URU5TSVZFIHwgV1Ff
TUVNX1JFQ0xBSU0sCj4gKwkJY2MtPmNyeXB0X3F1ZXVlID0gYWxsb2Nfd29ya3F1ZXVlKCJrY3J5
cHRkLSVzIiwgV1FfQ1BVX0lOVEVOU0lWRSB8IFdRX01FTV9SRUNMQUlNLAo+ICAgCQkJCQkJICAx
LCBkZXZuYW1lKTsKPiAtCWVsc2UKPiAtCQljYy0+Y3J5cHRfcXVldWUgPSBhbGxvY193b3JrcXVl
dWUoImtjcnlwdGQvJXMiLAo+IC0JCQkJCQkgIFdRX0NQVV9JTlRFTlNJVkUgfCBXUV9NRU1fUkVD
TEFJTSB8IFdRX1VOQk9VTkQsCj4gLQkJCQkJCSAgbnVtX29ubGluZV9jcHVzKCksIGRldm5hbWUp
Owo+ICsJZWxzZSB7Cj4gKwkJaW50IGlkID0gaWRhX2FsbG9jX21pbigmY3J5cHRfcXVldWVfaWRh
LCAxLCBHRlBfS0VSTkVMKTsKPiArCj4gKwkJaWYgKGlkIDwgMCkgewo+ICsJCQl0aS0+ZXJyb3Ig
PSAiQ291bGRuJ3QgZ2V0IGtjcnlwdGQgcXVldWUgaWQiOwo+ICsJCQlyZXQgPSBpZDsKPiArCQkJ
Z290byBiYWQ7Cj4gKwkJfQo+ICsKPiArCQljYy0+Y3J5cHRfcXVldWVfaWQgPSBpZDsKPiArCQlj
Yy0+Y3J5cHRfcXVldWUgPSBhbGxvY193b3JrcXVldWUoImtjcnlwdGQtJXMtJWQiLAo+ICsJCQkJ
CQkgIFdRX0NQVV9JTlRFTlNJVkUgfCBXUV9NRU1fUkVDTEFJTSB8Cj4gKwkJCQkJCSAgV1FfVU5C
T1VORCB8IFdRX1NZU0ZTLAo+ICsJCQkJCQkgIG51bV9vbmxpbmVfY3B1cygpLCBkZXZuYW1lLCBp
ZCk7Cj4gKwl9Cj4gKwo+ICAgCWlmICghY2MtPmNyeXB0X3F1ZXVlKSB7Cj4gICAJCXRpLT5lcnJv
ciA9ICJDb3VsZG4ndCBjcmVhdGUga2NyeXB0ZCBxdWV1ZSI7Cj4gICAJCWdvdG8gYmFkOwoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

