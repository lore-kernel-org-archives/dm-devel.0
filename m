Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E79C43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178467;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G3dzuYT+mJ1D7oHggZ1i5DVAhFDPv0ZT2vfMiyAPlPI=;
	b=MkfXACqa8oZ9S342psHSho0G59sn4dtrqtN8bH/5Ad/gXoDUp9Bw/gx1oTQjfvJKGIMfOY
	CNccH2OLsuCyC+xgc29ELMQcnUtY78F4xI96+l/evhWbrQqqOn3h9t2393KZ/1HkfS9/WU
	px9sGepWrdfG6W3HZhHTT4F0ftIf3yI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-G1VdE37cNyiIEbohFBopZA-1; Thu, 07 Jul 2022 03:21:04 -0400
X-MC-Unique: G1VdE37cNyiIEbohFBopZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A1231035341;
	Thu,  7 Jul 2022 07:21:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CF711415118;
	Thu,  7 Jul 2022 07:20:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 584751947068;
	Thu,  7 Jul 2022 07:20:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50107194706B
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 07:20:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C93032166B29; Thu,  7 Jul 2022 07:20:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C51F32166B26
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 07:20:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A94691032964
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 07:20:57 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-RWlMj2ROPDGs71Drbd9Uwg-1; Thu, 07 Jul 2022 03:20:53 -0400
X-MC-Unique: RWlMj2ROPDGs71Drbd9Uwg-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LdnqQ1LBGzl1kC;
 Thu,  7 Jul 2022 15:20:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgCnCWlOicZilpTiAQ--.30604S3;
 Thu, 07 Jul 2022 15:20:48 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20210804094147.459763-1-hch@lst.de>
 <20210804094147.459763-8-hch@lst.de>
 <ad2c7878-dabb-cb41-1bba-60ef48fa1a9f@huaweicloud.com>
 <20220707052425.GA13016@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fd5c2e0a-5f68-9f1f-dfc2-49a2cd51de0b@huaweicloud.com>
Date: Thu, 7 Jul 2022 15:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220707052425.GA13016@lst.de>
X-CM-TRANSID: _Ch0CgCnCWlOicZilpTiAQ--.30604S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKFWUWrWDKw48Xw18GrW8Crg_yoWxCFc_ZF
 s8W3s7C3W5G3Wvga1UKr95J39xKa4xZ34kWFy7uF4Duw18Xa1DWFy7GwnxXr15J348Xr9x
 ZryYgrWUCw1jqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
 6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

1NogMjAyMi8wNy8wNyAxMzoyNCwgQ2hyaXN0b3BoIEhlbGx3aWcg0LS1wDoKPiBPbiBUaHUsIEp1
bCAwNywgMjAyMiBhdCAxMToyOToyNkFNICswODAwLCBZdSBLdWFpIHdyb3RlOgo+PiBXZSBmb3Vu
ZCB0aGF0IHRoaXMgcGF0Y2ggZml4IGEgbnVsbHB0ciBjcmFzaCBpbiBvdXIgdGVzdDoKPiAKPj4g
RG8geW91IHRoaW5rIGl0J3Mgb2sgdG8gYmFja3BvcnQgdGhpcyBwYXRjaChhbmQgYWxsIHJlYWx0
ZWQgcGF0Y2hlcykgdG8KPj4gbHRzLCBvciBpdCdzIGJldHRlciB0byBmaXggdGhhdCBiaW8gY2Fu
IGJlIHN1Ym1pdHRlZCB3aXRoIHF1ZXVlCj4+IHVuaW5pdGlhbGl6ZWQgZnJvbSBibG9jayBsYXll
cj8KPiAKPiBHaXZlbiBob3cgbG9uZyBhZ28gdGhpcyB3YXMgSSBkbyBub3QgcmVtZW1iZXIgb2Zm
aGFuZCBob3cgbXVjaCBwcmVwCj4gd29yayB0aGlzIHdvdWxkIHJlcXVpcmUuICBUaGUgcGF0Y2gg
aXRzZWxmIGlzIG9mIGNvdXJzZSB0aW55IGFuZAo+IGJhY2twb3J0YWJsZSwgYnV0IHNvbWVvbmUg
d2lsbCBuZWVkIHRvIGRvIHRoZSB3b3JrIGFuZCBmaWd1cmUgb3V0IGhvdwo+IG11Y2ggZWxzZSB3
b3VsZCBoYXZlIHRvIGJlIGJhY2twb3J0ZWQuCgpPaywgSSdsbCB0cnkgdG8gZmlndXJlIG91dCB0
aGF0LCBhbmQgYmFja3BvcnQgdGhlbS4oQXQgbGVhc3QgdG8gNS4xMC55KQoKVGhhbmtzLApLdWFp
Cj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

