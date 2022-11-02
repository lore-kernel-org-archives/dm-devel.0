Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B852C43219
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=etsmenuY868MDnW79OkSIWa5vxHk1CJ6C+f1atV5two=;
	b=QkJNqWxMn6lJHBexlkqMZZDvb9sR4I1VgDBhR0n1zm7lW8yv+vhsEchopBOIYBlRYUkAPq
	ik78Uge5d+nDxrcK6J9pz0LqckvKz+eIo1te2jGYklA9j5XUm+12wx1jp5lmdiSBulGYW2
	CO8ioEG/nB7YPFLfJROXDHGAa3KLx+s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-b49h_TqjNQ6RBbXQg6wMRQ-1; Thu, 03 Nov 2022 03:57:19 -0400
X-MC-Unique: b49h_TqjNQ6RBbXQg6wMRQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E42292A5957F;
	Thu,  3 Nov 2022 07:57:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1AD54A9268;
	Thu,  3 Nov 2022 07:57:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84BED19465B3;
	Thu,  3 Nov 2022 07:57:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D275F1946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 12:25:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C231C49BB66; Wed,  2 Nov 2022 12:25:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA5AE49BB60
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 12:25:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F50D86F12E
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 12:25:07 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-5BJ5ZbH8OdC5sTiiBWRg_A-1; Wed, 02 Nov 2022 08:22:39 -0400
X-MC-Unique: 5BJ5ZbH8OdC5sTiiBWRg_A-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N2Qtv6pFyzKHbg;
 Wed,  2 Nov 2022 20:19:51 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP2 (Coremail) with SMTP id Syh0CgD33NECYWJjG8T2BA--.21321S3;
 Wed, 02 Nov 2022 20:22:26 +0800 (CST)
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
References: <20221102064854.GA8950@lst.de>
 <1dc5c1d0-72b6-5455-0b05-5c755ad69045@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2a618e55-33d7-1090-c906-0b44ad4832b8@huaweicloud.com>
Date: Wed, 2 Nov 2022 20:22:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1dc5c1d0-72b6-5455-0b05-5c755ad69045@huaweicloud.com>
X-CM-TRANSID: Syh0CgD33NECYWJjG8T2BA--.21321S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1fWF4fWFWUZr4ftFyDtrb_yoW5WFW3pr
 95KrW8GryUJr1kXF4Utw1UXFy5Zw1UJ3W8Jrn7XF12qr43Jr4qvr1UXryjgr17Jr4Ivr4U
 Jr1UXr43ZF1UCrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF9a9DU
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] [PATCH 8/7] block: don't claim devices that are not
 live in bd_link_disk_holder
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
Cc: linux-block@vger.kernel.org, "yukuai \(C\)" <yukuai3@huawei.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

