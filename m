Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B59C64EC7
	for <dm-devel@archiver.kernel.org>; Tue, 28 Feb 2023 07:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677571147;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pT82eVNlCyvO8oHlBufhfE2Xo1E4qGxfx+tSzIXTgpo=;
	b=PNc7sa1XuhuJjqI0Rq/09Q1xzs6eOSzFaW/W8ILroXU3dF/YnA3t5SX6e51rmxf4ds54hI
	zM+oYh3cfy2jBd00fqb8IjfGyOvKN69WJHKQs/6djH6UdV+FuWiMkcSMQtfzlrbTWu8s77
	UeDv6dOfYmpuLuv2mv5wJoICJOxKgDg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-d9gg1lpPPHyC3lxCvyaDZw-1; Tue, 28 Feb 2023 02:59:04 -0500
X-MC-Unique: d9gg1lpPPHyC3lxCvyaDZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38699384D029;
	Tue, 28 Feb 2023 07:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9A201415117;
	Tue, 28 Feb 2023 07:59:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B9531946589;
	Tue, 28 Feb 2023 07:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96E0B1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Feb 2023 01:18:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79979C15BAE; Tue, 28 Feb 2023 01:18:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72486C15BAD
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:18:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5693585CBE0
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:18:38 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-M9GL62w9P7u18aCtZc8LYg-1; Mon, 27 Feb 2023 20:18:36 -0500
X-MC-Unique: M9GL62w9P7u18aCtZc8LYg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PQfdK2Gk7z4f3mJX;
 Tue, 28 Feb 2023 09:18:29 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbBlVv1jGgPNEQ--.48273S3;
 Tue, 28 Feb 2023 09:18:31 +0800 (CST)
Message-ID: <5642df90-2ad4-19d4-538e-b1630cc00b76@huaweicloud.com>
Date: Tue, 28 Feb 2023 09:18:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Mike Snitzer <snitzer@kernel.org>
References: <20230223031818.3713509-1-yangerkun@huaweicloud.com>
 <Y/0Y6LyZqsNZhbo4@redhat.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <Y/0Y6LyZqsNZhbo4@redhat.com>
X-CM-TRANSID: gCh0CgAHvbBlVv1jGgPNEQ--.48273S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr15CF45tF1fAw1rWF43GFg_yoWkAFb_CF
 W7Gwn3tw1UJrsaqa17J3W7tryDZFW7XrWUuay5GF9rXr18tFZ5uF93Wrn5Zw13Aay8ZrnI
 9r9Yv34kZ3sIkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUbzAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_JrC_JFWl1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
 A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
 67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
 wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
 80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
 I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
 k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
 1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 28 Feb 2023 07:59:00 +0000
Subject: Re: [dm-devel] dm-crypt: reexport sysfs of kcryptd workqueue
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
Cc: dm-devel@redhat.com, yangerkun@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy8yLzI4IDQ6NTYsIE1pa2UgU25pdHplciDlhpnpgZM6Cj4gT24gV2VkLCBGZWIg
MjIgMjAyMyBhdCAxMDoxOFAgLTA1MDAsCj4geWFuZ2Vya3VuIDx5YW5nZXJrdW5AaHVhd2VpY2xv
dWQuY29tPiB3cm90ZToKPiAKPj4gRnJvbTogeWFuZ2Vya3VuIDx5YW5nZXJrdW5AaHVhd2VpLmNv
bT4KPj4KPj4gJ2EyYjhiMmQ5NzU2NyAoImRtIGNyeXB0OiBleHBvcnQgc3lzZnMgb2Yga2NyeXB0
ZCB3b3JrcXVldWUiKScgZ2l2ZSB1cwo+PiBpZGVhIHRvIHNldCBzcGVjaWZpYyBDUFUgb3IgbGlt
aXQgbWF4X2FjdGl2ZSBjcnlwdCB3b3JrLiBIb3dldmVyIHN5c2ZzCj4+IHdpbGwgcmVwb3J0IGEg
d2Fybm5pbmcgYW5kIGZhaWwgJ2NyeXB0c2V0dXAgcmVmcmVzaCB0ZXN0JyBzaW5jZSB0aGUKPj4g
cmVsb2FkIHdpbGwgYWxsb2Mgd29ya3F1ZXVlIHdpdGggc2FtZSBzeXNmcyBuYW1lLCBhbmQgd2Ug
dGVtcG9yYXJpbHkKPj4gcmV2ZXJ0IHRoaXMgZmVhdHVyZSB0byBmaXggdGhlIHByb2JsZW0uCj4+
Cj4+IFdoYXQgd2UgYWN0dWFsbHkgc2hvdWxkIGRvIGlzIGdpdmUgYSB1bmlxdWUgbmFtZSBvbmNl
IHdlIHRyeSByZWxvYWQKPj4gdGFibGUsIHdlIGNhbiB1c2UgaWRhIG5vdy4KPiAKPiBUaGlzIGhl
YWRlciBuZWVkcyB0byBiZSByZXdyaXR0ZW4gdG8gZGVhbCBkaXJlY3RseSB3aXRoIHRoZSBmYWN0
Ogo+IDEpIENvbW1pdCA0OGIwNzc3Y2Q5M2QgKFJldmVydCAiZG0gY3J5cHQ6IGV4cG9ydCBzeXNm
cyBvZiBrY3J5cHRkCj4gICAgIHdvcmtxdWV1ZSIpIGRlYWx0IHdpdGggd2hhdCB5b3UgY2FsbCAi
dGVtcG9yYXJpbHkgcmV2ZXJ0Ii4KPiAyKSBHcmVhdCB0aGF0IHlvdSBmaXhlZCBpdCB1c2luZyBJ
REEgYnV0IHlvdSBzdGlsbCBoYXZlbid0IGNsZWFybHkKPiAgICAgZXhwbGFpbmVkIHRoZSBiZW5l
Zml0IG9mIGV4cG9zaW5nIHRoaXMgc3lzZnMgaW50ZXJmYWNlIChwbGVhc2UgYWRkCj4gICAgIGRl
dGFpbHMgb24gd2hpY2ggdXNlcnNwYWNlIGlzIGNvbnN1bWluZyBpdCkuIEkgc3VwcG9zZSB5b3Ug
Y291bGQKPiAgICAgZXhwbGFpbiBieSByZWZlcnJpbmcgdG8gY29tbWl0IGEyYjhiMmQ5NzU2NzMg
KHRoYXQgd2FzIHJldmVydGVkKT8KClRoYW5rcyBhIGxvdCwgd2lsbCBkbyBpdCBuZXh0IHZlcnNp
b24uCgo+IAo+IFRoYW5rcywKPiBNaWtlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

