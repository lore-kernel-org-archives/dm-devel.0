Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D34C7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 12:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686657683;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6ReLa8XA8jR2iYPG+oxdNbNeqx//hxj1pBgTfmOKe1c=;
	b=QvhTAcdQBagSJnGbOC5/H6r2BjrI49E6na0ZMOVPRuGGNvJMLvP2ROV1Ea9s+JIaoi37Bn
	jRIYDjRtduLfGWwhVH6ROGFjFquOWY+Akvu9QuXSUhcXdXDqIONZAlw3XRksyioubwIsp0
	CrjKe86u9LS0uxUrbXMKDw1cadKH1Zk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-w-HMp--2OXutXc1xYbm_NQ-1; Tue, 13 Jun 2023 08:01:04 -0400
X-MC-Unique: w-HMp--2OXutXc1xYbm_NQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 892662800C4B;
	Tue, 13 Jun 2023 12:00:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77AA340C6F5D;
	Tue, 13 Jun 2023 12:00:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57EF41946A42;
	Tue, 13 Jun 2023 12:00:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E151194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 12:00:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97CFC2166B27; Tue, 13 Jun 2023 12:00:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FDD72166B25
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 12:00:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B6903C1350A
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 12:00:22 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-pzOP4EOAPHWF8JB39YyX3g-1; Tue, 13 Jun 2023 08:00:19 -0400
X-MC-Unique: pzOP4EOAPHWF8JB39YyX3g-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QgRvF5p8Dz4f4037;
 Tue, 13 Jun 2023 20:00:09 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgCXaK9KWohkdghwLg--.58089S3;
 Tue, 13 Jun 2023 20:00:11 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com>
 <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
Date: Tue, 13 Jun 2023 20:00:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
X-CM-TRANSID: gCh0CgCXaK9KWohkdghwLg--.58089S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtFykCF13Gry3WryfZry3XFb_yoW3Xwb_C3
 yDKw15Wr18Aaya9r1qyw15Z347Krn0v34UGrZ5Zw45uw17WFs5Jrs8J3Z5Wr4UGFWqkr17
 AFyYqa13Jr429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb3xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
 Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
 0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
 jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
 1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
 04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
 v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
 1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
 AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1l
 IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
 C2KfnxnUUI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
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
Cc: linux-raid@vger.kernel.org, "yukuai \(C\)" <yukuai3@huawei.com>,
 yangerkun@huawei.com, linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xMyAxNjowMiwgWGlhbyBOaSDlhpnpgZM6Cj4gCj4g5ZyoIDIwMjMv
NS8yOSDkuIvljYg5OjIwLCBZdSBLdWFpIOWGmemBkzoKPj4gRnJvbTogWXUgS3VhaSA8eXVrdWFp
M0BodWF3ZWkuY29tPgo+Pgo+PiBQcmVwYXJlIHRvIGhhbmRsZSAnaWRsZScgYW5kICdmcm96ZW4n
IGRpZmZlcmVudGx5IHRvIGZpeCBhIGRlYWRsb2NrLCAKPj4gdGhlcmUKPj4gYXJlIG5vIGZ1bmN0
aW9uYWwgY2hhbmdlcyBleGNlcHQgdGhhdCBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIGNoZWNrZWQK
Pj4gYWdhaW4gYWZ0ZXIgJ3JlY29uZmlnX211dGV4JyBpcyBoZWxkLgo+IAo+IAo+IENhbiB5b3Ug
ZXhwbGFpbiBtb3JlIGFib3V0IHdoeSBpdCBuZWVkcyB0byBjaGVjayBNRF9SRUNPVkVSWV9SVU5O
SU5HIAo+IGFnYWluIGhlcmU/CgpBcyBJIGV4cGxhaW4gaW4gdGhlIGZvbGxvd2luZyBjb21tZW50
Ogo+PiArwqDCoMKgIC8qCj4+ICvCoMKgwqDCoCAqIENoZWNrIGFnYWluIGluIGNhc2UgTURfUkVD
T1ZFUllfUlVOTklORyBpcyBjbGVhcmVkIGJlZm9yZSBsb2NrIGlzCj4+ICvCoMKgwqDCoCAqIGhl
bGQuCj4+ICvCoMKgwqDCoCAqLwo+PiArwqDCoMKgIGlmICghdGVzdF9iaXQoTURfUkVDT1ZFUllf
UlVOTklORywgJm1kZGV2LT5yZWNvdmVyeSkpIHsKPj4gK8KgwqDCoMKgwqDCoMKgIG1kZGV2X3Vu
bG9jayhtZGRldik7Cj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4+ICvCoMKgwqAgfQoKVGhh
bmtzLApLdWFpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

