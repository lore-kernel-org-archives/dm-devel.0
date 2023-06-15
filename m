Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAC2EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 01:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686792552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n3zdkopwuXiCjKBx07xXZvbNvfmo3PLG2m2lMg7Nzic=;
	b=OM16eM9mC4QUuWCKvC+hjEaFcsCs3d+z9aCMxwNZ0/ThTVhVtTekFlYW3Fu7mAaEYp6Iw3
	KWT8yN1R3Vn+7Tsar1ZwD9RfqnnC22bRF51h0F9Ge7WuVp9puwoAJXoOhD4uHmypN1Ua0X
	pqF5dIsR9l2tJYNKzpWzOA1OG56U6JI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-__KXw8MpMaWT5xB0mflctQ-1; Wed, 14 Jun 2023 21:29:08 -0400
X-MC-Unique: __KXw8MpMaWT5xB0mflctQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89F4980879D;
	Thu, 15 Jun 2023 01:29:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4779492C1B;
	Thu, 15 Jun 2023 01:29:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79ED119451D9;
	Thu, 15 Jun 2023 01:29:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 73BA519451CD
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 01:28:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0CC3540C20F5; Thu, 15 Jun 2023 01:28:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 051AC40C20F4
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 01:28:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE01D830EFE
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 01:28:58 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-VgMhmfuPO3iWGra1fBA6Sw-1; Wed, 14 Jun 2023 21:28:54 -0400
X-MC-Unique: VgMhmfuPO3iWGra1fBA6Sw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QhPnr2BQyz4f3nJS;
 Thu, 15 Jun 2023 09:28:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgD3mp5PaYpkU3_rLg--.4972S3;
 Thu, 15 Jun 2023 09:28:49 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
 <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
 <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
 <5bf97ec5-0cb4-1163-6917-2bc98d912c2b@huaweicloud.com>
 <CALTww28UapJnK+Xfx7O9uEd5ZH2E7ufPT_7pKY6YYuzTZ0Fbdw@mail.gmail.com>
 <b96ec15b-6102-17bb-2c18-a487f224865b@huaweicloud.com>
 <CALTww2-knHOoX35NB73X-sMn1u8EJHLA=0aOnoVqVm83+fdG5Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <04700f85-62a2-1dbd-f330-80f9a13b7d2e@huaweicloud.com>
