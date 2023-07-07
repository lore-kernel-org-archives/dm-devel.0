Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D7EEB64D9
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jul 2023 01:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688693219;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0wpDF3kkUKGq9rKU9XuI5cHp3Bcwm74F7/6VakFBTNU=;
	b=UGTPfkA6nTFKMhM0pBs5aQR9X8xgsspjaylppqe6qGHLF9Byc2NQO/alulSePJA7E6a6Am
	a6qmnEOjm3FIydDIaBMoDTLPmfKWBFPq06EcB63xrTqZAzq11r0JwTFct4OhVRnf2oED/c
	VZmuZ3VFEToCMGxhxuL7SQsaJSH0AZU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-CAMMuzDqO4i6FXYPen1_3Q-1; Thu, 06 Jul 2023 21:26:56 -0400
X-MC-Unique: CAMMuzDqO4i6FXYPen1_3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE5C42A59541;
	Fri,  7 Jul 2023 01:26:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEB471121330;
	Fri,  7 Jul 2023 01:26:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 644D8194658F;
	Fri,  7 Jul 2023 01:26:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 941671946589
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Jul 2023 01:26:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51CFB2017DC6; Fri,  7 Jul 2023 01:26:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A7672014F87
 for <dm-devel@redhat.com>; Fri,  7 Jul 2023 01:26:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F59C101A528
 for <dm-devel@redhat.com>; Fri,  7 Jul 2023 01:26:47 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-mfkuXoviMN21hjyYEtyDCQ-1; Thu, 06 Jul 2023 21:26:43 -0400
X-MC-Unique: mfkuXoviMN21hjyYEtyDCQ-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qxwj91RVbz4f3jpp;
 Fri,  7 Jul 2023 09:26:37 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgD3X7PNaadkfGaHNQ--.3435S3;
 Fri, 07 Jul 2023 09:26:37 +0800 (CST)
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230706071622.563073-1-yukuai1@huaweicloud.com>
 <20230706071622.563073-3-yukuai1@huaweicloud.com>
 <37c7a3f7-f769-a313-3279-e8e415369ba4@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c42524a9-6854-673b-d54e-392995483cca@huaweicloud.com>
Date: Fri, 7 Jul 2023 09:26:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <37c7a3f7-f769-a313-3279-e8e415369ba4@molgen.mpg.de>
X-CM-TRANSID: gCh0CgD3X7PNaadkfGaHNQ--.3435S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1xAw43ZrW8Cr45trWkZwb_yoWfCwb_Ca
 s2yasrGr1SqanxW3W5Gr4F9r90k398GrnrAFyIv3yjva4fXrsYkF4kCrZ0qr45WFWFyryr
 Jr1UXrWrAry7KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
 6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1U
 MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
 VFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH -next 2/3] md/dm-raid: cleanup multiple
 equivalent goto tags from raid_ctr()
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
Cc: yi.zhang@huawei.com, heinzm@redhat.com, yangerkun@huawei.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 song@kernel.org, dm-devel@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNy8wNiAyMTowMSwgUGF1bCBNZW56ZWwg5YaZ6YGTOgo+IERlYXIgWXUs
Cj4gCj4gCj4gVGhhbmsgeW91IGZvciB5b3VyIHBhdGNoLiBTb21lIG1pbm9yIG5pdHMsIGlmIHlv
dSBhcmUgaW50ZXJlc3RlZC4KPiAKPiBBbSAwNi4wNy4yMyB1bSAwOToxNiBzY2hyaWViIFl1IEt1
YWk6Cj4+IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPj4KPj4gVGhlcmUgYXJl
IGZvdXIgZXF1aXZhbGVudCBnb3RvIHRhZ3MgaW4gcmFpZF9jdHIoKSwgY2xlYW4gdGhlbSB1cCB0
byB1c2UKPj4ganVzdCBvbmUsIHRoZXJlIGFyZSBubyBmdW5jdGlvbmFsIGNoYW5nZSBhbmQgcHJl
cGFyZSB0byBmaXggdGhhdAo+IAo+IE1heWJlOgo+IAo+IFRoZXJlICppcyogbm8gZnVuY3Rpb25h
bCBjaGFuZ2UsIGFuZCBpcyBhIHByZXBhcmF0aW9uIHRvIGZpeCBhbiAKPiB1bnByb3RlY3RlZCBg
bWRfc3RvcCgpYC4KPiAKPj4gbWRfc3RvcCgpIGlzIG5vdCBwcm90ZWN0ZWQuCj4gCj4gSW4gdGhl
IGNvbW1pdCBtZXNzYWdlIHN1bW1hcnkvdGl0bGUsIEnigJlkIHNwZWxsIHRoZSB2ZXJiIHdpdGgg
YSBzcGFjZToKPiAKPiAgwqDCoMKgIENsZWFuIHVwIGZvdXIgZXF1aXZhbGVudCBnb3RvIHRhZ3Mg
aW4gcmFpZF9jdHIoKQo+IAoKVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbnMsIEknbGwgdXBkYXRl
IHRoZW0gaW4gdGhlIG5leHQgdmVyc2lvbi4KClRoYW5rcywKS3VhaQo+PiBTaWduZWQtb2ZmLWJ5
OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiDCoCBkcml2ZXJzL21kL2Rt
LXJhaWQuYyB8IDI3ICsrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQo+PiDCoCAxIGZpbGUgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKPiAKPiBb4oCmXQo+IAo+IAo+
IEtpbmQgcmVnYXJkcywKPiAKPiBQYXVsCj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

