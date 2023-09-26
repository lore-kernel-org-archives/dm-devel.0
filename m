Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 571ECE81817
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 03:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695698947;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BeXhbBTI8kE/JRAvygOn5MX0ZWZ/TpobOwqiqx847/Q=;
	b=AiGkrfp58f8TDhGMX8ct+HckrfRuEqVKelQdEbbI+VqFWQ1eHnFqhk+TnHRBfOwnsUh+fo
	HoBa86AunTOXOLw6Ak0aMXvzU9nxb7sPhIFMXUyN17l8a/M8x15JN0G+IuYbPwkOc/qr3Z
	ZC4rJOeOExIub29ejfvZHytlcYSyy+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-y3yiDbAgOOqMwXxZc2Ngog-1; Mon, 25 Sep 2023 23:29:04 -0400
X-MC-Unique: y3yiDbAgOOqMwXxZc2Ngog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F37A800045;
	Tue, 26 Sep 2023 03:29:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7C1A2156702;
	Tue, 26 Sep 2023 03:28:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E201194658D;
	Tue, 26 Sep 2023 03:28:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AEE95194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 03:28:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B5F7140E962; Tue, 26 Sep 2023 03:28:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 84336140E953
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 03:28:57 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6761F811E7B
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 03:28:57 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-4ZBkscdAO0KKn4bAOEwAiw-1; Mon, 25 Sep 2023 23:28:54 -0400
X-MC-Unique: 4ZBkscdAO0KKn4bAOEwAiw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RvlZj13Ljz4f3m6S
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 11:28:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdztTxJlxXikBQ--.47968S3;
 Tue, 26 Sep 2023 11:28:47 +0800 (CST)
To: Kirill Kirilenko <kirill@ultracoder.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
 <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d45ffbcd-cf55-f07c-c406-0cf762a4b4ec@huaweicloud.com>
