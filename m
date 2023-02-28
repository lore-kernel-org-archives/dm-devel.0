Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DFCC64ED6
	for <dm-devel@archiver.kernel.org>; Tue, 28 Feb 2023 07:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677568961;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oaHQYal+f465spDIPkubRelaMTElfRXWjF2zFFF+S9o=;
	b=IFtSZgRfSmcf8FmptHfDwTSDDf7cstO77eQhzvfuiCSmmUuSaRRekLcYIe3GB+VVEtTKBI
	sPF2EM6KgWP0zj1bCGLml71g/CpT1Zu5katwptzQ1L1kdrraRmntSTZJAOn0pipWNvnx3O
	B6RlAhmZ48MXC/9hkfoC54BvjpARx3k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-BHYta40TPHSYgHdDaUnICw-1; Tue, 28 Feb 2023 02:22:37 -0500
X-MC-Unique: BHYta40TPHSYgHdDaUnICw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20D013C02B6F;
	Tue, 28 Feb 2023 07:22:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68E9E40C945A;
	Tue, 28 Feb 2023 07:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FDFD1946589;
	Tue, 28 Feb 2023 07:22:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D18441946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Feb 2023 07:22:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF8E62166B2A; Tue, 28 Feb 2023 07:22:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B88F72166B26
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 07:22:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 993A485CCE0
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 07:22:30 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650--HZ_oy-HP6SVzPwNZffVfA-1; Tue, 28 Feb 2023 02:22:28 -0500
X-MC-Unique: -HZ_oy-HP6SVzPwNZffVfA-1
Received: from kwepemi500022.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PQphV2flPzrS14;
 Tue, 28 Feb 2023 15:21:46 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemi500022.china.huawei.com (7.221.188.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 15:22:23 +0800
Message-ID: <5f916b85-52cb-1896-c824-9059876a5975@huawei.com>
Date: Tue, 28 Feb 2023 15:22:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: yangerkun <yangerkun@huaweicloud.com>, Mike Snitzer <snitzer@kernel.org>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com>
 <e264ce36-b6ce-b0ad-513c-068e819cf183@huaweicloud.com>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <e264ce36-b6ce-b0ad-513c-068e819cf183@huaweicloud.com>
X-Originating-IP: [10.174.177.210]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500022.china.huawei.com (7.221.188.64)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy8yLzI4IDk6MjUsIHlhbmdlcmt1biDlhpnpgZM6Cj4gCj4gCj4g5ZyoIDIwMjMv
Mi8yOCAxOjU1LCBNaWtlIFNuaXR6ZXIg5YaZ6YGTOgo+PiBPbiBTdW4sIEZlYiAyNiAyMDIzIGF0
wqAgODozMVAgLTA1MDAsCj4+IHlhbmdlcmt1biA8eWFuZ2Vya3VuQGh1YXdlaWNsb3VkLmNvbT4g
d3JvdGU6Cj4+Cj4+Pgo+Pj4KPj4+IOWcqCAyMDIzLzIvMjYgMTA6MDEsIEJhcnQgVmFuIEFzc2No
ZSDlhpnpgZM6Cj4+Pj4gT24gMi8yMi8yMyAxOToxOSwgeWFuZ2Vya3VuIHdyb3RlOgo+Pj4+PiBA
QCAtMTkyNCw2ICsxOTI2LDEwIEBAIHN0YXRpYyBpbnQgZG1jcnlwdF93cml0ZSh2b2lkICpkYXRh
KQo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBCVUdfT04ocmJfcGFyZW50KHdyaXRlX3RyZWUu
cmJfbm9kZSkpOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKHRpbWVfaXNfYmVmb3JlX2ppZmZp
ZXMoc3RhcnRfdGltZSArIEhaKSkgewo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzY2hl
ZHVsZSgpOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdGFydF90aW1lID0gamlmZmll
czsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+Pgo+Pj4+IFdoeSBzY2hlZHVsZSgpIGluc3Rl
YWQgb2YgY29uZF9yZXNjaGVkKCk/Cj4+Pgo+Pj4gY29uZF9yZXNjaGVkIG1heSBub3QgcmVhbGx5
IHNjaGVkdWxlLCB3aGljaCBtYXkgdHJpZ2dlciB0aGUgcHJvYmxlbSAKPj4+IHRvbywgYnV0Cj4+
PiBpdCBzZWVtcyBhZnRlciAxIHNlY29uZCwgaXQgbWF5IG5ldmVyIGhhcHBlbmQ/Cj4+Cj4+IEkg
aGFkIHRoZSBzYW1lIHF1ZXN0aW9uIGFzIEJhcnQgd2hlbiByZXZpZXdpbmcgeW91ciBob21lZ3Jv
d24KPj4gY29uZGl0aW9uYWwgc2NoZWR1bGUoKS7CoCBIb3BlZnVsbHkgeW91IGNhbiByZXByb2R1
Y2UgdGhpcyBpc3N1ZT/CoCBJZgo+PiBzbywgcGxlYXNlIHNlZSBpZiBzaW1wbHkgdXNpbmcgY29u
ZF9yZXNjaGVkKCkgZml4ZXMgdGhlIGlzc3VlLgo+IAo+IFllcywgb3VyIHRlc3RjYXNlIGNhbiB0
cmlnZ2VyIHRoZSBpc3N1ZSwgd2lsbCBkbyBpdCB3aXRoIGNvbmRfcmVzY2hlZC4KCldpdGhvdXQg
dGhpcyBwYXRjaCwgdGhlIHNvZnRsb2NrdXAgbWF5IHRyaWdnZXIgc29vbiwgYWZ0ZXIgdGhpcyBw
YXRjaCBubyAKbWF0dGVyIGNvbmRfcmVzY2hlZCBvciBzY2hlZHVsZSwgc29mdGxvY2t1cCB3b24n
dCB0cmlnZ2VyIGFmdGVyIHR3byBob3VyIAp0ZXN0LgoKVGhhbmtzLApLdW4uCj4gCj4gCj4gCj4+
Cj4+IFRoYW5rcywKPj4gTWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

