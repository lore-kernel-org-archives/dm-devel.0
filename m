Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090DBC00140
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 01:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659315900;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YgzAyhZdbCh5T2mXeLetNr/BM4d8F/kWTNvvKihjHzE=;
	b=gYCFBrslj1EQnCd9/84iGYhBqNXdS7Cc99QC2jRRFWIfk0NUERlUYQedb07RwnDigtvcYi
	UL/6FPaSjaa0YT30xfY7ldUO/cecC1TDODXKs7DzRWa1de0uavp2OaMAmpvyRMPZbccPmX
	PqUlhk/v0088KNnJEb6SwElkoNeiLKM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-nxCY3LBsMJmTIBCDxN7sdQ-1; Sun, 31 Jul 2022 21:04:57 -0400
X-MC-Unique: nxCY3LBsMJmTIBCDxN7sdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A09B31C0BDE2;
	Mon,  1 Aug 2022 01:04:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86499C27D95;
	Mon,  1 Aug 2022 01:04:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66E1C1945D88;
	Mon,  1 Aug 2022 01:04:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D3AD51945D83
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 01:04:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C5D4D1121315; Mon,  1 Aug 2022 01:04:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1D3C1121314
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 01:04:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68DB23C025CB
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 01:04:50 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-sKnw3CeNOK24FQ2gNPquKg-1; Sun, 31 Jul 2022 21:04:47 -0400
X-MC-Unique: sKnw3CeNOK24FQ2gNPquKg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Lx0HN0WKszKH4k;
 Mon,  1 Aug 2022 09:03:28 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgA3tzCoJudi5cI3AA--.46416S3;
 Mon, 01 Aug 2022 09:04:41 +0800 (CST)
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
 <20210804094147.459763-8-hch@lst.de>
 <ad2c7878-dabb-cb41-1bba-60ef48fa1a9f@huaweicloud.com>
 <20220707052425.GA13016@lst.de>
 <fd5c2e0a-5f68-9f1f-dfc2-49a2cd51de0b@huaweicloud.com>
 <6ff5c130-b5b1-b611-bb99-6a2275404fcd@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a858472c-6899-a42e-d961-e82b7047ac7c@huaweicloud.com>
Date: Mon, 1 Aug 2022 09:04:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6ff5c130-b5b1-b611-bb99-6a2275404fcd@huaweicloud.com>
X-CM-TRANSID: _Ch0CgA3tzCoJudi5cI3AA--.46416S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFy3ZF17tw4fAF1kKF1DGFg_yoW8AFWfpa
 48JFs0krZrXrs7W397t34UZr9Yvr4UJw1UJry5GFyxKryDWr9Yqr4xXF4qgFy7Jr4kWr1j
 qF4Utry5Zr4kA37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
 6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9
 -UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 7/8] dm: delay registering the gendisk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
 "zhangyi \(F\)" <yi.zhang@huawei.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksIENocmlzdG9waCEKCuWcqCAyMDIyLzA3LzE1IDExOjI0LCBZdSBLdWFpIOWGmemBkzoKPiBI
