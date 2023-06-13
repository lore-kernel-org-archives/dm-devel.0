Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 563FBC7EE29
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686660285;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7NhDO3eNJYevUfd47EzBY/cRzeF9dgUpOBmS9XPvXdk=;
	b=hHVK8PteOIL7g/VTD2ZFUSJExuEmaEZCAKZQRiXSI2UQ5U9z2vSfiNBuGrrcJ7wiB0Bof4
	avBurefJyCghjXPaHTqB1AveJXJ99p7ucedWAVclUJY26r+BSzoTGOBL5begSgA1jkhrwZ
	JfRbSDksnLNjGCXeB0RcdqSHqZ/FT2Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-2ok5x5NwOK-hQzxAPhaQ3w-1; Tue, 13 Jun 2023 08:44:43 -0400
X-MC-Unique: 2ok5x5NwOK-hQzxAPhaQ3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC5BF85A5BB;
	Tue, 13 Jun 2023 12:44:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94332178B4;
	Tue, 13 Jun 2023 12:44:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F2CC1946A44;
	Tue, 13 Jun 2023 12:44:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58179194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 12:44:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D9A96492C38; Tue, 13 Jun 2023 12:44:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D237B492C1B
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 12:44:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B793F185A794
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 12:44:37 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-4FaQl5zSNHqDjg9W_3ibwQ-1; Tue, 13 Jun 2023 08:44:31 -0400
X-MC-Unique: 4FaQl5zSNHqDjg9W_3ibwQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgStK4Vq6z4f3v5D;
 Tue, 13 Jun 2023 20:44:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAHuKuoZIhkVmRyLg--.57499S3;
 Tue, 13 Jun 2023 20:44:26 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com>
 <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
 <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
 <CALTww2-ta1NUJxcT3Dq5KP7iunnVx24X7RKj1OKYTYwEPeDNrg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <68b215a4-b4bb-7c94-6ad4-84ea859af742@huaweicloud.com>
Date: Tue, 13 Jun 2023 20:44:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2-ta1NUJxcT3Dq5KP7iunnVx24X7RKj1OKYTYwEPeDNrg@mail.gmail.com>
X-CM-TRANSID: gCh0CgAHuKuoZIhkVmRyLg--.57499S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW5Kw4DXry5ZF43uw43GFg_yoWkWFX_Cr
 s2ywnrGr18ZFnIgwn0yr4rJ39rKFn5Wr47X3yUZF4Yvw18Xa4kJr4ktr18Ww45WayYyrnI
 vFyq9ay7XrZ7ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
 Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
 0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
 jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
 1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
 04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
 v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
 1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
 AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyU
 JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
 nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, guoqing.jiang@linux.dev,
 "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xMyAyMDoyNSwgWGlhbyBOaSDlhpnpgZM6Cj4gT24gVHVlLCBKdW4g
MTMsIDIwMjMgYXQgODowMOKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3
cm90ZToKPj4KPj4gSGksCj4+Cj4+IOWcqCAyMDIzLzA2LzEzIDE2OjAyLCBYaWFvIE5pIOWGmemB
kzoKPj4+Cj4+PiDlnKggMjAyMy81LzI5IOS4i+WNiDk6MjAsIFl1IEt1YWkg5YaZ6YGTOgo+Pj4+
IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4+Pgo+Pj4+IFByZXBhcmUgdG8g
aGFuZGxlICdpZGxlJyBhbmQgJ2Zyb3plbicgZGlmZmVyZW50bHkgdG8gZml4IGEgZGVhZGxvY2ss
Cj4+Pj4gdGhlcmUKPj4+PiBhcmUgbm8gZnVuY3Rpb25hbCBjaGFuZ2VzIGV4Y2VwdCB0aGF0IE1E
X1JFQ09WRVJZX1JVTk5JTkcgaXMgY2hlY2tlZAo+Pj4+IGFnYWluIGFmdGVyICdyZWNvbmZpZ19t
dXRleCcgaXMgaGVsZC4KPj4+Cj4+Pgo+Pj4gQ2FuIHlvdSBleHBsYWluIG1vcmUgYWJvdXQgd2h5
IGl0IG5lZWRzIHRvIGNoZWNrIE1EX1JFQ09WRVJZX1JVTk5JTkcKPj4+IGFnYWluIGhlcmU/Cj4+
Cj4+IEFzIEkgZXhwbGFpbiBpbiB0aGUgZm9sbG93aW5nIGNvbW1lbnQ6Cj4gCj4gSGkKPiAKPiBX
aG8gY2FuIGNsZWFyIHRoZSBmbGFnIGJlZm9yZSB0aGUgbG9jayBpcyBoZWxkPwoKQmFzaWNhbGx5
IGV2ZXJ5IHdoZXJlIHRoYXQgY2FuIGNsZWFyIHRoZSBmbGFnLi4uCgovLyBUaGlzIGNvbnRleHQg
CS8vIE90aGVyIGNvbnRleHQKCQkJbXV0ZXhfbG9jawoJCQkuLi4KdGVzdF9iaXQgLT4gcGFzcwoJ
CQljbGVhcl9iaXQKCQkJbXV0ZXhfdW5sb2NrCm11dGV4X2xvY2sKdGVzdF9iaXQgLT4gY2hlY2sg
YWdhaW4KClRoYW5rcywKS3VhaQo+IAo+IFJlZ2FyZHMKPiBYaWFvCj4+Pj4gKyAgICAvKgo+Pj4+
ICsgICAgICogQ2hlY2sgYWdhaW4gaW4gY2FzZSBNRF9SRUNPVkVSWV9SVU5OSU5HIGlzIGNsZWFy
ZWQgYmVmb3JlIGxvY2sgaXMKPj4+PiArICAgICAqIGhlbGQuCj4+Pj4gKyAgICAgKi8KPj4+PiAr
ICAgIGlmICghdGVzdF9iaXQoTURfUkVDT1ZFUllfUlVOTklORywgJm1kZGV2LT5yZWNvdmVyeSkp
IHsKPj4+PiArICAgICAgICBtZGRldl91bmxvY2sobWRkZXYpOwo+Pj4+ICsgICAgICAgIHJldHVy
bjsKPj4+PiArICAgIH0KPj4KPj4gVGhhbmtzLAo+PiBLdWFpCj4+Cj4gCj4gLgo+IAoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

