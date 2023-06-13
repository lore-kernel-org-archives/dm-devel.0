Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 920BDC7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686657517;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v3jopzuifKz5o4hdLVm2px5wEdWmeRGYUsbhQ+x8hV8=;
	b=IrhjJtpJMs/2Enp0QWGyDfkB5FPYX0VPOcAPlO2E92oAwL0ZHDt22fVUW4GfUx1/TZxAHG
	GquCxU7Ke/ulwq1M35Fq5F5k6IXfuZa3TOgvxR2csiFAqX+cOG4PYLy5W4xYfVEE0pjsZb
	qkySo2Sd2BWrNt/evlS+vVAC6/NH8P4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-mSze3BNWNOWHp4Yu_Y036A-1; Tue, 13 Jun 2023 07:58:36 -0400
X-MC-Unique: mSze3BNWNOWHp4Yu_Y036A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 940763C1350A;
	Tue, 13 Jun 2023 11:58:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E39712026D20;
	Tue, 13 Jun 2023 11:58:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6F5D1946A42;
	Tue, 13 Jun 2023 11:58:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8F92194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 11:58:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7843C492C38; Tue, 13 Jun 2023 11:58:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 703A0492C1B
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 11:58:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5231C85A5BA
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 11:58:29 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-64p6yY57NvOY8dik_MUXFw-1; Tue, 13 Jun 2023 07:58:23 -0400
X-MC-Unique: 64p6yY57NvOY8dik_MUXFw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgRs44wMqz4f4MXY;
 Tue, 13 Jun 2023 19:58:16 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAHcLPXWYhk+e1vLg--.58707S3;
 Tue, 13 Jun 2023 19:58:17 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-2-yukuai1@huaweicloud.com>
 <2d9f34b1-48e1-73a7-8548-bfd1843d3a0a@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5a107083-488d-1a1f-152c-50c9b9313da5@huaweicloud.com>
Date: Tue, 13 Jun 2023 19:58:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2d9f34b1-48e1-73a7-8548-bfd1843d3a0a@redhat.com>
X-CM-TRANSID: gCh0CgAHcLPXWYhk+e1vLg--.58707S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
 VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
 6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
 kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
 cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2js
 IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
 5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
 CFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxG
 xcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrw
 CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
 14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
 IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
 x2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
 AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
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
Subject: Re: [dm-devel] [PATCH -next v2 1/6] Revert "md: unlock mddev before
 reap sync_thread in action_store"
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
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xMyAxNDoyNSwgWGlhbyBOaSDlhpnpgZM6Cj4gVGhhbmtzIGZvciB0
aGUgcGF0Y2ggYW5kIHRoZSBleHBsYW5hdGlvbiBpbiBWMS4gSW4gdmVyc2lvbjEsIEkgdG9vayBt
dWNoIAo+IHRpbWUgdG8gdHJ5IHRvIHVuZGVyc3RhbmQgdGhlIHByb2JsZW0uIE1heWJlIHdlIGNh
biB1c2UgdGhlIHByb2JsZW0KPiBpdHNlbGYgYXMgdGhlIHN1YmplY3QuIFNvbWV0aGluZyBsaWtl
ICJEb24ndCBhbGxvdyB0d28gc3luYyBwcm9jZXNzZXMgCj4gcnVubmluZyBhdCB0aGUgc2FtZSB0
aW1lIj8gQW5kIGNvdWxkIHlvdSBhZGQgdGhlIHRlc3Qgc3RlcHMgd2hpY2ggdGFsa2VkIAo+IGlu
IHYxCj4gCj4gaW4gdGhlIHBhdGNoPyBJdCBjYW4gaGVscCB0byB1bmRlcnN0YW5kIHRoZSBwcm9i
bGVtIHZlcnkgbXVjaC4KCk9rLCB0aGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLCBJIGNhbiBkbyB0
aGF0IGluIHRoZSBuZXh0IHZlcnNpb24uCgpLdWFpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