aSwgQ2hyaXN0b3BoIQo+IAo+IOWcqCAyMDIyLzA3LzA3IDE1OjIwLCBZdSBLdWFpIOWGmemBkzoK
Pj4g5ZyoIDIwMjIvMDcvMDcgMTM6MjQsIENocmlzdG9waCBIZWxsd2lnIOWGmemBkzoKPj4+IE9u
IFRodSwgSnVsIDA3LCAyMDIyIGF0IDExOjI5OjI2QU0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6Cj4+
Pj4gV2UgZm91bmQgdGhhdCB0aGlzIHBhdGNoIGZpeCBhIG51bGxwdHIgY3Jhc2ggaW4gb3VyIHRl
c3Q6Cj4+Pgo+Pj4+IERvIHlvdSB0aGluayBpdCdzIG9rIHRvIGJhY2twb3J0IHRoaXMgcGF0Y2go
YW5kIGFsbCByZWFsdGVkIHBhdGNoZXMpIHRvCj4+Pj4gbHRzLCBvciBpdCdzIGJldHRlciB0byBm
aXggdGhhdCBiaW8gY2FuIGJlIHN1Ym1pdHRlZCB3aXRoIHF1ZXVlCj4+Pj4gdW5pbml0aWFsaXpl
ZCBmcm9tIGJsb2NrIGxheWVyPwo+Pj4KPj4+IEdpdmVuIGhvdyBsb25nIGFnbyB0aGlzIHdhcyBJ
IGRvIG5vdCByZW1lbWJlciBvZmZoYW5kIGhvdyBtdWNoIHByZXAKPj4+IHdvcmsgdGhpcyB3b3Vs
ZCByZXF1aXJlLsKgIFRoZSBwYXRjaCBpdHNlbGYgaXMgb2YgY291cnNlIHRpbnkgYW5kCj4+PiBi
YWNrcG9ydGFibGUsIGJ1dCBzb21lb25lIHdpbGwgbmVlZCB0byBkbyB0aGUgd29yayBhbmQgZmln
dXJlIG91dCBob3cKPj4+IG11Y2ggZWxzZSB3b3VsZCBoYXZlIHRvIGJlIGJhY2twb3J0ZWQuCj4+
Cj4+IE9rLCBJJ2xsIHRyeSB0byBmaWd1cmUgb3V0IHRoYXQsIGFuZCBiYWNrcG9ydCB0aGVtLihB
dCBsZWFzdCB0byA1LjEwLnkpCgpJIHBvc3RlZCBhIHN0YWJsZSBwYXRjaHNldCBvbiBzdGFibGUg
NS4xMCwgY2FuIHlvdSBwbGVhcyB0YWtlIGEgbG9vY2sgPwoKZG06IGZpeCBudWxscHRyIGNyYXNo
Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDcyOTA2MjM1Ni4xNjYzNTEzLTEteXVr
dWFpMUBodWF3ZWljbG91ZC5jb20vCgpUaGFua3MsCkt1YWkKPiAKPiBXaGlsZSByZXZpZXdpbmcg
dGhlIGNvZGUsIEkgZGlkbid0IGZvdW5kIGFueSBwcm90ZWN0aW9uIHRoYXQKPiBiZF9saW5rX2Rp
c2tfaG9sZGVyKCkgd29uJ3QgY29uY3VycmVudCB3aXRoCj4gYmRfcmVnaXN0ZXJfcGVuZGluZ19o
b2xkZXJzKCkuIElmIHRoZXkgZG8gY2FuIGNvbmN1cnJlbnQsCj4gZm9sbG93aW5nIHNjZW5hcmlv
IGlzIHByb2JsZW1hdGljOgo+IAo+IHQxwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHQy
Cj4gZGV2aWNlX2FkZF9kaXNrCj4gIMKgZGlzay0+c2xhdmVfZGlyID0ga29iamVjdF9jcmVhdGVf
YW5kX2FkZAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmRfbGlua19kaXNrX2hv
bGRlcgo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2xpbmtfZGlza19ob2xk
ZXIKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGlzdF9hZGQKPiAgwqBiZF9y
ZWdpc3Rlcl9wZW5kaW5nX2hvbGRlcnMKPiAgwqAgbGlzdF9mb3JfZWFjaF9lbnRyeQo+ICDCoMKg
IF9fbGlua19kaXNrX2hvbGRlciAtPiAtRUVYSVNUCj4gCj4gSW4gdGhpcyBjYXNlLCBJIHRoaW5r
IG1heWJlIGlnbm9yZSAnLUVFWElTVCcgaXMgZmluZS4KPiAKPiBJJ20gbm90IGZhbWlsaWFyIHdp
dGggZG0sIGFuZCBJJ20gbm90IHN1cmUgaWYgSSBtaXNzZWQgc29tZXRoaW5nLAo+IHBsZWFzZSBr
aW5kbHkgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcuCj4gCj4gVGhhbmtzLAo+IEt1YWkKPiAKPiAu
Cj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

