Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E20C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 03:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657855481;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qHztTOwXPjy6PP5ABs8ATkG/Thtc9ME70y7W2x4LJWA=;
	b=eG+uiRaWIGz4+lwzg18hOT+piyMNz1WIqUmDW5W/OmE3thCa9URMQVoqcuqnKOXhiTlZou
	+O/HeRsHugByJLJkuQu0MsKj346i6l9YDHTg3qHyqIzBtmzG70Vg0SlsCUNXQF3Itz9Ova
	wIKMen5NeKIskxRD0T3uKoqksD5Of80=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-Z2vIojdTPiO11nUrErYQWA-1; Thu, 14 Jul 2022 23:24:37 -0400
X-MC-Unique: Z2vIojdTPiO11nUrErYQWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B8D1801755;
	Fri, 15 Jul 2022 03:24:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C77A140E8B04;
	Fri, 15 Jul 2022 03:24:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 944451947071;
	Fri, 15 Jul 2022 03:24:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 61CAF194706D
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 03:24:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53BA7492C3B; Fri, 15 Jul 2022 03:24:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FC4A492CA2
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 03:24:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35B21101A54E
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 03:24:31 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-mgT_iKJ0PPu-HQNMCOIBNA-1; Thu, 14 Jul 2022 23:24:22 -0400
X-MC-Unique: mgT_iKJ0PPu-HQNMCOIBNA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LkcBY1ZJpzKHZn;
 Fri, 15 Jul 2022 11:23:17 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgCnCWng3dBiDTIaAw--.57220S3;
 Fri, 15 Jul 2022 11:24:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
 <20210804094147.459763-8-hch@lst.de>
 <ad2c7878-dabb-cb41-1bba-60ef48fa1a9f@huaweicloud.com>
 <20220707052425.GA13016@lst.de>
 <fd5c2e0a-5f68-9f1f-dfc2-49a2cd51de0b@huaweicloud.com>
Message-ID: <6ff5c130-b5b1-b611-bb99-6a2275404fcd@huaweicloud.com>
Date: Fri, 15 Jul 2022 11:24:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fd5c2e0a-5f68-9f1f-dfc2-49a2cd51de0b@huaweicloud.com>
X-CM-TRANSID: _Ch0CgCnCWng3dBiDTIaAw--.57220S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw18tFW3Gry3Xw4kAFW8WFg_yoW8Jw48pF
 WfuFsYkrsrXFsrW392y3yjg3sY9w43Ka1rGryrGryIqryDWrZay3y2yFnFvFy3Arn7WrZI
 qFWjq345Za1vyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
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
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksIENocmlzdG9waCEKCuWcqCAyMDIyLzA3LzA3IDE1OjIwLCBZdSBLdWFpIOWGmemBkzoKPiDl
nKggMjAyMi8wNy8wNyAxMzoyNCwgQ2hyaXN0b3BoIEhlbGx3aWcg5YaZ6YGTOgo+PiBPbiBUaHUs
IEp1bCAwNywgMjAyMiBhdCAxMToyOToyNkFNICswODAwLCBZdSBLdWFpIHdyb3RlOgo+Pj4gV2Ug
Zm91bmQgdGhhdCB0aGlzIHBhdGNoIGZpeCBhIG51bGxwdHIgY3Jhc2ggaW4gb3VyIHRlc3Q6Cj4+
Cj4+PiBEbyB5b3UgdGhpbmsgaXQncyBvayB0byBiYWNrcG9ydCB0aGlzIHBhdGNoKGFuZCBhbGwg
cmVhbHRlZCBwYXRjaGVzKSB0bwo+Pj4gbHRzLCBvciBpdCdzIGJldHRlciB0byBmaXggdGhhdCBi
aW8gY2FuIGJlIHN1Ym1pdHRlZCB3aXRoIHF1ZXVlCj4+PiB1bmluaXRpYWxpemVkIGZyb20gYmxv
Y2sgbGF5ZXI/Cj4+Cj4+IEdpdmVuIGhvdyBsb25nIGFnbyB0aGlzIHdhcyBJIGRvIG5vdCByZW1l
bWJlciBvZmZoYW5kIGhvdyBtdWNoIHByZXAKPj4gd29yayB0aGlzIHdvdWxkIHJlcXVpcmUuwqAg
VGhlIHBhdGNoIGl0c2VsZiBpcyBvZiBjb3Vyc2UgdGlueSBhbmQKPj4gYmFja3BvcnRhYmxlLCBi
dXQgc29tZW9uZSB3aWxsIG5lZWQgdG8gZG8gdGhlIHdvcmsgYW5kIGZpZ3VyZSBvdXQgaG93Cj4+
IG11Y2ggZWxzZSB3b3VsZCBoYXZlIHRvIGJlIGJhY2twb3J0ZWQuCj4gCj4gT2ssIEknbGwgdHJ5
IHRvIGZpZ3VyZSBvdXQgdGhhdCwgYW5kIGJhY2twb3J0IHRoZW0uKEF0IGxlYXN0IHRvIDUuMTAu
eSkKCldoaWxlIHJldmlld2luZyB0aGUgY29kZSwgSSBkaWRuJ3QgZm91bmQgYW55IHByb3RlY3Rp
b24gdGhhdApiZF9saW5rX2Rpc2tfaG9sZGVyKCkgd29uJ3QgY29uY3VycmVudCB3aXRoCmJkX3Jl
Z2lzdGVyX3BlbmRpbmdfaG9sZGVycygpLiBJZiB0aGV5IGRvIGNhbiBjb25jdXJyZW50LApmb2xs
b3dpbmcgc2NlbmFyaW8gaXMgcHJvYmxlbWF0aWM6Cgp0MQkJCQl0MgpkZXZpY2VfYWRkX2Rpc2sK
ICBkaXNrLT5zbGF2ZV9kaXIgPSBrb2JqZWN0X2NyZWF0ZV9hbmRfYWRkCgkJCQliZF9saW5rX2Rp
c2tfaG9sZGVyCgkJCQkgX19saW5rX2Rpc2tfaG9sZGVyCgkJCQkgbGlzdF9hZGQKICBiZF9yZWdp
c3Rlcl9wZW5kaW5nX2hvbGRlcnMKICAgbGlzdF9mb3JfZWFjaF9lbnRyeQogICAgX19saW5rX2Rp
c2tfaG9sZGVyIC0+IC1FRVhJU1QKCkluIHRoaXMgY2FzZSwgSSB0aGluayBtYXliZSBpZ25vcmUg
Jy1FRVhJU1QnIGlzIGZpbmUuCgpJJ20gbm90IGZhbWlsaWFyIHdpdGggZG0sIGFuZCBJJ20gbm90
IHN1cmUgaWYgSSBtaXNzZWQgc29tZXRoaW5nLApwbGVhc2Uga2luZGx5IGNvcnJlY3QgbWUgaWYg
SSdtIHdyb25nLgoKVGhhbmtzLApLdWFpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

