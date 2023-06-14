Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9599BEB64DA
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686728320;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ATvft9Qg36CFmXiEtWsYA0g55C5wbCPgmeW4tDgPqQU=;
	b=C09mnO3D6bxkrbyreIQaWi6lZ58wkEtEhSGX2iHhchQiB3dLNhi5RXEkayKhkyx6y/TWlY
	mTaLWNMrztoZR2jHN1NEnTG4G3zC4Z+bEuIWffz6WJk8XljfS8DoWNhGyLoc026qBhl5C7
	n5274ZjSBIRKUwvN6OzeasWhmM+T9W0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-6KA3Ld1wNOiCgS3aEI0prg-1; Wed, 14 Jun 2023 03:38:37 -0400
X-MC-Unique: 6KA3Ld1wNOiCgS3aEI0prg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD44C381D4CA;
	Wed, 14 Jun 2023 07:38:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C969C1603B;
	Wed, 14 Jun 2023 07:38:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4606119452C2;
	Wed, 14 Jun 2023 07:38:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F6BA194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:38:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DA2AC034A3; Wed, 14 Jun 2023 07:38:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 75B53C1604C
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:38:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52175101CC76
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:38:29 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-QEEhqgi3P3ef-9G9g3ByzA-1; Wed, 14 Jun 2023 03:38:26 -0400
X-MC-Unique: QEEhqgi3P3ef-9G9g3ByzA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qgy2f26Fqz4f3wQh;
 Wed, 14 Jun 2023 15:38:18 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgBn0LNpbolk9J6wLg--.62486S3;
 Wed, 14 Jun 2023 15:38:19 +0800 (CST)
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
 <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
 <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5bf97ec5-0cb4-1163-6917-2bc98d912c2b@huaweicloud.com>
Date: Wed, 14 Jun 2023 15:38:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
X-CM-TRANSID: gCh0CgBn0LNpbolk9J6wLg--.62486S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1DCFWDWFy5WF1rJw1UKFg_yoW8ZF4Upr
 y0yF15Cr4jkr4Iv3s5K3WjqrW0y34UXa15Jr9xJry3Jwn5Kw4ftFy7CFW5uF98ZF95Jr4j
 k39YqayfJFZIy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xNCAxNToxMiwgWGlhbyBOaSDlhpnpgZM6Cj4gT24gV2VkLCBKdW4g
MTQsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdlaWNsb3VkLmNvbT4g
d3JvdGU6Cj4+Cj4+IEhpLAo+Pgo+PiDlnKggMjAyMy8wNi8xNCA5OjQ4LCBZdSBLdWFpIOWGmemB
kzoKPj4KPj4KPj4+Pgo+Pj4+IEluIHRoZSBwYXRjaCwgc3luY19zZXEgaXMgYWRkZWQgaW4gbWRf
cmVhcF9zeW5jX3RocmVhZC4gSW4KPj4+PiBpZGxlX3N5bmNfdGhyZWFkLCBpZiBzeW5jX3NlcSBp
c24ndCBlcXVhbAo+Pj4+Cj4+Pj4gbWRkZXYtPnN5bmNfc2VxLCBpdCBzaG91bGQgbWVhbiB0aGVy
ZSBpcyBzb21lb25lIHRoYXQgc3RvcHMgdGhlIHN5bmMKPj4+PiB0aHJlYWQgYWxyZWFkeSwgcmln
aHQ/IFdoeSBkbwo+Pj4+Cj4+Pj4geW91IHNheSAnbmV3IHN0YXJ0ZWQgc3luYyB0aHJlYWQnIGhl
cmU/Cj4+Cj4+IElmIHNvbWVvbmUgc3RvcHMgdGhlIHN5bmMgdGhyZWFkLCBhbmQgbmV3IHN5bmMg
dGhyZWFkIGlzIG5vdCBzdGFydGVkLAo+PiB0aGVuIHRoaXMgc3luY19zZXEgd29uJ3QgbWFrZSBh
IGRpZmZlcmVuY2UsIGFib3ZlIHdhaXRfZXZlbnQoKSB3aWxsIG5vdAo+PiB3YWl0IGJlY2F1c2Ug
IXRlc3RfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpIHdpbGwgcGFz
cy4KPj4gU28gJ3N5bmNfc2VxJyBpcyBvbmx5IHVzZWQgd2hlbiB0aGUgb2xkIHN5bmMgdGhyZWFk
IHN0b3BzIGFuZCBuZXcgc3luYwo+PiB0aHJlYWQgc3RhcnRzLCBhZGQgJ3N5bmNfc2VxJyB3aWxs
IGJ5cGFzcyB0aGlzIGNhc2UuCj4gCj4gSGkKPiAKPiBJZiBhIG5ldyBzeW5jIHRocmVhZCBzdGFy
dHMsIHdoeSBjYW4gc3luY19zZXEgYmUgZGlmZmVyZW50PyBzeW5jX3NlcQo+IGlzIG9ubHkgYWRk
ZWQgaW4gbWRfcmVhcF9zeW5jX3RocmVhZC4gQW5kIHdoZW4gYSBuZXcgc3luYyByZXF1ZXN0Cj4g
c3RhcnRzLCBpdCBjYW4ndCBzdG9wIHRoZSBzeW5jIHJlcXVlc3QgYWdhaW4/Cj4gCj4gQWYgZmly
c3QsIHRoZSBzeW5jX3NlcSBpcyAwCj4gCj4gYWRtaW4xCj4gZWNobyBpZGxlID4gc3luY19hY3Rp
b24KPiBpZGxlX3N5bmNfdGhyZWFkKHN5bmNfc2VxIGlzIDEpCgpXYWl0LCBJJ20gY29uZnVzZWQg
aGVyZSwgaG93IGNhbiBzeW5jX3NlcSB0byBiZSAxIGhlcmU/IEkgc3VwcG9zZSB5b3UKbWVhbiB0
aGF0IHRoZXJlIGlzIGEgc3luY190aHJlYWQganVzdCBmaW5pc2hlZD8KClRoZW4gdGhlIHByb2Js
ZW0gaXMgdGhhdCBpZGxlX3N5bmNfdGhyZWFkKCkgcmVhZCBzeW5jX3NlcSBhZnRlciB0aGUgb2xk
CnN5bmNfdGhyZWFkIGlzIGRvbmUsIGFuZCBuZXcgc3luY190aHJlYWQgc3RhcnQgYmVmb3JlIHdh
aXRfZXZlbnQoKSBpcwpjYWxsZWQsIHNob3VsZCB3ZSB3YWl0IGZvciB0aGlzIG5ldyBzeW5jX3Ro
cmVhZD8KCk15IGFuc3dlciBoZXJlIGlzIHRoYXQgd2Ugc2hvdWxkLCBidXQgSSdtIGFsc28gb2sg
dG8gbm90IHdhaXQgdGhpcyBuZXcKc3luY190aHJlYWQsIEkgZG9uJ3QgdGhpbmsgdGhpcyBiZWhh
dmlvdXIgbWF0dGVycy4gVGhlIGtleSBwb2ludCBoZXJlCmlzIHRoYXQgb25jZSB3YWl0X2V2ZW50
KCkgaXMgY2FsbGVkIGZyb20gaWRsZV9zeW5jX3RocmVhZCgpLCB0aGlzCndhaXRfZXZlbnQoKSBz
aG91bGQgbm90IHdhaXQgZm9yIG5ldyBzeW5jX3RocmVhZC4uLgoKPiBlY2hvIHJlc3luYyA+IHN5
bmNfYWN0aW9uIChuZXcgc3luYykKCklmIHRoaXMgaXMgYmVoaW5kICJlY2hvIGlkbGUgPiBzeW5j
X2FjdGlvbiIsIGlkbGVfc3luY190aHJlYWQgc2hvdWxkIG5vdApzZWUgdGhhdCBNRF9SRUNPVkVS
WV9SVU5OSU5HIGlzIHNldCBhbmQgd2FpdF9ldmVudCgpIHdvbid0IHdhaXQgYXQgYWxsLgoKVGhh
bmtzLApLdWFpCj4gCj4gVGhlbiBhZG1pbjIgZWNob3MgaWRsZSA+IHN5bmNfYWN0aW9uLCBzeW5j
X3NlcSBpcyBzdGlsbCAxCj4gCj4gUmVnYXJkcwo+IFhpYW8KPiAKPj4KPj4gVGhhbmtzLAo+PiBL
dWFpCj4+Cj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