5ZyoIDIwMjIvMTEvMDIgMjA6MTcsIFl1IEt1YWkg5YaZ6YGTOgo+IEhpLAo+IAo+IOWcqCAyMDIy
LzExLzAyIDE0OjQ4LCBDaHJpc3RvcGggSGVsbHdpZyDlhpnpgZM6Cj4+IEZvciBnZW5kaXNrIHRo
YXQgYXJlIG5vdCBsaXZlIG9yIHRoZWlyIHBhcnRpdGlvbnMsIHRoZSBiZF9ob2xkZXJfZGlyCj4+
IHBvaW50ZXIgaXMgbm90IHZhbGlkIGFuZCB0aGUga29iamVjdCBtaWdodCBub3QgaGF2ZSBiZWVu
IGFsbG9jYXRlZAo+PiB5ZXQgb3IgZnJlZWQgYWxyZWFkeS7CoCBDaGVjayB0aGF0IHRoZSBkaXNr
IGlzIGxpdmUgYmVmb3JlIGNyZWF0aW5nIHRoZQo+PiBsaW5rYWdlIGFuZCBlcnJvciBvdXQgb3Ro
ZXJ3aXNlLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4KPj4gLS0tCj4+IMKgIGJsb2NrL2hvbGRlci5jIHwgNSArKysrKwo+PiDCoCAxIGZpbGUgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS9ibG9jay9ob2xkZXIuYyBi
L2Jsb2NrL2hvbGRlci5jCj4+IGluZGV4IGE4YzM1NWI5ZDA4MDYuLmE4ODA2YmJlZDIxMTIgMTAw
NjQ0Cj4+IC0tLSBhL2Jsb2NrL2hvbGRlci5jCj4+ICsrKyBiL2Jsb2NrL2hvbGRlci5jCj4+IEBA
IC02Niw2ICs2NiwxMSBAQCBpbnQgYmRfbGlua19kaXNrX2hvbGRlcihzdHJ1Y3QgYmxvY2tfZGV2
aWNlICpiZGV2LCAKPj4gc3RydWN0IGdlbmRpc2sgKmRpc2spCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVJTlZBTDsKPj4gwqDCoMKgwqDCoCBtdXRleF9sb2NrKCZkaXNrLT5vcGVuX211
dGV4KTsKPj4gK8KgwqDCoCAvKiBiZF9ob2xkZXJfZGlyIGlzIG9ubHkgdmFsaWQgZm9yIGxpdmUg
ZGlza3MgKi8KPj4gK8KgwqDCoCBpZiAoIWRpc2tfbGl2ZShiZGV2LT5iZF9kaXNrKSkgewo+PiAr
wqDCoMKgwqDCoMKgwqAgcmV0ID0gLUVJTlZBTDsKPj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8gb3V0
X3VubG9jazsKPj4gK8KgwqDCoCB9Cj4gCj4gSSB0aGluayB0aGlzIGlzIHN0aWxsIG5vdCBzYWZl
IPCfpJQKPiAKPiBIb3cgYWJvdXQgdGhpczoKPiAKPiBkaWZmIC0tZ2l0IGEvYmxvY2svaG9sZGVy
LmMgYi9ibG9jay9ob2xkZXIuYwo+IGluZGV4IDUyODNiYzgwNGNjMS4uMzVmZGZiYTU1OGI4IDEw
MDY0NAo+IC0tLSBhL2Jsb2NrL2hvbGRlci5jCj4gKysrIGIvYmxvY2svaG9sZGVyLmMKPiBAQCAt
ODUsNiArODUsMjAgQEAgaW50IGJkX2xpbmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2NrX2Rldmlj
ZSAqYmRldiwgCj4gc3RydWN0IGdlbmRpc2sgKmRpc2spCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBnb3RvIG91dF91bmxvY2s7Cj4gIMKgwqDCoMKgwqDCoMKgIH0KPiAKPiArwqDC
oMKgwqDCoMKgIC8qCj4gK8KgwqDCoMKgwqDCoMKgICogZGVsX2dlbmRpc2sgZHJvcHMgdGhlIGlu
aXRpYWwgcmVmZXJlbmNlIHRvIGJkX2hvbGRlcl9kaXIsIHNvIAo+IHdlIG5lZWQKPiArwqDCoMKg
wqDCoMKgwqAgKiB0byBrZWVwIG91ciBvd24gaGVyZSB0byBhbGxvdyBmb3IgY2xlYW51cCBwYXN0
IHRoYXQgcG9pbnQuCj4gK8KgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDCoMKgwqDCoCBtdXRleF9s
b2NrKCZiZGV2LT5iZF9kaXNrLT5vcGVuX211dGV4KTsKPiArwqDCoMKgwqDCoMKgIGlmICghZGlz
a19saXZlKGJkZXYtPmJkX2Rpc2spKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0ID0gLUVOT0RFVjsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtdXRleF91bmxv
Y2soJmJkZXYtPmJkX2Rpc2stPm9wZW5fbXV0ZXgpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGdvdG8gb3V0X3VubG9jazsKPiArwqDCoMKgwqDCoMKgIH0KPiArCj4gK8KgwqDCoMKg
wqDCoCBrb2JqZWN0X2dldChiZGV2LT5iZF9ob2xkZXJfZGlyKTsKPiArwqDCoMKgwqDCoMKgIG11
dGV4X3VubG9jaygmYmRldi0+YmRfZGlzay0+b3Blbl9tdXRleCk7Cj4gKwo+ICDCoMKgwqDCoMKg
wqDCoCBob2xkZXIgPSBremFsbG9jKHNpemVvZigqaG9sZGVyKSwgR0ZQX0tFUk5FTCk7Cj4gIMKg
wqDCoMKgwqDCoMKgIGlmICghaG9sZGVyKSB7Cj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXQgPSAtRU5PTUVNOwo+IEBAIC0xMDMsMTEgKzExNyw2IEBAIGludCBiZF9saW5rX2Rp
c2tfaG9sZGVyKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIAo+IHN0cnVjdCBnZW5kaXNrICpk
aXNrKQo+ICDCoMKgwqDCoMKgwqDCoCB9Cj4gCj4gIMKgwqDCoMKgwqDCoMKgIGxpc3RfYWRkKCZo
b2xkZXItPmxpc3QsICZkaXNrLT5zbGF2ZV9iZGV2cyk7Cj4gLcKgwqDCoMKgwqDCoCAvKgo+IC3C
oMKgwqDCoMKgwqDCoCAqIGRlbF9nZW5kaXNrIGRyb3BzIHRoZSBpbml0aWFsIHJlZmVyZW5jZSB0
byBiZF9ob2xkZXJfZGlyLCBzbyAKPiB3ZSBuZWVkCj4gLcKgwqDCoMKgwqDCoMKgICogdG8ga2Vl
cCBvdXIgb3duIGhlcmUgdG8gYWxsb3cgZm9yIGNsZWFudXAgcGFzdCB0aGF0IHBvaW50Lgo+IC3C
oMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDCoMKgwqAga29iamVjdF9nZXQoYmRldi0+YmRfaG9s
ZGVyX2Rpcik7Cj4gCj4gYmRldi0+YmRfZGlzay0+b3Blbl9tdXRleCBzaG91bGQgYmUgaG9sZCwg
Ym90aCBkaXNfbGl2ZSgpIGFuZAo+IGtvYmplY3RfZ2V0KCkgc2hvdWxkIGJlIHByb3RlY3RlZC4K
PiAKCkFuZCBrb2JqZWN0IHJlZmVyZW5jZSBzaG91bGQgYmUgZGVjcmVhc2VkIGluIHRoZSBmb2xs
b3dpbmcgZXJyb3IgcGF0aAoKVGhhbmtzLApLdWFpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

