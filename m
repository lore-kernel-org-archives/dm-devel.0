Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76A6C77B7A
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 02:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686192077;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fgv+5BeGoeoUWMq8nnbrXaAzd9ohZAO/226at7JohSE=;
	b=GXwQTu0bOLIfFW549wlekOnPmDIp8IOLx51W4cKVUZWe8D7VOpem+Pi7QuXx/hO7DoFjG0
	AnWmDygOfR1cb0694YjEk4etUxkpcMp5inlFIgYEhABMMaL6E0ufV//AvpwqbnpbFPj8dS
	gQT9yAD60/f4z+cRMTi8hrC32PU+Qn8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-g_zWlwFZP2mqHAYfYBQMHQ-1; Wed, 07 Jun 2023 22:41:14 -0400
X-MC-Unique: g_zWlwFZP2mqHAYfYBQMHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CAA03802134;
	Thu,  8 Jun 2023 02:41:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BB662026D49;
	Thu,  8 Jun 2023 02:41:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55F3019452C4;
	Thu,  8 Jun 2023 02:41:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8B7F19465BA
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 02:41:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74C33140E954; Thu,  8 Jun 2023 02:41:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D474140E955
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 02:41:10 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52BBB185A791
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 02:41:10 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-WkAPLZlcNHC0iM54YykCMA-1; Wed, 07 Jun 2023 22:41:07 -0400
X-MC-Unique: WkAPLZlcNHC0iM54YykCMA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qc7kP6KJgz4f3tNj;
 Thu,  8 Jun 2023 10:41:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgBH_rG9P4FkzBfHLA--.54104S3;
 Thu, 08 Jun 2023 10:41:02 +0800 (CST)
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0a38ddc1-b47e-04e8-dbf5-25afcd13fff4@huaweicloud.com>
Date: Thu, 8 Jun 2023 10:41:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
X-CM-TRANSID: gCh0CgBH_rG9P4FkzBfHLA--.54104S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWktr43Kr17Ww1fAFy3XFb_yoWkWFg_Wa
 4YkFy3Wr47GF15GFyDKrn8Z39rGFW5ur1DXFyrtayjvFyIgrnxCr1kuw43uw1YvFWjyr18
 ArWUCayfAwsrWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb3xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH -next v2 0/6] md: fix that
 MD_RECOVERY_RUNNING can be cleared while sync_thread is still running
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIzLzA1LzI5IDIxOjIwLCBZdSBLdWFpINC0tcA6Cj4gRnJvbTogWXUgS3VhaSA8
eXVrdWFpM0BodWF3ZWkuY29tPgo+IAo+IENoYW5nZXMgaW4gdjI6Cj4gICAtIHJlYmFzZSBmb3Ig
dGhlIGxhdGVzdCBtZC1uZXh0Cj4gCj4gUGF0Y2ggMSByZXZlcnQgdGhlIGNvbW1pdCBiZWNhdXNl
IGl0IHdpbGwgY2F1c2UgTURfUkVDT1ZFUllfUlVOTklORyB0byBiZQo+IGNsZWFyZWQgd2hpbGUg
c3luY190aHJlYWQgaXMgc3RpbGwgcnVubmluZy4gVGhlIGRlYWRsb2NrIHRoaXMgcGF0Y2ggdHJp
ZXMKPiB0byBmaXggd2lsbCBiZSBmaXhlZCBieSBwYXRjaCAyLTUuCj4gCj4gUGF0Y2ggNiBlbmhh
bmNlIGNoZWNraW5nIHRvIHByZXZlbnQgTURfUkVDT1ZFUllfUlVOTklORyB0byBiZSBjbGVhcmVk
Cj4gd2hpbGUgc3luY190aHJlYWQgaXMgc3RpbGwgcnVubmluZy4KCkFueSBzdWdnZXN0aW9ucyBv
biB0aGlzIHBhdGNoc2V0PyBJIGFscmVhZHkgc2VudCByZWdyZXNzaW9uIHRlc3QKZm9yIHRoZSBk
ZWFkbG9jayBwcm9ibGVtIGZvciBib3RoIHJhaWQxMCBhbmQgcmFpZDQ1Ni4KClRoYW5rcywKS3Vh
aQo+IAo+IFl1IEt1YWkgKDYpOgo+ICAgIFJldmVydCAibWQ6IHVubG9jayBtZGRldiBiZWZvcmUg
cmVhcCBzeW5jX3RocmVhZCBpbiBhY3Rpb25fc3RvcmUiCj4gICAgbWQ6IHJlZmFjdG9yIGFjdGlv
bl9zdG9yZSgpIGZvciAnaWRsZScgYW5kICdmcm96ZW4nCj4gICAgbWQ6IGFkZCBhIG11dGV4IHRv
IHN5bmNocm9uaXplIGlkbGUgYW5kIGZyb3plbiBpbiBhY3Rpb25fc3RvcmUoKQo+ICAgIG1kOiBy
ZWZhY3RvciBpZGxlL2Zyb3plbl9zeW5jX3RocmVhZCgpIHRvIGZpeCBkZWFkbG9jawo+ICAgIG1k
OiB3YWtlIHVwICdyZXN5bmNfd2FpdCcgYXQgbGFzdCBpbiBtZF9yZWFwX3N5bmNfdGhyZWFkKCkK
PiAgICBtZDogZW5oYW5jZSBjaGVja2luZyBpbiBtZF9jaGVja19yZWNvdmVyeSgpCj4gCj4gICBk
cml2ZXJzL21kL2RtLXJhaWQuYyB8ICAgMSAtCj4gICBkcml2ZXJzL21kL21kLmMgICAgICB8IDEy
NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tCj4gICBkcml2ZXJz
L21kL21kLmggICAgICB8ICAgNSArKwo+ICAgMyBmaWxlcyBjaGFuZ2VkLCA4OCBpbnNlcnRpb25z
KCspLCA0MiBkZWxldGlvbnMoLSkKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