Date: Thu, 15 Jun 2023 09:28:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2-knHOoX35NB73X-sMn1u8EJHLA=0aOnoVqVm83+fdG5Q@mail.gmail.com>
X-CM-TRANSID: gCh0CgD3mp5PaYpkU3_rLg--.4972S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF45JFy8Xr4xAr18trWUArb_yoWruw47pr
 y8AF1UGr4UAr47Z34Ut3WjvFW0y34UXF15Xr9xJry3Jwn5Kw4ftFW7CFW5uFykZFn5Jw1U
 ZrWrJFWfZFWqy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
 3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
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
Subject: Re: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xNCAxNzowOCwgWGlhbyBOaSDlhpnpgZM6Cj4gT24gV2VkLCBKdW4g
MTQsIDIwMjMgYXQgNDoyOeKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3
cm90ZToKPj4KPj4gSGksCj4+Cj4+IOWcqCAyMDIzLzA2LzE0IDE1OjU3LCBYaWFvIE5pIOWGmemB
kzoKPj4+IE9uIFdlZCwgSnVuIDE0LCAyMDIzIGF0IDM6MzjigK9QTSBZdSBLdWFpIDx5dWt1YWkx
QGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4+Pj4KPj4+PiBIaSwKPj4+Pgo+Pj4+IOWcqCAyMDIz
LzA2LzE0IDE1OjEyLCBYaWFvIE5pIOWGmemBkzoKPj4+Pj4gT24gV2VkLCBKdW4gMTQsIDIwMjMg
YXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4+
Pj4+Pgo+Pj4+Pj4gSGksCj4+Pj4+Pgo+Pj4+Pj4g5ZyoIDIwMjMvMDYvMTQgOTo0OCwgWXUgS3Vh
aSDlhpnpgZM6Cj4+Pj4+Pgo+Pj4+Pj4KPj4+Pj4+Pj4KPj4+Pj4+Pj4gSW4gdGhlIHBhdGNoLCBz
eW5jX3NlcSBpcyBhZGRlZCBpbiBtZF9yZWFwX3N5bmNfdGhyZWFkLiBJbgo+Pj4+Pj4+PiBpZGxl
X3N5bmNfdGhyZWFkLCBpZiBzeW5jX3NlcSBpc24ndCBlcXVhbAo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBt
ZGRldi0+c3luY19zZXEsIGl0IHNob3VsZCBtZWFuIHRoZXJlIGlzIHNvbWVvbmUgdGhhdCBzdG9w
cyB0aGUgc3luYwo+Pj4+Pj4+PiB0aHJlYWQgYWxyZWFkeSwgcmlnaHQ/IFdoeSBkbwo+Pj4+Pj4+
Pgo+Pj4+Pj4+PiB5b3Ugc2F5ICduZXcgc3RhcnRlZCBzeW5jIHRocmVhZCcgaGVyZT8KPj4+Pj4+
Cj4+Pj4+PiBJZiBzb21lb25lIHN0b3BzIHRoZSBzeW5jIHRocmVhZCwgYW5kIG5ldyBzeW5jIHRo
cmVhZCBpcyBub3Qgc3RhcnRlZCwKPj4+Pj4+IHRoZW4gdGhpcyBzeW5jX3NlcSB3b24ndCBtYWtl
IGEgZGlmZmVyZW5jZSwgYWJvdmUgd2FpdF9ldmVudCgpIHdpbGwgbm90Cj4+Pj4+PiB3YWl0IGJl
Y2F1c2UgIXRlc3RfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpIHdp
bGwgcGFzcy4KPj4+Pj4+IFNvICdzeW5jX3NlcScgaXMgb25seSB1c2VkIHdoZW4gdGhlIG9sZCBz
eW5jIHRocmVhZCBzdG9wcyBhbmQgbmV3IHN5bmMKPj4+Pj4+IHRocmVhZCBzdGFydHMsIGFkZCAn
c3luY19zZXEnIHdpbGwgYnlwYXNzIHRoaXMgY2FzZS4KPj4+Pj4KPj4+Pj4gSGkKPj4+Pj4KPj4+
Pj4gSWYgYSBuZXcgc3luYyB0aHJlYWQgc3RhcnRzLCB3aHkgY2FuIHN5bmNfc2VxIGJlIGRpZmZl
cmVudD8gc3luY19zZXEKPj4+Pj4gaXMgb25seSBhZGRlZCBpbiBtZF9yZWFwX3N5bmNfdGhyZWFk
LiBBbmQgd2hlbiBhIG5ldyBzeW5jIHJlcXVlc3QKPj4+Pj4gc3RhcnRzLCBpdCBjYW4ndCBzdG9w
IHRoZSBzeW5jIHJlcXVlc3QgYWdhaW4/Cj4+Pj4+Cj4+Pj4+IEFmIGZpcnN0LCB0aGUgc3luY19z
ZXEgaXMgMAo+Pj4+Pgo+Pj4+PiBhZG1pbjEKPj4+Pj4gZWNobyBpZGxlID4gc3luY19hY3Rpb24K
Pj4+Pj4gaWRsZV9zeW5jX3RocmVhZChzeW5jX3NlcSBpcyAxKQo+Pj4+Cj4+Pj4gV2FpdCwgSSdt
IGNvbmZ1c2VkIGhlcmUsIGhvdyBjYW4gc3luY19zZXEgdG8gYmUgMSBoZXJlPyBJIHN1cHBvc2Ug
eW91Cj4+Pj4gbWVhbiB0aGF0IHRoZXJlIGlzIGEgc3luY190aHJlYWQganVzdCBmaW5pc2hlZD8K
Pj4+Cj4+PiBIaSBLdWFpCj4+Pgo+Pj4gWWVzLiBCZWNhdXNlIGlkbGVfc3luY190aHJlYWQgbmVl
ZHMgdG8gd2FpdCB1bnRpbCBtZF9yZWFwX3N5bmNfdGhyZWFkCj4+PiBmaW5pc2hlcy4gQW5kIG1k
X3JlYXBfc3luY190aHJlYWQgYWRkcyBzeW5jX3NlcS4gRG8gSSB1bmRlcnN0YW5kIHlvdXIKPj4+
IHBhdGNoIHJpZ2h0Pwo+Pgo+PiBZZXMsIG5vdGVkIHRoYXQgaWRsZV9zeW5jX3RocmVhZCgpIHdp
bGwgb25seSB3YWl0IGlmIE1EX1JFQ09WRVJZX1JVTk5JTkcKPj4gaXMgc2V0Lgo+Pgo+Pj4KPj4+
Pgo+Pj4+IFRoZW4gdGhlIHByb2JsZW0gaXMgdGhhdCBpZGxlX3N5bmNfdGhyZWFkKCkgcmVhZCBz
eW5jX3NlcSBhZnRlciB0aGUgb2xkCj4+Pj4gc3luY190aHJlYWQgaXMgZG9uZSwgYW5kIG5ldyBz
eW5jX3RocmVhZCBzdGFydCBiZWZvcmUgd2FpdF9ldmVudCgpIGlzCj4+Pj4gY2FsbGVkLCBzaG91
bGQgd2Ugd2FpdCBmb3IgdGhpcyBuZXcgc3luY190aHJlYWQ/Cj4+Pj4KPj4+PiBNeSBhbnN3ZXIg
aGVyZSBpcyB0aGF0IHdlIHNob3VsZCwgYnV0IEknbSBhbHNvIG9rIHRvIG5vdCB3YWl0IHRoaXMg
bmV3Cj4+Pj4gc3luY190aHJlYWQsIEkgZG9uJ3QgdGhpbmsgdGhpcyBiZWhhdmlvdXIgbWF0dGVy
cy4gVGhlIGtleSBwb2ludCBoZXJlCj4+Pj4gaXMgdGhhdCBvbmNlIHdhaXRfZXZlbnQoKSBpcyBj
YWxsZWQgZnJvbSBpZGxlX3N5bmNfdGhyZWFkKCksIHRoaXMKPj4+PiB3YWl0X2V2ZW50KCkgc2hv
dWxkIG5vdCB3YWl0IGZvciBuZXcgc3luY190aHJlYWQuLi4KPj4+Cj4+PiBJIHRoaW5rIHdlIHNo
b3VsZCB3YWl0LiBJZiB3ZSBkb24ndCB3YWl0IGZvciBpdCwgdGhlcmUgaXMgYSBwcm9ibGVtLgo+
Pj4gT25lIHBlcnNvbiBlY2hvcyBpZGxlIHRvIHN5bmNfYWN0aW9uIGFuZCBpdCBkb2Vzbid0IHdv
cmsgc29tZXRpbWVzLgo+Pj4gSXQncyBhIHN0cmFuZ2UgdGhpbmcuCj4+Pgo+Pgo+PiBPay4gSSds
bCBhZGQgbmV3IGNvbW1lbnQgdG8gZW1waGFzaXplIHRoYXQgaWRsZV9zeW5jX3RocmVhZCgpIHdv
bid0IHdhaXQKPj4gZm9yIG5ldyBzeW5jX3RocmVhZCB0aGF0IGlzIHN0YXJ0ZWQgYWZ0ZXIgd2Fp
dF9ldmVudCgpLgo+IAo+IEkgc3VnZ2VzdCByZW1vdmluZyB0aGlzIGZ1bmN0aW9uLiBXaXRob3V0
IHRoaXMgY2hhbmdlLCBpdCdzIG1vcmUKPiBzaW1wbGUgYW5kIGl0IGNhbiB3b3JrIHdlbGwgd2l0
aG91dCBwcm9ibGVtLiBUaGUgcGVvcGxlIHRoYXQgZWNobyBpZGxlCj4gdG8gc3luY19hY3Rpb24g
bmVlZHMgdG8gd2FpdCB1bnRpbCB0aGUgc3luYyBhY3Rpb24gZmluaXNoZXMuIFRoZSBjb2RlCj4g
c2VtYW50aWMgaXMgY2xlYXIgYW5kIHNpbXBsZS4KPj4KPj4+Pgo+Pj4+PiBlY2hvIHJlc3luYyA+
IHN5bmNfYWN0aW9uIChuZXcgc3luYykKPj4+Pgo+Pj4+IElmIHRoaXMgaXMgYmVoaW5kICJlY2hv
IGlkbGUgPiBzeW5jX2FjdGlvbiIsIGlkbGVfc3luY190aHJlYWQgc2hvdWxkIG5vdAo+Pj4+IHNl
ZSB0aGF0IE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgc2V0IGFuZCB3YWl0X2V2ZW50KCkgd29uJ3Qg
d2FpdCBhdCBhbGwuCj4+Pgo+Pj4gYGVjaG8gcmVzeW5jID4gc3luY19hY3Rpb25gIGNhbid0IGNo
YW5nZSB0aGUgc3luY19zZXEuIFNvICdlY2hvIGlkbGUgPgo+Pj4gc3luY19hY3Rpb24nIHN0aWxs
IHdhaXRzIHVudGlsIE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgY2xlYXJlZD8KPj4KPj4gVGhpcyBp
cyBub3QgYWNjdXJhdGUsIGlmIGBlY2hvIHJlc3luYyA+IHN5bmNfYWN0aW9uYCB0cmlnZ2VycyBh
IG5ldwo+PiBzeW5jX3RocmVhZCwgdGhlbiBzeW5jX3NlcSBpcyB1cGRhdGVkIHdoZW4gdGhpcyBz
eW5jX3RocmVhZCBpcyBkb25lLAo+PiBkdXJpbmcgdGhpcyBwZXJpb2QsIE1EX1JFQ09WRVJZX1JV
Tk5JTkcgaXMgc3RpbGwgc2V0LCBzbyBgZWNobyBpZGxlCj4+ICAgPnN5bmNfYWN0aW9uYCB3aWxs
IHdhaXQgZm9yIHN5bmNfdGhyZWFkIHRvIGJlIGRvbmUuCj4gCj4gSSBjYW4gdW5kZXJzdGFuZCB5
b3VyIGNvbW1lbnQsIGJ1dCBzb3JyeSwgSSBzdGlsbCBjYW4ndCBnZXQgaG93Cj4gc3luY19zZXEg
d29ya3MuIENvdWxkIHlvdSBnaXZlIGEgc3BlY2lmaWMgY2FzZSB0aGF0IGV4cGxhaW5zIGhvdyBp
dAo+IHdvcmtzPwoKT2ssIHRoZSBwcm9ibGVtIGlzIHRoYXQgZWNobyBpbGRlIGlzIHN1cHBvc2Vk
IHRvIGludGVycnVwdCBzeW5jX3RocmVhZAphbmQgc3RvcCBzeW5jX3RocmVhZCBxdWlja2x5LiBO
b3cgdGhhdCB3ZSBkb24ndCBob2xkIG11dGV4IGhlcmUsIHdlCmNhbid0IHByZXZlbnQgbmV3IHN5
bmNfdGhyZWFkIHRvIHN0YXJ0LiBGb3IgZXhhcG1sZToKCjEpIGEgc3luY190aHJlYWQgQSBpcyBy
dW5pbmcsIE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgc2V0OwoKMikgZWNobyBpZGxlLCBBIHdpbGwg
YmUgaW50ZXJydXB0ZWQsIG11dGV4IGlzIG5vdCBob2xkIGFuZAppZGxlX3N5bmNfdGhyZWFkKCkg
aXMgd2FpdGluZyBmb3IgTURfUkVDT1ZFUllfUlVOTklORyB0byBiZSBjbGVhcmVkLgoKMykgQSBp
cyBpbnRlcnJ1cHRlZCwgaXQnbGwgY2xlYXIgTURfUkVDT1ZFUllfUlVOTklORyBhbmQgdHJ5IHRv
IHdha2V1cAppZGxlX3N5bmNfdGhyZWFkKCksIGhvd2V2ZXIsIGJlZm9yZSBpZGxlX3N5bmNfdGhy
ZWFkKCkgaXMgd29rZW4sIEEgY2FuCmJlIGRvbmUgYW5kIGEgbmV3IHN5bmNfdGhyZWFkIEIgY2Fu
IGJlIHN0YXJ0ZWQsIGFuZCBNRF9SRUNPVkVSWV9SVU5OSU5HCndpbGwgYmUgc2V0IGFnYWluLgoK
NCkgaWRsZV9zeW5jX3RocmVhZCgpIGZpbmlhbGx5IHdha2UgdXAsIGhvd2V2ZXIsIE1EX1JFQ09W
RVJZX1JVTk5JTkcgaXMKc2V0IGFuZCBpdCB3aWxsIHN0aWxsIHdhaXRpbmcuIEFuZCB0aGlzIHRp
bWUgQiB3b24ndCBiZSBpbnRlcnJ1cHRlZC4KClRoYW5rcywKS3VhaQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

