Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9AADC7EE2E
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481426;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3UPZiz0MIj4VT4/BICUp763Nx/elaMfYYN+S4uWAu4Y=;
	b=TBy/wMACauQ8vsTMxlBIuXO/k7K7YNI6niIEk9HFcNJgb+2BW/ZtcUh+ooVflGs41yMUQp
	MmCXeuvXr0NNMfJG8tn9RFburaoXYFUi1aO6uW0IBpBo5ANNsjtHZqKh3KixFjIPY7PyeF
	IttILwyYiDOWa6mW2funEfJ1/Vy6lIc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-jlGuFUfmOJ-BuLm8xj8Dhg-1; Mon, 27 Feb 2023 02:03:43 -0500
X-MC-Unique: jlGuFUfmOJ-BuLm8xj8Dhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26735857A8E;
	Mon, 27 Feb 2023 07:03:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 151C1404BEC5;
	Mon, 27 Feb 2023 07:03:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0270619465A4;
	Mon, 27 Feb 2023 07:03:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DFB4F1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 01:31:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4FF21121315; Mon, 27 Feb 2023 01:31:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4B7C1121314
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 01:31:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 570993C0D854
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 01:31:24 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-_8O9X1tuOOibaa-E5zpyEg-1; Sun, 26 Feb 2023 20:31:22 -0500
X-MC-Unique: _8O9X1tuOOibaa-E5zpyEg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PQ2yW3PW3z4f3mK2;
 Mon, 27 Feb 2023 09:31:15 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP4 (Coremail) with SMTP id gCh0CgCnD7PYB_xjFwaOEQ--.22263S3;
 Mon, 27 Feb 2023 09:31:17 +0800 (CST)
Message-ID: <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
Date: Mon, 27 Feb 2023 09:31:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Bart Van Assche <bvanassche@acm.org>, agk@redhat.com, snitzer@kernel.org, 
 dm-devel@redhat.com
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <b7020147-2382-71f6-5237-8501562f8011@acm.org>
X-CM-TRANSID: gCh0CgCnD7PYB_xjFwaOEQ--.22263S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
 VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5R7kC6x804xWl14x267AKxVWUJVW8JwAF
 c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWUWVWUuwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
 0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
 wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
 x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
 64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
 1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUU
 UU=
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
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: Re: [dm-devel] [PATCH] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy8yLzI2IDEwOjAxLCBCYXJ0IFZhbiBBc3NjaGUg5YaZ6YGTOgo+IE9uIDIvMjIv
MjMgMTk6MTksIHlhbmdlcmt1biB3cm90ZToKPj4gQEAgLTE5MjQsNiArMTkyNiwxMCBAQCBzdGF0
aWMgaW50IGRtY3J5cHRfd3JpdGUodm9pZCAqZGF0YSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIEJV
R19PTihyYl9wYXJlbnQod3JpdGVfdHJlZS5yYl9ub2RlKSk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBp
ZiAodGltZV9pc19iZWZvcmVfamlmZmllcyhzdGFydF90aW1lICsgSFopKSB7Cj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHNjaGVkdWxlKCk7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0
YXJ0X3RpbWUgPSBqaWZmaWVzOwo+PiArwqDCoMKgwqDCoMKgwqAgfQo+IAo+IFdoeSBzY2hlZHVs
ZSgpIGluc3RlYWQgb2YgY29uZF9yZXNjaGVkKCk/Cgpjb25kX3Jlc2NoZWQgbWF5IG5vdCByZWFs
bHkgc2NoZWR1bGUsIHdoaWNoIG1heSB0cmlnZ2VyIHRoZSBwcm9ibGVtIHRvbywgCmJ1dCBpdCBz
ZWVtcyBhZnRlciAxIHNlY29uZCwgaXQgbWF5IG5ldmVyIGhhcHBlbmQ/CgpUaGFua3MsCkt1bi4K
Cj4gCj4gVGhhbmtzLAo+IAo+IEJhcnQuCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

