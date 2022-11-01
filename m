Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99416C4321E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667378507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Gd3J/wZmnaEs1PYiMzSu/oeVsOlq+akitlwS94x/gH4=;
	b=X7zUx2mqCWq2/ujdeW84bJsLkOUj1QAA7QotFY6IhbU6RfhxD9o1xW0dcpdLVEZZI83+IC
	Q6bdn9TUlrPnQQQ2pnsDAPScIGD/Xi0lhrPaJwwbIHu2f5SywpuIZxpaHLQPYHs6HAxXHt
	sa1NvMk7MGhVSoqTqPmYwBFKZcdT4io=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-Lz7SVmH1MbmGuY2AUyhZKA-1; Wed, 02 Nov 2022 04:41:44 -0400
X-MC-Unique: Lz7SVmH1MbmGuY2AUyhZKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBE5C3C025B6;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B19AD200C0DD;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D86DA1946A78;
	Wed,  2 Nov 2022 08:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28AA41946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 13:29:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DD62440C83EC; Tue,  1 Nov 2022 13:29:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5B7F40C2140
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 13:29:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1D2A101A52A
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 13:29:35 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-MC5iOcCiOuS1kcxIYSDB6w-1; Tue, 01 Nov 2022 09:29:31 -0400
X-MC-Unique: MC5iOcCiOuS1kcxIYSDB6w-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N1rQg0n7pzKHlG;
 Tue,  1 Nov 2022 21:26:51 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgCH4+UzH2FjdsEuAg--.44981S3;
 Tue, 01 Nov 2022 21:29:24 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
 <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
 <20221101104927.GA13823@lst.de>
 <d3f6ec1d-8141-19d1-ce4c-d42710f4a636@huaweicloud.com>
 <20221101112131.GA14379@lst.de>
 <57465370-99fe-d8a5-e150-a1057640e972@huaweicloud.com>
 <20221101131830.GA16341@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <51362eda-fd76-ed35-1961-f17d8e9a9d93@huaweicloud.com>
Date: Tue, 1 Nov 2022 21:29:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221101131830.GA16341@lst.de>
X-CM-TRANSID: gCh0CgCH4+UzH2FjdsEuAg--.44981S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy3JrWrAF15ZFy3ury3Arb_yoW3tFg_ua
 45JanrAw48uFn3tw47tr13urZ5Ga9FkFWDZrWxCFs09ryjqasxJr1UA3yrAFy7Wr47GrsI
 yryYgF1UtrsF9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
 6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 02 Nov 2022 08:41:39 +0000
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIyLzExLzAxIDIxOjE4LCBDaHJpc3RvcGggSGVsbHdpZyDQtLXAOgo+IE9uIFR1
ZSwgTm92IDAxLCAyMDIyIGF0IDA3OjI4OjE3UE0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6Cj4+IFdo
YXQgaWYgYmRfaG9sZGVyX2RpciBpcyBhbHJlYWR5IGZyZWVkIGhlcmUsIHRoZW4gdWFmIGNhbiBi
ZSB0cmlnZ2VyZWQuCj4+IFRodXMgYmRfaG9sZGVyX2RpciBuZWVkIHRvIGJlIHJlc2VkIGluIGRl
bF9nZW5kaXNrKCkgaWYgaXQncyByZWZlcmVuY2UKPj4gaXMgZHJvcHBlZCB0byAwLCBob3dldmVy
LCBrb2JqZWN0IGFwaXMgY2FuJ3QgZG8gdGhhdC4uLgo+IAo+IEluZGVlZC4gIEkgZG9uJ3QgdGhp
bmsgd2UgY2FuIHNpbXBseSBtb3ZlIHRoZSBkcm9wcGluZyBvZiB0aGUgcmVmZXJlbmNlCj4gYXMg
eW91IHN1Z2dlc3RlZCBhcyB0aGF0IGFsc28gaW1wbGllcyB0YWtpbmcgaXQgZWFybGllciwgYW5k
IHRoZQo+IGRldmljZSBpbiB0aGUgZGlzayBpcyBvbmx5IGluaXRpYWxpemVkIGluIGFkZF9kaXNr
Lgo+IAo+IE5vdyB3aGF0IEkgdGhpbmsgd2UgY291bGQgZG8gaXM6Cj4gCj4gICAtIGhvbGQgb3Bl
bl9tdXRleCBpbiBiZF9saW5rX2Rpc2tfaG9sZGVyIGFzIHlvdSBzdWdnZXN0ZWQKPiAgIC0gY2hl
Y2sgdGhhdCB0aGUgYmRldiBpbm9kZSBpcyBoYXNoZWQgaW5zaWRlIG9wZW5fbXV0ZXggYmVmb3Jl
IGRvaW5nCj4gICAgIHRoZSBrb2JqZWN0X2dldAoKWWVzLCB0aGF0J3Mgc291bmRzIGdvb2QsIGNo
ZWNrIGlmIGlub2RlIGlzIGhhc2hlZCBpcyBiZXR0ZXIgdGhhbgp3aGF0IEkgZGlkIGluIGFub3Ro
ZXIgdGhyZWFkIHRvIGludHJvZHVjZSBhIG5ldyBmaWVsZC4KClRoYW5zaywKS3VhaQo+IAo+IC4K
PiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

