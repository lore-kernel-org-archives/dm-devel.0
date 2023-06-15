Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC2B9EB64DC
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 09:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686819949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/rvNZfqVlbLGDnKjvDISth1NkQ5klD9Vlp186t3NRBE=;
	b=i2/akhvE7OReYofSVJPPiaPbL2wwiDzb4ruzStT7gU8vEZSAVAIBK29+da0GzU7ql0sZmE
	X7UukoE8cznO2dHoBFJclUeO5rS6VZzuz9ibAwm2V/nnoh2JCtbM9hzNftXL911BalU0TS
	7hYKPeHWP7w9khZ3fOxF9CQnU2c86g8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-y0SDYnBfMgaYv96qIks4cA-1; Thu, 15 Jun 2023 05:05:48 -0400
X-MC-Unique: y0SDYnBfMgaYv96qIks4cA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7631E810BB4;
	Thu, 15 Jun 2023 09:05:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 285DF2026D49;
	Thu, 15 Jun 2023 09:05:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEBD91946588;
	Thu, 15 Jun 2023 09:05:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B04901946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 09:05:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DED7F1121314; Thu, 15 Jun 2023 09:05:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7BA61121315
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 09:05:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8871E3806062
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 09:05:35 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-46KfdafBOIO2kv7Nme7Zmw-1; Thu, 15 Jun 2023 05:05:32 -0400
X-MC-Unique: 46KfdafBOIO2kv7Nme7Zmw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qhbwk0Rk0z4f3lX4;
 Thu, 15 Jun 2023 17:05:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgCH77JS1IpkhGIELw--.57144S3;
 Thu, 15 Jun 2023 17:05:23 +0800 (CST)
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
 <04700f85-62a2-1dbd-f330-80f9a13b7d2e@huaweicloud.com>
 <CALTww2-Wr8UbNFaLOyYv5Syh5q4J+hzRuo8Eakj_nOW+P4Cx7A@mail.gmail.com>
 <CALTww2_V=KVLqVVXpXZvGyrmT0N-WG1tFC+HaSEGNfHagaLHug@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bacb3159-514c-76e2-ef2e-353cb1a0e30b@huaweicloud.com>
Date: Thu, 15 Jun 2023 17:05:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2_V=KVLqVVXpXZvGyrmT0N-WG1tFC+HaSEGNfHagaLHug@mail.gmail.com>
X-CM-TRANSID: gCh0CgCH77JS1IpkhGIELw--.57144S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw45WFW3KF45tr43try7Wrg_yoW8WrWrpr
 Z2k3W5KrWDGry0yFy2v3W0qFWFvrW7X345Xry3Gr13Aw15Krs0qrWUAayDuF97uFyrKw42
 v395Ja4fJF4UKFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xNSAxNjoxNywgWGlhbyBOaSDlhpnpgZM6Cj4+IFRoYW5rcyBmb3Ig
