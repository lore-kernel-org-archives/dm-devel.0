Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DEBC7EE32
	for <dm-devel@archiver.kernel.org>; Tue, 28 Feb 2023 07:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677571148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X1ldC/Nnhs8TvPrK3aTuVXMkz9iQ4PcR6QVc3YoMseo=;
	b=BAYwKDaGdxUSn0ujAv5iXRNXV+yEMJkdxzogJyVk7oOTlGnVe4LrTko+KgySDlDNLFP0Mw
	Z39ZICHTg0shlnUlSh/c9OBGlRqby2ox04Rl3sR4rkyRGgX05i6s1w7WKNwyZMzFtyB7GQ
	sd0npQIXy0/5XHVHadUckt5tiFtLawg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-Q82FvUkTPROB2jU8HOpS8Q-1; Tue, 28 Feb 2023 02:59:04 -0500
X-MC-Unique: Q82FvUkTPROB2jU8HOpS8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B657A19705B0;
	Tue, 28 Feb 2023 07:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A494D404BEC5;
	Tue, 28 Feb 2023 07:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9437819465A8;
	Tue, 28 Feb 2023 07:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BFE351946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Feb 2023 01:25:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0C5E492B0F; Tue, 28 Feb 2023 01:25:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9203492B0E
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:25:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B4B13C0CD53
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:25:48 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-668-aIHSjCRKMjaxYNKOLpGjCQ-1; Mon, 27 Feb 2023 20:25:46 -0500
X-MC-Unique: aIHSjCRKMjaxYNKOLpGjCQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PQfnb3SRHz4f3l82;
 Tue, 28 Feb 2023 09:25:39 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP4 (Coremail) with SMTP id gCh0CgBH_rEUWP1jrlTNEQ--.54551S3;
 Tue, 28 Feb 2023 09:25:41 +0800 (CST)
Message-ID: <e264ce36-b6ce-b0ad-513c-068e819cf183@huaweicloud.com>
Date: Tue, 28 Feb 2023 09:25:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Mike Snitzer <snitzer@kernel.org>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <Y/zueUWERryoIGA8@redhat.com>
X-CM-TRANSID: gCh0CgBH_rEUWP1jrlTNEQ--.54551S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZFyfCry5Wr1fZr4rZr4kXrb_yoWDCFX_Zw
 45Crykur1UJ3yktrn3tws8Xr97JF10qF15Gr45AF1jqF1UXF95Jr1fK3s5Xw1UGF47Jrsx
 Kr9Yq3W3XFnI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_JrC_JFWl1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
 A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
 67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
 wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
 80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
 I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
 k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1wL05UUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 28 Feb 2023 07:59:00 +0000
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
Cc: yangerkun@huawei.com, dm-devel@redhat.com,
 Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy8yLzI4IDE6NTUsIE1pa2UgU25pdHplciDlhpnpgZM6Cj4gT24gU3VuLCBGZWIg
MjYgMjAyMyBhdCAgODozMVAgLTA1MDAsCj4geWFuZ2Vya3VuIDx5YW5nZXJrdW5AaHVhd2VpY2xv
dWQuY29tPiB3cm90ZToKPiAKPj4KPj4KPj4g5ZyoIDIwMjMvMi8yNiAxMDowMSwgQmFydCBWYW4g
QXNzY2hlIOWGmemBkzoKPj4+IE9uIDIvMjIvMjMgMTk6MTksIHlhbmdlcmt1biB3cm90ZToKPj4+
PiBAQCAtMTkyNCw2ICsxOTI2LDEwIEBAIHN0YXRpYyBpbnQgZG1jcnlwdF93cml0ZSh2b2lkICpk
YXRhKQo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgQlVHX09OKHJiX3BhcmVudCh3cml0ZV90cmVl
LnJiX25vZGUpKTsKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKHRpbWVfaXNfYmVmb3JlX2ppZmZp
ZXMoc3RhcnRfdGltZSArIEhaKSkgewo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNjaGVk
dWxlKCk7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RhcnRfdGltZSA9IGppZmZpZXM7
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+Cj4+PiBXaHkgc2NoZWR1bGUoKSBpbnN0ZWFkIG9m
IGNvbmRfcmVzY2hlZCgpPwo+Pgo+PiBjb25kX3Jlc2NoZWQgbWF5IG5vdCByZWFsbHkgc2NoZWR1
bGUsIHdoaWNoIG1heSB0cmlnZ2VyIHRoZSBwcm9ibGVtIHRvbywgYnV0Cj4+IGl0IHNlZW1zIGFm
dGVyIDEgc2Vjb25kLCBpdCBtYXkgbmV2ZXIgaGFwcGVuZD8KPiAKPiBJIGhhZCB0aGUgc2FtZSBx
dWVzdGlvbiBhcyBCYXJ0IHdoZW4gcmV2aWV3aW5nIHlvdXIgaG9tZWdyb3duCj4gY29uZGl0aW9u
YWwgc2NoZWR1bGUoKS4gIEhvcGVmdWxseSB5b3UgY2FuIHJlcHJvZHVjZSB0aGlzIGlzc3VlPyAg
SWYKPiBzbywgcGxlYXNlIHNlZSBpZiBzaW1wbHkgdXNpbmcgY29uZF9yZXNjaGVkKCkgZml4ZXMg
dGhlIGlzc3VlLgoKWWVzLCBvdXIgdGVzdGNhc2UgY2FuIHRyaWdnZXIgdGhlIGlzc3VlLCB3aWxs
IGRvIGl0IHdpdGggY29uZF9yZXNjaGVkLgoKCgo+IAo+IFRoYW5rcywKPiBNaWtlCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