Date: Tue, 26 Sep 2023 11:28:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
X-CM-TRANSID: gCh0CgAnvdztTxJlxXikBQ--.47968S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF17KFWUtF4fArWDAr1fZwb_yoW8trWDpr
 WvqFWYvrWUJr1kJr1DJr1UAry8Jr1Dt39rKr18XFyUXr17JFyjqr4kXryjgr1DGr48Gw1j
 qw1UJr1UuFyUJrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
 IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
 6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
 DUUUUU=
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
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Roman Mamedov <rm@romanrm.net>, "yukuai \(C\)" <yukuai3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wOS8yNiA3OjU5LCBLaXJpbGwgS2lyaWxlbmtvIOWGmemBkzoKPiBPbiAy
NS4wOS4yMDIzIDA1OjU4ICswMzAwLCBZdSBLdWFpIHdyb3RlOgo+PiBSb21hbiBhbmQgS2lyaWxs
LCBjYW4geW91IHRlc3QgdGhlIGZvbGxvd2luZyBwYXRjaD8KPj4KPj4gVGhhbmtzLAo+PiBLdWFp
Cj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQxLmMgYi9kcml2ZXJzL21kL3JhaWQx
LmMKPj4gaW5kZXggNGIzMGExNzQyMTYyLi40OTYzZjg2NGVmOTkgMTAwNjQ0Cj4+IC0tLSBhL2Ry
aXZlcnMvbWQvcmFpZDEuYwo+PiArKysgYi9kcml2ZXJzL21kL3JhaWQxLmMKPj4gQEAgLTEzNDUs
NiArMTM0NSw3IEBAIHN0YXRpYyB2b2lkIHJhaWQxX3dyaXRlX3JlcXVlc3Qoc3RydWN0IG1kZGV2
Cj4+ICptZGRldiwgc3RydWN0IGJpbyAqYmlvLAo+PiAgwqDCoMKgwqDCoMKgwqAgaW50IGZpcnN0
X2Nsb25lOwo+PiAgwqDCoMKgwqDCoMKgwqAgaW50IG1heF9zZWN0b3JzOwo+PiAgwqDCoMKgwqDC
oMKgwqAgYm9vbCB3cml0ZV9iZWhpbmQgPSBmYWxzZTsKPj4gK8KgwqDCoMKgwqDCoCBib29sIGlz
X2Rpc2NhcmQgPSAoYmlvX29wKGJpbykgPT0gUkVRX09QX0RJU0NBUkQpOwo+Pgo+PiAgwqDCoMKg
wqDCoMKgwqAgaWYgKG1kZGV2X2lzX2NsdXN0ZXJlZChtZGRldikgJiYKPj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBtZF9jbHVzdGVyX29wcy0+YXJlYV9yZXN5bmNpbmcobWRkZXYsIFdSSVRF
LAo+PiBAQCAtMTQwNSw3ICsxNDA2LDcgQEAgc3RhdGljIHZvaWQgcmFpZDFfd3JpdGVfcmVxdWVz
dChzdHJ1Y3QgbWRkZXYKPj4gKm1kZGV2LCBzdHJ1Y3QgYmlvICpiaW8sCj4+ICDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHdyaXRlLW1vc3RseSwgd2hpY2ggbWVhbnMgd2UgY291
bGQgYWxsb2NhdGUgd3JpdGUKPj4gYmVoaW5kCj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqIGJpbyBsYXRlci4KPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICovCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZGV2ICYmIHRlc3RfYml0
KFdyaXRlTW9zdGx5LCAmcmRldi0+ZmxhZ3MpKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoIWlzX2Rpc2NhcmQgJiYgcmRldiAmJiB0ZXN0X2JpdChXcml0ZU1vc3RseSwKPj4g
JnJkZXYtPmZsYWdzKSkKPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgd3JpdGVfYmVoaW5kID0gdHJ1ZTsKPj4KPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAocmRldiAmJiB1bmxpa2VseSh0ZXN0X2JpdChCbG9ja2VkLCAmcmRldi0+
ZmxhZ3MpKSkgewo+IAo+IFRoYW5rIHlvdS4gSSBjYW4gY29uZmlybSwgdGhhdCB5b3VyIHBhdGNo
IGVsaW1pbmF0ZXMgZnJlZXplcyBkdXJpbmcKPiAnZnN0cmltJyBleGVjdXRpb24uIFRlc3RlZCBv
biBrZXJuZWwgNi41LjAuCj4gU3RpbGwgJ2ZzdHJpbScgdGFrZXMgbW9yZSB0aGFuIDIgbWludXRl
cywgYnV0IEkgYmVsaWV2ZSBpdCdzIG5vcm1hbCB0byBhCj4gZmlsZSBzeXN0ZW0gd2l0aCAxTSsg
aW5vZGVzLgpUaGFua3MgZm9yIHRoZSB0ZXN0LgoKPiAKPiBQcm9iYWJseSBJJ20gd3JvbmcgaGVy
ZSwgYnV0IHRvIG1lIHRoaXMgZG9lc24ndCBsb29rIGxpa2UgYSBzb2x1dGlvbiwKPiBtb3JlIGxp
a2UgYSBtYXNraW5nIHRoZSByZWFsIHByb2JsZW0uCj4gRXZlbiB3aXRoIFRSSU0gb3BlcmF0aW9u
cyBzcGxpdCBpbiAxTUIgcGllY2VzLCBJIGRvbid0IGV4cGVjdCBrZXJuZWwgdG8KPiBmcmVlemUu
CgpJIHN0aWxsIGRvbid0IHF1aXRlIHVuZGVyc3RhbmQgd2hhdCB5b3UgbWVhbiAna2VybmVsIGZy
ZWV6ZScsIHRoaXMgcGF0Y2gKaW5kZWVkIGZpeCBhIHByb2JsZW0gdGhhdCBkaXNrY2FyZCBiaW8g
aXMgdHJlYXRlZCBhcyBub3JtYWwgd3JpdGUgYmlvCmFuZCBpdCdzIHNwbGl0dGVkLgoKQ2FuIHlv
dSBleHBsYWluIG1vcmUgYnkgaG93IGRvIHlvdSBqdWRnZSAna2VybmVsIGZyZWV6ZSc/IEluIHRo
ZQptZWFudGltZSBkb3NlICdpb3N0YXQgLWRteCAxJyBzaG93cyB0aGF0IGRpc2sgaXMgaWRsZSBh
bmQgbm8gZGljYXJkIGlvCmlzIGhhbmRsZWQ/CgpUaGFua3MsCkt1YWkKCj4gCj4gLgo+IAoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