dGhlIGV4YW1wbGUuIEkgY2FuIHVuZGVyc3RhbmQgdGhlIHVzYWdlIG9mIGl0LiBJdCdzIHRoZQo+
PiBzaWRlIGVmZmVjdCB0aGF0IHJlbW92ZXMgdGhlIG11dGV4IHByb3RlY3Rpb24gZm9yIGlkbGVf
c3luY190aHJlYWQuCj4+Cj4+IFRoZXJlIGlzIGEgcHJvYmxlbS4gTmV3IHN5bmMgdGhyZWFkIGlz
IHN0YXJ0ZWQgaW4gbWRfY2hlY2tfcmVjb3ZlcnkuCj4+IEFmdGVyIHlvdXIgcGF0Y2gsIG1kX3Jl
YXBfc3luY190aHJlYWQgaXMgY2FsbGVkIGluIG1kX2NoZWNrX3JlY292ZXJ5Cj4+IHRvby4gU28g
aXQgbG9va3MgbGlrZSB0aGV5IGNhbid0IGhhcHBlbiBhdCB0aGUgc2FtZSB0aW1lPwoKT2YgY291
cnNlIHRoZXkgY2FuJ3QuIG1kX2NoZWNrX3JlY292ZXJ5KCkgY2FuIG9ubHkgZG8gb25lIHRoaW5n
IGF0IGEKdGltZS4KCj4gCj4gQWZ0ZXIgdGhpbmtpbmcgYSB3aGlsZSwgdGhlcmUgaXMgc3RpbGwg
YSByYWNlIHBvc3NpYmlsaXR5Lgo+IAo+IG1kX3JlYXBfc3luY190aHJlYWQgaXMgY2FsbGVkIGlu
IHBlcnMgZGVhbW9uIChlLmcuIHJhaWQxMGQgLT4KPiBtZF9jaGVja19yZWNvdmVyeSkgYW5kIG1k
X2NoZWNrX3JlY292ZXJ5IHJldHVybnMuIEJlZm9yZQo+IGlkbGVfc3luY190aHJlYWQgaXMgd29r
ZW4sIHRoZSBuZXcgc3luYyB0aHJlYWQgY2FuIGJlIHN0YXJ0ZWQgaW4KPiBtZF9jaGVja19yZWNv
dmVyeSBhZ2Fpbi4KPiAKPiBCdXQgaXQncyByZWFsbHkgc3RyYW5nZSwgd2hlbiBvbmUgcGVvcGxl
IGVjaG8gaWRsZSB0byBzeW5jX2FjdGlvbi4KPiBJdCdzIGJldHRlciB0byBhZGQgc29tZSBtZXNz
YWdlcyB0byBub3RpZnkgdGhlIHVzZXJzIHRoYXQgdGhleSBuZWVkIHRvCj4gZWNobyBpZGxlIHRv
IHN5bmNfYWN0aW9uIGFnYWluIHRvIGhhdmUgYSB0cnkuIElzIHRoZXJlIGEgd2F5IHRoYXQKPiBt
ZF9yZWFwX3N5bmNfdGhyZWFkIGNhbiB3YWl0IGlkbGVfc3luY190aHJlYWQ/CgpJIGRvbid0IHRo
aW5rIHRoaXMgaXMgYSBwcm9ibGVtLCBlY2hvIGlkbGUgb25seSBtYWtlIHN1cmUgdG8gaW50ZXJ1
cHQKY3VycmVudCBzeW5jX3RocmVhZCwgdGhlcmUgaXMgbm8gZ3VyYW50ZWUgdGhhdCBzeW5jX3Ro
cmVhZCBpcyBub3QKcnVubmluZyBhZnRlciAiZWNobyBpZGxlIiBpcyBkb25lIHdpdGggb3Igd2l0
aG91dCB0aGlzIHBhdGNoc2V0LCBiZWZvcmUKdGhpcyBwYXRjaHNldCwgbmV3IHN5bmMgdGhyZWFk
IGNhbiBzdGlsbCBzdGFydCBhZnRlciB0aGUgbXV0ZXggaXMKcmVsZWFzZWQuCgpVc2VyIHNob3Vk
ICJlY2hvIGZvcnplbiIgaW5zdGVhZCBvZiAiZWNobyBpZGxlIiBpZiB0aGV5IHJlYWxseSB3aGF0
IHRvCmF2b2lkIG5ldyBzeW5jX3RocmVhZCB0byBzdGFydC4KClRoYW5rcywKS3VhaQo+IAo+IFJl
Z2FyZHMKPiBYaWFvCj4+Cj4+IFJlZ2FyZHMKPj4gWGlhbwo+Pgo+Pj4KPj4+IFRoYW5rcywKPj4+
IEt1YWkKPj4+Cj4+PiAtLQo+Pj4gZG0tZGV2ZWwgbWFpbGluZyBsaXN0Cj4+PiBkbS1kZXZlbEBy
ZWRoYXQuY29tCj4+PiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

